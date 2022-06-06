--task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях.
-- Вывести: класс и число потопленных кораблей.


with all_ships(name, class) as
(select name, class from ships
union
select class as name, class from classes c 
)

select class, count(result) from all_ships a
join outcomes o 
on a.name  = o.ship
where o."result" = 'sunk'
group by class 


--task2
--Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса.
-- Если год спуска на воду головного корабля неизвестен,
-- определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

select c.class, min(launched) "launch year"
from classes c   full join ships s
on c.class=s.class
group by c.class

--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных,
-- вывести имя класса и число потопленных кораблей.

with all_ships(name, class) as
(select name, class from ships
where name!=class
union
select class as name, class from classes c 
)

select class, count(ship) as cnt_sunk
from all_ships a left join outcomes o
on a.name = o.ship and o."result" = 'sunk'
group by a.class
having count(*) > 2 and count(ship) > 0 -- count(*) - число кораблей в классе, count(ship) - число потопленных


--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий
-- среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).

with allships (name, class) as (
select name, class from ships 
union
select ship, ship from outcomes )


select name from allships a join classes c
on a.class = c.class
where
c.numGuns = (select max(numGuns)
             from classes
             where displacement = c.displacement
             and class in (select class from allships))

--task5
-- Компьютерная фирма: Найдите производителей принтеров,
-- которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК,
-- имеющих наименьший объем RAM. Вывести: Maker

select distinct maker from product p join pc
on p.model = pc.model
where p.maker in (select maker from product
                  where type = 'printer')
and p.type = 'pc'
and pc.speed = (select max(speed) from pc where ram = (select min(ram) from pc))
and pc.ram = (select min(ram) from pc)           
             