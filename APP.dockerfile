FROM python:3.10.6-slim

ARG PROJECT_FOLDER=/pcsFilter
ENV POETRY_VERSION=1.5.1

WORKDIR $PROJECT_FOLDER

COPY pyproject.toml poetry.lock README.md "${PROJECT_FOLDER}/"
COPY ./pcsFilter $PROJECT_FOLDER/pcsFilter

RUN pip install "poetry==${POETRY_VERSION}" \
    && poetry env use python --version | grep -Eo '[0-9]+([.][0-9]+)+([.][0-9]+)?' \
    && poetry install

COPY pytest.ini $PROJECT_FOLDER

WORKDIR $PROJECT_FOLDER/actual
RUN poetry run pcsFilter --output-path . .
WORKDIR $PROJECT_FOLDER

ENTRYPOINT ["poetry", "run", "pytest", "-vv", "--full-trace", "-m"]
