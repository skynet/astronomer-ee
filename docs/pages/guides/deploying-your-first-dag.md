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

## Creating Your Project
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

### Project Initialization
Now that you are in your project directory, you will need to initialize the project. This command will scaffold out the needed files and default configuration for your project.

```bash
astro airflow init
```

You will now see the following files and folders

```
- .astro/
- .dockerignore
- Dockerfile
- dags/
- include/
- packages.txt
- plugins/
- requirements.txt
```

## Importing Your Project

You have initialized your Astronomer Airflow project and now you can begin to build your project from scratch or import and existing one.

### DAGs
Directed acyclic graphs (DAG) are the configuration for your workflows and a core component of an Airflow Project. If you are migrating an existing Airflow project you likely have several DAG files you wish to import. You can place all DAG files into the `dags/` directory. They will be importing to your docker image when you deploy or test locally. This directory gets added to your docker image in the `$AIRFLOW_HOME` directory.

### Plugins
The [Airflow Plugin](https://airflow.apache.org/plugins.html) system can be used to make managing workflow logic easier or even expand the funcionality of Airflow itself. If you have any plugin requirements or would like to bring in a plugin from [airflow-plugins](https://github.com/airflow-plugins), they can be put into the `plugins/` project directory. As in the case of the `dags/` directory,  this directory will get added to your docker image in the `$AIRFLOW_HOME` directory.

### Requirements
In order to keep our images lightweight, we ship with only the [Python standard lib](https://docs.python.org/3/library/index.html). When you find yourself needing modules not included in the standard lib, you can use `requirements.txt`. You requirements file can be used to add additional Python requirements in the same way a standard [Python requirements](https://pip.readthedocs.io/en/1.1/requirements.html) file works.


























### File and Folder Description
This section contains a brief description of various files and folders that were created in the previous section.
#### ./astro
This hidden folder houses the `config.yaml` file for your project. You should never have to interface with this folder or it's contents directly.
#### .dockerignore
The [.dockerignore](https://docs.docker.com/engine/reference/builder/#dockerignore-file) file is used to avoid adding extraneous contents to the docker image.
#### Dockerfile
A standard [Dockerfile](https://docs.docker.com/engine/reference/builder/). It can be modified to customize your Airflow image as needed.
#### dags/
#### include/
#### packages.txt
#### plugins/
#### requirements.txt



