<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="${ctp}/css/mypage.css">
<link rel="stylesheet" href="${ctp}/css/product.css">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery-serialize-object/2.5.0/jquery.serialize-object.min.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
'use strict';
var uploadFiles = [];
var size = 0;

$(document).ready(function(){
	const textarea = document.getElementById("review_content");
	const charCount = document.getElementById("charCount");
	
	let drop_file = document.querySelector('#drop-file');
	drop_file.addEventListener('click', () => p_image_upload.click());

	$("#p_image_upload").bind("change", function(e) {
		for (let i = 0; i < e.target.files.length; i++) {
			console.log(e.target.files[i]);
			size = uploadFiles.push(e.target.files[i]); //업로드 목록에 추가하고 idx 번호를 반환
			thumbNailPreview(e.target.files[i], size);
		}

	});
	
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
	if($("#review_rating")!= 0 && $("#review_content").val() != ""){
		let con = confirm("입력하신 정보가 저장되지 않습니다. 정말 다음에 작성하시겠습니까?");
		if(con) window.close();
	}
	else window.close();
}


function thumbNailPreview(input, idx) {
	console.log(idx);
	var reader = new FileReader;
	reader.fileName = input.name;
	reader.onload = function(e) {
		
		//들어올때마다 div 요소로 하나씩 추가해준다...
		$("#imagesPreview").append(
			'<div class="previewImage" id="preview'+idx+'">'
			+'<div class="previewDelete" onclick="previewDelete('+idx+')"><i class="fas fa-lg fa-times"></i></div>'
			+'<img class="previewImages2" src="' + e.target.result + '" id="previewImage' + idx + '">'
			+'</div>'
		);
		
	}
	reader.readAsDataURL(input);
}


function previewDelete(idx){
	console.log(typeof(idx));
	uploadFiles.splice(idx, 1); //배열의 인덱스값으로 파일을 삭제한다
	$("#preview"+idx).remove();
}
	
	function uploadReview(){
		let msg = '';
		let iconBtn = '';
		var formData = new FormData();
			let p_image= '';
			for(let i=0; i<uploadFiles.length; i++){
				formData.append('files',uploadFiles[i]);
			}
			formData.delete('p_image_upload');
			
		//파일 제외 나머지를 전부 직렬화 -> 객체로 만들어버림 	 			
			var vo = $('#reviewForm').serializeObject();
			formData.append('vo', new Blob([JSON.stringify(vo)] , {type: "application/json"}));
			
			if($("#review_content").val()==""){
				alert("리뷰 내용을 입력해주세요.");
				return;
			}
			else if ($("#review_rating").val()== 0){
				alert("별점을 입력해주세요.");
				return;
			}
			
			$.ajax({
					type:'post',
		　　　　enctype:"multipart/form-data",   // 업로드를 위한 필수 파라미터
		　　　　url: '${ctp}/member/myPage/myOrder/reviewForm', 
		　　　　data: formData, 
		　　　　processData: false,    // 업로드를 위한 필수 파라미터
		　　　　contentType: false,    // 업로드를 위한 필수 파라미터
		　　　　success: function(res) {
			　　　　if(res == "0") {
						msg = "리뷰 등록에 실패했습니다.";
						iconBtn="error";
					}
    			else {
    				msg = "정상적으로 리뷰가 등록되었습니다.";
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
	<form name="reviewForm" id="reviewForm">
		<div class="container-fluid pt-4 px-0">
			<div class="row">
				<div class="col-sm-12 col-xl-12">
					<div class="bg-white rounded-lg h-100">
						<h5 class="text-center gmarketSans">리뷰 쓰기</h5>
						<div class="mt-3 border-top">
							<div>
								<div class="p-2">
									<img src="${ctp}/data/product/${vo.p_thumbnailIdx}" alt=""
										width="80" class="img-fluid rounded shadow-sm">
									<div class="ml-3 d-inline-block align-middle">
										<h5 class="mb-0">
											<a href="#"
												class="text-dark d-inline-block align-middle gmarketSans">${vo.p_name}</a>
										</h5>
										<span
											class="text-muted font-weight-normal font-italic d-block">${vo.c_mainName}-${vo.c_middleName}</span>
									</div>
								</div>
							</div>

							<div class="popup-border text-center">
								<div class="mt-3">
									<h4>
										<b>상품은 만족하셨나요?</b>
									</h4>
									<div class="ml-3 mb-3 d-inline-block align-middle">
										<div class="ratings d-flex flex-row align-items-center pr-0">
											<div class="d-flex flex-row">
												<div class="rating">
													<div class="w-100">
														<div id="star-rating" class="star-big letter-spacing">
															★★★★★ <span id="star-rating-checked"
																class="star-big letter-spacing color-red">★★★★★</span>
														</div>
														<div class="ms-3 mt-2">
															<div
																class="mt-2 font-big text-white d-flex justify-content-center">
																<font id="starValue">0</font>
																<div class="text-muted">/5</div>
															</div>
														</div>

													</div>
												</div>
											</div>
										</div>
									</div>
									<!-- 별찍기 -->

									<div class="p-4">
										<div class="textarea-container">
											<textarea name="review_content" id="review_content"
												class="textbox w-100" style="height: 100px;"
												placeholder="최소 10자 이상 입력해주세요."></textarea>
											<p id="charCount">0</p>
										</div>
									</div>

									<!-- 사진업로드 -->
									<div class="popup-border">
										<div class="m-3">
											<div class="upload-box">
												<div id="drop-file" class="drag-file">
													<i class="fas fa-camera-retro mr-2"></i>
													<p class="message">사진 첨부하기</p>
												</div>
												<div class="mb-3">
													<input class="d-none" id="p_image_upload"
														name="p_image_upload" multiple type="file">
													<div class="mb-3 d-flex flex-wrap" id="imagesPreview"
														style="overflow: auto;"></div>
												</div>
												<div class="previewList"></div>
												<div class="text-left text-danger">
													<i class="fas fa-check"></i>상품과 무관한 사진/동영상을 첨부한 리뷰는 통보없이 삭제
													및 적립 혜택이 회수됩니다.<br /> <i class="fas fa-check"></i>리뷰 작성시
													자동으로 구매확정 처리 됩니다.
												</div>
											</div>
										</div>

										<div class="popup-border p-4">
											<div class="mb-3">
												<button type="button" class="btn-black mr-2"
													onclick="cancelReview()">취소</button>
												<button type="button" class="btn-black-outline"
													onclick="uploadReview();">등록</button>
											</div>
										</div>

									</div>
								</div>
							</div>
						</div>

					</div>
				</div>


				<input type="hidden" name="p_idx" value="${vo.p_idx}"> <input
					type="hidden" name="review_rating" id="review_rating" value="0">
				<input type="hidden" name="oi_productCode" value="${oi_productCode}">
				<input type="hidden" name="o_idx" value="${o_idx}"> <input
					type="hidden" name="m_mid" value="${sMid}">
			</div>
		</div>
	</form>
</body>


<script>
 	 	let width=0;
 	 	let clickCheck=0;
 	 	let savewidth = 0;
 	 	let RangeValue2 = $("#star-rating-checked").val();
    document.querySelector("#star-rating").addEventListener("mouseover",function(event){
	      document.querySelector("#star-rating").addEventListener("mousemove",function(event){
		      	width = parseInt((event.offsetX)/20.3)*10+9;
	    	  	/* console.log(event.offsetX); 
	    	  	console.log(width2); */
		        $("#star-rating-checked").css("width", width+"%");
		        $("#star-rating").on("click", function(){
		        	clickCheck = 1;
		        	savewidth = width;
					   	$("#starValue").text((savewidth+1)/20);
					   	$("#review_rating").val((savewidth+1)/20);
						});
		});
	  		document.querySelector("#star-rating").addEventListener("mouseleave",function(event){
      	if(clickCheck==1){
			    $("#star-rating-checked").css("width", savewidth+"%");
		    }
      	else {
  				$("#star-rating-checked").css("width", "0%");
      	}
		});
    });
</script>

</html>
