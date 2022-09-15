FROM frolvlad/alpine-miniconda3

WORKDIR /build

RUN conda install -y -c conda-forge bash jupyter jupyterlab jupyter_contrib_nbextensions
RUN conda install -y -c conda-forge xeus-cling xtensor