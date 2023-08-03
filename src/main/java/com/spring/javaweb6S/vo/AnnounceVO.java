package com.spring.javaweb6S.vo;

import lombok.Data;

@Data
public class AnnounceVO {
	private int ann_idx;
	private String ann_title;
	private String ann_context;
	private String ann_wDate;
	private int ann_viewCnt;
}
