<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>

<!-- Controller -->
<%
	String searchWord = request.getParameter("searchWord");
	System.out.println("searchWord: " + searchWord);
	
	if(searchWord == null) {
		searchWord = "";
	}	
	
	int storeId = 0;										// isEmpty() -> 빈 문자열인지 확인하는 메서드
	if(request.getParameter("storeId") != null && !request.getParameter("storeId").isEmpty()) {
		storeId = Integer.parseInt(request.getParameter("storeId"));
	}
	System.out.println("storeId: " + storeId);
		
	
	// 페이징 설정
	int currentPage = 1;
	if(request.getParameter("currentPage") != null) {
		currentPage = Integer.parseInt(request.getParameter("currentPage"));
	}
	
	int rowPerPage = 15; // 페이징 당 보여줄 행의 개수
	int startRow = (currentPage - 1) * rowPerPage; 

	int pageBlock = 10; // 5 페이지씩 표시
	int startPage = ((currentPage - 1) / pageBlock) * pageBlock + 1;
	int endPage = startPage + pageBlock - 1;
	
	/*
		currentPage 1 ~ 10   | startPage 1  | endPage 10
		currentPage 11 ~ 20  | startPage 11 | endPage 20
		currentPage 21 ~ 30  | startPage 21 | endPage 30
	*/
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


	String sql = "SELECT COUNT(*)"
				+ " FROM rental r INNER JOIN inventory i"
				+ " ON r.inventory_id = i.inventory_id"
				+ " INNER JOIN film f"
				+ " ON i.film_id = f.film_id"
				+ " INNER JOIN customer c"
				+ " ON r.customer_id = c.customer_id";
	
	// 검색어가 없을 때 개수
	if(searchWord.equals("")) {
		
		if(storeId == 0) { // Store 전체로 선택
			stmt = conn.prepareStatement(sql);
		
		} else { // 1지점 or 2지점으로 선택
			sql += " WHERE c.store_id = ?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, storeId);	
		}
		
	} else if(!searchWord.equals("")) { // 검색어가 있을 때 개수
		
		if(storeId == 0) { // Store 전체로 선택
			sql += " WHERE f.title like ?";
			stmt = conn.prepareStatement(sql);
			stmt.setString(1, "%" + searchWord + "%");
			
		} else { // 1지점 or 2지점으로 선택
			sql += " WHERE c.store_id = ? AND f.title LIKE ?";
			stmt = conn.prepareStatement(sql);
			stmt.setInt(1, storeId);	
			stmt.setString(2, "%" + searchWord + "%");	
		}
	}
	
	rs = stmt.executeQuery();
	System.out.println("rs: " + rs);
	
	rs.next();
	
	int totalCnt = rs.getInt("count(*)");
	int lastPage = totalCnt / rowPerPage;
	if(totalCnt % rowPerPage != 0) {
		lastPage++;
	}
	
	
	/*
	SELECT 
		r.rental_id rentalId, 
		r.rental_date rentalDate, 
		r.inventory_id inventoryId, 
		r.customer_id customerId, 
		r.return_date returnDate,
		i.film_id filmId,
		f.title filmTitle,
		c.store_id storeId,
		CONCAT(c.first_name, ' ', c.last_name, '(', c.customer_id, ')') name
	FROM rental r INNER JOIN inventory i
	ON r.inventory_id = i.inventory_id
		INNER JOIN film f
		ON i.film_id = f.film_id
			INNER JOIN customer c
			ON r.customer_id = c.customer_id
			ORDER BY returnDate DESC LIMIT ?, ?;
	*/
	
	PreparedStatement stmt2 = null;
	ResultSet rs2 = null;
	
	String sql2 = "SELECT r.rental_id rentalId, r.rental_date rentalDate"
					+ " , r.inventory_id inventoryId, r.customer_id customerId"
					+ " , r.return_date returnDate, i.film_id filmId" 
					+ " , f.title filmTitle, c.store_id storeId"
					+ " , CONCAT(c.first_name, ' ', c.last_name, '(', c.customer_id, ')') name"
					+ " FROM rental r INNER JOIN inventory i"
					+ " ON r.inventory_id = i.inventory_id"
					+ " INNER JOIN film f"
					+ " ON i.film_id = f.film_id"
					+ " INNER JOIN customer c"
					+ " ON r.customer_id = c.customer_id";
	
	// 검색어가 없을 때 전체 값 검색
	if(searchWord.equals("")) {
		
		if(storeId == 0) { // Store 전체로 선택
			sql2 += " ORDER BY returnDate DESC LIMIT ?, ?";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setInt(1, startRow);
			stmt2.setInt(2, rowPerPage);
			
		} else { // 1지점 or 2지점으로 선택
			sql2 += " WHERE c.store_id = ? ORDER BY returnDate DESC LIMIT ?, ?";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setInt(1, storeId);
			stmt2.setInt(2, startRow);
			stmt2.setInt(3, rowPerPage);		
		}
		
	} else if(!searchWord.equals("")) { // 검색어가 있을 때 조건 검색
		
		if(storeId == 0) { // Store 전체로 선택 후 조건 검색
			sql2 += " WHERE f.title LIKE ? ORDER BY returnDate DESC LIMIT ?, ?";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setString(1, "%" + searchWord + "%");
			stmt2.setInt(2, startRow);
			stmt2.setInt(3, rowPerPage);
			
		} else { // 1지점 or 2지점으로 선택 후 조건 검색
			sql2 += " WHERE c.store_id = ? AND f.title LIKE ? ORDER BY returnDate DESC LIMIT ?, ?";
			stmt2 = conn.prepareStatement(sql2);
			stmt2.setInt(1, storeId);
			stmt2.setString(2, "%" + searchWord + "%");
			stmt2.setInt(3, startRow);
			stmt2.setInt(4, rowPerPage);	
		}
	}
	
	rs2 = stmt2.executeQuery();
	System.out.println("rs2: " + rs2);
	
	ArrayList<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
	while(rs2.next()) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("rentalId", rs2.getString("rentalId"));
		map.put("filmTitle", rs2.getString("filmTitle"));
		map.put("inventoryId", rs2.getString("inventoryId"));
		map.put("name", rs2.getString("name"));
		map.put("rentalDate", rs2.getString("rentalDate"));
		map.put("returnDate", rs2.getString("returnDate"));
		list.add(map);
	}
		

%>

<!-- view -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title></title>
</head>
<body>
	<h1>Rental List</h1>
	<form action="/sakila/d0325/rentalList.jsp">
		Store :
		<select name="storeId">
			<option value="0" <% if(storeId == 0) { %> selected="selected" <% } %>>전체</option>
			<option value="1" <% if(storeId == 1) { %> selected="selected" <% } %>>1지점</option>
			<option value="2" <% if(storeId == 2) { %> selected="selected" <% } %>>2지점</option>
		</select>
		<button type="submit">검색</button>
	</form>
	
	<table border="1">
		<tr>
			<th>rentalId</th>
			<th>filmTitle</th>
			<th>inventoryId</th>
			<th>name(customerId)</th><!-- name = first_name + last_name -->
			<th>rentalDate</th>
			<th>returnDate</th>
		</tr>
		
		<%
			for(HashMap<String, Object> map: list) {
		%>		
				<tr>
					<td><%=map.get("rentalId")%></td>
					<td><%=map.get("filmTitle")%></td>
					<td><%=map.get("inventoryId")%></td>
					<td><%=map.get("name")%></td>
					<td><%=map.get("rentalDate")%></td>
					<td>
						<%
							if(map.get("returnDate") == null) {
						%>
								Not returned
						<%		
							} else {
						%>
								<%=map.get("returnDate")%>
						<%
							}
						%>
					</td>
				</tr>		
		<%
			}
		%>
	
	</table>
	
	<a href="/sakila/d0325/rentalList.jsp?currentPage=1">[처음]</a>
	
	<%
		if(startPage > 1) {
	%>
			<a href="/sakila/d0325/rentalList.jsp?storeId=<%=storeId%>&searchWord=<%=searchWord%>&currentPage=<%=startPage-10%>">[이전 10페이지]</a>
	<%
		}
	%>
	
	<%
		if(currentPage > 1) {
	%>
			<a href="/sakila/d0325/rentalList.jsp?storeId=<%=storeId%>&searchWord=<%=searchWord%>&currentPage=<%=currentPage-1%>">[이전]</a>
	<%
		}
	%>
	
	
	<!-- 페이지 번호 -->
	<%
		for(int i=startPage; i<=endPage; i++) {
			if(i == currentPage) {
	%>			
				<strong><%=i%></strong>
	<%					
			} else {
	%>
				<a href="/sakila/d0325/rentalList.jsp?storeId=<%=storeId%>&searchWord=<%=searchWord%>&currentPage=<%=i%>"><%=i%></a>
	<%		
			}
		}
	%>
	
	
	<%
		if(currentPage < lastPage) {
	%>
			<a href="/sakila/d0325/rentalList.jsp?storeId=<%=storeId%>&searchWord=<%=searchWord%>&currentPage=<%=currentPage+1%>">[다음]</a>
	<%
		}
	%>
	
	<%
		if(endPage < lastPage) {
	%>
			<a href="/sakila/d0325/rentalList.jsp?storeId=<%=storeId%>&searchWord=<%=searchWord%>&currentPage=<%=startPage+10%>">[다음 10페이지]</a>
	<%
		}
	%>
	
	<a href="/sakila/d0325/rentalList.jsp?storeId=<%=storeId%>&searchWord=<%=searchWord%>&currentPage=<%=lastPage%>">[마지막]</a>
	
	<form action="/sakila/d0325/rentalList.jsp">
		<input type="hidden" name="storeId" value="<%=storeId%>">
		filmTitle Search Word :
		<input type="text" name="searchWord" value="<%=searchWord%>">
		<button type="submit">검색</button>
	</form>
</body>
</html>