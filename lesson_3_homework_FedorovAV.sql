--task1
--�������: ��� ������� ������ ���������� ����� �������� ����� ������, ����������� � ���������.
-- �������: ����� � ����� ����������� ��������.


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
--�������: ��� ������� ������ ���������� ���, ����� ��� ������ �� ���� ������ ������� ����� ������.
-- ���� ��� ������ �� ���� ��������� ������� ����������,
-- ���������� ����������� ��� ������ �� ���� �������� ����� ������. �������: �����, ���.

select c.class, min(launched) "launch year"
from classes c   full join ships s
on c.class=s.class
group by c.class

--task3
--�������: ��� �������, ������� ������ � ���� ����������� �������� � �� ����� 3 �������� � ���� ������,
-- ������� ��� ������ � ����� ����������� ��������.

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
having count(*) > 2 and count(ship) > 0 -- count(*) - ����� �������� � ������, count(ship) - ����� �����������


--task4
--�������: ������� �������� ��������, ������� ���������� ����� ������
-- ����� ���� �������� ������ �� ������������� (������ ������� �� ������� Outcomes).

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
-- ������������ �����: ������� �������������� ���������,
-- ������� ���������� �� � ���������� ������� RAM � � ����� ������� ����������� ����� ���� ��,
-- ������� ���������� ����� RAM. �������: Maker

select distinct maker from product p join pc
on p.model = pc.model
where p.maker in (select maker from product
                  where type = 'printer')
and p.type = 'pc'
and pc.speed = (select max(speed) from pc where ram = (select min(ram) from pc))
and pc.ram = (select min(ram) from pc)           
             