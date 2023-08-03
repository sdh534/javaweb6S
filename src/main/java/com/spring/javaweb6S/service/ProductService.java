package com.spring.javaweb6S.service;

import java.util.ArrayList;

import com.spring.javaweb6S.vo.CategoryVO;
import com.spring.javaweb6S.vo.ProductVO;
import com.spring.javaweb6S.vo.QnaVO;
import com.spring.javaweb6S.vo.ReviewVO;

public interface ProductService {

	public ProductVO getProductInfo(int p_idx);

	public ArrayList<ProductVO> getProductList(String category, String value);

	public ArrayList<ProductVO> getProductPageList(String category, String search, int startIndexNo, int pageSize, String sort);

	public ArrayList<ProductVO> getProductNewPageList(int startIndexNo, int pageSize);

	public int insertQnA(QnaVO vo);

	public ArrayList<QnaVO> getQnAList(int p_idx, int startIndexNo, int pageSize, String sortAnswer);

	public ArrayList<CategoryVO> getCategory(String c_mainCode);

	public ArrayList<ProductVO> getHomeProduct();

	public ArrayList<ProductVO> getProductSearchList(String searchKeyword, int startIndexNo, int pageSize, String sort);

	public ArrayList<ReviewVO> getHomeReview();

	public String getMainCategoryName(String mainCode);



}
