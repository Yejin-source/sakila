<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!-- Controller -->
<%
	// 로그인 되었는지 아닌지
	Integer staffId = (Integer)(session.getAttribute("loginStaff"));

	if(staffId == null) { // 로그아웃 상태라면
		response.sendRedirect("/sakila/d0328/loginForm.jsp");
		return;
	}

	Integer customerId = Integer.parseInt(request.getParameter("customerId"));
	Integer active = Integer.parseInt(request.getParameter("active"));
	
	/*
		Cannot parse null string -> 값이 안 넘어와서 생긴 오류
		휴면상태 해지하기 버튼을 클릭했을 때 값이 넘어와야 하니까 searchCustomerList.jsp 에서
		<a href="/sakila/d0331/updateCustomerActive.jsp></a> 에서 값을 넘겨주도록 수정함
	*/
	
%>

<!-- Model -->
<%
	Connection conn = null;
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	System.out.println("드라이버 로딩 성공!");
	
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	System.out.println("updateCustomerActive conn: " + conn);
	
	PreparedStatement stmt = null;	
	
	// active가 0인 경우 | 0 -> 1
	String sql = "UPDATE customer SET active = 1 WHERE customer_id = ?";
	
	// active가 1인 경우 | 1 -> 0
	if(active == 1) {
		sql = "UPDATE customer SET active = 0 WHERE customer_id = ?";
	} 
	
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, customerId);
	System.out.println("updateCustomerActive stmt: " + stmt);
	
	int row = stmt.executeUpdate();
	
	if(row == 1) {
		System.out.println("휴먼 해지 완료");
	} else {
		System.out.println("휴먼 해지 실패");
	}
	
	response.sendRedirect("/sakila/d0327/inventoryList.jsp");
%>