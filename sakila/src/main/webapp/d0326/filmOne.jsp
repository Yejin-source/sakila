<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<!-- Controller -->
<% 
	int filmId = Integer.parseInt(request.getParameter("filmId"));
	System.out.println("filmOne.jsp filmId: " + filmId);
	
%>


<!-- Model -->
<%
	Connection conn = null;
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	System.out.println("드라이버 로딩 성공!");
	
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	System.out.println("filmOne.jsp conn: " + conn);
	
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	// 영화 상세 정보
	String sql = "SELECT"
					+ " film_id filmId, title, description, rental_duration duration"
					+ ", rental_rate rate, length, replacement_cost cost, rating, special_features special"
				+ " FROM film WHERE film_id = ?";
	
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, filmId);
	rs = stmt.executeQuery();
	System.out.println("filmOne.jsp rs: " + rs);
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("filmId", rs.getInt("filmId"));
		map.put("title", rs.getString("title"));
		map.put("description", rs.getString("description"));
		map.put("duration", rs.getInt("duration"));
		map.put("rate", rs.getDouble("rate"));
		map.put("length", rs.getInt("length"));
		map.put("cost", rs.getDouble("cost"));
		map.put("rating", rs.getString("rating"));
		map.put("special", rs.getString("special"));
		list.add(map);
	}
	
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	
	// 출연자 정보
	String sql2 = "SELECT fa.actor_id actorId, CONCAT(first_name, ' ', last_name) name"
					+ " FROM film f INNER JOIN film_actor fa"
					+ " ON f.film_id = fa.film_id" 
					+ " INNER JOIN actor a ON fa.actor_id = a.actor_id"
					+ " WHERE f.film_id = ? ORDER BY fa.actor_id asc";
	
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1, filmId);
	rs2 = stmt2.executeQuery();
	System.out.println("filmOne.jsp rs2: " + rs2);
	
	ArrayList<HashMap<String, Object>> list2 = new ArrayList<HashMap<String, Object>>();
	while(rs2.next()) {
		HashMap<String, Object> map2 = new HashMap<String, Object>();
		map2.put("actorId", rs2.getString("actorId"));
		map2.put("name", rs2.getString("name"));
		list2.add(map2);
	}
	
%>

<!-- View -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
	<h1>영화 상세 정보</h1>
	
	<table border="1" style="width : 600px;">
			
		<%
			for(HashMap<String, Object> map : list) {
		%>			
				<tr>
					<th>filmId</th>
					<td><%=map.get("filmId")%></td>
				</tr>
				<tr>
					<th>title</th>
					<td><%=map.get("title")%></td>
				</tr>	
				<tr>
					<th>description</th>
					<td><%=map.get("description")%></td>
				</tr>
				<tr>	
					<th>duration</th>
					<td><%=map.get("duration")%></td>
				</tr>
				<tr>	
					<th>rate</th>
					<td><%=map.get("rate")%></td>
				</tr>	
				<tr>
					<th>length</th>
					<td><%=map.get("length")%></td>
				</tr>	
				<tr>
					<th>cost</th>
					<td><%=map.get("cost")%></td>
				</tr>	
				<tr>
					<th>rating</th>
					<td><%=map.get("rating")%></td>
				</tr>	
				<tr>
					<th>special features</th>
					<td><%=map.get("special")%></td>
				</tr>		
		<% 
			}
		%>
	</table>
	
	<div>
		<a href="/sakila/d0326/filmList.jsp">영화 목록으로 돌아가기</a>
	</div>
	
	<br>
	<hr>
	<h1>출연자 목록</h1>
	<table border="1">
		<tr>
			<th>actorId</th>		
			<th>name</th>
		</tr>
		
		<%
			for(HashMap<String, Object> map2 : list2) {
		%>			
				<tr>
					<td><%=map2.get("actorId")%></td>
					<td>
						<a href="/sakila/d0326/actorOne.jsp?actorId=<%=map2.get("actorId")%>">
							<%=map2.get("name")%>
						</a>
					</td>
				</tr>
		<% 
			}
		%>
	</table>
</body>
</html>