SPHINX_OPTIONS ?=
SPHINX_OBJS = \
	genindex \
	index \
	search \
	blog
SPHINX_SUFFIX = .html

all:
	sphinx-build $(SPHINX_OPTIONS) -c . -b html -d .doctrees src ./

publish: all
	git add $(SPHINX_OBJS:=$(SPHINX_SUFFIX))
	git add objects.inv searchindex.js
	git add src/blog/ blog/
	git commit -S -a
	git push

.PHONY: all publish
