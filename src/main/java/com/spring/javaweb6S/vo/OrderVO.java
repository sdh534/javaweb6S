package com.spring.javaweb6S.vo;

import lombok.Data;

@Data
public class OrderVO {
	//주문정보, 주문 상세정보 모두 하나의 VO에 담는다
	private int o_idx;
	private String m_mid;
	private String o_date;
	private String o_status;
	private String o_orderCode;
	private String o_cStatus;
	
	//상세정보
	private int od_idx;
	private int od_price;
	private int m_idx;
	private int p_idx;
	private int od_amount; //주문수량
	private String attn_name;
	private String attn_phone;
	private String attn_email;
	private String attn_address;
	private String od_detail;
	private String deliveryCompany;
	private String deliveryCode;
	
	//결제정보
	private int pay_idx;
	private String imp_uid; 
	private String pay_method;
	private String pay_date;
	private int pay_price;
	private int pay_point;
	private int pay_plusPrice;
	private int pay_vbankPrice;
	private String pay_vbankNumber;
	private String pay_vbankName;
	private String pay_vbankDate;
	private String pay_cardCode;
	private String pay_cardName;
	private String pay_bankCode;
	private String pay_bankName;
	private boolean refundCoupon;
	
	private String oi_productCode;
	private String oi_status;
	
	private String productList;
	private String amountList;
	
	private String p_name;
	private String p_thumbnailIdx;
	private int p_price;
	
	private int totalPrice;
	
	private int cu_idx;
	private String cp_name;
	
	private int cs_idx;
	private String cs_status;
	private String cs_context;
	private String cs_category;
	private String cs_img;
	private String cancelSelect;
	private String cs_date;
	private String orderModify;
	
	private String cs_admin;
	private int refund_amount;
	private String refund_bank;
	private String refund_holder;
	private String refund_account;
	private String refund_date;
	
	
	private String deliveryCom;

	private String point_date;
	private int point;
	private boolean reviewOK;
	private boolean point_status;
}
