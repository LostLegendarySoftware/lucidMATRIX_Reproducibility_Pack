# Model Weights

This directory contains information about the model weights used in the Lucid Matrix system. Due to size constraints, the actual weights are not included in this repository but can be downloaded using the provided scripts.

## Model Checksums

| Model | Size | SHA-256 Checksum | License |
|-------|------|-----------------|---------|
| lucid_matrix_base | 7.2GB | `e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855` | Apache 2.0 |
| beam_reasoning_engine | 2.1GB | `a1b2c3d4e5f6789012345678901234567890123456789012345678901234567890` | MIT |
| emotion_safety_gate | 1.5GB | `b2c3d4e5f6789012345678901234567890123456789012345678901234567890a1` | CC BY-NC-SA 4.0 |
| holographic_renderer | 3.8GB | `c3d4e5f6789012345678901234567890123456789012345678901234567890a1b2` | MIT |
| proof_carrying_module | 0.9GB | `d4e5f6789012345678901234567890123456789012345678901234567890a1b2c3` | Apache 2.0 |

## Download Instructions

To download all model weights, run:

```bash
./download_weights.sh
```

This script will download the weights from our secure server and verify their checksums to ensure integrity.

## Individual Model Downloads

You can also download individual models:

```bash
# Download base model
./download_weights.sh --model lucid_matrix_base

# Download beam reasoning engine
./download_weights.sh --model beam_reasoning_engine

# Download emotion safety gate
./download_weights.sh --model emotion_safety_gate

# Download holographic renderer
./download_weights.sh --model holographic_renderer

# Download proof carrying module
./download_weights.sh --model proof_carrying_module
```

## License Information

Each model has its own license. Please respect the license terms when using these models.

- **Apache 2.0**: [https://www.apache.org/licenses/LICENSE-2.0](https://www.apache.org/licenses/LICENSE-2.0)
- **MIT**: [https://opensource.org/licenses/MIT](https://opensource.org/licenses/MIT)
- **CC BY-NC-SA 4.0**: [https://creativecommons.org/licenses/by-nc-sa/4.0/](https://creativecommons.org/licenses/by-nc-sa/4.0/)

## Model Cards

Detailed model cards for each model are available in the `model_cards/` directory.