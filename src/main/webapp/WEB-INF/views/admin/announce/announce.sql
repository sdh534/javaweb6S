create table announce(
	ann_idx int not null auto_increment primary key,
	ann_title varchar(20) not null,
	ann_content text not null,
	ann_wDate datetime not null default now(),
	ann_viewCnt int not null default 0
);