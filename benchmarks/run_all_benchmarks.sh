#!/bin/bash
# Bullet-proof verification script
# Reproducible, signed results for university submission

set -euo pipefail

echo "🎓 UNIVERSITY-GRADE VERIFICATION"
echo "================================"

# Create results directory
mkdir -p /workspace/results
mkdir -p /workspace/benchmarks

# Environment lock
echo "Locking environment..."
{
    echo "Node: $(node --version)"
    echo "Python: $(python3 --version)"
    echo "NPM: $(npm --version)"
    echo "Git Commit: $(git rev-parse HEAD)"
    echo "Timestamp: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
} > /workspace/results/environment.lock

# Build system
echo "Building system..."
cd /workspace/apps/overlay
npm ci > /dev/null 2>&1
npm run build > /dev/null 2>&1

# Run all benchmarks
echo "Running latency benchmark..."
bash /workspace/benchmarks/bench_latency.sh

echo "Running TruthfulQA benchmark..."
python3 /workspace/benchmarks/bench_truthfulqa.py

echo "Running EmoBench benchmark..."
python3 /workspace/benchmarks/bench_emobench.py

echo "Running FPS benchmark..."
node /workspace/benchmarks/bench_overlay_fps.js

# Create final verification report
cat > /workspace/results/VERIFICATION_REPORT.json << 'EOF'
{
  "verification_date": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "system": "Lucid Matrix Auriella Holo Dashboard v1",
  "benchmarks": {
    "latency": "bench_latency.sh",
    "truthfulqa": "bench_truthfulqa.py", 
    "emobench": "bench_emobench.py",
    "fps": "bench_overlay_fps.js"
  },
  "environment": {
    "node": "$(node --version)",
    "python": "$(python3 --version)",
    "npm": "$(npm --version)"
  },
  "results_location": "/workspace/results/",
  "reproducibility": "All benchmarks include fixed seeds and environment locks"
}
EOF

# Create master signature
cd /workspace/results
find . -name "*.json" -type f | sort | xargs cat | sha256sum | cut -d' ' -f1 > MASTER_SIGNATURE.txt

echo "✅ ALL BENCHMARKS COMPLETE"
echo "Results: /workspace/results/"
echo "Signature: $(cat MASTER_SIGNATURE.txt)"
echo "✅ Ready for university submission"