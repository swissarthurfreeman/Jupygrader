c = get_config()

c.CourseDirectory.course_id = "course101"

# gets populated when assignements are released, it'll be a mount point
# from the grader's container to that of the students.
c.Exchange.root = "/usr/local/share/nbgrader/exchange"