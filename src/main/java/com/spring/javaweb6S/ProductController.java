package com.spring.javaweb6S;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.javaweb6S.pagination.PageProcess;
import com.spring.javaweb6S.scheduler.SearchPaid;
import com.spring.javaweb6S.service.MemberService;
import com.spring.javaweb6S.service.ProductService;
import com.spring.javaweb6S.service.ReviewService;
import com.spring.javaweb6S.vo.CategoryVO;
import com.spring.javaweb6S.vo.PageVO;
import com.spring.javaweb6S.vo.ProductVO;
import com.spring.javaweb6S.vo.QnaVO;
import com.spring.javaweb6S.vo.ReviewVO;

@Controller
@RequestMapping(value = "/product")
public class ProductController {

	@Autowired
	PageProcess pageProcess;

	@Autowired
	ProductService productService;

	@Autowired
	ReviewService reviewService;

	@Autowired
	MemberService memberService;

	@RequestMapping(value = "/productInfo", method = RequestMethod.GET)
	public String productInfoGet(int p_idx, Model model, HttpSession session,
			@RequestParam(name = "sortAnswer", defaultValue = "", required = false) String sortAnswer,
			@RequestParam(name = "pagQnA", defaultValue = "1", required = false) int pagQnA,
			@RequestParam(name = "pageSizeQnA", defaultValue = "10", required = false) int pageSizeQnA,
			@RequestParam(name = "pagReview", defaultValue = "1", required = false) int pagReview,
			@RequestParam(name = "pageSizeReview", defaultValue = "10", required = false) int pageSizeReview,
			@RequestParam(name = "paging", defaultValue = "", required = false) String paging) {

		ProductVO vo = productService.getProductInfo(p_idx);
		model.addAttribute("vo", vo);

		// 리뷰 목록
		PageVO pageReviewVO = pageProcess.totRecCnt(pagReview, pageSizeReview, "review", "p_idx", p_idx + "");
		ArrayList<ReviewVO> reviewVos = reviewService.getProductReviewList(p_idx, pageReviewVO.getStartIndexNo(),
				pageSizeReview);
		vo.setP_reviewCnt(reviewVos.size());
		model.addAttribute("reviewVos", reviewVos);
		model.addAttribute("pageReviewVO", pageReviewVO);

		// QnA목록
		PageVO pageQnAVO = null;
		if (sortAnswer.equals(""))
			pageQnAVO = pageProcess.totRecCnt(pagQnA, pageSizeQnA, "qna", "p_idx", p_idx + "");
		else
			pageQnAVO = pageProcess.totRecCnt(pagQnA, pageSizeQnA, "qnaSort", "p_idx", p_idx + "/" + sortAnswer);
		ArrayList<QnaVO> QnAVos = productService.getQnAList(p_idx, pageQnAVO.getStartIndexNo(), pageSizeQnA, sortAnswer);

		String sMid = (String) session.getAttribute("sMid");
		int[] pIdx = memberService.getWishList(p_idx, sMid);
		if (pIdx.length != 0)
			model.addAttribute("wishList", true);
		else
			model.addAttribute("wishList", false);

		model.addAttribute("QnAVos", QnAVos);
		model.addAttribute("sortAnswer", sortAnswer);
		model.addAttribute("pageQnAVO", pageQnAVO);
		model.addAttribute("paging", paging);
		return "/product/productInfo";
	}

	@RequestMapping(value = "/productQnA", method = RequestMethod.GET)
	public String productQnAGet(int p_idx, Model model) {
		model.addAttribute("p_idx", p_idx);

		return "/product/productQnA";
	}

	// qna 작성
	@ResponseBody
	@RequestMapping(value = "/productQnA", method = RequestMethod.POST)
	public String productQnAPost(QnaVO vo) {
		String qna_context = vo.getQna_context().replace("\n", "<br/>");
		vo.setQna_context(qna_context);
		int res = productService.insertQnA(vo);
		return res + "";
	}

	// 리뷰 좋아요 버튼
	@ResponseBody
	@RequestMapping(value = "/reviewThumb", method = RequestMethod.POST)
	public String reviewThumbPost(int review_idx, HttpSession session) {
		ArrayList<String> likeReviewIdx = (ArrayList) session.getAttribute("likeReviewIdx");

		int res = 0;
		String tempIdx = "review" + review_idx;
		if (likeReviewIdx == null)
			likeReviewIdx = new ArrayList<String>(); // 좋아요를 누른 적이 없다면 세션에 한번 생성해주고
		if (!likeReviewIdx.contains(tempIdx)) { // 생성한 값에 리뷰의 고유번호가 없다면 좋아요 증가
			res = reviewService.setReviewThumb(review_idx);
			likeReviewIdx.add(tempIdx);
		}
		session.setAttribute("likeReviewIdx", likeReviewIdx);
		return res + "";
	}

	// 전체보기에서 갈때
	@RequestMapping(value = "/productList", method = RequestMethod.GET)
	public String MainListGet(String category, Model model,
			@RequestParam(name = "sort", defaultValue = "", required = false) String sort,
			@RequestParam(name = "mainCode", defaultValue = "", required = false) String mainCode,
			@RequestParam(name = "middleCode", defaultValue = "all", required = false) String middleCode,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "20", required = false) int pageSize) {
		// board, new, best... 등 내비게이션 클릭 시 사용한다
		PageVO pageVO = null;
		ArrayList<ProductVO> vos = null;

		ArrayList<CategoryVO> middleVOS = productService.getCategory(mainCode); // 중분류 가져오기
		if (middleCode.equals("all")) {
			pageVO = pageProcess.totRecCnt(pag, pageSize, "product", "c_mainCode", mainCode);
			vos = productService.getProductPageList("c_mainCode", mainCode, pageVO.getStartIndexNo(), pageSize, sort);
		} else {
			pageVO = pageProcess.totRecCnt(pag, pageSize, "product", "c_middleCode", middleCode);
			vos = productService.getProductPageList("c_middleCode", middleCode, pageVO.getStartIndexNo(), pageSize, sort);
		}

		for (ProductVO vo : vos) {
			ArrayList<ReviewVO> rVos = reviewService.getProductReview(vo.getP_idx());
			if (rVos.size() != 0) {
				vo.setP_rating(reviewService.getProductRating(vo.getP_idx()));
				vo.setP_reviewCnt(rVos.size());
			}
		}

		String mainName = productService.getMainCategoryName(mainCode);
		model.addAttribute("title", mainName);
		model.addAttribute("totRecCnt", pageVO.getTotRecCnt());
		model.addAttribute("middleVOS", middleVOS);
		model.addAttribute("middleCode", middleCode);
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("vos", vos);
		model.addAttribute("sort", sort);
		model.addAttribute("paging", mainCode);
		return "/product/productList";
	}

	// 카테고리 - 최신순
	@RequestMapping(value = "/productList/new", method = RequestMethod.GET)
	public String NewListGet(String category, Model model,
			@RequestParam(name = "sort", defaultValue = "", required = false) String sort,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "20", required = false) int pageSize)
			throws InterruptedException {
		// board, new, best... 등 내비게이션 클릭 시 사용한다
		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "product", "", "");

		ArrayList<ProductVO> vos = productService.getProductNewPageList(pageVO.getStartIndexNo(), pageSize);

		for (ProductVO vo : vos) {
			ArrayList<ReviewVO> rVos = reviewService.getProductReview(vo.getP_idx());
			if (rVos.size() != 0) {
				vo.setP_rating(reviewService.getProductRating(vo.getP_idx()));
				vo.setP_reviewCnt(rVos.size());
			}
		}
		model.addAttribute("title", "NEW");
		model.addAttribute("totRecCnt", pageVO.getTotRecCnt());
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("vos", vos);
		model.addAttribute("sort", sort);
		model.addAttribute("paging", "new");
		return "/product/productList";
	}

	@RequestMapping(value = "/productSearch", method = RequestMethod.GET)
	public String productSearch(String searchKeyword, Model model,
			@RequestParam(name = "sort", defaultValue = "", required = false) String sort,
			@RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "20", required = false) int pageSize) {
		PageVO pageVO = null;

		pageVO = pageProcess.totRecCnt(pag, pageSize, "product", "search", searchKeyword);
		ArrayList<ProductVO> vos = productService.getProductSearchList(searchKeyword, pageVO.getStartIndexNo(), pageSize,
				sort);
		for (ProductVO vo : vos) {
			ArrayList<ReviewVO> rVos = reviewService.getProductReview(vo.getP_idx());
			if (rVos.size() != 0) {
				vo.setP_rating(reviewService.getProductRating(vo.getP_idx()));
				vo.setP_reviewCnt(rVos.size());
			}
		}
		model.addAttribute("title", "검색결과");
		model.addAttribute("totRecCnt", pageVO.getTotRecCnt());
		model.addAttribute("pageVO", pageVO);
		model.addAttribute("searchKeyword", searchKeyword);
		model.addAttribute("vos", vos);
		model.addAttribute("sort", sort);
		return "/product/productSearch";
	}
}
