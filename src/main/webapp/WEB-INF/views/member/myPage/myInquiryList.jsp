<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<c:set var="ctp" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>PARADICE | 마이페이지</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<!-- Favicon -->
<link rel="icon" href="${ctp}/images/favicon.ico">
<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
<script>
		'use strict'
		$(document).ready(function(){
			//최근 주문내역 
			//--------------------------------------------------------------
			$("#startDate").change(function(){
				$("#startDate").css("color", "black");
			});
			$("#endDate").change(function(){
				$("#endDate").css("color", "black");
			});
			
			$(".clickPrevent").click(function(e){
				   e.stopPropagation();
				})
			let now = new Date();	
	    document.getElementById('startDate').valueAsDate = new Date(now.setDate(now.getDate()));
	    document.getElementById('endDate').valueAsDate = new Date(now.setDate(now.getDate()));
	    
			//조회기간 설정
			$("input[name='duration']").click(function(){
						var duration = $("input[name='duration']:checked").val();
	        	let startDate = $("#startDate").val();
	      		let day  = new Date();
	      		
	      		if(startDate == "") {
	      			Swal.fire({
	    				width:500,
	    			  position: 'center',
	    			  icon: 'error',
	    			  title: '조회할 기간을 선택해주세요.',
	    			  showConfirmButton: false,
	    			  timer: 1000
	    			})
	    			 return;
	      		}

	      		if(duration == "today"){
	        		document.getElementById('startDate').valueAsDate = new Date(now.setDate(now.getDate()));
	        	}
	        	else if (duration == "week"){
	        		day = new Date(day.setDate(day.getDate()-7));
	        		document.getElementById('startDate').valueAsDate = new Date(day);
	        	}
	        	else if (duration == "15day"){
	        		let day  = new Date(startDate);
	        		day = new Date(day.setDate(day.getDate()-15));
	        		document.getElementById('startDate').valueAsDate = new Date(day);
	        	}
	        	else if (duration == "1month"){
	        		let day  = new Date(startDate);
	        		day = new Date(day.setMonth(day.getMonth()-1));
	        		document.getElementById('startDate').valueAsDate = new Date(day);
	        	}
	        	else if (duration == "3month"){
	        		let day  = new Date(startDate);
	        		day = new Date(day.setMonth(day.getMonth()-3));
	        		document.getElementById('startDate').valueAsDate = new Date(day);
	        	}
				$("#endDate").css("color", "black");
	      });
		});
		function hideSearch(){
			$("#hideSearchForm").hide(500);
			$("#hideBtn").css('display','none');
			$("#showBtn").css('display','block');
		}
		function showSearch(){
			$("#hideSearchForm").show(500);
			$("#hideBtn").css('display','block');
			$("#showBtn").css('display','none');
		}
		
		function searchNow(){
			//답변상태 (OK/NO)
			let answerOK = document.getElementsByName("answerOK");
			let answerOKList = "";
			for(let i=0; i<answerOK.length; i++){
				if(answerOK[i].checked == true){
					answerOKList += $("#answerOK"+(i+1)).val() + "/";
				}
			}
			let openSw = document.getElementsByName("openSw");
			let openSwList = "";
			for(let i=0; i<openSw.length; i++){
				if(openSw[i].checked == true){
					openSwList += $("#openSw"+(i+1)).val() + "/";
				}
			}
			
			$("#answerOKList").val(answerOKList);
			$("#openSwList").val(openSwList);
			
			QnASearch.submit();
		}
		

		function deleteQnA(qna_idx){
			Swal.fire({
				  title: '해당 Q&A를 삭제하시겠습니까?',
				  showDenyButton: true,
				  confirmButtonColor: 'grey',
				  confirmButtonText: '확인',
				  denyButtonText: '취소',
				}).then((result) => {
				  if (result.isConfirmed) {
				    $.ajax({
				    	type: "post",
				    	data: {qna_idx : qna_idx},
							url: "${ctp}/member/QnADelete",
							success: function(res){
							if(res=="1"){
								Swal.fire({
									width:500,
								  position: 'center',
								  icon: 'success',
								  title: '삭제 되었습니다.',
								  showConfirmButton: false,
								  timer: 1500
								})
								setTimeout(function(){location.reload();},1500);
							}
						}
				    });
				  }
				})
		}
		</script>
</head>

<body>

	<jsp:include page="/WEB-INF/views/include/nav.jsp" />
	<div class="container-xl position-relative bg-white d-flex p-0 mypage">

		<jsp:include page="/WEB-INF/views/member/myPage/myPageNav.jsp" />


		<div class="container-fluid pt-4 px-4">
			<div class="row">
				<div class="col-sm-12 col-xl-12">
					<div class="text-center rounded p-4">
						<div
							class="d-flex align-items-center justify-content-between mb-4 mt-2 border-bottom-design">
							<div class="d-flex mb-1">
								<h4 class="mb-0 pretendard mr-2">1:1 문의</h4>
							</div>
						</div>
						<!-- 오른쪽 카테고리 등록부분 -->
						<!-- Form Start -->
						<form name="InquirySearch" method="get"
							action="${ctp}/member/InquirySearch">
							<div class="bg-white rounded-lg p-3 mb-3">
								<div class="p-3">
									<div class="row border align-items-center  font-16px"
										id="searchForm">
										<div class="col-xl-12">
											<!-- 여기서부터 묶어주기 -->
											<div id="hideSearchForm">
												<div class="row border-bottom">
													<div
														class="col-sm-2 col-xl-2 gmarketSans16 p-0 d-flex align-items-center justify-content-center"
														style="background: #eee;">
														<div>답변 상태</div>
													</div>
													<div class="col-sm-10 col-xl-10">
														<div class="row p-3 d-flex flex-column">
															<!-- 입금 완료 ~ 배송 처리 -->
															<div class="row p-2">
																<div
																	class="custom-control custom-checkbox d-flex align-items-center mr-3">
																	<input type="checkbox" class="custom-control-input"
																		name="answerOK" id="answerOK1" value="OK"
																		<c:if test="${fn:indexOf(searchVO.answerOKList, 'OK')!=-1}">checked</c:if> />
																	<label class="custom-control-label black"
																		for="answerOK1">완료</label>
																</div>
																<div
																	class="custom-control custom-checkbox d-flex align-items-center mr-3">
																	<input type="checkbox" class="custom-control-input"
																		name="answerOK" id="answerOK2" value="NO"
																		<c:if test="${fn:indexOf(searchVO.answerOKList, 'NO')!=-1}">checked</c:if> />
																	<label class="custom-control-label black"
																		for="answerOK2">미완료</label>
																</div>
															</div>
														</div>
													</div>
												</div>
												<!-- 검색 -->
												<div class="row  border-bottom">
													<div
														class="col-sm-2 col-xl-2 p-0 d-flex align-items-center justify-content-center "
														style="background: #eee;">
														<div>기간</div>
													</div>
													<div class="col-sm-10 col-xl-10">
														<div class="row p-3 d-flex flex-column">
															<!-- 입금 완료 ~ 배송 처리 -->
															<div class="row p-2">
																<div class="custom-input mr-3">
																	<select class="btn border" name="durationCategory"
																		id="durationCategory">
																		<option value="qna_Date"
																			<c:if test="${fn:indexOf(searchVO.durationCategory, 'qna_Date')!=-1}">selected</c:if>>등록일자</option>
																		<option value="answer_Date"
																			<c:if test="${fn:indexOf(searchVO.durationCategory, 'answer_Date')!=-1}">selected</c:if>>답변일자</option>
																	</select>
																</div>
																<div class="custom-input">
																	<input type="date" class="textbox text-mute"
																		name="startDate" id="startDate"
																		<c:if test="${searchVO.startDate!=''}">value="${searchVO.startDate}"</c:if>>
																	- <input type="date" class="textbox text-mute"
																		name="endDate" id="endDate"
																		<c:if test="${searchVO.endDate!=''}">value="${searchVO.endDate}"</c:if>>
																</div>
																<div class="ml-3 buttonList btn-group btn-group-toggle"
																	data-toggle="buttons">
																	<label class="btn btn-secondary"> <input
																		type="radio" name="duration" id="today"
																		autocomplete="off" value="today" checked> 오늘
																	</label> <label class="btn btn-secondary"> <input
																		type="radio" name="duration" id="week"
																		autocomplete="off" value="week"> 1주
																	</label> <label class="btn btn-secondary"> <input
																		type="radio" name="duration" id="15day"
																		autocomplete="off" value="15day"> 15일
																	</label> <label class="btn btn-secondary"> <input
																		type="radio" name="duration" id="1month"
																		autocomplete="off" value="1month"> 1개월
																	</label> <label class="btn btn-secondary"> <input
																		type="radio" name="duration" id="3month"
																		autocomplete="off" value="3month"> 3개월
																	</label>
																</div>
															</div>
														</div>
													</div>
												</div>
												<!-- 버튼 -->
												<div class="row  border-bottom">
													<div class="col-sm-12 col-xl-12">
														<div class="row p-3 d-flex flex-column align-items-center">
															<div class="row p-2">
																<button type="button" class="btn-black mr-2"
																	onclick="searchNow()">
																	<i class="fas fa-search"></i>&nbsp;검색
																</button>
																<button type="button" class="btn-black-outline"
																	onclick="location.reload();">
																	<i class="fas fa-undo"></i>&nbsp;초기화
																</button>
															</div>
														</div>
													</div>
												</div>
											</div>
											<!-- 숨길 구간 -->
											<input type="hidden" name="openSwList" id="openSwList">
											<input type="hidden" name="answerOKList" id="answerOKList">
											<div class="row  border-bottom" id="showButton">
												<div class="col-sm-12 col-xl-12">
													<div class="row p-3 d-flex flex-column align-items-center">
														<div class="row p-2">
															<!-- 접히는 버튼? -->
															<button type="button" class="" onclick="hideSearch()"
																id="hideBtn">
																<i class="fas fa-angle-double-up fa-2x"></i>
															</button>
															<button type="button" class="" onclick="showSearch()"
																id="showBtn" style="display: none;">
																<i class="fas fa-angle-double-down fa-2x"></i>
															</button>
														</div>
													</div>
												</div>
											</div>
										</div>


									</div>
								</div>
							</div>
							<!-- Form End -->
						</form>
					</div>
				</div>
			</div>
			<!-- 226라인 col-sm-12 col-xl-12 end -->

			<div class="col-sm-12 col-xl-12">
				<div class="bg-white rounded-lg h-100 p-3">
					<button type="button" class="btn-black"
						onclick="location.href='${ctp}/member/InsertInquiry';">1:1문의
						등록</button>

					<!-- QnA 목록 -->
					<div class="navbar-nav">
						<nav class="navbar">
							<div class="navbar-nav w-100">
								<div class="row qna-header text-center gmarketSans font-16px">
									<div class="col-2 ">번호</div>
									<div class="col-5 ">제목</div>
									<div class="col-2">답변상태</div>
									<div class="col-3">작성일</div>
								</div>

								<c:if test="${fn:length(InquiryVos) == 0}">
									<div
										class="d-flex flex-column justify-content-center align-items-center mt-5">
										<i class="far fa-times-circle fa-5x my-3"></i> <span
											class="gmarketSans">등록된 1:1 문의가 없습니다.</span>
									</div>
								</c:if>
								<div id="qnaList">
									<c:forEach var="vo" items="${InquiryVos}" varStatus="st">
										<div class="row boardLine pointer" style="font-size: 12pt;"
											onclick="location.href='${ctp}/member/myInquiry?inq_idx=${vo.inq_idx}'">
											<div class="col-2 text-center">${st.count}</div>
											<div class="col-5 ellipsis">${vo.inq_title}</div>
											<div class="col-2 text-center">
												<c:if test="${vo.inq_answerOK == 'NO'}">X</c:if>
												<c:if test="${vo.inq_answerOK == 'OK'}">O</c:if>
											</div>
											<div class="col-3 text-center">${fn:substring(vo.inq_wDate,0,10)}</div>
										</div>
									</c:forEach>
								</div>

							</div>
						</nav>
					</div>


					<!-- 블록 페이징 처리 -->
					<div class="text-center m-4">
						<ul class="pagination justify-content-center pagination-sm">
							<c:if test="${pageVO.pag > 1}">
								<li class="page-item"><a class="page-link text-secondary"
									href="${ctp}/member/myQnAList?pageSize=${pageVO.pageSize}&pag=1">첫페이지</a></li>
							</c:if>
							<c:if test="${pageVO.curBlock > 0}">
								<li class="page-item"><a class="page-link text-secondary"
									href="${ctp}/member/myQnAList?pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock-1)*pageVO.blockSize + 1}">이전블록</a></li>
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
									<li class="page-item"><a class="page-link text-secondary"
										href="${ctp}/member/myQnAList?pageSize=${pageVO.pageSize}&pag=${i}">${i}</a></li>
								</c:if>
							</c:forEach>
							<c:if test="${pageVO.curBlock < pageVO.lastBlock}">
								<li class="page-item"><a class="page-link text-secondary"
									href="${ctp}/member/myQnAList?pageSize=${pageVO.pageSize}&pag=${(pageVO.curBlock+1)*pageVO.blockSize + 1}">다음블록</a></li>
							</c:if>
							<c:if test="${pageVO.pag < pageVO.totPage}">
								<li class="page-item"><a class="page-link text-secondary"
									href="${ctp}/member/myQnAList?pageSize=${pageVO.pageSize}&pag=${pageVO.totPage}">마지막페이지</a></li>
							</c:if>
						</ul>
					</div>


				</div>
			</div>
			<!-- 226라인 row end -->
		</div>




		<!-- Back to Top -->
		<a href="#" class="btn btn-lg btn-danger btn-lg-square back-to-top"><i
			class="bi bi-arrow-up"></i></a>
	</div>

	</div>
	<jsp:include page="/WEB-INF/views/include/footer.jsp" />
</body>

</html>