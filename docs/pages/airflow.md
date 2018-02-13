---
layout: page
title: Airflow
permalink: /airflow/
order: 2
---

{% include licensing.md %}

## Architecture

The Astronomer Airflow module consists of seven components, and you must bring
your own Postgres and Redis database, as well as a container deployment strategy
for your cloud.

![Airflow Module]({{ "/assets/img/airflow_module.png" | absolute_url }})

## Quickstart
If you haven't already, clone the repository by running the following: `git clone https://github.com/astronomerio/astronomer.git` and change into the repository directory.

To get up and running quickly and poke around with Apache Airflow on Astronomer, pop open a terminal and run `cd examples/airflow && docker-compose up`. This will spin up a handful of containers to closely mimic a live Astronomer environment.

First, we spin up a [Postgres](https://www.postgresql.org/) container for the Airflow metadata database, and a [Redis](https://redis.io/) container to back [Celery](http://www.celeryproject.org/), which Airflow will use for its task queue. Once the storage containers have started, we start the Airflow Scheduler, Airflow Webserver, a Celery worker, and the [Flower UI](http://flower.readthedocs.io/en/latest/) to monitor the Celery task queue. Once everything is up and running, open a browser tab and visit http://localhost:8080 for the Airflow UI and http://localhost:5555 for the Celery UI.

Sweet! You're up and running with Apache Airflow and well on your way to automating all your data pipelines! The following sections will help you get started with your first pipelines, or get your existing pipelines running on the Astronomer Platform.

## Starting from Nothing
You need to write your first DAG. Review:

* [Core Airflow Concepts](https://docs.astronomer.io/v2/apache_airflow/tutorial/core-airflow-concepts.html)
* [Simple Sample DAG](https://docs.astronomer.io/v2/apache_airflow/tutorial/sample-dag.html)

If you want to start with some DAGs that work out of the box, clone this repo:
* [Astronomer Sample DAGs](https://github.com/astronomerio/open-example-dags)

We recommend managing your DAGs in a Git repo.To get started, you need a directory (typically your project name) on your machine that contains a `dags` directory (if you're not using the sample dags from `open-example-dags` the link above, feel free to use the Simple Sample DAG as a file called `test_dag.py` in the `dags` folder of your project). You can place this directory anywhere on your machine.

We typically advise first testing locally on your machine, before pushing changes to your staging environment. Once fully tested you can deploy to your production instance.
When ready to commit new source or destination hooks/operators, our best practice is to commit these into separate repositories for each plugin.

For your project with custom hooks and operators, we recommend this folder structure:

```
example_project
├──dags/
|  ├──example_day.py
├──plugins/
|  ├──example_plugin/
|      ├── hooks
|      │   ├── __init__.py
|      │   └── example_hook.py
|      ├── operators
|      │   ├── __init__.py
|      │   └── example_operator.py
|      ├── README.md
|      └── __init__.py  <--- Your AirflowPlugin class instantiation
|──all_other_files
```

## Spinning up Astronomer
If you already have an Airflow project (Airflow home directory), getting things running on Astronomer is straightforward.
Within `examples/airflow`, we provide a `start` script that can wire up a few things to help you develop on Airflow quickly - just point it to your project directory:

`./start ~/repos/airflow-project`.

You'll also notice a small `.env` file next to the `docker-compose.yml` file. This file is automatically sourced by `docker-compose` and it's variables are interpolated into the service definitions in the `docker-compose.yml` file. If you run `docker-compose up`, like we did above, we mount volumes into your host machine's `/tmp` directory for Postgres and Redis. This will automatically be cleaned up for you.

This will also be the behavior if you run `./start` with no arguments.

Under the hood, a few things make this work. `Dockerfile.astro` and `.dockerignore` files are written into your project directory. And an `.astro` directory is created.
- `Dockerfile.astro` just links to a special `onbuild` version of our Airflow image that will automatically add certain files, within the `.astro` directory to the image.
- The `.astro` file will contain a `data` directory which will be used for mapping docker volumes into for Postgres and Redis. This lets you persist your current Airflow state between shutdowns. These files are automatically ignored by `git`.
- The `.astro` directory will also contain a `requirements.txt` file that you can add python packages to be installed using `pip`. We will automatically build and install them when the containers are restarted.
- In some cases, python modules will need to compile native modules and/or rely on other package that exist outside of the python ecosystem. In this case, we also provide a `packages.txt` file in the `.astro` directory, where you can add [Alpine packages](https://pkgs.alpinelinux.org/packages). The format is similar to `requirements.txt`, with a package on each line. If you run into a situation where you need more control or further assistance, please reach out to humans@astronomer.io.

With this configuration, you can point the `./start` script at any Airflow home directory and maintain distinct and separate environments for each, allowing you to easily test different Airflow projects in isolation.


## Limitations

### HDFS hook not supported

Astronomer is built on the latest stable versions of everything, including Python 3.

**With that said, we currently do not support using Airflow's HDFS hook and operators which use it (we `pip uninstall snakebite` in our dockerfile).**

The `HDFSHook` [depends on](https://github.com/apache/incubator-airflow/blob/b75367bb572e8bbfc1bfd539fbb34a76a5ed484d/setup.py#L129) the package spotify/snakebite which does not support Python 3. If you are interested in that package getting Python 3 support, you can follow and comment on the issue at [snakebite #62](https://github.com/spotify/snakebite/issues/62). In the comments, Spotify engineers have stated that the compatibility issue is due to their library's dependency on protobuf 2.x which doesn't support Python 3.

You can read more info on this issue at:

- [https://issues.apache.org/jira/browse/AIRFLOW-1316](https://issues.apache.org/jira/browse/AIRFLOW-1316)
- [https://github.com/apache/incubator-airflow/pull/2398](https://github.com/apache/incubator-airflow/pull/2398)
- [https://github.com/puckel/docker-airflow/issues/77](https://github.com/puckel/docker-airflow/issues/77)

One workaround you may consider to work with HDFS is putting calls inside in a Docker container running Python 2 and using Airflow's `DockerOperator`. If this solution doesn't work for you, please contact us and we'd be happy to discuss further.
