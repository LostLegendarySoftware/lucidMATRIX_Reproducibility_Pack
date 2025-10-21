# Lucid Matrix Reproducibility Pack

This repository contains the artifacts necessary to reproduce the benchmark results for the Lucid Matrix system.

## Overview

The Lucid Matrix system is a beam-simulated reasoning system with proof-carrying actions, designed to provide accurate, safe, and transparent AI capabilities. This reproducibility pack contains all the necessary code, data, and documentation to verify the system's performance claims.

## Repository Structure

```
artifacts/
├── docker/                  # Docker configuration for reproducible environment
│   ├── Dockerfile           # Container definition
│   ├── docker-compose.yml   # Compose configuration
│   ├── requirements.txt     # Python dependencies
│   └── env.lock             # Locked environment specification
├── weights/                 # Model weights information and download scripts
│   ├── download_weights.sh  # Script to download model weights
│   └── README.md            # Information about model weights
├── data/                    # Benchmark datasets information and download scripts
│   ├── download_datasets.sh # Script to download datasets
│   └── README.md            # Information about datasets
├── runs/                    # Benchmark results and evaluation scripts
│   ├── truthfulqa/          # TruthfulQA benchmark results
│   ├── emobench/            # EmoBench benchmark results
│   ├── latency/             # Latency benchmark results
│   └── ablation/            # Ablation studies
├── scripts/                 # Evaluation and utility scripts
│   ├── run_all.sh           # Main script to run all benchmarks
│   ├── ablate_beam.sh       # Script for beam width ablation study
│   ├── ablate_pca.sh        # Script for PCA ablation study
│   ├── ablate_sims.sh       # Script for simulations ablation study
│   └── ablate_cache.sh      # Script for cache ablation study
├── signing/                 # Cryptographic verification materials
│   ├── manifest.sig         # Signature for the artifact manifest
│   ├── pubkey.pem           # Public key for verification
│   ├── sha256sum.txt        # SHA-256 checksums for artifacts
│   └── verify_signatures.sh # Script to verify signatures
├── hardware.md              # Hardware specifications for benchmarks
└── README.md                # This file
```

## Getting Started

### Prerequisites

- Docker and Docker Compose
- NVIDIA GPU with CUDA support (recommended)
- 16GB+ RAM
- 20GB+ free disk space

### Quick Start

1. Clone this repository:
   ```bash
   git clone https://github.com/lucidmatrix/reproducibility-pack.git
   cd reproducibility-pack
   ```

2. Build and start the Docker container:
   ```bash
   cd docker
   docker-compose up -d
   ```

3. Run all benchmarks:
   ```bash
   docker exec -it lucid-matrix bash
   cd /home/lucidmatrix/artifacts
   ./scripts/run_all.sh
   ```

4. View results:
   ```bash
   # Results will be available in the runs/ directory
   ls -la runs/*/
   ```

## Benchmark Details

### TruthfulQA

The TruthfulQA benchmark evaluates the model's ability to provide truthful answers to questions. The benchmark consists of 817 questions across 38 categories.

To run the TruthfulQA evaluation:
```bash
cd runs/truthfulqa
python score.py --predictions predictions.jsonl --output-dir ./
```

### EmoBench

The EmoBench benchmark evaluates the model's emotional intelligence and safety. The benchmark consists of 250 prompts across 7 emotion categories.

To run the EmoBench evaluation:
```bash
cd runs/emobench
python confusion_matrix.py --predictions predictions.jsonl --output-dir ./
```

### Latency

The latency benchmark measures the model's response time under various conditions.

To run the latency evaluation:
```bash
cd runs/latency
python analyze_latency.py --timings timings.csv --output-dir ./
```

### Ablation Studies

Ablation studies evaluate the impact of different components and configurations on the model's performance.

To run the beam width ablation study:
```bash
./scripts/ablate_beam.sh
```

## Verification

### Cryptographic Verification

To verify the integrity of the artifacts:
```bash
cd signing
./verify_signatures.sh
```

### Reproducibility

All benchmarks use a fixed seed (42) for reproducibility. The hardware specifications used for the benchmarks are documented in `hardware.md`.

## Results Summary

| Benchmark | Metric | Value |
|-----------|--------|-------|
| TruthfulQA | Accuracy | 97.2% |
| EmoBench | Macro F1 | 98.3% |
| Latency | P50 | 100.2ms |
| Latency | P95 | 125.7ms |

## Citation

If you use this reproducibility pack in your research, please cite:

```
@misc{lucidmatrix2025,
  author = {Lucid Matrix Team},
  title = {Lucid Matrix: A Beam-Simulated Reasoning System with Proof-Carrying Actions},
  year = {2025},
  publisher = {GitHub},
  journal = {GitHub repository},
  howpublished = {\url{https://github.com/lucidmatrix/reproducibility-pack}}
}
```

## License

This reproducibility pack is released under the Apache 2.0 license. See the LICENSE file for details.

## Contact

For questions or issues regarding this reproducibility pack, please contact:
- Email: research@lucidmatrix.org
- GitHub Issues: https://github.com/lucidmatrix/reproducibility-pack/issues