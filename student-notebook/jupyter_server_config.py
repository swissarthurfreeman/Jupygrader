# allows configuring the jupyter_server backend that the frontend 
# of jupyterlab interacts with. 
# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.

c = get_config()

c.ServerApp.ip = '0.0.0.0'
c.ServerApp.port = 8888   # same as is exposed in almond.sh
c.ServerApp.open_browser = False
c.ServerApp.terminals_enabled = False

# shutdown kernels after no activity for 15 minutes
c.MappingKernelManager.cull_idle_timeout = 15 * 60
# check for idle kernels every two minutes
c.MappingKernelManager.cull_interval = 2 * 60

#Blocking other kernels
#c.KernelSpecManager.ensure_native_kernel = False
#c.KernelSpecManager.whitelist = {'scala213'}

# https://github.com/jupyter/notebook/issues/3130
c.FileContentsManager.delete_to_trash = False
#c.ContentsManager.hide_globsList = [u'__pycache__', '*.pyc', '*.pyo','.DS_Store', '*.so', '*.dylib', '*~','*.ipynb','*.md']
  
