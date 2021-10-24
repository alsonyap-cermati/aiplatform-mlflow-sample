# Use nvidia/cuda image
FROM nvidia/cuda:11.4.1-cudnn8-runtime-ubuntu18.04

ARG HOME=/home
ARG CONDA_ENV_NAME=container

# set bash as current shell
RUN chsh -s /bin/bash
SHELL ["/bin/bash", "-c"]

# Install Conda
RUN apt-get update
RUN apt-get install -y wget git python3-dev && \
    apt-get clean
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py38_4.8.3-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    find /opt/conda/ -follow -type f -name '*.a' -delete && \
    find /opt/conda/ -follow -type f -name '*.js.map' -delete && \
    /opt/conda/bin/conda clean -afy

# set path to conda
ENV PATH /opt/conda/bin:$PATH

# Setup conda virtual environment
COPY container.yaml .
RUN conda env create -f container.yaml

# Set mlflow as default environment
RUN echo "conda activate ${CONDA_ENV_NAME}" >> ~/.bashrc
ENV PATH /opt/conda/envs/${CONDA_ENV_NAME}/bin:$PATH
ENV CONDA_DEFAULT_ENV $${CONDA_ENV_NAME}
RUN conda clean -ay

# Copy folders over
COPY model_a ${HOME}/model_a
COPY model_b ${HOME}/model_b

# Set home directory
WORKDIR ${HOME}

ENV MLFLOW_TRACKING_URI=<URL>
ENV GCLOUD_PROJECT=<GCP_PROJECT>

ENTRYPOINT ["mlflow", "run"]
