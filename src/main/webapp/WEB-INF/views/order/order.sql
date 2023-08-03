--주문 테이블

--order 삽입 -> detail 삽입 -> payment 삽입
create table orders (
	o_idx int not null auto_increment,
	m_mid varchar(20) not null,
	o_date datetime not null default now(),
	o_status varchar(20) not null,
	o_cStatus varchar(20),
	primary key(o_idx), /*멤버테이블 삭제 혹은 수정 시 자동 갱신*/
	foreign key(m_mid) references smember(m_mid)  on delete cascade on update cascade
);

--주문정보 - (배송시 사용)를 저장하는 테이블 ... 
create table orderDetail (
	od_idx int not null auto_increment,
	o_idx int not null,
	attn_name varchar(20) not null,
	attn_phone varchar(15) not null,
	attn_email varchar(40) not null,
	attn_address varchar(100) not null,
	od_detail text,
	primary key (od_idx),
	foreign key(o_idx) references orders(o_idx)  on delete cascade on update cascade
);

create table payment (
	pay_idx int not null auto_increment,
	o_idx int not null,
	imp_uid varchar(50) not null,
	pay_method varchar(20) not null,
	pay_date datetime not null default now(), 
	pay_price int not null,
	pay_plusPrice int,
	pay_vbankPrice int,
	pay_vbankName varchar(20),
	pay_vbankNumber varchar(50),
	pay_vbankDate datetime,
	pay_cardCode varchar(20),
	pay_cardName varchar(20),
	pay_bankCode varchar(50),
	pay_bankName varchar(20),
	primary key (pay_idx),
	foreign key(o_idx) references orders(o_idx)  on delete cascade on update cascade
);

--주문한 상품의 정보를 저장하는 테이블 
create table orderItems (
	o_idx int not null,
	p_idx int not null,
	od_amount int not null,
	foreign key(o_idx) references orders(o_idx)  on delete cascade on update cascade
);

create table cart(
	cart_idx int not null auto_increment,
	m_mid varchar(20) not null, 
	p_idx int not null,
	od_amount int not null default 1,
	primary key (cart_idx),
	foreign key (m_mid) references smember(m_mid) on update cascade on delete cascade,
	foreign key (p_idx) references product(p_idx) on update cascade on delete cascade
);

create table coupon(
	cp_idx int not null auto_increment,
	m_mid varchar(20) not null,
	cp_name varchar(50) not null,
	cp_minValue int,
	cp_percentage int,
	cp_price int,
	cp_date datetime,
	primary key(cp_idx),
	foreign key (m_mid) references smember(m_mid) on update cascade on delete cascade
);

drop table coupon;

drop table orderitems;
drop table payment;
drop table orderDetail;
drop table orders;

select sum(pay_price) as total from orders o right outer join payment od on o.o_idx = od.o_idx;

alter table orderItems add column oi_productCode varchar(13) not null;

--주문자 정보
select p.*, m_mid, o_date, o_status, o_cStatus from orders o, payment p where p.o_idx = o.o_idx;
--배송지 정보
select od.*, m_mid, o_date, o_status, o_cStatus from orders o, orderDetail od where od.o_idx = o.o_idx;
--주문한 상품 정보 
select o.o_orderCode, od.attn_address, p.* from orders o, orderdetail od, payment p where o.o_orderCode = 'D20230711e9bf' and o.o_idx= od.o_idx and o.o_idx = p.o_idx;

select * from payment;
--느리다...
select m_mid, o_date, o_orderCode, o_status , pay.* ,oi.od_amount, oi.p_idx, p.p_name, p_image from orders o 
left join payment pay on o.o_idx = pay.o_idx
left join orderitems oi on o.o_idx = oi.o_idx
left join product p on oi.p_idx = p.p_idx 
--속도개선?
select o.*, od.*, oi.*, p.* from 
orders o inner join orderdetail od on o.o_idx = od.o_idx 
inner join payment p on o.o_idx = p.o_idx
inner join orderitems oi on o.o_idx = oi.o_idx
where o.o_idx = p.o_idx and od.o_idx = o.o_idx;
-
select m.c_middleName as label, count(m.c_middleCode) as data from orderitems oi left join product p on oi.p_idx = p.p_idx
left join c_middlecategory m on p.c_middleCode = m.c_middleCode GROUP BY m.c_middleCode;

select o.*, pay.* ,oi.od_amount, oi.p_idx, oi.oi_productCode, p.p_name, p_thumbnailIdx, p_price from orders o 
		left join payment pay on o.o_idx = pay.o_idx
		left join orderitems oi on o.o_idx = oi.o_idx
		left join product p on oi.p_idx = p.p_idx	order by o.o_date desc; 

select o.*, pay.* ,oi.od_amount, oi.p_idx, p.p_name, p_thumbnailIdx, p_price from orders o 
		left join payment pay on o.o_idx = pay.o_idx
		left join orderitems oi on o.o_idx = oi.o_idx
		left join product p on oi.p_idx = p.p_idx 
		where o_status IN ('결제대기');
		
		select o.*, pay.* ,oi.od_amount, oi.p_idx, oi.oi_productCode, p.p_name, p_thumbnailIdx, p_price from orders o    left join payment pay on o.o_idx = pay.o_idx   left join orderitems oi on o.o_idx = oi.o_idx   left join product p on oi.p_idx = p.p_idx     WHERE pay_method IN    (    ?    )      o_status IN     (     ?     )
		
select month(o_date) as mon, sum(pay_price) as total from orders o
left join payment p on o.o_idx = p.o_idx
group by mon;



		select o.*, pay.* ,oi.od_amount, oi.p_idx, p.p_name, p_thumbnailIdx, p_price from orders o 
		inner join payment pay on o.o_idx = pay.o_idx
		inner join orderitems oi on o.o_idx = oi.o_idx
		inner join product p on oi.p_idx = p.p_idx 
		inner join order_cs cs on cs.o_idx = o.o_idx
		where oi_productCode = 'P20230711E1E1';
		
		
	select imp_uid from orderitems oi
	inner join orders o on o.o_idx = oi.o_idx
	inner join payment p on p.o_idx = oi.o_idx
	where o_status = '결제대기';
	
	select o.o_orderCode from orderitems oi
	inner join orders o on o.o_idx = oi.o_idx
	inner join payment p on p.o_idx = oi.o_idx
	where imp_uid = 'imp_257161021992' group by o.o_idx;
	
	
	select m.m_mid, m_level, count(o_idx) as orderCount from smember m 
	inner join orders o on m.m_mid = o.m_mid
	where m_level != 0
	group by m_mid;
