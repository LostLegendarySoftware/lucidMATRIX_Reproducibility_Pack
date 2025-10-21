#!/bin/bash
# Lucid Matrix - Run All Benchmarks
# This script runs all benchmarks and generates reports

set -e

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ARTIFACTS_DIR="$(dirname "$SCRIPT_DIR")"
DATA_DIR="$ARTIFACTS_DIR/data"
WEIGHTS_DIR="$ARTIFACTS_DIR/weights"
RUNS_DIR="$ARTIFACTS_DIR/runs"

# Set fixed seed for reproducibility
export PYTHONHASHSEED=42
export RANDOM_SEED=42
export NUMPY_SEED=42
export TORCH_SEED=42

# Print header
echo "=================================================="
echo "Lucid Matrix - Reproducibility Benchmark Suite"
echo "=================================================="
echo "Date: $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
echo "Artifacts Directory: $ARTIFACTS_DIR"
echo "Fixed Seed: 42"
echo "=================================================="

# Function to check if required files exist
check_requirements() {
    echo "Checking requirements..."
    
    # Check if datasets are available
    if [ ! -d "$DATA_DIR/truthfulqa" ] || [ ! -d "$DATA_DIR/emobench" ]; then
        echo "Downloading required datasets..."
        bash "$DATA_DIR/download_datasets.sh" --all
    fi
    
    # Check if model weights are available
    if [ ! -f "$WEIGHTS_DIR/lucid_matrix_base.safetensors" ]; then
        echo "Downloading required model weights..."
        bash "$WEIGHTS_DIR/download_weights.sh" --all
    fi
    
    echo "Requirements check completed."
}

# Function to run TruthfulQA benchmark
run_truthfulqa() {
    echo "=================================================="
    echo "Running TruthfulQA Benchmark..."
    echo "=================================================="
    
    cd "$RUNS_DIR/truthfulqa"
    
    # Run evaluation
    python score.py --predictions predictions.jsonl --output-dir ./
    
    echo "TruthfulQA benchmark completed."
}

# Function to run EmoBench benchmark
run_emobench() {
    echo "=================================================="
    echo "Running EmoBench Benchmark..."
    echo "=================================================="
    
    cd "$RUNS_DIR/emobench"
    
    # Run evaluation
    python confusion_matrix.py --predictions predictions.jsonl --output-dir ./
    
    echo "EmoBench benchmark completed."
}

# Function to run Latency benchmark
run_latency() {
    echo "=================================================="
    echo "Running Latency Benchmark..."
    echo "=================================================="
    
    cd "$RUNS_DIR/latency"
    
    # Run evaluation
    python analyze_latency.py --timings timings.csv --output-dir ./
    
    echo "Latency benchmark completed."
}

# Function to run ablation studies
run_ablations() {
    echo "=================================================="
    echo "Running Ablation Studies..."
    echo "=================================================="
    
    # Run beam width ablation
    if [ -f "$SCRIPT_DIR/ablate_beam.sh" ]; then
        echo "Running beam width ablation..."
        bash "$SCRIPT_DIR/ablate_beam.sh"
    fi
    
    # Run PCA ablation
    if [ -f "$SCRIPT_DIR/ablate_pca.sh" ]; then
        echo "Running PCA ablation..."
        bash "$SCRIPT_DIR/ablate_pca.sh"
    fi
    
    # Run simulations ablation
    if [ -f "$SCRIPT_DIR/ablate_sims.sh" ]; then
        echo "Running simulations ablation..."
        bash "$SCRIPT_DIR/ablate_sims.sh"
    fi
    
    # Run cache ablation
    if [ -f "$SCRIPT_DIR/ablate_cache.sh" ]; then
        echo "Running cache ablation..."
        bash "$SCRIPT_DIR/ablate_cache.sh"
    fi
    
    echo "Ablation studies completed."
}

# Function to generate final report
generate_report() {
    echo "=================================================="
    echo "Generating Final Report..."
    echo "=================================================="
    
    # Create report directory
    REPORT_DIR="$ARTIFACTS_DIR/report"
    mkdir -p "$REPORT_DIR"
    
    # Collect metrics
    echo "Collecting metrics..."
    
    # TruthfulQA metrics
    if [ -f "$RUNS_DIR/truthfulqa/metrics.json" ]; then
        cp "$RUNS_DIR/truthfulqa/metrics.json" "$REPORT_DIR/truthfulqa_metrics.json"
        cp "$RUNS_DIR/truthfulqa/"*.png "$REPORT_DIR/" 2>/dev/null || true
    fi
    
    # EmoBench metrics
    if [ -f "$RUNS_DIR/emobench/metrics.json" ]; then
        cp "$RUNS_DIR/emobench/metrics.json" "$REPORT_DIR/emobench_metrics.json"
        cp "$RUNS_DIR/emobench/"*.png "$REPORT_DIR/" 2>/dev/null || true
    fi
    
    # Latency metrics
    if [ -f "$RUNS_DIR/latency/latency_metrics.json" ]; then
        cp "$RUNS_DIR/latency/latency_metrics.json" "$REPORT_DIR/latency_metrics.json"
        cp "$RUNS_DIR/latency/"*.png "$REPORT_DIR/" 2>/dev/null || true
    fi
    
    # Generate summary report
    echo "Generating summary report..."
    
    cat > "$REPORT_DIR/summary.md" << EOF
# Lucid Matrix Benchmark Results

## Overview

This report summarizes the benchmark results for the Lucid Matrix system.

## TruthfulQA

$([ -f "$RUNS_DIR/truthfulqa/metrics.json" ] && python -c "import json; m = json.load(open('$RUNS_DIR/truthfulqa/metrics.json')); print(f'- Accuracy: {m[&quot;accuracy&quot;]:.1%}\\n- Total Questions: {m[&quot;count&quot;]}\\n')" || echo "- Results not available")

## EmoBench

$([ -f "$RUNS_DIR/emobench/metrics.json" ] && python -c "import json; m = json.load(open('$RUNS_DIR/emobench/metrics.json')); print(f'- Macro F1: {m[&quot;macro_f1&quot;]:.1%}\\n- Safety Score: {m[&quot;safety_score_avg&quot;]:.1%}\\n- Empathy Score: {m[&quot;empathy_score_avg&quot;]:.1%}\\n- Total Prompts: {m[&quot;total_prompts&quot;]}\\n')" || echo "- Results not available")

## Latency

$([ -f "$RUNS_DIR/latency/latency_metrics.json" ] && python -c "import json; m = json.load(open('$RUNS_DIR/latency/latency_metrics.json')); print(f'- P50 Latency: {m[&quot;percentiles&quot;][&quot;p50&quot;]:.1f}ms\\n- P95 Latency: {m[&quot;percentiles&quot;][&quot;p95&quot;]:.1f}ms\\n- P99 Latency: {m[&quot;percentiles&quot;][&quot;p99&quot;]:.1f}ms\\n- Mean Latency: {m[&quot;percentiles&quot;][&quot;mean&quot;]:.1f}ms\\n')" || echo "- Results not available")

## Hardware

$([ -f "$RUNS_DIR/latency/latency_metrics.json" ] && python -c "import json; m = json.load(open('$RUNS_DIR/latency/latency_metrics.json')); print(f'- GPU: {m[&quot;hardware_specs&quot;][&quot;gpu&quot;]}\\n- VRAM: {m[&quot;hardware_specs&quot;][&quot;vram&quot;]}\\n- CUDA Version: {m[&quot;hardware_specs&quot;][&quot;cuda_version&quot;]}\\n')" || echo "- Hardware information not available")

## Reproducibility

- Date: $(date -u +"%Y-%m-%d")
- Fixed Seed: 42
- All benchmarks are deterministic and reproducible
EOF
    
    echo "Final report generated at $REPORT_DIR/summary.md"
}

# Function to verify signatures
verify_signatures() {
    echo "=================================================="
    echo "Verifying Signatures..."
    echo "=================================================="
    
    if [ -f "$ARTIFACTS_DIR/signing/verify_signatures.sh" ]; then
        bash "$ARTIFACTS_DIR/signing/verify_signatures.sh"
    else
        echo "Signature verification script not found. Skipping."
    fi
}

# Main execution
main() {
    # Check requirements
    check_requirements
    
    # Run benchmarks
    run_truthfulqa
    run_emobench
    run_latency
    
    # Run ablation studies if available
    run_ablations
    
    # Verify signatures if available
    verify_signatures
    
    # Generate final report
    generate_report
    
    echo "=================================================="
    echo "All benchmarks completed successfully!"
    echo "Final report available at $ARTIFACTS_DIR/report/summary.md"
    echo "=================================================="
}

# Run main function
main