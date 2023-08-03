package com.spring.javaweb6S.vo;

import lombok.Data;

@Data
public class QnaVO {
	
	private int qna_idx; 
	private String m_mid;
	private String qna_context;
	private String openSw;
	private String qna_Date;
	private String answer_context;
	private String answerOK;
	private String answer_Date;
	
	
	private String p_name;
	private int p_idx;
	private String p_thumbnailIdx;
}
