<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>PARADICE | 회원탈퇴 안내</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<!-- Favicon -->
<link rel="icon" href="${ctp}/images/favicon.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script>
	'use strict'

	function userDelete() {
		let check = document.getElementById("deleteOK");
		if (!check.checked) {
			alert("탈퇴 안내를 확인하고 동의해 주세요.");
			return;
		}

		$.ajax({
			type : "post",
			url : "${ctp}/member/memberDelete",
			data : data,
			success : function(res) {
				if (res == "1") {
					Swal.fire({
						width : 500,
						position : 'center',
						icon : 'success',
						title : '정상적으로 탈퇴처리 되었습니다.',
						showConfirmButton : false,
						timer : 1500
					})
				}
				setTimeout(function() {
					location.href = '${ctp}/';
				}, 1500);
			},
			error : function() {
				alert("전송 실패!");
			}
		});
	}
</script>
</head>

<body>

	<jsp:include page="/WEB-INF/views/include/nav.jsp" />
	<div class="container-xl position-relative bg-white d-flex p-0 mypage">

		<jsp:include page="/WEB-INF/views/member/myPage/myPageNav.jsp" />


		<!-- Sales Chart Start -->
		<div class="container-fluid pt-4 px-4">
			<div class="row g-4">
				<div class="col-sm-12 col-xl-12">
					<div class="text-center rounded p-4">
						<div
							class="d-flex align-items-center justify-content-between mb-4 mt-2 border-bottom-design">
							<div class="d-flex mb-1">
								<h4 class="mb-0 pretendard mr-2">탈퇴 안내</h4>
							</div>
							<span class="extraText">회원탈퇴를 신청하기 전에 안내 사항을 꼭 확인해주세요.</span>
						</div>
						<div class="text-left delete-text mb-5">
							<span><i class="fas fa-check"></i><b>&nbsp;사용하고 계신
									아이디(<font color="red">${sMid}</font>)는 탈퇴하실 경우 재사용 및 복구가
									불가능합니다.
							</b></span> <br /> <span><font color="red">탈퇴한 아이디는 본인과 타인 모두
									재사용 및 복구가 불가</font>하오니 신중하게 선택하시기 바랍니다.</span>
						</div>
						<div class="text-left delete-text mb-5">
							<span><i class="fas fa-check"></i><b>&nbsp;탈퇴 후에도 주문한
									내역, 작성한 리뷰는 그대로 남아 있습니다.</b></span> <br /> <span> 단, 주문 시 이용한 배송
								내역이나 개인 정보는 전부 삭제됩니다. 리뷰 삭제, 혹은 상품 문의 내역 비공개 처리를 원하신다면 <font
								color="red">반드시 탈퇴 전 비공개 처리하거나 삭제하시기 바랍니다.</font>
							</span>
						</div>
						<div class="text-left delete-text mb-5">
							<span><i class="fas fa-check"></i><b>&nbsp;탈퇴하실 경우
									구매내역 확인은 물론 로그인 후 가능한 모든 기능은 사용하실 수 없습니다.</b></span> <br /> <span>
								탈퇴하신 후에 회원 정보의 복구는 불가능하며,<font color="red"> 보유하신 쿠폰이나
									적립금도 모두 무효화됩니다.</font>
							</span>
						</div>
						<div class="text-left delete-text mb-5">
							<span> <font color="red"><i class="fas fa-check"></i>&nbsp;
									탈퇴 후에는 아이디 ${sMid} 로 다시 가입할 수 없으며 아이디와 데이터는 복구할 수 없습니다.<br />
									작성한 리뷰는 탈퇴 후 삭제할 수 없습니다.</font>
							</span>
						</div>
						<div class="text-center mb-5">
							<div
								class="custom-control custom-checkbox d-flex align-items-center mr-3">
								<input type="checkbox" class="custom-control-input"
									name="deleteOK" id="deleteOK" value="OK" /> <label
									class="custom-control-label black delete-text" for="deleteOK">안내
									사항을 모두 확인하였으며, 이에 동의합니다.</label>
							</div>
						</div>

						<div class="text-center">
							<input type="button" onclick="userDelete()" value="확인"
								class="btn btn-black" id="userDelBtn">
						</div>
					</div>
				</div>
				<!-- col End -->

				<div class="col-sm-12 col-xl-12">
					<div class="text-left rounded p-4"></div>
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