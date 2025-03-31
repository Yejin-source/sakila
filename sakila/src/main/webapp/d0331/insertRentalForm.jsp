<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
	// staff 로그인 session 확인
	
	Integer inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
	Integer staffId = (Integer)session.getAttribute("loginStaff");
	Integer customerId = null;
	if(request.getParameter("customerId") != null) {
		// 이름 검색 후 이 페이지가 다시 요청되면 customerId 값을 받아옴 
		customerId = Integer.parseInt(request.getParameter("customerId"));		
	}
%>

<%
	Connection conn = null;
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	System.out.println("드라이버 로딩 성공!");
	
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	System.out.println("insertRentalForm conn: " + conn);
	
	PreparedStatement stmt = null;	
	ResultSet rs = null;
	
	String sql = "SELECT i.inventory_id inventoryId, i.film_id filmId, f.title, i.store_id storeId" 
				+ " FROM inventory i INNER JOIN film f on i.film_id = f.film_id WHERE inventory_id = ?";
	stmt = conn.prepareStatement(sql);	
	stmt.setInt(1, inventoryId);
	System.out.println("insertRentalForm stmt: " + stmt);
	rs = stmt.executeQuery();
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
	<h1>Insert Rental Inventory</h1>
	<%
		if(rs.next()) {
	%>
		<form action="/sakila/d0331/searchCustomerList.jsp" method="post">
			<input type="hidden" name="inventoryId" value="<%=inventoryId%>">
			<input type="text" name="searchName">
			<button type="submit">이름으로 customerId 검색</button>
		</form>
		<!-- 
			insertRentalForm.jsp -> 이름검색 -> customerListByName.jsp -> insertRentalForm.jsp
		 -->
		
		<form action="/sakila/d0331/insertRentalAction.jsp" method="post">
			<table border="1">
				<tr>
					<td>customerId</td>
					<td>
						<input type="text" name="customerId" value="<%=customerId%>" readonly>
					</td>
				</tr>
				<tr>
					<td>inventoryId</td>
					<td>
						<input type="text" name="inventoryId" value="<%=inventoryId%>" readonly>
					</td>
				</tr>
				<tr>
					<td>filmId</td>
					<td>
						<input type="text" name="filmId" value="<%=rs.getInt("filmId")%>" readonly>
						<%=rs.getString("title")%>
					</td>
				</tr>
				<tr>
					<td>storeId</td>
					<td><input type="text" name="storeId" value="<%=rs.getInt("storeId")%>" readonly></td>
				</tr>
				<tr>
					<td>staffId</td>
					<td><input type="text" name="staffId" value="<%=staffId%>" readonly></td>
				</tr>
			</table>
			<button type="submit">대여하기</button>
		</form>	
	<%		
		}
	%>
</body>
</html>