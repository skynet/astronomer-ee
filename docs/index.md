---
layout: page
homepage: true
isHome: true
title: Astronomer Enterprise Edition
permalink: /
order: 1
---

{% include licensing.md %}

Astronomer Enterprise Edition is an enterprise-grade data
engineering platform that allows any developer to jump to the task
of creating and managing data pipelines very quickly. The platform
includes a Heroku-like CLI capability to deploy pipelines, as
well as a New Relic-like interface to monitor and troubleshoot
running pipelines.

The platform leverages leading open source tools
including Kubernetes, Airflow, Prometheus, and Grafana — and also
includes a library of
[open-source Airflow connectors](https://github.com/airflow-plugins)
that we have been building and curating for the past year.

<iframe width="560" height="315" style="display: block; margin: 20px auto;"
  src="https://www.youtube.com/embed/PESuvgnsP8Q"
  frameborder="0" allow="autoplay; encrypted-media"
allowfullscreen></iframe>

{% include guides.md %}

## Modules

1. [Clickstream](/clickstream) — Docker images for an [Analytics.js](https://github.com/segmentio/analytics.js)-based clickstream system with server-side event processing. Includes a Go Event API, Apache Kafka, Go Event Router, and server-side integration workers that push data off to ~50 common APIs.
1. [Airflow](/airflow) — Docker images for [Apache Airflow](https://airflow.apache.org/)-based ETL system that is pre-configured to run Airflow, Celery, Flower, StatsD, Prometheus, and Grafana.

## Building the Documentation

Documentation is built on Jekyll and hosted on Google Cloud Storage.

Build the docs site locally:

```
cd docs
bundle install
```

Run it:

```
bundle exec jekyll serve
```
