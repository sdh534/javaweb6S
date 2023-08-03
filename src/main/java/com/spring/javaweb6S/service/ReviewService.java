package com.spring.javaweb6S.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.spring.javaweb6S.vo.OrderVO;
import com.spring.javaweb6S.vo.ReviewVO;

public interface ReviewService {

	public int newReviewInsert(ReviewVO vo, List<MultipartFile> fileList);

	public ArrayList<ReviewVO> getProductReview(int p_idx);

	public double getProductRating(int p_idx);

	public int newCSInsert(OrderVO vo, List<MultipartFile> fileList);

	public int getOrderReview(String oi_productCode);

	public int setReviewThumb(int review_idx);

	public int ReviewUpdate(ReviewVO vo, List<MultipartFile> fileList);

	public ArrayList<ReviewVO> getProductReviewList(int p_idx, int startIndexNo, int pageSizeReview);



}
