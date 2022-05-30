--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

-- ������� 20: ������� ������� ������ hd PC ������� �� ��� ��������������, ������� ��������� � ��������. �������: maker, ������� ������ HD.

select maker, avg(hd) avg_hd from product p
join pc on p.model = pc.model
where 1=1
and maker in (
			  select distinct maker from product p
	          join printer pr 
	          on p.model = pr.model
	         )
group by maker


-- ������� 1: ������� name, class �� ��������, ���������� ����� 1920
--
select name, class  from ships
where launched > 1920

-- ������� 2: ������� name, class �� ��������, ���������� ����� 1920, �� �� ������� 1942
--

select name, class, launched from ships
where launched between 1921 and 1942

-- ������� 3: ����� ���������� �������� � ������ ������. ������� ���������� � class
--

select class, count(name) from ships
group by class

-- ������� 4: ��� ������� ��������, ������ ������ ������� �� ����� 16, ������� ����� � ������. (������� classes)
--

select class, country from classes c 
where bore >= 16

-- ������� 5: ������� �������, ����������� � ��������� � �������� ��������� (������� Outcomes, North Atlantic). �����: ship.
--

select ship from outcomes o
where battle = 'North Atlantic' and "result" = 'sunk'

-- ������� 6: ������� �������� (ship) ���������� ������������ �������
--

select ship from outcomes o
join battles b 
on o.battle = b."name"
where 1=1
and "result" = 'sunk'
and b."date" = ( select max(date) from outcomes o join battles b --����� ������� ���� ���������� ��������
				 on o.battle = b."name"
				 where "result" = 'sunk'
			   )
			   
--��� ��� ������������� ����������, �� � ������� ��������
			   
select ship from
   (
	select *, rank() over(order by date desc) rnk from outcomes o
	join battles b 
	on o.battle = b."name"
	where 1=1
	and "result" = 'sunk'
   ) t
where rnk=1 --��������� ������ � ������=1 (����� ������� ���� ����������)

-- ������� 7: ������� �������� ������� (ship) � ����� (class) ���������� ������������ �������
--

select t.ship, s.class from --����� ������ ��������� ����������� ��������
   (
	select ship from outcomes o -- �������, ������� �������� ����������
	join battles b 
	on o.battle = b."name"
	where 1=1
	and "result" = 'sunk'
	and b."date" = ( select max(date) from outcomes o join battles b --����� ������� ���� ���������� ��������
					 on o.battle = b."name"
					 where "result" = 'sunk'
				   )
   ) t join (
			select name, class from ships s
			union
			select class as name, class from classes c --�������� ������� � ������
		    ) s
on t.ship = s.name

-- ������� 8: ������� ��� ����������� �������, � ������� ������ ������ �� ����� 16, � ������� ���������. �����: ship, class
--

select tt.ship, c.class from (
								select ship, class from outcomes o --��� ����������� �������
								left join (
										select name, class from ships s --������� �������
										union
										select class as name, class from classes c --�������� ������� � ������
									      ) s
								on o.ship = s.name
								where "result" = 'sunk'
                             ) tt
join classes c on tt.class=c.class
where c.bore >= 16

-- ������� 9: ������� ��� ������ ��������, ���������� ��� (������� classes, country = 'USA'). �����: class
--

select * from classes c
where country = 'USA'

-- ������� 10: ������� ��� �������, ���������� ��� (������� classes & ships, country = 'USA'). �����: name, class

select s.name, c.class from ships s join classes c
on c."class" = s."class" 
where country = 'USA'
