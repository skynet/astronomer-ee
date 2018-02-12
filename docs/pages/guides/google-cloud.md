---
layout: page
title: Google Cloud Guide
permalink: /guides/google-cloud/
hide: true
---

> **Objective:** Install Astronomer Enterprise Edition and
a single deployment of our Airflow module
on Kubernetes on Google Cloud.

## Requirements

Initial requirements are:

* a running [Kubernetes](https://kubernetes.io/) cluster
* [Helm/Tiller](https://github.com/kubernetes/helm) installed
* a Postgres database that Astronomer will use

If you don't have Kubernetes installed already, no fear, it's not
too hard to [get Kubernetes Running](https://cloud.google.com/kubernetes-engine/docs/quickstart).
If you're just getting started, you can probably get away with a single node cluster, and increase the count over time. Think about how your workload might increase over time and choose a node size that makes sense for your plans. You can't change the node type after a cluster is already created, but you can add additional node pools that have different types of nodes.

As you deploy Astronomer modules, you will need to provide additional data stores
such as Kafka and Redis.


### Provision IPs
The Astronomer Platform needs to exposes several services for end users to consume. If you are planning on only connecting to your cluster from inside your cluster you can skip this step. If you just want to be able to connect to thse services and work with the platform over the internet, you'll want to provision a few static IP addresses. One static IP for the Astronomer Platform services, and one for Airflow services.

Provision two static IPs from Google Cloud:
* `gcloud compute addresses create astro-ingress --global`
* `gcloud compute addresses create astro-airflow-prod --global`

### Setup DNS
Once you have static IP addresses allocated, you may want to map them to easy to remember DNS names. This step will depend on your DNS provider.

* choose a base domain such as `astro.mycompany.com`
* Setup a CNAME `registry.astro.mycompany.com` -> ip for astro-ingress
* Setup a CNAME `airflow.prod.astro.mycompany.com` -> ip for astro-airflow-prod
* Setup a CNAME `grafana.prod.astro.mycompany.com` -> ip for astro-airflow-prod
* Setup a CNAME `flower.prod.astro.mycompany.com` -> ip for astro-airflow-prod

### Create a namespace
Now let's start the deployment process. To start, let's create namespace for the platform to live under.

* `kubectl create ns astronomer`

### Configure and run Helm
Now that we have a namespace to launch the Astronomer Platform into, let's download the installation package. Astronomer is packaged as a set of Helm charts. You can clone the latest charts from GitHub.
* run `git clone https://github.com/astronomerio/helm.astronomer.io`
* run `cd helm.astronomer.io`

Before deploying to a cluster, you'll need to configure a few things. Let's start by copying the boilerplate config file to a new file called `config.yaml`.
* run `cp config.tpl.yaml config.yaml`

Open `config.yaml` in a text editor and add a few values. Any of the values in the nested `values.yaml` config files can be overridden, but a few are highly encouraged or required. Those are listed below:
  * `global.baseDomain: astro.mycompany.com`
  * `astronomer.ingress.staticIpName: astro-ingress`
  * `airflow-prod.ingress.staticIpName: astro-airflow-prod`
  * `astronomer.registry.username: admin`
  * `astronomer.registry.password: changeme`

In addition to the listed configurations you'll also need to fill in the database connection details. `config.yaml` is already in `.gitignore` so you won't accidentially commit any sensitive data.

Once everything looks good you can deploy Astronomer using Helm.
* run `helm install --name=astro-prod --namespace=astronomer -f config.yaml .`

### Test
If everything went according to plan, you should be able to check the following URL's in your browser:
* http://airflow.prod.astro.mycompany.com
* http://flower.prod.astro.mycompany.com
* http://grafana.prod.astro.mycompany.com
* http://registry.astro.mycompany.com/v2/_catalog

### Secure your deployment
If this is a production environment, you'll want to secure your services with TLS. If you have your own certificate, you can use that. Documentation on that coming soon. If you don't have certificates, you can use a tool called `kube-lego` to automatically provision and deploy certificates.
* Delete deployment `helm delete --purge astro-prod`
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

* Wait about 15 minutes
  * Google Cloud load balancer takes about 5 min to spin up.
  * Let's Encrypt sequence takes 5 min.
  * 5 more min to propagate the certificate to the load balancer.

### Test Again
If everything worked, you'll be able to load your services over a secure connection.
* https://airflow.prod.astro.mycompany.com
* https://grafana.prod.astro.mycompany.com
* https://flower.prod.astro.mycompany.com
* https://registry.astro.mycompany.com/v2/_catalog

### Deploy an Airflow DAG

* Install CLI by running `curl -o- https://astro-cli.astronomer.io/install.sh | bash`
* Login by running `astro auth login` with user credentials you chose earlier
* Deploy DAGs
* Clone some test dags, wherever you keep your code by running `git clone https://github.com/astronomerio/open-example-dags` then `cd open-example-dags`
* Deploy `astro airflow deploy astro-prod 0.0.1`
* Visit https://airflow.prod.astro.mycompany.com and you should see your dags!
