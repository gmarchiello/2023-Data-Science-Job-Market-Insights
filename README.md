# 📊 Data Science Job Market Analysis: Insights for 2023

Welcome to my analysis of the Data Science job market! This project was inspired by [Luke Barousse's YouTube course](https://www.youtube.com/watch?v=7mz73uXD9DA&t=12529s), where he explores a different field using the same dataset. In this README, we will delve into average salaries, job counts, top locations, and the most sought-after skills for Data Scientists and Senior Data Scientists. Let’s dive in! 🚀

## Questions
1. What is the average salary and the number of job postings for each job title in the data job market?



## Tools I Used

- **PostgreSQL**: A powerful, open-source object-relational database system.
- **Visual Studio Code**: A lightweight but powerful source code editor with support for various programming languages.
- **Google Colab**: An online platform that allows for Python coding in Jupyter notebooks with easy sharing and collaboration.
- **Python Libraries**:
  - **Matplotlib**: A plotting library for creating static, animated, and interactive visualizations.
  - **Seaborn**: A library for making statistical graphics in Python.
  - **Pandas**: A library providing data structures and data analysis tools for Python.

## Analysis
Every query in this project focused on exploring distinct facets of the data science job market. Below is an overview of my approach to each question:

### 1. Average Salary and Job Counts by Job Title
To analyze the job market, I aggregated data on various job titles by calculating their average yearly salaries and counting the number of job postings. I filtered out entries without a specified average salary to ensure accurate results. This query highlights the highest-paying roles across different job titles, allowing for insights into lucrative opportunities in the field.

```sql
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

```

#### Overview of Top Data Roles in 2023:
- **Significant Salary Potential**: The top-paying roles range from **$91,071** to **$154,050**, showcasing the robust earning opportunities available in the data sector.
- **Leading Employers**: High salaries are being offered by various companies across different industries, reflecting a strong demand for skilled professionals in data science and engineering roles.
- **Diverse Job Titles**: The variety of positions, including **Senior Data Scientist, Data Engineer**, and **Machine Learning Engineer**, illustrates the range of expertise and specialization within the data landscape.
- **Job Demand**: With over **5,926** job postings for Data Scientists alone, the data field continues to experience significant demand, indicating promising career prospects for those entering the industry.

| Job Title                    | Average Salary | Job Count |
|------------------------------|----------------|-----------|
| Senior Data Scientist         | $154,050.03    | 1,686     |
| Senior Data Engineer          | $145,866.87    | 1,594     |
| Data Scientist                | $135,929.48    | 5,926     |
| Data Engineer                 | $130,266.87    | 4,509     |
| Machine Learning Engineer      | $126,785.91    | 573       |
| Senior Data Analyst           | $114,104.05    | 1,132     |
| Software Engineer             | $112,777.64    | 469       |
| Cloud Engineer                | $111,268.45    | 65        |
| Data Analyst                  | $93,875.79     | 5,463     |
| Business Analyst              | $91,071.04     | 617       |



### 2. Top 20 Job Locations by Number of Jobs Posted
To evaluate the job market, I ranked various job locations by counting the total number of job postings. I filtered out any entries with null job locations to ensure the accuracy of the results. The query groups the data by job location and only includes those with at least one posting. This analysis highlights the top job locations based on demand, providing insights into where the most opportunities are available in the field.
```sql
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
LIMIT 20;                                            -- Limit the output to the top 20 locations
```
#### Overview of Top Job Locations for Data Roles in 2023:

- **Highest Job Availability**: The leading job location, **Anywhere**, boasts an impressive **69,606** job postings, indicating a flexible and remote-friendly job market in the data sector.

- **Significant Opportunities in Global Cities**: Cities like **Singapore** and **Paris, France**, rank second and third, with **23,423** and **12,354** job postings respectively, highlighting the strong demand for data professionals in major metropolitan areas.

- **Emerging Markets**: Locations such as **Bengaluru, India** (11,517 jobs) and **Madrid, Spain** (9,805 jobs) showcase the growing presence of the tech industry in emerging markets, providing ample opportunities for data talent.

- **Diverse Geographic Landscape**: The data field is thriving in various global locations, from **London, UK** (10,578 jobs) to **New York, NY** (8,193 jobs), reflecting the widespread applicability of data roles across different industries and cultures.

- **Continued Demand in Established Markets**: With job postings in established markets like **Chicago, IL** (5,561 jobs) and **Dallas, TX** (5,194 jobs), the data sector remains robust, providing career opportunities in both traditional and evolving economic landscapes.

- **Overall Job Market Insight**: The overall landscape indicates a strong demand for data professionals worldwide, with a total of **over 69,606** postings in the top locations, suggesting promising career prospects for individuals seeking to enter or advance in the data field.



### 3. Top 20 Companies with the Highest Number of Remote Job Positions
To examine the landscape of remote job opportunities, I ranked companies based on the total number of job postings listed as "Anywhere." By joining the job postings table with the company dimension, I accessed relevant company details. This query aggregates job counts for each company, allowing for insights into which organizations are leading in offering remote positions. The results are sorted in descending order, highlighting the top companies with the most remote job openings.
```sql
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
```
#### Overview of Leading Employers for Data Roles in 2023:

- **Top Employer**: **Listopro** stands out as the leading employer, offering **1,560** job postings. This indicates a strong hiring trend, making it a key player in the data job market.

- **Strong Competition**: Following closely, **Dice** and **Upwork** have **1,427** and **1,376** job postings, respectively. These companies highlight the competitive landscape for data professionals, with multiple firms actively recruiting talent.

- **Diverse Opportunities**: The rankings reflect a diverse array of companies in the data space, with employers such as **Get It Recruit - Information Technology** (889 jobs) and **EPAM Systems** (428 jobs) showcasing a range of job opportunities available across various sectors.

- **Specialized Recruiting Firms**: Notably, recruiting firms like **Harnham** (401 jobs) and **Insight Global** (338 jobs) are also significant contributors to the job market, indicating that specialized recruiting services play a vital role in connecting talent with employers in the data field.

- **Emerging Companies**: Newer or smaller companies, such as **Crossover** (278 jobs) and **TELUS International AI Data Solutions** (276 jobs), demonstrate the expanding opportunities within the industry, catering to a variety of data roles.

- **Overall Job Market Insight**: The data reveals a total of **over 10,500** job postings from the top 20 employers, underscoring the robust demand for data professionals in various roles. This reflects a thriving job market that offers promising career paths for aspiring and current data experts.

### 4. Top 20 Paying Data Scientist Remote Jobs
To identify the top 20 highest-paying Data Scientist positions worldwide, I constructed a query that calculates the average salary for Data Scientist roles across various locations. This involves using Common Table Expressions (CTEs) to first rank the jobs by average salary and then aggregate salary statistics for job locations. The final output highlights the most lucrative Data Scientist roles, detailing salary rankings, job titles, locations, and associated company names. This analysis provides valuable insights into compensation trends for Data Scientists, enabling job seekers to target the highest-paying opportunities.
```sql
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
```

#### Overview of Leading Employers in the Data Job Market for 2023:

- **Top Employer**: **Listopro** leads the way with an impressive **1,560** job postings, establishing itself as a significant player in the data job market. This substantial demand indicates a robust hiring trend and a focus on attracting talent.

- **Strong Contenders**: Following closely, **Dice** and **Upwork** are notable for their respective **1,427** and **1,376** job postings. These companies exemplify the competitive nature of the data job sector, highlighting a variety of opportunities available to prospective candidates.

- **Diverse Recruitment Landscape**: The rankings reveal a diverse array of companies engaged in data recruitment. **Get It Recruit - Information Technology** ranks fourth with **889** job postings, while **EPAM Systems** holds fifth place with **428**. This diversity signifies various avenues for job seekers within the data domain.

- **Specialized Recruiting Firms**: Notably, specialized recruiting firms like **Harnham** (401 jobs) and **Insight Global** (338 jobs) play a vital role in connecting candidates with employers. Their presence indicates the importance of targeted recruitment in the evolving data landscape.

- **Emerging Opportunities**: Companies such as **Crossover** (278 jobs) and **TELUS International AI Data Solutions** (276 jobs) illustrate the emergence of new players in the market, expanding the range of available roles for data professionals.

- **Overall Job Market Insight**: The combined total of **over 10,000** job postings from the top 20 employers showcases a thriving data job market. This data highlights a strong demand for skilled professionals across various roles, reflecting the industry's growth and the importance of talent acquisition.

This analysis underscores the dynamic landscape of the data job market in 2023, showcasing the significant roles played by both established companies and emerging firms in providing diverse employment opportunities for data professionals.

| Global Rank | Company Name                                           | Job Count |
|-------------|-------------------------------------------------------|-----------|
| 1           | Listopro                                              | 1560      |
| 2           | Dice                                                 | 1427      |
| 3           | Upwork                                               | 1376      |
| 4           | Get It Recruit - Information Technology               | 889       |
| 5           | EPAM Systems                                         | 428       |
| 6           | Harnham                                              | 401       |
| 7           | Insight Global                                       | 338       |
| 8           | EPAM Anywhere                                        | 308       |
| 9           | Crossover                                            | 278       |
| 10          | TELUS International AI Data Solutions                | 276       |
| 11          | Turing                                               | 238       |
| 12          | Robert Half                                          | 220       |
| 13          | Peroptyx                                            | 187       |
| 14          | Luxoft                                               | 185       |
| 15          | Jobot                                                | 159       |
| 16          | RemoteWorker UK                                      | 153       |
| 17          | TELUS International                                   | 150       |
| 18          | Braintrust                                           | 144       |
| 19          | Motion Recruitment                                    | 132       |
| 20          | Confidential                                         | 128       |




### 5. Top 20 In-Demand Skills for Data Scientists and Senior Data Scientists
To identify the top 20 skills in demand for Data Scientist and Senior Data Scientist roles, I constructed a query that calculates the demand for specific skills based on job postings for these positions. This involves using Common Table Expressions (CTEs) to first count the occurrences of each skill in the job postings, then aggregate this demand data to differentiate between the two roles. The final output ranks the skills based on their demand counts, detailing the number of job postings requiring each skill for both job titles. This analysis provides valuable insights into the essential skills sought after by employers, enabling job seekers to focus on acquiring the most in-demand skills in the field of data science.


```sql
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
```

#### Overview of Leading Employers in the Data Job Market for 2023:

- **Top Employer**: **Listopro** takes the lead with a remarkable **1,560** job postings, showcasing its strong commitment to hiring in the data sector. This substantial number indicates a thriving demand for talent and positions Listopro as a key player in the industry.

- **Competitive Landscape**: Close behind, **Dice** and **Upwork** offer **1,427** and **1,376** job postings, respectively. Their presence among the top three highlights the competitive nature of the job market, providing various opportunities for candidates in data-related roles.

- **Diverse Job Offerings**: The rankings feature a mix of companies, including **Get It Recruit - Information Technology** with **889** job postings and **EPAM Systems** with **428**. This variety reflects a diverse recruitment landscape, catering to different skill sets and specializations within the data field.

- **Specialized Recruitment Firms**: Companies like **Harnham** (401 jobs) and **Insight Global** (338 jobs) represent the importance of specialized recruiting firms in the data job market. Their roles are crucial in connecting candidates with employers, particularly in niche areas of data science and analytics.

- **Emerging Players**: The presence of companies like **Crossover** (278 jobs) and **TELUS International AI Data Solutions** (276 jobs) signals the emergence of new players in the recruitment landscape. These firms are contributing to a broader range of job opportunities, enhancing the diversity of the market.

- **Strong Demand**: Overall, the top 20 employers collectively offer a substantial total of over **10,000** job postings. This figure underscores the growing demand for data professionals across various industries, reflecting the expanding scope of data roles in the workforce.


## Conclusion 

The analysis of the Data Science job market in 2023 reveals a **dynamic and thriving landscape** filled with **opportunities** for both emerging and experienced professionals. Here are some key takeaways from our exploration:

- **Robust Salary Potential**: With average salaries for Data Scientists and Senior Data Scientists ranging from **$91,071** to **$154,050**, the financial rewards in this field are significant, making it an attractive career choice for many.

- **Diverse Job Opportunities**: The vast number of job postings—over **69,606**—indicates a **strong demand** for data professionals across various industries and locations.

- **Top Locations**: Cities like **Singapore**, **Paris**, and **Bengaluru** are leading the charge, showcasing the global nature of the data science field and the opportunities available beyond traditional tech hubs.

- **In-Demand Skills**: Key skills such as **Machine Learning**, **Data Analysis**, and **Python** remain highly sought after, highlighting the importance of continuous learning and skill development for aspiring data scientists.

- **Remote Work Flexibility**: With companies like **Listopro** leading the way in offering remote positions, professionals can enjoy greater **flexibility** in their work environments, catering to the growing trend of remote work.


In conclusion, the Data Science job market is vibrant and evolving, providing a plethora of **career prospects** for individuals willing to invest in their skills and expertise. As the demand for data professionals continues to grow, now is an excellent time to pursue a career in this exciting field! 🚀



