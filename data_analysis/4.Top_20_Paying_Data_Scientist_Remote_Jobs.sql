-- This query ranks the top 20 highest-paying Data Scientist jobs globally.
-- It first calculates the average salary for Data Scientist roles in various locations,
-- then identifies the top jobs based on salary while providing contextual salary statistics for each job location.

WITH RankedJobs AS (
    -- CTE to rank Data Scientist jobs by average yearly salary
    SELECT	
        jp.job_id,                       -- Unique identifier for the job
        jp.job_title,                    -- Full job title
        jp.job_title_short,              -- Shortened job title (e.g., "Data Scientist")
        jp.job_location,                 -- Location of the job
        jp.job_schedule_type,            -- Schedule type (e.g., Full-time, Part-time)
        jp.salary_year_avg,              -- Average yearly salary for the job
        c.name AS company_name,          -- Name of the company offering the job

        -- Rank jobs within the same job title based on average salary
        RANK() OVER (PARTITION BY jp.job_title_short
                     ORDER BY jp.salary_year_avg DESC) AS salary_rank
    FROM
        job_postings_fact jp                -- Source table containing job postings
    LEFT JOIN company_dim c ON jp.company_id = c.company_id  -- Join with company dimension to get company name
    WHERE
        jp.job_title_short LIKE '%Data Scientist%' AND  -- Filter for Data Scientist roles
        jp.salary_year_avg IS NOT NULL AND                -- Ensure salary data is present
        jp.job_location = 'Anywhere'                      -- Filter for jobs located 'Anywhere'
),

AggregatedJobs AS (
    -- CTE to aggregate job statistics by job location
    SELECT 
        job_location,                      -- Job location
        AVG(salary_year_avg) AS data_scientist_global_avg_salary,  -- Average salary in that location
        MIN(salary_year_avg) AS data_scientist_global_min_salary,  -- Minimum salary in that location
        MAX(salary_year_avg) AS data_scientist_global_max_salary   -- Maximum salary in that location
    FROM 
        RankedJobs                         -- Source from the RankedJobs CTE
    WHERE
        job_title_short IN ('Data Scientist', 'Senior Data Scientist')  -- Filter to only include relevant job titles
    GROUP BY job_location                  -- Group results by job location
)

-- Final query to rank the top 20 highest-paying Data Scientist jobs globally.
SELECT
    ROW_NUMBER() OVER (ORDER BY rj.salary_year_avg DESC) AS global_rank,  -- Global ranking based on average salary
    rj.salary_rank,                   -- Rank within the Data Scientist category based on salary
    rj.job_id,                        -- Job ID
    rj.job_title,                     -- Full job title
    rj.job_title_short,               -- Shortened job title
    rj.job_location,                  -- Job location
    rj.job_schedule_type,             -- Schedule type for the job
    rj.salary_year_avg,               -- Average yearly salary
    rj.company_name,                  -- Name of the company offering the job
    aj.data_scientist_global_avg_salary,                    -- Average salary in that location
    aj.data_scientist_global_min_salary,                    -- Minimum salary in that location
    aj.data_scientist_global_max_salary                     -- Maximum salary in that location
FROM
    RankedJobs rj                     -- Source from the RankedJobs CTE
JOIN 
    AggregatedJobs aj ON rj.job_location = aj.job_location -- Join with aggregated job statistics
ORDER BY
    rj.salary_year_avg DESC           -- Order results by average salary in descending order
LIMIT 20;                             -- Limit the results to the top 20 highest-paying jobs

/* RESULTS

[
  {
    "global_rank": "1",
    "salary_rank": "1",
    "job_id": 40145,
    "job_title": "Staff Data Scientist/Quant Researcher",
    "job_title_short": "Data Scientist",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "550000.0",
    "company_name": "Selby Jennings",
    "global_avg_salary": "149444.032948369565",
    "global_min_salary": "30750.0",
    "global_max_salary": "550000.0"
  },
  {
    "global_rank": "2",
    "salary_rank": "2",
    "job_id": 1714768,
    "job_title": "Staff Data Scientist - Business Analytics",
    "job_title_short": "Data Scientist",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "525000.0",
    "company_name": "Selby Jennings",
    "global_avg_salary": "149444.032948369565",
    "global_min_salary": "30750.0",
    "global_max_salary": "550000.0"
  },
  {
    "global_rank": "3",
    "salary_rank": "1",
    "job_id": 327496,
    "job_title": "Senior Data Scientist",
    "job_title_short": "Senior Data Scientist",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "475000.0",
    "company_name": "Glocomms",
    "global_avg_salary": "149444.032948369565",
    "global_min_salary": "30750.0",
    "global_max_salary": "550000.0"
  },
  {
    "global_rank": "4",
    "salary_rank": "3",
    "job_id": 1131472,
    "job_title": "Data Scientist",
    "job_title_short": "Data Scientist",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "375000.0",
    "company_name": "Algo Capital Group",
    "global_avg_salary": "149444.032948369565",
    "global_min_salary": "30750.0",
    "global_max_salary": "550000.0"
  },
  {
    "global_rank": "5",
    "salary_rank": "2",
    "job_id": 627602,
    "job_title": "Senior Data Scientist",
    "job_title_short": "Senior Data Scientist",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "375000.0",
    "company_name": "Algo Capital Group",
    "global_avg_salary": "149444.032948369565",
    "global_min_salary": "30750.0",
    "global_max_salary": "550000.0"
  },
  {
    "global_rank": "6",
    "salary_rank": "4",
    "job_id": 1742633,
    "job_title": "Head of Data Science",
    "job_title_short": "Data Scientist",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "351500.0",
    "company_name": "Demandbase",
    "global_avg_salary": "149444.032948369565",
    "global_min_salary": "30750.0",
    "global_max_salary": "550000.0"
  },
  {
    "global_rank": "7",
    "salary_rank": "5",
    "job_id": 551497,
    "job_title": "Head of Data Science",
    "job_title_short": "Data Scientist",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "324000.0",
    "company_name": "Demandbase",
    "global_avg_salary": "149444.032948369565",
    "global_min_salary": "30750.0",
    "global_max_salary": "550000.0"
  },
  {
    "global_rank": "8",
    "salary_rank": "6",
    "job_id": 126218,
    "job_title": "Director Level - Product Management - Data Science",
    "job_title_short": "Data Scientist",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "320000.0",
    "company_name": "Teramind",
    "global_avg_salary": "149444.032948369565",
    "global_min_salary": "30750.0",
    "global_max_salary": "550000.0"
  },
  {
    "global_rank": "9",
    "salary_rank": "3",
    "job_id": 488169,
    "job_title": "Senior Director Data Science & ML",
    "job_title_short": "Senior Data Scientist",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "315000.0",
    "company_name": "Life Science People",
    "global_avg_salary": "149444.032948369565",
    "global_min_salary": "30750.0",
    "global_max_salary": "550000.0"
  },
  {
    "global_rank": "10",
    "salary_rank": "7",
    "job_id": 1161630,
    "job_title": "Director of Data Science & Analytics",
    "job_title_short": "Data Scientist",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "313000.0",
    "company_name": "Reddit",
    "global_avg_salary": "149444.032948369565",
    "global_min_salary": "30750.0",
    "global_max_salary": "550000.0"
  },
  {
    "global_rank": "11",
    "salary_rank": "4",
    "job_id": 1080763,
    "job_title": "Sr. Director - Data Science",
    "job_title_short": "Senior Data Scientist",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "310000.0",
    "company_name": "Indeed",
    "global_avg_salary": "149444.032948369565",
    "global_min_salary": "30750.0",
    "global_max_salary": "550000.0"
  },
  {
    "global_rank": "12",
    "salary_rank": "8",
    "job_id": 38905,
    "job_title": "Principal Data Scientist",
    "job_title_short": "Data Scientist",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "300000.0",
    "company_name": "Storm5",
    "global_avg_salary": "149444.032948369565",
    "global_min_salary": "30750.0",
    "global_max_salary": "550000.0"
  },
  {
    "global_rank": "13",
    "salary_rank": "8",
    "job_id": 129924,
    "job_title": "Director of Data Science",
    "job_title_short": "Data Scientist",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "300000.0",
    "company_name": "Storm4",
    "global_avg_salary": "149444.032948369565",
    "global_min_salary": "30750.0",
    "global_max_salary": "550000.0"
  },
  {
    "global_rank": "14",
    "salary_rank": "8",
    "job_id": 457991,
    "job_title": "Head of Battery Data Science",
    "job_title_short": "Data Scientist",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "300000.0",
    "company_name": "Lawrence Harvey",
    "global_avg_salary": "149444.032948369565",
    "global_min_salary": "30750.0",
    "global_max_salary": "550000.0"
  },
  {
    "global_rank": "15",
    "salary_rank": "8",
    "job_id": 226011,
    "job_title": "Distinguished Data Scientist",
    "job_title_short": "Data Scientist",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "300000.0",
    "company_name": "Walmart",
    "global_avg_salary": "149444.032948369565",
    "global_min_salary": "30750.0",
    "global_max_salary": "550000.0"
  },
  {
    "global_rank": "16",
    "salary_rank": "5",
    "job_id": 91852,
    "job_title": "Senior Data Scientist",
    "job_title_short": "Senior Data Scientist",
    "job_location": "Anywhere",
    "job_schedule_type": null,
    "salary_year_avg": "300000.0",
    "company_name": "Top Artificial Intelligence Company",
    "global_avg_salary": "149444.032948369565",
    "global_min_salary": "30750.0",
    "global_max_salary": "550000.0"
  },
  {
    "global_rank": "17",
    "salary_rank": "12",
    "job_id": 178888,
    "job_title": "Pre-Sales Data Scientist, Financial Services",
    "job_title_short": "Data Scientist",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "288000.0",
    "company_name": "Teradata",
    "global_avg_salary": "149444.032948369565",
    "global_min_salary": "30750.0",
    "global_max_salary": "550000.0"
  },
  {
    "global_rank": "18",
    "salary_rank": "13",
    "job_id": 1177572,
    "job_title": "Data Science Manager, Online Customer Experience Intelligence (Remote)",
    "job_title_short": "Data Scientist",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "280000.0",
    "company_name": "Home Depot / THD",
    "global_avg_salary": "149444.032948369565",
    "global_min_salary": "30750.0",
    "global_max_salary": "550000.0"
  },
  {
    "global_rank": "19",
    "salary_rank": "14",
    "job_id": 886101,
    "job_title": "Distinguished Data Scientist",
    "job_title_short": "Data Scientist",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "275000.0",
    "company_name": "Torc Robotics",
    "global_avg_salary": "149444.032948369565",
    "global_min_salary": "30750.0",
    "global_max_salary": "550000.0"
  },
  {
    "global_rank": "20",
    "salary_rank": "14",
    "job_id": 158782,
    "job_title": "Data Scientist",
    "job_title_short": "Data Scientist",
    "job_location": "Anywhere",
    "job_schedule_type": "Full-time",
    "salary_year_avg": "275000.0",
    "company_name": "Algo Capital Group",
    "global_avg_salary": "149444.032948369565",
    "global_min_salary": "30750.0",
    "global_max_salary": "550000.0"
  }
]

*/