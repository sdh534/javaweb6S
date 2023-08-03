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

						<div
							class="textHeader d-flex align-items-center justify-content-between">
							<span>${vo.ann_title}</span>
						</div>
						<div class="d-flex justify-content-end mt-1">
							<span class="font-12"> ${fn:substring(vo.ann_wDate,0,16)}</span>
						</div>

						<!-- 내용 -->
						<div class="font-12 p-3 border-bottom">${vo.ann_context }</div>
					</div>
				</div>
				<!-- 226라인 row end -->

				<div class="font-12 p-4">
					<c:if test="${!empty pnVos[1]}">
						<div class="row  align-items-center">
							<span class="mr-5"> <i class="fas fa-chevron-up"></i><b>이전글</b>
							</span> <a href="${ctp}/notice/content?ann_idx=${pnVos[1].ann_idx}">${pnVos[1].ann_title}</a>
						</div>
					</c:if>
					<c:if test="${vo.ann_idx > pnVos[0].ann_idx}">
						<div class="row align-items-center">
							<span class="mr-5"> <i class="fas fa-chevron-down"></i><b>다음글</b>
							</span> <a href="${ctp}/notice/content?ann_idx=${pnVos[0].ann_idx}">${pnVos[0].ann_title}</a>
						</div>
					</c:if>
					<c:if test="${vo.ann_idx < pnVos[0].ann_idx}">
						<div class="row  align-items-center">
							<span class="mr-5"> <i class="fas fa-chevron-up"></i><b>이전글</b>
							</span> <a href="${ctp}/notice/content?ann_idx=${pnVos[0].ann_idx}">${pnVos[0].ann_title}</a>
						</div>
					</c:if>
				</div>

			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>

</html>