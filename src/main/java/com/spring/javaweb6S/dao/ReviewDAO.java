package com.spring.javaweb6S.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javaweb6S.vo.OrderVO;
import com.spring.javaweb6S.vo.ReviewVO;

public interface ReviewDAO {

	public int newReviewInsert(@Param(value = "vo") ReviewVO vo);

	public ArrayList<ReviewVO> getProductReview(@Param(value = "p_idx") int p_idx);

	public double getProductRating(@Param(value = "p_idx") int p_idx);

	public int newCSInsert(@Param(value = "vo") OrderVO vo);

	public int getOrderReview(@Param(value = "oi_productCode") String oi_productCode);

	public int setReviewThumb(@Param(value = "review_idx") int review_idx);

	public int updateReview(@Param(value = "vo") ReviewVO vo);

	public ArrayList<ReviewVO> getProductReviewList(@Param(value = "p_idx") int p_idx,
			@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

}
