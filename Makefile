# Public bucket for docs.
DOMAIN ?= enterprise.astronomer.io
URL ?= https://${DOMAIN}
BUCKET ?= gs://${DOMAIN}

# Local directories
INPUT := docs
OUTPUT := docs/_site

.PHONY: build-docs
build-docs:
	jekyll build --source ${INPUT} --destination ${OUTPUT}


.PHONY: push-docs
push-docs: build-docs
	gsutil -m rsync -a public-read -d -r ${OUTPUT} ${BUCKET}
