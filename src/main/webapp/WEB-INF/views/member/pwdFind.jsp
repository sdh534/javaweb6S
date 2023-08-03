<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<html>
<head>
<title>파라다이스 | 회원가입</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="${ctp}/js/member.js"></script>
<link rel="stylesheet" href="${ctp}/css/spinner.css">
<script>
	'use strict';
	function pwdFind() {
		//여기 정규식 체크 (아이디, 비밀번호)
		if($("#m_mid").val().trim() == ''){
			alert("아이디를 입력해주세요.");
			$("#m_mid").focus();
			return;
		}
		else if($("#m_email").val().trim() == ''){
			alert("이메일을 입력해주세요.");
			$("#m_email").focus();
			return;
		}
		
		console.log($("#m_mid").val());
		let data = {
				m_mid : $("#m_mid").val().trim(),
				m_email : $("#m_email").val().trim()
		}
		$.ajax({
			type : "post",
			url : "${ctp}/member/memberPwdFind",
			data : data,
			success : function(res) {
				if (res == "MIDNO"){
					Swal.fire({
						width:500,
					  position: 'center',
					  icon: 'error',
					  title: '존재하지 않는 아이디입니다.',
					  showConfirmButton: false,
					  timer: 1500
					})
				}
				else if (res == "FAIL"){
					Swal.fire({
						width:500,
					  position: 'center',
					  icon: 'error',
					  title: '임시비밀번호 발급을 실패했습니다.',
					  showConfirmButton: false,
					  timer: 1500
					})
				}
				else if (res == "EMAILNO"){
					Swal.fire({
						width:500,
					  position: 'center',
					  icon: 'error',
					  title: '등록된 회원 이메일을 찾을 수 없습니다.',
					  showConfirmButton: false,
					  timer: 1500
					})
				}
				else {
					Swal.fire({
						width:500,
					  position: 'center',
					  icon: 'success',
					  title: '임시비밀번호가 발급되었습니다.',
					  confirmButtonColor: 'grey',
					  confirmButtonText: '확인',
					}).then((result) => {
					  if (result.isConfirmed) {
									location.href="${ctp}/";
								}
					    });
				}
			},
			error : function() {
				alert("전송 실패!");
			}
		});
		
	}
	$(document).ready(function(){
		$(".loading").hide();
		
		$(document).ajaxStart(function() {
			$(".loading").show();
	    }).ajaxStop(function() {
	 		$(".loading").hide();
	    });
		
	});
		
</script>
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
					<h2 class="gmarketSans">
						비밀번호 <font color="red">찾기</font>
					</h2>
				</div>
				<div class="row clearfix justify-content-center">
					<form name="findIdForm" style="width: 100%">
						<div class="input_field">
							<input type="text" class="form-control" name="m_mid" id="m_mid"
								placeholder="아이디" autofocus>
						</div>
						<div class="input_field">
							<input type="text" class="form-control" name="m_email"
								id="m_email" placeholder="이메일">
						</div>
						<button type="button" id="modal-btn-login"
							class="btn btn-info btn-block btn-round mb-2" onclick="pwdFind()">비밀번호
							찾기</button>
						<span><i class="fas fa-check"></i>&nbsp;등록된 이메일 주소와 아이디로
							임시비밀번호를 발급 받을 수 있습니다. <br /> <i class="fas fa-check"></i>&nbsp;아이디/비번
							찾기가 안될 경우 고객센터로 문의해주세요.</span>
					</form>
					<div class="d-flex flex-column">
						<div class="text-center">
							<span><a href="${ctp}/member/memberNeedLogin"
								style="color: red">로그인</a></span> | <span><a
								href="${ctp}/member/memberIdFind" style="color: red">아이디 찾기</a></span>
						</div>
						<div id="findResult"></div>
					</div>
				</div>
			</div>
		</div>
	</div>


	<div class="loading">
		<!-- SOLAR SYSTEM -->
		<div class="spinner-box">
			<div class="solar-system">
				<div class="earth-orbit orbit">
					<div class="planet earth"></div>
					<div class="venus-orbit orbit">
						<div class="planet venus"></div>
						<div class="mercury-orbit orbit">
							<div class="planet mercury"></div>
							<div class="sun"></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<span class="solar-system-b">이메일 전송중...</span>
	</div>

	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>
