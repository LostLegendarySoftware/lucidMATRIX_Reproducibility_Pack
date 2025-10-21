# Lucid Matrix Reproducibility Pack
# Base image with CUDA support
FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    cmake \
    curl \
    git \
    libssl-dev \
    python3-dev \
    python3-pip \
    python3-setuptools \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -s /bin/bash lucidmatrix
USER lucidmatrix
WORKDIR /home/lucidmatrix

# Set up Python environment
RUN python3 -m pip install --no-cache-dir --upgrade pip setuptools wheel

# Copy requirements file
COPY --chown=lucidmatrix:lucidmatrix requirements.txt .

# Install Python dependencies
RUN python3 -m pip install --no-cache-dir -r requirements.txt

# Copy the artifact pack
COPY --chown=lucidmatrix:lucidmatrix . /home/lucidmatrix/artifacts/

# Set working directory to artifacts
WORKDIR /home/lucidmatrix/artifacts

# Set entrypoint
ENTRYPOINT ["/bin/bash"]