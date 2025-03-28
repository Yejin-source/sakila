<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
	// 로그인 되었는지 아닌지
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));	
	// 세션에서 loginStaff 키에 저장된 값을 가져옴 
	// session.getAttribute("loginStaff") 반환값은 Object 타입 -> Integer로 반환
			
	if(staffId == null) { // 로그아웃 상태라면
		// 로그인 페이지로 리다이렉트
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
	<h1>비밀번호 변경</h1>
	<form action="/sakila/d0328/updatePasswordAction.jsp">
	<table border="1">
		<tr>
			<th>현재 비밀번호</th>
			<td><input type="password" name="password"></td>
		</tr>
		<tr>
			<th>새 비밀번호</th>
			<td><input type="password" name="newPassword"></td>
		</tr>
		<tr>
			<th>새 비밀번호 확인</th>
			<td><input type="password" name="passwordCheck"></td>
		</tr>
	</table>
	<button type="submit">변경</button>	
	</form>
</body>
</html>