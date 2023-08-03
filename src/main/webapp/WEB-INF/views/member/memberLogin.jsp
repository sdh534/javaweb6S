<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" href="${ctp}/css/member.css">
<style>
</style>
<script>
	'use strict';
	function login_off() {
		$('#loginModal').modal('hide');
	}
	function press(e) {
		if (e.keyCode == 13) { //javascript에서는 13이 enter키를 의미함
			loginCheck(); //formname에 사용자가 지정한 form의 name입력
		}
	}
	function loginCheck() {
		//여기 정규식 체크 (아이디, 비밀번호)

		let data = {
			mid : $("#mid").val().trim(),
			pwd : $("#pwd").val().trim(),
			autoLogin : document.getElementById('autoLogin').checked
		}
		$.ajax({
			type : "post",
			url : "${ctp}/member/memberLogin",
			data : data,
			success : function(res) {
				if (res == "NoID") {
					Swal.fire({
						width : 500,
						position : 'center',
						icon : 'error',
						title : '존재하지 않는 아이디입니다.',
						showConfirmButton : false,
						timer : 1500
					})
				} else if (res == "NoPwd") {
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
						location.reload();
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

<div class="modal fade" id="loginModal" tabindex="-1" aria-hidden="true">
	<div class="modal-dialog modal-dialog-centered" role="document">
		<div class="modal-content">
			<div class="modal-header border-bottom-0">
				<button type="button" class="close" data-dismiss="modal"
					aria-label="Close">
					<span aria-hidden="true">×</span>
				</button>
			</div>
			<div class="modal-body">
				<div class="form-title text-center">
					<h4 style="font-weight: 1000;">
						PARA<font color="red">DICE</font>
					</h4>
				</div>
				<div class="d-flex flex-column text-center">
					<form name="login-form">
						<div class="form-group">
							<input type="text" class="form-control" name="mid" id="mid"
								placeholder="아이디" autofocus onkeypress="press(event)"
								value="${cMid}">

						</div>
						<div class="form-group">
							<input type="password" class="form-control" name="pwd" id="pwd"
								placeholder="비밀번호" onkeypress="press(event)">
						</div>
						<button type="button" id="modal-btn-login"
							class="btn btn-info btn-block btn-round mb-2"
							onclick="loginCheck()">Login</button>

						<div class="custom-control custom-checkbox text-left"
							style="display: flex; justify-content: space-between;">
							<input class="custom-control-input" type="checkbox"
								name="autoLogin" id="autoLogin"
								<c:if test="${cMid != null}">checked</c:if>> <label
								class="custom-control-label red" for="autoLogin">아이디저장</label>

							<div class="text-right">
								<span><a href="${ctp}/member/memberIdFind">아이디 찾기</a></span>
								&nbsp;| &nbsp; <span><a
									href="${ctp}/member/memberPwdFind">비밀번호 찾기</a></span>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</div>