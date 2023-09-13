FROM almondsh/almond:0.14.0-RC12-scala-2.12.18

# ps -eO user,group,ppid,c,start_time
#RUN setup_directory "/usr/local/share/nbgrader/exchange" ugo+rwx

COPY nbgrader_config.py /etc/jupyter/nbgrader_config.py
COPY jupyter_server_config.py /etc/jupyter/jupyter_server_config.py
COPY student.jupyterlab-workspace /home/jovyan
RUN jupyter lab workspaces import /home/jovyan/student.jupyterlab-workspace
RUN pip install nbgrader==0.8.4

# disable non student extensions
RUN jupyter labextension disable nbgrader/formgrader
RUN jupyter labextension disable nbgrader/course-list
RUN jupyter labextension disable nbgrader/create-assignment

# disable jupyterlab bloat
RUN jupyter labextension disable @jupyterlab/debugger-extension
RUN jupyter labextension disable @jupyterlab/application-extension:property-inspector
RUN jupyter labextension disable @jupyterlab/apputils-extension:notification
RUN jupyter labextension disable @jupyterlab/statusbar-extension:plugin
RUN jupyter labextension disable @jupyterlab/extensionmanager-extension:plugin

# disable table of contents bloat
RUN jupyter labextension disable @jupyterlab/notebook-extension:toc
RUN jupyter labextension disable @jupyterlab/toc

# disable running sessions manager
RUN jupyter labextension disable @jupyterlab/running-extension:plugin

EXPOSE 8888