<h1>PARADICE</h1>
   보드게임을 판매하는 쇼핑몰 사이트
  <ul>
    <li>개발인원 : 1명 </li> 
    <li>개발기간 : 2023.06.20 - 23.07.31 (41일)</li>
    <li>배포 사이트 : http://49.142.157.251:9090/javaweb6S/</li>
    <li>테스트 계정 : hkd1234/hkd1234!</li>
  </ul>

  <h1>사용한 기술 스택</h1>
  <ul style="list-style: none;">
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
  기타 사용한 API : SweetAlert2 / TOAST UI Grid / Chart.js / Iamport 결제모듈
  
<h1>구현 기능</h1>
 <ul>
    <li> 계정 관련 </li> 
      <ul>
        <li>로그인, 로그아웃, 회원가입, 회원탈퇴</li>
        <li>ID찾기, 비밀번호 찾기 - 이메일을 통한 재발급 처리</li>
        <li>마이페이지 - 주문 목록, 작성한 QnA목록, 작성한 1:1문의 목록, 작성한 리뷰 목록, 포인트 적립 내역, 쿠폰 내역, 위시리스트, 장바구니, 회원 정보 수정</li>
        <li>관리자 페이지를 통한 상품 등록 및 조회, 배송, 주문관리, 쿠폰관리, Q&A 관리, 1:1 문의 관리, 회원 관리, 통계, 공지사항 등록</li>
      </ul>  
    <li> 게시판 </li> 
      <ul>
        <li>공지사항</li>
        <li>리뷰 페이징 처리</li>
        <li>1:1 문의</li>
        <li>상품별 Q&A 문의</li>
      </ul>  
    <li> 상품 </li> 
      <ul>
        <li>상품 검색</li>
        <li>카테고리별 상품 조회</li>
        <li>상품 목록 페이징 처리</li>
        <li>상품 등록, 삭제, 수정</li>
        <li>등록순, 리뷰평순, 높은 가격순, 낮은 가격순 정렬</li>
        <li>리뷰, Q&A, Q&A 관리자 답글</li>
      </ul>  
    <li> 장바구니 </li> 
      <ul>
        <li>장바구니 상품 추가, 상품 삭제, 개별 주문, 선택 주문</li>
      </ul>  
    <li> 결제 </li> 
      <ul>
        <li>아임포트 결제API 사용 - 신용카드, 무통장입금(가상계좌) 지원</li>
      </ul>  
  </ul>

  <h1>구현 이미지</h1>
  <ul>
    <li> 메인 화면 </li> 
      <ul>
        <li>카테고리별 상품 조회 가능</li>
        <li>전체 버튼에 마우스 오버시 전체 카테고리 확인 가능</li>
        <img src="https://imgur.com/qDI53A2.jpg">
      </ul>  
    <li> 회원 가입 </li> 
      <ul>
        <li>아이디 중복 검사(키업 감지, AJAX 이용 - 비동기식 처리)</li>
        <li>프론트 유효성 검사</li>
        <li>Spring Security - BcryptPasswordEncoder 비밀번호 암호화</li>
        <img src="https://imgur.com/TaYaBZp.jpg">
      </ul>  
    <li> 로그인 </li> 
      <ul>
        <li>아이디 저장 체크 후 로그인 성공 시 쿠키에 아이디 저장</li>
        <img src="https://imgur.com/K8Xmkgv.jpg">
      </ul>  
   <li> 아이디 찾기 </li>   
    <ul>
      <li>서버에서 일치하는 이름과 이메일이 존재하는 경우 일치값을 하단에 표기(AJAX 이용 - 비동기식 처리) </li>
        <img src="https://imgur.com/WbE8aaE.jpg">
    </ul>
   <li> 비밀번호 찾기 </li>   
     <ul>
      <li>서버에서 일치하는 아이디와 이메일이 존재하는 경우 이메일로 임시비밀번호 재발급 </li>
      <li>임시비밀번호의 경우 UUID를 생성해 8자리로 잘라서 구성 </li>
        <img src="https://imgur.com/AD2wTqr.jpg">
    </ul>
   <li> 마이 페이지 </li>   
     <ul>
      <li>회원정보 수정, 회원 탈퇴 기능 </li>
      <li>주문 상세 클릭시 팝업으로 해당 주문 관련 정보를 표시 </li>
        <img src="https://imgur.com/gnNQP3y.jpg">
    </ul>
   <li> 상품 목록 </li>   
     <ul>
      <li>쿼리 스트링을 통한 상품 목록 불러오기</li>
      <li>중분류 클릭시 해당 중분류에 속하는 상품들만 필터링해서 출력</li>
      <li>등록일/상품평/높은가격/낮은가격 순으로 정렬가능</li>
      <li>페이징 처리</li>
        <img src="https://imgur.com/gbAqC7Q.jpg">
    </ul>
   <li> 상품 상세 </li>   
     <ul>
      <li>수량 변경 가능</li>
      <li>리뷰: 상품 구매 후 구매확정시에만 마이페이지에서 리뷰 작성 가능, 페이징 기능</li>
      <li>Q&A : 상품별로 작성 가능(팝업), 비공개 여부 선택 가능, 관리자만 답글 가능, 페이징 처리</li>
        <img src="https://imgur.com/YAe4T38.jpg">
        <img src="https://imgur.com/EwwTZ1M.jpg">
        <img src="https://imgur.com/gX5IvWf.jpg">
    </ul>
   <li> 장바구니 </li>   
     <ul>
      <li>개별 / 선택 주문 가능</li>
      <li>선택 품목 삭제</li>
      <li>5만원 이상 주문 시 배송비 무료</li>
        <img src="https://imgur.com/TYzsyGM.jpg">
    </ul>
   <li> 상품 주문 </li>   
     <ul>
      <li>개별 / 선택 주문 가능</li>
      <li>구매하려는 상품의 목록 표시, 프론트 배송정보 유효성 검사</li>
      <li>트랜잭션 이용 - 상품 구매정보 저장 (주문/주문 품목/배송지/결제)</li>
      <li>아임포트 결제모듈 이용 - 신용카드, 가상계좌(무통장입금) 결제가능</li>
        <img src="https://imgur.com/jJUXRfe.jpg">
      <li>사용가능한 쿠폰 적용 가능</li>
        <img src="https://imgur.com/jITA3KY.jpg">
    </ul>
  </ul>
