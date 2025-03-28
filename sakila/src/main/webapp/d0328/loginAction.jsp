<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
	// controller layer : staffId, password
	int staffId = Integer.parseInt(request.getParameter("staffId"));
	String password = request.getParameter("password");
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	System.out.println("드라이버 로딩 성공!");
	
	Connection conn = null;
	PreparedStatement stmt = null;
	ResultSet rs = null;

	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	System.out.println("conn: " + conn);
	
	String sql = "SELECT staff_id staffId, first_name firstName FROM staff WHERE staff_id = ? AND password = ?";
	stmt = conn.prepareStatement(sql);	
	stmt.setInt(1, staffId);
	stmt.setString(2, password);
	
	rs = stmt.executeQuery();

	if(rs.next()) {
		// 로그인 성공
		// isLogin = true;
		System.out.println("로그인 성공");
		// 로그인 성공시 현재 세션 영역에 loginStaff 변수를 생성 (이 변수가 접속자의 세션에 있다면 로그인 상태, 없다면 로그아웃 상태)
		session.setAttribute("loginStaff", rs.getInt("staffId")); 
		response.sendRedirect("/sakila/index.jsp");
	} else {
		// 로그인 실패
		System.out.println("로그인 실패");
		response.sendRedirect("/sakila/d0328/loginForm.jsp");		
	}
%>