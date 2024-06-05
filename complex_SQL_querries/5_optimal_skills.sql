/*
Answer: What are the most optimal skills to learn (aka it's in high demand and a high-paying skill)?
-Concentrates on remote positions with specified salaries.
-Why? Targets skills that offer job security (high demand) and financial benefits  (high salaries),
    offering strategic insights for  career development in data analysis.
    */


WITH skills_demand AS (
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) as demand_count           --Ambigoutiy means when you join tables, all the select clumn neds to have their correspondent table names before--> like job_dim.skill_id
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' 
AND salary_year_avg IS NOT NULL
AND job_work_from_home = True
GROUP BY
    skills_dim.skill_id
), average_salary AS (                  --Anytime you wanna group CTES together, you cant write WITH all the time, instead you need to put just a coma behind the first CTE
SELECT
    skills_job_dim.skill_id,
    ROUND(AVG(salary_year_avg)) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' 
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True
GROUP BY
    skills_job_dim.skill_id
)
--now we need to combine these CTEs , lets start to build the qquerry itself.
SELECT 
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    average_salary.avg_salary
FROM
    skills_demand
INNER JOIN average_salary
ON skills_demand.skill_id = average_salary.skill_id
WHERE demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC   
LIMIT 25;

--now if we wanna skip using CTEs we can use multiple select columns wiht aggregations, that require Group by, however we would need having for to have more than one group by
--Simplified querry.:

SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) as demand_count,
    ROUND(AVG(salary_year_avg)) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE   job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) >10
Order BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;