---
layout: page
title: Deploying Your First DAG to Astronomer Enterprise
permalink: /guides/deploying-your-first-dag/
hide: true
---

{% include licensing.md %}

# Objective 
You have successfully setup and deployed [Astronomer EE](https://enterprise.astronomer.io/guides/google-cloud/), now it is time to setup a project and deploy your first DAG.


## Requirements
Guide requirements are
- Astronomer EE with TLS Enabled
- [astro-cli](https://github.com/astronomerio/astro-cli) installed
- an [Airflow DAG](https://airflow.incubator.apache.org/concepts.html#dags) you wish to deploy
    - If you don't have a DAG at this time, that's okay, we suggest picking out an [example-dag](https://github.com/airflow-plugins/Example-Airflow-DAGs) from our [airflow-plugins](https://github.com/airflow-plugins) repository.

## Initializing Your Project
Before deploying your first DAG you will need to intialize your Astronomer EE Airflow project.

### Creating A Project Directory
Create a project directory in your desired root directory. 

Change into the root development directory on your machine. This is often the directory where you have chose to house various development respositories on your computer. If you don't have one yet, don't worry, we suggest creating a "dev" directory in your home path `~/dev/`.

```bash
cd [EXAMPLE_ROOT_DEV_DIR]
```

Create a project directory. This directory name will become the name of your Astronomer EE Project. The best project names will indicate the department (or if you're lean like us, the organization) and the purpose of the project. Using this example, Astronomer may then name their project `astronomer-airflow`. 

```bash
mkdir [EXAMPLE_PROJECT_NAME]
```

Change into the newly created project directory
```bash
cd [EXAMPLE_PROJECT_NAME]
```


