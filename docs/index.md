---
layout: page
homepage: true
isHome: true
title: Astronomer Enterprise Edition
permalink: /
order: 1
---


## Overview

Astronomer Enterprise Edition allows your to deploy
Astronomer Modules (Clickstream and Apache Airflow) to your Kubernetes.
Usage of requires an active, paid subscription license from Astronomer, Inc.,
which you can get by emailing us at
[humans@astronomer.io](mailto:humans@astronomer.io). We're super easy to deal
with; we'll make sure the price is right for your value.

{% include guides.md %}

## Modules

1. [Clickstream](/clickstream) — Docker images for an [Analytics.js](https://github.com/segmentio/analytics.js)-based clickstream system with server-side event processing. Includes a Go Event API, Apache Kafka, Go Event Router, and server-side integration workers that push data off to ~50 common APIs.
1. [Airflow](/airflow) — Docker images for [Apache Airflow](https://airflow.apache.org/)-based ETL system that is pre-configured to run Airflow, Celery, Flower, StatsD, Prometheus, and Grafana.

## Building the Documentation

Documentation is built on jekyll and currently hosted on GitHub
pages. To run the docs site locally:

- `cd docs`
- `bundle install`
- `bundle exec jekyll serve`
