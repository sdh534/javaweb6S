package com.spring.javaweb6S.vo;

import lombok.Data;

@Data
public class InquiryVO {
	private int inq_idx;
	private String m_mid;
	private String oi_productCode;
	private String inq_context;
	private String inq_category;
	private String inq_title;
	private String inq_wDate;
	private String inq_answerContext;
	private String inq_answerDate;
	private String inq_answerOK;
}
