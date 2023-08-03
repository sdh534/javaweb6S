package com.spring.javaweb6S.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;

import com.spring.javaweb6S.vo.AnnounceVO;
import com.spring.javaweb6S.vo.CategoryVO;
import com.spring.javaweb6S.vo.ChartVO;
import com.spring.javaweb6S.vo.CouponVO;
import com.spring.javaweb6S.vo.InquiryVO;
import com.spring.javaweb6S.vo.MemberVO;
import com.spring.javaweb6S.vo.OrderVO;
import com.spring.javaweb6S.vo.ProductVO;
import com.spring.javaweb6S.vo.QnaVO;
import com.spring.javaweb6S.vo.SearchVO;

public interface AdminDAO {

	public int setMainCategoryInsert(@Param("vo") CategoryVO vo);

	public CategoryVO getMainCategory(@Param("c_mainCode") char c_mainCode, @Param("c_mainName") String c_mainName);

	public ArrayList<CategoryVO> getAllMainCategory();

	public CategoryVO getMiddleCategoryExist(@Param("vo") CategoryVO vo);

	public void setMiddleCategoryInsert(@Param("vo") CategoryVO vo);

	public ArrayList<CategoryVO> getAllMiddleCategory();

	public List<CategoryVO> getMiddleCategoryCode(@Param("c_mainCode") String c_mainCode);

	public int addProduct(@Param("vo") ProductVO vo);

	public int deleteMiddleCategory(@Param("c_middleCode") String c_middleCode);

	public void deleteMainCategory(@Param("c_mainCode") String c_mainCode);

	public List<ProductVO> getAllProduct();

	public ProductVO getProduct(@Param("p_idx") int p_idx);

	public int updateProductInt(@Param("p_idx") int p_idx, @Param("updateCol") String updateCol,
			@Param("updateValInt") int updateValInt);

	public int updateProduct(@Param("p_idx") int p_idx, @Param("updateCol") String updateCol,
			@Param("updateVal") String updateVal);

	public int updateProductAll(@Param("vo") ProductVO vo);

	public String getImageFile(@Param("p_idx") int p_idx);

	public int getAllTotal();

	public List<OrderVO> getAllOrder();

	public List<OrderVO> getOrder(@Param("pay_method") String[] pay_method, @Param("o_status") String[] o_status,
			@Param("o_cStatus") String[] o_cStatus, @Param("durationCategory") String durationCategory,
			@Param("startDate") String startDate, @Param("endDate") String endDate,
			@Param("searchCategory") String searchCategory, @Param("searchKeyword") String searchKeyword);

	public String[] getCategoryLabel();

	public List<ChartVO> getCategoryData();

	public List<OrderVO> monthTotalPrice();

	public int couponInsert(@Param("vo") CouponVO vo);

	public ArrayList<CouponVO> getCouponList();

	public int couponUpdate(@Param("vo") CouponVO vo);

	public int totRecCntCoupon();

	public ArrayList<CouponVO> getCouponPageList(@Param("startIndexNo") int startIndexNo,
			@Param("pageSize") int pageSize);

	public ArrayList<CouponVO> getCouponAvailableList();

	public ArrayList<CouponVO> getUserCouponList(@Param("level") int level, @Param("cp_idx") int cp_idx);

	public int[] getUserLevelList(@Param("level") int level);

	public CouponVO getMemberCouponList(@Param("m_idx") int m_idx, @Param("cp_idx") int cp_idx);

	public void giveMemberCoupon(@Param("m_idx") int m_idx, @Param("cp_idx") int cp_idx);

	public List<OrderVO> getAllCS();

	public OrderVO getOrderInfo(@Param("o_idx") int o_idx);

	public ArrayList<OrderVO> getDeliveryStart();

	public void updateCustomerStatus(@Param("cs_admin") String cs_admin, @Param("cs_idx") int cs_idx,
			@Param("status") String status, @Param("refund_amount") int refund_amount);

	public void updateOrderStatus(@Param("oi_productCode") String oi_productCode,
			@Param("updateStatus") String updateStatus);

	public List<OrderVO> allOrderChangeList();

	public ArrayList<OrderVO> getProductOrder(@Param("o_idx") int o_idx);

	public void deliveryUpdate(@Param("o_idx") String o_idx, @Param("deliveryCom") String deliveryCom,
			@Param("deliveryCode") String deliveryCode);

	public void deliveryStatusUpdate(@Param("o_idx") String o_idx, @Param("status") String status);

	public ArrayList<QnaVO> getAllQnA();

	public int updateQnA(@Param("answer_context") String answer_context, @Param("qna_idx") int qna_idx);

	public int getQnaNoAnswer();

	public int totRecCntQnA();

	public ArrayList<QnaVO> getQnAList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public int totRecCntQnASearch();

	public int getQnASearchRec(@Param("openSw") String[] openSw, @Param("answerOK") String[] answerOK,
			@Param("vo") SearchVO vo);

	public List<QnaVO> getQnASearch(@Param("openSw") String[] openSw, @Param("answerOK") String[] answerOK,
			@Param("vo") SearchVO vo, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public void updateCS(@Param("oi_productCodes") String[] oi_productCodes, @Param("updateStatus") String updateStatus);

	public OrderVO getOrderbyProductCode(@Param("oi_productCode") String oi_productCode);

	public int totRecCntInquiry();

	public ArrayList<InquiryVO> getInquiryList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public int updateInqAnswer(@Param("inq_idx") int inq_idx, @Param("inq_answerContext") String inq_answerContext);

	public int getRefundTotal();

	public int getInqNoAnswer();

	public int totRecCntCouponUser();

	public ArrayList<CouponVO> getCouponUserList(@Param("startIndexNo") int startIndexNo,
			@Param("pageSize") int pageSize);

	public int setNewAnnounce(@Param("vo") AnnounceVO vo);

	public List<AnnounceVO> getAllAnnounce(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize,
			@Param("searchCategory") String searchCategory, @Param("searchKeyword") String searchKeyword);

	public int totRecAnnCnt(@Param("searchCategory") String searchCategory, @Param("searchKeyword") String searchKeyword);

	public AnnounceVO getNotice(@Param("ann_idx") int ann_idx);

	public ArrayList<InquiryVO> getPrevNextAnn(@Param("ann_idx") int ann_idx);

	public int deleteAnnounce(@Param("ann_idx") int ann_idx);

	public List<ChartVO> refundCategory();

	public List<ChartVO> memberRank();

	public List<ChartVO> memberLevelCnt();

	public int getProductOrderCnt(@Param("p_idx") int p_idx);

	public void getProductDelete(@Param("p_idx") int p_idx);

	public int getDeliverCnt();

	public int getCSCnt();

	public int memberDelete(@Param("m_idx") int m_idx);

	public int getMiddleCategoryCnt(@Param("c_middleCode") String c_middleCode);

}
