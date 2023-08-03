package com.spring.javaweb6S.vo;

import lombok.Data;

@Data
public class CouponVO {
	private int cp_idx;
	private String cp_name;
	private int cp_exPeriod;
	private int cp_type;
	private int cp_price;
	private double cp_ratio;
	private int cp_useAvailable;
	private int cp_minValue;
	private String cp_update; 
	private String cp_endDate; 
	
	//쿠폰 - 유저 테이블
	private int cu_idx;
	private int m_idx;
	private boolean cu_status;
	private String cu_useDate;
	private String m_mid;
}
