FROM python:3.10.6-alpine

ARG PCS_FILTER_VERSION=0.0.0

RUN pip install "pcsFilter==${PCS_FILTER_VERSION}"

ENTRYPOINT ["pcsFilter"]
