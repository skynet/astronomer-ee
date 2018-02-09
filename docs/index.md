---
layout: page
homepage: true
isHome: true
title: Astronomer Enterprise Edition
permalink: /
order: 1
---

## Overview
Astronomer Enterprise Edition allows your to deploy the
modules of the Astronomer Platform to Kubernetes.

Astronomer Enterprise Edition requires an active subscription
license from Astronomer.

## Requirements
The only requirement to get up and running is a running Kubernetes cluster.

If you don't have Kubernetes installed already you can run it locally
or easily deploy to clouds.

More info: [Getting Kubernetes Up](...)

The Astronomer modules will require you provide data stores
such as Postgres, Kafka, and Redis.

## Quickstart

...

## Modules

1. [Clickstream](/clickstream) — Docker images for an
[Analytics.js](https://github.com/segmentio/analytics.js)-based
clickstream system with server-side event processing. Includes a
Go Event API, Apache Kafka, Go Event Router, and server-side
integration workers that push data off to ~50 common APIs.

2. [Airflow](/airflow) — Docker images for
[Apache Airflow](https://airflow.apache.org/)-based ETL system
that is pre-configured to run Airflow, Celery, Flower, StatsD,
Prometheus, and Grafana.

## Building the Documentation
Documentation is built on jekyll and currently hosted on GitHub
pages. To run the docs site locally:

- `cd docs`
- `bundle install`
- `bundle exec jekyll serve`
