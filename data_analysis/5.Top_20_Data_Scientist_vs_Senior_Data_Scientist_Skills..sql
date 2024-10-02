-- This query ranks the top 20 skills in demand for Data Scientist and Senior Data Scientist roles.
-- It first calculates the demand for specific skills by counting their occurrences in job postings 
-- for the specified job titles. Then, it aggregates this demand data to differentiate between 
-- the two roles and ranks the skills accordingly.

WITH SkillDemand AS (
    SELECT 
        sd.skills,  -- Select skill names from the skills_dim table.
        COUNT(sjd.job_id) AS demand_count,  -- Counts occurrences of each skill in job postings to determine demand.
        jp.job_title_short  -- Select job title to filter by 'Data Scientist' and 'Senior Data Scientist'.
    FROM 
        job_postings_fact jp  -- Main table containing job postings data.
    INNER JOIN 
        skills_job_dim sjd ON jp.job_id = sjd.job_id  -- Joins with skills_job_dim.
    INNER JOIN 
        skills_dim sd ON sjd.skill_id = sd.skill_id  -- Joins with skills_dim to get skill names.
    WHERE 
        jp.job_title_short IN ('Data Scientist', 'Senior Data Scientist')  -- Filters for specified job titles.
    GROUP BY 
        sd.skills, jp.job_title_short  -- Groups by skill names and job titles.
),
AggregatedDemand AS (
    SELECT
        skills,
        MAX(CASE WHEN job_title_short = 'Data Scientist' THEN demand_count END) AS "Data Scientist Demand Count",  -- Maximum demand count for Data Scientist.
        MAX(CASE WHEN job_title_short = 'Senior Data Scientist' THEN demand_count END) AS "Senior Data Scientist Demand Count"  -- Maximum demand count for Senior Data Scientist.
    FROM 
        SkillDemand  -- Use the results of the SkillDemand CTE.
    GROUP BY 
        skills  -- Groups the final results by skill names.
)

SELECT 
    ROW_NUMBER() OVER (ORDER BY 
        CASE WHEN "Data Scientist Demand Count" IS NULL THEN 1 ELSE 0 END,  -- Sort NULLs last
        "Data Scientist Demand Count" DESC,  -- Then by demand count in descending order
        "Senior Data Scientist Demand Count" DESC  -- Finally by Senior Data Scientist demand count
    ) AS global_rank,  
    skills,  
    "Data Scientist Demand Count",  
    "Senior Data Scientist Demand Count"
FROM 
    AggregatedDemand  -- Use the results of the AggregatedDemand CTE.
ORDER BY 
    CASE WHEN "Data Scientist Demand Count" IS NULL THEN 1 ELSE 0 END,  -- Sort NULLs last
    "Data Scientist Demand Count" DESC, 
    "Senior Data Scientist Demand Count" DESC  -- Orders by demand counts.
LIMIT 20;  -- Limits to the top 20 skills based on demand counts.



/* RESULTS

[
  {
    "global_rank": "1",
    "skills": "python",
    "Data Scientist Demand Count": "114016",
    "Senior Data Scientist Demand Count": "25996"
  },
  {
    "global_rank": "2",
    "skills": "sql",
    "Data Scientist Demand Count": "79174",
    "Senior Data Scientist Demand Count": "18661"
  },
  {
    "global_rank": "3",
    "skills": "r",
    "Data Scientist Demand Count": "59754",
    "Senior Data Scientist Demand Count": "12772"
  },
  {
    "global_rank": "4",
    "skills": "sas",
    "Data Scientist Demand Count": "29642",
    "Senior Data Scientist Demand Count": "6292"
  },
  {
    "global_rank": "5",
    "skills": "tableau",
    "Data Scientist Demand Count": "29513",
    "Senior Data Scientist Demand Count": "5959"
  },
  {
    "global_rank": "6",
    "skills": "aws",
    "Data Scientist Demand Count": "26311",
    "Senior Data Scientist Demand Count": "7468"
  },
  {
    "global_rank": "7",
    "skills": "spark",
    "Data Scientist Demand Count": "24353",
    "Senior Data Scientist Demand Count": "6638"
  },
  {
    "global_rank": "8",
    "skills": "azure",
    "Data Scientist Demand Count": "21698",
    "Senior Data Scientist Demand Count": "5529"
  },
  {
    "global_rank": "9",
    "skills": "tensorflow",
    "Data Scientist Demand Count": "19193",
    "Senior Data Scientist Demand Count": "5068"
  },
  {
    "global_rank": "10",
    "skills": "excel",
    "Data Scientist Demand Count": "17601",
    "Senior Data Scientist Demand Count": "3285"
  },
  {
    "global_rank": "11",
    "skills": "java",
    "Data Scientist Demand Count": "16314",
    "Senior Data Scientist Demand Count": "3135"
  },
  {
    "global_rank": "12",
    "skills": "power bi",
    "Data Scientist Demand Count": "15744",
    "Senior Data Scientist Demand Count": "2788"
  },
  {
    "global_rank": "13",
    "skills": "hadoop",
    "Data Scientist Demand Count": "15575",
    "Senior Data Scientist Demand Count": "3534"
  },
  {
    "global_rank": "14",
    "skills": "pytorch",
    "Data Scientist Demand Count": "15075",
    "Senior Data Scientist Demand Count": "4386"
  },
  {
    "global_rank": "15",
    "skills": "pandas",
    "Data Scientist Demand Count": "14866",
    "Senior Data Scientist Demand Count": "3614"
  },
  {
    "global_rank": "16",
    "skills": "git",
    "Data Scientist Demand Count": "12285",
    "Senior Data Scientist Demand Count": "2963"
  },
  {
    "global_rank": "17",
    "skills": "scikit-learn",
    "Data Scientist Demand Count": "11636",
    "Senior Data Scientist Demand Count": "3244"
  },
  {
    "global_rank": "18",
    "skills": "numpy",
    "Data Scientist Demand Count": "10818",
    "Senior Data Scientist Demand Count": "2510"
  },
  {
    "global_rank": "19",
    "skills": "scala",
    "Data Scientist Demand Count": "10416",
    "Senior Data Scientist Demand Count": "2856"
  },
  {
    "global_rank": "20",
    "skills": "gcp",
    "Data Scientist Demand Count": "8736",
    "Senior Data Scientist Demand Count": "2618"
  }
]


*/