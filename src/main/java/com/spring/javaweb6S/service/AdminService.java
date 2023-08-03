package com.spring.javaweb6S.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.spring.javaweb6S.vo.AnnounceVO;
import com.spring.javaweb6S.vo.CategoryVO;
import com.spring.javaweb6S.vo.ChartVO;
import com.spring.javaweb6S.vo.CouponVO;
import com.spring.javaweb6S.vo.InquiryVO;
import com.spring.javaweb6S.vo.OrderVO;
import com.spring.javaweb6S.vo.ProductVO;
import com.spring.javaweb6S.vo.QnaVO;
import com.spring.javaweb6S.vo.SearchVO;

public interface AdminService {

	public int setMainCategoryInsert(CategoryVO vo);

	public CategoryVO getMainCategory(char c_mainCode, String c_mainName);

	public ArrayList<CategoryVO> getAllMainCategory();

	public CategoryVO getMiddleCategoryExist(CategoryVO vo);

	public void setMiddleCategoryInsert(CategoryVO vo);

	public ArrayList<CategoryVO> getAllMiddleCategory();

	public List<CategoryVO> getMiddleCategoryCode(String c_mainCode);

	public int saveProductImg(ProductVO vo, List<MultipartFile> fileList);

	public int deleteMiddleCategory(String c_middleCode);

	public void deleteMainCategory(String c_mainCode);

	public List<ProductVO> getAllProduct();

	public ProductVO getProduct(int p_idx);

	public int updateProductInt(int p_idx, String updateCol, int updateValInt);

	public int updateProduct(int p_idx, String updateCol, String updateVal);

	public int updateProductAll(ProductVO vo, List<MultipartFile> fileList);

	public void ThumbnailDelete(String s);

	public void ContentUpdate(String p_content);

	public void ContentDelete(String p_content);

	public int getAllTotal();

	public List<OrderVO> getAllOrder();

	public List<OrderVO> getOrder(String[] pay_method, String[] o_status, String[] o_cStatus, String durationCategory,
			String startDate, String endDate, String searchCategory, String searchKeyword);

	public String[] getCategoryLabel();

	public List<ChartVO> getCategoryData();

	public List<OrderVO> monthTotalPrice();

	public int couponInsert(CouponVO vo);

	public ArrayList<CouponVO> getCouponList();

	public int couponUpdate(CouponVO vo);

	public ArrayList<CouponVO> getCouponPageList(int startIndexNo, int pageSize);

	public ArrayList<CouponVO> getCouponAvailableList();

	public ArrayList<CouponVO> getUserCouponList(int level, int cp_idx);

	public int[] getUserLevelList(int level);

	public CouponVO getMemberCouponList(int m_idx, int cp_idx);

	public void giveMemberCoupon(int m_idx, int cp_idx);

	public List<OrderVO> getAllCS();

	public OrderVO getOrderInfo(int o_idx);

	public ArrayList<OrderVO> getDeliveryStart();

	public int updateCustomerStatus(String cs_admin, String cancelSelect, String oi_productCode, int cs_idx,
			int refund_amount);

	public void updateOrderStatus(String oi_productCode, String updateStatus);

	public List<OrderVO> allOrderChangeList();

	public ArrayList<OrderVO> getProductOrder(int o_idx);

	public int deliveryUpdate(String deliveryComList, String deliveryIdxList, String deliveryCodeList);

	public ArrayList<QnaVO> getAllQnA();

	public int updateQnA(String answer_context, int qna_idx);

	public int getQnaNoAnswer();

	public ArrayList<QnaVO> getQnAList(int startIndexNo, int pageSize);

	/*
	 * public List<QnaVO> getQnASearch(String[] openSw, String[] answerOK, String
	 * durationCategory, String startDate, String endDate, String searchCategory,
	 * String searchKeyword);
	 */

	public List<QnaVO> getQnASearch(String[] openSw, String[] answerOK, SearchVO vo, int startIndexNo, int pageSize);

	public int getQnASearchRec(String[] openSw, String[] answerOK, SearchVO vo);

	public void updateCS(String[] oi_productCodes, String updateStatus);

	public OrderVO getOrderbyProductCode(String oi_productCode);

	public ArrayList<InquiryVO> getInquiryList(int startIndexNo, int pageSize);

	public int updateInqAnswer(int inq_idx, String inq_answerContext);

	public int getInqNoAnswer();

	public int memberLevelUpdate(String memberIdxList, int m_level);

	public ArrayList<CouponVO> getCouponUserList(int startIndexNo, int pageSize);

	public int setNewAnnounce(AnnounceVO vo);

	public List<AnnounceVO> getAllAnnounce(int startIndexNo, int pageSize, String searchCategory, String searchKeyword);

	public AnnounceVO getNotice(int ann_idx);

	public ArrayList<InquiryVO> getPrevNextAnn(int ann_idx);

	public int deleteAnnounce(int ann_idx);

	public List<ChartVO> refundCategory();

	public List<ChartVO> memberRank();

	public List<ChartVO> memberLevelCnt();

	public int getProductOrderCnt(int p_idx);

	public void getProductDelete(int p_idx);

	public int getDeliverCnt();

	public int getCSCnt();

	public int memberDelete(int m_idx);

	public int getMiddleCategoryCnt(String c_middleCode);

}
