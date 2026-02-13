FROM alpine:3.19

RUN apk add --no-cache \
    bash \
    python3 \
    py3-pip \
    offlineimap \
    jq \
    git \
    ca-certificates

# sgpt CLI + reportlab for PDF
RUN pip3 install --no-cache-dir sgpt reportlab

WORKDIR /app

# copy scripts + static files (configs are bind-mounted at runtime)
COPY bin/ ./bin/
COPY rules/ ./rules/
COPY mirror_dir_gmail.json_example ./
COPY offlineimaprc_example ./
COPY goodie_openclaw_low_llm_advises.txt ./
COPY README.md ./

ENV PATH="/app/bin:${PATH}"

# default command (override in docker-compose or docker run)
CMD ["/bin/bash"]
