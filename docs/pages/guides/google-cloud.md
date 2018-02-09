---
layout: page
title: Google Cloud Guide
permalink: /guides/google-cloud/
hide: true
---

Objective: Install Astronomer and a single deployment of our
Airflow module on Kubernetes on Google Cloud.

## Requirements

Initial requirements are:

* a running [Kubernetes](https://kubernetes.io/) cluster
* [Helm/Tiller](https://github.com/kubernetes/helm) installed
* a Postgres database that Astronomer will use

If you don't have Kubernetes installed already, no fears, it's not
too hard to [get Kubernetes Running](/kubernetes).

As you deploy Astronomer modules, you will need to provide additional data stores
such as Kafka and Redis.


### Provision IPs

Provision two static IPs from your cloud provider:
* `gcloud compute addresses create astro-ingress --global`
* `gcloud compute addresses create astro-airflow-prod --global`

### Setup DNS

* choose a base domain such as `astro.mycompany.com`
* Setup a CNAME `registry.astro.mycompany.com` -> ip for astro-ingress
* Setup a CNAME `airflow.prod.astro.mycompany.com` -> ip for astro-airflow-prod
* Setup a CNAME `grafana.prod.astro.mycompany.com` -> ip for astro-airflow-prod
* Setup a CNAME `flower.prod.astro.mycompany.com` -> ip for astro-airflow-prod

### Create a namespace

* `kubectl create ns astro`

### Configure and run Helm

* run `git clone https://github.com/astronomerio/helm.astronomer.io`
* run `cd helm.astronomer.io`
* run `cp config.tpl.yaml config.yaml`
* fill in `config.yaml` including:
  * `global.baseDomain: astro.mycompany.com`
  * `astronomer.ingress.staticIpName: astro-ingress`
  * `airflow-prod.ingress.staticIpName: astro-airflow-prod`
  * `astronomer.registry.username: admin`
  * `astronomer.registry.password: changeme`
* run `helm install --name=astro-prod --namespace=astro -f config.yaml .`

### Test

Check URLs:

* http://registry.astro.mycompany.com
* http://airflow.prod.astro.mycompany.com
* http://grafana.prod.astro.mycompany.com
* http://flower.prod.astro.mycompany.com

### Secure your deployment

* Nuke everything by running `helm delete --purge astro-prod`

* Install kube-lego for letsencrypt

```
helm install \                   
--set=config.LEGO_EMAIL=me@mycompany.com \
--set=config.LEGO_URL="https://acme-v01.api.letsencrypt.org/directory" \
--set=config.LEGO_LOG_LEVEL=debug \
--set=rbac.create=true \
--set=image.tag=canary \
--namespace=astro \
stable/kube-lego
```

* Edit `config.yaml`
  * add `astronomer.ingress.acme: true`
* run `helm install --name=astro-prod --namespace=astro -f config.yaml .`

* WAIT 15 MINUTES :(
  * Google Cloud load balancer takes 5 min
  * letsencrypt sequence takes 5 min
  * takes 5 min to propagate the certificate to the load balancers

### Test Again

Check URLs:

* https://registry.astro.mycompany.com
* https://airflow.prod.astro.mycompany.com
* https://grafana.prod.astro.mycompany.com
* https://flower.prod.astro.mycompany.com

### Deploy an Airflow DAG

* Install CLI by running `curl -o- https://astro-cli.astronomer.io/install.sh | bash`
* Login by running `astro auth login` with user credentials you chose earlier
* Deploy DAGs
* Clone some test dags, wherever you keep your code by running `git clone https://github.com/astronomerio/open-example-dags` then `cd open-example-dags`
* Deploy `astro airflow deploy astro-prod 0.0.1`
* Visit https://airflow.prod.astro.mycompany.com and you should see your dags!
