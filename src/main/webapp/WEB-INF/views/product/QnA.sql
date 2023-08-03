create table product_QnA(
	qna_idx int not null primary key,
	p_idx int not null,
	m_mid varchar(20) not null,
	qna_context varchar(500) not null,
	openSw char(2) not null default 'OK', /* 공개 여부, 기본 공개 OK, 비공개 NO */
	wDate datetime not null default now(),
	answerContext varchar(500) not null,
	answerOK char(2) not null default 'OK' /* 답변 여부, 기본 NO, 등록시 OK*/
);

create table home_product(
	p_idx int not null,
	foreign key (p_idx) references product(p_idx) on update cascade on delete cascade
);