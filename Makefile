SPHINX_OPTIONS ?= -a
SPHINX_OBJS = \
	index \
	search \
	blog
SPHINX_SUFFIX = .html

all: purge
	sphinx-build $(SPHINX_OPTIONS) -c . -b html -d .doctrees src ./

purge:
	$(RM) -r blog/

publish: all
	git add $(SPHINX_OBJS:=$(SPHINX_SUFFIX))
	git add objects.inv searchindex.js
	git add src/blog/
	git add -f blog/
	git commit -S -a
	git push

.PHONY: all purge publish
