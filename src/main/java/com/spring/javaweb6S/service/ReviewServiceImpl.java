package com.spring.javaweb6S.service;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Service;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaweb6S.dao.OrderDAO;
import com.spring.javaweb6S.dao.ReviewDAO;
import com.spring.javaweb6S.vo.OrderVO;
import com.spring.javaweb6S.vo.ReviewVO;

@Service
public class ReviewServiceImpl implements ReviewService {
	@Autowired
	ReviewDAO reviewDAO;

	@Autowired
	OrderDAO orderDAO;

	@Autowired
	DataSourceTransactionManager transactionManager;

	@Override
	public int newReviewInsert(ReviewVO vo, List<MultipartFile> fileList) {

		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = transactionManager.getTransaction(def);

		int res = 0;
		// 썸네일+상세 이미지를 먼저 폴더에 저장
		try {
			String serverFileNames = ""; // 서버 저장 파일명
			for (MultipartFile file : fileList) {
				String ext = file.getOriginalFilename(); // 파일명 얻어와서
				ext = ext.substring(ext.indexOf("."), ext.length()); // 확장자 앞의 파일 이름만 가져옴
				String serverFileName = "R" + saveFileName() + ext; // 서버에 저장할때 날짜시간초로 저장해 중복 방지
				writeFile(file, serverFileName); // 서버에 저장
				serverFileNames += serverFileName + "/";
			}
			String content = vo.getReview_content();
			vo.setReview_content(content.replace("\n", "<br/>"));

			String oi_productCode = vo.getOi_productCode();
			vo.setOi_productCode(oi_productCode.substring(1, oi_productCode.length() - 1));

			vo.setReview_photo(serverFileNames);

			res = reviewDAO.newReviewInsert(vo);

			int point = 50;
			if (fileList != null) {
				orderDAO.updateMemberPoint(150, vo.getM_mid());
				point = 150;
			} else {
				orderDAO.updateMemberPoint(50, vo.getM_mid());
			}

			orderDAO.pointHistory(vo.getM_mid(), point, vo.getOi_productCode());
			transactionManager.commit(status);
			System.out.println("리뷰 - DB삽입 완료");

		} catch (IOException e) {
			// transactionManager.rollback(status);
			e.printStackTrace();
		}

		return res;

	}

	private String saveFileName() {
		String fileName = "";
		Calendar cal = Calendar.getInstance();
		fileName += cal.get(Calendar.YEAR);
		fileName += cal.get(Calendar.MONTH);
		fileName += cal.get(Calendar.DATE);
		fileName += cal.get(Calendar.HOUR);
		fileName += cal.get(Calendar.MINUTE);
		fileName += cal.get(Calendar.SECOND);
		fileName += cal.get(Calendar.MILLISECOND);

		return fileName;
	}

	// 서버에 실제로 저장하는 메소드
	private void writeFile(MultipartFile file, String sFileName) throws IOException {
		byte[] data = file.getBytes();

		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes())
				.getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/review/");

		FileOutputStream fos = new FileOutputStream(realPath + sFileName);
		fos.write(data);
		fos.close();
	}

	@Override
	public ArrayList<ReviewVO> getProductReview(int p_idx) {
		return reviewDAO.getProductReview(p_idx);
	}

	@Override
	public double getProductRating(int p_idx) {
		// TODO Auto-generated method stub
		return reviewDAO.getProductRating(p_idx);
	}

	@Override
	public int newCSInsert(OrderVO vo, List<MultipartFile> fileList) {
		int res = 0;

		try {
			String serverFileNames = ""; // 서버 저장 파일명
			for (MultipartFile file : fileList) {
				String ext = file.getOriginalFilename(); // 파일명 얻어와서
				ext = ext.substring(ext.indexOf("."), ext.length()); // 확장자 앞의 파일 이름만 가져옴
				String serverFileName = "CS" + saveFileName() + ext; // 서버에 저장할때 날짜시간초로 저장해 중복 방지
				writeFile(file, serverFileName); // 서버에 저장
				serverFileNames += serverFileName + "/";
			}
			String content = vo.getCs_context();
			vo.setCs_context(content.replace("\n", "<br/>"));

			vo.setCs_img(serverFileNames);

			System.out.println("CS - DB삽입 완료");

			vo.setOi_productCode(vo.getOi_productCode().replace("'", ""));
			res = reviewDAO.newCSInsert(vo);

		} catch (IOException e) {
			e.printStackTrace();
		}

		return res;
	}

	@Override
	public int getOrderReview(String oi_productCode) {
		return reviewDAO.getOrderReview(oi_productCode);
	}

	@Override
	public int setReviewThumb(int review_idx) {
		return reviewDAO.setReviewThumb(review_idx);
	}

	@Override
	public int ReviewUpdate(ReviewVO vo, List<MultipartFile> fileList) {
		int res = 0;
		try {
			// 수정한 이미지 저장
			String serverFileNames = ""; // 서버 저장 파일명
			for (MultipartFile file : fileList) {
				String ext = file.getOriginalFilename();
				ext = ext.substring(ext.indexOf("."), ext.length());
				String serverFileName = "R" + saveFileName() + ext; // 서버에 저장할때 날짜시간초로 저장해 중복을 방지한다
				writeFile(file, serverFileName); // 서버에 저장
				serverFileNames += serverFileName + "/";
				System.out.println(serverFileNames);
			}
			String content = vo.getReview_content();
			vo.setReview_content(content.replace("\n", "<br/>"));

			vo.setReview_photo(vo.getReview_photo() + serverFileNames);
			System.out.println(vo.getReview_photo());

			// 전부 완료 후 content의 폴더를 data/product/detail로 변경
			res = reviewDAO.updateReview(vo);
			System.out.println("수정 완료");

		} catch (IOException e) {
			e.printStackTrace();
		}

		return res;
	}

	@Override
	public ArrayList<ReviewVO> getProductReviewList(int p_idx, int startIndexNo, int pageSizeReview) {
		// TODO Auto-generated method stub
		return reviewDAO.getProductReviewList(p_idx, startIndexNo, pageSizeReview);
	}

}
