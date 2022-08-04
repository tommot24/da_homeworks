--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/

-- Write an SQL query to find the employees who are high earners in each of the departments. A high earner in a department is an employee who has a salary in the top three unique salaries for that department.
with employee_rank as
(select d.name as Department,
        e.name as Employee,
        e.salary as Salary,
        dense_rank() over (partition by d.id order by e.salary desc) as rank
from Employee e join Department d on e.departmentId = d.id)       
        
select Department, Employee, Salary
from employee_rank 
where rank <= 3


--task2  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/17

-- Определить, сколько потратил в 2005 году каждый из членов семьи
select member_name, 
        status,
        sum(amount * unit_price) as costs
from FamilyMembers f join Payments p on f.member_id = p.family_member
where extract(year from date) = 2005
group by member_name, status


--task3  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/13

-- Вывести имена людей, у которых есть полный тёзка среди пассажиров
select name
from passenger 
group by name
having count(id) > 1


--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

-- Сколько Анн (Anna) учится в школе
select count(id) as count
from Student
where first_name = 'Anna'
group by first_name 


--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35

-- Сколько различных кабинетов школы использовались 2.09.2019 в образовательных целях
select count(c.id) as count
from Class c join Schedule s on c.id = s.class
where date(date) = '2019-09-02'


--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

Дублирует task4


--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32

-- Вывести средний возраст людей (в годах), хранящихся в базе данных. Результат округлите до целого в меньшую сторону.
select round(avg(TIMESTAMPDIFF(YEAR, birthday, CURDATE())),0) as age
from FamilyMembers


--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27

-- Узнать, сколько потрачено на каждую из групп товаров в 2005 году. Вывести название группы и сумму
select good_type_name, 
        sum(amount * unit_price) as costs
from Goods g join Payments p on g.good_id = p.good
            join GoodTypes gt on g.type = gt.good_type_id
where extract(year from date) = 2005
group by good_type_name


--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37

-- Сколько лет самому молодому обучающемуся
select min(TIMESTAMPDIFF(YEAR, birthday, CURDATE())) as year
from Student


--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

-- Найдите максимальный возраст (колич. лет) среди обучающихся 10 классов
select max(TIMESTAMPDIFF(YEAR, birthday, CURDATE())) as max_year
from Student s join Student_in_class sc on s.id = sc.student
               join Class c on c.id = sc.class 
where name = 10


--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20

-- Сколько и кто из семьи потратил на развлечения (entertainment). Вывести статус в семье, имя, сумму
select status,
        member_name,
        sum(amount * unit_price) as costs
from FamilyMembers f join Payments p on f.member_id = p.family_member
                    join Goods g on p.good = g.good_id
                    join GoodTypes gt on g.type = gt.good_type_id
where good_type_name = 'entertainment'
group by status, member_name


--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55

-- Удалить компании, совершившие наименьшее количество рейсов
delete from Company
where id in 

(select company 
from Trip
group by company 
having count(id) = (select min(cnt)
                    from (select count(id) as cnt 
                        from trip 
                        group by company) tbl))


--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45

-- Какой(ие) кабинет(ы) пользуются самым большим спросом
select classroom 
from Schedule
group by classroom 
having count(id) = (select max(cnt)
                    from (select classroom, count(id) as cnt
                    from Schedule
                    group by classroom) tbl)


--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43

-- Выведите фамилии преподавателей, которые ведут физическую культуру (Physical Culture). Отcортируйте преподавателей по фамилии
select t.last_name
from Teacher t join Schedule s on t.id = s.teacher
                join Subject sb on s.subject = sb.id
where sb.name = 'Physical Culture' 
order by t.last_name


--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63

-- Выведите отсортированный список (по возрастанию) имен студентов в виде Фамилия.И.О.
select concat(last_name, '.', left(first_name, 1), '.', left(middle_name, 1), '.') as name
from Student
order by name asc
