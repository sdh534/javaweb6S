<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>PARADICE | 마이페이지</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<!-- Favicon -->
<link rel="icon" href="${ctp}/images/favicon.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="${ctp}/ckeditor/ckeditor.js"></script>
<script>
		'use strict'
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
			if($("#inq_title").val() != "" || inq_context !=""){
				let con = confirm("입력하신 정보가 저장되지 않았습니다. \n정말 다음에 작성하시겠습니까?");
				if(con) history.back();
			}
			else history.back();
		}
		
		function insertInquiry(){
			let msg = '';
			let iconBtn = '';
			
			if($("#inq_title").val() == "" ){
				alert("제목을 입력해주세요.");
				$("#inq_title").focus();
				return;
			}
			else if(CKEDITOR.instances.inq_context.getData() ==""){
				$("#inq_context").focus();
				alert("내용을 입력해주세요.");
				return;
			}
			else if($("#inq_category").val() == "" ){
				alert("카테고리를 선택해주세요.");
				$("#inq_category").focus();
				return;
			}
				$.ajax({
						type:'post',
			　　　　data: {
							inq_context : CKEDITOR.instances.inq_context.getData(),
							inq_title : inquiryForm.inq_title.value,
							inq_category : inquiryForm.inq_category.value,
							oi_productCode : inquiryForm.oi_productCode.value
			　　　　}, 
			　　　　success: function(res) {
				　　　　if(res == "0") {
							msg = "1:1 문의 등록에 실패했습니다.";
							iconBtn="error";
						}
	    			else {
	    				msg = "정상적으로 1:1 문의가 등록되었습니다.";
	    				iconBtn="success";
	    				setTimeout(function(){location.href='${ctp}/member/myInquiryList';},1500);
	    			}
	    			Swal.fire({
	    				width:500,
	    			  position: 'center',
	    			  icon: iconBtn,
	    			  title: msg,
	    			  showConfirmButton: false,
	    			  timer: 1500
	    			});
				
			　　　　}, 
			　　　　error: function(e) {
			　　　　alert("전송오류:" + e);
						console.log(e);
			}
		});
		}
		</script>
</head>

<body>

	<jsp:include page="/WEB-INF/views/include/nav.jsp" />
	<div
		class="container-xl position-relative bg-white d-flex p-0 mypage mb-5">

		<jsp:include page="/WEB-INF/views/member/myPage/myPageNav.jsp" />


		<div class="container-fluid pt-4 px-4">
			<div class="row">
				<div class="col-sm-12 col-xl-12">
					<div class="text-center rounded p-4">
						<div
							class="d-flex align-items-center justify-content-between mb-4 mt-2 border-bottom-design">
							<div class="d-flex mb-1">
								<h4 class="mb-0 pretendard mr-2">1:1 문의 등록</h4>
							</div>
						</div>
					</div>
				</div>
			</div>
			<form name="inquiryForm">
				<div class="col-sm-12 col-xl-12">
					<div class="bg-white rounded-lg h-100 p-3">
						<div class="d-flex">
							<select name="inq_category" id="inq_category"
								class="mb-3 mr-3 textbox" style="width: 200px;">
								<option value="">분류 선택</option>
								<option value="배송지연/불만">배송지연/불만</option>
								<option value="반품문의">반품문의</option>
								<option value="환불문의">환불문의</option>
								<option value="회원정보문의">회원정보문의</option>
								<option value="기타문의">기타문의</option>
							</select> <input type="text" class="textbox mb-3" name="oi_proudctCode"
								id="oi_proudctCode" placeholder="주문번호 입력(생략 가능)" autofocus
								class="form-control">
							<button type="button" name="oi_productCode"
								class="textbox-button" onclick="findOrderCode();">주문번호
								조회</button>
						</div>
						<input type="text" class="textHeader w-100 mb-3" name="inq_title"
							id="inq_title" placeholder="제목을 입력하세요" autofocus required
							class="form-control">
						<textarea rows="6" name="inq_context" id="inq_context"
							class="form-control mt-5"></textarea>
						<br /> <span class="delete-text"> <i class="fas fa-check"></i>1:1문의
							작성 전 확인해주세요!<br /> <i class="fas fa-check"></i>문의 남겨주시면 2일 이내
							순차적으로 답변 드리겠습니다. <br /> <i class="fas fa-check"></i>제품 하자 혹은 이상으로
							반품(환불)이 필요한 경우 사진과 함께 구체적인 내용을 남겨주세요. <br />
						</span>
						<hr>
						<div class="w-100 d-flex justify-content-end">
							<button type="button" class="btn-black-outline mt-3 mr-2"
								onclick="cancelReview();">취소</button>
							<button type="button" class="btn-black mt-3"
								onclick="insertInquiry();">등록</button>
						</div>
					</div>
				</div>
				<!-- 226라인 row end -->
			</form>
		</div>



		<!-- Back to Top -->
		<a href="#" class="btn btn-lg btn-danger btn-lg-square back-to-top"><i
			class="bi bi-arrow-up"></i></a>
	</div>

	</div>
	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>

</html>