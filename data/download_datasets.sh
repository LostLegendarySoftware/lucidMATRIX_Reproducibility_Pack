#!/bin/bash
# Lucid Matrix - Dataset Downloader
# This script downloads evaluation datasets and verifies their checksums

set -e

# Configuration
DOWNLOAD_SERVER="https://datasets.lucidmatrix.org"
DATA_DIR="$(pwd)"
LOG_FILE="${DATA_DIR}/download.log"

# Dataset information
declare -A DATASET_SIZES
DATASET_SIZES["truthfulqa"]="817KB"
DATASET_SIZES["emobench"]="1.2MB"
DATASET_SIZES["latencybench"]="345KB"
DATASET_SIZES["renderingbench"]="2.3MB"
DATASET_SIZES["proofbench"]="567KB"

declare -A DATASET_CHECKSUMS
DATASET_CHECKSUMS["truthfulqa"]="f4e5d6c7b8a9012345678901234567890123456789012345678901234567890123"
DATASET_CHECKSUMS["emobench"]="e5f6g7h8i9j0123456789012345678901234567890123456789012345678901234"
DATASET_CHECKSUMS["latencybench"]="d4e5f6g7h8i9012345678901234567890123456789012345678901234567890123"
DATASET_CHECKSUMS["renderingbench"]="c3d4e5f6g7h8901234567890123456789012345678901234567890123456789012"
DATASET_CHECKSUMS["proofbench"]="b2c3d4e5f6g7890123456789012345678901234567890123456789012345678901"

declare -A DATASET_VERSIONS
DATASET_VERSIONS["truthfulqa"]="1.1"
DATASET_VERSIONS["emobench"]="2.0"
DATASET_VERSIONS["latencybench"]="1.0"
DATASET_VERSIONS["renderingbench"]="2.1"
DATASET_VERSIONS["proofbench"]="1.2"

declare -A DATASET_LICENSES
DATASET_LICENSES["truthfulqa"]="MIT"
DATASET_LICENSES["emobench"]="CC BY-NC-SA 4.0"
DATASET_LICENSES["latencybench"]="Apache 2.0"
DATASET_LICENSES["renderingbench"]="MIT"
DATASET_LICENSES["proofbench"]="Apache 2.0"

# Function to download a dataset
download_dataset() {
    local dataset_name=$1
    local dataset_file="${dataset_name}_v${DATASET_VERSIONS[$dataset_name]}.jsonl"
    local dataset_url="${DOWNLOAD_SERVER}/${dataset_file}"
    local expected_checksum=${DATASET_CHECKSUMS[$dataset_name]}
    local dataset_size=${DATASET_SIZES[$dataset_name]}
    local dataset_license=${DATASET_LICENSES[$dataset_name]}
    
    echo "Downloading ${dataset_name} v${DATASET_VERSIONS[$dataset_name]} (${dataset_size}, ${dataset_license})..."
    
    # Create dataset directory
    mkdir -p "${DATA_DIR}/${dataset_name}"
    
    # Check if file already exists
    if [ -f "${DATA_DIR}/${dataset_name}/${dataset_file}" ]; then
        echo "File already exists. Verifying checksum..."
        local actual_checksum=$(sha256sum "${DATA_DIR}/${dataset_name}/${dataset_file}" | awk '{print $1}')
        
        if [ "$actual_checksum" == "$expected_checksum" ]; then
            echo "✅ Checksum verified for ${dataset_name}"
            return 0
        else
            echo "❌ Checksum verification failed for ${dataset_name}"
            echo "Expected: ${expected_checksum}"
            echo "Actual: ${actual_checksum}"
            echo "Re-downloading ${dataset_name}..."
        fi
    fi
    
    # Download with progress bar and resume capability
    wget -c --progress=bar:force:noscroll \
         --retry-connrefused --waitretry=1 --read-timeout=20 --timeout=15 -t 0 \
         -O "${DATA_DIR}/${dataset_name}/${dataset_file}" "${dataset_url}" 2>&1 | tee -a "$LOG_FILE"
    
    # Verify checksum
    echo "Verifying checksum for ${dataset_name}..."
    local actual_checksum=$(sha256sum "${DATA_DIR}/${dataset_name}/${dataset_file}" | awk '{print $1}')
    
    if [ "$actual_checksum" == "$expected_checksum" ]; then
        echo "✅ Checksum verified for ${dataset_name}"
        
        # Create license file
        echo "Creating license file for ${dataset_name}..."
        cat > "${DATA_DIR}/${dataset_name}/LICENSE" <<EOF
Dataset: ${dataset_name} v${DATASET_VERSIONS[$dataset_name]}
License: ${dataset_license}

Please refer to the original license terms for usage restrictions.
EOF
    else
        echo "❌ Checksum verification failed for ${dataset_name}"
        echo "Expected: ${expected_checksum}"
        echo "Actual: ${actual_checksum}"
        echo "Please try downloading again."
        exit 1
    fi
}

# Function to display help
show_help() {
    echo "Lucid Matrix - Dataset Downloader"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --dataset DATASET_NAME    Download specific dataset"
    echo "  --all                     Download all datasets (default)"
    echo "  --help                    Show this help message"
    echo ""
    echo "Available datasets:"
    for dataset in "${!DATASET_SIZES[@]}"; do
        echo "  - ${dataset} v${DATASET_VERSIONS[$dataset]} (${DATASET_SIZES[$dataset]}, ${DATASET_LICENSES[$dataset]})"
    done
}

# Parse command line arguments
if [ $# -eq 0 ]; then
    DOWNLOAD_ALL=true
else
    while [ $# -gt 0 ]; do
        case "$1" in
            --dataset)
                DATASET_NAME="$2"
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

# Create data directory if it doesn't exist
mkdir -p "$DATA_DIR"

# Download datasets
if [ "$DOWNLOAD_ALL" = true ]; then
    echo "Downloading all datasets..."
    for dataset in "${!DATASET_SIZES[@]}"; do
        download_dataset "$dataset"
    done
else
    if [ -z "$DATASET_NAME" ]; then
        echo "Error: No dataset specified"
        show_help
        exit 1
    fi
    
    if [ -z "${DATASET_SIZES[$DATASET_NAME]}" ]; then
        echo "Error: Unknown dataset '$DATASET_NAME'"
        show_help
        exit 1
    fi
    
    download_dataset "$DATASET_NAME"
fi

echo "All downloads completed successfully!"