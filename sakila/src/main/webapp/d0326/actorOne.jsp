<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<!-- Controller -->
<%
	int actorId = Integer.parseInt(request.getParameter("actorId"));
	System.out.println("actorOne.jsp actorId: " + actorId);
%>

<!-- Model -->
<%
	Connection conn = null;
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	System.out.println("드라이버 로딩 성공!");
	
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	System.out.println("actorOne.jsp conn: " + conn);
	
	PreparedStatement stmt = null;
	ResultSet rs = null;

	// 출연한 작품
	String sql = "SELECT f.film_id filmId, f.title title, fa.actor_id actorId"
					+ ", CONCAT(first_name, ' ', last_name) name"
					+ " FROM film f INNER JOIN film_actor fa"
					+ " ON f.film_id = fa.film_id" 
					+ " INNER JOIN actor a ON fa.actor_id = a.actor_id"
					+ " WHERE fa.actor_id = ? ORDER BY f.film_id asc";
	
	stmt = conn.prepareStatement(sql);
	stmt.setInt(1, actorId);
	rs = stmt.executeQuery();
	System.out.println("actorOne.jsp rs: " + rs);
	

	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs.next()) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("filmId", rs.getInt("filmId"));
		map.put("title", rs.getString("title"));
		list.add(map);
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
	<h1>출연 영화 정보</h1>
	
	<div>
		<a href="/sakila/d0326/filmList.jsp">영화 목록 보기</a>
		&nbsp; &nbsp;
		<a href="/sakila/d0326/actorList.jsp">배우 목록 보기</a>
	</div>

	<table border="1">
		<tr>
			<th>filmId</th>		
			<th>title</th>
		</tr>
		
		<%
			for(HashMap<String, Object> map : list) {
		%>			
				<tr>
					<td><%=map.get("filmId")%></td>
					<td>
						<a href="/sakila/d0326/filmOne.jsp?filmId=<%=map.get("filmId")%>">
							<%=map.get("title")%>
						</a>
					</td>
				</tr>
		<% 
			}
		%>
	</table>
</body>
</html>