package com.spring.javaweb6S.dao;

import java.util.ArrayList;
import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.spring.javaweb6S.vo.CouponVO;
import com.spring.javaweb6S.vo.InquiryVO;
import com.spring.javaweb6S.vo.MemberVO;
import com.spring.javaweb6S.vo.OrderVO;
import com.spring.javaweb6S.vo.ProductVO;
import com.spring.javaweb6S.vo.QnaVO;
import com.spring.javaweb6S.vo.ReviewVO;
import com.spring.javaweb6S.vo.SearchVO;

public interface MemberDAO {

	public MemberVO getMemberMidCheck(@Param("mid") String mid);

	public int setMemberJoin(@Param("vo") MemberVO vo);

	public List<OrderVO> getAllOrder(@Param("mid") String sMid, @Param("startDate") String startDate,
			@Param("endDate") String endDate, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public int totRecCnt();

	public ArrayList<MemberVO> getAllMember();

	public ArrayList<CouponVO> getUserCoupon(@Param("idx") int idx);

	public ArrayList<ReviewVO> getUserReview(@Param("mid") String sMid);

	public int setMemberDelete(@Param("mid") String sMid);

	public void setMemberUpdate(@Param("vo") MemberVO vo);

	public int getMemberLevel(@Param("sLevel") int sLevel, @Param("mid") String sMid);

	public ArrayList<MemberVO> getMemberPageList(@Param("startIndexNo") int startIndexNo,
			@Param("pageSize") int pageSize);

	public MemberVO getMemberIdFind(@Param("name") String name, @Param("email") String email);

	public void setMemberPwdUpdate(@Param("m_mid") String m_mid, @Param("pwd") String pwd);

	public int deleteQnA(@Param("qna_idx") int qna_idx);

	public int totQnARecCnt(@Param("mid") String mid);

	public ArrayList<QnaVO> getMemberQnAList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize,
			@Param("mid") String mid);

	public int getQnASearchRec(@Param("openSw") String[] openSw, @Param("answerOK") String[] answerOK,
			@Param("vo") SearchVO vo, @Param("mid") String mid);

	public ArrayList<QnaVO> getQnASearch(@Param("openSw") String[] openSw, @Param("answerOK") String[] answerOK,
			@Param("mid") String mid, @Param("vo") SearchVO vo, @Param("startIndexNo") int startIndexNo,
			@Param("pageSize") int pageSize);

	public int deleteReview(@Param("review_idx") int review_idx);

	public ReviewVO getUserReviewOne(@Param("review_idx") int review_idx);

	public int setMemberInquiry(@Param("vo") InquiryVO vo);

	public int totInqRecCnt(@Param("mid") String mid);

	public ArrayList<QnaVO> getMemberInquiryList(@Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize,
			@Param("mid") String mid);

	public InquiryVO getMemberInquiry(@Param("inq_idx") int inq_idx);

	public ArrayList<InquiryVO> getPrevNextInq(@Param("inq_idx") int inq_idx, @Param("mid") String mid);

	public int totLevCnt(@Param("m_level") int m_level);

	public ArrayList<MemberVO> getMemberLevelPageList(@Param("startIndexNo") int startIndexNo,
			@Param("pageSize") int pageSize, @Param("level") int level);

	public void memberLevelUpdate(@Param("m_idx") int m_idx, @Param("m_level") int m_level);

	public void updateLastDate(@Param("m_mid") String m_mid);

	public int totRecOrderCnt(@Param("startDate") String startDate, @Param("endDate") String endDate);

	public int totOrderDate(@Param("startDate") String startDate, @Param("endDate") String endDate,
			@Param("mid") String mid);

	public int totPointDate(@Param("startDate") String startDate, @Param("endDate") String endDate,
			@Param("mid") String mid);

	public List<OrderVO> getAllPoint(@Param("mid") String sMid, @Param("startDate") String startDate,
			@Param("endDate") String endDate, @Param("startIndexNo") int startIndexNo, @Param("pageSize") int pageSize);

	public int[] getWishList(@Param("mid") String sMid, @Param("p_idx") int p_idx);

	public void removeWishList(@Param("p_idx") int p_idx, @Param("mid") String sMid);

	public void addWishList(@Param("p_idx") int p_idx, @Param("mid") String sMid);

	public int getMemberCoupon(@Param("m_idx") int m_idx);

	public int getMemberOrder(@Param("mid") String m_mid);

	public int totwishRecCnt(@Param("mid") String m_mid);

	public List<ProductVO> getAllWishList(@Param("mid") String sMid, @Param("startIndexNo") int startIndexNo,
			@Param("pageSize") int pageSize);

}
