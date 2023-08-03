create table inquiry(
	inquiry_idx int not null auto_increment,
	m_mid varchar(20) not null,
	inquiry_context text not null,
	wDate datetime not null default now(),
	answerContext varchar(500) not null,
	answerOK char(2) not null default 'OK', /* 답변 여부, 기본 NO, 등록시 OK*/
	foreign key(m_mid) references smember(m_mid),
	primary key (inquiry_idx)
);


 	select * from inquiry where inq_idx in (
		  (select inq_idx from inquiry where inq_idx < 2 order by inq_idx desc limit 1),
		  (select inq_idx from inquiry where inq_idx > 2 limit 1));
		  --지금 내 글번호 기준 이전번호와 다음 번호를 가져옴, [0]은 다음글, [1]은 이전글이 된다  