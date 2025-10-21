# Hardware Specifications

This document describes the hardware specifications used for benchmarking the Lucid Matrix system.

## Test Environment

All benchmarks were conducted on the following hardware:

| Component | Specification |
|-----------|---------------|
| CPU | Intel Core i7-10700K (8 cores, 16 threads, 3.8 GHz base, 5.1 GHz boost) |
| GPU | NVIDIA RTX 2060 (6GB GDDR6) |
| RAM | 32GB DDR4-3200 |
| Storage | 1TB NVMe SSD |
| OS | Ubuntu 22.04 LTS |
| CUDA | 11.8 |
| cuDNN | 8.6.0 |
| Python | 3.10.12 |
| PyTorch | 2.0.1+cu118 |

## Benchmark Configuration

### Cache Policy

All benchmarks were run with the following cache policy:

- **Cold Cache**: First run of each benchmark with empty cache
- **Warm Cache**: Subsequent runs with populated cache
- **Cache Invalidation**: Cache is invalidated between different benchmark types
- **Cache Size**: 1GB maximum memory usage for cache

### GPU Configuration

- **CUDA Device**: 0
- **Memory Configuration**: Default (no memory limitations)
- **Power Mode**: Unrestricted (maximum performance)
- **Driver Version**: 525.105.17

### CPU Configuration

- **Governor**: performance
- **Frequency Scaling**: Disabled (fixed at maximum frequency)
- **Hyperthreading**: Enabled
- **Power Limits**: Unrestricted (maximum performance)

## Reproducibility

To reproduce the benchmark results on similar hardware:

1. Ensure the same software versions are installed (CUDA 11.8, cuDNN 8.6.0, PyTorch 2.0.1)
2. Set the same cache policy as described above
3. Use the same GPU configuration
4. Run benchmarks with a fixed seed (42)
5. Follow the instructions in the `run_all.sh` script

## Hardware Variability

Performance may vary based on:

- Thermal conditions
- Background processes
- Driver versions
- BIOS settings
- Memory configuration
- Storage speed

For the most accurate reproduction, ensure the system is in a similar state with minimal background processes and consistent thermal conditions.

## Alternative Hardware Configurations

The Lucid Matrix system has also been tested on the following hardware configurations:

### High-End Configuration

| Component | Specification |
|-----------|---------------|
| CPU | AMD Ryzen 9 5950X (16 cores, 32 threads) |
| GPU | NVIDIA RTX 3090 (24GB GDDR6X) |
| RAM | 64GB DDR4-3600 |
| Storage | 2TB NVMe SSD |

**Performance Improvement**: Approximately 2.5x faster than the baseline configuration.

### Server Configuration

| Component | Specification |
|-----------|---------------|
| CPU | 2x Intel Xeon Gold 6330 (28 cores, 56 threads each) |
| GPU | 4x NVIDIA A100 (40GB SXM4) |
| RAM | 512GB DDR4-3200 ECC |
| Storage | 8TB NVMe SSD (RAID 0) |

**Performance Improvement**: Approximately 8x faster than the baseline configuration with multi-GPU parallelization.

### Minimum Configuration

| Component | Specification |
|-----------|---------------|
| CPU | Intel Core i5-9400F (6 cores, 6 threads) |
| GPU | NVIDIA GTX 1660 (6GB GDDR5) |
| RAM | 16GB DDR4-2666 |
| Storage | 512GB SATA SSD |

**Performance Degradation**: Approximately 1.5x slower than the baseline configuration.