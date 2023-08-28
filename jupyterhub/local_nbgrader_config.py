c = get_config()

c.CourseDirectory.root = '/home/grader-course101/course101'

c.ClearSolutions.begin_solution_delimeter = "BEGIN SOLUTION"
c.ClearSolutions.end_solution_delimeter = "END SOLUTION"
c.ClearSolutions.code_stub = {
    "scala": "// your code here\n throw new NotImplementedError()"
}