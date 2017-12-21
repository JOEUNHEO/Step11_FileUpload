<%@page import="java.util.List"%>
<%@page import="test.file.dto.FileDto"%>
<%@page import="test.file.dao.FileDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>file/list.jsp</title>
</head>
<body>
<%
	//파일 목록을 불러오기
	List<FileDto> list = FileDao.getInstance().getList();
%>
<a href="insertform.jsp">파일 올리기</a>
<h3>파일 목록입니다.</h3>
<table>
	<thead>
		<tr>
			<th>번호</th>
			<th>작성자</th>
			<th>제목</th>
			<th>파일명</th>
			<th>크기</th>
			<th>등록일</th>
			<th>삭제</th>
		</tr>
	</thead>
	<tbody>
	<%for(FileDto tmp:list){ %>
		<tr>
			<td><%=tmp.getNum() %></td>
			<td><%=tmp.getWriter() %></td>
			<td><%=tmp.getTitle() %></td>
			<td><a href="download.jsp?num=<%=tmp.getNum() %>"><%=tmp.getOrgFileName() %></a></td>
			<td><%=tmp.getFileSize() %> byte</td>
			<td><%=tmp.getRegdate() %></td>
			<td><a href="delete.jsp?num=<%=tmp.getNum() %>">삭제</a></td>
		</tr>
	<%} %>
	</tbody>
</table>
</body>
</html>