/*
====================================================
            Instagram Clone SQL Queries
====================================================

This file contains SQL queries used to analyze
Instagram user activity and engagement.

Each query represents a real-world business question
that a social media company may ask.

Topics Covered

✓ Joins
✓ Aggregate Functions
✓ GROUP BY
✓ HAVING
✓ Subqueries
✓ LEFT JOIN
✓ ORDER BY
✓ LIMIT

====================================================
*/
-- Verify all tables created in the database
SHOW TABLES;

-- Inspect table schemas
DESC users;
DESC comments;
DESC follows;
DESC photo_tags;
DESC photos;
DESC tags;
DESC likes;
----------------------------------------------------
-- 1. Find the first five users who joined Instagram
----------------------------------------------------
-- Business Scenario:
-- The product team wants to reward the earliest users
-- with a loyalty badge.

SELECT username, DATE(created_at) FROM users
ORDER BY created_at LIMIT 5;

----------------------------------------------------
-- 2. Find the day of the week with the highest number
--    of user registrations
----------------------------------------------------
-- Business Scenario:
-- The marketing team wants to know which day users
-- are most likely to sign up so they can schedule
-- advertising campaigns.

SELECT DAYNAME(created_at) AS week_day, COUNT(*) AS total FROM users
GROUP BY week_day
ORDER BY total DESC LIMIT 1;

----------------------------------------------------
-- 3. Find users who have never uploaded a photo
----------------------------------------------------
-- Business Scenario:
-- These inactive users can receive reminder emails
-- encouraging them to share their first photo.

SELECT username FROM users
LEFT JOIN photos ON photos.user_id = users.id
WHERE image_url IS NULL;

----------------------------------------------------
-- 4. Find the photo with the highest number of likes
----------------------------------------------------
-- Business Scenario:
-- Helps identify the most popular content on the
-- platform.

SELECT COUNT(*) AS count, photo_id, username FROM likes
JOIN photos ON photos.id = likes.photo_id
JOIN users ON users.id = photos.user_id
GROUP BY photo_id
ORDER BY count DESC LIMIT 1;

----------------------------------------------------
-- 5. Calculate the average number of photos uploaded
--    per user
----------------------------------------------------
-- Business Scenario:
-- Measures overall platform engagement and content
-- creation.

SELECT (SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users) AS average_per_user;

----------------------------------------------------
-- 6. Find the five most frequently used hashtags
----------------------------------------------------
-- Business Scenario:
-- Trending hashtags help recommend content and improve
-- search functionality.

SELECT COUNT(*) AS count, tag_name FROM tags
JOIN photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tag_name
ORDER BY count DESC, tag_name LIMIT 5;

----------------------------------------------------
-- 7. Find users who have liked every photo
----------------------------------------------------
-- Business Scenario:
-- These highly engaged users could be bots,
-- power users, or excellent candidates for
-- loyalty rewards.

SELECT username, COUNT(*) AS num_likes FROM users
INNER JOIN likes ON users.id = likes.user_id
GROUP BY likes.user_id
HAVING num_likes = (SELECT COUNT(*) FROM photos);
