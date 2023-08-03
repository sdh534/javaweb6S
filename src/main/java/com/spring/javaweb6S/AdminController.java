package com.spring.javaweb6S;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.siot.IamportRestClient.IamportClient;
import com.siot.IamportRestClient.exception.IamportResponseException;
import com.siot.IamportRestClient.request.CancelData;
import com.spring.javaweb6S.pagination.PageProcess;
import com.spring.javaweb6S.service.AdminService;
import com.spring.javaweb6S.service.MemberService;
import com.spring.javaweb6S.service.OrderService;
import com.spring.javaweb6S.vo.AnnounceVO;
import com.spring.javaweb6S.vo.CategoryVO;
import com.spring.javaweb6S.vo.ChartVO;
import com.spring.javaweb6S.vo.CouponVO;
import com.spring.javaweb6S.vo.InquiryVO;
import com.spring.javaweb6S.vo.MemberVO;
import com.spring.javaweb6S.vo.OrderVO;
import com.spring.javaweb6S.vo.PageVO;
import com.spring.javaweb6S.vo.ProductVO;
import com.spring.javaweb6S.vo.QnaVO;
import com.spring.javaweb6S.vo.SearchVO;

@Controller
@RequestMapping(value = "/admin")
public class AdminController {

	@Autowired
	AdminService adminService;

	@Autowired
	MemberService memberService;

	@Autowired
	OrderService orderService;

	@Autowired
	PageProcess pageProcess;

	@RequestMapping(value = "/adminMain", method = RequestMethod.GET)
	public String adminMainGet(HttpSession session, Model model) {
		session.setAttribute("sNowAdminPage", "main");
		int sAllTotal = adminService.getAllTotal();
		session.setAttribute("sAllTotal", sAllTotal);

		int qnaTotal = adminService.getQnaNoAnswer();
		model.addAttribute("qnaTotal", qnaTotal);

		int inqTotal = adminService.getInqNoAnswer();
		model.addAttribute("inqTotal", inqTotal);

		int deliveryTotal = adminService.getDeliverCnt();
		model.addAttribute("deliveryTotal", deliveryTotal);

		int csTotal = adminService.getCSCnt();
		model.addAttribute("csTotal", csTotal);
		return "/admin/adminMain";
	}

	@RequestMapping(value = "/statistics", method = RequestMethod.GET)
	public String adminStatisticsGet(HttpSession session, Model model) {
		session.setAttribute("sNowAdminPage", "statics");
		int sAllTotal = adminService.getAllTotal();
		session.setAttribute("sAllTotal", sAllTotal);

		int qnaTotal = adminService.getQnaNoAnswer();
		model.addAttribute("qnaTotal", qnaTotal);

		int inqTotal = adminService.getInqNoAnswer();
		model.addAttribute("inqTotal", inqTotal);
		return "/admin/statistics/statistics";
	}

	@ResponseBody
	@RequestMapping(value = "/getCategoryData", method = RequestMethod.POST)
	public List<ChartVO> getCategoryData() {

		List<ChartVO> vos = adminService.getCategoryData();
		return vos;
	}

	@ResponseBody
	@RequestMapping(value = "/refundCategory", method = RequestMethod.POST)
	public List<ChartVO> refundCategory() {
		List<ChartVO> vos = adminService.refundCategory();
		return vos;
	}

	@ResponseBody
	@RequestMapping(value = "/memberRank", method = RequestMethod.POST)
	public List<ChartVO> memberRank() {
		List<ChartVO> vos = adminService.memberRank();
		return vos;
	}

	@ResponseBody
	@RequestMapping(value = "/member/memberDelete", method = RequestMethod.POST)
	public String memberDelete(int m_idx) {
		int res = adminService.memberDelete(m_idx);
		return res + "";
	}

	@ResponseBody
	@RequestMapping(value = "/memberLevelCnt", method = RequestMethod.POST)
	public List<ChartVO> memberLevelCnt() {
		List<ChartVO> vos = adminService.memberLevelCnt();
		return vos;
	}

	// 상품 등록 페이지
	@RequestMapping(value = "/product/productInsert", method = RequestMethod.GET)
	public String adminProductInsertGet(HttpSession session, Model model) {
		session.setAttribute("sNowAdminPage", "product");
		ArrayList<CategoryVO> mainCategory = adminService.getAllMainCategory();
		ArrayList<CategoryVO> middleCategory = adminService.getAllMiddleCategory();

		model.addAttribute("mainCategoryVos", mainCategory);
		model.addAttribute("middleCategoryVos", middleCategory);
		return "/admin/product/productInsert";
	}

	// 카테고리 삽입 페이지
	@RequestMapping(value = "/product/productCategory", method = RequestMethod.GET)
	public String adminProductCategoryGet(HttpSession session, Model model) {
		session.setAttribute("sNowAdminPage", "product");

		ArrayList<CategoryVO> mainCategory = adminService.getAllMainCategory();
		ArrayList<CategoryVO> middleCategory = adminService.getAllMiddleCategory();
		model.addAttribute("mainCategoryVos", mainCategory);
		model.addAttribute("middleCategoryVos", middleCategory);

		return "/admin/product/productCategory";
	}

	@ResponseBody
	@RequestMapping(value = "/product/categoryMainInsert", method = RequestMethod.POST)
	public String productCategoryMainInsert(CategoryVO vo) {
		// 기존 대분류가 있는지 체크
		CategoryVO categoryVO = adminService.getMainCategory(vo.getC_mainCode(), vo.getC_mainName());
		if (categoryVO != null)
			return "0";
		adminService.setMainCategoryInsert(vo);

		return "1";
	}

	@ResponseBody
	@RequestMapping(value = "/product/categoryMiddleInsert", method = RequestMethod.POST)
	public String productCategoryMiddleInsert(CategoryVO vo) {
		// 기존 중분류가 있는지 체크
		CategoryVO categoryVO = adminService.getMiddleCategoryExist(vo);
		if (categoryVO != null)
			return "0";
		adminService.setMiddleCategoryInsert(vo);
		return "1";
	}

	@ResponseBody
	@RequestMapping(value = "/product/middleDelete", method = RequestMethod.POST)
	public String middleDelete(String c_middleCode) {
		System.out.println(c_middleCode);
		int res = 0;
		if (c_middleCode.length() == 1)
			c_middleCode = "0" + c_middleCode;
		int cnt = adminService.getMiddleCategoryCnt(c_middleCode);
		if (cnt != 0)
			return res + "";
		res = adminService.deleteMiddleCategory(c_middleCode);
		return res + "";
	}

	// 대분류 삭제
	@ResponseBody
	@RequestMapping(value = "/product/mainDelete", method = RequestMethod.POST)
	public String mainDelete(String c_mainCode) {
		System.out.println(c_mainCode);
		adminService.deleteMainCategory(c_mainCode);
		return "1";
	}

	// 중분류 불러오기
	@ResponseBody
	@RequestMapping(value = "/product/categoryMiddleGet", method = RequestMethod.POST)
	public List<CategoryVO> categoryMiddleGet(String c_mainCode) {
		return adminService.getMiddleCategoryCode(c_mainCode);
	}

	// 상품 입력
	@ResponseBody
	@RequestMapping(value = "/prodct/addProduct", method = RequestMethod.POST, consumes = {
			MediaType.APPLICATION_JSON_VALUE, MediaType.MULTIPART_FORM_DATA_VALUE })
	public String addProduct(@RequestPart(name = "files") List<MultipartFile> fileList,
			@RequestPart(name = "vo") ProductVO vo) {
		System.out.println("파일: " + fileList);
		System.out.println("vo: " + vo);
		System.out.println(vo.getP_thumbnailIdx());
		int res = adminService.saveProductImg(vo, fileList);
		return res + "";
	}

	// 상품 목록 리스트
	@RequestMapping(value = "/product/productList", method = RequestMethod.GET)
	public String productListGet(HttpSession session) {
		session.setAttribute("sNowAdminPage", "product");
		session.setAttribute("aProductNowPage", 1);
		return "/admin/product/productList";
	}

	// 상품 목록 리스트
	@ResponseBody
	@RequestMapping(value = "/product/allProductList", method = RequestMethod.GET)
	public List<ProductVO> allProductListGet(HttpSession session) {
		List<ProductVO> vos = adminService.getAllProduct();
		for (ProductVO vo : vos) {
			String image = vo.getP_image();
			if (image.trim() != null && image.trim() != "") {
				image = image.substring(0, image.indexOf("/"));
			}
			vo.setP_image(image);
			vo.setProductModify("수정");
			vo.setProductDelete("삭제");
		}
		return vos;
	}

//상품 수정
	@RequestMapping(value = "/product/productUpdate", method = RequestMethod.GET)
	public String productUpdateGet(int p_idx, Model model) {
		ProductVO vo = adminService.getProduct(p_idx);

		ArrayList<CategoryVO> mainCategory = adminService.getAllMainCategory();
		model.addAttribute("mainCategoryVos", mainCategory);

		model.addAttribute("vo", vo);
		return "/admin/product/productUpdate";
	}

//상품 삭제
	@ResponseBody
	@RequestMapping(value = "/product/productDelete", method = RequestMethod.POST)
	public String productDeleteGet(int p_idx) {
		int res = 0;
		int cnt = adminService.getProductOrderCnt(p_idx);
		if (cnt == 0) {
			adminService.getProductDelete(p_idx);
			res = 1;
		}
		return res + "";
	}

//상품 수정반영 - 조회페이지에서 즉시 수정 
	@ResponseBody
	@RequestMapping(value = "/product/productUpdate", method = RequestMethod.POST)
	public String productUpdatePost(int p_idx, String updateCol, String updateVal) {
		// p_sellStatus, p_amount, p_price는 정수로 변환
		int updateValInt = 0;
		int res = 0;
		if (updateCol.equals("p_sellStatus") || updateCol.equals("p_amount") || updateCol.equals("p_price")) {
			updateValInt = Integer.parseInt(updateVal);
			res = adminService.updateProductInt(p_idx, updateCol, updateValInt);
		} else {
			res = adminService.updateProduct(p_idx, updateCol, updateVal);
		}

		return res + "";
	}

//상품 수정반영 - 상세 페이지에서 전체 수정
	@ResponseBody
	@RequestMapping(value = "/product/productUpdateAll", method = RequestMethod.POST)
	public String productUpdateAllPost(@RequestPart(name = "files", required = false) List<MultipartFile> fileList,
			@RequestPart(name = "vo") ProductVO vo) {
		// 이전기록 불러오기
		ProductVO tempVO = adminService.getProduct(vo.getP_idx());
		System.out.println(vo.getP_image());
		for (String imageFile : tempVO.getP_image().split("/")) {
			// 이전의 이미지 목록과 현재 등록된 이미지 파일을 비교, 이전에 등록된 이미지 파일이 존재하지 않을 경우 삭제하고 다시 올려주자!!
			if (vo.getP_image().indexOf(imageFile) == -1)
				adminService.ThumbnailDelete(imageFile); // 단일 파일 삭제
		}
		// ck에디터 부분도 변경사항이 있다면 업데이트 -> 존재하는 파일 다 삭제하고 다시 올림
		if (!vo.getP_content().equals(tempVO.getP_content())) { // 변경사항이 존재하고
			if (tempVO.getP_content().indexOf("src=\"") != -1) { // 기존에 업로드한 이미지 파일이 존재한다면
				adminService.ContentDelete(tempVO.getP_content()); // 이전의 데이터 모두 삭제하고 ckEditor로 복사한다 (detail 폴더)
			}
			// 전부 ck에디터로 옮겼으므로 경로 바꿔주고
			vo.setP_content(vo.getP_content().replace("/product/detail/", "/ckeditor/"));
			adminService.ContentUpdate(vo.getP_content()); // 다시 업데이트 과정 ㄱㄱ
		}
		System.out.println("ck에디터의 변경사항이 없으면 " + vo.getP_content());
		int res = adminService.updateProductAll(vo, fileList);
//		 
		return res + "";
	}

	// 주문목록 리스트
	@RequestMapping(value = "/order/orderList", method = RequestMethod.GET)
	public String orderList(HttpSession session, Model model) {
		session.setAttribute("sNowAdminPage", "order");
		return "/admin/order/orderList";
	}

	// 주문변경 리스트
	@RequestMapping(value = "/order/orderChange", method = RequestMethod.GET)
	public String orderChange(HttpSession session, Model model) {
		session.setAttribute("sNowAdminPage", "order");
		return "/admin/order/orderChange";
	}

	// 모든 주문을 불러온다
	@ResponseBody
	@RequestMapping(value = "/order/allOrderList", method = RequestMethod.POST)
	public List<OrderVO> allOrderList() {
		List<OrderVO> vos = adminService.getAllOrder();
		for (OrderVO vo : vos) {
			int totalPrice = vo.getP_price() * vo.getOd_amount();
			vo.setTotalPrice(totalPrice);
			vo.setO_date(vo.getO_date().substring(0, 16));
			if (vo.getO_cStatus() != "")
				vo.setOrderModify("상세");
		}

		return vos;
	}

	// 변경가능한 주문가져오기(취소/교환/반품 요청이 없음)
	@ResponseBody
	@RequestMapping(value = "/order/allOrderChangeList", method = RequestMethod.POST)
	public List<OrderVO> allOrderChangeList() {
		List<OrderVO> vos = adminService.allOrderChangeList();
		for (OrderVO vo : vos) {
			int totalPrice = vo.getP_price() * vo.getOd_amount();
			vo.setTotalPrice(totalPrice);
			vo.setO_date(vo.getO_date().substring(0, 16));
			if (vo.getO_cStatus() != "")
				vo.setOrderModify("상세");
		}

		return vos;
	}

	// 주문목록 리스트
	@RequestMapping(value = "/order/orderInfo", method = RequestMethod.GET)
	public String orderInfo(int o_idx, Model model) {
		OrderVO vo = adminService.getOrderInfo(o_idx);
		ArrayList<OrderVO> productVOS = adminService.getProductOrder(o_idx);
		int salePrice = 0;
		int refundPrice = 0;
		int totalPrice = vo.getP_price();
		int drivePrice = 0;
		// 쿠폰 사용정보를 가져와야함
		for (OrderVO order : productVOS) {
			salePrice = orderService.getCouponUse(o_idx, order.getP_price());
			refundPrice += order.getP_price();
		}

		// 단순변심 배송비책정
		if (vo.getCs_category() != null && vo.getCs_category().equals("단순변심")) {
			// 총 결제금액이 5만원 이하인 경우!
			if (totalPrice < 50000)
				drivePrice = 3000; // 소비자측에서 이미 배송비를 지불했으므로 반품 배송비만 차감
			else {
				// 결제금액이 5만원 이상인 경우!
				if (totalPrice - refundPrice > 50000) {
					// 결제금액 - 환불금액이 5만원 이상인 경우 배송비 무료였으므로 반품 배송비만 차감
					drivePrice = 3000;
				} else
					drivePrice = 6000; // 이 외의 경우 판매자 측에서 지불한 배송비를 포함해 왕복 배송비 차감한다
			}
		}

		System.out.println(refundPrice);
		model.addAttribute("vo", vo);
		model.addAttribute("salePrice", salePrice);
		model.addAttribute("refundPrice", refundPrice);
		model.addAttribute("drivePrice", drivePrice);
		model.addAttribute("productVOS", productVOS);
		return "/admin/order/orderForm";
	}

	// 취소/환불/교환 리스트
	@RequestMapping(value = "/order/cancelList", method = RequestMethod.GET)
	public String cancelList(HttpSession session, Model model) {
		session.setAttribute("sNowAdminPage", "order");
		return "/admin/order/cancelList";
	}

	// 배송 리스트
	@RequestMapping(value = "/order/deliveryList", method = RequestMethod.GET)
	public String deliveryList(HttpSession session, Model model) {
		session.setAttribute("sNowAdminPage", "order");

		ArrayList<OrderVO> vos = adminService.getDeliveryStart();
		model.addAttribute("vos", vos);
		return "/admin/order/deliveryList";
	}

	@ResponseBody
	@RequestMapping(value = "/order/allCancelList", method = RequestMethod.POST)
	public List<OrderVO> allCancelList() {
		List<OrderVO> vos = adminService.getAllCS();
		for (OrderVO vo : vos) {
			int totalPrice = vo.getP_price() * vo.getOd_amount();
			vo.setTotalPrice(totalPrice);
			vo.setCs_date(vo.getCs_date().substring(0, 16));
			vo.setOrderModify("상세");
		}

		return vos;
	}

	@ResponseBody
	@RequestMapping(value = "/order/monthTotalPrice", method = RequestMethod.POST)
	public List<OrderVO> monthTotalPrice() {
		List<OrderVO> vos = adminService.monthTotalPrice();

		return vos;
	}

	@ResponseBody
	@RequestMapping(value = "/order/orderListSearch", method = RequestMethod.POST)
	public List<OrderVO> orderListSearch(String pay_methodList, String o_statusList, String o_cStatusList,
			String durationCategory, String startDate, String endDate, String searchCategory, String searchKeyword) {
		String[] pay_method = pay_methodList.split("/");
		String[] o_status = o_statusList.split("/");
		String[] o_cStatus = o_cStatusList.split("/");
		System.out.println(o_cStatusList);
		System.out.println(o_cStatus);
		List<OrderVO> vos = adminService.getOrder(pay_method, o_status, o_cStatus, durationCategory, startDate, endDate,
				searchCategory, searchKeyword);
		for (OrderVO vo : vos) {
			int totalPrice = vo.getP_price() * vo.getOd_amount();
			vo.setTotalPrice(totalPrice);
			vo.setO_date(vo.getO_date().substring(0, 16));
		}

		return vos;
	}

	@ResponseBody
	@RequestMapping(value = "/order/orderStatusUpdate", method = RequestMethod.POST)
	public String orderStatusUpdate(String oi_productCodeList, String updateStatus) {
		System.out.println(oi_productCodeList);
		String[] oi_productCodes = oi_productCodeList.split("/");
		for (String oi_productCode : oi_productCodes) {
			adminService.updateOrderStatus(oi_productCode, updateStatus);
		}

		return "1";
	}

	@ResponseBody
	@RequestMapping(value = "/order/orderCSUpdate", method = RequestMethod.POST)
	public String orderCSUpdate(String oi_productCodeList, String updateStatus) {
		String[] oi_productCodes = oi_productCodeList.split("/");

		int res = 0;
		if (updateStatus.equals("반품완료")) { // 선택한 값이 반품완료일 때
			IamportClient client = new IamportClient("5074657238861441",
					"2lpjNO5zHjXDWfcNbicrLV82OzX4eMRQnIJ3VclpxAjwAcUXPyNuNtsiXjXeMumUW1RfHq5lLLEFlcaQ");
			for (String oi_productCode : oi_productCodes) {
				OrderVO vo = adminService.getOrderbyProductCode(oi_productCode);
				if (vo.getCs_status() == "반품반려")
					return "RefundNO";
				// 반품 승인일 경우 계속 진행
				BigDecimal amount = new BigDecimal(vo.getRefund_amount());
				CancelData c = new CancelData(vo.getImp_uid(), true, amount);
				try {
					client.cancelPaymentByImpUid(c);
					res = 1;
				} catch (IamportResponseException e) {
					e.printStackTrace();
					System.out.println("아임포트 오류: " + e);
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		} else if (updateStatus.equals("교환완료")) { // 선택한 값이 교환완료일 때
			for (String oi_productCode : oi_productCodes) {
				OrderVO vo = adminService.getOrderbyProductCode(oi_productCode);
				if (vo.getCs_status() == "교환반려")
					return "RefundNO";
				// 반품 승인일 경우 계속 진행
				res = 1;
			}

			adminService.updateCS(oi_productCodes, updateStatus);

		}

		return res + "";
	}

	@ResponseBody
	@RequestMapping(value = "/order/orderCSconfirm", method = RequestMethod.POST)
	public String orderCSconfirm(String cs_admin, String cancelSelect, String oi_productCode, int cs_idx,
			int refund_amount) {
		adminService.updateCustomerStatus(cs_admin, cancelSelect, oi_productCode, cs_idx, refund_amount);
		return 1 + "";
	}

	@ResponseBody
	@RequestMapping(value = "/order/deliveryUpdate", method = RequestMethod.POST)
	public String deliveryUpdate(String deliveryComList, String deliveryIdxList, String deliveryCodeList) {
		int res = adminService.deliveryUpdate(deliveryComList, deliveryIdxList, deliveryCodeList);
		return res + "";
	}

	// 쿠폰 리스트
	@RequestMapping(value = "/coupon", method = RequestMethod.GET)
	public String couponGet(Model model, HttpSession session,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "5", required = false) int pageSize) {
		session.setAttribute("sNowAdminPage", "coupon");

		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "admin", "coupon", "");

		ArrayList<CouponVO> vos = adminService.getCouponPageList(pageVO.getStartIndexNo(), pageSize);
		ArrayList<CouponVO> coupons = adminService.getCouponAvailableList();

		model.addAttribute("vos", vos);
		model.addAttribute("coupons", coupons);
		model.addAttribute("count", vos.size());
		model.addAttribute("pageVO", pageVO);

		return "/admin/coupon/couponList";
	}

	@RequestMapping(value = "/coupon/couponInsert", method = RequestMethod.POST)
	public String couponInsert(CouponVO vo) {
		System.out.println(vo);
		adminService.couponInsert(vo);
		return "redirect:/admin/coupon";
	}

	@ResponseBody
	@RequestMapping(value = "/coupon/couponUpdate", method = RequestMethod.POST)
	public String couponUpdate(CouponVO vo) {
		System.out.println(vo);
		int res = adminService.couponUpdate(vo);
		System.out.println(res);
		return res + "";
	}

	@ResponseBody
	@RequestMapping(value = "/coupon/giveCoupon", method = RequestMethod.POST)
	public String giveCoupon(@RequestParam(value = "giveCoupon_level", defaultValue = "1", required = false) int level,
			@RequestParam(value = "giveCoupon_select", defaultValue = "1", required = false) int cp_idx) {
		// 관리자가 레벨을 기준으로 일괄지급하는 경우에 한정해서,
		// 해당 등급 회원의 목록을 가져와서 cp_idx와 비교한다(0: 전체 1: 실버...)

		// 해당 레벨 대의 모든 회원의 고유번호를 가져옴
		int[] members = adminService.getUserLevelList(level);

		for (int m_idx : members) {
			CouponVO vo = adminService.getMemberCouponList(m_idx, cp_idx);
			if (vo == null) {
				adminService.giveMemberCoupon(m_idx, cp_idx);
			}

		}

		return "1";
	}

	@RequestMapping(value = "/member/memberList", method = RequestMethod.GET)
	public String memberListGet(Model model, HttpSession session,
			@RequestParam(value = "m_level", defaultValue = "", required = false) String m_level,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "10", required = false) int pageSize) {
		session.setAttribute("sNowAdminPage", "member");

		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "member", "m_level", m_level);
		ArrayList<MemberVO> vos;

		if (m_level.equals(""))
			vos = memberService.getMemberPageList(pageVO.getStartIndexNo(), pageSize);
		else {
			int level = Integer.parseInt(m_level);
			vos = memberService.getMemberLevelPageList(pageVO.getStartIndexNo(), pageSize, level);
		}

		System.out.println(vos);
		String levelStr[] = { "관리자", "브론즈", "실버", "골드", "VIP" };
		model.addAttribute("vos", vos);
		model.addAttribute("levelStr", levelStr);
		model.addAttribute("count", vos.size());
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("m_level", m_level);

		model.addAttribute("vos", vos);
		return "/admin/member/memberList";
	}

	@RequestMapping(value = "/member/memberLevel", method = RequestMethod.GET)
	public String memberLevelGet(Model model, @RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "10", required = false) int pageSize) {
		return "/admin/member/memberLevel";
	}

	@ResponseBody
	@RequestMapping(value = "/member/memberLevelUpdate", method = RequestMethod.POST)
	public String memberLevelUpdate(String memberIdxList, int m_level) {
		int res = adminService.memberLevelUpdate(memberIdxList, m_level);
		return res + "";
	}

	@RequestMapping(value = "/coupon/memberCoupon", method = RequestMethod.GET)
	public String memberCouponGet(Model model,
			@RequestParam(value = "level", defaultValue = "", required = false) String level,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "10", required = false) int pageSize) {

		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "admin", "coupon", "user");

		ArrayList<CouponVO> vos = adminService.getCouponUserList(pageVO.getStartIndexNo(), pageSize);

		model.addAttribute("vos", vos);
		model.addAttribute("count", vos.size());
		model.addAttribute("pageVO", pageVO);

		return "/admin/coupon/memberCouponList";
	}

	@RequestMapping(value = "/inquiry/QnA", method = RequestMethod.GET)
	public String QnAListGet(Model model, HttpSession session,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "10", required = false) int pageSize) {
		session.setAttribute("sNowAdminPage", "question");

		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "admin", "QnA", "");
		ArrayList<QnaVO> vos = adminService.getQnAList(pageVO.getStartIndexNo(), pageSize);

		model.addAttribute("pageVO", pageVO);
		model.addAttribute("QnAVos", vos);
		return "/admin/inquiry/QnAList";
	}

	@RequestMapping(value = "/inquiry/1to1Inquiry", method = RequestMethod.GET)
	public String InquiryListGet(Model model, HttpSession session,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "10", required = false) int pageSize) {
		session.setAttribute("sNowAdminPage", "question");

		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "admin", "Inquiry", "");
		ArrayList<InquiryVO> vos = adminService.getInquiryList(pageVO.getStartIndexNo(), pageSize);

		model.addAttribute("pageVO", pageVO);
		model.addAttribute("vos", vos);
		return "/admin/inquiry/InquiryList";
	}

	@RequestMapping(value = "/inquiry/inquiryAnswer", method = RequestMethod.GET)
	public String InquiryGet(HttpSession session, Model model, int inq_idx) {
		session.setAttribute("sNowAdminPage", "question");

		InquiryVO vo = memberService.getMemberInquiry(inq_idx);
		model.addAttribute("vo", vo);
		return "/admin/inquiry/InquiryAnswer";
	}

	@ResponseBody
	@RequestMapping(value = "/inquiry/inquiryAnswer", method = RequestMethod.POST)
	public String InquiryPost(Model model, int inq_idx, String inq_answerContext) {
		int res = adminService.updateInqAnswer(inq_idx, inq_answerContext);
		return "/admin/inquiry/InquiryAnswer";
	}

	@ResponseBody
	@RequestMapping(value = "/inquiry/QnA", method = RequestMethod.POST)
	public String QnAListPost(String answer_context, int qna_idx) {
		String context = answer_context.replace("\n", "<br/>");
		int res = adminService.updateQnA(context, qna_idx);
		return res + "";
	}

	@ResponseBody
	@RequestMapping(value = "/inquiry/QnADelete", method = RequestMethod.POST)
	public String QnADelete(int qna_idx) {
		int res = memberService.deleteQnA(qna_idx);
		return res + "";
	}

	@RequestMapping(value = "/inquiry/QnAListSearch", method = RequestMethod.GET)
	public String QnAListSearch(Model model, SearchVO vo, HttpSession session,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "10", required = false) int pageSize) {
		System.out.println(vo);
		session.setAttribute("sNowAdminPage", "question");

		String[] openSw = vo.getOpenSwList().split("/");
		String[] answerOK = vo.getAnswerOKList().split("/");
		vo.setEndDate(vo.getEndDate() + " 23:59:59");
		int totRec = adminService.getQnASearchRec(openSw, answerOK, vo);
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "admin", "QnA", totRec + "");

		List<QnaVO> vos = adminService.getQnASearch(openSw, answerOK, vo, pageVO.getStartIndexNo(), pageSize);

		vo.setEndDate(vo.getEndDate().substring(0, 10));
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("QnAVos", vos);
		model.addAttribute("searchVO", vo);
		System.out.println(vos);
		return "/admin/inquiry/QnAListSearch";
	}

	@RequestMapping(value = "/announceList", method = RequestMethod.GET)
	public String AnnounceGet(Model model, HttpSession session,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "searchCategory", defaultValue = "", required = false) String searchCategory,
			@RequestParam(name = "searchKeyword", defaultValue = "", required = false) String searchKeyword) {
		session.setAttribute("sNowAdminPage", "announce");

		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "announce", searchCategory, searchKeyword);
		List<AnnounceVO> vos = adminService.getAllAnnounce(pageVO.getStartIndexNo(), pageSize, searchCategory,
				searchKeyword);
		model.addAttribute("vos", vos);
		model.addAttribute("pageVO", pageVO);
		return "/admin/announce/announceList";
	}

	@RequestMapping(value = "/announceInsert", method = RequestMethod.GET)
	public String announceInsertGet(Model model, HttpSession session) {
		session.setAttribute("sNowAdminPage", "announce");

		return "/admin/announce/announceInsert";
	}

	@RequestMapping(value = "/announceUpdate", method = RequestMethod.GET)
	public String announceUpdateGet(Model model, int ann_idx, HttpSession session) {
		AnnounceVO vo = adminService.getNotice(ann_idx);
		model.addAttribute("vo", vo);
		return "/admin/announce/announceInsert";
	}

	@ResponseBody
	@RequestMapping(value = "/announceDelete", method = RequestMethod.POST)
	public String announceDeletePost(int ann_idx) {
		int res = adminService.deleteAnnounce(ann_idx);
		return res + "";
	}

	@ResponseBody
	@RequestMapping(value = "/announceInsert", method = RequestMethod.POST)
	public String announceInsertPost(AnnounceVO vo) {
		int res = adminService.setNewAnnounce(vo);
		return res + "";
	}

}
