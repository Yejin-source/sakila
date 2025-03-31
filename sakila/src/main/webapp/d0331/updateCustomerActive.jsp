<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!-- Controller -->
<%
	// 로그인 되었는지 아닌지
	Integer staffId = (Integer)session.getAttribute("loginStaff");

	if(staffId == null) { // 로그아웃 상태라면
		response.sendRedirect("/sakila/d0328/loginForm.jsp");
	}

	Integer active = Integer.parseInt(request.getParameter("active"));
	Integer customerId = Integer.parseInt(request.getParameter("customerId"));
	
%>

<!-- Model -->
<%
	Connection conn = null;
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	System.out.println("드라이버 로딩 성공!");
	
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	System.out.println("updateCustomerActive conn: " + conn);
	
	PreparedStatement stmt = null;	
	ResultSet rs = null;
	
	// active가 0인 경우
	String sql = "UPDATE customer SET active = 1 WHERE customer_id = ?";
	
	// active가 1인 경우
	if(active == 1) {
		sql = "UPDATE customer SET active = 0 WHERE customer_id = ?";
	} 
	
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, customerId);
	System.out.println("updateCustomerActive stmt: " + stmt);
	rs = stmt.executeQuery();
	
	response.sendRedirect("/sakila/d0327/inventoryList.jsp");
%>