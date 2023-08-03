package com.spring.javaweb6S.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaweb6S.dao.MemberDAO;
import com.spring.javaweb6S.vo.CouponVO;
import com.spring.javaweb6S.vo.InquiryVO;
import com.spring.javaweb6S.vo.MemberVO;
import com.spring.javaweb6S.vo.OrderVO;
import com.spring.javaweb6S.vo.ProductVO;
import com.spring.javaweb6S.vo.QnaVO;
import com.spring.javaweb6S.vo.ReviewVO;
import com.spring.javaweb6S.vo.SearchVO;

@Service
public class MemberServiceImpl implements MemberService {
	@Autowired
	MemberDAO memberDAO;

	@Override
	public MemberVO getMemberMidCheck(String mid) {
		return memberDAO.getMemberMidCheck(mid);
	}

	@Override
	public int setMemberJoin(MemberVO vo) {
		return memberDAO.setMemberJoin(vo);
	}

	@Override
	public List<OrderVO> getAllOrder(String sMid, String startDate, String endDate, int startIndexNo, int pageSize) {
		return memberDAO.getAllOrder(sMid, startDate, endDate, startIndexNo, pageSize);
	}

	@Override
	public ArrayList<MemberVO> getAllMember() {
		return memberDAO.getAllMember();
	}

	@Override
	public ArrayList<CouponVO> getUserCoupon(int idx) {
		return memberDAO.getUserCoupon(idx);
	}

	@Override
	public ArrayList<ReviewVO> getUserReview(String sMid) {
		// TODO Auto-generated method stub
		return memberDAO.getUserReview(sMid);
	}

	@Override
	public int setMemberDelete(String sMid) {
		return memberDAO.setMemberDelete(sMid);
	}

	@Override
	public void setMemberUpdate(MemberVO vo) {
		memberDAO.setMemberUpdate(vo);
	}

	@Override
	public int getMemberLevel(int sLevel, String sMid) {
		return memberDAO.getMemberLevel(sLevel, sMid);
	}

	@Override
	public ArrayList<MemberVO> getMemberPageList(int startIndexNo, int pageSize) {
		// TODO Auto-generated method stub
		return memberDAO.getMemberPageList(startIndexNo, pageSize);
	}

	@Override
	public MemberVO getMemberIdFind(String name, String email) {
		return memberDAO.getMemberIdFind(name, email);
	}

	@Override
	public void setMemberPwdUpdate(String m_mid, String pwd) {
		memberDAO.setMemberPwdUpdate(m_mid, pwd);
	}

	@Override
	public int deleteQnA(int qna_idx) {
		return memberDAO.deleteQnA(qna_idx);
	}

	@Override
	public int getQnASearchRec(String[] openSw, String[] answerOK, SearchVO vo, String mid) {
		return memberDAO.getQnASearchRec(openSw, answerOK, vo, mid);
	}

	@Override
	public ArrayList<QnaVO> getMemberQnAList(int startIndexNo, int pageSize, String mid) {
		return memberDAO.getMemberQnAList(startIndexNo, pageSize, mid);
	}

	@Override
	public ArrayList<QnaVO> getQnASearch(String[] openSw, String[] answerOK, String mid, SearchVO vo, int startIndexNo,
			int pageSize) {
		return memberDAO.getQnASearch(openSw, answerOK, mid, vo, startIndexNo, pageSize);
	}

	@Override
	public int deleteReview(int review_idx) {
		return memberDAO.deleteReview(review_idx);
	}

	@Override
	public ReviewVO getUserReviewOne(int review_idx) {
		return memberDAO.getUserReviewOne(review_idx);
	}

	@Override
	public int setMemberInquiry(InquiryVO vo) {
		// 넣기 전에 이미지 처리작업해줘야함

		// 이제 vo.getContent에서 이미지가 있을 경우 해당 이미지를 저장하기 위한 이미지 처리를 진행한다
		ImgCheck(vo.getInq_context());

		// 전부 완료 후 content의 폴더를 data/product/detail로 변경
		vo.setInq_context(vo.getInq_context().replace("/data/ckeditor/", "/data/review/inq"));

		return memberDAO.setMemberInquiry(vo);
	}

	@Override
	public ArrayList<QnaVO> getMemberInquiryList(int startIndexNo, int pageSize, String mid) {
		return memberDAO.getMemberInquiryList(startIndexNo, pageSize, mid);
	}

	@Override
	public InquiryVO getMemberInquiry(int inq_idx) {
		return memberDAO.getMemberInquiry(inq_idx);
	}

	@Override
	public ArrayList<InquiryVO> getPrevNextInq(int inq_idx, String mid) {
		return memberDAO.getPrevNextInq(inq_idx, mid);
	}

	// ck에디터 내에 이미지가 있는 경우 실행 - 건드리지말것... 삽입 할때 쓰는 코드임...
	public void ImgCheck(String content) {
		if (content.indexOf("src=\"") == -1)
			return;
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes())
				.getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/");

		int position = 30;
		String img = content.substring(content.indexOf("src=\"/") + position);
		boolean sw = true;

		while (sw) {
			// "로 끝나는 위치 찾기 (현재: 230628115527_A3.jpg" ~ ...) 이므로 "전까지만 가져오면 이미지만 가져올 수있음
			String imgFile = img.substring(0, img.indexOf("\""));
			// ckeditor에 저장된 임시 파일을
			String origFilePath = realPath + "ckeditor/" + imgFile;
			// product-detail폴더로 옮겨야 한다
			String copyFilePath = realPath + "review/inq" + imgFile;
			try {
				FileInputStream fis = new FileInputStream(new File(origFilePath));
				FileOutputStream fos = new FileOutputStream(new File(copyFilePath));

				byte[] bytes = new byte[2048];
				int cnt = 0;
				while ((cnt = fis.read(bytes)) != -1) {
					fos.write(bytes, 0, cnt);
				}

				fos.flush();
				fos.close();
				fis.close();

				// 옮긴 후 ck 에디터의 폴더를 비운다
				fileDelete(realPath + "ckeditor/" + imgFile);

				// 다음 이미지가 존재하지 않을 경우 while문 탈출
				if (img.indexOf("src=\"/") == -1) {
					sw = false;
				} else {
					img = img.substring(img.indexOf("src=\"/") + position);
				}
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

	}

	// 실제로 서버의 파일을 삭제처리한다.
	private void fileDelete(String origFilePath) {
		File delFile = new File(origFilePath);
		if (delFile.exists())
			delFile.delete();
		System.out.println("삭제경로:" + origFilePath);
	}

	@Override
	public ArrayList<MemberVO> getMemberLevelPageList(int startIndexNo, int pageSize, int level) {
		return memberDAO.getMemberLevelPageList(startIndexNo, pageSize, level);
	}

	@Override
	public void updateLastDate(String m_mid) {
		memberDAO.updateLastDate(m_mid);
	}

	@Override
	public List<OrderVO> getAllPoint(String sMid, String startDate, String endDate, int startIndexNo, int pageSize) {
		return memberDAO.getAllPoint(sMid, startDate, endDate, startIndexNo, pageSize);
	}

	@Override
	public int[] getWishList(int p_idx, String sMid) {
		return memberDAO.getWishList(sMid, p_idx);
	}

	@Override
	public void removeWishList(int p_idx, String sMid) {
		memberDAO.removeWishList(p_idx, sMid);
	}

	@Override
	public void addWishList(int p_idx, String sMid) {
		memberDAO.addWishList(p_idx, sMid);
	}

	@Override
	public int getMemberCoupon(int m_idx) {
		return memberDAO.getMemberCoupon(m_idx);
	}

	@Override
	public int getMemberOrder(String m_mid) {
		return memberDAO.getMemberOrder(m_mid);
	}

	@Override
	public List<ProductVO> getAllWishList(String sMid, int startIndexNo, int pageSize) {
		return memberDAO.getAllWishList(sMid, startIndexNo, pageSize);
	}

}
