---
layout: page
homepage: true
isHome: true
title: Astronomer Enterprise Edition
permalink: /
order: 1
---

{% include licensing.md %}

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
