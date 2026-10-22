ARG PANGEO_BASE_IMAGE_TAG=2026.01.30
FROM pangeo/pangeo-notebook:${PANGEO_BASE_IMAGE_TAG}

# eMudhra CA distrust; remove once the base image ships this.
USER root
RUN apt-get update && \
    apt-get install -y --only-upgrade ca-certificates && \
    rm -rf /var/lib/apt/lists/*
USER ${NB_USER:-jovyan}

COPY environment.yml /tmp/environment.yml
RUN mamba env update -f /tmp/environment.yml --name notebook && \
    mamba install -y -n notebook "ca-certificates>=2026.10.19" "certifi>=2026.10.19" && \
    mamba install -y -n base "ca-certificates>=2026.10.19" "certifi>=2026.10.19" && \
    mamba clean --all -f -y
