# Used for e2e test
FROM python:3.10.6-slim as base

ARG PROJECT_FOLDER=/pcsFilter

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

# Create a final layer with only necessary dependencies
FROM base as final

COPY --from=updates $PROJECT_FOLDER/.venv $PROJECT_FOLDER/.venv
ENV PATH="${PROJECT_FOLDER}/.venv/bin:$PATH"

COPY ./src $PROJECT_FOLDER/src
COPY tests/pcsFilter/e2e/actual $PROJECT_FOLDER/actual
COPY tests/pcsFilter/e2e/expected $PROJECT_FOLDER/expected
COPY tests/pcsFilter/e2e/test_pcsFilter_results.py $PROJECT_FOLDER/test_pcsFilter_results.py
COPY setup.py $PROJECT_FOLDER
COPY README.md $PROJECT_FOLDER
COPY pytest.ini $PROJECT_FOLDER

RUN pip install -e .
WORKDIR $PROJECT_FOLDER/actual
RUN pcsFilter --output-path . .
WORKDIR $PROJECT_FOLDER

ENTRYPOINT ["pytest", "-vv", "--full-trace", "-m"]
