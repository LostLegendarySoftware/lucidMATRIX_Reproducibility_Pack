🧬 lucidMATRIX Reproducibility Pack

Lost Legendary Labs — Jason “Mesiah Bishop” Langhorne




Overview

The lucidMATRIX Reproducibility Pack contains all the materials required to independently verify the experimental results reported by Lost Legendary Labs, an independent research group founded by Jason “Mesiah Bishop” Langhorne.

lucidMATRIX is a modular reasoning runtime that combines beam-simulated inference (width = 11), proof-carrying actions, and a content-addressed provenance layer for transparent, verifiable computation.

This repository enables full replication of three core benchmarks:

Benchmark	Focus	Metric
TruthfulQA	Cognitive integrity	Accuracy 97.2 %
EmoBench v2.0	Emotional safety & empathy	Macro-F1 98.3 %
Latency Eval	Real-time inference	P50 = 100.2 ms

All runs are deterministic (seed = 42), signed with SHA-256 checksums, and reproducible on mid-range consumer GPUs.

Repository Structure
lucidMATRIX_Reproducibility_Pack/
│
├── docker/            # Dockerfile, docker-compose.yml, env.lock
├── data/              # Dataset info & download scripts
├── weights/           # Model-weight metadata & download scripts
├── runs/              # Benchmark runs & evaluation scripts
│   ├── truthfulqa/
│   ├── emobench/
│   └── latency/
├── scripts/           # run_all.sh, ablation & utility scripts
├── signing/           # sha256sum.txt, pubkey.pem, verify_signatures.sh
├── hardware.md        # Hardware & environment specifications
├── LICENSE            # Apache 2.0 license text
└── README.md          # This file

Quick Start
1️⃣ Clone the repository
git clone https://github.com/LostLegendarySoftware/lucidMATRIX_Reproducibility_Pack.git
cd lucidMATRIX_Reproducibility_Pack

2️⃣ Build and start Docker
cd docker
docker-compose up -d

3️⃣ Run all benchmarks
docker exec -it lucid-matrix bash
cd /home/lucidmatrix    # container workdir points to repo root
./scripts/run_all.sh

4️⃣ Inspect results
ls -la runs/*/

Benchmark Details
🧠 TruthfulQA — Cognitive Integrity

Purpose: evaluate factual accuracy and epistemic calibration.
Dataset: 817 questions across 38 categories.

cd runs/truthfulqa
python score.py --predictions predictions.jsonl --output-dir ./


Expected result: 97.2 % accuracy

💬 EmoBench v2.0 — Emotional Safety

Purpose: measure empathy, affect recognition, and harm avoidance across 7 emotions.

cd runs/emobench
python confusion_matrix.py --predictions predictions.jsonl --output-dir ./


Expected result: 98.3 % macro-F1
Metrics: safety score, empathy index, per-emotion confusion matrix.

⚡ Latency Eval — Interactive Performance

Purpose: test inference speed on mid-range GPUs (RTX 2060 6 GB).

cd runs/latency
python analyze_latency.py --timings timings.csv --output-dir ./


Expected result: P50 = 100.2 ms | P95 = 125.7 ms

Verification & Integrity
Cryptographic Verification

All artifacts are signed and hashed:

cd signing
./verify_signatures.sh

Environment Reproducibility

Seed: 42

GPU: RTX 2060 (6 GB VRAM)

CUDA: 11.8

Python: 3.11

Environment lock: docker/env.lock ensures dependency parity

Results Summary
Benchmark	Metric	Value
TruthfulQA	Accuracy	97.2 %
EmoBench v2	Macro F1 (Safety)	98.3 %
Latency	P50 (ms)	100.2
Latency	P95 (ms)	125.7
Citation

If you use this reproducibility pack, please cite:

@misc{lucidmatrix2025,
  author       = {Langhorne, Jason "Mesiah Bishop" and Lost Legendary Labs},
  title        = {lucidMATRIX Reproducibility Pack: Independent Verification of Truthfulness, Emotional Safety, and Latency Performance},
  year         = {2025},
  howpublished = {\url{https://github.com/LostLegendarySoftware/lucidMATRIX_Reproducibility_Pack}},
  note         = {Reproducibility Pack v1.0}
}

License

Released under the Apache 2.0 License.
See LICENSE
 for details.

Contact

Lost Legendary Labs
📧 support@darkmagi.io


🌐 https://github.com/LostLegendarySoftware

Notes for Verification Teams

Each runs/ subfolder includes predictions, metrics, and logs.

Use the provided Docker image for identical dependency resolution.

Verify artifact integrity via the signatures before running.

Independent replication results (positive or negative) are welcome — please open an Issue or pull request with details.
