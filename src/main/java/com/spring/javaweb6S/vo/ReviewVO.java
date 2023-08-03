package com.spring.javaweb6S.vo;

import lombok.Data;

@Data
public class ReviewVO {
	private int review_idx;
	private String m_mid;
	private String  oi_productCode;
	private String  review_content;
	private String review_photo;
	private double review_rating;
	private int review_Del;
	private String review_DelContent;
	private String review_date;
	private String m_photo;
	private int review_thumb;
	
	
	private String p_name;
	private int p_idx;
	private String p_thumbnailIdx;
}
