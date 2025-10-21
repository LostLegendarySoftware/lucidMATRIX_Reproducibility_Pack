#!/usr/bin/env python3
"""
Latency Analysis Script
This script analyzes latency measurements for the Lucid Matrix system.
"""

import argparse
import json
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from pathlib import Path

def load_timings(timings_file):
    """Load timing data from CSV file."""
    df = pd.read_csv(timings_file)
    return df

def calculate_percentiles(df):
    """Calculate latency percentiles."""
    percentiles = {
        "p50": np.percentile(df["total_time_ms"], 50),
        "p90": np.percentile(df["total_time_ms"], 90),
        "p95": np.percentile(df["total_time_ms"], 95),
        "p99": np.percentile(df["total_time_ms"], 99),
        "min": df["total_time_ms"].min(),
        "max": df["total_time_ms"].max(),
        "mean": df["total_time_ms"].mean(),
        "std": df["total_time_ms"].std()
    }
    return percentiles

def analyze_components(df):
    """Analyze time spent in different components."""
    components = ["parsing_time_ms", "reasoning_time_ms", "generation_time_ms", "post_processing_time_ms"]
    component_stats = {}
    
    for component in components:
        component_stats[component] = {
            "mean": df[component].mean(),
            "percentage": (df[component].sum() / df["total_time_ms"].sum()) * 100
        }
    
    return component_stats

def analyze_cache_impact(df):
    """Analyze impact of cache hits on latency."""
    cache_stats = {
        "cache_hit": {
            "count": df[df["cache_hit"] == True].shape[0],
            "mean": df[df["cache_hit"] == True]["total_time_ms"].mean(),
            "p50": np.percentile(df[df["cache_hit"] == True]["total_time_ms"], 50),
            "p95": np.percentile(df[df["cache_hit"] == True]["total_time_ms"], 95)
        },
        "cache_miss": {
            "count": df[df["cache_hit"] == False].shape[0],
            "mean": df[df["cache_hit"] == False]["total_time_ms"].mean(),
            "p50": np.percentile(df[df["cache_hit"] == False]["total_time_ms"], 50),
            "p95": np.percentile(df[df["cache_hit"] == False]["total_time_ms"], 95)
        }
    }
    
    cache_stats["improvement"] = {
        "mean_reduction": cache_stats["cache_miss"]["mean"] - cache_stats["cache_hit"]["mean"],
        "mean_reduction_percent": ((cache_stats["cache_miss"]["mean"] - cache_stats["cache_hit"]["mean"]) / cache_stats["cache_miss"]["mean"]) * 100,
        "p50_reduction": cache_stats["cache_miss"]["p50"] - cache_stats["cache_hit"]["p50"],
        "p50_reduction_percent": ((cache_stats["cache_miss"]["p50"] - cache_stats["cache_hit"]["p50"]) / cache_stats["cache_miss"]["p50"]) * 100
    }
    
    return cache_stats

def analyze_prompt_length_impact(df):
    """Analyze impact of prompt length on latency."""
    # Group by prompt length
    prompt_length_groups = df.groupby("prompt_length")["total_time_ms"].agg(["mean", "count"]).reset_index()
    
    # Calculate correlation
    correlation = df["prompt_length"].corr(df["total_time_ms"])
    
    return {
        "prompt_length_groups": prompt_length_groups.to_dict("records"),
        "correlation": correlation
    }

def plot_latency_distribution(df, output_dir):
    """Plot latency distribution."""
    plt.figure(figsize=(10, 6))
    sns.histplot(df["total_time_ms"], kde=True, bins=20)
    plt.axvline(x=np.percentile(df["total_time_ms"], 50), color='r', linestyle='--', label=f'P50: {np.percentile(df["total_time_ms"], 50):.1f}ms')
    plt.axvline(x=np.percentile(df["total_time_ms"], 95), color='g', linestyle='--', label=f'P95: {np.percentile(df["total_time_ms"], 95):.1f}ms')
    plt.axvline(x=np.percentile(df["total_time_ms"], 99), color='b', linestyle='--', label=f'P99: {np.percentile(df["total_time_ms"], 99):.1f}ms')
    plt.title("Latency Distribution")
    plt.xlabel("Latency (ms)")
    plt.ylabel("Count")
    plt.legend()
    plt.tight_layout()
    plt.savefig(output_dir / "latency_distribution.png")
    plt.close()

def plot_component_breakdown(df, output_dir):
    """Plot component breakdown."""
    components = ["parsing_time_ms", "reasoning_time_ms", "generation_time_ms", "post_processing_time_ms"]
    component_means = [df[component].mean() for component in components]
    component_labels = ["Parsing", "Reasoning", "Generation", "Post-processing"]
    
    plt.figure(figsize=(10, 6))
    plt.bar(component_labels, component_means)
    plt.title("Latency Component Breakdown")
    plt.xlabel("Component")
    plt.ylabel("Average Time (ms)")
    plt.tight_layout()
    plt.savefig(output_dir / "component_breakdown.png")
    plt.close()
    
    # Pie chart
    plt.figure(figsize=(10, 6))
    plt.pie(component_means, labels=component_labels, autopct='%1.1f%%')
    plt.title("Latency Component Distribution")
    plt.tight_layout()
    plt.savefig(output_dir / "component_distribution.png")
    plt.close()

def plot_cache_comparison(df, output_dir):
    """Plot cache hit vs miss comparison."""
    cache_hit = df[df["cache_hit"] == True]["total_time_ms"]
    cache_miss = df[df["cache_hit"] == False]["total_time_ms"]
    
    plt.figure(figsize=(10, 6))
    sns.boxplot(x=df["cache_hit"].map({True: "Cache Hit", False: "Cache Miss"}), y=df["total_time_ms"])
    plt.title("Latency: Cache Hit vs Miss")
    plt.xlabel("")
    plt.ylabel("Latency (ms)")
    plt.tight_layout()
    plt.savefig(output_dir / "cache_comparison.png")
    plt.close()

def plot_prompt_length_impact(df, output_dir):
    """Plot impact of prompt length on latency."""
    plt.figure(figsize=(10, 6))
    sns.scatterplot(x="prompt_length", y="total_time_ms", hue="cache_hit", data=df)
    plt.title("Latency vs Prompt Length")
    plt.xlabel("Prompt Length (chars)")
    plt.ylabel("Latency (ms)")
    plt.tight_layout()
    plt.savefig(output_dir / "prompt_length_impact.png")
    plt.close()

def main():
    parser = argparse.ArgumentParser(description="Analyze latency measurements")
    parser.add_argument("--timings", type=str, required=True, help="Path to timings CSV file")
    parser.add_argument("--output-dir", type=str, default="./", help="Directory to save results")
    args = parser.parse_args()
    
    # Load timings
    print(f"Loading timings from {args.timings}")
    df = load_timings(args.timings)
    print(f"Loaded {len(df)} timing measurements")
    
    # Calculate percentiles
    print("Calculating percentiles...")
    percentiles = calculate_percentiles(df)
    
    # Analyze components
    print("Analyzing components...")
    component_stats = analyze_components(df)
    
    # Analyze cache impact
    print("Analyzing cache impact...")
    cache_stats = analyze_cache_impact(df)
    
    # Analyze prompt length impact
    print("Analyzing prompt length impact...")
    prompt_length_stats = analyze_prompt_length_impact(df)
    
    # Create output directory
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # Generate plots
    print("Generating plots...")
    plot_latency_distribution(df, output_dir)
    plot_component_breakdown(df, output_dir)
    plot_cache_comparison(df, output_dir)
    plot_prompt_length_impact(df, output_dir)
    
    # Compile metrics
    metrics = {
        "percentiles": percentiles,
        "component_stats": component_stats,
        "cache_stats": cache_stats,
        "prompt_length_stats": {
            "correlation": prompt_length_stats["correlation"]
        }
    }
    
    # Save metrics to JSON
    with open(output_dir / "latency_metrics.json", "w") as f:
        json.dump(metrics, f, indent=2)
    
    # Print summary
    print("\nLatency Analysis Results:")
    print(f"P50 latency: {percentiles['p50']:.2f}ms")
    print(f"P95 latency: {percentiles['p95']:.2f}ms")
    print(f"P99 latency: {percentiles['p99']:.2f}ms")
    print(f"Mean latency: {percentiles['mean']:.2f}ms")
    
    print("\nComponent Breakdown:")
    for component, stats in component_stats.items():
        print(f"{component}: {stats['mean']:.2f}ms ({stats['percentage']:.1f}%)")
    
    print("\nCache Impact:")
    print(f"Cache hit mean: {cache_stats['cache_hit']['mean']:.2f}ms")
    print(f"Cache miss mean: {cache_stats['cache_miss']['mean']:.2f}ms")
    print(f"Mean reduction: {cache_stats['improvement']['mean_reduction']:.2f}ms ({cache_stats['improvement']['mean_reduction_percent']:.1f}%)")
    
    print(f"\nResults saved to {output_dir}")

if __name__ == "__main__":
    main()