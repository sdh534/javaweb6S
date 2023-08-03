package com.spring.javaweb6S.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javaweb6S.dao.ProductDAO;
import com.spring.javaweb6S.vo.CategoryVO;
import com.spring.javaweb6S.vo.ProductVO;
import com.spring.javaweb6S.vo.QnaVO;
import com.spring.javaweb6S.vo.ReviewVO;

@Service
public class ProductServiceImpl implements ProductService {
	@Autowired
	ProductDAO productDAO;

	@Override
	public ProductVO getProductInfo(int p_idx) {
		return productDAO.getProductInfo(p_idx);
	}

	@Override
	public ArrayList<ProductVO> getProductList(String category, String value) {
		return productDAO.getProductList(category, value);
	}

	@Override
	public ArrayList<ProductVO> getProductPageList(String category, String search, int startIndexNo, int pageSize,
			String sort) {
		return productDAO.getProductPageList(category, search, startIndexNo, pageSize, sort);
	}

	@Override
	public ArrayList<ProductVO> getProductNewPageList(int startIndexNo, int pageSize) {
		return productDAO.getProductNewPageList(startIndexNo, pageSize);
	}

	@Override
	public int insertQnA(QnaVO vo) {
		return productDAO.insertQnA(vo);
	}

	@Override
	public ArrayList<QnaVO> getQnAList(int p_idx, int startIndexNo, int pageSize, String sortAnswer) {
		return productDAO.getQnAList(p_idx, startIndexNo, pageSize, sortAnswer);
	}

	@Override
	public ArrayList<CategoryVO> getCategory(String c_mainCode) {
		return productDAO.getCategory(c_mainCode);
	}

	@Override
	public ArrayList<ProductVO> getHomeProduct() {
		return productDAO.getHomeProduct();
	}

	@Override
	public ArrayList<ProductVO> getProductSearchList(String searchKeyword, int startIndexNo, int pageSize, String sort) {
		return productDAO.getProductSearchList(searchKeyword, startIndexNo, pageSize, sort);
	}

	@Override
	public ArrayList<ReviewVO> getHomeReview() {
		return productDAO.getHomeReview();
	}

	@Override
	public String getMainCategoryName(String mainCode) {
		return productDAO.getMainCategoryName(mainCode);
	}

}
