create table coupon (
	cp_idx int not null auto_increment, 
	cp_name varchar(20) not null,
	cp_content varchar(50),
	cp_type int not null default 0, 
	cp_price int,
	cp_ratio double,
	cp_status int, /*0:대기 1:사용가능 2:만료*/
	cp_update datetime not null default now(), /* 쿠폰 등록일*/
	cp_useAvailable int not null, /* 쿠폰의 유효기간 */
	cp_minValue int,
	cp_maxValue int,
	primary key(cp_idx)
);

drop table coupon;
drop table coupon_user;

create table coupon_user(
	cu_idx int not null auto_increment,
	cp_idx int not null,
	m_idx int not null, 
	cu_satus boolean not null default false, /*쿠폰 상태 = 유효기간과 발급일을 비교해서 만료된 경우 상태를 바꿈(사용시 true)*/
	cu_useDate datetime default now(), /*쿠폰 발급일*/
	primary key(cu_idx),
	FOREIGN KEY (cp_idx) REFERENCES coupon(cp_idx) on update cascade on delete cascade,
	foreign key (m_idx) references smember(m_idx) on update cascade on delete cascade
);

select cu.*, m.m_level from coupon_user cu
left join coupon cp on cu.cp_idx = cp.cp_idx
left join smember m on cu.m_idx = m.m_idx
where cu.cp_idx=2 ;

alter table payment add column cu_idx int;
alter table payment add foreign key(cu_idx) references coupon_user(cu_idx);
alter table payment drop foreign key cp_idx;



select o.*, cs.*,oi.od_amount, oi.p_idx, oi.oi_productCode, p.p_name, p_thumbnailIdx, p_price, pay.*, cu.cu_status, cp.cp_name
		from orders o 
		inner join orderitems oi on o.o_idx = oi.o_idx
		inner join product p on oi.p_idx = p.p_idx	
		inner join order_cs cs on cs.o_idx = o.o_idx
		inner join payment pay on pay.o_idx = o.o_idx
		left join coupon_user cu on pay.cu_idx = cu.cu_idx
		left join coupon cp on cp.cp_idx = cu.cp_idx 
		where o.o_idx = 8
		
		
		 select cu.*, cp.* from coupon cp
		 inner join coupon_user cu on cp.cp_idx = cu.cp_idx
		 order by cu.cp_idx;