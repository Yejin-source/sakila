<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
	// 로그인 session 검증
	Integer inventoryId = Integer.parseInt(request.getParameter("inventoryId"));
	String searchName = request.getParameter("searchName");			
%>

<%
	Connection conn = null;
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	System.out.println("드라이버 로딩 성공!");
	
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	System.out.println("returnCustomerList conn: " + conn);
	
	PreparedStatement stmt = null;	
	ResultSet rs = null;
	
	String sql = "SELECT customer_id customerId, first_name firstName, last_name lastName, email, active" 
					+ " FROM customer WHERE CONCAT(first_name, last_name) LIKE ?";
	stmt = conn.prepareStatement(sql);	
	stmt.setString(1, "%"+ searchName + "%");
	System.out.println("returnCustomerList stmt: " + stmt);
	rs = stmt.executeQuery();

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
	<h1>Search Customer List</h1>
	<table border="1">
		<tr>
			<td>customerId</td>
			<td>firstName</td>
			<td>lastName</td>
			<td>email</td>
			<td>active</td>
			<td>choose</td>
		</tr>
		<%
			while(rs.next()) {
		%>	
				<tr>
					<td><%=rs.getInt("customerId")%></td>
					<td><%=rs.getString("firstName")%></td>
					<td><%=rs.getString("lastName")%></td>
					<td><%=rs.getString("email")%></td>
					<td><%=rs.getInt("active")%></td>
					<td>
						<%
							if(rs.getInt("active") == 0) {
						%>
								<a href='/sakila/d0331/updateCustomerActive.jsp?customerId=<%=rs.getInt("customerId")%>&active=<%=rs.getInt("active")%>'>
									휴면상태 해지하기 <!-- customer.active 0을 1로 변경 -->
								</a>
						<%		
							} else {
						%>
								<a href='/sakila/d0401/returnForm.jsp?customerId=<%=rs.getInt("customerId")%>&inventoryId=<%=inventoryId%>'>
									선택
								</a>
						<%		
							}
						%>
					</td>
				</tr>
		<%		
			}
		%>
	</table>
</body>
</html>