-- This query calculates the average salary and the number of job postings for each job title 
-- from the job_postings_fact table. It filters out records with missing salary information 
-- and groups the results by job title. Finally, it orders the results by average salary in descending order.

SELECT
    
    job_title_short,                                     -- Select the short job title for display
    AVG(salary_year_avg) AS avg_salary,                 -- Calculate the average yearly salary for each job title
    COUNT(job_id) AS job_number                          -- Count the number of job postings for each job title
FROM 
    job_postings_fact                                   -- Specify the main table containing job postings
WHERE 
    salary_year_avg IS NOT NULL                          -- Filter out job postings that do not have a specified average salary
GROUP BY 
    job_title_short                                     -- Group the results by the short job title to aggregate data
ORDER BY 
    avg_salary DESC                                     -- Order the results by average salary in descending order, showing highest salaries first

/*Results
[
  {
    "job_title_short": "Senior Data Scientist",
    "avg_salary": "154050.031829218565",
    "job_number": "1686"
  },
  {
    "job_title_short": "Senior Data Engineer",
    "avg_salary": "145866.871765213300",
    "job_number": "1594"
  },
  {
    "job_title_short": "Data Scientist",
    "avg_salary": "135929.476302786450",
    "job_number": "5926"
  },
  {
    "job_title_short": "Data Engineer",
    "avg_salary": "130266.870366905079",
    "job_number": "4509"
  },
  {
    "job_title_short": "Machine Learning Engineer",
    "avg_salary": "126785.905759162304",
    "job_number": "573"
  },
  {
    "job_title_short": "Senior Data Analyst",
    "avg_salary": "114104.053272692138",
    "job_number": "1132"
  },
  {
    "job_title_short": "Software Engineer",
    "avg_salary": "112777.641674440299",
    "job_number": "469"
  },
  {
    "job_title_short": "Cloud Engineer",
    "avg_salary": "111268.453846153846",
    "job_number": "65"
  },
  {
    "job_title_short": "Data Analyst",
    "avg_salary": "93875.788390364726",
    "job_number": "5463"
  },
  {
    "job_title_short": "Business Analyst",
    "avg_salary": "91071.043481564019",
    "job_number": "617"
  }
]
*/