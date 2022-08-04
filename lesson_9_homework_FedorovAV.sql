--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

select case when (grades.grade < 8) then 'NULL' 
            else students.name 
            end as name,
        grades.grade, 
        students.marks
from students, grades
where students.marks between grades.min_mark and grades.max_mark
order by grades.grade desc, students.name asc;


--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

select  max(case when occupation = 'Doctor' then name end) as Doctor,
        max(case when occupation = 'Professor' then name end) as Professor,
        max(case when occupation = 'Singer' then name end) as Singer,
        max(case when occupation = 'Actor' then name end) as Actor        
from (select occupations.*, row_number() over(partition by occupation order by name) as rn 
      from occupations)
group by rn
order by rn;


--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem

select distinct(city)
from station
where not regexp_like(city, '^[AEIOU]');


--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

select distinct(city)
from station
where not regexp_like(city, '[aeiou]$');


--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

select distinct(city)
from station
where not regexp_like(city, '^[AEIOU]')
    or not regexp_like(city, '[aeiou]$');


--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

select distinct(city)
from station
where not regexp_like(city, '^[AEIOU]')
    and not regexp_like(city, '[aeiou]$');


--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem

select name
from employee
where salary > 2000 and months < 10
order by employee_id;


--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

дубль --task1  (lesson9)

