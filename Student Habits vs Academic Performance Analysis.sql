-- SECTION 1: DATA CLEANING & EXPLORATION

-- 1.1 Check for Duplicate Student Records
SELECT
    student_id,
    COUNT(*) AS record_count
FROM
    student_habits_performance
GROUP BY
    student_id
HAVING
    record_count > 1;

-- 1.2 Check for Missing Values in Key Columns
SELECT
    COUNT(CASE WHEN student_id IS NULL THEN 1 END) AS missing_student_id,
    COUNT(CASE WHEN exam_score IS NULL THEN 1 END) AS missing_exam_score,
    COUNT(CASE WHEN study_hours_per_day IS NULL THEN 1 END) AS missing_study_hours
FROM
    student_habits_performance;

-- 1.3 Check for Inconsistencies in Categorical Data
SELECT DISTINCT gender FROM student_habits_performance;
SELECT DISTINCT parental_education_level FROM student_habits_performance;
SELECT DISTINCT part_time_job FROM student_habits_performance;

-- 1.4 Check for Outliers/Invalid Data in Numerical Columns
SELECT
    MIN(exam_score) AS min_score,
    MAX(exam_score) AS max_score,
    MIN(attendance_percentage) AS min_attendance,
    MAX(attendance_percentage) AS max_attendance,
    MIN(study_hours_per_day) AS min_study_hours,
    MAX(study_hours_per_day) AS max_study_hours,
    MIN(sleep_hours) AS min_sleep_hours,
    MAX(sleep_hours) AS max_sleep_hours
FROM
    student_habits_performance;

-- SECTION 2: KEY PERFORMANCE INDICATORS (KPIs)

SELECT
    COUNT(student_id) AS total_students,
    ROUND(AVG(exam_score), 2) AS overall_avg_exam_score,
    ROUND(AVG(attendance_percentage), 2) AS overall_avg_attendance,
    ROUND(AVG(study_hours_per_day), 2) AS overall_avg_study_hours,
    ROUND(AVG(sleep_hours), 2) AS overall_avg_sleep_hours
FROM
    student_habits_performance;

-- SECTION 3: ANALYTICAL QUESTIONS

-- 3.1 Study Hours vs Exam Scores
SELECT
    CASE
        WHEN study_hours_per_day <= 2 THEN '0-2 hours'
        WHEN study_hours_per_day <= 4 THEN '2-4 hours'
        WHEN study_hours_per_day <= 6 THEN '4-6 hours'
        ELSE '> 6 hours'
    END AS study_hours_group,
    ROUND(AVG(exam_score), 2) AS average_score
FROM student_habits_performance
GROUP BY study_hours_group
ORDER BY study_hours_group;

-- 3.2 Exercise Frequency vs Exam Scores
SELECT
    CASE
        WHEN exercise_frequency <= 2 THEN '0-2 times/week'
        WHEN exercise_frequency <= 4 THEN '3-4 times/week'
        ELSE '> 4 times/week'
    END AS exercise_frequency_group,
    ROUND(AVG(exam_score), 2) AS average_score
FROM student_habits_performance
GROUP BY exercise_frequency_group
ORDER BY exercise_frequency_group;

-- 3.3 Sleep Hours Group vs Exam Scores
SELECT
    CASE
        WHEN sleep_hours <= 5 THEN '< 6 hours'
        WHEN sleep_hours <= 8 THEN '6-8 hours'
        ELSE '> 8 hours'
    END AS sleep_hours_group,
    ROUND(AVG(exam_score), 2) AS average_score
FROM student_habits_performance
GROUP BY sleep_hours_group
ORDER BY average_score DESC;

-- 3.4 Attendance vs Exam Scores
SELECT
    CASE
        WHEN attendance_percentage <= 75 THEN '0-75%'
        WHEN attendance_percentage <= 90 THEN '76-90%'
        ELSE '> 90%'
    END AS attendance_group,
    ROUND(AVG(exam_score), 2) AS average_score
FROM student_habits_performance
GROUP BY attendance_group
ORDER BY attendance_group;

-- 3.5 Diet Quality vs Exam Scores
SELECT
    diet_quality,
    ROUND(AVG(exam_score), 2) AS average_score
FROM student_habits_performance
GROUP BY diet_quality
ORDER BY average_score DESC;

-- 3.6 Parental Education Level vs Exam Scores
SELECT
    parental_education_level,
    ROUND(AVG(exam_score), 2) AS average_score
FROM student_habits_performance
GROUP BY parental_education_level
ORDER BY average_score DESC;

-- 3.7 Gender Differences in Study & Exam Scores
SELECT
    gender,
    ROUND(AVG(study_hours_per_day), 2) AS avg_study_hours,
    ROUND(AVG(exam_score), 2) AS avg_exam_score
FROM student_habits_performance
GROUP BY gender;

-- 3.8 Extra-Curricular Participation vs Attendance
SELECT
    extracurricular_participation,
    ROUND(AVG(attendance_percentage), 2) AS avg_attendance
FROM student_habits_performance
GROUP BY extracurricular_participation;

-- 3.9 Part-Time Job vs Exam Scores
SELECT
    part_time_job,
    ROUND(AVG(exam_score), 2) AS avg_exam_score
FROM student_habits_performance
GROUP BY part_time_job;

-- 3.10 Lowest Attendance by Demographic
SELECT
    gender,
    parental_education_level,
    ROUND(AVG(attendance_percentage), 2) AS avg_attendance
FROM student_habits_performance
GROUP BY gender, parental_education_level
ORDER BY avg_attendance ASC
LIMIT 1;

-- 3.11 High Study Hours + Exercise Impact
SELECT
    CASE
        WHEN exercise_frequency <= 2 THEN '0-2 times/week'
        WHEN exercise_frequency <= 4 THEN '3-4 times/week'
        ELSE '> 4 times/week'
    END AS exercise_group,
    ROUND(AVG(exam_score), 2) AS avg_exam_score
FROM student_habits_performance
WHERE study_hours_per_day > 6
GROUP BY exercise_group
ORDER BY avg_exam_score DESC;

-- 3.12 Sleep Mitigating Part-Time Job
SELECT
    CASE
        WHEN sleep_hours <= 5 THEN '< 6 hours'
        WHEN sleep_hours <= 8 THEN '6-8 hours'
        ELSE '> 8 hours'
    END AS sleep_group,
    ROUND(AVG(exam_score), 2) AS avg_exam_score
FROM student_habits_performance
WHERE part_time_job = 'Yes'
GROUP BY sleep_group
ORDER BY avg_exam_score DESC;

-- 3.13 Good Diet + High Exercise Combo
SELECT
    diet_quality,
    CASE
        WHEN exercise_frequency <= 2 THEN '0-2 times/week'
        WHEN exercise_frequency <= 4 THEN '3-4 times/week'
        ELSE '> 4 times/week'
    END AS exercise_group,
    ROUND(AVG(exam_score), 2) AS avg_exam_score
FROM student_habits_performance
GROUP BY diet_quality, exercise_group
ORDER BY avg_exam_score DESC;

-- 3.14 Low Attendance: Study vs Sleep
SELECT 'Study Hours' AS factor,
    CASE
        WHEN study_hours_per_day <= 2 THEN '0-2 hours'
        WHEN study_hours_per_day <= 4 THEN '2-4 hours'
        WHEN study_hours_per_day <= 6 THEN '4-6 hours'
        ELSE '> 6 hours'
    END AS grp,
    ROUND(AVG(exam_score), 2) AS avg_score
FROM student_habits_performance
WHERE attendance_percentage <= 75
GROUP BY grp
UNION ALL
SELECT 'Sleep Hours' AS factor,
    CASE
        WHEN sleep_hours <= 5 THEN '< 6 hours'
        WHEN sleep_hours <= 8 THEN '6-8 hours'
        ELSE '> 8 hours'
    END AS grp,
    ROUND(AVG(exam_score), 2) AS avg_score
FROM student_habits_performance
WHERE attendance_percentage <= 75
GROUP BY grp
ORDER BY factor, avg_score DESC;

-- 3.15 Study Hour Impact by Parental Education
SELECT
    parental_education_level,
    CASE
        WHEN study_hours_per_day <= 2 THEN '0-2 hours'
        WHEN study_hours_per_day <= 4 THEN '2-4 hours'
        WHEN study_hours_per_day <= 6 THEN '4-6 hours'
        ELSE '> 6 hours'
    END AS study_group,
    ROUND(AVG(exam_score), 2) AS avg_score
FROM student_habits_performance
GROUP BY parental_education_level, study_group
ORDER BY parental_education_level, avg_score DESC;

-- 3.16 Top 10 Performing Habit Profiles
SELECT
    CASE
        WHEN study_hours_per_day <= 2 THEN '0-2 hours'
        WHEN study_hours_per_day <= 4 THEN '2-4 hours'
        WHEN study_hours_per_day <= 6 THEN '4-6 hours'
        ELSE '> 6 hours'
    END AS study_group,
    CASE
        WHEN sleep_hours <= 5 THEN '< 6 hours'
        WHEN sleep_hours <= 8 THEN '6-8 hours'
        ELSE '> 8 hours'
    END AS sleep_group,
    CASE
        WHEN exercise_frequency <= 2 THEN '0-2 times/week'
        WHEN exercise_frequency <= 4 THEN '3-4 times/week'
        ELSE '> 4 times/week'
    END AS exercise_group,
    diet_quality,
    ROUND(AVG(exam_score), 2) AS avg_score
FROM student_habits_performance
GROUP BY 1, 2, 3, 4
ORDER BY avg_score DESC
LIMIT 10;

-- 3.17 At-Risk Students (Score < 75)
SELECT
    CASE
        WHEN study_hours_per_day <= 2 THEN '0-2 hours'
        WHEN study_hours_per_day <= 4 THEN '2-4 hours'
        WHEN study_hours_per_day <= 6 THEN '4-6 hours'
        ELSE '> 6 hours'
    END AS study_group,
    CASE
        WHEN sleep_hours <= 5 THEN '< 6 hours'
        WHEN sleep_hours <= 8 THEN '6-8 hours'
        ELSE '> 8 hours'
    END AS sleep_group,
    CASE
        WHEN attendance_percentage <= 75 THEN '0-75%'
        WHEN attendance_percentage <= 90 THEN '76-90%'
        ELSE '> 90%'
    END AS attendance_group,
    diet_quality,
    part_time_job,
    ROUND(AVG(exam_score), 2) AS avg_score,
    COUNT(*) AS student_count
FROM student_habits_performance
WHERE exam_score < 75
GROUP BY 1, 2, 3, 4, 5
ORDER BY student_count DESC;

-- 3.18 Habit with Largest Score Range
SELECT 'Study Hours' AS habit, MAX(avg_score) - MIN(avg_score) AS score_gap
FROM (
    SELECT
        CASE
            WHEN study_hours_per_day <= 2 THEN '0-2 hours'
            WHEN study_hours_per_day <= 4 THEN '2-4 hours'
            WHEN study_hours_per_day <= 6 THEN '4-6 hours'
            ELSE '> 6 hours'
        END AS group_val,
        AVG(exam_score) AS avg_score
    FROM student_habits_performance
    GROUP BY group_val
) AS t1
UNION
SELECT 'Sleep Hours', MAX(avg_score) - MIN(avg_score)
FROM (
    SELECT
        CASE
            WHEN sleep_hours <= 5 THEN '< 6 hours'
            WHEN sleep_hours <= 8 THEN '6-8 hours'
            ELSE '> 8 hours'
        END AS group_val,
        AVG(exam_score) AS avg_score
    FROM student_habits_performance
    GROUP BY group_val
) AS t2
UNION
SELECT 'Exercise', MAX(avg_score) - MIN(avg_score)
FROM (
    SELECT
        CASE
            WHEN exercise_frequency <= 2 THEN '0-2 times/week'
            WHEN exercise_frequency <= 4 THEN '3-4 times/week'
            ELSE '> 4 times/week'
        END AS group_val,
        AVG(exam_score) AS avg_score
    FROM student_habits_performance
    GROUP BY group_val
) AS t3
ORDER BY score_gap DESC;

-- 3.19 High Scoring Students with Low Study Hours
SELECT *
FROM student_habits_performance
WHERE study_hours_per_day <= 2 AND exam_score > 85
ORDER BY exam_score DESC;

-- 3.20 Compare Sleep/Study: Job vs Extra-Curriculars
SELECT 'Part-Time Job' AS group_type,
    ROUND(AVG(sleep_hours), 2) AS avg_sleep,
    ROUND(AVG(study_hours_per_day), 2) AS avg_study
FROM student_habits_performance
WHERE part_time_job = 'Yes'
UNION ALL
SELECT 'Extra-Curriculars',
    ROUND(AVG(sleep_hours), 2),
    ROUND(AVG(study_hours_per_day), 2)
FROM student_habits_performance
WHERE extracurricular_participation = 'Yes';
