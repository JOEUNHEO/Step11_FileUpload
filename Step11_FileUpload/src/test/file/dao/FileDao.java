package test.file.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import test.file.dto.FileDto;
import test.util.DbcpBean;

public class FileDao {
	private static FileDao dao;
	
	private FileDao() {}
	
	public static FileDao getInstance() {
		if(dao == null) {
			dao = new FileDao();
		}
		
		return dao;
	}
	
	//파일 정보를 저장하는 메소드 insert()
	public boolean insert(FileDto dto) {
		boolean isSuccess = false;
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			conn = new DbcpBean().getConn();
			String sql = "INSERT INTO board_data(num, writer, title, orgFileName, saveFileName, fileSize, regdate)" +
			"VALUES(board_data_seq.NEXTVAL,?,?,?,?,?,SYSDATE)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getWriter());
			pstmt.setString(2, dto.getTitle());
			pstmt.setString(3, dto.getOrgFileName());
			pstmt.setString(4, dto.getSaveFileName());
			pstmt.setLong(5, dto.getFileSize());
			
			int flag = pstmt.executeUpdate();
			if (flag > 0) {
				isSuccess = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			}
		}

		return isSuccess;
	}
	
	//파일 목록을 리턴해주는 메소드 getList()
	public List<FileDto> getList(){
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		List<FileDto> list = new ArrayList<>();

		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();

			String sql = "SELECT num, writer, title, orgFileName, saveFileName, fileSize, TO_CHAR(regdate, 'yyyy\"년 \"mm\"월 \"dd\"일 \"HH24:MI:SS') RD FROM board_data ORDER BY num ASC";
			pstmt = conn.prepareStatement(sql);
			rs = pstmt.executeQuery();

			while (rs.next()) {
				int num = rs.getInt("num");
				String writer = rs.getString("writer");
				String title = rs.getString("title");
				String orgFileName = rs.getString("orgFileName");
				String saveFileName = rs.getString("saveFileName");
				long fileSize = rs.getLong("fileSize");
				String regdate = rs.getString("RD");
				
				FileDto dto = new FileDto(num, writer, title, orgFileName, saveFileName, fileSize, regdate);
				list.add(dto);
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				// Connection 객체 반납하기
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			}
		}
		//파일 목록을 리턴해준다.
		return list;
	}
	//파일 정보를 지우는 메소드
	public boolean delete(int num) {
		boolean isSuccess = false;
		Connection conn = null;
		PreparedStatement pstmt = null;

		try {
			conn = new DbcpBean().getConn();
			String sql = "DELETE FROM board_data WHERE num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			int flag = pstmt.executeUpdate();
			if (flag > 0) {
				isSuccess = true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			}
		}

		return isSuccess;
	}
	
	public FileDto getData(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		FileDto dto = null;

		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();

			String sql = "SELECT writer, title, orgFileName, saveFileName, fileSize, TO_CHAR(regdate, 'yyyy\"년 \"mm\"월 \"dd\"일 \"HH24:MI:SS') RD " +
			"FROM board_data WHERE num=?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				dto = new FileDto();
				
				dto.setNum(num);
				dto.setWriter(rs.getString("writer"));
				dto.setTitle(rs.getString("title"));
				dto.setOrgFileName(rs.getString("orgFileName"));
				dto.setSaveFileName(rs.getString("saveFileName"));
				dto.setFileSize(rs.getLong("fileSize"));
				dto.setRegdate(rs.getString("RD"));
			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				// Connection 객체 반납하기
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			}
		}
		//파일 정보를 리턴해준다.
		return dto;
	}
}
