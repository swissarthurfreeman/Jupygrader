c = get_config()

# note, by default nbgrader is using /usr/local/share/nbgrader/exchange/course101/outbound|inbound
# as a exchange directory. This appears to work automatically, hopefully it won't break in the future...

c.CourseDirectory.course_id = "course101"
c.CourseDirectory.root = '/home/grader-course101/course101'

c.ClearSolutions.begin_solution_delimeter = "BEGIN SOLUTION"
c.ClearSolutions.end_solution_delimeter = "END SOLUTION"
c.ClearSolutions.code_stub = {
    "scala": "// your code here\n throw new NotImplementedError()"
}