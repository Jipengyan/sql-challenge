
--create tables and set up keys
CREATE TABLE employees(
	emp_no INT UNIQUE NOT NULL,
	emp_title VARCHAR NOT NULL,
	birth_date DATE NOT NULL,
	first_name VARCHAR(30) NOT NULL,
	last_name VARCHAR(30) NOT NULL,
	sex VARCHAR NOT NULL,
	hire_date DATE NOT NULL,
	PRIMARY KEY(emp_no)
);

CREATE TABLE departments (
	dept_no CHAR(4) NOT NULL,
	dept_name VARCHAR(30) NOT NULL,
	PRIMARY KEY(dept_no),
	UNIQUE (dept_no)
);

CREATE TABLE dept_manager(
	dept_no CHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	FOREIGN KEY(dept_no) REFERENCES departments (dept_no),
	FOREIGN KEY(emp_no) REFERENCES employees (emp_no),
	PRIMARY KEY (dept_no, emp_no)
);

CREATE TABLE dept_emp(
	emp_no INT  NOT NULL,
	dept_no CHAR(4) NOT NULL,
	FOREIGN KEY(dept_no) REFERENCES departments(dept_no),
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no),
	PRIMARY KEY(emp_no, dept_no)
);

CREATE TABLE titles(
	title_id VARCHAR NOT NULL,
	emp_title VARCHAR NOT NULL,
	PRIMARY KEY(title_id, emp_title)
);
	
CREATE TABLE salaries(
	emp_no INT NOT NULL,
	salary INT NOT NULL,
	FOREIGN KEY(emp_no) REFERENCES employees(emp_no),
	PRIMARY KEY(emp_no)
);
	

--1. List the following details of each employee: employee number, last name, first name, sex, and salary.

SELECT employees.emp_no,
employees.last_name,
employees.first_name,
employees.sex,
salaries.salary
FROM employees
INNER JOIN salaries ON
employees.emp_no=salaries.emp_no;

--2. List first name, last name, and hire date for employees who were hired in 1986.
SELECT employees.last_name,
employees.first_name,
employees.hire_date
FROM employees
WHERE EXTRACT (YEAR FROM hire_date)= '1986';

--3. List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.
SELECT employees.emp_no,
employees.last_name,
employees.first_name,
departments.dept_name,
dept_manager.dept_no
FROM ((employees
INNER JOIN dept_manager ON
dept_manager.emp_no=employees.emp_no)
INNER JOIN departments ON
departments.dept_no=dept_manager.dept_no);

--4. List the department of each employee with the following information: employee number, last name, first name, and department name.
SELECT employees.emp_no,
employees.last_name,
employees.first_name,
departments.dept_name
FROM ((employees
INNER JOIN dept_emp ON
dept_emp.emp_no=employees.emp_no)
INNER JOIN departments ON
departments.dept_no=dept_emp.dept_no);

--5. List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
SELECT employees.last_name,
employees.first_name,
employees.sex
FROM employees
WHERE employees.first_name='Hercules' AND LEFT(last_name, 1)='B';

--6. List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT employees.emp_no,
employees.last_name,
employees.first_name,
departments.dept_name
FROM employees
INNER JOIN dept_emp ON
dept_emp.emp_no=employees.emp_no
INNER JOIN departments ON
departments.dept_no=dept_emp.dept_no
WHERE departments.dept_name='Sales';

--7. List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT employees.emp_no,
employees.last_name,
employees.first_name,
departments.dept_name
FROM employees
INNER JOIN dept_emp ON
dept_emp.emp_no=employees.emp_no
INNER JOIN departments ON
departments.dept_no=dept_emp.dept_no
WHERE departments.dept_name='Sales'OR departments.dept_name='Development'
;

--8. In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT employees.last_name, COUNT(*)
FROM employees
GROUP BY employees.last_name
ORDER BY COUNT (*) DESC
;

--Bonous 1. Import the SQL database into Pandas. 
--2. Create a histogram to visualize the most common salary ranges for employees. 
--3. Create a bar chart of average salary by title.
