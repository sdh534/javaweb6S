package com.spring.javaweb6S;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.spring.javaweb6S.pagination.PageProcess;
import com.spring.javaweb6S.service.AdminService;
import com.spring.javaweb6S.service.ProductService;
import com.spring.javaweb6S.vo.AnnounceVO;
import com.spring.javaweb6S.vo.CategoryVO;
import com.spring.javaweb6S.vo.InquiryVO;
import com.spring.javaweb6S.vo.PageVO;
import com.spring.javaweb6S.vo.ProductVO;
import com.spring.javaweb6S.vo.ReviewVO;

@Controller
public class HomeController {
	@Autowired
	ProductService productService;

	@Autowired
	AdminService adminService;

	@Autowired
	PageProcess pageProcess;

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(HttpServletRequest request, Model model, HttpSession session) {
		Cookie[] cookies = request.getCookies();
		if (cookies != null) {
			for (int i = 0; i < cookies.length; i++) {
				if (cookies[i].getName().equals("cMid")) {
					request.setAttribute("cMid", cookies[i].getValue());
					break;
				}
			}
		}
		ArrayList<ProductVO> vos = productService.getHomeProduct();
		ArrayList<ReviewVO> reviewVOS = productService.getHomeReview();
		ArrayList<CategoryVO> mainCategory = adminService.getAllMainCategory();
		ArrayList<CategoryVO> middleCategory = adminService.getAllMiddleCategory();
		model.addAttribute("vos", vos);
		model.addAttribute("reviewVOS", reviewVOS);

		session.setAttribute("mainCategory", mainCategory);
		session.setAttribute("middleCategory", middleCategory);
		System.out.println(mainCategory);
		System.out.println(middleCategory);
		return "home";
	}

	@RequestMapping(value = "/notice", method = RequestMethod.GET)
	public String announceList(Model model, @RequestParam(name = "pag", defaultValue = "1", required = false) int pag,
			@RequestParam(name = "pageSize", defaultValue = "10", required = false) int pageSize,
			@RequestParam(name = "searchCategory", defaultValue = "", required = false) String searchCategory,
			@RequestParam(name = "searchKeyword", defaultValue = "", required = false) String searchKeyword) {

		PageVO pageVO = pageProcess.totRecCnt(pag, pageSize, "announce", searchCategory, searchKeyword);
		List<AnnounceVO> vos = adminService.getAllAnnounce(pageVO.getStartIndexNo(), pageSize, searchCategory,
				searchKeyword);

		model.addAttribute("vos", vos);
		model.addAttribute("pageVO", pageVO);
		return "/announce/announceList";
	}

	@RequestMapping(value = "/notice/content", method = RequestMethod.GET)
	public String announceList(Model model, int ann_idx) {

		AnnounceVO vo = adminService.getNotice(ann_idx);
		model.addAttribute("vo", vo);

		ArrayList<InquiryVO> pnVos = adminService.getPrevNextAnn(ann_idx);
		model.addAttribute("pnVos", pnVos);
		return "/announce/announceContext";
	}

	@RequestMapping(value = "/ckeditor/imageUpload")
	public void ckeditorImageUpload(MultipartFile upload, HttpServletRequest request, HttpServletResponse response)
			throws IOException {
		// 인코딩 설정
		response.setCharacterEncoding("utf-8");
		response.setContentType("text/html; charset=utf-8");

		// 실제 경로 가져오기
		String realPath = request.getSession().getServletContext().getRealPath("/resources/data/ckeditor/");
		// 원본 파일 이름 가져오기
		String oFileName = upload.getOriginalFilename();

		// 중복방지를 위해 원본 파일이름 변경해주기
		Date date = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyMMddHHmmss");
		oFileName = sdf.format(date) + "_" + oFileName;

		// ckeditor에서 올린(전송)한 파일을 서버 파일시스템에 실제로 저장처리시켜준다.
		byte[] bytes = upload.getBytes();
		FileOutputStream fos = new FileOutputStream(new File(realPath + oFileName));
		fos.write(bytes);

		// 서버 파일시스템에 저장되어 있는 그림파일을 브라우저 편집화면(textarea)에 보여주는 처리 -프리뷰
		PrintWriter out = response.getWriter();
		String fileUrl = request.getContextPath() + "/data/ckeditor/" + oFileName;
		out.println("{\"originalFilename\":\"" + oFileName + "\",\"uploaded\":1,\"url\":\"" + fileUrl + "\"}");

		out.flush();
		fos.close();

	}

}
