<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<!-- Controller -->
<%
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 10;
	int startRow = (currentPage - 1) * rowPerPage;
	
	int pageBlock = 5;
	int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;
	int endPage = startPage + pageBlock - 1;
	
	
	String searchWord = request.getParameter("searchWord");
	
	
	if(searchWord == null) {
		searchWord = "";
	}
	System.out.println("searchWord: " + searchWord);
	
%>


<!-- Model -->
<%
	Connection conn = null;
	
	Class.forName("com.mysql.cj.jdbc.Driver");
	System.out.println("드라이버 로딩 성공!");
	
	conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/sakila", "root", "java1234");
	System.out.println("conn: " + conn);
	
	PreparedStatement stmt = null;
	ResultSet rs = null;
	
	
	// 전체 개수
	String sql = "SELECT COUNT(*) cnt"
					+ " FROM (SELECT i.inventory_id, i.film_id, t.return_date,"
					+ " CASE WHEN t.rental_date IS NULL THEN '대여가능'"
					+ " WHEN t.return_date IS NULL THEN '대여중' ELSE '대여가능' END isRental"
					+ " FROM inventory i LEFT JOIN (SELECT inventory_id, rental_date, return_date FROM rental"
					+ " WHERE (inventory_id, rental_date) IN (SELECT inventory_id, MAX(rental_date)"
					+ " FROM rental GROUP BY inventory_id)) t ON i.inventory_id = t.inventory_id) t"
					+ " INNER JOIN film f ON t.film_id = f.film_id";
	stmt = conn.prepareStatement(sql);	
	
	/*
		IN ->  조건을 만족하는지 확인
		t는 다른 범위에서 별칭으로 사용하고 있기 때문에 중복 사용 가능
	*/
	
	// 검색어가 있을 때 개수
	if(!searchWord.equals("")) {
		sql += " WHERE title LIKE ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%" + searchWord + "%");
	}
	
	rs = stmt.executeQuery();
	System.out.println("rs: " + rs);
	
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
	
	// 검색 쿼리
	String sql2 = "SELECT t1.inventory_id inventoryId, t1.title title, t1.store_id storeId, t2.isRental isRental"
				+ " FROM (SELECT i.inventory_id, f.title, i.store_id"
				+ " FROM inventory i INNER JOIN film f"
				+ " ON i.film_id = f.film_id) t1"
				+ " LEFT OUTER JOIN"
				+ " (SELECT inventory_id, rental_date,"
				+ " CASE WHEN return_date IS NULL THEN '대여중' ELSE '대여가능' END isRental"
				+ " FROM rental WHERE (inventory_id, rental_date)"
				+ " IN (SELECT inventory_id, MAX(rental_date)"
				+ " FROM rental GROUP BY inventory_id)) t2"
				+ " ON t1.inventory_id = t2.inventory_id";
	
	// 검색어가 없을 때
	if(searchWord.equals("")) {
		sql2 += " LIMIT ?, ?";
		stmt2 = conn.prepareStatement(sql2);
		stmt2.setInt(1, startRow);
		stmt2.setInt(2, rowPerPage);
		
	} else if(!searchWord.equals("")) { // 검색어가 있을 때
		sql2 += " WHERE t1.title LIKE ? LIMIT ?, ?";
		stmt2 = conn.prepareStatement(sql2);
		stmt2.setString(1, "%" + searchWord + "%");
		stmt2.setInt(2, startRow);
		stmt2.setInt(3, rowPerPage);
	}
	
	rs2 = stmt2.executeQuery();
	System.out.println("rs2: " + rs2);
	
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs2.next()) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("inventoryId", rs2.getInt("inventoryId"));
		map.put("title", rs2.getString("title"));
		map.put("storeId", rs2.getInt("storeId"));
		map.put("isRental", rs2.getString("isRental"));
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
	<h1>Inventory List</h1>
	<form action="/sakila/d0327/inventoryList.jsp">
	title : 
	<input type="text" name="searchWord" value="<%=searchWord%>">
	<button type="submit">검색</button>
	</form>
	
	<table border="1">
		<tr>
			<th>Id</th>
			<th>Title</th>
			<th>Store</th>			
			<th>Return Date</th>
			<th>Rental Link</th>
		</tr>
		
		<%
			for(HashMap<String, Object> map : list) {
		%>			
				<tr>
					<td><%=map.get("inventoryId")%></td>
					<td><%=map.get("title")%></td>
					<td><%=map.get("storeId")%>지점</td>
					<td><%=map.get("isRental")%></td>
					<td>
						<%
							String rentalLink = String.valueOf(map.get("isRental"));
							if(rentalLink.equals("대여가능")) {
						%>
								<a href="/sakila/d0331/insertRentalForm.jsp?inventoryId=1">대여하기</a>
						<%		
							} else {
						%>		
								<a href="">반납하기</a>
						<%		
							}
						%>
					</td>	
				</tr>
		<% 
			}
		%>
	</table>
	
	<!-- 페이징 -->
	<a href="/sakila/d0327/inventoryList.jsp?currentPage=1">[처음]</a>
	
	<%
		if(startPage > 1) {
	%>
			<a href="/sakila/d0327/inventoryList.jsp?searchWord=<%=searchWord%>&currentPage=<%=startPage-5%>">[이전 5페이지]</a>
	<%				
		}
	%>
	
	<%
		if(currentPage > 1) {
	%>
			<a href="/sakila/d0327/inventoryList.jsp?searchWord=<%=searchWord%>&currentPage=<%=currentPage-1%>">[이전]</a>
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
				<a href="/sakila/d0327/inventoryList.jsp?searchWord=<%=searchWord%>&currentPage=<%=i%>"><%=i%></a>
	<%
			}
		}
	%>
		
	<%
		if(currentPage < lastPage) {
	%>
			<a href="/sakila/d0327/inventoryList.jsp?searchWord=<%=searchWord%>&currentPage=<%=currentPage+1%>">[다음]</a>
	<%		
		}
	%>
	
	<%
		if(endPage < lastPage) {
	%>
			<a href="/sakila/d0327/inventoryList.jsp?searchWord=<%=searchWord%>&currentPage=<%=startPage+5%>">[다음 5페이지]</a>
	<%				
		}
	%>
	
	<a href="/sakila/d0327/inventoryList.jsp?searchWord=<%=searchWord%>&currentPage=<%=lastPage%>">[마지막]</a>
</body>
</html>