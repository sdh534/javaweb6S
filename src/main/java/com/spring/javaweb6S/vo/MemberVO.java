package com.spring.javaweb6S.vo;

import lombok.Data;

@Data
public class MemberVO {
	private int m_idx;
	private String m_mid;
	private String m_name;
	private String m_pwd;
	private String m_email;
	private String m_nickName;
	private String m_phone;
	private String m_address;
	private String m_birthday;
	private String m_mailOk;
	private char m_userDel;
	private String m_photo;
	private int m_point;
	private int m_level;
	private String m_startDate;
	private String m_lastDate;
	
	private int orderCount;
	private int delDiff;
	private String m_levelStr;
	private int m_pointRatio;
}
