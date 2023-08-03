package com.spring.javaweb6S;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.javaweb6S.scheduler.SearchPaid;
import com.spring.javaweb6S.service.MemberService;
import com.spring.javaweb6S.service.OrderService;
import com.spring.javaweb6S.service.ProductService;
import com.spring.javaweb6S.vo.CartVO;
import com.spring.javaweb6S.vo.CouponVO;
import com.spring.javaweb6S.vo.MemberVO;
import com.spring.javaweb6S.vo.OrderVO;
import com.spring.javaweb6S.vo.ProductVO;

@Controller
@RequestMapping(value = "/order")
public class OrderController {
	@Autowired
	SearchPaid searchVbankPaid;

	@Autowired
	OrderService orderService;

	@Autowired
	MemberService memberService;

	@Autowired
	ProductService productService;

	@RequestMapping(value = "/orderOneSheet", method = RequestMethod.GET)
	public String orderOneSheetGet() {
		return "/order/orderSheet";
	}

	@RequestMapping(value = "/orderOneSheet", method = RequestMethod.POST)
	public String orderOneSheet(Model model, HttpSession session,
			@RequestParam(value = "od_amount", required = false, defaultValue = "1") int od_amount,
			@RequestParam(value = "p_idx", required = false) int p_idx) {
		int sLevel = session.getAttribute("sLevel") == null ? 99 : (int) session.getAttribute("sLevel");
		if (sLevel == 99)
			return "/member/memberNeedLogin";

		// 단일 상품 주문
		String mid = (String) session.getAttribute("sMid");

		MemberVO memberVO = memberService.getMemberMidCheck(mid);
		ProductVO productVO = productService.getProductInfo(p_idx);
		productVO.setOd_amount(od_amount);

		model.addAttribute("memberVO", memberVO);
		model.addAttribute("productVO", productVO);

		model.addAttribute("productList", p_idx + "/");
		model.addAttribute("amountList", od_amount + "/");

		int totalPrice = productVO.getP_price() * productVO.getOd_amount();
		int totalOrigPrice = productVO.getP_origPrice() * productVO.getOd_amount();
		int drivePrice = 0;
		if (totalPrice < 50000) {
			drivePrice = 3000;
		}

		model.addAttribute("drivePrice", drivePrice); // 배달비
		model.addAttribute("totalPrice", totalPrice); // 물건 총액
		model.addAttribute("totalOrigPrice", totalOrigPrice); // 물건 원가 총액

		return "/order/orderSheet";
	}

	@RequestMapping(value = "/orderOK", method = RequestMethod.GET)
	public String orderOKGet(Model model, String o_orderCode) {
		OrderVO vo = orderService.getOrderCode(o_orderCode);
		model.addAttribute("vo", vo);
		return "/order/orderOK";
	}

	@ResponseBody
	@RequestMapping(value = "/orderOK", method = RequestMethod.POST, produces = "application/text; charset=utf8")
	public String orderOKPost(OrderVO vo, HttpSession session) {
		System.out.println(vo);
		UUID tempUid = UUID.randomUUID();
		SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
		Date tempDate = new Date(System.currentTimeMillis());

		String uid = tempUid.toString().substring(0, 4).toUpperCase();
		String date = format.format(tempDate);
		String orderCode = "D" + date + uid;
		vo.setO_orderCode(orderCode);

		if (vo.getPay_method().equals("vbank"))
			vo.setO_status("결제대기");
		else
			vo.setO_status("결제완료");
		orderService.setNewOrder(vo);

		int cartCnt = orderService.getMemberCart(vo.getM_mid()).size();
		session.setAttribute("cartCnt", cartCnt);
		return orderCode;
	}

	@RequestMapping(value = "/orderCart", method = RequestMethod.GET)
	public String orderCartGet(Model model, HttpSession session) {

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
		int cartCnt = orderService.getMemberCart(sMid).size();
		session.setAttribute("cartCnt", cartCnt);
		model.addAttribute("vos", vos);
		model.addAttribute("totalPrice", totalPrice);
		return "/order/orderCart";
	}

	@ResponseBody
	@RequestMapping(value = "/orderCart", method = RequestMethod.POST)
	public String orderCartPost(CartVO vo, HttpSession session) {
		int sLevel = session.getAttribute("sLevel") == null ? 99 : (int) session.getAttribute("sLevel");
		if (sLevel == 99)
			return "0";

		int res = 0;
		int sw = 0;
		System.out.println(vo);
		// 한 아이디는 여러개의 상품을 가질 수 있음
		// 만약 같은 상품의 idx가 있다면 해당 count를 증가시켜야 함
		List<CartVO> vos = orderService.getMemberCart(vo.getM_mid());
		// 카트에는 무조건 하나의 idx만 들어가야 함 (중복 X)
		for (CartVO memberCartVO : vos) { // 해당아이디가 장바구니에 넣은 상품을 하나씩 조회
			// 이미 존재하는 상품의 idx면
			if (memberCartVO.getP_idx() == vo.getP_idx()) {
				vo.setCart_idx(memberCartVO.getCart_idx());
				vo.setOd_amount(memberCartVO.getOd_amount() + vo.getOd_amount());
				sw = 1;
			}
		}
		if (sw == 1)
			orderService.updateMemberCart(vo);
		else
			orderService.setMemberCart(vo);
		res = 1;

		return res + "";
	}

	@ResponseBody
	@RequestMapping(value = "/cartDelete", method = RequestMethod.POST)
	public String orderCartPost(@RequestParam(value = "arr[]") List<String> check, HttpSession session) {
		String sMid = (String) session.getAttribute("sMid");

		for (int i = 0; i < check.size(); i++) {
			orderService.deleteCart(Integer.parseInt(check.get(i)), sMid);
		}

		return "1";
	}

	@RequestMapping(value = "/orderSheet", method = RequestMethod.POST)
	public String orderSheet(Model model, HttpSession session,
			@RequestParam(value = "productList", required = false, defaultValue = "x") String productList,
			@RequestParam(value = "amountList", required = false, defaultValue = "x") String amountList) {
		int sLevel = session.getAttribute("sLevel") == null ? 99 : (int) session.getAttribute("sLevel");
		if (sLevel == 99)
			return "/member/memberNeedLogin";
		String mid = (String) session.getAttribute("sMid");

		MemberVO memberVO = memberService.getMemberMidCheck(mid);
		System.out.println(productList);
		System.out.println(amountList);
		// 가져온 상품의 목록을 분리하고, 주문하려는 개수도 분리

		int totalPrice = 0;
		int totalOrigPrice = 0;
		int drivePrice = 0;

		String[] product = productList.split("/");
		String[] amount = amountList.split("/");
		List<ProductVO> vos = new ArrayList<ProductVO>();
		for (int i = 0; i < product.length; i++) {
			ProductVO vo = productService.getProductInfo(Integer.parseInt(product[i]));
			vo.setOd_amount(Integer.parseInt(amount[i]));
			vos.add(vo);
			totalPrice += vo.getP_price() * vo.getOd_amount();
			totalOrigPrice += vo.getP_origPrice() * vo.getOd_amount();
		}

		if (totalPrice < 50000) {
			drivePrice = 3000;
		}

		model.addAttribute("drivePrice", drivePrice); // 배달비
		model.addAttribute("totalPrice", totalPrice); // 물건 총액
		model.addAttribute("totalOrigPrice", totalOrigPrice); // 물건 원가 총액
		model.addAttribute("memberVO", memberVO);
		model.addAttribute("vos", vos);
		model.addAttribute("productList", productList);
		model.addAttribute("amountList", amountList);
		return "/order/orderSheet";
	}

	@RequestMapping(value = "/couponForm", method = RequestMethod.GET)
	public String couponFormGet(int m_idx, int totalPrice, Model model) {
		ArrayList<CouponVO> vos = memberService.getUserCoupon(m_idx);
		model.addAttribute("vos", vos);
		model.addAttribute("totalPrice", totalPrice);
		return "/order/couponForm";
	}

	@ResponseBody
	@RequestMapping(value = "/purchaseConfirm", method = RequestMethod.POST)
	public String purchaseConfirm(String oi_productCode, int totalPrice, HttpSession session) {

		int sLevel = (int) session.getAttribute("sLevel");
		// 구매확정과 동시에 적립금 업데이트
		String sMid = (String) session.getAttribute("sMid");
		int ratio = memberService.getMemberLevel(sLevel, sMid);
		int res = orderService.updateMemberPoint(oi_productCode, totalPrice, ratio, sMid);
		return res + "";
	}

}
