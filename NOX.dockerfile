FROM ubuntu:23.10

ENV NOX_VERSION "2023.4.22"
ENV POETRY_VERSION "1.5.1"
ENV PYENV_ROOT /root/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN apt-get update && \
    apt-get install -y --no-install-recommends make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget ca-certificates curl llvm libncurses5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev mecab-ipadic-utf8 git

RUN curl https://pyenv.run | bash
RUN pyenv update
RUN pyenv install 3.10
RUN pyenv install 3.9
RUN pyenv install 3.8
RUN pyenv install 3.7
RUN pyenv global 3.10
RUN pyenv rehash

RUN pip install poetry==$POETRY_VERSION nox==$NOX_VERSION

ARG PROJECT_FOLDER=/pcsFilter
WORKDIR $PROJECT_FOLDER
COPY . $PROJECT_FOLDER

RUN pyenv local 3.7 3.8 3.9 3.10

CMD ["make", "nox"]