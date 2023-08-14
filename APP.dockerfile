FROM ghcr.io/mirrorshub/docker/python:3.10-slim

RUN #pip install "pcsfilter==1.0.1"

ENTRYPOINT ["pcsfilter"]
