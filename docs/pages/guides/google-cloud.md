---
layout: page
title: Google Cloud Guide
permalink: /guides/google-cloud/
hide: true
---

{% include licensing.md %}

## Objective

Install Astronomer Enterprise Edition and a single deployment of our Airflow module on Kubernetes on Google Cloud.

## Requirements

Initial requirements are:

* A live [Kubernetes](https://kubernetes.io/) cluster
* [Helm/Tiller](https://github.com/kubernetes/helm) installed in the cluster
* A Postgres database
* A Redis database
* Local clone of [our helm charts](https://github.com/astronomerio/helm.astronomer.io)

If you don't have Kubernetes installed already, no fear, it's not too hard to [get Kubernetes Running](https://cloud.google.com/kubernetes-engine/docs/quickstart). If you're just getting started, you can probably get away with a single node cluster, and increase the count over time. Think about how your workload might increase over time and choose a node size that makes sense for your plans. You can't change the node type after a cluster is already created, but you can add additional node pools that have different types of nodes.

## Permissions

To complete this installation guide, you will need to have Kubernetes Admin and Compute Admin roles in GCP. You need permission to create a cluster, as well as provision a static IP address.

## Configuration File

Once you have cloned the helm repository, change into that directory. The helm charts are built to be customizable and tailored to your unique environment. The way we customize an installation is through a YAML configuration file. This file can contain global configurations that are used in multiple charts, or chart specific configurations. Global configurations are underneath the top-level `global` key. Chart specific configurations will be nested under top-level keys that correspond to the chart name. For example, to override values in the `airflow` chart, you will need to create a top-level key, `airflow`, and nest configurations under it.

All charts are located under the `charts` directory and each chart contains a default `values.yaml` file that contains every possible configuration as well as the default value. The charts repository also contains a `values.yaml` file in the root of the project that overrides several values and sets up some default values. You should not edit these files directly. Instead, let's create a new YAML file where you can override these configurations, and provide some of the required configurations for the installation.

`cp config.tpl.yaml config.yaml`

You now have a file named `config.yaml` where you can make any configuration changes you need to. This file will contain keys for required fields, but any configuration can be overridden. Check out the root `values.yaml` file to get a feel for the structure of this file.

## Namespace

Although this is not a strict requirement, we typically recommend that you create an isolated namespace for the Astronomer Platform to live inside.

`kubectl create namespace astronomer`

## DNS

By default, the Astronomer Platform will only be accessible from within the Kubernetes cluster. In a production environment, you'll most likely want to securely expose the various web interfaces to the internet so your team can collaborate on the platform. To do this you'll probably want to assign the platform a domain name that you own, so your users don't have to remember an IP address. On GCP, you can create a static IP address with the following command:

`gcloud compute addresses create ${CLUSTER_NAME}-external-ip --region ${REGION} --project ${PROJECT}`

To view the newly created IP address run this command:

`gcloud compute addresses describe ${CLUSTER_NAME}-external-ip --region ${REGION} --project ${PROJECT} --format='value(address)'`

Copy this value and populate `global.loadBalancerIP` in your `config.yaml` file.

Now that you have a static IP address, you'll need to set up your DNS nameserver with some entries. Depending on your set up you can do one of two things here. You can either set up a wildcard A record or create individual A records for each subdomain. If nothing else is running on the domain you choose, you can quickly and easily set up a wildcard A record to point to your IP address. If you already have other services running on your domain, you can create individual records for the various services. You can create A records for any or all of the following subdomains: `registry.yourdomain`, `airflow.yourdomain`, `flower.yourdomain`, `prometheus.yourdomain`, and `grafana.yourdomain`.

Once you've chosen the domain where you will be hosting the services, update `global.baseDomain` in your `config.yaml`. For example, if you entered `mycompany.io` as the `baseDomain`, your airflow UI will be available at `airflow.mycompany.io`.

## Secrets

The Astronomer Platform requires several secrets to be in place before installation. At a minimum, you will need to create secrets that contain database connection strings. Optionally, you can provide a secret for TLS certificates so you can accesss the platform securely over HTTPS. If you are new to Kubernetes or secrets, you may want to check out [this guide](https://kubernetes.io/docs/tasks/inject-data-application/distribute-credentials-secure/) for a quick primer.

### Connection Strings

All connection strings should be created with a `connection` key that contains the actual connection string. We typically recommend Postgres for the relational data, and Redis for the Celery task queue. You'll need to ensure that the databases specified here exist prior to deployment. The examples here use the `--from-literal` form but you can just as easily create the secrets from txt files. If you do use the `--from-literal` form, the secrets will most likely be hanging around in your shell's history, which could be a security concern. The following commands are using the default secret names specified in the root `values.yaml`. If you change the names, make sure you update your `config.yaml` file. These values are located under `airflow.data`. Also, don't forget to switch your `kubectl` default context to the namespace you created earlier, or specify the namespace with the `--namespace` flag.

First, let's create a secret for the Airflow metadata.

`kubectl create secret generic airflow-metadata --from-literal connection='postgresql://username:password@host:port/database' --namespace astronomer`

Next, let's create a secret for the Celery result backend. This only creates two additional tables, so we typically reuse the same database as the Airflow metadata. Note the `db+` prefix on this version.

`kubectl create secret generic airflow-result-backend --from-literal connection='db+postgresql://username:password@host:port/database' --namespace astronomer`

Now, let's create a secret for the Airflow task queue broker. Note that if you are using redis, the database name is an integer between 0 and 15.

`kubectl create secret generic airflow-broker --from-literal connection='redis://username:password@host:port/database' --namespace astronomer`

Finally, let's create a secret for Grafana. We recommend a separate database on the same server for this data. Note that Grafana expects yet another form of the postgres scheme, different from the first two.

`kubectl create secret generic grafana-backend --from-literal connection='postgres://username:password@host:port/database' --namespace astronomer`

### TLS

The Astronomer Platform requires secure connections when accessing it's sevices over the public internet. To do this, you will need to polulate one more secret with your TLS key and certificate.

#### Existing Certificate

If you already have a wildcard certificate for the domain you are running under, then you can create the secret by running this command, specifying the absolute paths to the files on your system.

`kubectl create secret tls astronomer-tls --key domain.key --cert domain.crt --namespace astronomer`

You can name the secret whatever you want. Just make sure to update the `global.tlsSecret` value in your `config.yaml` if you change it.

#### Let's Encrypt

If you do not already have a valid certificate, and do not want to purchase one, you can use the free service, [Let's Encrypt](https://letsencrypt.org/). [Kube-lego](https://github.com/jetstack/kube-lego) is a project that you can deploy into your cluster that will take care of registering with Let's Encrypt and populating the secret with a TLS certificate for you. You can deploy it using the following command:

```
helm install \                   
--set=config.LEGO_EMAIL=${YOUR_EMAIL_ADDRESS} \
--set=config.LEGO_URL="https://acme-v01.api.letsencrypt.org/directory" \
--set=config.LEGO_LOG_LEVEL=debug \
--set=rbac.create=true \
--set=image.tag=canary \
--namespace=astronomer \
stable/kube-lego
```

Be sure to add your email address before deploying. Let's Encrypt has rate limits that an easily be hit if you are not careful. They have a staging service that you can use to test with before deploying using the production service, as shown above. Check out the kube-lego documentation for more information.

If you do decide to go with Let's Encrypt, be sure to update the `global.acme` value to `true` in your `config.yaml`.

#### Authentication
Currently, the Astronomer Platform uses basic authentication and a single user. This will be changing very soon to support full role-based authentication.

To get started, we'll need to create a file that contains the user information. To do this we'll need the `htpasswd` utility. You should be able to install it using your system's package manager. It's usually part of a larger package called `apache-tools` or `apache2-utils` or something similar. Once you have that installed, run the following command to create a file, `auth`, with a single user. You will be prompted to enter a password.

`htpasswd -c auth ${USERNAME}`

Now, let's create the secret from that file. If you change the name of the secret, be sure to update `base.nginxAuthSecret` in your `config.yaml`.

`kubectl create secret generic nginx-auth --from-file auth --namespace astronomer`


Finally, we need to create a secret to give Kubernetes access to pull images from the private registry. The username and password here should match what was entered in the previous command.

`kubectl create secret docker-registry registry-auth --docker-server registry.${YOUR_DOMAIN} --docker-username ${USERNAME} --docker-password ${PASSWORD} --docker-email ${YOUR_EMAIL} --namespace astronomer`

## Installation

Now that we have everything in place, we can deploy the Astronomer Platform to your cluster. All you need to do is run `helm install`, and specify your configuration file.

`helm install -f config.yaml --namespace astronomer .`

If you recieve any weird errors from helm, you may need to give Tiller access to the Kubernetes API. Check out [our post](/guides/helm) on setting helm up with the proper permissions.

## Test

If everything went according to plan, you should be able to check the following URL's in your browser:
* https://airflow.yourdomain
* https://flower.yourdomain
* https://prometheus.yourdomain
* https://grafana.yourdomain
* https://registry.yourdomain/v2/_catalog

## Deploy an Airflow DAG

COMING SOON!