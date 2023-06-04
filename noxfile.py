import nox


@nox.session(python=["3.7", "3.8", "3.9", "3.10"])
def tests(session):
    session.run(
        "make", "reinstall",
        external=True, env={'PIPENV_IGNORE_VIRTUALENVS': '1'})
    session.run("pytest", "-v", "-m", "unit")


@nox.session(python=["3.7", "3.8", "3.9", "3.10"])
def tests(session):
    session.run(
        "make", "reinstall",
        external=True, env={'PIPENV_IGNORE_VIRTUALENVS': '1'})
    session.run("pytest", "-v", "-m", "integration")
