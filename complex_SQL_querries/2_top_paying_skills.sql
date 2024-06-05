/* Building on the foundation ofthe above quarry the following questions are  acquired.:
    1.What are the top-paying jobs for my role?
    2.What are the skills required for these top-paying roles?
    3.What are the top skills based on salary for me role?
    4.What are the top skills baed on salary for my role?
    5.What are the most optimal skills to learn?
        a, Optimal: High Demand AND High paying.
*/
--wegonna need to use a CTE cause of the complexity of the quetions.
--we wont really need the location, schedule_type, and posted_date

WITH  top_paying_jobs_result_set AS (
SELECT
    job_id,
    job_title,
    salary_year_avg,
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
LIMIT 10
)

SELECT
        top_paying_jobs_result_set.*,
        skills
FROM top_paying_jobs_result_set
INNER JOIN skills_job_dim ON top_paying_jobs_result_set.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY 
    salary_year_avg DESC
    limit 10;

/* Thats the optional questions with using CHAT GPT.
After we  got this result we ran uploaded it to CHATGPT to anaylze for it.
and it gave us the following findings: 
SQL is the leading bith bold count of 8.
Python follows closely with ta bold count of 7.
Tableu is also a highly sought after , with a bold count of 6.
Other skills like R, Snowflake, pandas and excel show varying degrees of demand. */

/*Questions to Answer phase 3
1.What are the top paying jobs for my role
2.what are the skills required for these toppaying roles?
3. What are the most in-deamnd skills form y rolke?
4.What are the top skills based on salary for my role?
5.what are the most optimal skills to learn?
    a. Optimal: high Demand AND High Paying. ..... */

/*Find t he Coun of the number of remote job postings per skill
    -display the top 5 skills by ttheir demand in remote jobs
    -Include skill ID, name and count of postings requiring the skill */


WITH remote_job_skills AS (
    
    SELECT
        skill_id,
        COUNT(*) as skill_count
    FROM
        skills_job_dim AS skills_to_job
    INNER JOIN job_postings_fact AS job_postings
    ON job_postings.job_id = skills_to_job.job_id
    WHERE job_postings.job_work_from_home = True AND
            job_postings.job_title_short = 'Data Analyst'
    Group by 
        skill_id
)
SELECT
    skills.skill_id,
    skills as skill_name,
    skill_count
FROM remote_job_skills
INNER JOIN skills_dim as skills ON skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5;



