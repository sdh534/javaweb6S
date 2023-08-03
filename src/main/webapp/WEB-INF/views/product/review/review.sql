create table sreview(
	review_idx int not null auto_increment,
	m_mid varchar(20) not null,
	p_idx int not null,
	oi_productCode varchar(13) not null,
	review_content text not null,
	review_photo varchar(100) not null,
	review_rating double not null,
	review_Del int default 0,
	review_DelContent text,
	primary key(review_idx)
);

	select p.*, ifnull(review_rating,0) as p_rating from product p
	left join sreview r on r.p_idx = p.p_idx  where c_middleCode = '08' group by p.p_idx;
	
	select avg(review_rating), count(*) from sreview where p_idx = 22
	
		select review.*, m_photo from sreview review
		inner join smember mem on mem.m_mid = review.m_mid
		where p_idx = 22

drop table sreview;
alter table sreview add foreign key (oi_productCode) references on orderitems(oi_productCode);