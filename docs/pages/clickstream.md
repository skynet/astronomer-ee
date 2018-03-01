---
layout: page
title: Clickstream
permalink: /clickstream/
order: 3
---

{% include licensing.md %}

## Architecture

The Astronomer Clickstream module consists of six components:

* **Event API** is built in Go, and its only job is to accept user events from SDKs, and drop those events into Kafka
* **Apache Kafka** is the data store
* **Event Router** republishes events from the main topic to destination-specific topics
* **Serverside workers** pulls user events from the destination-specific topics and route them to destination APIs
* **Prometheus** scrapes metrics from all the containers
* **Grafana** visualizes Prometheus metrics

![Clickstream Module]({{ "/assets/img/clickstream_module.png" | absolute_url }})

## Guides

* [Create a Clickstream Destination](/clickstream/destination)
