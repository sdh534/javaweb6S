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
<script>
		'use strict'
		$(document).ready(function(){
			//최근 주문내역 
			//--------------------------------------------------------------
			
	    
			//조회기간 설정
		});
		

		function deleteQnA(qna_idx){
			Swal.fire({
				  title: '해당 Q&A를 삭제하시겠습니까?',
				  showDenyButton: true,
				  confirmButtonColor: 'grey',
				  confirmButtonText: '확인',
				  denyButtonText: '취소',
				}).then((result) => {
				  if (result.isConfirmed) {
				    $.ajax({
				    	type: "post",
				    	data: {qna_idx : qna_idx},
							url: "${ctp}/member/QnADelete",
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
</head>

<body>

	<jsp:include page="/WEB-INF/views/include/nav.jsp" />
	<div class="container-xl position-relative bg-white d-flex p-0 mypage">

		<jsp:include page="/WEB-INF/views/member/myPage/myPageNav.jsp" />


		<div class="container-fluid pt-4 px-4">
			<div class="row">
				<div class="col-sm-12 col-xl-12">
					<div class="text-center rounded  px-4 pt-4">
						<div
							class="d-flex align-items-center justify-content-between mb-4 mt-2 border-bottom-design">
							<div class="d-flex mb-1">
								<h4 class="mb-0 pretendard mr-2">1:1 문의</h4>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 226라인 col-sm-12 col-xl-12 end -->

			<div class="col-sm-12 col-xl-12">
				<div
					class="bg-white h-100 p-3 mb-1 <c:if test="${vo.inq_answerOK == 'NO'}">border-bottom-design</c:if>">
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
								<c:if test="${sMid == vo.m_mid }">
									<li><button class="moreBtn  font-14"
											onclick="reviewUpdate()">
											<i class="fas fa-pen fa-2xs"></i>&nbsp;수정
										</button></li>
									<li><button class="moreBtn  font-14"
											onclick="reviewDelete()">
											<i class="fas fa-trash-alt fa-2xs"></i> &nbsp; 삭제
										</button></li>
								</c:if>
								<c:if test="${sMid != vo.m_mid }">
									<li><button class="moreBtn  font-14" onclick="">
											<i class="fas fa-ban fa-2xs"></i> &nbsp; 신고
										</button></li>
								</c:if>
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
			<c:if test="${vo.inq_answerOK == 'OK'}">
				<div class="col-sm-12 col-xl-12">
					<div class="bg-white h-100 p-3 border-bottom-design">
						<div class="border-line mb-2"></div>
						<div
							class="d-flex align-items-center justify-content-between mb-4 mt-2">
							<div class="d-flex mb-1">
								<h4 class="mb-0 pretendard mr-2">
									<span
										class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger text-white">
										답변완료 <span class="font-12 text-dark">|
											${fn:substring(vo.inq_answerDate,0,16)}</span>
									</span>
								</h4>

							</div>
						</div>
						<!-- 내용 -->
						<div class="font-12 p-3 mb-5">${vo.inq_answerContext}</div>
					</div>
				</div>
				<!-- 226라인 row end -->
			</c:if>
			<!--  [0]은 다음글, [1]은 이전글이 된다  -->
			<div class="font-12 p-4">
				<c:if test="${!empty pnVos[1]}">
					<div class="row  align-items-center">
						<span class="mr-5"> <i class="fas fa-chevron-up"></i><b>이전글</b>
						</span> <a href="${ctp}/member/myInquiry?inq_idx=${pnVos[1].inq_idx}">${pnVos[1].inq_title}</a>
					</div>
				</c:if>
				<c:if test="${vo.inq_idx > pnVos[0].inq_idx}">
					<div class="row align-items-center">
						<span class="mr-5"> <i class="fas fa-chevron-down"></i><b>다음글</b>
						</span> <a href="${ctp}/member/myInquiry?inq_idx=${pnVos[0].inq_idx}">${pnVos[0].inq_title}</a>
					</div>
				</c:if>
				<c:if test="${vo.inq_idx < pnVos[0].inq_idx}">
					<div class="row  align-items-center">
						<span class="mr-5"> <i class="fas fa-chevron-up"></i><b>이전글</b>
						</span> <a href="${ctp}/member/myInquiry?inq_idx=${pnVos[0].inq_idx}">${pnVos[0].inq_title}</a>
					</div>
				</c:if>
			</div>
		</div>




		<!-- Back to Top -->
		<a href="#" class="btn btn-lg btn-danger btn-lg-square back-to-top"><i
			class="bi bi-arrow-up"></i></a>
	</div>

	</div>
	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>

</html>