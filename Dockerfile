FROM python:3.10.6-slim as base

ARG PROJECT_FOLDER=/sfilter

RUN mkdir -p $PROJECT_FOLDER
WORKDIR $PROJECT_FOLDER

# Create a temporary layer for latest security updates
FROM base as updates

COPY Pipfile $PROJECT_FOLDER
COPY Pipfile.lock $PROJECT_FOLDER

RUN pip install --upgrade pip \
    && pip install pipenv \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
    && PIPENV_VENV_IN_PROJECT=1 pipenv install --ignore-pipfile --deploy --python 3.10

# Create a final layer with only necessary dependencies \
FROM base as final

COPY --from=updates $PROJECT_FOLDER/.venv $PROJECT_FOLDER/.venv
ENV PATH="${PROJECT_FOLDER}/.venv/bin:$PATH"

COPY ./src $PROJECT_FOLDER/src
COPY setup.py $PROJECT_FOLDER
COPY README.md $PROJECT_FOLDER

VOLUME $PROJECT_FOLDER

RUN pip install -e .
