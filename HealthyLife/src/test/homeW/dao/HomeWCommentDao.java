package test.homeW.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import test.homeW.dto.HomeWCommentDto;
import test.util.DbcpBean;

public class HomeWCommentDao {
	
	private static HomeWCommentDao dao;
	private HomeWCommentDao() {};
	public static HomeWCommentDao getInstance() {
		if(dao==null) {
			dao=new HomeWCommentDao();
		}
		return dao;
	}
	//전체 댓글의 갯수를 리턴해주는 메소드
	public int getCount(int ref_group) {
		int count=0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기 
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT NVL(MAX(ROWNUM),0) AS count"
					+ " FROM home_workout_comment"
					+ " WHERE ref_group=?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setInt(1, ref_group);
			//select 문 수행하고 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
			if (rs.next()) {
				count=rs.getInt("count");
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
	
	//댓글 목록을 리턴하는 메소드
	public List<HomeWCommentDto> getList(HomeWCommentDto dto){
		List<HomeWCommentDto> list=new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기 
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql ="select *" + 
		            " from" + 
		            "   (select result1.*, rownum as rnum" + 
		            "   from" + 
		            "      (select num, writer, content, target_id, ref_group," + 
		            "      comment_group, deleted, home_workout_comment.regdate, profile" + 
		            "      from home_workout_comment" + 
		            "      inner join users" + 
		            "      on home_workout_comment.writer = users.id" + 
		            "      where ref_group=?" + 
		            "      order by comment_group desc, num asc) result1)" + 
		            " where rnum between ? and ?";
					
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setInt(1, dto.getRef_group());
			pstmt.setInt(2, dto.getStartRowNum());
			pstmt.setInt(3, dto.getEndRowNum());
			//select 문 수행하고 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
			while (rs.next()) {
				HomeWCommentDto dto2=new HomeWCommentDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setContent(rs.getString("content"));
				dto2.setTarget_id(rs.getString("target_id"));
				dto2.setRef_group(rs.getInt("ref_group"));
				dto2.setComment_group(rs.getInt("comment_group"));
				dto2.setDeleted(rs.getString("deleted"));
				dto2.setRegdate(rs.getString("regdate"));
				dto2.setProfile(rs.getString("profile"));
				list.add(dto2);
				
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
	
	//시퀀스 값을 미리 얻어내는 메소드
	public int getSequence() {
		int seq=0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기 
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT home_workout_comment_seq.NEXTVAL AS seq"
					+ " FROM dual";
			
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩할 내용이 있으면 여기서 바인딩

			//select 문 수행하고 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
			if (rs.next()) {
				seq=rs.getInt("seq");
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
		return seq;
	}
	
	
	//댓글을 작성하는 메소드
	public boolean insert(HomeWCommentDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "INSERT INTO home_workout_comment"
					+ " (num, writer, content, target_id, ref_group, comment_group, regdate)"
					+ " VALUES(?, ?, ?, ?, ?, ?, SYSDATE)";
			
			pstmt = conn.prepareStatement(sql);
			//?에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setInt(1, dto.getNum());
			pstmt.setString(2, dto.getWriter());
			pstmt.setString(3, dto.getContent());
			pstmt.setString(4, dto.getTarget_id());
			pstmt.setInt(5, dto.getRef_group());
			pstmt.setInt(6, dto.getComment_group());
			//insert or update or delete 문 수행하고 변화된 row 의 갯수 리턴 받기
			flag = pstmt.executeUpdate();
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
		if (flag > 0) {
			return true;
		} else {
			return false;
		}
	}
	
}
