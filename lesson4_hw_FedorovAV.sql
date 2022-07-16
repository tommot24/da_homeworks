--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type

select model, maker, type from product p 

--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"

select *,
	   case when price > (select avg(price) from pc) then 1 else 0 end flag
from printer

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL)

with all_ships as
(
 select name, class from ships
 union all
 select class as name, class from classes
 ) 
 
 select coalesce(o.ship, a.name) as name, a.class
 from outcomes o full join all_ships a
 on o.ship = a.name
 where a.class is NULL

--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду.
 
 select name from battles
 where cast(extract(year from date) as int2) not in (select distinct launched from ships)


--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships.
 
select battle from outcomes o join  
(select * from ships
where class = 'Kongo') k
on o.ship = k.name

--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом,
-- если стоимость больше > 300. Во view три колонки: model, price, flag
--drop view all_products_flag_300;

create view all_products_flag_300 as
	select * from (
					with all_models as (
										select model, price from pc
										union all
										select model, price from printer
										union all 
										select model, price from laptop
									   )
					
					select *,
					       case when price > 300 then 1 else 0 end flag
					from all_models a
				  ) alias;

--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом,
-- если стоимость больше cредней . Во view три колонки: model, price, flag

--drop view all_products_flag_avg_price;

create view all_products_flag_avg_price as
	select * from (
					with all_models as (
										select model, price from pc
										union all
										select model, price from printer
										union all 
										select model, price from laptop
									   )
					
					select *,
					       case when price > (select avg(price) from all_models) then 1 else 0 end flag
					from all_models a
				  ) alias;

select * from all_products_flag_avg_price

--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

with cte(maker, model, price) as
   (
	select p.maker, p.model, pr.price
	from product p join printer pr
	on p.model = pr.model
   )

select * from cte
where maker = 'A'
and price > (select avg(price) from cte where maker in ('C', 'D'))


--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model

with cte(maker, model, price) as
   (select maker, p.model, price
    from product p join
						(select model, price from printer
				 		 union all
				 		 select model, price from pc
				 		 union all
				 		 select model, price from laptop
						) t
   on t.model = p.model
   )

select model from cte
where maker = 'A'
and price > (select avg(price)
             from cte
             where maker in ('C', 'D')
            )


--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc)
with cte(maker, model, price) as
   (select maker, p.model, price
    from product p join
						(select model, price from printer
				 		 union all
				 		 select model, price from pc
				 		 union all
				 		 select model, price from laptop
						) t
   on t.model = p.model
   )

select avg(price) from cte
where maker = 'A'



--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count

--drop view count_products_by_makers;

create view count_products_by_makers as
    select maker, count(*)
    from product p join
						(select model, price from printer
				 		 union all
				 		 select model, price from pc
				 		 union all
				 		 select model, price from laptop
						) t
   on t.model = p.model
   group by maker

--select * from count_products_by_makers

--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count)

request = """
select * from count_products_by_makers
order by count desc
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df.maker.to_list(), y=df['count'].to_list(), labels={'x':'maker', 'y':'count'})
fig.show()


--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D'

--drop table printer_updated;

create table printer_updated as 
select pr.*
from product p join printer pr
on pr.model = p.model
where maker != 'D'

--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers)

--drop view printer_updated_with_makers;
create view printer_updated_with_makers as
select p.maker, pu.* from printer_updated pu join product p
on pu.model = p.model

--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes).
-- Во view: count, class (если значения класса нет/IS NULL, то заменить на 0)

--drop view sunk_ships_by_classes;
create view sunk_ships_by_classes as
select * from
	(
with all_ships as
	 (
	 select name, class from ships
	 union all
	 select class as name, class from classes
	 ) 
	
	select coalesce(a.class, '0') as class, count(*) as cnt_sunk
	from outcomes o left join all_ships a
	on o.ship = a.name
	where result = 'sunk'
	group by a.class
) t
select * from sunk_ships_by_classes;

--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

request = """
select * from sunk_ships_by_classes
order by cnt_sunk desc
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df['class'].to_list(), y=df['cnt_sunk'].to_list(), labels={'x':'class', 'y':'cnt_sunk'})
fig.show()


--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag:
-- если количество орудий больше или равно 9 - то 1, иначе 0

create table classes_with_flag as
select c.*,
       case when numguns >= 9 then 1 else 0 end flag
from classes c

select * from classes_with_flag

--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)

request = """
select country, count(*) as cnt_class from classes
group by country
order by 2 desc 
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df['country'].to_list(), y=df['cnt_class'].to_list(), labels={'x':'country', 'y':'cnt_class'})
fig.show()


--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M".

with all_ships as
	 (
	 select name, class from ships
	 union all
	 select class as name, class from classes
	 )
	 
select count(*) from all_ships
where name like 'O%' or name like 'M%' 


--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов.

with all_ships as
	 (
	 select name, class from ships
	 union all
	 select class as name, class from classes
	 )

	 select count(name) from all_ships
	 where trim(name) like '%_ %_'


--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)
	 
request = """
select launched as year, count(*) cnt_ships from ships
group by launched
order by year
"""
df = pd.read_sql_query(request, conn)
fig = px.bar(x=df['year'].to_list(), y=df['cnt_ships'].to_list(), labels={'x':'year', 'y':'cnt_ships'})
fig.show()
