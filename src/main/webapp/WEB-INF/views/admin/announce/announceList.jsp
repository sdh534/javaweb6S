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
</head>
<script>
	'use strict';
	
	function popup(ann_idx){
		var width = 550;
		var height = 850;
		
		var left = (window.screen.width / 2) - (width/2);
		var top = (window.screen.height / 4) - (height/4);
		
		var windowStatus = 'width='+width+', height='+height+', left='+left+', top='+top+', scrollbars=yes, status=yes, resizable=yes, titlebar=yes';
			const url = "${ctp}/notice/content?ann_idx="+ann_idx;

		//등록된 url 및 window 속성 기준으로 팝업창을 연다.
		window.open(url, "hello popup", windowStatus);
	}
	
	function deleteNotice(ann_idx){
		Swal.fire({
			  title: '선택하신 공지사항을 삭제하시겠습니까?',
			  showDenyButton: true,
			  confirmButtonText: '확인',
			  denyButtonText: '취소',
			}).then((result) => {
			  if (result.isConfirmed) {
		$.ajax({
			type : "post",
			url : "${ctp}/admin/announceDelete",
			data : {
				ann_idx : ann_idx
			},
			success : function(res) {
				Swal.fire({
    				width:500,
    			  position: 'center',
    			  icon: 'success',
    			  title: '정상적으로 삭제되었습니다.',
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
			})
	}
	
	function search(){
		let searchKeyword = $("#searchKeyword").val();
		let searchCategory = $("#searchCategory").val();
		location.href = '${ctp}/admin/announceList?searchKeyword='+searchKeyword+"&searchCategory="+searchCategory;
	}
</script>
<body>


	<div class="container-xxl position-relative bg-white d-flex p-0">

		<jsp:include page="/WEB-INF/views/admin/adminNav.jsp" />



		<div class="container-fluid pt-4 px-4">
			<div class="row">

				<div class="col-sm-12 col-xl-12">
					<div class="bg-white rounded-lg h-100 p-3">
						<h5 class="mb-2">공지사항 조회/등록</h5>
						<hr>
						<div class=" d-flex align-items-center justify-content-between">
							<form name="noticeSearch">
								<div>
									<select class="textbox border" name="searchCategory"
										id="searchCategory">
										<option value="ann_title">제목</option>
										<option value="ann_context">내용</option>
									</select> <input type="text" class="textbox ml-2" name="searchKeyword"
										id="searchKeyword">
									<button type="button" class="btn-black-outline btn-small ml-2"
										onclick="search()">검색</button>
								</div>
							</form>
							<div>
								<button type="button" class="btn-black ml-2"
									onclick="location.href='${ctp}/admin/announceInsert'">공지
									등록</button>
							</div>
						</div>
						<!-- QnA 목록 -->
						<div class="navbar-nav">
							<nav class="navbar">
								<div class="navbar-nav w-100">
									<div class="row qna-header text-center">
										<div class="col-1">번호</div>
										<div class="col-5">제목</div>
										<div class="col-2">작성일</div>
										<div class="col-2">조회수</div>
										<div class="col-2">상세</div>
									</div>

									<div id="qnaList">
										<c:forEach var="vo" items="${vos}">
											<div class="nav-item dropdown qna">
												<div class="nav-link dropdown-toggle text-left pointer"
													id="nav-qna">
													<div class="row" style="font-size: 12pt;">
														<div class="col-1">${vo.ann_idx}</div>
														<div class="col-5 ellipsis" onclick="popup(${vo.ann_idx})">
															${vo.ann_title}</div>
														<div class="col-2 ellipsis">
															${fn:substring(vo.ann_wDate,0,10)}</div>
														<div class="col-2 text-center">${vo.ann_viewCnt}</div>
														<div class="col-2 text-center">
															<span class="badge badge-secondary"
																onclick="location.href='${ctp}/admin/announceUpdate?ann_idx=${vo.ann_idx}'">수정</span>
															<span class="badge badge-danger"
																onclick="deleteNotice(${vo.ann_idx})">삭제</span>
														</div>
													</div>
												</div>
											</div>
										</c:forEach>
									</div>




								</div>
							</nav>
						</div>


						<!-- 블록 페이징 처리 -->
						<div class="text-center m-4">
							<ul class="pagination justify-content-center pagination-sm">
								<c:if test="${pageVO.pag > 1}">
									<li class="page-item"><a class="page-link text-secondary"
										href="${ctp}/admin/inquiry/QnA?pageSize=${pageVO.pageSize}&pag=1">첫페이지</a></li>
								</c:if>
								<c:if test="${pageVO.curBlock > 0}">
									<li class="page-item"><a class="page-link text-secondary"
										href="${ctp}/admin/inquiry/QnA?pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock-1)*pageVO.blockSize + 1}">이전블록</a></li>
								</c:if>
								<c:forEach var="i"
									begin="${pageVO.curBlock*pageVO.blockSize + 1}"
									end="${pageVO.curBlock*pageVO.blockSize + pageVO.blockSize}"
									varStatus="st">
									<c:if test="${i <= pageVO.totPage && i == pageVO.pag}">
										<li class="page-item active"><a
											class="page-link text-white bg-secondary border-secondary"
											href="javascript:nextPage(${pageVO.pageSize},${i})">${i}</a></li>
									</c:if>
									<c:if test="${i <= pageVO.totPage && i != pageVO.pag}">
										<li class="page-item"><a class="page-link text-secondary"
											href="${ctp}/admin/inquiry/QnA?pageSize=${pageVO.pageSize}&pag=${i}">${i}</a></li>
									</c:if>
								</c:forEach>
								<c:if test="${pageVO.curBlock < pageVO.lastBlock}">
									<li class="page-item"><a class="page-link text-secondary"
										href="${ctp}/admin/inquiry/QnA?pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock+1)*pageVO.blockSize + 1}">다음블록</a></li>
								</c:if>
								<c:if test="${pageVO.pag < pageVO.totPage}">
									<li class="page-item"><a class="page-link text-secondary"
										href="${ctp}/admin/inquiry/QnA?pageSize=${pageVO.pageSize}&pag=${pageVO.totPage}">마지막페이지</a></li>
								</c:if>
							</ul>
						</div>

					</div>
				</div>


			</div>
			<!-- 226라인 row end -->
		</div>
		<!-- 왼쪽 종료 -->


		<!-- 하나로 묶기 위한 row 종료 -->



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
