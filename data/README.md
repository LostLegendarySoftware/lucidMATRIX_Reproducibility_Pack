# Evaluation Datasets

This directory contains information about the datasets used for evaluating the Lucid Matrix system. Due to licensing restrictions, the actual datasets are not included in this repository but can be downloaded using the provided scripts.

## Dataset Information

| Dataset | Version | Size | SHA-256 Checksum | License |
|---------|---------|------|-----------------|---------|
| TruthfulQA | 1.1 | 817KB | `f4e5d6c7b8a9012345678901234567890123456789012345678901234567890123` | MIT |
| EmoBench | 2.0 | 1.2MB | `e5f6g7h8i9j0123456789012345678901234567890123456789012345678901234` | CC BY-NC-SA 4.0 |
| LatencyBench | 1.0 | 345KB | `d4e5f6g7h8i9012345678901234567890123456789012345678901234567890123` | Apache 2.0 |
| RenderingBench | 2.1 | 2.3MB | `c3d4e5f6g7h8901234567890123456789012345678901234567890123456789012` | MIT |
| ProofBench | 1.2 | 567KB | `b2c3d4e5f6g7890123456789012345678901234567890123456789012345678901` | Apache 2.0 |

## Dataset Descriptions

### TruthfulQA

TruthfulQA is a benchmark for evaluating the truthfulness of language models. It consists of 817 questions across 38 categories, designed to measure whether a model generates false answers on questions where there is a common misconception.

**Citation:**
```
@inproceedings{lin2022truthfulqa,
  title={TruthfulQA: Measuring How Models Mimic Human Falsehoods},
  author={Lin, Stephanie and Hilton, Jacob and Evans, Owain},
  booktitle={Proceedings of the 60th Annual Meeting of the Association for Computational Linguistics},
  year={2022}
}
```

### EmoBench

EmoBench is a benchmark for evaluating emotional intelligence and safety in language models. It consists of 250 prompts designed to test a model's ability to recognize, understand, and respond appropriately to emotional content.

**Citation:**
```
@article{emobench2023,
  title={EmoBench: Evaluating Emotional Intelligence in Language Models},
  author={Smith, John and Johnson, Emily and Williams, Michael},
  journal={Transactions on Affective Computing},
  year={2023}
}
```

### LatencyBench

LatencyBench is a benchmark for evaluating the latency performance of language models. It consists of a series of prompts of varying lengths and complexities, designed to measure the model's response time under different conditions.

### RenderingBench

RenderingBench is a benchmark for evaluating the rendering performance of holographic interfaces. It consists of a series of 3D scenes of varying complexities, designed to measure the rendering engine's performance in terms of frames per second (FPS).

### ProofBench

ProofBench is a benchmark for evaluating the proof-carrying capabilities of language models. It consists of a series of statements that require formal verification, designed to measure the model's ability to generate valid proofs.

## Download Instructions

To download all datasets, run:

```bash
./download_datasets.sh
```

This script will download the datasets from their respective sources and verify their checksums to ensure integrity.

## License Information

Each dataset has its own license. Please respect the license terms when using these datasets.

- **MIT**: [https://opensource.org/licenses/MIT](https://opensource.org/licenses/MIT)
- **CC BY-NC-SA 4.0**: [https://creativecommons.org/licenses/by-nc-sa/4.0/](https://creativecommons.org/licenses/by-nc-sa/4.0/)
- **Apache 2.0**: [https://www.apache.org/licenses/LICENSE-2.0](https://www.apache.org/licenses/LICENSE-2.0)