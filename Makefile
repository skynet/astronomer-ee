# Public bucket for docs.
DOCS_DOMAIN ?= enterprise.astronomer.io
DOCS_BUCKET ?= gs://${DOCS_DOMAIN}

# Local directories
DOCS_SRC := docs
DOCS_DEST := docs/_site

.PHONY: build-docs
build-docs:
	jekyll build --source ${DOCS_SRC} --destination ${DOCS_DEST}

.PHONY: push-docs
push-docs: build-docs
	gsutil -m rsync -a public-read -d -r ${DOCS_DEST} ${DOCS_BUCKET}
