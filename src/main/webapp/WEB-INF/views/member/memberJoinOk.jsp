<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<html>
<head>
<title>파라다이스 | 회원가입 완료</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="${ctp}/js/member.js"></script>
<style>
body {
	padding-right: 0 !important;
	font-family: "GmarketSansMedium";
}

.joinOkBtn1, .joinOkBtn2 {
	width: 100%;
	background-color: #fff;
	border: 1px solid #ccc;
	height: 50px;
}

.joinOkBtn2 {
	background-color: grey;
	color: white;
	margin-left: 10px;
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/nav.jsp" />
	<div class="form_wrapper">
		<div class="form_container">
			<div class="title_container">
				<h2>
					PARA<font color="red">DICE</font>
				</h2>
			</div>
			<div class="row clearfix">
				<div class="text-center mt-4" style="width: 100%">
					<i class="fas fa-dice fa-7x" style="color: #fe0606;"></i>
					<div class="mt-4">
						<h2>환영합니다!</h2>
					</div>
					<p>
						<b>${name}</b>님의 회원가입이 완료되었습니다. <br /> 로그인 하시고 <font color="red">파라다이스</font>의
						모든 서비스를 이용해보세요!
					</p>
				</div>
				<div class="input_field" style="height: 35px; width: 100%;">
					<div class="col_half">
						<input class="button joinOkBtn1" type="button"
							onclick="location.href='${ctp}/';" value="홈으로" />
					</div>
					<div class="col_half">
						<input class="button joinOkBtn2" type="button" data-toggle="modal"
							data-target="#loginModal" value="로그인" />
					</div>
				</div>
			</div>
		</div>
	</div>


</body>
</html>
