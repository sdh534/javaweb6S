<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<html>
<head>
<title>파라다이스 | 회원가입</title>
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script src="${ctp}/js/member.js"></script>
<script>
	'use strict';
	function idFind() {
		//여기 정규식 체크 (아이디, 비밀번호)
		if ($("#name").val().trim() == '') {
			alert("이름을 입력해주세요.");
			$("#name").focus();
			return;
		} else if ($("#email").val().trim() == '') {
			alert("이메일을 입력해주세요.");
			$("#email").focus();
			return;
		}

		console.log($("#name").val());
		let data = {
			name : $("#name").val().trim(),
			email : $("#email").val().trim()
		}
		$.ajax({
			type : "post",
			url : "${ctp}/member/memberIdFind",
			data : data,
			success : function(res) {
				if (res == "NO")
					$("#findResult").html("회원 정보를 찾을 수 없습니다.");
				else {
					$("#findResult").html(
							"고객님의 정보와 일치하는 아이디는 <font color='red'>" + res
									+ "</font> 입니다.");
				}
			},
			error : function() {
				alert("전송 실패!");
			}
		});
	}
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
						아이디 <font color="red">찾기</font>
					</h2>
				</div>
				<div class="row clearfix justify-content-center">
					<form name="findIdForm" style="width: 100%">
						<div class="input_field">
							<input type="text" class="form-control" name="name" id="name"
								placeholder="이름" autofocus>
						</div>
						<div class="input_field">
							<input type="text" class="form-control" name="email" id="email"
								placeholder="이메일">
						</div>
						<button type="button" id="modal-btn-login"
							class="btn btn-info btn-block btn-round mb-2" onclick="idFind()">아이디
							찾기</button>
						<span><i class="fas fa-check"></i>&nbsp;등록된 이메일 주소로 아이디를 찾을
							수 있습니다. <br /> <i class="fas fa-check"></i>&nbsp;아이디 비번 찾기가 안될 경우
							고객센터로 문의해주세요.</span>
					</form>
					<div class="d-flex flex-column">
						<div class="text-center" style="color: red">
							<span><a href="${ctp}/member/memberNeedLogin">로그인</a></span> | <span><a
								href="${ctp}/member/memberPwdFind">비밀번호 찾기</a></span>
						</div>
						<div id="findResult"></div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>
