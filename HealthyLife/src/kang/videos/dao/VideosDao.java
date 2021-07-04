package kang.videos.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import kang.videos.dto.VideosDto;
import test.users.dao.UsersDao;
import test.util.DbcpBean;

public class VideosDao {
	private static VideosDao dao;
	private VideosDao() {}
	
	/*
	 * [ static 초기화 블럭  ]
	 * - 이 클래스가 최초 사용될 때 한 번만 수행하는 블럭
	 * - static 자원을 초기화할 때 사용한다.
	 */
	static {
		dao = new VideosDao();
	}
	public static VideosDao getInstance() {
		return dao;
	}
	
	public List<VideosDto> getList(VideosDto dto){
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		//return 할 list
		List<VideosDto> list = new ArrayList<VideosDto>();

		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT * " + 
					" FROM" + 
					"	(SELECT result1.*, ROWNUM AS rnum" + 
					"	FROM" + 
					"		(SELECT num, writer, title, content, view_count, regdate, good_count" + 
					"		FROM video_board" + 
					"		ORDER BY num DESC) result1)" + 
					" WHERE rnum >= ? AND rnum <= ?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩
			pstmt.setInt(1, dto.getStartRowNum());
			pstmt.setInt(2, dto.getEndRowNum());

			//select 문 수행하고, 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
			while (rs.next()) {
				VideosDto tmp = new VideosDto();
				tmp.setNum(rs.getInt("num"));
				tmp.setWriter(rs.getString("writer"));
				tmp.setTitle(rs.getString("title"));
				tmp.setContent(rs.getString("content"));
				tmp.setView_count(rs.getInt("view_count"));
				tmp.setRegdate(rs.getString("regdate"));
				tmp.setGood_count(rs.getInt("good_count"));
				
				//list 에 tmp 추가
				list.add(tmp);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			}
		}
		return list;
	}
	
	//전체 row 의 개수를 return 하는 메소드
	public int getCount() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		//table 에 들어 있는 row 의 개수
		int count = 0;
		
		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT COUNT(1) AS count"
					+ " FROM video_board";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩

			//select 문 수행하고, 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			//ResultSet 객체가 존재하면 -> 
			if (rs.next()) {
				count = rs.getInt("count");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (pstmt != null)
					pstmt.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			}
		}
		return count;
	}
	
	
}
