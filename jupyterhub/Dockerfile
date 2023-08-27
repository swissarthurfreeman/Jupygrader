FROM jupyterhub/jupyterhub:4

# cwd /srv/jupyterhub, recall jupyterhub loads config from cwd.
COPY utils.sh /etc/profile.d/
SHELL ["/bin/bash", "--login", "-c"] 

ARG EXCHANGE_ROOT="/usr/local/share/nbgrader/exchange"
RUN setup_directory ${EXCHANGE_ROOT} ugo+rwx

# config directory is /srv/jupyterhub
RUN pip install nbgrader
RUN pip install dockerspawner

# nbgrader looks for config in /etc/jupyter
RUN setup_directory /etc/jupyter ugo+r
COPY global_nbgrader_config.py /etc/jupyter/

RUN make_user student1
RUN make_user instructor1
RUN make_user grader-course101

# configure local nbgrader config file
# the grader account runs the starter nbgrader commands 
# and his home directory contains the course files.
RUN cd /home/grader-course101 && mkdir .jupyter
COPY local_nbgrader_config.py /home/grader-course101/.jupyter/nbgrader_config.py
RUN chown -R grader-course101:grader-course101 /home/grader-course101/

# Setup grading account jupyterlab instance
COPY formgrader_workspace.json /home/grader-course101/formgrader_workspace.json
RUN chown grader-course101:grader-course101 /home/grader-course101/formgrader_workspace.json
RUN jupyter lab workspaces import /home/grader-course101/formgrader_workspace.json

USER grader-course101
WORKDIR /home/grader-course101/
RUN nbgrader quickstart course101

# root runs jupyterhub here
USER root
WORKDIR /srv/jupyterhub
COPY jupyterhub_config.py /srv/jupyterhub
