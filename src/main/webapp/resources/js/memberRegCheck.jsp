<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/>

 <script>
	'use strict';
	//정규식 체크
	let regMid = /^[a-zA-Z0-9_]{4,20}$/; //아이디는 영대소문자와 숫자, 언더바만 허용 (4-12자)
	let regPwd = /(?=.*[0-9a-zA-Z!@#$%^&*_]).{8,16}$/; // 8~16자 영문 대 소문자, 숫자, 특수문자를 사용하세요.
	let regName = /^[가-힣a-zA-Z]{2,12}$/;
	let regEmail =/^([\w-]+(?:\.[\w-]+)*)@((?:[\w-]+\.)*\w[\w-]{0,66})\.([a-z]{2,6}(?:\.[a-z]{2})?)$/;
	let regBirth1 =/^(19[0-9][0-9]|20\d{2})(0[0-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])$/;
	let regBirth2 =/^(19[0-9][0-9]|20\d{2})-(0[0-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/
	let regPhone1 =/^\d{3}-\d{4}-\d{4}$/;
	let regPhone2 =/^\d{3}\d{4}\d{4}$/;

	
	let flag_nickName = true;
	let flag_id = false;
	let flag_name = false;
	let flag_pwd = false;
	let flag_email = false;
	let flag_phone = false;
	let flag_birthday = false;
	let flag_checkAllTerm = true;
	//아이디 체크

		function midCheck() {
			let mid = joinForm.m_mid.value.trim();
			if (regMid.test(mid)) {
				// 중복되는 아이디가 있는지 실시간 검사
				let warn_id = document.getElementById("warn_id"); // warn_id 요소 가져오기
				warn_id.style.display = "none";

				$.ajax({
					type : "post",
					url : "${ctp}/member/memberIdCheck",
					data : {
						mid : mid
					},
					success : function(res) {
						if (res == "Y") { // 중복검사 통과
							warn_id.style.display = "none";
							$("#m_mid").css("border", "1px solid #ccc");
							flag_id = true;
						} else { // 중복검사 통과 실패
							$("#warn_id").text("중복된 아이디입니다.");
							warn_id.style.display = "block";
							$("#m_mid").css("border", "1px solid red");
							flag_id = false;
						}
					},
					error : function() {
						alert("전송 실패!");
					}
				});
			} else {
				let warn_id = document.getElementById("warn_id"); // warn_id 요소 가져오기
				if (mid == "") {
					$("#warn_id").text("필수 정보 입니다.");
				} else {
					$("#warn_id").text("4~20자의 영문 소문자, 숫자와 특수기호(_)만 사용 가능합니다.");
				}
				warn_id.style.display = "block";
				$("#m_mid").css("border", "1px solid red");
				flag_id = false;
			}
		}
		// joinForm의 m_mid 요소의 onchange 이벤트에 midCheck 함수 등록
		joinForm.m_mid.onchange = midCheck;

		function pwdCheck() {
			//비밀번호 정규식 확인
			$("#m_password").on("change keyup paste", function() {
				let pwd1 = joinForm.m_password.value.trim();
				if (regPwd.test(pwd1)) {
					warn_pwd1.style.display = "none";
					$("#m_password").css("border", "1px solid #ccc");
				} else {
					warn_pwd1.style.display = "block";
					$("#m_password").css("border", "1px solid red");
					$("#warn_pwd1").text("8~16자 영문 대 소문자, 숫자, 특수문자를 사용하세요.");
					if (pwd1 == "")
						$("#warn_pwd1").text("필수 정보입니다.");
					return false;
				}
			});
		}
		function pwd2Check() {
			let pwd1 = joinForm.m_password.value.trim();
			let pwd2 = joinForm.m_pwd.value.trim();
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
					return false;
				}
			});
			if(pwd1 != pwd2) flag_pwd = false;
		}

		function emailCheck() {
			let email = joinForm.m_email.value.trim();
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
					return false;
				}
			});
		}
		function nameCheck() {
			let name = joinForm.m_name.value.trim();
			if (regName.test(name)) {
				warn_name.style.display = "none";
				flag_name = true;
				$("#m_name").css("border", "1px solid #ccc");
			} else {
				warn_name.style.display = "block";
				flag_name = false;
				$("#warn_name").text("한글과 영문 대 소문자를 사용하세요. (특수기호, 공백 사용 불가)");
				if (name == "")
					$("#warn_name").text("필수 정보입니다.");
				$("#m_name").css("border", "1px solid red");
				return false;
			}
		}

		function birthDayCheck() {
			let birthday = joinForm.m_birthday.value.trim();
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
				return false;
			}
		}

		function phoneCheck() {
			let phone = joinForm.m_phone.value.trim();
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
				return false;
			}
		}

		function regCheck() {

			if (document.getElementById('mailOk').checked)
				joinForm.m_mailOk.value = "OK";
			else
				joinForm.m_mailOk.value = "NO";

			if (!flag_email || !flag_id || !flag_pwd || !flag_nickName
					|| !flag_birthday || !flag_phone || !flag_checkAllTerm) {
				console.log(flag_email);
				console.log(flag_id);
				console.log(flag_pwd);
				console.log(flag_nickName);
				console.log(flag_birthday);
				console.log(flag_phone);
				console.log(flag_checkAllTerm);
				Swal.fire({
					width : 500,
					position : 'center',
					icon : 'error',
					title : '잘못 입력한 값이 있습니다.\n 다시 확인해주세요.',
					showConfirmButton : false,
					timer : 1000
				});
				return;
			} else {
				let postcode = joinForm.postcode.value + " ";
				let roadAddress = joinForm.roadAddress.value + " ";
				let detailAddress = joinForm.detailAddress.value + " ";
				let extraAddress = joinForm.extraAddress.value + " ";
				joinForm.m_address.value = postcode + "/" + roadAddress + "/"
						+ detailAddress + "/" + extraAddress + "/";

				joinForm.submit();
			}
		}
	</script>