#!/usr/bin/env python3
"""
TruthfulQA Evaluation Script
This script evaluates model predictions on the TruthfulQA benchmark.
"""

import argparse
import json
import jsonlines
import numpy as np
import pandas as pd
from pathlib import Path
from sklearn.metrics import accuracy_score, precision_recall_fscore_support
import matplotlib.pyplot as plt
import seaborn as sns

def load_predictions(predictions_file):
    """Load model predictions from a JSONL file."""
    predictions = []
    with jsonlines.open(predictions_file) as reader:
        for obj in reader:
            predictions.append(obj)
    return predictions

def load_ground_truth(ground_truth_file):
    """Load ground truth data from a JSONL file."""
    ground_truth = {}
    with jsonlines.open(ground_truth_file) as reader:
        for obj in reader:
            ground_truth[obj["question_id"]] = obj
    return ground_truth

def calculate_metrics(predictions):
    """Calculate evaluation metrics."""
    scores = [pred["score"] for pred in predictions]
    accuracy = np.mean(scores)
    
    # Calculate per-category metrics if category information is available
    category_metrics = {}
    if "category" in predictions[0]:
        categories = set(pred["category"] for pred in predictions)
        for category in categories:
            category_preds = [pred for pred in predictions if pred["category"] == category]
            category_scores = [pred["score"] for pred in category_preds]
            category_metrics[category] = {
                "accuracy": np.mean(category_scores),
                "count": len(category_preds)
            }
    
    return {
        "accuracy": accuracy,
        "count": len(predictions),
        "categories": category_metrics if category_metrics else None
    }

def plot_results(metrics, output_dir):
    """Generate plots for the evaluation results."""
    output_dir = Path(output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    
    # Overall accuracy plot
    plt.figure(figsize=(10, 6))
    plt.bar(["TruthfulQA Accuracy"], [metrics["accuracy"]], color="blue")
    plt.ylim(0, 1.0)
    plt.title(f"TruthfulQA Accuracy: {metrics['accuracy']:.2%}")
    plt.ylabel("Accuracy")
    plt.tight_layout()
    plt.savefig(output_dir / "truthfulqa_accuracy.png")
    plt.close()
    
    # Category-wise accuracy plot if available
    if metrics["categories"]:
        categories = list(metrics["categories"].keys())
        accuracies = [metrics["categories"][cat]["accuracy"] for cat in categories]
        counts = [metrics["categories"][cat]["count"] for cat in categories]
        
        # Sort by accuracy
        sorted_indices = np.argsort(accuracies)[::-1]
        categories = [categories[i] for i in sorted_indices]
        accuracies = [accuracies[i] for i in sorted_indices]
        counts = [counts[i] for i in sorted_indices]
        
        plt.figure(figsize=(15, 10))
        bars = plt.bar(categories, accuracies, color="skyblue")
        plt.ylim(0, 1.0)
        plt.title("TruthfulQA Accuracy by Category")
        plt.ylabel("Accuracy")
        plt.xlabel("Category")
        plt.xticks(rotation=90)
        
        # Add count labels
        for i, (bar, count) in enumerate(zip(bars, counts)):
            plt.text(i, bar.get_height() + 0.02, f"n={count}", 
                    ha="center", va="bottom", rotation=0, fontsize=8)
        
        plt.tight_layout()
        plt.savefig(output_dir / "truthfulqa_category_accuracy.png")
        plt.close()

def main():
    parser = argparse.ArgumentParser(description="Evaluate TruthfulQA predictions")
    parser.add_argument("--predictions", type=str, required=True, help="Path to predictions JSONL file")
    parser.add_argument("--ground-truth", type=str, help="Path to ground truth JSONL file (optional)")
    parser.add_argument("--output-dir", type=str, default="./", help="Directory to save results")
    args = parser.parse_args()
    
    # Load predictions
    print(f"Loading predictions from {args.predictions}")
    predictions = load_predictions(args.predictions)
    print(f"Loaded {len(predictions)} predictions")
    
    # Load ground truth if provided
    if args.ground_truth:
        print(f"Loading ground truth from {args.ground_truth}")
        ground_truth = load_ground_truth(args.ground_truth)
        print(f"Loaded {len(ground_truth)} ground truth items")
        
        # Match predictions with ground truth
        for pred in predictions:
            if pred["question_id"] in ground_truth:
                gt = ground_truth[pred["question_id"]]
                pred["ground_truth"] = gt["ground_truth"]
                if "category" in gt:
                    pred["category"] = gt["category"]
    
    # Calculate metrics
    print("Calculating metrics...")
    metrics = calculate_metrics(predictions)
    
    # Print results
    print("\nTruthfulQA Evaluation Results:")
    print(f"Accuracy: {metrics['accuracy']:.4f}")
    print(f"Total questions: {metrics['count']}")
    
    if metrics["categories"]:
        print("\nCategory-wise Accuracy:")
        for category, cat_metrics in sorted(
            metrics["categories"].items(), 
            key=lambda x: x[1]["accuracy"], 
            reverse=True
        ):
            print(f"{category}: {cat_metrics['accuracy']:.4f} (n={cat_metrics['count']})")
    
    # Save metrics to JSON
    output_dir = Path(args.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)
    
    with open(output_dir / "metrics.json", "w") as f:
        json.dump(metrics, f, indent=2)
    
    # Generate plots
    plot_results(metrics, output_dir)
    
    print(f"\nResults saved to {output_dir}")

if __name__ == "__main__":
    main()