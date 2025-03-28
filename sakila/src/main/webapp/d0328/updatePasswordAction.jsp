<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<!-- Controller -->
<%
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	
	if(staffId == null) { // 로그아웃 상태라면
		// 로그인 페이지로 리다이렉트
		response.sendRedirect("/sakila/d0328/loginForm.jsp");	
		return;
	}	

	String password = request.getParameter("password");
	String newPassword = request.getParameter("newPassword");
	String passwordCheck = request.getParameter("passwordCheck");
	
	System.out.println("updatePasswordAction password: " + password);
	System.out.println("updatePasswordAction newPassword: " + newPassword);
	System.out.println("updatePasswordAction passwordCheck: " + passwordCheck);
	
%>

<!-- Model -->
<%
	
	if(!newPassword.equals(passwordCheck)) { // 비밀번호 확인에서 틀린 경우
		System.out.println("새 비밀번호와 비밀번호 확인이 일치하지 않습니다.");
		response.sendRedirect("/sakila/d0328/updatePasswordForm.jsp");	
		return; 
	} else if(newPassword.equals(password)) { // 현재 비밀번호와 똑같이 설정한 경우
		System.out.println("비밀번호 재작성 필요");
		response.sendRedirect("/sakila/d0328/updatePasswordForm.jsp");
		return;
	}

	Connection conn = null;
	PreparedStatement stmt = null;
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	System.out.println("드라이버 로딩 성공!");
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	System.out.println("updatePasswordAction conn: " + conn);
	
	String sql = "UPDATE staff SET password = ? WHERE staff_id = ? AND password = ?";
	stmt = conn.prepareStatement(sql); 
	stmt.setString(1, newPassword);
	stmt.setInt(2, staffId);
	stmt.setString(3, password);
	int row = stmt.executeUpdate(); // 영향을 받은 행의 개수 반환
	System.out.println("updatePasswordAction row: " + row);
	
	if(row == 1) {
		// 비밀번호 변경 성공
		System.out.print("비밀번호 변경되었습니다.");
		response.sendRedirect("/sakila/d0328/loginForm.jsp");
	} else {
		// 비밀번호 변경 실패 | 현재 비밀번호를 틀린 경우
		System.out.print("비밀번호를 정확하게 입력해 주세요.");
		response.sendRedirect("/sakila/d0328/updatePasswordForm.jsp");		
	}

%>