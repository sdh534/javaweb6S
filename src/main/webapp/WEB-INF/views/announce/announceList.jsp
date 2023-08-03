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
<title>PARADICE | 공지사항</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<link rel="stylesheet" href="${ctp}/css/admin.css">
<!-- Favicon -->
<link rel="icon" href="${ctp}/images/favicon.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script>
	'use strict'

	function search() {
		let searchKeyword = $("#searchKeyword").val();
		let searchCategory = $("#searchCategory").val();
		location.href = '${ctp}/notice?searchKeyword=' + searchKeyword
				+ "&searchCategory=" + searchCategory;
	}
</script>
</head>

<body>

	<jsp:include page="/WEB-INF/views/include/nav.jsp" />
	<div class="container-xl position-relative bg-white d-flex p-0 mypage">


		<div class="container-fluid pt-4 px-4 mb-5">
			<div class="container">
				<div class="col-sm-12 col-xl-12">
					<div class="bg-white rounded-lg h-100 p-3">
						<h1 class="mb-2">공지사항</h1>
						<!-- QnA 목록 -->
						<div class="navbar-nav">
							<nav class="navbar">
								<div class="navbar-nav w-100">
									<div class="row qna-header text-center">
										<div class="col-1">번호</div>
										<div class="col-7">제목</div>
										<div class="col-2">작성일</div>
										<div class="col-2">조회수</div>
									</div>

									<div id="qnaList">
										<c:forEach var="vo" items="${vos}">
											<div class="nav-item dropdown qna">
												<div class="nav-link dropdown-toggle text-left pointer"
													id="nav-qna"
													onclick="location.href='${ctp}/notice/content?ann_idx=${vo.ann_idx}';">
													<div class="row" style="font-size: 12pt;">
														<div class="col-1 text-center">${vo.ann_idx}</div>
														<div class="col-7 ellipsis">${vo.ann_title}</div>
														<div class="col-2 text-center ellipsis">
															${fn:substring(vo.ann_wDate,0,10)}</div>
														<div class="col-2 text-center">${vo.ann_viewCnt}</div>
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
						<div class="d-flex justify-content-center">
							<select class="textbox border" name="searchCategory"
								id="searchCategory">
								<option value="ann_title">제목</option>
								<option value="ann_context">내용</option>
							</select> <input type="text" class="textbox ml-2">
							<button type="button" class="btn-black btn-small ml-2"
								onclick="search()">검색</button>
						</div>
					</div>
				</div>
			</div>
		</div>

	</div>


	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>

</html>