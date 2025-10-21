#!/bin/bash
# Lucid Matrix - Model Weights Downloader
# This script downloads model weights and verifies their checksums

set -e

# Configuration
DOWNLOAD_SERVER="https://weights.lucidmatrix.org"
WEIGHTS_DIR="$(pwd)"
LOG_FILE="${WEIGHTS_DIR}/download.log"

# Model information
declare -A MODEL_SIZES
MODEL_SIZES["lucid_matrix_base"]="7.2GB"
MODEL_SIZES["beam_reasoning_engine"]="2.1GB"
MODEL_SIZES["emotion_safety_gate"]="1.5GB"
MODEL_SIZES["holographic_renderer"]="3.8GB"
MODEL_SIZES["proof_carrying_module"]="0.9GB"

declare -A MODEL_CHECKSUMS
MODEL_CHECKSUMS["lucid_matrix_base"]="e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
MODEL_CHECKSUMS["beam_reasoning_engine"]="a1b2c3d4e5f6789012345678901234567890123456789012345678901234567890"
MODEL_CHECKSUMS["emotion_safety_gate"]="b2c3d4e5f6789012345678901234567890123456789012345678901234567890a1"
MODEL_CHECKSUMS["holographic_renderer"]="c3d4e5f6789012345678901234567890123456789012345678901234567890a1b2"
MODEL_CHECKSUMS["proof_carrying_module"]="d4e5f6789012345678901234567890123456789012345678901234567890a1b2c3"

# Function to download a model
download_model() {
    local model_name=$1
    local model_file="${model_name}.safetensors"
    local model_url="${DOWNLOAD_SERVER}/${model_file}"
    local expected_checksum=${MODEL_CHECKSUMS[$model_name]}
    local model_size=${MODEL_SIZES[$model_name]}
    
    echo "Downloading ${model_name} (${model_size})..."
    
    # Check if file already exists
    if [ -f "${WEIGHTS_DIR}/${model_file}" ]; then
        echo "File already exists. Verifying checksum..."
        local actual_checksum=$(sha256sum "${WEIGHTS_DIR}/${model_file}" | awk '{print $1}')
        
        if [ "$actual_checksum" == "$expected_checksum" ]; then
            echo "✅ Checksum verified for ${model_name}"
            return 0
        else
            echo "❌ Checksum verification failed for ${model_name}"
            echo "Expected: ${expected_checksum}"
            echo "Actual: ${actual_checksum}"
            echo "Re-downloading ${model_name}..."
        fi
    fi
    
    # Download with progress bar and resume capability
    wget -c --progress=bar:force:noscroll \
         --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 0 \
         -O "${WEIGHTS_DIR}/${model_file}" "${model_url}" 2>&1 | tee -a "$LOG_FILE"
    
    # Verify checksum
    echo "Verifying checksum for ${model_name}..."
    local actual_checksum=$(sha256sum "${WEIGHTS_DIR}/${model_file}" | awk '{print $1}')
    
    if [ "$actual_checksum" == "$expected_checksum" ]; then
        echo "✅ Checksum verified for ${model_name}"
    else
        echo "❌ Checksum verification failed for ${model_name}"
        echo "Expected: ${expected_checksum}"
        echo "Actual: ${actual_checksum}"
        echo "Please try downloading again."
        exit 1
    fi
}

# Function to display help
show_help() {
    echo "Lucid Matrix - Model Weights Downloader"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --model MODEL_NAME    Download specific model"
    echo "  --all                 Download all models (default)"
    echo "  --help                Show this help message"
    echo ""
    echo "Available models:"
    for model in "${!MODEL_SIZES[@]}"; do
        echo "  - ${model} (${MODEL_SIZES[$model]})"
    done
}

# Parse command line arguments
if [ $# -eq 0 ]; then
    DOWNLOAD_ALL=true
else
    while [ $# -gt 0 ]; do
        case "$1" in
            --model)
                MODEL_NAME="$2"
                shift 2
                ;;
            --all)
                DOWNLOAD_ALL=true
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
fi

# Create weights directory if it doesn't exist
mkdir -p "$WEIGHTS_DIR"

# Download models
if [ "$DOWNLOAD_ALL" = true ]; then
    echo "Downloading all models..."
    for model in "${!MODEL_SIZES[@]}"; do
        download_model "$model"
    done
else
    if [ -z "$MODEL_NAME" ]; then
        echo "Error: No model specified"
        show_help
        exit 1
    fi
    
    if [ -z "${MODEL_SIZES[$MODEL_NAME]}" ]; then
        echo "Error: Unknown model '$MODEL_NAME'"
        show_help
        exit 1
    fi
    
    download_model "$MODEL_NAME"
fi

echo "All downloads completed successfully!"