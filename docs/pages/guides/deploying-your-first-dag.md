---
layout: page
title: Deploying Your First DAG to Astronomer Enterprise
permalink: /guides/deploying-your-first-dag/
hide: true
---



# Objective 
You have created and tested your Airflow DAG locally via the [astro-cli](https://github.com/astronomerio/astro-cli){:target="_blank"}. This guide will show you how to deploy a DAG to your Astronomer EE cluster.

## Requirements
Guide requirements are
- [Astronomer EE](http://enterprise.astronomer.io/){:target="_blank"} deployed
- [astro-cli](https://github.com/astronomerio/astro-cli){:target="_blank"} installed
- [An Astronomer EE Airflow Project](http://enterprise.astronomer.io/guides/creating-an-airflow-project/index.html){:target="_blank"} you want to push to your cluster

## Configuration
Before we deploy there are just a few settings you will need to supply. You can do so either via the CLI or modifying the `.astro/config.yaml` file directly. In order to configure these settings manually in the configuration file, create the setting under the same namespace pointed to by the dot notation in the CLI command.

Ex.

```bash
astro config set project.name my-first-project
```
This bash command would map to the project.name namespace in `config.yaml`.

```yaml
project
    name: my-first-project
```

One last thing to note is that supplying these configurations is only temporary until [houston-api](https://github.com/astronomerio/houston-api){:target="_blank"} is integrated with the platform.

### Specifying your Repository
The first setting we need to configure is the location of your private Docker registry. This houses all Docker images pushed to your Astronomer EE deploy. By default it is located at `registry.[baseDomain]`. If you are unsure about which domain you deployed Astronomer EE to, you can refer back to the `baseDomain` in your [`config.yaml`](http://enterprise.astronomer.io/guides/google-cloud/index.html#configuration-file){:target="_blank"}.

Run the following command from your project root directory...
```bash
astro config set docker.registry.authority registry.[baseDomain]
```

### Specifying Registry Auth
Now that you have made the CLI aware of your private Docker registry, you will need to provide the credentials your CLI will use to authenticate. If you are unsure about these credentials, they were configured when you created the `registry-auth` [secret](http://enterprise.astronomer.io/guides/google-cloud/index.html#secrets){:target="_blank"} during your Astronomer EE install. 

First set your registry user...
```bash
astro config set docker.registry.user [registry_user]
```

Next you can set your registry password...
```bash
astro config set docker.registry.password [registry_password]
```

## Deployment
We have now configured the astro-cli to point at your Astronomer EE deploy and are ready to push your first DAG. You will need the release name of your Astronomer EE deployment. This release name was created by the Helm package manager during your Astronomer EE deploy. If you are unsure of what release name was created for your deploy, you can run `helm ls` to get a list of all Helm releases and find the one that has an "Updated" timestamp corresponding to the time at which you deployed Astronomer EE. If it is still unclear which Helm release you should deploy to, it is best to contact your cluster Administrator.

```bash
astro airflow deploy [release-name]
```

After running this command you will see some stdout as the CLI builds and pushes images to your private registry. After a deploy, you can view your updated instance. If using the default install this will be located at airflow.[baseDomain].
