<%@page import="test.file.dao.FileDao"%>
<%@page import="test.file.dto.FileDto"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/*
		http://servlets.com/cos/ 에서 압축 파일을 받아서
		안에 들어있는 cos.jar 파일을
		WEB-INF/lib/ 폴더에 넣어주면 아래와 같이 파일 업로드
		처리를 할 수 있다.
	*/

	//파일을 저장할 폴더의 절대 경로를 얻어온다.
	String realPath=application.getRealPath("/upload"); //application 객체는 기본 객체이다.
	//콘솔에 테스트로 출력해보기
	System.out.println(realPath);
	//최대 업로드 사이즈
	int sizeLimit=1024*1000*50;  //50 Mbyte
	//cos.jar 라이브러리에 있는 클래스를 이용해서 객체 생성하기
	//객체가 생성되는 시점에 /upload 폴더에 자동 파일이 저장된다.
	MultipartRequest mr=new MultipartRequest(request,
			realPath, //파일 저장 경로
			sizeLimit, //사이즈 제한
			"utf-8", //파일명 한글 처리
			new DefaultFileRenamePolicy()); //파일명 겹치지 않도록
			
	//업로드된 파일에 대한 정보는 mr 객체를 통해서 얻어온다.
	String writer=mr.getParameter("writer");
	String title=mr.getParameter("title");
	String orgFileName=mr.getOriginalFileName("myFile");
	String saveFileName=mr.getFilesystemName("myFile");
	long fileSize=mr.getFile("myFile").length();
	//파일의 정보를 FileDto 객체에 담아서
	FileDto dto=new FileDto();
	dto.setWriter(writer);
	dto.setTitle(title);
	dto.setOrgFileName(orgFileName);
	dto.setSaveFileName(saveFileName);
	dto.setFileSize(fileSize);
	//FileDao 객체를 이용해서 DB 에 저장하고
	boolean isSuccess=FileDao.getInstance().insert(dto);
	//응답한다.
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>file/insert.jsp</title>
</head>
<body>
<%if(isSuccess){ %>
	<p>파일을 업로드 했습니다.</p>
	<a href="list.jsp">목록 보기</a>
<%}else{ %>
	<p>업로드 실패</p>
	<a href="insertform.jsp">파일 업로드 하기</a>
<%} %>
</body>
</html>