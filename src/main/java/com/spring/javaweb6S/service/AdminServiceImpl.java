package com.spring.javaweb6S.service;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.TransactionDefinition;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.DefaultTransactionDefinition;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaweb6S.dao.AdminDAO;
import com.spring.javaweb6S.dao.MemberDAO;
import com.spring.javaweb6S.vo.AnnounceVO;
import com.spring.javaweb6S.vo.CategoryVO;
import com.spring.javaweb6S.vo.ChartVO;
import com.spring.javaweb6S.vo.CouponVO;
import com.spring.javaweb6S.vo.InquiryVO;
import com.spring.javaweb6S.vo.OrderVO;
import com.spring.javaweb6S.vo.ProductVO;
import com.spring.javaweb6S.vo.QnaVO;
import com.spring.javaweb6S.vo.SearchVO;

@Controller
public class AdminServiceImpl implements AdminService {

	@Autowired
	AdminDAO adminDAO;

	@Autowired
	MemberDAO memberDAO;

	@Autowired
	DataSourceTransactionManager transactionManager;

	@Override
	public int setMainCategoryInsert(CategoryVO vo) {
		return adminDAO.setMainCategoryInsert(vo);
	}

	@Override
	public CategoryVO getMainCategory(char c_mainCode, String c_mainName) {
		return adminDAO.getMainCategory(c_mainCode, c_mainName);
	}

	@Override
	public ArrayList<CategoryVO> getAllMainCategory() {
		return adminDAO.getAllMainCategory();
	}

	@Override
	public CategoryVO getMiddleCategoryExist(CategoryVO vo) {
		return adminDAO.getMiddleCategoryExist(vo);
	}

	@Override
	public void setMiddleCategoryInsert(CategoryVO vo) {
		adminDAO.setMiddleCategoryInsert(vo);
	}

	@Override
	public ArrayList<CategoryVO> getAllMiddleCategory() {
		return adminDAO.getAllMiddleCategory();
	}

	@Override
	public List<CategoryVO> getMiddleCategoryCode(String c_mainCode) {
		// TODO Auto-generated method stub
		return adminDAO.getMiddleCategoryCode(c_mainCode);
	}

	// 중분류 삭제
	@Override
	public int deleteMiddleCategory(String c_middleCode) {
		return adminDAO.deleteMiddleCategory(c_middleCode);
	}

	// 대분류 삭제
	@Override
	public void deleteMainCategory(String c_mainCode) {
		adminDAO.deleteMainCategory(c_mainCode);
	}

	// 상품 입력
	@Override
	public int saveProductImg(ProductVO vo, List<MultipartFile> fileList) {
		int res = 0;
		// 썸네일+상세 이미지를 먼저 폴더에 저장
		try {
			String serverFileNames = ""; // 서버 저장 파일명
			for (MultipartFile file : fileList) {
				String ext = file.getOriginalFilename();
				ext = ext.substring(ext.indexOf("."), ext.length());
				String serverFileName = "P" + saveFileName() + ext; // 서버에 저장할때 날짜시간초로 저장해 중복을 방지한다
				writeFile(file, serverFileName); // 서버에 저장
				// 여러개의 파일을 다루므로 저장
				if (file.getOriginalFilename().equals(vo.getP_thumbnailIdx()))
					vo.setP_thumbnailIdx(serverFileName);
				serverFileNames += serverFileName + "/";
			}

			vo.setP_image(serverFileNames);
			// 이제 vo.getContent에서 이미지가 있을 경우 해당 이미지를 저장하기 위한 이미지 처리를 진행한다
			ImgCheck(vo.getP_content(), "product/detail/D");

			// 전부 완료 후 content의 폴더를 data/product/detail로 변경
			vo.setP_content(vo.getP_content().replace("/data/ckeditor/", "/data/product/detail/D"));

			res = adminDAO.addProduct(vo);
			System.out.println("DB삽입 완료");
		} catch (IOException e) {
			e.printStackTrace();
		}

		return res;
	}

	// ck에디터 내에 이미지가 있는 경우 실행 - 건드리지말것... 삽입 할때 쓰는 코드임...
	public void ImgCheck(String content, String copyFilePath) {
		if (content.indexOf("src=\"") == -1)
			return;

		// 0 1 2 3 4
		// 01234567890123456789012345678901234567890
		// <img alt="" src="/javaweb6S/data/ckeditor/230628115527_A3.jpg"
		// style="height:300px; width:400px" /></p><p><img alt=""
		// src="/javawebS/data/ckeditor/230616141353_paris.jpg" style="height:300px;
		// width:400px" /></p>
		// 상품설명에 이미지가 존재하는 경우
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes())
				.getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/");

		int position = 30;
		String img = content.substring(content.indexOf("src=\"/") + position);
		boolean sw = true;
		String copyPath = copyFilePath;

		while (sw) {
			// "로 끝나는 위치 찾기 (현재: 230628115527_A3.jpg" ~ ...) 이므로 "전까지만 가져오면 이미지만 가져올 수있음
			String imgFile = img.substring(0, img.indexOf("\""));

			// ckeditor에 저장된 임시 파일을
			String origFilePath = realPath + "ckeditor/" + imgFile;
			// product-detail폴더로 옮겨야 한다
			copyFilePath = realPath + copyPath + imgFile;
//			String copyFilePath = realPath + "product/detail/D" + imgFile;
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
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/product/");

		FileOutputStream fos = new FileOutputStream(realPath + sFileName);
		fos.write(data);
		fos.close();
	}

	@Override
	public List<ProductVO> getAllProduct() {
		return adminDAO.getAllProduct();
	}

	@Override
	public ProductVO getProduct(int p_idx) {
		// TODO Auto-generated method stub
		return adminDAO.getProduct(p_idx);
	}

	@Override
	public int updateProductInt(int p_idx, String updateCol, int updateValInt) {
		// TODO Auto-generated method stub
		return adminDAO.updateProductInt(p_idx, updateCol, updateValInt);
	}

	@Override
	public int updateProduct(int p_idx, String updateCol, String updateVal) {
		return adminDAO.updateProduct(p_idx, updateCol, updateVal);
	}

	// 상세페이지에서 수정할 때 사용
	@Override
	public int updateProductAll(ProductVO vo, List<MultipartFile> fileList) {
		int res = 0;
		try {
			// 수정된 썸네일을 저장한다!!!
			String serverFileNames = ""; // 서버 저장 파일명
			for (MultipartFile file : fileList) {
				String ext = file.getOriginalFilename();
				ext = ext.substring(ext.indexOf("."), ext.length());
				String serverFileName = "P" + saveFileName() + ext; // 서버에 저장할때 날짜시간초로 저장해 중복을 방지한다
				writeFile(file, serverFileName); // 서버에 저장
				// 여러개의 파일을 다루므로 저장
				if (file.getOriginalFilename().equals(vo.getP_thumbnailIdx()))
					vo.setP_thumbnailIdx(serverFileName);
				serverFileNames += serverFileName + "/";
			}
			vo.setP_image(vo.getP_image() + serverFileNames);

			if (vo.getP_content().indexOf("/ckeditor/") != -1)
				ImgCheck(vo.getP_content(), "product/detail/D");

			// 전부 완료 후 content의 폴더를 data/product/detail로 변경
			vo.setP_content(vo.getP_content().replace("/data/ckeditor/", "/data/product/detail/D"));
			res = adminDAO.updateProductAll(vo);

			System.out.println("수정 완료");

		} catch (IOException e) {
			e.printStackTrace();
		}

		return res;
	}

	// 실제로 서버의 파일을 삭제처리한다.
	private void fileDelete(String origFilePath) {
		File delFile = new File(origFilePath);
		if (delFile.exists())
			delFile.delete();
		System.out.println("삭제경로:" + origFilePath);
	}

	// CK에디터에 변경사항이 있다면 삭제하고 다시 올려주자!
	@Override
	public void ContentUpdate(String p_content) {
		if (p_content.indexOf("src=\"") == -1)
			return;

	}

	// 이전에 저장해두었던 데이터들을 모두 삭제 후 CK에디터로 전송한다
	@Override
	public void ContentDelete(String p_content) {
		if (p_content.indexOf("src=\"/") == -1)
			return;

		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes())
				.getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/");

		int position = 35;
		String img = p_content.substring(p_content.indexOf("src=\"/") + position);
		boolean sw = true;

		while (sw) {
			String imgFile = img.substring(0, img.indexOf("\"")); // 그림파일명만 꺼내오기

			String origFilePath = realPath + "product/detail/" + imgFile;
			String copyFilePath = realPath + "ckeditor/" + imgFile;

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

				fileDelete(origFilePath); // 'detail'폴더의 그림을 삭제처리한다.
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

	// 썸네일 삭제
	@Override
	public void ThumbnailDelete(String s) {
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes())
				.getRequest();
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/");

		fileDelete(realPath + "product/" + s);
	}

	// 통계용 - 매출 총액을 구한다
	@Override
	public int getAllTotal() {
		// "주문취소"된 주문은 전부 제외
		int total = adminDAO.getAllTotal();
		int refund = adminDAO.getRefundTotal();
		return total - refund;
	}

	@Override
	public List<OrderVO> getAllOrder() {
		return adminDAO.getAllOrder();
	}

	@Override
	public List<OrderVO> getOrder(String[] pay_method, String[] o_status, String[] o_cStatus, String durationCategory,
			String startDate, String endDate, String searchCategory, String searchKeyword) {
		return adminDAO.getOrder(pay_method, o_status, o_cStatus, durationCategory, startDate, endDate, searchCategory,
				searchKeyword);
	}

	@Override
	public String[] getCategoryLabel() {
		return adminDAO.getCategoryLabel();
	}

	@Override
	public List<ChartVO> getCategoryData() {
		return adminDAO.getCategoryData();
	}

	@Override
	public List<ChartVO> refundCategory() {
		return adminDAO.refundCategory();
	}

	@Override
	public List<OrderVO> monthTotalPrice() {
		return adminDAO.monthTotalPrice();
	}

	@Override
	public int couponInsert(CouponVO vo) {
		return adminDAO.couponInsert(vo);
	}

	@Override
	public ArrayList<CouponVO> getCouponList() {
		return adminDAO.getCouponList();
	}

	@Override
	public int couponUpdate(CouponVO vo) {
		return adminDAO.couponUpdate(vo);
	}

	@Override
	public ArrayList<CouponVO> getCouponPageList(int startIndexNo, int pageSize) {
		return adminDAO.getCouponPageList(startIndexNo, pageSize);
	}

	@Override
	public ArrayList<CouponVO> getCouponAvailableList() {
		return adminDAO.getCouponAvailableList();
	}

	@Override
	public ArrayList<CouponVO> getUserCouponList(int level, int cp_idx) {
		return adminDAO.getUserCouponList(level, cp_idx);
	}

	@Override
	public int[] getUserLevelList(int level) {
		return adminDAO.getUserLevelList(level);
	}

	@Override
	public CouponVO getMemberCouponList(int m_idx, int cp_idx) {
		return adminDAO.getMemberCouponList(m_idx, cp_idx);
	}

	@Override
	public void giveMemberCoupon(int m_idx, int cp_idx) {
		adminDAO.giveMemberCoupon(m_idx, cp_idx);
	}

	@Override
	public List<OrderVO> getAllCS() {
		return adminDAO.getAllCS();
	}

	@Override
	public OrderVO getOrderInfo(int o_idx) {
		return adminDAO.getOrderInfo(o_idx);
	}

	@Override
	public ArrayList<OrderVO> getDeliveryStart() {
		return adminDAO.getDeliveryStart();
	}

	// CS 업데이트
	@Override
	public int updateCustomerStatus(String cs_admin, String cancelSelect, String oi_productCode, int cs_idx,
			int refund_amount) {
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = transactionManager.getTransaction(def);
		int res = 0;
		try {
			// CS상태에 승인/반려사유와 승인/반려 여부를 업데이트하고 난 후
			adminDAO.updateCustomerStatus(cs_admin, cs_idx, cancelSelect, refund_amount);
			// 주문 상태를 변경한다
			if (cancelSelect.equals("반려"))
				adminDAO.updateOrderStatus(oi_productCode, "주문취소");
			res = 1;

			transactionManager.commit(status);
			System.out.println("성공함");
		} catch (Exception e) {
			transactionManager.rollback(status);
			throw e;
		}
		return res;
	}

	@Override
	public void updateOrderStatus(String oi_productCode, String updateStatus) {
		adminDAO.updateOrderStatus(oi_productCode, updateStatus);
	}

	@Override
	public List<OrderVO> allOrderChangeList() {
		// TODO Auto-generated method stub
		return adminDAO.allOrderChangeList();
	}

	@Override
	public ArrayList<OrderVO> getProductOrder(int o_idx) {
		// TODO Auto-generated method stub
		return adminDAO.getProductOrder(o_idx);
	}

	// 배성정보등록
	@Override
	public int deliveryUpdate(String deliveryComList, String deliveryIdxList, String deliveryCodeList) {
		String[] deliveryCom = deliveryComList.split("/");
		String[] o_idx = deliveryIdxList.split("/");
		String[] deliveryCode = deliveryCodeList.split("/");
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = transactionManager.getTransaction(def);
		int res = 0;
		try {
			for (int i = 0; i < o_idx.length; i++) {
				adminDAO.deliveryUpdate(o_idx[i], deliveryCom[i], deliveryCode[i]);
				// 트랜잭션 처리 -> oi_product 배송중 처리해주기
				adminDAO.deliveryStatusUpdate(o_idx[i], "배송중");
			}
			transactionManager.commit(status);
			res = 1;
		} catch (Exception e) {
			transactionManager.rollback(status);
			throw e;
		}
		return res;

	}

	@Override
	public ArrayList<QnaVO> getAllQnA() {
		return adminDAO.getAllQnA();
	}

	@Override
	public int updateQnA(String answer_context, int qna_idx) {
		return adminDAO.updateQnA(answer_context, qna_idx);
	}

	@Override
	public int getQnaNoAnswer() {
		return adminDAO.getQnaNoAnswer();
	}

	@Override
	public int getInqNoAnswer() {
		return adminDAO.getInqNoAnswer();
	}

	@Override
	public ArrayList<QnaVO> getQnAList(int startIndexNo, int pageSize) {
		return adminDAO.getQnAList(startIndexNo, pageSize);
	}

	@Override
	public int getQnASearchRec(String[] openSw, String[] answerOK, SearchVO vo) {
		return adminDAO.getQnASearchRec(openSw, answerOK, vo);
	}

	@Override
	public List<QnaVO> getQnASearch(String[] openSw, String[] answerOK, SearchVO vo, int startIndexNo, int pageSize) {
		return adminDAO.getQnASearch(openSw, answerOK, vo, startIndexNo, pageSize);
	}

	@Override
	public void updateCS(String[] oi_productCodes, String updateStatus) {
		adminDAO.updateCS(oi_productCodes, updateStatus);
	}

	@Override
	public OrderVO getOrderbyProductCode(String oi_productCode) {
		return adminDAO.getOrderbyProductCode(oi_productCode);
	}

	@Override
	public ArrayList<InquiryVO> getInquiryList(int startIndexNo, int pageSize) {
		return adminDAO.getInquiryList(startIndexNo, pageSize);
	}

	@Override
	public int updateInqAnswer(int inq_idx, String inq_answerContext) {
		// 이제 vo.getContent에서 이미지가 있을 경우 해당 이미지를 저장하기 위한 이미지 처리를 진행한다
		ImgCheck(inq_answerContext, "admin/");
		// 전부 완료 후 content의 폴더를 data/product/detail로 변경
		inq_answerContext = inq_answerContext.replace("/data/ckeditor/", "/data/admin/");

		return adminDAO.updateInqAnswer(inq_idx, inq_answerContext);
	}

	@Override
	public int memberLevelUpdate(String memberIdxList, int m_level) {
		String[] m_idx = memberIdxList.split("/");
		DefaultTransactionDefinition def = new DefaultTransactionDefinition();
		def.setPropagationBehavior(TransactionDefinition.PROPAGATION_REQUIRED);
		TransactionStatus status = transactionManager.getTransaction(def);
		int res = 0;
		try {
			for (int i = 0; i < m_idx.length; i++) {
				memberDAO.memberLevelUpdate(Integer.parseInt(m_idx[i]), m_level);
			}
			transactionManager.commit(status);
			res = 1;
		} catch (Exception e) {
			transactionManager.rollback(status);
			throw e;
		}
		return res;
	}

	@Override
	public ArrayList<CouponVO> getCouponUserList(int startIndexNo, int pageSize) {
		return adminDAO.getCouponUserList(startIndexNo, pageSize);
	}

	@Override
	public int setNewAnnounce(AnnounceVO vo) {
		// 넣기 전에 이미지 처리작업해줘야함
		// 이제 vo.getContent에서 이미지가 있을 경우 해당 이미지를 저장하기 위한 이미지 처리를 진행한다
		ImgCheck(vo.getAnn_context(), "admin/");
		// 전부 완료 후 content의 폴더를 data/product/detail로 변경
		vo.setAnn_context(vo.getAnn_context().replace("/data/ckeditor/", "/data/admin/"));

		return adminDAO.setNewAnnounce(vo);
	}

	@Override
	public List<AnnounceVO> getAllAnnounce(int startIndexNo, int pageSize, String searchCategory, String searchKeyword) {
		return adminDAO.getAllAnnounce(startIndexNo, pageSize, searchCategory, searchKeyword);
	}

	@Override
	public AnnounceVO getNotice(int ann_idx) {
		return adminDAO.getNotice(ann_idx);
	}

	@Override
	public ArrayList<InquiryVO> getPrevNextAnn(int ann_idx) {
		return adminDAO.getPrevNextAnn(ann_idx);
	}

	@Override
	public int deleteAnnounce(int ann_idx) {
		return adminDAO.deleteAnnounce(ann_idx);
	}

	@Override
	public List<ChartVO> memberRank() {
		return adminDAO.memberRank();
	}

	@Override
	public List<ChartVO> memberLevelCnt() {
		return adminDAO.memberLevelCnt();
	}

	@Override
	public int getProductOrderCnt(int p_idx) {
		return adminDAO.getProductOrderCnt(p_idx);
	}

	@Override
	public void getProductDelete(int p_idx) {
		adminDAO.getProductDelete(p_idx);
	}

	@Override
	public int getDeliverCnt() {
		return adminDAO.getDeliverCnt();
	}

	@Override
	public int getCSCnt() {
		return adminDAO.getCSCnt();
	}

	@Override
	public int memberDelete(int m_idx) {
		return adminDAO.memberDelete(m_idx);
	}

	@Override
	public int getMiddleCategoryCnt(String c_middleCode) {
		return adminDAO.getMiddleCategoryCnt(c_middleCode);
	}

}
