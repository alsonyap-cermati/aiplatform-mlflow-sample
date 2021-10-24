# Cermati / Indodana - AI Platform + MLflow Sample Code

This repository will host the sample code for the Medium article that describes how to train ML models using MLflow and GCP AI Platform.

## Getting Started
These are the steps necessary to get started using the code.

### Prequisites

- [x] [Git](https://git-scm.com/) installed.
- [x] [Docker](https://www.docker.com/) installed.
- [x] [MLflow Tracking Server](https://mlflow.org/) set up with a public URL, remote backend database and remote GCS storage.
- [x] [GCP Google Container Registry](https://cloud.google.com/container-registry) enabled and authenticated with Docker on local machine.
- [x] [AI Platform](https://docs.conda.io/en/latest/) API enabled and able to submit job via `gcloud` from local machine.

### Quickstart

* Clone the repository to local machine
* In the `Dockerfile`, replace the `<URL>` with your public MLflow tracking server URL and `<GCP_PROJECT>` with the name of your GCP Project ID.
* In the `Makefile`, replace `<GCP_PROJECT>` with the name of your GCP Project ID.

```bash
$ git clone https://github.com/alsonyap-cermati/aiplatform-mlflow-sample.git
$ cd aiplatform-mlflow-sample
$ make build
$ make tag
$ make push
$ make -e MODEL=model_b -e GPU=True submit
```

Go into AI Platform to see the progress of the training and head to your MLflow tracking server to see the logged metrics and the saved artifacts post-training.