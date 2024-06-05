
/*
What are the most in-dmand skills for data analysts?
-join job postings innerj oin table simiar to query 2
-identify the top 5 in-demand skills for a data analysist.
-focus on all job postings.
-Why? Retrives the top 5 skills with the highest demand in the job market,
    providing insights into the most valuable skills for job seekers.
    *** we optionally tested whether the outcome was affected by the type of home office availability.
    */

SELECT
    skills,
    COUNT(skills_job_dim.job_id) as demand_count

FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_title_short = 'Data Analyst' 
AND
    job_work_from_home = True
GROUP BY
    skills
ORDER BY demand_count DESC
limit 5;