SPHINX_OPTIONS ?=

all:
	sphinx-build $(SPHINX_OPTIONS) -c . -b html -d .doctrees src ./
