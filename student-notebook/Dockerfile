FROM almondsh/almond:0.14.0-RC12-scala-2.12.18

# ps -eO user,group,ppid,c,start_time
#RUN setup_directory "/usr/local/share/nbgrader/exchange" ugo+rwx

COPY global_nbgrader_config.py /etc/jupyter/nbgrader_config.py
COPY jupyter_server_config.py /etc/jupyter/jupyter_server_config.py
RUN pip install nbgrader

# disable non student extensions
RUN jupyter labextension disable --level=sys_prefix nbgrader:formgrader
RUN jupyter labextension disable --level=sys_prefix nbgrader:course-list
RUN jupyter labextension disable --level=sys_prefix nbgrader:create-assignment

EXPOSE 8888
