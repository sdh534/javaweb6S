package com.spring.javaweb6S.service;

import java.util.ArrayList;
import java.util.List;

import com.spring.javaweb6S.vo.CouponVO;
import com.spring.javaweb6S.vo.InquiryVO;
import com.spring.javaweb6S.vo.MemberVO;
import com.spring.javaweb6S.vo.OrderVO;
import com.spring.javaweb6S.vo.ProductVO;
import com.spring.javaweb6S.vo.QnaVO;
import com.spring.javaweb6S.vo.ReviewVO;
import com.spring.javaweb6S.vo.SearchVO;

public interface MemberService {

	public MemberVO getMemberMidCheck(String mid);

	public int setMemberJoin(MemberVO vo);

	public List<OrderVO> getAllOrder(String sMid, String startDate, String endDate, int startIndexNo, int pageSize);

	public ArrayList<MemberVO> getAllMember();

	public ArrayList<CouponVO> getUserCoupon(int idx);

	public ArrayList<ReviewVO> getUserReview(String sMid);

	public int setMemberDelete(String sMid);

	public void setMemberUpdate(MemberVO vo);

	public int getMemberLevel(int sLevel, String sMid);

	public ArrayList<MemberVO> getMemberPageList(int startIndexNo, int pageSize);

	public MemberVO getMemberIdFind(String name, String email);

	public void setMemberPwdUpdate(String m_mid, String pwd);

	public int deleteQnA(int qna_idx);

	public int getQnASearchRec(String[] openSw, String[] answerOK, SearchVO vo, String mid);

	public ArrayList<QnaVO> getQnASearch(String[] openSw, String[] answerOK, String mid, SearchVO vo, int startIndexNo, int pageSize);

	public ArrayList<QnaVO> getMemberQnAList(int startIndexNo, int pageSize, String mid);

	public int deleteReview(int review_idx);

	public ReviewVO getUserReviewOne(int review_idx);

	public int setMemberInquiry(InquiryVO vo);

	public ArrayList<QnaVO> getMemberInquiryList(int startIndexNo, int pageSize, String mid);

	public InquiryVO getMemberInquiry(int inq_idx);

	public ArrayList<InquiryVO> getPrevNextInq(int inq_idx, String mid);

	public ArrayList<MemberVO> getMemberLevelPageList(int startIndexNo, int pageSize, int level);

	public void updateLastDate(String m_mid);

	public List<OrderVO> getAllPoint(String sMid, String startDate, String endDate, int startIndexNo, int pageSize);

	public int[] getWishList(int p_idx, String sMid);

	public void removeWishList(int p_idx, String sMid);

	public void addWishList(int p_idx, String sMid);

	public int getMemberCoupon(int m_idx);

	public int getMemberOrder(String m_mid);

	public List<ProductVO> getAllWishList(String sMid, int startIndexNo, int pageSize);



}
