LucidMATRIX Reproducibility Pack — Lost Legendary Labs

Repository Overview
This repository provides the complete, verified reproducibility package for LucidMATRIX, an agent-reasoning system created by Lost Legendary Labs, founded by Jason “Mesiah Bishop” Langhorne.
LucidMATRIX pairs beam-simulated inference (width = 11) with proof-carrying actions and a content-addressed provenance layer to deliver transparent, verifiable reasoning.

Purpose

The goal of this repository is to enable independent replication and validation of the system’s reported benchmark results:

Truthful QA – Factual integrity (97.2 %)

EmoBench v2.0 – Emotional safety and empathy (98.3 % macro-F1)

Latency Benchmark – Interactive inference speed (100.2 ms P50 on mid-range GPUs)

Each benchmark folder contains raw predictions, evaluation scripts, metrics, and cryptographic signatures for verification.

Repository Structure
lucidmatrix_reproducibility/
│
├── runs/
│   ├── truthfulqa/   →  Factual-accuracy benchmark
│   ├── emobench/     →  Emotional-safety benchmark
│   └── latency/      →  Real-time-performance benchmark
│
├── scripts/          →  Setup, ablation, and verification utilities
├── signing/          →  Hashes and signature files for artifact integrity
├── hardware.md       →  Hardware and environment specifications
├── LICENSE           →  Apache 2.0 license text
└── README.md         →  Execution and verification guide

Key Features

Self-contained reproducibility – All data, configs, and evaluation scripts included

Fixed seed (42) – Deterministic runs across hardware

Cryptographic verification – Signed hashes ensure artifact integrity

Docker / conda environments – Pinned dependencies for consistent execution

Ablation scripts – Analyze beam width, caching, and proof-carrying modules

How to Reproduce

Run the benchmarks sequentially:

# TruthfulQA
cd runs/truthfulqa
python score.py --predictions predictions.jsonl --output-dir ./

# EmoBench
cd runs/emobench
python confusion_matrix.py --predictions predictions.jsonl --output-dir ./

# Latency
cd runs/latency
python analyze_latency.py --timings timings.csv --output-dir ./

Verification

Confirm file integrity before reproducing results:

cd signing
./verify_signatures.sh


All artifacts are signed and logged in hashes.txt. Hardware specs and environment details are documented in hardware.md.

Citation
@misc{lucidmatrix2025,
  author       = {Langhorne, Jason "Mesiah Bishop" and the Lost Legendary Labs Team},
  title        = {LucidMATRIX: A Beam-Simulated Reasoning System with Proof-Carrying Actions},
  year         = {2025},
  publisher    = {Lost Legendary Labs},
  howpublished = {\url{[(https://github.com/LostLegendarySoftware/lucidMATRIX_Reproducibility_Pack)}},
  note         = {Reproducibility Pack v1.0}
}

License & Contact

Licensed under Apache 2.0.
For replication support or research inquiries:

support@Darkmagi.io

For head researcher/CEO:

Mesiah@darkmagi.io

Architecture will be in the future hosted at domain:

https://machinegod.live
