<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<!-- Controller -->
<%
	// 로그인 되었는지 아닌지
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));	
	// 세션에서 loginStaff 키에 저장된 값을 가져옴 
	// session.getAttribute("loginStaff") 반환값은 Object 타입 -> Integer로 반환
			
	if(staffId == null) { // 로그아웃 상태라면
		response.sendRedirect("/sakila/d0328/loginForm.jsp");	
		return;
	}
	
	Integer inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
	Integer customerId = Integer.parseInt(request.getParameter("customerId"));
%>


<!-- Model -->
<%
	Connection conn = null;
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	System.out.println("드라이버 로딩 성공!");
	
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	System.out.println("insertRentalForm conn: " + conn);
	
	PreparedStatement stmt = null;	
	
	String sql = "INSERT INTO rental(inventory_id, customer_id, staff_id) values(?,?,?)";
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, inventoryId);
	stmt.setInt(2, customerId);
	stmt.setInt(3, staffId);
	stmt.executeUpdate();
	
	response.sendRedirect("/sakila/d0325/rentalList.jsp");
%>