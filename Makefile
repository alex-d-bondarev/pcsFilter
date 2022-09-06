.DEFAULT_GOAL := default

default:
	@echo "\nThe following commands are supported for general usage:\n"
	@echo "build \t\t # Build sfilter locally via pip"
	@echo "clean \t\t # Clean the project"
	@echo "install \t # Install project dependencies"
	@echo "reinstall \t # Clean the project and install from scratch"
	@echo "test \t\t # Test the project"
	@echo "\nThe following commands are supported for debugging:\n"
	@echo "start_docker \t\t # Build sfilter docker and run bash from inside"
	@echo "stop_clean_docker \t # Stop all containers and perform full cleanup"

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

start_docker:
	docker build -t sfilter .
	docker run --name sfilter-container -dit sfilter
	docker exec -it sfilter-container bash

stop_clean_docker:
	docker stop `docker ps -aq`
	docker rm `docker ps -aq`
	docker rmi `docker image ls -aq`
	docker volume prune -f `docker volume ls -a`
