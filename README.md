# Ollama with Intel GPU Acceleration (IPEX-LLM / SYCL)

This repository contains a fully auditable Dockerfile and automated GitHub Actions workflow to build and publish an Intel GPU-accelerated Ollama image. It serves as a drop-in replacement for standard Nvidia-based Ollama containers.

## Features
* **Intel Arc Acceleration:** Built using Intel's Level-Zero compute runtime and IPEX-LLM oneAPI backend.
* **CI/CD:** Automatically built and published to GitHub Container Registry (GHCR) at `ghcr.io/steve-offutt/ollama-intel:latest`.
* **Auditable:** Built directly from source on GitHub runners.

## Running Locally

To run the container locally with GPU passthrough:

```bash
docker run -d --name ollama-intel-gpu \
  --device=/dev/dri \
  -p 11434:11434 \
  -v ollama-data:/root/.ollama \
  ghcr.io/steve-offutt/ollama-intel:latest
```
