<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	// 로그인 되었는지 아닌지
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));		
			
	if(staffId == null) { // 로그아웃 상태라면
		response.sendRedirect("/sakila/d0328/loginForm.jsp");	
		return;
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
	<div>
		<%=staffId%>님 반갑습니다
		<a href="/sakila/d0328/logout.jsp">[로그아웃]</a>
		<a href="/sakila/d0328/updatePasswordForm.jsp">[비밀번호 변경]</a>
	</div>
	<h1>Index</h1>
	<ol>
		<li><a href="/sakila/d0325/rentalList.jsp">대여목록</a></li><!-- 3/25 -->
		<li><a href="/sakila/d0326/filmList.jsp">영화목록</a></li><!-- 3/26 -->
		<li><a href="/sakila/d0326/actorList.jsp">배우목록</a></li><!-- 3/26 -->
	</ol>
</body>
</html>