
--SELECT *,salary > 5000 AS low_salary FROM employees;

--SELECT *, salary * 10 AS might_be FROM employees;

--CREATE VIEW up_test AS SELECT *, salary > 5000 AS low_salary, salary * 10 AS might_be FROM employees;

--UPDATE up_test SET might_be=30;

--SELECT salary fROM employees ORDER BY salary DESC, last_name DESC, first_name DESC OFFSET 2 LIMIT 3;


--CREATE VIEW rich_employees AS SELECT salary fROM employees ORDER BY salary DESC, last_name DESC, first_name DESC OFFSET 2 LIMIT 3;
--SELECT * FROM employees WHERE salary IN (table rich_employees);

SELECT * FROM employees WHERE job_id=(SELECT job_id FROM jobs WHERE job_title='President');
