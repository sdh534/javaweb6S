<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="${ctp}/css/mypage.css">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery-serialize-object/2.5.0/jquery.serialize-object.min.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
	'use strict';
	
	$(document).ready(function(){
		const textarea = document.getElementById("qna_context");
		const charCount = document.getElementById("charCount");
		
		
		//글자수 제한
		textarea.addEventListener("keyup", function() {
			this.style.height = "auto";
	    this.style.height = this.scrollHeight + "px";	
		  const text = textarea.value;
		  const count = text.length;
		  
		  if(count > 1000){
			  this.value = text.substring(0, 1000);
		  }
		  charCount.textContent = count + "/1,000";
		});
	});

	
	function cancelReview(){
		if($("#qna_context")!= 0 && $("#qna_context").val() != ""){
			let con = confirm("입력하신 정보가 저장되지 않습니다. 정말 다음에 작성하시겠습니까?");
			if(con) window.close();
		}
		else window.close();
	}
	

	
	function uploadQnA(){
		let msg = '';
		let iconBtn = '';
			
			$.ajax({
					type:'post',
		　　　　url: '${ctp}/product/productQnA', 
		　　　　data: {
						m_mid : qnaForm.m_mid.value,
						p_idx : qnaForm.p_idx.value,
						qna_context : qnaForm.qna_context.value,
						openSw : qnaForm.openSw.value
		　　　　}, 
		　　　　success: function(res) {
			　　　　if(res == "0") {
						msg = "Q&A 등록에 실패했습니다.";
						iconBtn="error";
					}
    			else {
    				msg = "정상적으로 Q&A가 등록되었습니다.";
    				iconBtn="success";
    				setTimeout(function(){window.close();},1500);
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
<body class="popup">
	<form name="qnaForm" id="qnaForm">
		<div class="container-fluid pt-4 px-0">
			<div class="row">
				<div class="col-sm-12 col-xl-12">
					<div class="bg-white rounded-lg h-100">
						<h5 class="text-center gmarketSans">Q&A</h5>
						<div class="mt-3 border-top">

							<div class="popup-border text-center">
								<div class="mt-3">
									<h4>
										<b>상품 Q&A 작성하기</b>
									</h4>

									<div class="p-4">
										<div class="textarea-container">
											<textarea name="qna_context" id="qna_context"
												class="textbox w-100" style="height: 100px;"
												placeholder="문의하실 내용을 최소 10자 이상 입력해주세요."></textarea>
											<p id="charCount">0</p>
										</div>

										<div class="d-flex mb-3">
											<div
												class="mr-3 custom-control custom-radio custom-control-inline ">
												<input class="custom-control-input" type="radio"
													name="openSw" id="sort1" value="NO"> <label
													class="custom-control-label" for="sort1">비공개</label>
											</div>
											<div
												class="custom-control custom-radio custom-control-inline ">
												<input class="custom-control-input" type="radio"
													name="openSw" id="sort2" value="OK"> <label
													class="custom-control-label" for="sort2">공개</label>
											</div>
										</div>

									</div>

									<div class="popup-border">
										<div class="popup-border p-4">
											<div class="mb-3">
												<button type="button" class="btn-black mr-2"
													onclick="cancelReview()">취소</button>
												<button type="button" class="btn-black-outline"
													onclick="uploadQnA();">등록</button>
											</div>
											<div class="text-left text-danger">
												<i class="fas fa-check"></i>상품 Q&A는 상품 및 상품 구매 과정(배송, 반품/취소,
												교환/변경)에 대해 판매자에게 문의하는 게시판입니다.<br /> <i class="fas fa-check"></i>상품
												및 상품 구매 과정과 관련 없는 비방/욕설/명예훼손성 게시글 및 상품과 관련 없는 광고글 등 부적절한 게시글
												등록 시 글쓰기 제한 및 게시글이 삭제 조치 될 수 있습니다.<br /> <i
													class="fas fa-check"></i>전화번호, 이메일 등 개인 정보가 포함된 글 작성이 필요한
												경우 판매자만 볼 수 있도록 비밀글로 문의해 주시기 바랍니다.<br /> <i
													class="fas fa-check"></i>상품에 대한 이용 후기는 리뷰에 남겨 주세요.<br />
											</div>
										</div>

									</div>
								</div>
							</div>
						</div>

					</div>
				</div>


				<input type="hidden" name="p_idx" value="${p_idx}"> <input
					type="hidden" name="m_mid" value="${sMid}">
			</div>
		</div>
	</form>
</body>



</html>
