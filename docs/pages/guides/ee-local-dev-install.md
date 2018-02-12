---
layout: page
title: Data Services
permalink: /guides/data-services/
hide: true
---

# Install Enterprise Edition to a Local Kubernetes Cluster
This guide will walk you through installing Kubernetes on a local dockerized cluster. For information on installing a local Kubernetes cluster please review [create-local-k8-dev.md][1]

## Included In This Chart
- [Apache Airflow][2]
- [Celery][3] w/ [Flower][4]
- [Grafana][5]
- [Prometheus][6]
- [Ingress][7]

## Database Prerequisites
Before installing the Astronomer Open platform, setup two databases that will serve as back-ends to the platform. You can bring these databases with you or install the helm package(s). This guide will assume that you are installing the helm packages.

### Redis Deploy
[Redis][8] is an in-memory data structure store that we will be using as a message broker for [Celery][3].

1. run `helm install stable/redis`
2. Capture the resource URL from successful deployment out
    - The output contains a header titled "NOTES:"
    - In a new text doc save this URL
3. Follow the output instructions to capture your REDIS_PASSWORD
    - `echo $REDIS_PASSWORD`
    - Save this in a text doc with the Redis URL

### Verification

1. Run `helm ls` to see the status of your deployment

### PostgreSQL Deploy
[PostgreSQL][9] is an open-source relational DB that will serve as the back-end to Apache Airflow, Celery and Grafana. There is currently a minor bug in the stable helm chart, so for this install we will be using the Astronomer fork.

1. `git clone https://github.com/astronomerio/charts.git`
2. `cd charts/stable`
3. run `helm install postgresql`
4. Capture the resource URL from successful deployment output
    - The output contains a header titled "NOTES:"
    - In a new text doc save this URL
5. Follow the output instructions to capture your PGPASSWORD
    - `echo $PGPASSWORD`
    - Save this in a text doc with the PostgreSQL URL

### Verification

1. Run `helm ls` to see the status of your deployment

## Astronomer Open Platform Deployment

### Configure the Overrides

In this step you will updating `overrides.yaml` to point to the Redis and PostgreSQL pods you deployed earlier in this document.

1. Rename `overrides.default.yaml` to  `overrides.yaml`.
    - Directory contents should be
        - `astronomer/`
        - `overrides.yaml`
        - `README.md`
        - `.gitignore`
2. Update `overrides.yaml`

    - Configuration depending on PostgreSQL
        - `data.metadata`
        - `data.results`
        - `data.grafata`
    - Configuration depending on Redis
        - `data.broker`

Below are example configurations with local dev defaults being denoted by a *
```yaml
results:
    host: intentional-marmot-postgresql.default.svc.cluster.local
    port: 5432*
    database: airflow
    username: postgres*
    password: password
```

```yaml
results:
    host: braided-alpaca-redis.default.svc.cluster.local
    port: 6379*
    database: 0*
    username: ''*
    password: password
```

### Deploy Astronomer Open

In this step we will be deploying Astronomer Open pods to your local Kubernetes cluster.

1. To deploy Astronomer Open, run `helm install -f overrides.yaml astronomer`

### Verification

1. Navigate to your Kubernetes Dashboard
- http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/
2. Change your namespace on the left-side panel from `default` to `astronomer-system`
3. Verify that all your pods are all-green


[1]: /create-local-k8-dev.md                                            "Kubernetes On Docker Installation Guide"
[2]: https://airflow.apache.org/                                        "Apache Airflow"
[3]: http://www.celeryproject.org/                                      "Celery: Distributed Task Queue"
[4]: http://flower.readthedocs.io/en/latest/                            "Flower: A Celery Monitoring Tool"
[5]: https://grafana.com/                                               "Grafana Monitoring"
[6]: https://prometheus.io/                                             "Prometheus Time Series Monitoring"
[7]: https://kubernetes.io/docs/concepts/services-networking/ingress/   "Ingress: DNS"
[8]: https://redis.io/                                                  "Redis Homepage"
[9]: https://www.postgresql.org/                                        "PostgreSQL Database"
