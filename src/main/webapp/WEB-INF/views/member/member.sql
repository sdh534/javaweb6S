show tables;


create table sMember(
	m_idx int not null auto_increment,
	m_mid varchar(20) not null,
	m_name varchar(10) not null,
	m_pwd varchar(100) not null,
	m_email varchar(50) not null,
	m_nickName varchar(20) not null,
	m_phone varchar(15),/* 123-4567-8910*/
	m_address varchar(100),
	m_birthday datetime,
	m_mailOk varchar(2),
	m_userDel char(1) default 'N',
	m_photo varchar(50) default 'noImage.jpg',
	m_point int default 100,
	m_level int default 1, /* 0: 관리자 / 1: 브론즈 / 2: 실버 / 3: 골드 / 4: VIP */
	m_startDate datetime default now(),
	primary key(m_idx),
	unique key(m_mid)
);

create table point(
	point_idx int not null auto_increment,
	m_mid varchar(10) not null,
	oi_productCode varchar(13) not null,
	point_category varchar(10) not null,
	point_amount int not null
);

drop table sMember;

select o.*, pay.pay_price, p.p_name  from orders o
left join payment pay on o.o_idx = pay.o_idx
left join orderitems oi on oi.o_idx = o.o_idx
left join product p on oi.p_idx = p.p_idx
where m_mid = 'hkd1234' order by o.o_date desc;

select cu.*, c.*, DATE_ADD(cu_useDate, interval cp_exPeriod day) from coupon_user cu
left join coupon c on cu.cp_idx = c.cp_idx
where m_idx = 2;


create table memberLevel(
	m_level int not null,
	m_levelStr varchar(30) not null ,
	m_pointRatio int not null,
	primary key(m_level)
);

insert into memberLevel values 
(4, "VIP", 10);

alter table smember add foreign key 


select lv.m_pointRatio from smember s inner join memberlevel lv on s.m_level = lv.m_level
where m_mid = 'hkd1234'

select count(*) from sreview where oi_productCode = 'P20230711DAB1';


