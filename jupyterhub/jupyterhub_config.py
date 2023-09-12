import os

c = get_config()

c.Authenticator.allowed_users = ['instructor1', 'grader-course101', 'student1']  # Our user list

c.JupyterHub.spawner_class = 'dockerspawner.DockerSpawner'
c.JupyterHub.hub_ip = os.environ['HUB_IP']
c.DockerSpawner.image = 'student:latest'

c.DockerSpawner.use_internal_ip = True
c.DockerSpawner.network_name = os.environ["DOCKER_NETWORK_NAME"]

c.DockerSpawner.volumes = {
    'jupyterhub-user-{username}': '/home/jovyan',                   # persist all home directories (grader account, students, instructors...)
    'main_exchange_volume': '/usr/local/share/nbgrader/exchange'    # volume that contains the exchange
}

# instructor1 and instructor2 have access to a shared server.
# This group *must* start with formgrade- for nbgrader to work correctly.
c.JupyterHub.load_groups = {
    'formgrade-course101': { 'users': ['instructor1', 'grader-course101'] }
}

c.JupyterHub.load_roles = [
    {
        'name': 'formgrade-course101',
        'groups': ['formgrade-course101'],
        'scopes': [
            'access:services!service=course101',
            'list:services',    # access to the services API to discover the service(s)
            f'read:services!service=course101',
        ],
    },
    {   # The class_list extension needs permission to access services
        'name': 'server',
        'scopes': ['inherit']
    },
]

c.JupyterHub.services = [               # Start the notebook server as a service.
    {                                   # the group has to match the name of the group defined above. The name of
        'name': 'course101',            # the service MUST match the name of your course.
        'url': 'http://127.0.0.1:9999',
        'command': [
            'jupyterhub-singleuser',
            '--group=formgrade-course101',
            '--debug',
        ],
        'environment': {
            # specify formgrader as default landing page
            #'JUPYTERHUB_DEFAULT_URL': '/formgrader'
        },
        'user': 'grader-course101',
        'cwd': '/home/grader-course101/',
    }
]
