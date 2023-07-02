.DEFAULT_GOAL := default

default:
	@echo "\nThe following commands are supported for general usage:\n"
	@echo "clean      # Delete python virtual environment and poetry.lock"
	@echo "install    # Create python virtual environment and install project dependencies"
	@echo "reinstall  # Clean the project and install from scratch"
	@echo "update     # Update project dependencies"
	@echo "test_all   # Run unit, integration and e2e tests against supported python versions"
	@echo "quick_test # Run unit and integration tests against current python version"
	@echo "publish    # Publish project to pypi. See CONTRIBUTING.md for details"

clean:
	poetry env remove --all
	rm -f poetry.lock

install:
	@echo "Set poetry with the current python version"
	poetry env use python --version | grep -Eo '[0-9]+([.][0-9]+)+([.][0-9]+)?'
	@echo "Install dependencies"
	poetry install
	$(MAKE) path

path:
	@echo "Python virtual environment (virtualenv) path is:"
	poetry show -v | grep "Using virtualenv"

reinstall: clean install

update:
	poetry update

test_all: nox e2e_test

nox:
	@echo "Run tests against python 3.7, 3.8, 3.9, and 3.10"
	nox

e2e_test: stop_clean_docker start_docker stop_clean_docker

start_docker:
	docker build -t pcsfilter .
	docker run -it --name pcsfilter-container pcsfilter e2e

stop_clean_docker:
	docker stop pcsfilter-container || true
	docker rm pcsfilter-container || true

quick_test:
	poetry run pytest -v -m "unit or integration"

publish:
	poetry --build publish
