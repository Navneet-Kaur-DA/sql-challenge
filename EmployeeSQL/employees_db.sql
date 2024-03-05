-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/k3JHtI
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


DROP TABLE if exists departments;
DROP TABLE if exists dept_emp;
DROP TABLE if exists dept_manager;
DROP TABLE if exists employees;
DROP TABLE if exists salaries;
DROP TABLE if exists titles;


--ALTER DATABASE TO CHANGE THE DATESTYLE SO THAT THERE WOULD BE NO ERROR WHILE IMPORITNG CSV FILE
ALTER DATABASE "employees_DB" SET datestyle TO "ISO, MDY";
--

CREATE TABLE "employees" (
    "emp_no" INTEGER   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR(255)   NOT NULL,
    "last_name" VARCHAR(255)   NOT NULL,
    "sex" VARCHAR(10)   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR(10)   NOT NULL,
    "emp_no" INTEGER   NOT NULL,
    CONSTRAINT "pk_dept_manager" PRIMARY KEY (
        "dept_no","emp_no"
     )
);

CREATE TABLE "titles" (
    "title_id" VARCHAR(10)   NOT NULL,
    "title" VARCHAR(255)   NOT NULL,
    CONSTRAINT "pk_titles" PRIMARY KEY (
        "title_id"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INTEGER   NOT NULL,
    "salary" INTEGER   NOT NULL,
    CONSTRAINT "pk_salaries" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INTEGER   NOT NULL,
    "dept_no" VARCHAR(10)   NOT NULL,
    CONSTRAINT "pk_dept_emp" PRIMARY KEY (
        "emp_no","dept_no"
     )
);

CREATE TABLE "departments" (
    "dept_no" VARCHAR(10)   NOT NULL,
    "dept_name" VARCHAR(255)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

ALTER TABLE "employees" ADD CONSTRAINT "fk_employees_emp_title_id" FOREIGN KEY("emp_title_id")
REFERENCES "titles" ("title_id");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

-----------------------------------------------------------------------------------------------

SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM salaries;
SELECT * FROM titles;

--List the employee number, last name, first name, sex, and salary of each employee.
SELECT e.emp_no AS Employee_Number,e.last_name AS Last_Name,e.first_name AS First_Name,e.sex AS Sex,s.salary AS Salary
FROM employees e
JOIN salaries s
ON e.emp_no=s.emp_no;

--List the first name, last name, and hire date for the employees who were hired in 1986.
SELECT first_name,last_name,hire_date
FROM employees
WHERE hire_date >= '1986-01-01' and hire_date < '1987-01-01';

--List the manager of each department along with their department number,
--department name, employee number, last name, and first name.
SELECT e.first_name,e.last_name,e.emp_no,d.dept_name,dm.dept_no
FROM employees e
JOIN dept_manager dm
ON e.emp_no=dm.emp_no
JOIN departments d
ON dm.dept_no=d.dept_no;


--List the department number for each employee along with that employee’s employee number,
--last name, first name, and department name
SELECT e.first_name,e.last_name,e.emp_no,d.dept_name
FROM employees e
JOIN dept_emp de
ON e.emp_no=de.emp_no
JOIN departments d
ON de.dept_no=d.dept_no;


--List first name, last name, and sex of each employee
--whose first name is Hercules and whose last name begins with the letter B
SELECT first_name,last_name,sex
FROM employees
WHERE first_name='Hercules' AND last_name LIKE'B%';

--List each employee in the Sales department, including their employee number, last name, and first name
SELECT e.first_name,e.last_name,e.emp_no,d.dept_name
FROM employees e
JOIN dept_emp de
ON e.emp_no=de.emp_no
JOIN departments d
ON de.dept_no=d.dept_no
WHERE dept_name='Sales';

--List each employee in the Sales and Development departments, including their employee number, 
--last name, first name, and department name
SELECT e.first_name,e.last_name,e.emp_no,d.dept_name
FROM employees e
JOIN dept_emp de
ON e.emp_no=de.emp_no
JOIN departments d
ON de.dept_no=d.dept_no
WHERE dept_name='Sales'
OR dept_name='Development';

--List the frequency counts, in descending order, of all the employee last names 
--(that is, how many employees share each last name)

SELECT last_name, COUNT(last_name) As "last_name_count"
FROM employees
GROUP BY last_name
ORDER BY "last_name_count" DESC;
