package com.spring.javaweb6S;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.FileSystemResource;
import org.springframework.http.MediaType;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
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
import com.spring.javaweb6S.service.ProductService;
import com.spring.javaweb6S.service.ReviewService;
import com.spring.javaweb6S.vo.CartVO;
import com.spring.javaweb6S.vo.CouponVO;
import com.spring.javaweb6S.vo.InquiryVO;
import com.spring.javaweb6S.vo.MemberVO;
import com.spring.javaweb6S.vo.OrderVO;
import com.spring.javaweb6S.vo.PageVO;
import com.spring.javaweb6S.vo.ProductVO;
import com.spring.javaweb6S.vo.QnaVO;
import com.spring.javaweb6S.vo.ReviewVO;
import com.spring.javaweb6S.vo.SearchVO;

@Controller
@RequestMapping(value = "/member")
public class MemberController {
	@Autowired
	MemberService memberService;

	@Autowired
	ProductService productService;

	@Autowired
	OrderService orderService;

	@Autowired
	ReviewService reviewService;

	@Autowired
	AdminService adminService;

	@Autowired
	BCryptPasswordEncoder passwordEncoder;

	@Autowired
	PageProcess pageProcess;

	@Autowired
	JavaMailSender mailSender;

	@ResponseBody
	@RequestMapping(value = "/memberLogin", method = RequestMethod.POST)
	public String memberLoginPost(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(name = "mid", defaultValue = "", required = false) String mid,
			@RequestParam(name = "pwd", defaultValue = "", required = false) String pwd,
			@RequestParam(name = "autoLogin", defaultValue = "", required = false) boolean autoLogin) {
		MemberVO vo = memberService.getMemberMidCheck(mid);

		if (vo == null)
			return "NoID";
		if (vo.getM_userDel() == 'Y')
			return "NoID";
		if (vo != null && vo.getM_userDel() == 'N' && passwordEncoder.matches(pwd, vo.getM_pwd())) {
			HttpSession session = request.getSession();
			session.setAttribute("strLevel", vo.getM_levelStr());
			session.setAttribute("sLevel", vo.getM_level());
			session.setAttribute("sLevelRatio", vo.getM_pointRatio());
			session.setAttribute("sMid", vo.getM_mid());
			session.setAttribute("sIdx", vo.getM_idx());

			memberService.updateLastDate(vo.getM_mid());
			int cartCnt = orderService.getMemberCart(vo.getM_mid()).size();
			session.setAttribute("cartCnt", cartCnt);

			if (autoLogin == true) { // 참일때
				Cookie cookie = new Cookie("cMid", mid);
				cookie.setMaxAge(60 * 60 * 24 * 7);
				cookie.setPath("/");
				response.addCookie(cookie);
			} else {
				Cookie[] cookies = request.getCookies();
				for (int i = 0; i < cookies.length; i++) {
					if (cookies[i].getName().equals("cMid")) {
						cookies[i].setMaxAge(0);
						cookies[i].setPath("/");
						response.addCookie(cookies[i]);
						break;
					}
				}
			}
			return "OK";
		} else if (vo != null && vo.getM_userDel() == 'N' && !passwordEncoder.matches(pwd, vo.getM_pwd()))
			return "NoPwd";
		else
			return "NoID";
	}

	// 나중에 약관 추가하고 바꿔야함
	@RequestMapping(value = "/memberJoinTerm", method = RequestMethod.GET)
	public String memberJoinTermGet() {
		return "/member/memberJoin";
	}

	// 비밀번호 찾기
	@RequestMapping(value = "/memberPwdFind", method = RequestMethod.GET)
	public String memberPwdFindGet() {
		return "/member/pwdFind";
	}

	// 비밀번호 찾기
	@ResponseBody
	@RequestMapping(value = "/memberPwdFind", method = RequestMethod.POST)
	public String memberPwdFindPost(String m_mid, String m_email, HttpServletRequest request) throws MessagingException {
		MemberVO vo = memberService.getMemberMidCheck(m_mid);
		if (vo != null) {
			if (vo.getM_email().equals(m_email)) {
				// 회원정보가 맞다면 임시비밀번호를 발급받는다.(8자리)
				UUID uid = UUID.randomUUID();
				String pwd = uid.toString().substring(0, 8);

				// 회원이 임시비밀번호를 변경처리할 수 있도록 유도하기위해 임시세션1개를 생성해준다.
				HttpSession session = request.getSession();
				session.setAttribute("sImsiPwd", pwd);

				// 발급받은 임시비밀번호를 암호화처리시켜서 DB에 저장한다.
				memberService.setMemberPwdUpdate(m_mid, passwordEncoder.encode(pwd));

				// 저정된 임시비밀번호를 메일로 전송처리한다.
				String content = pwd;
				int res = mailSend(m_email, content);

				if (res == 1)
					return "OK";
				else
					return "FAIL";
			} else {
				return "EMAILNO";
			}
		} else {
			return "MIDNO";
		}
	}

	// 임시비밀번호를 메일로 전송처리한다.
	private int mailSend(String toMail, String content) throws MessagingException {
		String title = "임시 비밀번호를 발급하였습니다.";

		// 메일 전송을 위한 객체 : MimeMessage(), MimeMessageHelper()
		MimeMessage message = mailSender.createMimeMessage();
		MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");

		// 메일보관함에 회원이 보내온 메세지들의 정보를 모두 저장시킨후 작업처리하자...
		messageHelper.setTo(toMail);
		messageHelper.setSubject(title);
		messageHelper.setText(content);

		// 메세지 보관함의 내용(content)에 필요한 정보를 추가로 담아서 전송시킬수 있도록 한다.

		content = "<br><hr><h3>임시 비밀번호는 <font color='red'>" + content + "</font></h3><hr><br>";
		content += "<p>방문하기 : <a href='http://49.142.157.251:9090/cjgreen/'>CJ Green프로젝트</a></p>";
		content += "<hr>";
		messageHelper.setText(content, true);

		// 본문에 기재된 그림파일의 경로를 별도로 표시시켜준다. 그런후, 다시 보관함에 담아준다.
		FileSystemResource file = new FileSystemResource(
				"D:\\javaweb\\springframework\\works\\javawebS\\src\\main\\webapp\\resources\\images\\main.jpg");

		// 메일 전송하기
		mailSender.send(message);

		return 1;
	}

	// 아이디 찾기GET
	@RequestMapping(value = "/memberIdFind", method = RequestMethod.GET)
	public String memberIdFindGet() {
		return "/member/idFind";
	}

	// 아이디찾기
	@ResponseBody
	@RequestMapping(value = "/memberIdFind", method = RequestMethod.POST)
	public String memberIdFindPost(String name, String email) {
		String res = "";
		MemberVO vo = memberService.getMemberIdFind(name, email);
		if (vo != null)
			res = vo.getM_mid();
		else
			res = "NO";
		return res;

	}

	// 나중에 약관 추가하고 바꿔야함
	@RequestMapping(value = "/memberDelete", method = RequestMethod.GET)
	public String memberDeleteGet() {
		return "/member/myPage/memberDeleteWarn";
	}

	// 나중에 비밀번호 확인하고 접속해야 함
	@RequestMapping(value = "/updateInfo", method = RequestMethod.GET)
	public String updateInfoGet(HttpSession session, Model model) {
		String sMid = (String) session.getAttribute("sMid");
		MemberVO vo = memberService.getMemberMidCheck(sMid);
		model.addAttribute("vo", vo);
		return "/member/myPage/myUpdateInfo";
	}

	@RequestMapping(value = "/updateInfo", method = RequestMethod.POST)
	public String updateInfoPost(MemberVO vo, Model model) {
		if (vo.getM_mailOk() == null)
			vo.setM_mailOk("NO");

		if (vo.getM_pwd() != "")
			vo.setM_pwd(passwordEncoder.encode(vo.getM_pwd()));
		memberService.setMemberUpdate(vo);

		model.addAttribute("name", vo.getM_name());
		model.addAttribute("mailOK", vo.getM_mailOk());

		return "/member/myPage/myUpdateInfoOk";
	}

	// 아이디 중복검사
	@ResponseBody
	@RequestMapping(value = "/memberIdCheck", method = RequestMethod.POST)
	public String memberIdCheckPost(String mid) {
		MemberVO vo = memberService.getMemberMidCheck(mid);
		if (vo != null)
			return "N";
		else
			return "Y";
	}

	@RequestMapping(value = "/memberJoin", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String memberJoinTermPost(MemberVO vo, Model model) {
		if (memberService.getMemberMidCheck(vo.getM_mid()) != null) {
			return "";
		}
		if (vo.getM_mailOk() == null)
			vo.setM_mailOk("NO");
		vo.setM_pwd(passwordEncoder.encode(vo.getM_pwd()));

		int res = memberService.setMemberJoin(vo);
		model.addAttribute("name", vo.getM_name());
		if (res == 1)
			return "redirect:/member/memberJoinOk";
		else
			return "/member/memberJoinNo";
	}

	@RequestMapping(value = "/memberJoinOk", method = RequestMethod.GET)
	public String memberJoinOkGet(Model model, String name) {
		model.addAttribute("name", name);
		return "/member/memberJoinOk";
	}

	@RequestMapping(value = "/memberNeedLogin", method = RequestMethod.GET)
	public String memberNeedLoginGet(HttpServletRequest request) {
		Cookie[] cookies = request.getCookies();
		if (cookies != null) {
			for (int i = 0; i < cookies.length; i++) {
				if (cookies[i].getName().equals("cMid")) {
					request.setAttribute("cMid", cookies[i].getValue());
					break;
				}
			}
		}
		return "/member/memberNeedLogin";
	}

	@ResponseBody
	@RequestMapping(value = "/memberLogout", method = RequestMethod.POST)
	public String memberLogoutGet(HttpSession session) {
		session.invalidate();
		return "1";
	}

	@ResponseBody
	@RequestMapping(value = "/wishList", method = RequestMethod.POST)
	public String wishList(HttpSession session, int p_idx) {
		String sMid = (String) session.getAttribute("sMid");
		int[] p_idxList = memberService.getWishList(p_idx, sMid);
		String sw = "OK";
		if (p_idxList.length != 0) {
			// 있으면...
			memberService.removeWishList(p_idx, sMid);
			return "NO";
		}
		memberService.addWishList(p_idx, sMid);
		return sw;

	}

	@RequestMapping(value = "/myPage", method = RequestMethod.GET)
	public String myPage(HttpSession session, Model model) {
		String sMid = (String) session.getAttribute("sMid");
		List<OrderVO> vos = memberService.getAllOrder(sMid, "", "", 0, 5);
		if (vos.size() > 5)
			vos = vos.subList(0, 5);
		for (OrderVO vo : vos) {
			int totalPrice = vo.getP_price() * vo.getOd_amount();
			vo.setTotalPrice(totalPrice);
			vo.setO_date(vo.getO_date().substring(0, 16));
			vo.setReviewOK(false);
			if (reviewService.getOrderReview(vo.getOi_productCode()) != 0) {
				vo.setReviewOK(true);
			}
		}
		MemberVO memberVO = memberService.getMemberMidCheck(sMid);

		int couponCnt = memberService.getMemberCoupon(memberVO.getM_idx());
		int orderItems = memberService.getMemberOrder(memberVO.getM_mid());
		model.addAttribute("vos", vos);
		model.addAttribute("couponCnt", couponCnt);
		model.addAttribute("orderItems", orderItems);
		model.addAttribute("memberVO", memberVO);
		return "member/myPage/myPage";
	}

	@RequestMapping(value = "/myOrderList", method = RequestMethod.GET)
	public String myOrderList(HttpSession session, Model model,
			@RequestParam(name = "startDate", defaultValue = "", required = false) String startDate,
			@RequestParam(name = "endDate", defaultValue = "", required = false) String endDate,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "5", required = false) int pageSize) {

		String sMid = (String) session.getAttribute("sMid");

		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "member", "order", startDate + "/" + endDate + "/" + sMid);

		List<OrderVO> vos = memberService.getAllOrder(sMid, startDate, endDate, pageVO.getStartIndexNo(), pageSize);
		for (OrderVO vo : vos) {
			int totalPrice = vo.getP_price() * vo.getOd_amount();
			vo.setTotalPrice(totalPrice);
			vo.setO_date(vo.getO_date().substring(0, 16));
			vo.setReviewOK(false);
			if (reviewService.getOrderReview(vo.getOi_productCode()) != 0) {
				vo.setReviewOK(true);
			}
		}
		MemberVO memberVO = memberService.getMemberMidCheck(sMid);
		model.addAttribute("vos", vos);
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("memberVO", memberVO);
		return "member/myPage/myOrderList";
	}

	@RequestMapping(value = "/myWishList", method = RequestMethod.GET)
	public String myOrderList(HttpSession session, Model model,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "5", required = false) int pageSize) {

		String sMid = (String) session.getAttribute("sMid");
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "member", "wishlist", sMid);

		List<ProductVO> vos = memberService.getAllWishList(sMid, pageVO.getStartIndexNo(), pageSize);

		model.addAttribute("vos", vos);
		model.addAttribute("pageVO", pageVO);
		return "member/myPage/myWishList";
	}

	@RequestMapping(value = "/myPointList", method = RequestMethod.GET)
	public String myPointList(HttpSession session, Model model,
			@RequestParam(name = "startDate", defaultValue = "", required = false) String startDate,
			@RequestParam(name = "endDate", defaultValue = "", required = false) String endDate,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "5", required = false) int pageSize) {

		String sMid = (String) session.getAttribute("sMid");
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "member", "point", startDate + "/" + endDate + "/" + sMid);

		List<OrderVO> vos = memberService.getAllPoint(sMid, startDate, endDate, pageVO.getStartIndexNo(), pageSize);

		model.addAttribute("vos", vos);
		model.addAttribute("pageVO", pageVO);
		return "member/myPage/myPointList";
	}

	@RequestMapping(value = "/myCouponList", method = RequestMethod.GET)
	public String myCouponList(HttpSession session, Model model) {
		int idx = (int) session.getAttribute("sIdx");

		ArrayList<CouponVO> vos = memberService.getUserCoupon(idx);
		model.addAttribute("vos", vos);
		return "member/myPage/myCouponList";
	}

	@RequestMapping(value = "/myReviewList", method = RequestMethod.GET)
	public String myReviewList(HttpSession session, Model model) {
		String sMid = (String) session.getAttribute("sMid");

		ArrayList<ReviewVO> vos = memberService.getUserReview(sMid);
		model.addAttribute("reviewVos", vos);
		return "member/myPage/myReviewList";
	}

	@ResponseBody
	@RequestMapping(value = "/mypage/allOrderList", method = RequestMethod.POST)
	public List<OrderVO> memberAllOrderList(HttpSession session) {
		String sMid = (String) session.getAttribute("sMid");
		List<OrderVO> vos = memberService.getAllOrder(sMid, "", "", 0, 0);
		for (OrderVO vo : vos) {
			int totalPrice = vo.getP_price() * vo.getOd_amount();
			vo.setTotalPrice(totalPrice);
			vo.setO_date(vo.getO_date().substring(0, 16));
		}
		return vos;
	}

	@RequestMapping(value = "/myCart", method = RequestMethod.GET)
	public String myCart(HttpSession session, Model model) {

		String sMid = (String) session.getAttribute("sMid");
		List<CartVO> items = orderService.getMemberCart(sMid);
		int totalPrice = 0;
		ArrayList<ProductVO> vos = new ArrayList<ProductVO>();
		for (CartVO item : items) {
			ProductVO vo = productService.getProductInfo(item.getP_idx());
			vo.setOd_amount(item.getOd_amount());
			if (vo.getP_amount() != 0)
				totalPrice += vo.getP_price() * vo.getOd_amount();
			vos.add(vo);
		}
		model.addAttribute("vos", vos);
		model.addAttribute("totalPrice", totalPrice);

		return "member/myPage/myCart";
	}

	@RequestMapping(value = "/myPage/myOrder/reviewForm", method = RequestMethod.GET)
	public String reviewFormGet(@RequestParam(value = "o_idx", defaultValue = "0", required = false) int o_idx,
			@RequestParam(value = "p_idx", defaultValue = "0", required = false) int p_idx,
			@RequestParam(value = "oi_productCode", defaultValue = "", required = false) String oi_productCode, Model model) {
		ProductVO vo = productService.getProductInfo(p_idx);
		System.out.println(vo);
		model.addAttribute("vo", vo);
		model.addAttribute("o_idx", o_idx);
		model.addAttribute("oi_productCode", oi_productCode);
		return "member/myPage/reviewForm";
	}

	@RequestMapping(value = "/myPage/myOrderForm", method = RequestMethod.GET)
	public String myOrderFormGet(@RequestParam(value = "o_idx", defaultValue = "0", required = false) int o_idx,
			Model model) {

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

		return "member/myPage/orderForm";
	}

	@ResponseBody
	@RequestMapping(value = "/myPage/myOrder/reviewForm", method = RequestMethod.POST, consumes = {
			MediaType.APPLICATION_JSON_VALUE, MediaType.MULTIPART_FORM_DATA_VALUE })
	public String reviewFormPost(@RequestPart(name = "files") List<MultipartFile> fileList,
			@RequestPart(name = "vo") ReviewVO vo) {
		System.out.println("파일: " + fileList);
		System.out.println("vo: " + vo);
		int res = reviewService.newReviewInsert(vo, fileList);
		return res + "";
	}

	@ResponseBody
	@RequestMapping(value = "/myPage/myReviewUpdate", method = RequestMethod.POST, consumes = {
			MediaType.APPLICATION_JSON_VALUE, MediaType.MULTIPART_FORM_DATA_VALUE })
	public String myReviewUpdate(@RequestPart(name = "files") List<MultipartFile> fileList,
			@RequestPart(name = "vo") ReviewVO vo) {
		System.out.println("파일: " + fileList);
		System.out.println("vo: " + vo);
		int res = reviewService.ReviewUpdate(vo, fileList);

		return res + "";
	}

	@ResponseBody
	@RequestMapping(value = "/memberDelete", method = RequestMethod.POST)
	public String memberDeletePOST(HttpSession session) {
		String sMid = (String) session.getAttribute("sMid");
		int res = memberService.setMemberDelete(sMid);
		session.invalidate();

		return res + "";
	}

	// 리뷰 수정
	@RequestMapping(value = "/reviewUpdate", method = RequestMethod.GET)
	public String reviewUpdate(int review_idx, Model model) {
		ReviewVO vo = memberService.getUserReviewOne(review_idx);
		model.addAttribute("vo", vo);
		return "member/myPage/reviewFormUpdate";
	}

	@RequestMapping(value = "/myPage/myOrder/cancelForm", method = RequestMethod.GET)
	public String cancelFormGet(@RequestParam(value = "o_idx", defaultValue = "0", required = false) int o_idx,
			@RequestParam(value = "p_idx", defaultValue = "0", required = false) int p_idx,
			@RequestParam(value = "pay_method", defaultValue = "", required = false) String pay_method,
			@RequestParam(value = "oi_productCode", defaultValue = "", required = false) String oi_productCode,
			@RequestParam(value = "imp_uid", defaultValue = "", required = false) String imp_uid, Model model) {
		ProductVO vo = productService.getProductInfo(p_idx);
		model.addAttribute("vo", vo);
		model.addAttribute("o_idx", o_idx);
		model.addAttribute("pay_method", pay_method);
		model.addAttribute("oi_productCode", oi_productCode);
		model.addAttribute("imp_uid", imp_uid);
		return "member/myPage/cancelForm";
	}

	@RequestMapping(value = "/myQnAList", method = RequestMethod.GET)
	public String myQnAListGet(Model model, HttpSession session,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "10", required = false) int pageSize) {
		String mid = (String) session.getAttribute("sMid");
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "member", "QnA", mid);

		ArrayList<QnaVO> vos = memberService.getMemberQnAList(pageVO.getStartIndexNo(), pageSize, mid);

		model.addAttribute("pageVO", pageVO);
		model.addAttribute("QnAVos", vos);
		return "/member/myPage/myQnAList";
	}

	@ResponseBody
	@RequestMapping(value = "/QnADelete", method = RequestMethod.POST)
	public String QnADelete(int qna_idx) {
		int res = memberService.deleteQnA(qna_idx);
		return res + "";
	}

	@ResponseBody
	@RequestMapping(value = "/reviewDelete", method = RequestMethod.POST)
	public String ReviewDelete(int review_idx) {
		int res = memberService.deleteReview(review_idx);
		return res + "";
	}

	@RequestMapping(value = "/myQnASearch", method = RequestMethod.GET)
	public String myQnASearchGet(Model model, HttpSession session, SearchVO vo,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "10", required = false) int pageSize) {
		String mid = (String) session.getAttribute("sMid");
		String[] openSw = vo.getOpenSwList().split("/");
		String[] answerOK = vo.getAnswerOKList().split("/");
		vo.setEndDate(vo.getEndDate() + " 23:59:59");
		int totRec = memberService.getQnASearchRec(openSw, answerOK, vo, mid);
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "member", "QnASearch", totRec + "");

		List<QnaVO> vos = memberService.getQnASearch(openSw, answerOK, mid, vo, pageVO.getStartIndexNo(), pageSize);

		vo.setEndDate(vo.getEndDate().substring(0, 10));
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("QnAVos", vos);
		return "/member/myPage/myQnASearch";
	}

	@RequestMapping(value = "/myPage/myOrder/refundForm", method = RequestMethod.GET)
	public String refundGet(@RequestParam(value = "o_idx", defaultValue = "0", required = false) int o_idx,
			@RequestParam(value = "p_idx", defaultValue = "0", required = false) int p_idx,
			@RequestParam(value = "pay_method", defaultValue = "", required = false) String pay_method,
			@RequestParam(value = "oi_productCode", defaultValue = "", required = false) String oi_productCode, Model model) {
		ProductVO vo = productService.getProductInfo(p_idx);

		// 쿠폰 사용정보를 가져와야함
		int salePrice = orderService.getCouponUse(o_idx, vo.getP_price());
		System.out.println(salePrice);
		model.addAttribute("o_idx", o_idx);
		model.addAttribute("vo", vo);
		model.addAttribute("pay_method", pay_method);
		model.addAttribute("salePrice", salePrice);
		model.addAttribute("oi_productCode", oi_productCode);
		return "member/myPage/refundForm";
	}

	@ResponseBody
	@RequestMapping(value = "/myPage/myOrder/cancelForm", method = RequestMethod.POST, consumes = {
			MediaType.APPLICATION_JSON_VALUE, MediaType.MULTIPART_FORM_DATA_VALUE })
	public String cancelFormGet(@RequestPart(name = "files") List<MultipartFile> fileList,
			@RequestPart(name = "vo") OrderVO vo) {
		System.out.println("파일: " + fileList);
		System.out.println("vo: " + vo);
		if (vo.getCancelSelect().equals("취소완료"))
			orderService.updateOrderStatus(vo.getOi_productCode().substring(1, 14), "주문취소");
		int res = 0;
		IamportClient client = new IamportClient("5074657238861441",
				"2lpjNO5zHjXDWfcNbicrLV82OzX4eMRQnIJ3VclpxAjwAcUXPyNuNtsiXjXeMumUW1RfHq5lLLEFlcaQ");
		BigDecimal amount = new BigDecimal(vo.getP_price());
		CancelData c = new CancelData(vo.getImp_uid(), true, amount);
		try {
			client.cancelPaymentByImpUid(c);
			res = reviewService.newCSInsert(vo, fileList);
		} catch (IamportResponseException e) {
			e.printStackTrace();
			System.out.println("아임포트 오류: " + e);
		} catch (IOException e) {
			e.printStackTrace();
		}
		return res + "";
	}

	@RequestMapping(value = "/myInquiryList", method = RequestMethod.GET)
	public String myInquiryListGet(Model model, HttpSession session,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "10", required = false) int pageSize) {
		String mid = (String) session.getAttribute("sMid");
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "member", "Inquiry", mid);
		ArrayList<QnaVO> vos = memberService.getMemberInquiryList(pageVO.getStartIndexNo(), pageSize, mid);

		System.out.println(pageVO);
		System.out.println(vos);
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("InquiryVos", vos);
		return "/member/myPage/myInquiryList";
	}

	@RequestMapping(value = "/InsertInquiry", method = RequestMethod.GET)
	public String InsertInquiry(Model model, HttpSession session) {
		return "/member/myPage/InsertInquiry";
	}

	@ResponseBody
	@RequestMapping(value = "/InsertInquiry", method = RequestMethod.POST)
	public String InsertInquiryPost(InquiryVO vo, HttpSession session) {
		String mid = (String) session.getAttribute("sMid");
		vo.setM_mid(mid);
		int res = memberService.setMemberInquiry(vo);
		return res + "";
	}

	@RequestMapping(value = "/myInquiry", method = RequestMethod.GET)
	public String InsertInquiry(int inq_idx, Model model, HttpSession session) {
		String mid = (String) session.getAttribute("sMid");
		InquiryVO vo = memberService.getMemberInquiry(inq_idx);
		model.addAttribute("vo", vo);

		ArrayList<InquiryVO> pnVos = memberService.getPrevNextInq(inq_idx, mid);
		model.addAttribute("pnVos", pnVos);
		return "/member/myPage/myInquiry";
	}
}
