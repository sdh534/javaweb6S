<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<c:set var="address" value="${fn:split(vo.m_address, '/' )}" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>PARADICE | 마이페이지</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<link rel="stylesheet" href="${ctp}/css/mypage.css">
<script
	src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<!-- Favicon -->
<link rel="icon" href="${ctp}/images/favicon.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script src="${ctp}/js/member.js"></script>
<jsp:include page="/resources/js/memberUpdateRegCheck.jsp" />
<script>
	function regCheck() {

		if (document.getElementById('mailOk').checked)
			updateForm.m_mailOk.value = "OK";
		else
			updateForm.m_mailOk.value = "NO";
		pwdCheck();
		pwd2Check();

		if (!flag_email || !flag_id || !flag_Regpwd || !flag_pwd
				|| !flag_nickName || !flag_birthday || !flag_phone) {
			Swal.fire({
				width : 500,
				position : 'center',
				icon : 'error',
				title : '잘못 입력한 값이 있습니다.\n 다시 확인해주세요.',
				showConfirmButton : false,
				timer : 1000
			});
			if (!flag_email)
				$("#m_email").focus();
			else if (!flag_id)
				$("#m_mid").focus();
			else if (!flag_pwd)
				$("#m_pwd").focus();
			else if (!flag_nickName)
				$("#m_nickName").focus();
			else if (!flag_birthday)
				$("#m_birthday").focus();
			else if (!flag_phone)
				$("#m_phone").focus();
			return;

		} else {
			let postcode = updateForm.postcode.value;
			let roadAddress = updateForm.roadAddress.value;
			let detailAddress = updateForm.detailAddress.value;
			let extraAddress = updateForm.extraAddress.value;
			updateForm.m_address.value = postcode + "/" + roadAddress + "/"
					+ detailAddress + "/" + extraAddress + "/";

			updateForm.submit();
		}
	}
</script>
</head>

<body>

	<jsp:include page="/WEB-INF/views/include/nav.jsp" />
	<div class="container-xl position-relative bg-white d-flex p-0 mypage">

		<jsp:include page="/WEB-INF/views/member/myPage/myPageNav.jsp" />


		<!-- Sales Chart Start -->
		<div class="container-fluid pt-4 px-4">
			<div class="row g-4 justify-content-center">
				<div class="col-sm-12 col-xl-12 ">
					<div class="text-center rounded p-4">
						<div
							class="d-flex align-items-center justify-content-between  mt-2 border-bottom-design">
							<div class="d-flex mb-1">
								<h4 class="mb-0 pretendard mr-2">회원 정보 수정</h4>
							</div>
						</div>
					</div>
				</div>
				<!-- ---------------------------------- -->

				<div class="form_update h-100">
					<div class="form_container">
						<div class="row clearfix">
							<div class="" style="width: 100%">
								<form name="updateForm" action="${ctp}/member/updateInfo"
									method="post">
									<div class="input_field">
										<span>아이디</span> <input type="text" name="m_mid" id="m_mid"
											placeholder="아이디" readonly value="${vo.m_mid}"
											onkeyup="midCheck()" />
										<div class="form_warn" id="warn_id">4~20자의 영문 소문자, 숫자와
											특수기호(_)만 사용 가능합니다.</div>
									</div>
									<div class="input_field">
										<span>이메일</span> <input type="email" name="m_email"
											id="m_email" placeholder="이메일" required value="${vo.m_email}"
											onkeyup="emailCheck()" />
										<div class="form_warn" id="warn_email">이메일 주소를 다시
											확인해주세요.</div>
									</div>
									<div class="input_field">
										<span>비밀번호</span> <input type="password" id="m_password"
											name="m_password" placeholder="새 비밀번호" required
											onkeyup="pwdCheck()" />
										<div class="form_warn" id="warn_pwd1">8~16자 영문 대 소문자,
											숫자, 특수문자를 사용하세요.</div>
									</div>
									<div class="input_field">
										<span>비밀번호 재입력</span> <input type="password" id="m_pwd"
											name="m_pwd" placeholder="새 비밀번호 재입력" required
											onkeyup="pwd2Check()" />
										<div class="form_warn" id="warn_pwd2">비밀번호가 일치하지 않습니다.</div>
									</div>
									<div class="input_field">
										<span>이름</span> <input type="text" name="m_name" id="m_name"
											placeholder="이름 입력" readonly value="${vo.m_name}"
											onkeyup="nameCheck()" />
										<div class="form_warn" id="warn_name">한글과 영문 대 소문자를
											사용하세요. (특수기호, 공백 사용 불가)</div>
									</div>
									<div class="input_field">
										<span>휴대전화번호</span> <input type="text" name="m_phone"
											id="m_phone" placeholder="휴대전화번호 입력" value="${vo.m_phone}"
											onchange="phoneCheck()" />
										<div class="form_warn" id="warn_phone"></div>
									</div>
									<div class="input_field">
										<span>생년월일</span> <input type="text" name="m_birthday"
											id="m_birthday" placeholder="생년월일 8자리"
											value="${fn:substring(vo.m_birthday,0,10)}"
											onchange="birthDayCheck()" />
										<div class="form_warn" id="warn_birthday">생년월일은 8자리 숫자로
											입력해 주세요.</div>
									</div>
									<div class="input_field" style="height: 35px">
										<div class="col_half">
											<input type="text" name="postcode" id="sample6_postcode"
												placeholder="우편번호" value="${address[0]}">
										</div>
										<div class="col_half">
											<input type="button" onclick="sample6_execDaumPostcode()"
												value="우편번호 찾기" class="btn-secondary"
												style="width: 100%; height: 100%">
										</div>
									</div>

									<div class="input_field">
										<input type="text" name="roadAddress" id="sample6_address"
											size="50" placeholder="주소" value="${address[1]}">
									</div>
									<div class="input_field">
										<input type="text" name="detailAddress"
											id="sample6_detailAddress" placeholder="상세주소"
											value="${address[3]}">
									</div>
									<div class="input_field">
										<input type="text" name="extraAddress"
											id="sample6_extraAddress" placeholder="참고항목"
											value="${address[2]}">
									</div>

									<div
										class="custom-control custom-checkbox d-flex align-items-center mr-3">
										<input type="checkbox" class="custom-control-input"
											name="mailOk" id="mailOk"
											<c:if test="${vo.m_mailOk =='OK'}">checked</c:if> /> <label
											class="custom-control-label black delete-text" for="mailOk"><font
											color="red">(선택)</font> 정보/이벤트 메일 수신에 동의합니다</label>
									</div>
									<input type="hidden" name="m_address"> <input
										type="hidden" name="m_mailOk"> <input type="button"
										class="btn btn-black w-100 mt-5" onclick="regCheck()"
										value="회원정보 수정" />
								</form>
							</div>
						</div>
					</div>
				</div>

			</div>
		</div>
		<!-- Content End -->


		<!-- Back to Top -->
		<a href="#" class="btn btn-lg btn-danger btn-lg-square back-to-top"><i
			class="bi bi-arrow-up"></i></a>
	</div>
	</div>

	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>

</html>