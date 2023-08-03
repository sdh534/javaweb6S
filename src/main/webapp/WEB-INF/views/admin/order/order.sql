
create table order_cs(
	cs_idx int not null auto_increment primary key,
	o_idx int not null,
	cs_context varchar(500) not null,
	cs_category varchar(20) not null,
	cs_img varchar(100) not null,
	foreign key(o_idx) references orders(o_idx) on delete cascade on update cascade
);

drop table order_cs;

select o.*, cs.*,oi.od_amount, oi.p_idx, oi.oi_productCode, p.p_name, p_thumbnailIdx, p_price 
from orders o 
		left join orderitems oi on o.o_idx = oi.o_idx
		left join product p on oi.p_idx = p.p_idx	
		left join order_cs cs on cs.o_idx = o.o_idx
		where o_cStatus != ''
		order by o.o_date desc;
		
		select od.*, o.o_date, p.pay_date, o.m_mid from orderdetail od
		inner join orders o on od.o_idx = o.o_idx 
		inner join payment p on p.o_idx = od.o_idx 
		where o_status = '배송준비'
		
		
		
update order_cs set cs_admin = "13252151325" where cs_idx = 1;

select o.*, cs.*,oi.od_amount, oi.p_idx, oi.oi_productCode, p.p_name, p_thumbnailIdx, p_price, pay.*, cu.cu_status, cp.cp_name
		from orders o 
		inner join orderitems oi on o.o_idx = oi.o_idx
		inner join product p on oi.p_idx = p.p_idx	
		left join order_cs cs on cs.o_idx = o.o_idx
		left join payment pay on pay.o_idx = o.o_idx
		left join coupon_user cu on pay.cu_idx = cu.cu_idx
		left join coupon cp on cp.cp_idx = cu.cp_idx 
		where o.o_idx = 14
		
alter table orderitems add primary key (oi_productCode)
alter table order_cs add column oi_productCode varchar(13) not null
alter table order_cs add foreign key (oi_productCode) references orderitems(oi_productCode)


select o.*, pay.* ,oi.od_amount, oi.p_idx, oi.oi_productCode, p.p_name, p_thumbnailIdx, p_price, cs.* from orders o 
		left join payment pay on o.o_idx = pay.o_idx
		left join orderitems oi on o.o_idx = oi.o_idx
		left join product p on oi.p_idx = p.p_idx
		left join order_cs cs on cs.oi_productCode = oi.oi_productCode
		where o.m_mid = 'sdh534'
		order by o.o_date desc;
		
		
	select cp_type, cp_price, cp_ratio, cp_minValue from payment p 
	inner join coupon_user cu on p.cu_idx =cu.cu_idx 
	inner join coupon cp on cp.cp_idx = cu.cp_idx
	where o_idx = 14;

	select *, p_name, p_thumbnailIdx from product_qna q
		inner join product p on p.p_idx = q.p_idx
		order by qna_Date
		
		
		select *, p_name, p_thumbnailIdx 
		from product_qna q
		left join product p on p.p_idx = q.p_idx 
		where	
		qna_Date between '2023-07-24 00:00:00' AND  '2023-07-24 23:59:59';
		
--취소한 주문을 제외한다 	
select sum(p) as total from 
(select pay_price as p from orders o 
inner join payment od on o.o_idx = od.o_idx
inner join orderitems oi on oi.o_idx = o.o_idx
left join order_cs cs on o.o_idx = cs.o_idx
where o_status not like '%주문취소%'
group by o.o_idx) as idx
; 
		
select sum(refund_amount) as total from orders o 
inner join payment od on o.o_idx = od.o_idx
left join order_cs cs on o.o_idx = cs.o_idx
;
			