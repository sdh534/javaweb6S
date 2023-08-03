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

<jsp:include page="/resources/js/memberRegCheck.jsp" />
<style>
body {
	padding-right: 0 !important
}
</style>
</head>
<body>
	<jsp:include page="/WEB-INF/views/include/nav.jsp" />
	<div class="container h-100" style="margin-bottom: 200px;">
		<div class="form_wrapper h-100">
			<div class="form_container">
				<div class="title_container">
					<h2>
						PARA<font color="red">DICE</font>
					</h2>
				</div>
				<div class="row clearfix">
					<div class="" style="width: 100%">
						<form name="joinForm" action="${ctp}/member/memberJoin"
							method="post">
							<div class="input_field">
								<span><i aria-hidden="true" class="fa fa-id-card"></i></span> <input
									type="text" name="m_mid" id="m_mid" placeholder="아이디 (필수)"
									required autofocus onkeyup="midCheck()" />
								<div class="form_warn" id="warn_id">4~20자의 영문 소문자, 숫자와
									특수기호(_)만 사용 가능합니다.</div>
							</div>
							<div class="input_field">
								<span><i aria-hidden="true" class="fa fa-at"></i></span> <input
									type="email" name="m_email" id="m_email" placeholder="이메일 (필수)"
									required onkeyup="emailCheck()" />
								<div class="form_warn" id="warn_email">이메일 주소를 다시 확인해주세요.</div>
							</div>
							<div class="input_field">
								<span><i aria-hidden="true" class="fa fa-lock-open"></i></span>
								<input type="password" id="m_password" name="m_password"
									placeholder="비밀번호 (필수)" required onkeyup="pwdCheck()" /> <i
									class="fa fa-eye-slash fa-lg password_see"></i>
								<div class="form_warn" id="warn_pwd1">8~16자 영문 대 소문자, 숫자,
									특수문자를 사용하세요.</div>
							</div>
							<div class="input_field">
								<span><i aria-hidden="true" class="fa fa-lock"></i></span> <input
									type="password" id="m_pwd" name="m_pwd" placeholder="비밀번호 재입력"
									required onkeyup="pwd2Check()" />
								<div class="form_warn" id="warn_pwd2">비밀번호가 일치하지 않습니다.</div>
							</div>
							<div class="input_field">
								<span><i aria-hidden="true" class="fa fa-signature"></i></span>
								<input type="text" name="m_name" id="m_name"
									placeholder="이름 입력 (필수)" onkeyup="nameCheck()" />
								<div class="form_warn" id="warn_name">한글과 영문 대 소문자를 사용하세요.
									(특수기호, 공백 사용 불가)</div>
							</div>
							<div class="input_field">
								<span><i aria-hidden="true" class="fa fa-mobile"></i></span> <input
									type="text" name="m_phone" id="m_phone"
									placeholder="휴대전화번호 입력(필수)" onchange="phoneCheck()" />
								<div class="form_warn" id="warn_phone"></div>
							</div>
							<div class="input_field">
								<span><i aria-hidden="true" class="fa fa-calendar"></i></span> <input
									type="text" name="m_birthday" id="m_birthday"
									placeholder="생년월일 8자리(필수)" onchange="birthDayCheck()" />
								<div class="form_warn" id="warn_birthday">생년월일은 8자리 숫자로
									입력해 주세요.</div>
							</div>
							<div class="input_field" style="height: 35px">
								<div class="col_half">
									<input type="text" name="postcode" id="sample6_postcode"
										placeholder="우편번호">
								</div>
								<div class="col_half">
									<input type="button" onclick="sample6_execDaumPostcode()"
										value="우편번호 찾기" class="btn-secondary"
										style="width: 100%; height: 100%">
								</div>
							</div>

							<div class="input_field">
								<input type="text" name="roadAddress" id="sample6_address"
									size="50" placeholder="주소">
							</div>
							<div class="input_field">
								<input type="text" name="detailAddress"
									id="sample6_detailAddress" placeholder="상세주소">
							</div>
							<div class="input_field">
								<input type="text" name="extraAddress" id="sample6_extraAddress"
									placeholder="참고항목">
							</div>
							<input type="hidden" name="m_address">
							<div class="input_field checkbox_option">
								<input type="checkbox" id="mailOk" name="m_mailOk"> <label
									for="mailOk"><font color="red">(선택)</font> 정보/이벤트 메일
									수신에 동의합니다</label>
							</div>
							<input class="button" type="button" id="submitBtn"
								onclick="regCheck()" value="Register" />
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>
</html>
