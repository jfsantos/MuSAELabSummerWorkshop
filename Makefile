#======================================================================
# Based on the default Makefile for Software Carpentry bootcamps.  
# Use 'make' on its own to see a list of targets.
#
# To add new lessons, add their Markdown files to the MOST_SRC target.
# Order is important: when we build the single-page book version of
# the notes on the web site, lessons appear in the order in which they
# appear in MOST_SRC.
#
# If the source of those lessons isn't Markdown, whoever adds them is
# responsible for adding rules to convert them from whatever format
# they're in to Markdown.  The section titled "Create Markdown
# versions of IPython Notebooks" does this for IPython Notebooks; if
# more notebooks are added, make sure to add them to the target
# IPYNB_SRC.  If other source formats are used, add a new section to
# this Makefile and list it here.
#
# Note that this Makefile uses $(wildcard pattern) to match sets of
# files instead of using shell wildcards, and $(sort list) to ensure
# that matches are ordered when necessary.
#======================================================================

#----------------------------------------------------------------------
# Settings.
#----------------------------------------------------------------------

# Output directory for local build.
SITE = _site

# Jekyll configuration file.
CONFIG = _config.yml

#----------------------------------------------------------------------
# Specify the default target before any other targets are defined so
# that we're sure which one Make will choose.
#----------------------------------------------------------------------

all : commands

#----------------------------------------------------------------------
# Convert Markdown to HTML exactly as GitHub will when files are
# committed in the repository's gh-pages branch.
#----------------------------------------------------------------------

# Source Markdown files.  These are listed in the order in which they
# appear in the final book-format version of the notes.
MOST_SRC = \
	 novice/git/index.md $(sort $(wildcard novice/git/??-*.md)) \
	 LICENSE.md

# Other files that the site depends on.
EXTRAS = \
       $(wildcard css/*.css) \
       $(wildcard css/*/*.css) \
       $(wildcard _layouts/*.html)

# Principal target files
INDEX = $(SITE)/index.html

# Convert from Markdown to HTML.  This builds *all* the pages (Jekyll
# only does batch mode), and erases the SITE directory first, so
# having the output index.html file depend on all the page source
# Markdown files triggers the desired build once and only once.
$(INDEX) : ./index.html $(ALL_SRC) $(CONFIG) $(EXTRAS)
	 jekyll build -t -d $(SITE)

#----------------------------------------------------------------------
# Targets.
#----------------------------------------------------------------------

## ---------------------------------------

## commands : show all commands.
commands :
	@grep -E '^##' Makefile | sed -e 's/##//g'

## ---------------------------------------

## site     : build the site as GitHub will see it.
site : $(INDEX)

## check    : check that the index.html file is properly formatted.
check :
	@python bin/swc_index_validator.py ./index.html

## clean    : clean up all generated files.
clean : tidy
	rm -rf $(SITE)

## ---------------------------------------
## contribs : list contributors.
#  Relies on ./.mailmap to translate user IDs into names.
contribs :
	git log --pretty=format:%aN | sort | uniq

## fixme    : find places where fixes are needed.
fixme :
	grep -i -n FIXME $$(find novice -type f -print | grep -v .ipynb_checkpoints)

## gloss    : check the glossary.
gloss : $(INDEX)
	python bin/gloss.py gloss.md $(patsubst %.md,$(SITE)/%.html,$(MOST_SRC))

## tidy     : clean up odds and ends.
tidy :
	rm -rf \
	$$(find . -name '*~' -print) \
	$$(find . -name '*.pyc' -print) \
	$(BOOK_MD)

.PHONY: all check clean commands contribs fixme gloss site tidy
