-- This query retrieves the top 20 companies with the highest number of job postings
-- for positions located 'Anywhere'. It aggregates job postings data by company name
-- to provide insights into company hiring activity in a flexible job market.

SELECT 
    ROW_NUMBER() OVER (ORDER BY COUNT(jp.job_id) DESC) AS global_rank,  -- Assign global rank based on the count
    c.name AS company_name,                     -- Retrieve the name of the company from the company dimension
    COUNT(jp.job_id) AS job_count              -- Count the number of job postings associated with each company
FROM 
    job_postings_fact jp                        -- Specify the main table containing job postings
JOIN 
    company_dim c ON jp.company_id = c.company_id  -- Join with the company dimension table to access company details
WHERE 
    jp.job_location = 'Anywhere'                -- Filter for job postings that are listed as being located 'Anywhere'
GROUP BY 
    c.name                                      -- Group the results by company name to aggregate job counts
ORDER BY 
    job_count DESC                              -- Order the results by job count in descending order to identify top companies
LIMIT 20;                                       -- Limit the output to the top 20 companies with the most job postings

/* RESULTS
[
  {
    "global_rank": "1",
    "company_name": "Listopro",
    "job_count": "1560"
  },
  {
    "global_rank": "2",
    "company_name": "Dice",
    "job_count": "1427"
  },
  {
    "global_rank": "3",
    "company_name": "Upwork",
    "job_count": "1376"
  },
  {
    "global_rank": "4",
    "company_name": "Get It Recruit - Information Technology",
    "job_count": "889"
  },
  {
    "global_rank": "5",
    "company_name": "EPAM Systems",
    "job_count": "428"
  },
  {
    "global_rank": "6",
    "company_name": "Harnham",
    "job_count": "401"
  },
  {
    "global_rank": "7",
    "company_name": "Insight Global",
    "job_count": "338"
  },
  {
    "global_rank": "8",
    "company_name": "EPAM Anywhere",
    "job_count": "308"
  },
  {
    "global_rank": "9",
    "company_name": "Crossover",
    "job_count": "278"
  },
  {
    "global_rank": "10",
    "company_name": "TELUS International AI Data Solutions",
    "job_count": "276"
  },
  {
    "global_rank": "11",
    "company_name": "Turing",
    "job_count": "238"
  },
  {
    "global_rank": "12",
    "company_name": "Robert Half",
    "job_count": "220"
  },
  {
    "global_rank": "13",
    "company_name": "Peroptyx",
    "job_count": "187"
  },
  {
    "global_rank": "14",
    "company_name": "Luxoft",
    "job_count": "185"
  },
  {
    "global_rank": "15",
    "company_name": "Jobot",
    "job_count": "159"
  },
  {
    "global_rank": "16",
    "company_name": "RemoteWorker UK",
    "job_count": "153"
  },
  {
    "global_rank": "17",
    "company_name": "TELUS International",
    "job_count": "150"
  },
  {
    "global_rank": "18",
    "company_name": "Braintrust",
    "job_count": "144"
  },
  {
    "global_rank": "19",
    "company_name": "Motion Recruitment",
    "job_count": "132"
  },
  {
    "global_rank": "20",
    "company_name": "Confidential",
    "job_count": "128"
  }
]
*/