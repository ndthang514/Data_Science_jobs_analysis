/*
Question: What are the top-paying jobs for data analyst?
    -Identify the top 10 highest-paying Data analyst role that are available remotely.
    -Focuses on job postings with specific salaries ( remove nulls).
    -Why? highlght the top-paying opportunities for Data analsts, offering insights into
    employmmeny opportunites
*/

--Querry

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    job_posted_date,
    name as company_name

FROM 
    job_postings_fact
LEFT JOIN company_dim
    ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    salary_year_avg IS NOT NULL

ORDER by salary_year_avg DESC
LIMIT 10;

/* Building on the foundation ofthe above quarry the following questions are  acquired.:
    1.What are the top-paying jobs for my role?
    2.What are the skills required for these top-paying roles?
    3.What are the top skills based on salary for me role?
    4.What are the top skills baed on salary for my role?
    5.What are the most optimal skills to learn?
        a, Optimal: High Demand AND High paying.
*/


