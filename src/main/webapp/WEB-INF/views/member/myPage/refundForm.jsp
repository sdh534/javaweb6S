<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery-serialize-object/2.5.0/jquery.serialize-object.min.js"></script>
<meta charset="UTF-8">
<link rel="stylesheet" href="${ctp}/css/mypage.css">
<title>Insert title here</title>
<script>
	'use strict';
	
	'use strict';
	var uploadFiles = [];
	var size = 0;
	
	$(document).ready(function(){
		const textarea = document.getElementById("cs_context");
		const charCount = document.getElementById("charCount");
		
		let drop_file = document.querySelector('#drop-file');
		drop_file.addEventListener('click', () => cs_img.click());
		
		$("#cs_img").bind("change", function(e) {
			for (let i = 0; i < e.target.files.length; i++) {
				console.log(e.target.files[i]);
				if(size<5) size = uploadFiles.push(e.target.files[i]); //업로드 목록에 추가하고 idx 번호를 반환
				else {
					alert("파일은 최대 5개만 첨부 가능합니다.");
					return;	
				}
				thumbNailPreview(e.target.files[i], size);
			}
		});

		//글자수 제한
		textarea.addEventListener("keyup", function() {
			this.style.height = "auto";
	    this.style.height = this.scrollHeight + "px";	
		  const text = textarea.value;
		  const count = text.length;
		  
		  if(count > 500){
			  this.value = text.substring(0, 500);
		  }
		  charCount.textContent = count + "/500";
		});
		
		$("#refundMoney").css('display', 'none');
		
		$('input[name="cancelSelect"]').change(function(){
			var value = $(this).val();
	    if(value == "반품요청"){
	    	$("#refundMoney").css('display', 'block');
	    }
	    else $("#refundMoney").css('display', 'none');
	});
		
	});
	


		function thumbNailPreview(input, idx) {
			console.log(idx);
			var reader = new FileReader;
			reader.fileName = input.name;
			reader.onload = function(e) {
				
				//들어올때마다 div 요소로 하나씩 추가해준다...
				$("#imagesPreview").append(
					'<div class="previewImage" id="preview'+idx+'">'
					+'<div class="previewDelete" onclick="previewDelete('+idx+')"><i class="fas fa-lg fa-times"></i></div>'
					+'<img class="previewImages" src="' + e.target.result + '" id="previewImage' + idx + '">'
					+'</label>'
					+'</div>'
				);
				
			}
			reader.readAsDataURL(input);
		}


		function previewDelete(idx){
			console.log(typeof(idx));
			uploadFiles.splice(idx, 1); //배열의 인덱스값으로 파일을 삭제한다
			$("#preview"+idx).remove();
			size--;
		}
		
		function uploadCancelForm(){
			let msg = '';
			let iconBtn = '';
			var formData = new FormData();
				let p_image= '';
				for(let i=0; i<uploadFiles.length; i++){
					formData.append('files',uploadFiles[i]);
				}
				formData.delete('cs_img');
				
			//파일 제외 나머지를 전부 직렬화 -> 객체로 만들어버림 	 			
				var vo = $('#cancelForm').serializeObject();
				formData.append('vo', new Blob([JSON.stringify(vo)] , {type: "application/json"}));
				
				if($("#cs_context").val()==""){
					alert("주문 취소 사유를 입력해주세요.");
					return;
				}
				
				$.ajax({
					  type:'post',
			　　　　enctype:"multipart/form-data",   // 업로드를 위한 필수 파라미터
			　　　　url: '${ctp}/member/myPage/myOrder/cancelForm', 
			　　　　data: formData, 
			　　　　processData: false,    // 업로드를 위한 필수 파라미터
			　　　　contentType: false,    // 업로드를 위한 필수 파라미터
			　　　　success: function(res) {
				　　　　if(res == "0") {
							msg = "주문 취소에 실패했습니다.";
							iconBtn="error";
						}
	    			else {
	    				msg = "정상적으로 접수되었습니다.";
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
		
	function cancel(){
		if($("#cs_context").val() != ""){
			let con = confirm("입력하신 정보가 저장되지 않습니다. 정말 다음에 작성하시겠습니까?");
			if(con) window.close();
		}
		else window.close();
	}
	
</script>
</head>
<body class="popup">
	<form name="cancelForm" id="cancelForm">
		<div class="container-fluid pt-4 px-0">
			<div class="row">
				<div class="col-sm-12 col-xl-12">
					<div class="bg-white rounded-lg h-100">
						<h5 class="text-center gmarketSans">주문 취소</h5>
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
										<b>교환/반품 사유를 입력해주세요.</b>
									</h4>
									<div class=" mb-3  align-middle">
										<div class="d-flex justify-content-center mb-3">
											<div
												class="mr-3 custom-control custom-radio custom-control-inline ">
												<input class="custom-control-input" type="radio"
													name="cancelSelect" id="sort1" value="교환요청"> <label
													class="custom-control-label" for="sort1">교환</label>
											</div>
											<div
												class="custom-control custom-radio custom-control-inline ">
												<input class="custom-control-input" type="radio"
													name="cancelSelect" id="sort2" value="반품요청"> <label
													class="custom-control-label" for="sort2">반품</label>
											</div>
										</div>
										<div class="px-4">
											<select class="btn h-100 form-control border"
												name="cs_category" style="font-size: 11pt;">
												<option>요청사유 선택</option>
												<option value="단순변심">단순변심</option>
												<option value="배송문제">배송문제</option>
												<option value="상품문제">상품문제</option>
											</select>
										</div>

									</div>
									<!-- 별찍기 -->

									<div class="form_wrapper p-4">
										<div class="textarea-container">
											<textarea name="cs_context" id="cs_context"
												class="textbox w-100" style="height: 100px;"
												placeholder="최소 10자 이상 입력해주세요."></textarea>
											<p id="charCount">0/500</p>
										</div>
									</div>

									<div class="popup-border text-center">
										<div class="p-2 mt-3" id="refundMoney">
											<h4>
												<b>환불 금액 안내</b>
											</h4>
											<div class=" mb-3  align-middle">
												<div class="px-4">
													<table class="table-bordered w-100">
														<tr class="bg-light">
															<td>상품금액</td>
															<td class="bg-white">${vo.p_price}</td>
														</tr>
														<tr class="bg-light">
															<td>차감금액<br />(쿠폰/적립금)
															</td>
															<td class="bg-white">${salePrice}</td>
														</tr>
														<tr class="bg-light">
															<td>환불예상금액<br />(배송비 제외)
															</td>
															<td class="bg-white">${vo.p_price - salePrice}</td>
														</tr>
													</table>
												</div>

											</div>
											<!-- 별찍기 -->

										</div>


										<div class="popup-border text-center">
											<c:if test="${pay_method =='vbank' }">
												<div class="p-2 mt-3">
													<h4>
														<b>환불 받으실 계좌를 입력해주세요.</b>
													</h4>
													<div class=" mb-3  align-middle">
														<div class="px-4">
															<table class="table-bordered w-100">
																<tr class="bg-light">
																	<td>은행</td>
																	<td><select class="btn textbox w-100 bg-white"
																		name="refund_bank">
																			<option value="">선택</option>
																			<option value="03">기업은행</option>
																			<option value="04">국민은행</option>
																			<option value="20">우리은행</option>
																			<option value="45">새마을금고</option>
																			<option value="71">우체국</option>
																			<option value="81">하나은행</option>
																			<option value="88">신한은행</option>
																			<option value="89">케이뱅크</option>
																			<option value="90">카카오뱅크</option>
																			<option value="92">토스뱅크</option>
																	</select></td>
																</tr>
																<tr class="bg-light">
																	<td>예금주</td>
																	<td><input type="text" class="textbox w-100"
																		name="refund_holder"></td>
																</tr>
																<tr class="bg-light">
																	<td>계좌번호</td>
																	<td><input type="text" class="textbox w-100"
																		name="refund_account"></td>
																</tr>
															</table>
														</div>

													</div>
													<!-- 별찍기 -->

												</div>
											</c:if>



											<!-- 사진업로드 -->
											<div class="popup-border p-4">
												<div class="mb-3">
													<div class="upload-box">
														<div id="drop-file" class="drag-file">
															<i class="fas fa-camera-retro mr-2"></i>
															<p class="message">사진 첨부하기</p>
														</div>
														<div class="mb-3">
															<input class="d-none" id="cs_img" name="cs_img" multiple
																type="file">
															<div class="mb-3 d-flex flex-wrap" id="imagesPreview"
																style="overflow: auto;"></div>
														</div>
														<div class="previewList"></div>
														<div class="text-left text-danger">
															<i class="fas fa-check"></i>반품 사유를 확인할 수 있는 사진을 등록하시면 보다
															신속하게 반품 처리 진행됩니다.<br /> <i class="fas fa-check"></i>가상계좌로
															결제하신 경우 환불 정보를 꼭 작성해주세요.<br /> <i class="fas fa-check"></i>주
															결제수단(카드,계좌,휴대폰 등)과 할인수단(적립금/쿠폰)을 포함한 환불요청 시, 주 결제수단에서 선
															환불 처리됩니다.<br /> <i class="fas fa-check"></i>부분 반품의 경우 포인트
															혹은 쿠폰 사용으로 할인을 받았다면, 가장 먼저 반품하는 상품에서 차감되어 환불됩니다.<br /> <i
																class="fas fa-check"></i>반품시 사유가 '단순 변심'일 경우 환불 금액에서 각
															상품별 규정에 따라 수거 배송비(3,000원)가 차감됨을 알려드립니다.<br /> <i
																class="fas fa-check"></i>쿠폰과 적립금의 경우 취소일 기준 3일 이내로
															복구됩니다.
														</div>
													</div>
												</div>
												<div class="popup-border p-4">
													<div class="mb-3">
														<button type="button" class="btn-black mr-2"
															onclick="cancel()">취소</button>
														<button type="button" class="btn-black-outline"
															onclick="uploadCancelForm()">등록</button>
													</div>
												</div>

											</div>
										</div>
									</div>
								</div>

							</div>
						</div>

					</div>
					<input type="hidden" name="p_idx" value="${vo.p_idx}"> <input
						type="hidden" name="o_idx" value="${o_idx}"> <input
						type="hidden" name="oi_productCode" value="${oi_productCode}">
					<input type="hidden" name="m_mid" value="${sMid}">
				</div>
			</div>
		</div>
	</form>
</body>


</html>
