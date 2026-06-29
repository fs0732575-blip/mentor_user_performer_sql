
CREATE TABLE user_submissions (
    id SERIAL PRIMARY KEY,
    user_id BIGINT,
    question_id INT,
    points INT,
    submitted_at TIMESTAMP WITH TIME ZONE,
    username VARCHAR(50)
);

 SELECT * FROM USER_SUBMISSIONS


 -- Q.1 List all distinct users and their stats (return user_name, total_submissions, points earned)
-- Q.2 Calculate the daily average points for each user.
-- Q.3 Find the top 3 users with the most positive submissions for each day.
-- Q.4 Find the top 5 users with the highest number of incorrect submissions.
-- Q.5 Find the top 10 performers for each week.


-- Please note for each questions return current stats for the users
-- user_name, total points earned, correct submissions, incorrect submissions no


-- -------------------
-- My Solutions
-- -------------------
-- Q.1 List all distinct users and their stats (return user_name, total_submissions, points earned)

SELECT
 USERNAME,

 COUNT(ID) AS TOTAL_SUBMISSIONS,
 SUM(POINTS) AS POINTS_EARNED
 FROM USER_SUBMISSIONS
 GROUP BY USERNAME
 ORDER BY TOTAL_SUBMISSIONS DESC

 -- -- Q.2 Calculate the daily average points for each user.

SELECT * FROM USER_SUBMISSIONS

SELECT
    TO_CHAR(SUBMITTED_AT,'YYYY-MM-DD') AS DAY,
	USERNAME,
	AVG(POINTS) AS DAILY_AVG_POINTS
	FROM USER_SUBMISSIONS
	GROUP BY 1,2
	ORDER BY USERNAME; 



-- Q.3 Find the top 3 users with the most correct submissions for each day.


SELECT  
    TO_CHAR(SUBMITTED_AT,'YYYY-MM-DD') AS DAY,
	USERNAME,
	SUM(CASE
	WHEN POINTS > 0 THEN 1 ELSE 0
	END)AS CORRECT_SUBMISSION
	FROM USER_SUBMISSIONS
	GROUP BY 1,2
	ORDER BY USERNAME;),
	USER_RANK AS
	DAILY,
	USERNAME,
	CORRECT_SUBMISSIONS
	DENSE RANK() OVER(PARTITION BY DAILY ORDER BY CORRECT_SUBMISSIONS DESC) AS RANK
	FROM DAILY_SUBMISSIONS
	)
	SELECT
	     DAILY,
		 USERNAME,
		 CORRE


--Q4: Find the Top 5 Users with the Highest Number of Incorrect Submissions

SELECT 
    username,
    SUM(CASE WHEN points < 0 THEN 1 ELSE 0 END) AS incorrect_submissions,
    SUM(CASE WHEN points > 0 THEN 1 ELSE 0 END) AS correct_submissions,
    SUM(CASE WHEN points < 0 THEN points ELSE 0 END) AS incorrect_submissions_points,
    SUM(CASE WHEN points > 0 THEN points ELSE 0 END) AS correct_submissions_points_earned,
    SUM(points) AS points_earned
FROM user_submissions
GROUP BY 1
ORDER BY incorrect_submissions DESC;

--Q5: Find the Top 10 Performers for Each Week

SELECT *  
FROM (
    SELECT 
        EXTRACT(WEEK FROM submitted_at) AS week_no,
        username,
        SUM(points) AS total_points_earned,
        DENSE_RANK() OVER(PARTITION BY EXTRACT(WEEK FROM submitted_at) ORDER BY SUM(points) DESC) AS rank
    FROM user_submissions
    GROUP BY 1, 2
    ORDER BY week_no, total_points_earned DESC
)
WHERE rank <= 10;