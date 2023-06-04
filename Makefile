.DEFAULT_GOAL := default

default:
	@echo "\nThe following commands are supported for general usage:\n"
	@echo "pip_build \t # Build pcsFilter locally via pip"
	@echo "clean \t\t # Clean the project"
	@echo "install \t # Install project dependencies"
	@echo "reinstall \t # Clean the project and install from scratch"
	@echo "test_all \t # Run all (unit, integration, e2e) tests against multiple python versions"
	@echo "quick_test \t # Quick test (unit, integration) the project against current python version"

reinstall: clean install

clean:
	pipenv --rm
	rm -f Pipfile.lock

install:
	pipenv install


test_all: nox e2e_test pcsFilter_src

nox:
	@echo "Run tests against python 3.7, 3.8, 3.9, and 3.10"
	nox

quick_test:
	@echo "Run tests"
	pyenv local 3.10.6
	PIPENV_IGNORE_VIRTUALENVS=1 pipenv run pytest -v -m "unit or integration"

pcsFilter_src:
	@echo "Run pcsFilter"
	pyenv local 3.10.6
	$(MAKE) pip_build
	pcsFilter -s ./src

pip_build:
	pip install -e .

e2e_test: stop_clean_docker start_docker stop_clean_docker

start_docker:
	docker build -t pcsfilter .
	docker run -it --name pcsfilter-container pcsfilter e2e

stop_clean_docker:
	docker stop pcsfilter-container || true
	docker rm pcsfilter-container || true
