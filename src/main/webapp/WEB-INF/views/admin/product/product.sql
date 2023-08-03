create table product (
	p_idx int not null auto_increment,
	p_name varchar(40) not null,
	p_amount int not null default 0,
	p_price int not null default 0,
	p_origPrice int not null default 0,
	p_image varchar(100) not null default 'productReady.jpg',
	p_content text not null,
	p_info varchar(100),
	p_sellStatus int not null default 0,
	p_saleStatus boolean not null default false,
	p_couponAvailable boolean default true,
	c_mainCode char(1) not null,
	c_middleCode char(2) not null,
	primary key(p_idx),
	foreign key(c_middleCode) references c_middleCategory(c_middleCode),
	foreign key(c_mainCode) references c_mainCategory(c_mainCode) on delete cascade
);
drop table product;

select p.*, cM.c_mainName, cMi.c_middleName from product p inner join c_mainCategory cM on p.c_mainCode = cM.c_mainCode inner join c_middleCategory cMi on p.c_middleCode = cMi.c_middleCode where p_idx =2;

alter table product add constraint 
alter table product add p_ varchar(50);

alter table product add p_thumbnailIdx varchar(50);
alter table product drop p_thumbnailIdx;
select ('2022-08-17', +12) from dual;
update product set p_name = '앤티크 접이식 자석 체스(36x31cm) (브라운+아이보리)' where p_idx = 1;

select * from product where p_idx = 2;
update product set p_amount = p_amount - 2 where p_idx = 2;

select p.*, cM.c_mainName, cMi.c_middleName, avg(review.review_rating)
		from product p inner join c_mainCategory cM on p.c_mainCode = cM.c_mainCode 
		inner join c_middleCategory cMi on p.c_middleCode = cMi.c_middleCode
		inner join sreview review on p.p_idx = review.p_idx 
		where p.p_idx = 22;
		
		
select * from product where c_mainCode='A';

select * from product where c_mainCode='A' order by p_idx asc limit 0 , 20


select p.*, cM.c_mainName, cMi.c_middleName, avg(review.review_rating) as p_rating
		from product p inner join c_mainCategory cM on p.c_mainCode = cM.c_mainCode 
		inner join c_middleCategory cMi on p.c_middleCode = cMi.c_middleCode
		left join sreview review on p.p_idx = review.p_idx 
		where p.p_idx = 34;
		
		select p.* from product p 
		left join sreview r on p.p_idx = r.p_idx
		where c_mainCode = 'A' group by p_idx
		order by avg(review_rating) desc;