package com.spring.javaweb6S.dao;

import java.util.ArrayList;

import org.apache.ibatis.annotations.Param;

import com.spring.javaweb6S.vo.CategoryVO;
import com.spring.javaweb6S.vo.ProductVO;
import com.spring.javaweb6S.vo.QnaVO;
import com.spring.javaweb6S.vo.ReviewVO;

public interface ProductDAO {

	public ProductVO getProductInfo(@Param("p_idx") int p_idx);

	public ArrayList<ProductVO> getProductList(@Param("category") String category, @Param("value") String value);

	public int totRecCnt(@Param("part") String part, @Param("searchString") String searchString);

	public ArrayList<ProductVO> getProductPageList(@Param("category") String category, @Param("search") String search,
			@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("sort") String sort);

	public ArrayList<ProductVO> getProductNewPageList(@Param("startIndexNo") int startIndexNo,
			@Param("pageSize") int pageSize);

	public int insertQnA(@Param("vo") QnaVO vo);

	public ArrayList<QnaVO> getQnAList(@Param("p_idx") int p_idx, @Param("startIndexNo") int startIndexNo,
			@Param("pageSize") int pageSize, @Param("answerOK") String answerOK);

	public int totRecQnACnt(@Param("p_idx") int p_idx);

	public ArrayList<ProductVO> getProductListLatest(String category, String search, int startIndexNo, int pageSize);

	public ArrayList<CategoryVO> getCategory(@Param("c_mainCode") String c_mainCode);

	public int totRecReviewCnt(@Param("p_idx") int p_idx);

	public ArrayList<ProductVO> getHomeProduct();

	public int totSearchCnt(@Param("searchKeyword") String searchKeyword);

	public ArrayList<ProductVO> getProductSearchList(@Param("searchKeyword") String searchKeyword,
			@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize, @Param("sort") String sort);

	public ArrayList<ReviewVO> getHomeReview();

	public String getMainCategoryName(@Param("mainCode") String mainCode);

	public int totRecQnASortCnt(@Param("p_idx") int p_idx, @Param("answerOK") String answerOK);

}
