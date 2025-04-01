<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!-- Controller -->
<%
	// 로그인 확인
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));
	if(staffId == null) { // 로그아웃 상태면
		response.sendRedirect("/sakila/d0327/loginForm.jsp");
		return;
	}
	
	Integer customerId = Integer.parseInt(request.getParameter("customerId"));
	Integer inventoryId = Integer.parseInt(request.getParameter("inventoryId"));

%>

<!-- Model -->
<%
	Connection conn = null;
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	System.out.println("드라이버 로딩 성공!");
	
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	System.out.println("insertRentalForm conn: " + conn);
	
	PreparedStatement stmt = null;	

	String sql = "UPDATE rental SET return_date = now() WHERE customer_id = ? AND inventory_id = ?";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, customerId);
	stmt.setInt(2, inventoryId);
	
	int row = stmt.executeUpdate();
	
	response.sendRedirect("/sakila/d0325/rentalList.jsp");
%>
