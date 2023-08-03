create table cart(
	cart_idx int not null auto_increment,
	m_mid varchar(20) not null, 
	p_idx int not null,
	od_count int not null default 1,
	primary key (cart_idx),
	foreign key (m_mid) references smember(m_mid) on update cascade on delete cascade,
	foreign key (p_idx) references product(p_idx) on update cascade on delete cascade
);

create table wishlist(
	p_idx int not null,
	foreign key (p_idx) references product(p_idx) on update cascade on delete cascade
);
drop table cart;