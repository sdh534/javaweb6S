





select o.*, pay.* ,oi.*, p.p_name, p_thumbnailIdx, p_price, cs.cs_status from orders o 
		left join payment pay on o.o_idx = pay.o_idx
		left join orderitems oi on o.o_idx = oi.o_idx
		left join order_cs cs on cs.oi_productCode = oi.oi_productCode
		left join product p on oi.p_idx = p.p_idx
where cs_status is null	order by o.o_date desc

		select od.*, o.*, oi.*, p.pay_date, o.m_mid from orderdetail od
		inner join orders o on od.o_idx = o.o_idx 
		inner join payment p on p.o_idx = od.o_idx 
		inner join orderitems oi on oi.o_idx = o.o_idx 
		where o_status = '배송준비' group by o.o_orderCode
		
select p.* from orders o 
		inner join orderitems oi on o.o_idx = oi.o_idx
		inner join product p on oi.p_idx = p.p_idx	
		inner join orderdetail od on od.o_idx = o.o_idx	
		where o.o_idx =15
		
		
		select p.p_name, p_thumbnailIdx, p_price, cs_status from orders o 
		inner join orderitems oi on o.o_idx = oi.o_idx
		inner join product p on oi.p_idx = p.p_idx	
		inner join orderdetail od on od.o_idx = o.o_idx	
		left join order_cs cs on cs.oi_productCode = oi.oi_productCode
		where o.o_idx = 15
		
	select p.p_name, p_thumbnailIdx, p_price, cs.* from orders o 
		inner join orderitems oi on o.o_idx = oi.o_idx
		inner join product p on oi.p_idx = p.p_idx	
		inner join orderdetail od on od.o_idx = o.o_idx	
		left join order_cs cs on cs.oi_productCode = oi.oi_productCode
		where o.o_idx = 15