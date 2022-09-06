.DEFAULT_GOAL := default

default:
	@echo "The following commands are supported:"
	@echo "build \t\t # Build sfilter locally via pip"
	@echo "clean \t\t # Clean the project"
	@echo "install \t # Install project dependencies"
	@echo "reinstall \t # Clean the project and install from scratch"
	@echo "test \t\t # Test the project"

reinstall: clean install

clean:
	pipenv --rm

install:
	pipenv install


test: tox sfilter

tox:
	@echo "Prepare environment"
	pip3 install tox tox-pyenv
	pyenv local 3.7.12 3.8.12 3.9.1 3.10.6
	@echo "Run tox"
	tox

pytest:
	@echo "Run tests"
	PIPENV_IGNORE_VIRTUALENVS=1 pipenv run pytest -v

sfilter:
	@echo "Run sfilter"
	$(MAKE) build
	sfilter ./src

build:
	pip install -e .
