<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="nowPage" value="" />
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<head>
<meta charset="utf-8">
<title>PARADICE | 공지사항 관리</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta content="" name="description">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<!-- 페이지네이션 -->
<script src="${ctp}/js/admin/productList.js"></script>
<script src="${ctp}/ckeditor/ckeditor.js"></script>
</head>
<script>
	'use strict';
	var ann_context;
	$(document).ready(function() {
		ann_context = CKEDITOR.replace("ann_context", {
			height : 480,
			enterMode : CKEDITOR.ENTER_BR, // 엔터키를 <br> 로 적용함.
			shiftEnterMode : CKEDITOR.ENTER_P, // 쉬프트 +  엔터를 <p> 로 적용함.
			filebrowserUploadUrl : "${ctp}/ckeditor/imageUpload", /* 파일(이미지) 업로드시 매핑경로 */
			uploadUrl : "${ctp}/ckeditor/imageUpload" /* 여러개의 그림파일을 드래그&드롭해서 올리기 */
		});
	});

	function cancelReview() {
		let ann_context = CKEDITOR.instances.ann_context.getData();
		if (ann_context != "") {
			let con = confirm("입력하신 정보가 저장되지 않았습니다. \n정말 다음에 작성하시겠습니까?");
			if (con)
				location.href = '${ctp}/admin/announceList';
		} else
			location.href = '${ctp}/admin/announceList';
	}

	function answerAnn() {
		let ann_context = CKEDITOR.instances.ann_context.getData();
		if (ann_context == "") {
			alert("내용을 입력해주세요.");
			return;
		}
		if ($("#ann_title") == "") {
			alert("제목을 입력해주세요.");
			return;
		}
		$.ajax({
			type : "post",
			url : "${ctp}/admin/announceInsert",
			data : {
				ann_context : ann_context,
				ann_title : annForm.ann_title.value
			},
			success : function(res) {
				Swal.fire({
					width : 500,
					position : 'center',
					icon : 'success',
					title : '정상적으로 등록되었습니다.',
					showConfirmButton : false,
					timer : 1500
				})
				setTimeout(function() {
					location.href = '${ctp}/admin/announceList';
				}, 1500);
			},
			error : function() {
				alert("전송오류!");
			}
		});
	}
</script>
<body>


	<div class="container-xxl position-relative bg-white d-flex p-0">

		<jsp:include page="/WEB-INF/views/admin/adminNav.jsp" />

		<div class="container-fluid pt-4 px-4">
			<!-- admin 답변 -->
			<div class="col-sm-12 col-xl-12">
				<div class="bg-white p-5">
					<div class="border-line mb-2"></div>
					<div
						class="d-flex align-items-center justify-content-between mb-4 mt-2">
						<div class="d-flex mb-1">
							<h4 class="mb-0 pretendard mr-2">
								<span
									class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger text-white">
									<span class="font-12 text-white">공지사항 등록 </span>
								</span>
							</h4>

						</div>
					</div>
					<!-- 내용 -->
					<form name="annForm">
						<input type="text" class="textHeader w-100 mb-3" name="ann_title"
							id="ann_title" placeholder="제목을 입력하세요" autofocus required
							class="form-control"
							<c:if test="${vo != null}">value="${vo.ann_title}"</c:if>>

						<textarea rows="6" name="ann_context" id="ann_context"
							class="form-control mt-5"><c:if test="${vo != null}">${vo.ann_context}</c:if></textarea>
						<br />
					</form>

					<div class="w-100 d-flex justify-content-end">
						<button type="button" class="btn-black-outline mt-3 mr-2"
							onclick="cancelReview();">취소</button>
						<button type="button" class="btn-black mt-3"
							onclick="answerAnn();">등록</button>
					</div>
				</div>
			</div>
			<!-- 226라인 row end -->
		</div>






		<!-- Footer Start -->
		<div class="container-fluid pt-4 px-4">
			<div class="bg-light rounded-top p-3">
				<div class="row">
					<div class="col-12 col-sm-6 text-center text-sm-start">
						&copy; <a href="#">Your Site Name</a>, All Right Reserved.
					</div>
					<div class="col-12 col-sm-6 text-center text-sm-end">
						<!--/*** This template is free as long as you keep the footer authorâs credit link/attribution link/backlink. If you'd like to use the template without the footer authorâs credit link/attribution link/backlink, you can purchase the Credit Removal License from "https://htmlcodex.com/credit-removal". Thank you for your support. ***/-->
						Designed By <a href="https://htmlcodex.com">HTML Codex</a>
					</div>
				</div>
			</div>
		</div>
		<!-- Footer End -->
	</div>
	<!-- Content End -->

	<!-- Back to Top -->
	<a href="#" class="btn btn-lg btn-danger btn-lg-square back-to-top"><i
		class="bi bi-arrow-up"></i></a>

</body>
