<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<head>
<meta charset="utf-8">
<title>PARADICE | 전체 회원 조회</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta content="" name="keywords">
<meta content="" name="description">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
</head>
<script>

$(document).ready(function(){
	$("#updateStatus").change(function(){
		if($("#updateStatus").val() == -1) location.href="${ctp}/admin/member/memberList";
		else location.href='${ctp}/admin/member/memberList?m_level='+$("#updateStatus").val();
	});
	
});


// 체크박스 전체 선택
$(function(){
		$("#member_check").on('click',function(){
			//체크박스 check상태가 true라면
			if($("#member_check").is(":checked"))  
			{
				$("input[name='m_idx']").prop("checked", true);
			}
			else
			{
				$("input[name='m_idx']").prop("checked", false);
			}
		});
		//하위 항목 클릭시 전체를 선택한 경우 상단의 체크박스도 바꿔주는 코드  
		$("input[name='m_idx']").click(function() {
			var total = $("input[name='m_idx']").length;
			var checked = $("input[name='m_idx']:checked").length;
			if(total != checked) {
				$("#member_check").prop("checked", false);
			}
			else $("#member_check").prop("checked", true); 
		});
		
		$(".hide").hide();
	});
	
	function memberToggle(m_idx){
		$("#detail"+m_idx).toggle();
	}
	
function levelUpdate(){
	let arr = [];
	let check = document.getElementsByName("m_idx");
	let checkCount = 0;
	let memberIdxList = "";
	for(let i=0; i<check.length; i++){
		if(check[i].checked == true){
			arr.push(check[i].value); 
			memberIdxList += check[i].value + "/";
			checkCount++;
		}
	}
	let leverStr = ['브론즈','실버','골드','VIP'];
	Swal.fire({
		  title: '선택하신 '+checkCount+'명의 회원을 \n'+leverStr[$("#changeLevel").val()-1]+'으로 변경하시겠습니까?',
		  showDenyButton: true,
		  confirmButtonText: '확인',
		  denyButtonText: '취소',
		}).then((result) => {
			if (result.isConfirmed) {
			$.ajax({
				type : "post",
				url : "${ctp}/admin/member/memberLevelUpdate",
				data : {
					memberIdxList: memberIdxList,
					m_level: $("#changeLevel").val()
				},
				success : function(res) {
					if(res==1){
						Swal.fire({
							width:500,
						  position: 'center',
						  icon: 'success',
						  title: '변경되었습니다.',
						  showConfirmButton: false,
						  timer: 1000
						})
						setTimeout(function(){
							location.reload();
						},1000);
					}
				},
				error : function() {
					alert("전송오류!");
				}
			}); }
		})
}

function memberDelete(m_idx){
	Swal.fire({
		  title: '선택하신 회원을 탈퇴처리하시겠습니까?',
		  showDenyButton: true,
		  confirmButtonText: '확인',
		  denyButtonText: '취소',
		}).then((result) => {
			if (result.isConfirmed) {
			$.ajax({
				type : "post",
				url : "${ctp}/admin/member/memberDelete",
				data : {
					m_idx : m_idx					
				},
				success : function(res) {
					if(res==1){
						Swal.fire({
							width:500,
						  position: 'center',
						  icon: 'success',
						  title: '정상적으로 처리되었습니다.',
						  showConfirmButton: false,
						  timer: 1000
						})
						setTimeout(function(){
							location.reload();
						},1000);
					}
				},
				error : function() {
					alert("전송오류!");
				}
			}); }
		})
}
</script>
<body>

	<div class="container-xxl position-relative bg-white d-flex p-0">

		<jsp:include page="/WEB-INF/views/admin/adminNav.jsp" />


		<div class="container-fluid pt-4 px-4">


			<div class="row">
				<div class="col-sm-12 col-xl-12">
					<div class="row mb-4">
						<div class="col-sm-12 col-xl-12  h-100">
							<!-- 오른쪽 카테고리 등록부분 -->
							<!-- Form Start -->
							<div class="bg-white rounded-lg p-4 mb-2">
								<h5 class="mb-2">전체 회원 조회</h5>
								<div class="d-flex align-items-center p-2">
									<span>정렬 방식 </span> <select class="textbox border ml-3"
										name="updateStatus" id="updateStatus">
										<option value="-1"
											<c:if test="${m_level ==''}">selected</c:if>>전체</option>
										<option value="1"
											<c:if test="${m_level =='1'}">selected</c:if>>브론즈</option>
										<option value="2"
											<c:if test="${m_level =='2'}">selected</c:if>>실버</option>
										<option value="3"
											<c:if test="${m_level =='3'}">selected</c:if>>골드</option>
										<option value="4"
											<c:if test="${m_level =='4	'}">selected</c:if>>VIP</option>
									</select>
								</div>
								<div class="custom-input d-flex mr-3 justify-content-between">
									<div class=" d-flex align-items-center p-2">
										<span>등급 변경</span> <select class="textbox border ml-3"
											name="changeLevel" id="changeLevel">
											<option value="">선택</option>
											<option value="1">브론즈</option>
											<option value="2">실버</option>
											<option value="3">골드</option>
											<option value="4">VIP</option>
										</select>
										<button type="button" class="btn-black-outline btn-small ml-2"
											onclick="levelUpdate()">변경</button>
									</div>
									<div class=" p-2">
										<select class="btn border" name="updateStatus">
											<option value="">구분</option>
											<option value="m_mid">아이디</option>
											<option value="m_name">성명</option>
											<option value="m_nickName">닉네임</option>
										</select> <input type="text" class="textbox" name="memberKeywordSearch">
										<button type="button" class="btn-black btn-small ml-2"
											onclick="">검색</button>
									</div>
								</div>
								<div class="table-responsive">
									<table
										class="table text-start align-middle table-bordered table-hover mb-0">
										<thead>
											<tr class="text-dark bg-light pretendard text-sm"
												id="memberToggle${vo.m_idx}">
												<th scope="col">
													<div class="p-2 px-3 text-uppercase">
														<div
															class="custom-control custom-checkbox custom-control-inline">
															<input type="checkbox" class="custom-control-input"
																name="member_checkAll" id="member_check" /> <label
																class="custom-control-label black" for="member_check"
																style="margin-left: 10px;"> </label>
														</div>
													</div>
												</th>
												<th scope="col">등급</th>
												<th scope="col">이름</th>
												<th scope="col">연락처</th>
												<!-- 1 정액 2 정율 -->
												<th scope="col">이메일</th>
												<th scope="col" style="width: 100px">이메일 수신 동의</th>
												<th scope="col">가입일</th>
												<th scope="col">포인트</th>
												<th scope="col" style="width: 100px">상태</th>
											</tr>
										</thead>
										<tbody id="memberListList"
											class="nanumbarungothic text-center"
											style="vertical-align: middle;" class="text-center">
											<c:forEach var="vo" items="${vos}" varStatus="st">
												<c:if test="${vo.m_name !=''}">
													<tr onclick="memberToggle(${vo.m_idx})">
														<td>
															<div class="custom-control custom-checkbox ">
																<input type="checkbox" class="custom-control-input"
																	name="m_idx" id="m_idx${vo.m_idx}" value="${vo.m_idx}" />
																<label class="custom-control-label black"
																	for="m_idx${vo.m_idx}" style="margin-left: 10px;"></label>
															</div>
														</td>
														<td><c:if test="${vo.m_level == 0}">관리자</c:if> <c:if
																test="${vo.m_level == 1}">브론즈</c:if> <c:if
																test="${vo.m_level == 2}">실버</c:if> <c:if
																test="${vo.m_level == 3}">골드</c:if> <c:if
																test="${vo.m_level == 4}">VIP</c:if></td>
														<td>${vo.m_name}</td>
														<td>${vo.m_phone}</td>
														<td>${vo.m_email}</td>
														<td><c:if test="${vo.m_mailOk == 'OK'}">Y</c:if> <c:if
																test="${vo.m_mailOk == 'NO'}">N</c:if></td>
														<td>${fn:substring(vo.m_startDate,0,10)}</td>
														<td>${vo.m_point}</td>
														<td
															class="<c:if test="${fn:contains(vo.m_userDel, 'Y')}">red</c:if>">
															<c:if test="${fn:contains(vo.m_userDel, 'N')}">활동중</c:if>
															<c:if test="${fn:contains(vo.m_userDel, 'Y')}">탈퇴 신청</c:if>
														</td>
													</tr>
													<tr id="detail${vo.m_idx}" class="hide">
														<td colspan="9">
															<div class="border container bg-white p-3">
																<h4>회원 상세 정보</h4>
																<div class="row">
																	<div class="col">
																		<table class="table">
																			<tbody>
																				<tr>
																					<th>고유번호</th>
																					<td>${vo.m_idx}</td>
																				</tr>
																				<tr>
																					<th>프로필 사진</th>
																					<td><img src="${ctp}/images/noImage.jpg"
																						width="100px"></td>
																				</tr>
																				<tr>
																					<th>아이디</th>
																					<td>${vo.m_mid}</td>
																				</tr>
																				<tr>
																					<th>이름</th>
																					<td>${vo.m_name}</td>
																				</tr>
																				<tr>
																					<th>생일</th>
																					<td>${fn:substring(vo.m_birthday,0,10)}</td>
																				</tr>
																				<tr>
																					<th>email</th>
																					<td>${vo.m_email}</td>
																				</tr>
																			</tbody>
																		</table>
																	</div>
																	<div class="col">
																		<table class="table">
																			<tbody>
																				<tr>
																					<th width="30%">연락처</th>
																					<td>${vo.m_phone}</td>
																				</tr>
																				<tr>
																					<th>등급</th>
																					<td>${levelStr[vo.m_level]}</td>
																				</tr>
																				<tr>
																					<th>주소</th>
																					<c:set var="addr"
																						value="${fn:split(vo.m_address,'/')}"></c:set>
																					<td>${addr[1]}&nbsp;${addr[2]}&nbsp;${addr[3]}&nbsp;(${addr[0]})</td>
																				</tr>
																				<tr>
																					<th>누적포인트</th>
																					<td>${vo.m_point}</td>
																				</tr>
																				<tr>
																					<th>최근 방문일</th>
																					<td>${vo.m_lastDate}</td>
																				</tr>
																				<tr>
																					<th>이메일 수신여부</th>
																					<td>${vo.m_mailOk}</td>
																				</tr>
																				<c:if test="${fn:contains(vo.m_userDel, 'Y')}">
																					<tr>
																						<th>탈퇴 경과일</th>
																						<td class="red">${vo.m_lastDate}(${vo.delDiff}일
																							경과)</td>
																					</tr>
																				</c:if>
																			</tbody>
																		</table>
																	</div>
																</div>
																<c:if test="${vo.delDiff >= 30}">
																	<input type="button" class="btn btn-danger" value="삭제"
																		onclick="memberDelete(${vo.m_idx})" />
																</c:if>
															</div>
														</td>
													</tr>
												</c:if>
											</c:forEach>
										</tbody>
									</table>
								</div>

								<!-- 블록 페이징 처리 -->
								<div class="text-center m-4">
									<ul class="pagination justify-content-center pagination-sm">
										<c:if test="${pageVO.pag > 1}">
											<li class="page-item"><a
												class="page-link text-secondary"
												href="${ctp}/admin/member/memberList?pageSize=${pageVO.pageSize}&pag=1">첫페이지</a></li>
										</c:if>
										<c:if test="${pageVO.curBlock > 0}">
											<li class="page-item"><a
												class="page-link text-secondary"
												href="${ctp}/admin/member/memberList?pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock-1)*pageVO.blockSize + 1}">이전블록</a></li>
										</c:if>
										<c:forEach var="i"
											begin="${pageVO.curBlock*pageVO.blockSize + 1}"
											end="${pageVO.curBlock*pageVO.blockSize + pageVO.blockSize}"
											varStatus="st">
											<c:if test="${i <= pageVO.totPage && i == pageVO.pag}">
												<li class="page-item active"><a
													class="page-link text-white bg-secondary border-secondary"
													href="javascript:nextPage(${pageVO.pageSize},${i})">${i}</a></li>
											</c:if>
											<c:if test="${i <= pageVO.totPage && i != pageVO.pag}">
												<li class="page-item"><a
													class="page-link text-secondary"
													href="${ctp}/admin/member/memberList?pageSize=${pageVO.pageSize}&pag=${i}">${i}</a></li>
											</c:if>
										</c:forEach>
										<c:if test="${pageVO.curBlock < pageVO.lastBlock}">
											<li class="page-item"><a
												class="page-link text-secondary"
												href="${ctp}/admin/member/memberList?pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock+1)*pageVO.blockSize + 1}">다음블록</a></li>
										</c:if>
										<c:if test="${pageVO.pag < pageVO.totPage}">
											<li class="page-item"><a
												class="page-link text-secondary"
												href="${ctp}/admin/member/memberList?pageSize=${pageVO.pageSize}&pag=${pageVO.totPage}">마지막페이지</a></li>
										</c:if>
									</ul>
								</div>


							</div>
							<!-- 흰 배경 안으로 묶어줌 -->
						</div>
						<!-- col 종료 -->
					</div>
				</div>
			</div>



		</div>


		<!-- Footer Start -->
		<div class="container-fluid pt-4 px-4">
			<div class="bg-light rounded-top p-4">
				<div class="row">
					<div class="col-12 col-sm-6 text-center text-sm-start">
						&copy; <a href="#">Your Site Name</a>, All Right Reserved.
					</div>
					<div class="col-12 col-sm-6 text-center text-sm-end">
						<!--/*** This template is free as long as you keep the footer authorâs credit link/attribution link/backlink. If you'd like to use the template without the footer authorâs credit link/attribution link/backlink, you can purchase the Credit Removal License from "https://htmlcodex.com/credit-removal". Thank you for your support. ***/-->
						Designed By <a href="https://htmlcodex.com">HTML Codex</a>
					</div>
				</div>
			</div>
		</div>
		<!-- Footer End -->
	</div>
	<!-- Content End -->

	<!-- Back to Top -->
	<a href="#" class="btn btn-lg btn-danger btn-lg-square back-to-top"><i
		class="bi bi-arrow-up"></i></a>

</body>

