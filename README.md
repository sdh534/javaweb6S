<h1>파라다이스</h1>

> 보드게임 쇼핑몰 사이트 제작 <br/>
> 기간: 2023.06.21 - 2023.07.31(41일) <br/>
> 인원: 1인<br/>

링크 : http://49.142.157.251:9090/javaweb6S/
<h1>사용 기술 스택</h1>
<ul>
 <li>
      <img src="https://img.shields.io/badge/java-red?style=for-the-badge&logo=java&logoColor=white"> 
      <img src="https://img.shields.io/badge/spring-6DB33F?style=for-the-badge&logo=spring&logoColor=white">
    </li>
    <li>
      <img src="https://img.shields.io/badge/apache tomcat-orange?style=for-the-badge&logo=apachetomcat&logoColor=white">
      <img src="https://img.shields.io/badge/mysql-4479A1?style=for-the-badge&logo=mysql&logoColor=white">
      <img src="https://img.shields.io/badge/myBatis-black?style=for-the-badge&logo=myBatis&logoColor=white">
    <li>
      <img src="https://img.shields.io/badge/html5-E34F26?style=for-the-badge&logo=html5&logoColor=white">
      <img src="https://img.shields.io/badge/css-1572B6?style=for-the-badge&logo=css3&logoColor=white"> 
      <img src="https://img.shields.io/badge/javascript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black"> 
      <img src="https://img.shields.io/badge/jquery-0769AD?style=for-the-badge&logo=jquery&logoColor=white">
      <img src="https://img.shields.io/badge/bootstrap-7952B3?style=for-the-badge&logo=bootstrap&logoColor=white">
      <img src="https://img.shields.io/badge/fontawesome-339AF0?style=for-the-badge&logo=fontawesome&logoColor=white">
    </li>
</ul>

<h1>구현 기능</h1>
<div>
    <ul>
        <li>
            <strong>계정 관련</strong>
            <ul>
                <li>로그인,로그아웃,회원가입,회원탈퇴</li>
                <li>ID찾기</li>
                <li>비밀번호 재발급 - 이메일 전송</li>
                <li>MyPage(주문 목록, 작성한 QnA목록, 작성한 리뷰 목록)</li>
                <li>등급별 적립금 차등 지급</li>
                <li>관리자 페이지를 통한 상품 조회, 배송, 주문관리</li>
            </ul>
        </li>
        <li>
            <strong>상품</strong>
            <ul>
                <li>상품 검색</li>
                <li>카테고리별 상품 조회</li>
                <li>버튼 페이징</li>
                <li>카테고리 등록, 삭제</li>
                <li>상품 등록, 삭제, 수정</li>
                <li>등록일순, 리뷰평순, 낮은가격순, 높은 가격순 정렬</li>
                <li>리뷰 CRUD, QnA CRUD</li>
            </ul>
        </li>
        <li>
            <strong>공지사항</strong>
            <ul>
                <li>게시판 CRUD</li>
            </ul>
        </li>
        <li>
            <strong>장바구니</strong>
            <ul>
                <li>추가, 개별주문, 선택주문</li>
            </ul>
        </li>
        <li>
            <strong>위시리스트</strong>
            <ul>
                <li>추가, 삭제</li>
            </ul>
        </li>
        <li>
            <strong>결제 - Iamport 결제모듈 사용, KG 이니시스</strong>
            <ul>
                <li>신용카드, 가상계좌</li>
                <li>쿠폰 및 적립금 사용 가능</li>
            </ul>
        </li>
    </ul>
</div>


<h1>이미지</h1>
<div>
    <ul>
        <li>
            <strong>메인 페이지</strong>
            <ul>
                <li>카테고리별 상품 조회 가능</li>
                <li>상품검색 가능</li>
                  <img src="https://i.imgur.com/qDI53A2.png">
                  <img src="https://i.imgur.com/acr6Q6k.png">
            </ul>
        </li>
        <br/>
        <li>
            <strong>로그인/회원가입/아이디찾기/비밀번호찾기</strong>
            <ul>
                <li>아이디 중복검사</li>
                <li>프론트 유효성 검사</li>
                <li>SMTP이용 - 임시비밀번호 재발급</li>
                  <img src="https://i.imgur.com/TaYaBZp.png">
                  <img src="https://i.imgur.com/AD2wTqr.png">
            </ul>
        </li>
        <br/>
        <li>
            <strong>MyPage</strong>
            <ul>
                <li>회원탈퇴, 회원수정 가능</li>
                <li>주문상세보기 클릭시 해당 주문 관련 정보를 팝업으로 표시</li>
                <li>쿠폰 사용 내역, 적립금 사용 내역 조회 가능</li>
                    <img src="https://i.imgur.com/gnNQP3y.png">
            </ul>
        </li>
        <li>
            <strong>상품, 상품리뷰, 상품 QnA</strong>
            <ul>
                <li>중분류 선택 정렬 가능 (등록일순/상품평순/높은가격순/낮은가격순)</li>
                <li>수량 변경 가능</li>
                <li>리뷰 : 상품 구매 후 구매확정시에만 리뷰 작성 가능, 페이징 처리</li>
                <li>QnA : 비공개여부 선택 가능, 관리자 페이지에서 답글 가능</li>
                    <img src="https://i.imgur.com/GlNblvb.png">
                    <img src="https://i.imgur.com/N1ykOd3.png">
                    <img src="https://i.imgur.com/YAe4T38.png">
                    <img src="https://i.imgur.com/EwwTZ1M.png">
            </ul>
        </li>
        <br/>
        <br/>
        <li>
            <strong>장바구니</strong>
            <ul>
                <li>개별 혹은 선택주문</li>
                <li>선택 삭제 가능</li>
                <li>배송비 5만원 이상일 경우 0원으로, 이하일 경우 3천원으로 변경</li>
                <li>
                    <img src="https://i.imgur.com/TYzsyGM.png">
                </li>
            </ul>
        </li>
        <br/>
        <li>
            <strong>상품 주문</strong>
            <ul>
                <li>구매하려는 상품 목록 표시</li>
                <li>구매 클릭시 프론트에서 배송정보 유효성 검사후 결제 진행</li>
                <li>무통장입금, 가상계좌 결제 가능</li>
                <li>쿠폰 및 적립금 사용 가능</li>
                    <img src="https://i.imgur.com/jJUXRfe.png">
            </ul>
        </li>
      <li>
            <strong>주문 정보</strong>
            <ul>
                <li>주문 날짜 별 검색 가능</li>
                <li>주문한 상품에 대한 기본 정보 표시</li>
                <li>가상계좌 구매시 계좌번호 표시 - Iamport API & 스케줄러 이용, 10분마다 무통장입금 자동 확인</li>
                    <img src="https://i.imgur.com/9m5VwEz.png">
                    <img src="https://i.imgur.com/LDomp0x.png">
            </ul>
        </li>
        <br/>
        <li>
            <strong>관리자 페이지 메인</strong>
            <ul>
                <li>최근 5건의 주문 목록, CS 통계</li>
            </ul>
        </li>
        <br/>
        <li>
            <strong>관리자 페이지 주문목록</strong>
            <ul>
                <li>주문상태 변경 기능</li>
                <li>쿼리 스트링 이용 동적 검색</li>
            </ul>
        </li>
        <br/>
        <li>
            <strong>관리자 페이지 상품배송</strong>
            <ul>
                <li>배송중인 주문만 표시</li>
                <li>운송장 입력후 배송시 해당 주문 배송상태를 '배송중'으로 변경</li>
            </ul>
        </li>
        <br/>
        <li>
            <strong>관리자 카테고리 목록</strong>
            <ul>
                <li>카테고리 생성/삭제 가능</li>
                <li>대분류 선택 후 동적으로 중분류 활성화</li>
            </ul>
        </li>
        <li>
            <strong>관리자 페이지 상품 목록</strong>
            <ul>
                <li>TOAST UI Grid 이용</li>
            </ul>
        </li>
    </ul>
</div>
<br/>
