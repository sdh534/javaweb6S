<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<html>
<head>
<title>파라다이스 | 로그인</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="${ctp}/js/member.js"></script>
<script>
	'use strict';
	function login_off() {
		$('#loginModal').modal('hide');
	}
	function press2(e) {
		if (e.keyCode == 13) { //javascript에서는 13이 enter키를 의미함
			loginCheck2(); //formname에 사용자가 지정한 form의 name입력
		}
	}
	function loginCheck2() {
		//여기 정규식 체크 (아이디, 비밀번호)
		console.log($("#mid2").val());
		let data = {
			mid : $("#mid2").val().trim(),
			pwd : $("#pwd2").val().trim(),
			autoLogin : document.getElementById('autoLogin2').checked
		}
		$.ajax({
			type : "post",
			url : "${ctp}/member/memberLogin",
			data : data,
			success : function(res) {
				if (res == "NoID")
					alert("아이디 정보가 존재하지 않습니다.");
				else if (res == "NoPwd") {
					Swal.fire({
						width : 500,
						position : 'center',
						icon : 'error',
						title : '비밀번호가 옳지 않습니다.',
						showConfirmButton : false,
						timer : 1500
					})
				} else {
					Swal.fire({
						width : 500,
						position : 'center',
						icon : 'success',
						title : '로그인 성공!',
						showConfirmButton : false,
						timer : 1500
					})
					setTimeout(function() {
						location.href = '${ctp}/';
					}, 1500);
					$('#loginModal').modal('hide');
				}
			},
			error : function() {
				alert("전송 실패!");
			}
		});
	}
</script>
<jsp:include page="/resources/js/memberRegCheck.jsp" />
<style>
body {
	padding-right: 0 !important
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/nav.jsp" />
	<div class="container h-50">
		<div class="form_wrapper">
			<div class="form_container">
				<div class="title_container">
					<h2>
						PARA<font color="red">DICE</font>
					</h2>
				</div>
				<div class="row clearfix justify-content-center">
					<form name="loginForm" style="width: 100%">
						<div class="input_field">
							<input type="text" class="form-control" name="mid" id="mid2"
								placeholder="아이디" autofocus onkeypress="press2(event)"
								value="${cMid}">
						</div>
						<div class="input_field">
							<input type="password" class="form-control" name="pwd" id="pwd2"
								placeholder="비밀번호" onkeypress="press2(event)">
						</div>
						<button type="button" id="modal-btn-login"
							class="btn btn-info btn-block btn-round mb-2"
							onclick="loginCheck2()">Login</button>

						<div class="custom-control custom-checkbox text-left"
							style="display: flex; justify-content: space-between;">
							<input class="custom-control-input" type="checkbox"
								name="autoLogin2" id="autoLogin2"
								<c:if test="${cMid != null}">checked</c:if>> <label
								class="custom-control-label red" for="autoLogin2">자동로그인</label>
							<div class="text-right">
								<span><a href="#">아이디 찾기</a></span> | <span><a href="#">비밀번호
										찾기</a></span>
							</div>
						</div>
					</form>

				</div>
			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>
