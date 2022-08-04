--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1 (lesson5)
-- ������������ �����: ������� view (pages_all_products),
-- � ������� ����� ������������ �������� ���� ��������� (�� ����� ���� ��������� �� ����� ��������).
-- �����: ��� ������ �� laptop, ����� ��������, ������ ���� �������

--sample:
--1 1
--2 1
--1 2
--2 2
--1 3
--2 3
create view pages_all_products as
(
select * from (
with param(items_of_page) as (
	values(3)
)

select *, row_number() over(partition by ttt.pg_num) as num_item
from (
	  select *, ntile(cast(cnt_pages as int)) over() as pg_num
	  from (
		    select *,
		           case when total % items_of_page = 0 then total/items_of_page else total/items_of_page+1 end as cnt_pages
		    from (select *, count(*) over() total from laptop, param) t
           ) tt
     ) ttt) x)
    
select * from pages_all_products


--task2 (lesson5)
-- ������������ �����: ������� view (distribution_by_type),
-- � ������ �������� ����� ���������� ����������� ���� ������� �� ���� ����������.
-- �����: �������������, ���, ������� (%)

create view distribution_by_type as
(
select maker, type, cast(1.0*cnt_type/total*100 as dec(6,2)) as procent from			   
(select distinct maker, type, count(*) over(partition by maker, type) as cnt_type, count(*) over() as total
from product p
order by maker) t)

select * from distribution_by_type;

--task3 (lesson5)
-- ������������ �����: ������� �� ���� ����������� view ������ - �������� ���������.
-- ������ https://plotly.com/python/histograms/

import matplotlib.pyplot as plt
request = """
select maker, type, procent from distribution_by_type
"""
df = pd.read_sql_query(request, conn)
fig1, ax1 = plt.subplots()
ax1.pie(df.procent, labels=df.maker+'_'+df.type)
ax1.axis('equal')  
plt.show()


--task4 (lesson5)
-- �������: ������� ����� ������� ships (ships_two_words), �� �������� ������� ������ �������� �� ���� ����

create table ships_two_words as
(select * from ships
where trim(name) like '% %')


--task5 (lesson5)
-- �������: ������� ������ ��������, � ������� class ����������� (IS NULL) � �������� ���������� � ����� "S"

select * from ships
where 1=1
and class is NULL
and name like 'S%'


--task6 (lesson5)
-- ������������ �����: ������� ��� �������� ������������� = 'A'
-- �� ���������� ���� ������� �� ��������� ������������� = 'C'
-- � ��� ����� ������� (����� ������� �������). ������� model

with cte(model, price, maker) as (
	select p.model, pr.price, p.maker from product p join printer pr
	on p.model = pr.model)

select model from (
	select model, rank() over(order by price desc) max_price from cte
) t
where max_price < 4
union all
select model from cte
where maker = 'A'
and price > (select avg(price) from cte where maker = 'C')









