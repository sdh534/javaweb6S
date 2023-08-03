<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="nowPage" value="" />
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<head>
<meta charset="utf-8">
<title>PARADICE | Q&A 관리</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta content="" name="description">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<!-- 페이지네이션 -->
<script src="${ctp}/js/admin/productList.js"></script>
<script src="${ctp}/ckeditor/ckeditor.js"></script>
</head>
<script>
	'use strict';
	var inq_context;
	$(document).ready(function(){
		inq_context = CKEDITOR.replace("inq_context",{
   	height:480,
   	enterMode: CKEDITOR.ENTER_BR, // 엔터키를 <br> 로 적용함.
   	shiftEnterMode: CKEDITOR.ENTER_P,  // 쉬프트 +  엔터를 <p> 로 적용함.
   	filebrowserUploadUrl:"${ctp}/ckeditor/imageUpload",	/* 파일(이미지) 업로드시 매핑경로 */
   	uploadUrl : "${ctp}/ckeditor/imageUpload"		/* 여러개의 그림파일을 드래그&드롭해서 올리기 */
   }); 
	});
	

	function cancelReview(){
		let inq_context = CKEDITOR.instances.inq_context.getData();
		if(inq_context !=""){
			let con = confirm("입력하신 정보가 저장되지 않았습니다. \n정말 다음에 작성하시겠습니까?");
			if(con) location.href='${ctp}/admin/inquiry/1to1Inquiry';
		}
		else location.href='${ctp}/admin/inquiry/1to1Inquiry';
	}
	
	function answerInq(inq_idx){
		let inq_context = CKEDITOR.instances.inq_context.getData();
		if(inq_context==""){
			alert("답변 내용을 입력해주세요.");
			return;
		}
		$.ajax({
			type : "post",
			url : "${ctp}/admin/inquiry/inquiryAnswer",
			data : {
				inq_answerContext :inq_context,
				inq_idx : inq_idx
			},
			success : function(res) {
				Swal.fire({
    				width:500,
    			  position: 'center',
    			  icon: 'success',
    			  title: '정상적으로 등록되었습니다.',
    			  showConfirmButton: false,
    			  timer: 1500
    			})
    			setTimeout(function(){location.reload();},1500);
			},
			error : function() {
				alert("전송오류!");
			}
		}); 
	}
	
	function deleteInq(inq_idx){
		Swal.fire({
			  title: '해당 문의를 삭제하시겠습니까?',
			  showDenyButton: true,
			  confirmButtonColor: 'grey',
			  confirmButtonText: '확인',
			  denyButtonText: '취소',
			}).then((result) => {
			  if (result.isConfirmed) {
			    $.ajax({
			    	type: "post",
			    	data: {qna_idx : qna_idx},
						url: "${ctp}/admin/inquiry/inqDelete",
						success: function(res){
						if(res=="1"){
							Swal.fire({
								width:500,
							  position: 'center',
							  icon: 'success',
							  title: '삭제 되었습니다.',
							  showConfirmButton: false,
							  timer: 1500
							})
							setTimeout(function(){location.reload();},1500);
						}
					}
			    });
			  }
			})
	}
</script>
<body>


	<div class="container-xxl position-relative bg-white d-flex p-0">

		<jsp:include page="/WEB-INF/views/admin/adminNav.jsp" />

		<div class="container-fluid pt-4 px-4">

			<div class="col-sm-12 col-xl-12">
				<div class="bg-white p-5 border-bottom-red">
					<span class="font-12 red">${vo.inq_category}</span>
					<div
						class="textHeader d-flex align-items-center justify-content-between">
						<span>${vo.inq_title}</span>
						<div>
							<span class="font-12 mr-3"> 작성자 | ${vo.m_mid}</span>
							<button class="review-more font-12 text-grey" type="button"
								id="moreMenu" data-toggle="dropdown">
								<i class="fas fa-ellipsis-v"></i>
							</button>

							<ul class="dropdown-menu text-center" aria-labelledby="moreMenu">
								<li><button class="moreBtn  font-14"
										onclick="reviewDelete()">
										<i class="fas fa-trash-alt fa-2xs"></i> &nbsp; 삭제
									</button></li>
							</ul>
						</div>
					</div>
					<div class="d-flex justify-content-end mt-1">
						<span class="font-12"> ${fn:substring(vo.inq_wDate,0,16)}</span>
					</div>

					<!-- 내용 -->
					<div class="font-12 p-3">${vo.inq_context }</div>
				</div>
			</div>
			<!-- 226라인 row end -->

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
									<span class="font-12 text-white">답변작성 </span>
								</span>
							</h4>

						</div>
					</div>
					<!-- 내용 -->
					<div class="font-12 p-3 mb-5">
						<textarea rows="6" name="inq_context" id="inq_context"
							class="form-control mt-2">${vo.inq_answerContext}</textarea>
					</div>

					<div class="w-100 d-flex justify-content-end">
						<button type="button" class="btn-black-outline mt-3 mr-2"
							onclick="cancelReview();">취소</button>
						<button type="button" class="btn-black mt-3"
							onclick="answerInq(${vo.inq_idx});">
							<c:if test="${vo.inq_answerOK=='NO'}">등록</c:if>
							<c:if test="${vo.inq_answerOK=='OK'}">수정</c:if>
						</button>
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
