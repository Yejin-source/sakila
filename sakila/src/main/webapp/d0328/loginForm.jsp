<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	// 로그인 되었는지 아닌지
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));	
	// 세션에서 loginStaff 키에 저장된 값을 가져옴 
	// session.getAttribute("loginStaff") 반환값은 Object 타입 -> Integer로 반환
			
	if(staffId != null) { // 로그인 상태라면
		response.sendRedirect("/sakila/index.jsp");	
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
	<h1>Staff Login</h1>
	<form action="/sakila/d0328/loginAction.jsp" method="post"> <!-- 매개값이 노출되지 않음 -->
	<!-- 
		a태그와 동일한 방식: loginAction.jsp?number= & password= 
		매개값이 노출됨, 브라우저 주소창에 문자열 형태로 넘어가니까 길이가 제한되어 있음
		
		데이터값을 매개값으로 해서 다른 페이지로 전송하는 방법
		1) a태그: get (무조건 값이 노출됨)
		2) form 태그의 method 속성: get, post
	-->
		<table border="1">
			<tr>
				<th>staffId</th>
				<td><input type="number" name="staffId"></td>
			</tr>
			<tr>
				<th>password</th>
				<td><input type="password" name="password"></td>
			</tr>
		</table>
		<button type="submit">로그인</button>
	</form>
</body>
</html>