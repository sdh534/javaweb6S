<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>

 <script>
	'use strict';
	//정규식 체크
	let regPwd = /(?=.*[0-9a-zA-Z!@#$%^&*_]).{8,16}$/; // 8~16자 영문 대 소문자, 숫자, 특수문자를 사용하세요.
	let regEmail =/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
	let regBirth1 =/^(19[0-9][0-9]|20\d{2})(0[0-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])$/;
	let regBirth2 =/^(19[0-9][0-9]|20\d{2})-(0[0-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/
	let regPhone1 =/^\d{3}-\d{4}-\d{4}$/;
	let regPhone2 =/^\d{3}\d{4}\d{4}$/;

	
	let flag_nickName = true;
	let flag_id = true;
	let flag_name = true;
	let flag_Regpwd = false;
	let flag_pwd = false;
	let flag_email = true;
	let flag_phone = true;
	let flag_birthday = true;
	//아이디 체크


		function pwdCheck() {
			//비밀번호 정규식 확인
			let pwd1 = updateForm.m_password.value.trim();
			$("#m_password").on("change keyup paste", function() {
				if (regPwd.test(pwd1)) {
					warn_pwd1.style.display = "none";
					$("#m_password").css("border", "1px solid #ccc");
					flag_Regpwd = true;
				} else {
					warn_pwd1.style.display = "block";
					$("#m_password").css("border", "1px solid red");
					$("#warn_pwd1").text("8~16자 영문 대 소문자, 숫자, 특수문자를 사용하세요.");
				}
			});
			if (pwd1 == ""){
				warn_pwd1.style.display = "none";
				flag_Regpwd = true;
			}
		}
		function pwd2Check() {
			let pwd1 = updateForm.m_password.value.trim();
			let pwd2 = updateForm.m_pwd.value.trim();
			if(pwd1 == "" && pwd2=="") {
				flag_pwd = true;
				warn_pwd1.style.display = "none";
				warn_pwd2.style.display = "none";
				return;
			}
			
			$("#m_password").on("change keyup paste", function() {
				if(pwd1 != pwd2) {
					warn_pwd2.style.display = "block";
					flag_pwd = false;
					$("#m_pwd").css("border", "1px solid red");
					$("#warn_pwd2").text("비밀번호가 일치하지 않습니다.");	
				}
			});
			$("#m_pwd").on("change keyup paste", function() {
				if (pwd2 == pwd1) {
					warn_pwd2.style.display = "none";
					$("#m_pwd").css("border", "1px solid #ccc");
					flag_pwd = true;
				} else {
					warn_pwd2.style.display = "block";
					flag_pwd = false;
					$("#m_pwd").css("border", "1px solid red");
					$("#warn_pwd2").text("비밀번호가 일치하지 않습니다.");
				}
			});
			if(pwd1 != pwd2) flag_pwd = false;
		}

		function emailCheck() {
			let email = updateForm.m_email.value.trim();
			$("#m_email").on("change keyup paste", function() {
				if (regEmail.test(email)) {
					warn_email.style.display = "none";
					flag_email = true;
					$("#m_email").css("border", "1px solid #ccc");
				} else {
					warn_email.style.display = "block";
					flag_email = false;
					$("#warn_email").text("이메일 주소를 다시 확인해주세요.");
					if (email == "")
						$("#warn_email").text("필수 정보입니다.");
					$("#m_email").css("border", "1px solid red");
				}
			});
		}

		function birthDayCheck() {
			let birthday = updateForm.m_birthday.value.trim();
			if (regBirth2.test(birthday)) {
				warn_birthday.style.display = "none";
				flag_birthday = true;
				$("#m_birthday").css("border", "1px solid #ccc");
			} else if (regBirth1.test(birthday)) {
				birthday = birthday.slice(0, 4) + '-' + birthday.slice(4, 6)
						+ '-' + birthday.slice(6, 8);
				$("#m_birthday").val(birthday);
				warn_birthday.style.display = "none";
				flag_birthday = true;
				$("#m_birthday").css("border", "1px solid #ccc");
			} else {
				warn_birthday.style.display = "block";
				flag_birthday = false;
				$("#warn_birthday").text("생년월일은 8자리 숫자로 입력해 주세요.");
				if (birthday == "")
					$("#warn_birthday").text("필수 정보입니다.");
				$("#m_birthday").css("border", "1px solid red");
			}
		}

		function phoneCheck() {
			let phone = updateForm.m_phone.value.trim();
			if (regPhone1.test(phone)) {
				warn_phone.style.display = "none";
				flag_phone = true;
				$("#m_phone").css("border", "1px solid #ccc");
			} else if (regPhone2.test(phone)) {
				phone = phone.slice(0, 3) + '-' + phone.slice(3, 7) + '-'
						+ phone.slice(7, 11);
				$("#m_phone").val(phone);
				warn_phone.style.display = "none";
				flag_phone = true;
				$("#m_phone").css("border", "1px solid #ccc");
			} else {
				warn_phone.style.display = "block";
				flag_phone = false;
				$("#warn_phone").text("형식에 맞지 않는 번호입니다.");
				if (phone == "")
					$("#warn_phone").text("필수 정보입니다.");
				$("#m_phone").css("border", "1px solid red");
			}
		}

	</script>