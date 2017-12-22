<%@page import="test.file.dao.FileDao"%>
<%@page import="test.file.dto.FileDto"%>
<%@page import="org.apache.commons.fileupload.FileItem"%>
<%@page import="java.util.List"%>
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="java.io.PrintWriter"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	/*
		http://mvnrepository.com/ 에서
		commons io 검색해서 commons-io.jar 파일 다운로드
		commons fileupload 검색해서 commons-fileupload 파일 다운로드
		해서
		WEB-INF/lib/ 폴더 안에 넣으면 아래와 같이 파일 업로드 처리를
		할 수 있다.
	*/
	
	//업로드 설정
	final int MEMORY_THRESHOLD   = 1024 * 1024 * 3;  // 3MB
	final int MAX_FILE_SIZE      = 1024 * 1024 * 40; // 40MB
	final int MAX_REQUEST_SIZE   = 1024 * 1024 * 50; // 50MB
		
	//실제로 업로드한 파일이 있는지 체크 한다.
	if (!ServletFileUpload.isMultipartContent(request)) {
		//업로드한 파일이 없다면 예외 처리를 한다. 
	    PrintWriter writer = response.getWriter();
	    writer.println("Error: Form must has enctype=multipart/form-data.");
	    writer.flush();
	    return;
	}

	// configures upload settings
	DiskFileItemFactory factory = new DiskFileItemFactory();
	// sets memory threshold - beyond which files are stored in disk
	factory.setSizeThreshold(MEMORY_THRESHOLD);
	// sets temporary location to store files
	factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
	ServletFileUpload upload = new ServletFileUpload(factory);
	// sets maximum size of upload file
	upload.setFileSizeMax(MAX_FILE_SIZE);
	// sets maximum size of request (include file + form data)
	upload.setSizeMax(MAX_REQUEST_SIZE);

	//WebContent 하위의 upload 폴더 절대 경로 얻어오기 
	String uploadPath = application.getRealPath("/upload");
	//전송된 파라미터의 한글 인코딩 설정 
	upload.setHeaderEncoding("utf-8");
	    
	//작업 성공여부
	boolean isSuccess=false;
	    
	try {
		//폼전송된 아이템 목록 얻어오기 
	    List<FileItem> formItems = upload.parseRequest(request);
	    //폼전송된 아이템이 존재 한다면 
	    if (formItems != null && formItems.size() > 0) {
	    	//파일 정보를 담을 Dto 객체 생성
	        FileDto dto=new FileDto();
	        	
	        //반복문 돌면서 FileItem 객체를 불러온다. 
	        for (FileItem item : formItems) {
	            	
	        	//아이템이 폼 필드인지 아닌지에 따라 선택적인 처리를 한다.
	            if (!item.isFormField()) {//만일 파일 필드라면...
	            	//전송된 원본 파일명을 얻어온다. 
	                String orgFileName = new File(item.getName()).getName();
	                //저장할 파일명 구성
	                String saveFileName = System.currentTimeMillis()+orgFileName;
	                //파일 시스템에 저장할 전체 경로를 구성한다.
	                String filePath = 
	                   	uploadPath + File.separator + saveFileName;
	                //파일을 파일시스템에 저장한다.
	                File storeFile = new File(filePath);
	                item.write(storeFile);
	                //원본 파일명과 저장된 파일명을 FileDto 객체에 담는다.
	                dto.setOrgFileName(orgFileName);
	                dto.setSaveFileName(saveFileName);
	                //파일 사이즈도 담는다?
	                dto.setFileSize(item.getSize());
	                    
	            }else{//폼 필드라면 
	               	if(item.getFieldName().equals("writer")){
	                	//작성자 읽어오기 
	                	String writer=item.getString("utf-8");
	                	dto.setWriter(writer);
	                }
	                if(item.getFieldName().equals("title")){
	                	//제목 읽어오기
	                	String title=item.getString("utf-8");
	                	dto.setTitle(title);
	                }
	            }//if
	        }//for
	        //DB 에 파일 정보를 저장한다.
	        isSuccess=FileDao.getInstance().insert(dto);
	   }//if
	        
	} catch (Exception ex) {
		System.out.println(ex.getMessage());
	}	
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>file/insert_commons.jsp</title>
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