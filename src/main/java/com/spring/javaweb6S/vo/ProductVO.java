package com.spring.javaweb6S.vo;

import lombok.Data;

@Data
public class ProductVO {
	private int p_idx;
	private String p_name;
	private int p_amount;
	private int p_price;
	private int p_origPrice;
	private String p_info;
	private String p_image;
	private String p_content;
	private int p_sellStatus;
	private boolean p_saleStatus;
	private boolean couponAvailable;
	private char c_mainCode;
	private String c_middleCode;
	private String p_thumbnailIdx;
	
	private String c_mainName;
	private String c_middleName;
	
	private String p_allIdx;
	private String productModify;
	private String productDelete;
	
	private double p_rating;
	private int p_reviewCnt;
	//주문할때 필요한 주문수량
	private int od_amount;
	private int totalPrice;

//	private MultipartFile file;
}
