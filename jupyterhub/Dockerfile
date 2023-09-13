FROM jupyterhub/jupyterhub:4

# cwd /srv/jupyterhub, recall jupyterhub loads config from cwd.
COPY utils.sh /etc/profile.d/
SHELL ["/bin/bash", "--login", "-c"] 

ARG EXCHANGE_ROOT="/usr/local/share/nbgrader/exchange"
RUN setup_directory ${EXCHANGE_ROOT} ugo+rwx

# config directory is /srv/jupyterhub
RUN pip install nbgrader==0.8.4
RUN pip install dockerspawner

RUN make_user student1
RUN make_user instructor1
RUN make_user grader-course101

# configure local nbgrader config file
# the grader account runs the starter nbgrader commands 
# and his home directory contains the course files and the nbgrader config
COPY nbgrader_config.py /home/grader-course101/nbgrader_config.py
RUN chown -R grader-course101:grader-course101 /home/grader-course101/

# Setup grading account jupyterlab instance
USER grader-course101
COPY instructor.jupyterlab-workspace /home/grader-course101/instructor.jupyterlab-workspace
RUN jupyter lab workspaces import /home/grader-course101/instructor.jupyterlab-workspace

# create course
RUN jupyter labextension disable --level=user nbgrader:formgrader
RUN jupyter labextension enable --level=user nbgrader:formgrader
RUN jupyter server extension enable --user nbgrader.server_extensions.formgrader
WORKDIR /home/grader-course101/
RUN mkdir course101

USER root
# install scala kernel for grader
RUN apt-get -y update && \     
    apt-get install --no-install-recommends -y curl openjdk-8-jre-headless ca-certificates-java && \
    apt-get clean && \     
    rm -rf /var/lib/apt/lists/*

RUN curl -Lo /usr/local/bin/coursier https://github.com/coursier/coursier/releases/download/v2.0.0-RC3-2/coursier && \
    chmod +x /usr/local/bin/coursier

RUN /usr/local/bin/coursier --help

COPY install-kernels.sh . 
RUN chmod +x install-kernels.sh

USER grader-course101
RUN ALMOND_VERSION=0.14.0-RC12 SCALA_VERSIONS=2.12.18 ./install-kernels.sh && \
    rm install-kernels.sh && \ 
    rm -rf .ivy2

# root runs jupyterhub here
USER root
WORKDIR /srv/jupyterhub
COPY jupyterhub_config.py /srv/jupyterhub
