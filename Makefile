# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line, and also
# from the environment for the first two.
SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = source
BUILDDIR      = build

# Put it first so that "make" without argument is like "make help".
help:
	@$(SPHINXBUILD) -M help "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)

publish:
	@if ! git status | grep "nothing to commit" &>/dev/null; then echo 'Commit all changes first.'; exit 1; fi
	@rm -rf docs; mkdir docs; rm -rf build/html
	@make html
	@cp -ra build/html/* docs; cp CNAME docs; touch docs/.nojekyll
	@git add * &>/dev/null
	@git commit -m "Publishing new content."
	@git push

.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
