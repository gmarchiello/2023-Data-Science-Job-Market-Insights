-- This query retrieves the top 20 job locations based on the number of job postings available.
-- It counts the number of job postings for each location from the job_postings_fact table
-- and orders the results in descending order by job count.

SELECT
      ROW_NUMBER() OVER (ORDER BY COUNT(job_id) DESC) AS global_rank,  -- Assign global rank based on the count
      job_location,                                    -- Select the job location from the dataset
    COUNT(job_id) AS number_of_jobs                 -- Count the total number of job postings (job_id) for each location
FROM 
    job_postings_fact                                -- Specify the main table containing job postings
WHERE 
    job_location IS NOT NULL                         -- Filter out any entries where the job location is NULL
GROUP BY 
    job_location                                     -- Group results by job location to aggregate counts
HAVING 
    COUNT(job_id) > 0                               -- Ensure that only locations with at least one job posting are included
ORDER BY 
    number_of_jobs DESC                             -- Order the results by the count of job postings in descending order
LIMIT 20;                                          -- Limit the results to the top 20 job locations with the highest number of postings




/* RESULTS
[
  {
    "global_rank": "1",
    "job_location": "Anywhere",
    "number_of_jobs": "69606"
  },
  {
    "global_rank": "2",
    "job_location": "Singapore",
    "number_of_jobs": "23423"
  },
  {
    "global_rank": "3",
    "job_location": "Paris, France",
    "number_of_jobs": "12354"
  },
  {
    "global_rank": "4",
    "job_location": "Bengaluru, Karnataka, India",
    "number_of_jobs": "11517"
  },
  {
    "global_rank": "5",
    "job_location": "London, UK",
    "number_of_jobs": "10578"
  },
  {
    "global_rank": "6",
    "job_location": "Madrid, Spain",
    "number_of_jobs": "9805"
  },
  {
    "global_rank": "7",
    "job_location": "New York, NY",
    "number_of_jobs": "8193"
  },
  {
    "global_rank": "8",
    "job_location": "India",
    "number_of_jobs": "7671"
  },
  {
    "global_rank": "9",
    "job_location": "United States",
    "number_of_jobs": "7449"
  },
  {
    "global_rank": "10",
    "job_location": "Hong Kong",
    "number_of_jobs": "7362"
  },
  {
    "global_rank": "11",
    "job_location": "Lisbon, Portugal",
    "number_of_jobs": "7215"
  },
  {
    "global_rank": "12",
    "job_location": "Atlanta, GA",
    "number_of_jobs": "7182"
  },
  {
    "global_rank": "13",
    "job_location": "Hyderabad, Telangana, India",
    "number_of_jobs": "6872"
  },
  {
    "global_rank": "14",
    "job_location": "Dublin, Ireland",
    "number_of_jobs": "6565"
  },
  {
    "global_rank": "15",
    "job_location": "Amsterdam, Netherlands",
    "number_of_jobs": "5987"
  },
  {
    "global_rank": "16",
    "job_location": "Chicago, IL",
    "number_of_jobs": "5561"
  },
  {
    "global_rank": "17",
    "job_location": "United Kingdom",
    "number_of_jobs": "5339"
  },
  {
    "global_rank": "18",
    "job_location": "Warsaw, Poland",
    "number_of_jobs": "5283"
  },
  {
    "global_rank": "19",
    "job_location": "Dallas, TX",
    "number_of_jobs": "5194"
  },
  {
    "global_rank": "20",
    "job_location": "Kuala Lumpur, Federal Territory of Kuala Lumpur, Malaysia",
    "number_of_jobs": "5084"
  }
]
*/