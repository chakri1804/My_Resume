# Build image for the pandoc + ConTeXt resume pipeline (see ../Makefile).
# Used by ../docker-compose.yml, which bind-mounts the repo at /home/app/resume
# and runs `make`.
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# fonts-texgyre (not tex-gyre) provides the OpenType TeX Gyre fonts that
# ConTeXt's `helvetica` typescript (used in styles/chmduquesne.tex) resolves to.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        make \
        pandoc \
        context \
        fonts-texgyre \
    && rm -rf /var/lib/apt/lists/*

# Let ConTeXt see fonts installed under /usr/share/fonts, then pre-generate the
# file/font databases so `make pdf` doesn't have to (the README's
# "Cannot find context.lua" fix is `mtxrun --generate`).
ENV OSFONTDIR=/usr/share/fonts
RUN mtxrun --generate \
    && mtxrun --script fonts --reload

WORKDIR /home/app/resume
