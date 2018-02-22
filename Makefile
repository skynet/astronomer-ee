# Public bucket for docs.
DOMAIN ?= enterprise.astronomer.io
URL ?= https://${DOMAIN}
BUCKET ?= gs://${DOMAIN}

# Local directories
INPUT := docs
OUTPUT := docs/_site

.PHONY: build
build:
	jekyll build --source ${INPUT} --destination ${OUTPUT}


.PHONY: push-public
push-docs: build
	gsutil -m rsync -a public-read -d -r ${OUTPUT} ${BUCKET}
