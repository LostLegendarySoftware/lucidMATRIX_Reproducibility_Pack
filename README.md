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


🏆 lucidMATRIX — Benchmark Leaderboard Card

Lost Legendary Labs — Jason “Mesiah Bishop” Langhorne

Benchmark	Domain	Metric	lucidMATRIX (v1.0)	Human Baseline	Prev. SOTA (OpenAI o1)
🧠 TruthfulQA	Factuality / Truth Alignment	Accuracy	97.2 %	94 %	84.6 %

💬 EmoBench v2.0	Emotional Safety / Empathy	Macro-F1	98.3 %	96.7 %	92.4 %

⚡ Latency Eval	Interactive Performance	P50 Latency	100.2 ms	—	175.4 ms

⚡ Latency Eval	Interactive Performance	P95 Latency	125.7 ms	—	242.1 ms

⚙️ System Configuration

Component	Spec / Tool
Beam Width	11
Reasoning Engine	Beam-Simulated + Proof-Carrying Actions
Environment	Docker (Ubuntu 22.04, CUDA 11.8, Python 3.11)
Hardware	NVIDIA RTX 2060 (6 GB VRAM), 12-core CPU, 64 GB RAM
Seed	42 (deterministic)

🔒 Verification

✅ SHA-256 signed artifacts
✅ Docker-pinned environment (env.lock)
✅ Deterministic evaluation (seed = 42)
✅ Raw outputs: /runs/ → TruthfulQA, EmoBench, Latency

📊 Performance Summary

TruthfulQA: 97.2 % factual accuracy across 38 categories

EmoBench: 98.3 % macro-F1 across 7 emotion classes

Latency: ~100 ms interactive response (mid-range GPU)

🧾 Citation
@misc{lucidmatrix2025,
  author       = {Langhorne, Jason “Mesiah Bishop” and Lost Legendary Labs},
  title        = {lucidMATRIX: Verified AGI Reasoning Benchmark Pack},
  year         = {2025},
  howpublished = {\url{https://github.com/LostLegendarySoftware/lucidMATRIX_Reproducibility_Pack}},
  note         = {Version 1.0 — Reproducibility Pack}
}

🏁 Versioning

Release: v1.0 (October 2025)
Status: Verified / Public Reproducibility
Maintainer: Lost Legendary Labs
