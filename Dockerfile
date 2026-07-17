# =============================================================================
# Intel Vulkan Ollama — Docker Image for Intel Arc GPUs (Auditable Build)
# =============================================================================
# Packages the official Ollama v0.32.1 binary with Intel GPU userspace
# drivers and Mesa Vulkan drivers into a minimal container.
# =============================================================================

FROM ollama/ollama:0.32.1

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Intel Graphics Compiler (IGC)
ARG IGC_VERSION=v2.36.3
ARG IGC_CORE_DEB=intel-igc-core-2_2.36.3+21719_amd64.deb
ARG IGC_OPENCL_DEB=intel-igc-opencl-2_2.36.3+21719_amd64.deb

# Intel Compute Runtime (Level-Zero GPU driver, OpenCL ICD, gmmlib)
ARG COMPUTE_RT_VERSION=26.22.38646.4
ARG LEVEL_ZERO_GPU_DEB=libze-intel-gpu1_26.22.38646.4-0_amd64.deb
ARG OPENCL_ICD_DEB=intel-opencl-icd_26.22.38646.4-0_amd64.deb
ARG GMMLIB_DEB=libigdgmm12_22.10.0_amd64.deb

# Level-Zero Loader
ARG LEVEL_ZERO_LOADER_VERSION=v1.32.0
ARG LEVEL_ZERO_LOADER_DEB=libze1_1.32.0+u24.04_amd64.deb
# Install base packages and Mesa Vulkan drivers
RUN apt-get update && \
    apt-get install --no-install-recommends -q -y \
        ca-certificates \
        wget \
        ocl-icd-libopencl1 \
        mesa-vulkan-drivers && \
    rm -rf /var/lib/apt/lists/*

# Install Intel GPU userspace drivers
RUN mkdir -p /tmp/gpu && cd /tmp/gpu && \
    wget -q https://github.com/oneapi-src/level-zero/releases/download/${LEVEL_ZERO_LOADER_VERSION}/${LEVEL_ZERO_LOADER_DEB} && \
    wget -q https://github.com/intel/intel-graphics-compiler/releases/download/${IGC_VERSION}/${IGC_CORE_DEB} && \
    wget -q https://github.com/intel/intel-graphics-compiler/releases/download/${IGC_VERSION}/${IGC_OPENCL_DEB} && \
    wget -q https://github.com/intel/compute-runtime/releases/download/${COMPUTE_RT_VERSION}/${LEVEL_ZERO_GPU_DEB} && \
    wget -q https://github.com/intel/compute-runtime/releases/download/${COMPUTE_RT_VERSION}/${OPENCL_ICD_DEB} && \
    wget -q https://github.com/intel/compute-runtime/releases/download/${COMPUTE_RT_VERSION}/${GMMLIB_DEB} && \
    dpkg -i *.deb && \
    rm -rf /tmp/gpu

# Configure runtime environment for Vulkan
ENV ZES_ENABLE_SYSMAN=1
ENV OLLAMA_VULKAN=1
ENV no_proxy=localhost,127.0.0.1

EXPOSE 11434
VOLUME ["/root/.ollama"]

# Use the official Ollama entrypoint
ENTRYPOINT ["/bin/ollama", "serve"]
