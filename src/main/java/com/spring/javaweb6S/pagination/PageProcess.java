package com.spring.javaweb6S.pagination;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.spring.javaweb6S.dao.AdminDAO;
import com.spring.javaweb6S.dao.MemberDAO;
import com.spring.javaweb6S.dao.ProductDAO;
import com.spring.javaweb6S.vo.PageVO;

@Service
public class PageProcess {

	@Autowired
	MemberDAO memberDAO;

	@Autowired
	ProductDAO productDAO;

	@Autowired
	AdminDAO adminDAO;

	public PageVO totRecCnt(int pag, int pageSize, String category, String part, String searchString) {
		PageVO pageVO = new PageVO();

		int totRecCnt = 0;
		String search = "";
		if (category.equals("member")) {
			totRecCnt = memberDAO.totRecCnt();
			if (part.equals("QnA")) {
				totRecCnt = memberDAO.totQnARecCnt(searchString);
			} else if (part.equals("QnASearch")) {
				totRecCnt = Integer.parseInt(searchString);
			} else if (part.equals("Inquiry")) {
				totRecCnt = memberDAO.totInqRecCnt(searchString);
			} else if (part.equals("order")) {
				String[] date = {};
				if (!searchString.equals("//"))
					date = searchString.split("/");
				totRecCnt = memberDAO.totOrderDate(date[0], date[1], date[2]); // 2는 sMid
			} else if (part.equals("point")) {
				String[] date = {};
				if (!searchString.equals("//"))
					date = searchString.split("/");
				totRecCnt = memberDAO.totPointDate(date[0], date[1], date[2]); // 2는 sMid
			} else if (part.equals("wishlist")) {
				totRecCnt = memberDAO.totwishRecCnt(searchString); // mid
			} else if (part.equals("m_level")) {
				if (!searchString.equals("")) {
					int m_level = Integer.parseInt(searchString);
					totRecCnt = memberDAO.totLevCnt(m_level);
				} else
					totRecCnt = memberDAO.totRecCnt();
			}
		} else if (category.equals("admin")) {
			// 쿠폰 페이징 처리시 사용
			if (part.equals("coupon")) {
				totRecCnt = adminDAO.totRecCntCoupon();
				if (searchString.equals("user"))
					totRecCnt = adminDAO.totRecCntCouponUser();
			} else if (part.equals("QnA")) {
				if (!searchString.equals(""))
					totRecCnt = Integer.parseInt(searchString);
				else
					totRecCnt = adminDAO.totRecCntQnA();
			} else if (part.equals("Inquiry")) {
				if (!searchString.equals(""))
					totRecCnt = Integer.parseInt(searchString);
				else
					totRecCnt = adminDAO.totRecCntInquiry();
			}
		} else if (category.equals("product")) {
			if (part.equals("search"))
				totRecCnt = productDAO.totSearchCnt(searchString);
			else
				totRecCnt = productDAO.totRecCnt(part, searchString);
		} else if (category.equals("qna")) { // 상품 정보 - qna
			int p_idx = Integer.parseInt(searchString);
			totRecCnt = productDAO.totRecQnACnt(p_idx);
		} else if (category.equals("qnaSort")) { // 상품 정보 - qna
			String[] str = searchString.split("/");
			int p_idx = Integer.parseInt(str[0]);
			totRecCnt = productDAO.totRecQnASortCnt(p_idx, str[1]);
		} else if (category.equals("review")) { // 상품 정보 - qna
			int p_idx = Integer.parseInt(searchString);
			totRecCnt = productDAO.totRecReviewCnt(p_idx);
		} else if (category.equals("announce")) { // 상품 정보 - qna
			totRecCnt = adminDAO.totRecAnnCnt(part, searchString);
		}

		int totPage = (totRecCnt % pageSize) == 0 ? totRecCnt / pageSize : (totRecCnt / pageSize) + 1;
		int startIndexNo = (pag - 1) * pageSize;
		int curScrStartNo = totRecCnt - startIndexNo;

		int blockSize = 5;
		int curBlock = (pag - 1) / blockSize;
		int lastBlock = (totPage - 1) / blockSize;

		pageVO.setPag(pag);
		pageVO.setPageSize(pageSize);
		pageVO.setTotRecCnt(totRecCnt);
		pageVO.setTotPage(totPage);
		pageVO.setStartIndexNo(startIndexNo);
		pageVO.setCurScrStartNo(curScrStartNo);
		pageVO.setCurBlock(curBlock);
		pageVO.setBlockSize(blockSize);
		pageVO.setLastBlock(lastBlock);
		pageVO.setPart(part);
		pageVO.setSearch(search);
		pageVO.setSearchString(searchString);

		return pageVO;
	}

}
