--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

-- Задание 20: Найдите средний размер hd PC каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.

select maker, avg(hd) avg_hd from product p
join pc on p.model = pc.model
where 1=1
and maker in (
			  select distinct maker from product p
	          join printer pr 
	          on p.model = pr.model
	         )
group by maker


-- Задание 1: Вывести name, class по кораблям, выпущенным после 1920
--
select name, class  from ships
where launched > 1920

-- Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942
--

select name, class, launched from ships
where launched between 1921 and 1942

-- Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class
--

select class, count(name) from ships
group by class

-- Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)
--

select class, country from classes c 
where bore >= 16

-- Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.
--

select ship from outcomes o
where battle = 'North Atlantic' and "result" = 'sunk'

-- Задание 6: Вывести название (ship) последнего потопленного корабля
--

select ship from outcomes o
join battles b 
on o.battle = b."name"
where 1=1
and "result" = 'sunk'
and b."date" = ( select max(date) from outcomes o join battles b --самая поздняя дата потопления кораблей
				 on o.battle = b."name"
				 where "result" = 'sunk'
			   )
			   
--или без использования подзапроса, но с оконной функцией
			   
select ship from
   (
	select *, rank() over(order by date desc) rnk from outcomes o
	join battles b 
	on o.battle = b."name"
	where 1=1
	and "result" = 'sunk'
   ) t
where rnk=1 --оставляем строки с рангом=1 (самая поздняя дата потопления)

-- Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля
--

select t.ship, s.class from --поиск класса последних потопленных кораблей
   (
	select ship from outcomes o -- корабли, которые потопили последними
	join battles b 
	on o.battle = b."name"
	where 1=1
	and "result" = 'sunk'
	and b."date" = ( select max(date) from outcomes o join battles b --самая поздняя дата потопления кораблей
					 on o.battle = b."name"
					 where "result" = 'sunk'
				   )
   ) t join (
			select name, class from ships s
			union
			select class as name, class from classes c --головные корабли в классе
		    ) s
on t.ship = s.name

-- Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class
--

select tt.ship, c.class from (
								select ship, class from outcomes o --все потопленные корабли
								left join (
										select name, class from ships s --обычные корабли
										union
										select class as name, class from classes c --головные корабли в классе
									      ) s
								on o.ship = s.name
								where "result" = 'sunk'
                             ) tt
join classes c on tt.class=c.class
where c.bore >= 16

-- Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class
--

select * from classes c
where country = 'USA'

-- Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class

select s.name, c.class from ships s join classes c
on c."class" = s."class" 
where country = 'USA'
