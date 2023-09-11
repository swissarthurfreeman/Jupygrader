c = get_config()

c.CourseDirectory.course_id = "course101"

# gets populated when assignements are released, a docker volume
# gets mounted at that location, see compose file. 
# user jupyservers see this volume thanks to dockerspawner's config
# in jupyterhub_config.py
c.Exchange.root = "/usr/local/share/nbgrader/exchange"