create table c_mainCategory(
	c_mainCode char(1) not null,
	c_mainName varchar(20) not null,
	primary key(c_mainCode),
  unique key(c_mainName)
);

create table c_middlecategory(
	c_mainCode char(1) not null,
	c_middleCode char(2) not null,
	c_middleName varchar(20) not null,
	primary key(c_middleCode),
 	foreign key(c_mainCode) references c_mainCategory(c_mainCode)  on delete cascade
);

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
show tables;
drop table c_middlecategory
drop table product

select c_middlecategory.*, c_mainCategory.c_mainName as c_mainName 
from c_middlecategory, c_mainCategory
where c_middlecategory.c_mainCode = c_mainCategory.c_mainCode
order by c_middleCode desc;

drop table order_cs;

create table order_cs(
	cs_idx int not null auto_increment primary key,
	o_idx int not null,
	cs_context varchar(500) not null,
	cs_category varchar(20) not null,
	cs_img varchar(100) not null,
	foreign key(o_idx) references orders(o_idx) on delete cascade on update cascade
);
