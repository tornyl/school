--1)
--SELECT jobs.job_title FROM jobs, employees WHERE jobs.job_id = employees.job_id;


--2)
--SELECT jobs.job_id, jobs.job_title FROM jobs, employees WHERE employees.job_id = jobs.job_id;


--3)

--SELECT countries.country_name, locations.city FROM countries, locations WHERE countries.country_id = locations.country_id;


--4)

--SELECT DISTINCT employees.first_name FROM employees, departments WHERE departments.department_id = employees.department_id;

--SELECT employees.employee_id, jobs.job_title FROM employees, jobs WHERE employees.job_id = jobs.job_id AND employees.salary >= jobs.min_salary AND employees.salary <= jobs.max_salary;

SELECT employees.employee_id, jobs.job_title, locations.city FROM employees, jobs, departments, locations WHERE employees.job_id = jobs.job_id AND employees.department_id = departments.department_id AND departments.location_id = locations.location_id;
