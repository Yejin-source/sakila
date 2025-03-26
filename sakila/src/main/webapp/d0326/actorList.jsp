<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<!-- Controller -->
<%
	// 페이징 준비
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 10;
	int startRow = (currentPage - 1) * rowPerPage;
	
	int pageBlock = 5;
	int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;
	int endPage = startPage + pageBlock - 1;	
%>


<!-- Model -->
<%
	Connection conn = null;

	Class.forName("com.mysql.cj.jdbc.Driver");
	System.out.println("드라이버 로딩 성공!");
	
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	System.out.println("actorList.jsp conn: " + conn);
	
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	
	// 전체 개수
	String sql = "SELECT count(*) cnt FROM actor";
	stmt = conn.prepareStatement(sql);	
	
	rs = stmt.executeQuery();
	System.out.println("actorList.jsp rs: " + rs);
	
	rs.next();
	
	
	// 페이징 준비
	int totalCnt = rs.getInt("cnt");
	int lastPage = totalCnt / rowPerPage;
	if(totalCnt % rowPerPage != 0) {
		lastPage++;
	}
	if(endPage > lastPage) {
		endPage = lastPage;
	}
			
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	
	// 배우 리스트
	String sql2 = "SELECT actor_id actorId, CONCAT(first_name, ' ', last_name) name"
					+ " FROM actor ORDER BY actor_id ASC LIMIT ?, ?";
	
	stmt2 = conn.prepareStatement(sql2);
	stmt2.setInt(1, startRow);
	stmt2.setInt(2, rowPerPage);

	rs2 = stmt2.executeQuery();
	System.out.println("actorList.jsp rs2: " + rs2);
	
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs2.next()) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("actorId", rs2.getInt("actorId"));
		map.put("name", rs2.getString("name"));
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
	<h1>배우 목록</h1>
	
	<table border="1">
		<tr>
			<th>actorId</th>		
			<th>name</th>
		</tr>
		
		<%
			for(HashMap<String, Object> map : list) {
		%>			
				<tr>
					<td><%=map.get("actorId")%></td>
					<td>
						<a href="/sakila/d0326/actorOne.jsp?actorId=<%=map.get("actorId")%>">
							<%=map.get("name")%>
						</a>
					</td>	
				</tr>
		<% 
			}
		%>
	</table>
	
	<!-- 페이징 -->
	<a href="/sakila/d0326/actorList.jsp?currentPage=1">[처음]</a>
	
	<%
		if(startPage > 1) {
	%>
			<a href="/sakila/d0326/actorList.jsp?currentPage=<%=startPage-5%>">[이전 5페이지]</a>
	<%				
		}
	%>
	
	<%
		if(currentPage > 1) {
	%>
			<a href="/sakila/d0326/actorList.jsp?currentPage=<%=currentPage-1%>">[이전]</a>
	<%		
		}
	%>
	
	<!-- 페이지 번호 -->
	<%
		for(int i=startPage; i<=endPage; i++){
			if(i == currentPage) {
	%>		
				<strong><%=i%></strong>
	<%
			} else {
	%>
				<a href="/sakila/d0326/actorList.jsp?currentPage=<%=i%>"><%=i%></a>
	<%
			}
		}
	%>
		
	<%
		if(currentPage < lastPage) {
	%>
			<a href="/sakila/d0326/actorList.jsp?currentPage=<%=currentPage+1%>">[다음]</a>
	<%		
		}
	%>
	
	<%
		if(endPage < lastPage) {
	%>
			<a href="/sakila/d0326/actorList.jsp?currentPage=<%=startPage+5%>">[다음 5페이지]</a>
	<%				
		}
	%>
	
	<a href="/sakila/d0326/actorList.jsp?currentPage=<%=lastPage%>">[마지막]</a>
</body>
</html>