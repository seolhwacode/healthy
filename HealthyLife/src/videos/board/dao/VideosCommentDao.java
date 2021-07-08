package videos.board.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import test.util.DbcpBean;
import videos.board.dto.VideosCommentDto;

public class VideosCommentDao {
	private static VideosCommentDao dao;
	private VideosCommentDao() {}
	
	static {
		dao = new VideosCommentDao();
	}
	
	public static VideosCommentDao getInstance() {
		return dao;
	}
	
	//댓글의 시퀀스 값을 미리 리턴해주는 메소드
	public int getSequence() {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		//return 할 시퀀스 값
		int seq = 0;

		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT video_board_comment_seq.NEXTVAL AS seq"
					+ " FROM DUAL";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩

			//select 문 수행하고, 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			//ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
			if (rs.next()) {
				seq = rs.getInt("seq");
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
	
	//댓글 추가 - insert
	public boolean insert(VideosCommentDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0; //return 값 확인을 위해 사용

		try {
			conn = new DbcpBean().getConn();
			String sql = "INSERT INTO video_board_comment"
					+ " (num, writer, content, target_id, ref_group, comment_group, regdate)"
					+ " VALUES(?, ?, ?, ?, ?, ?, SYSDATE)";
			pstmt = conn.prepareStatement(sql);
			// ? 에 바인딩 할 내용 있으면 여기서 바인딩
			pstmt.setInt(1, dto.getNum());
			pstmt.setString(2, dto.getWriter());
			pstmt.setString(3, dto.getContent());
			pstmt.setString(4, dto.getTarget_id());
			pstmt.setInt(5, dto.getRef_group());
			pstmt.setInt(6, dto.getComment_group());

			//update(insert, update, delete) 로 변경된 row 의 개수 return
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
		//변경된 개수가 1개 이상이면 성공
		if (flag > 0) {
			return true;
		} else {//0 이하면 false
			return false;
		}
	}
	
	//댓글의 리스트 읽어오기
	public List<VideosCommentDto> getList(VideosCommentDto dto){
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		//return 할 List<VideosCommentDto>
		List<VideosCommentDto> list = new ArrayList<VideosCommentDto>();

		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT *" + 
					" FROM" + 
					"	(SELECT result1.*, ROWNUM AS rnum" + 
					"	FROM " + 
					"		(SELECT num, writer, content, target_id, ref_group, comment_group, deleted, video_board_comment.regdate, profile " + 
					"		FROM video_board_comment " + 
					"		INNER JOIN users " + 
					"		ON video_board_comment.writer = users.id " + 
					"		WHERE ref_group = ? " + 
					"		ORDER BY comment_group ASC, num ASC) result1) " + 
					" WHERE rnum >= ? AND rnum <= ?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩
			pstmt.setInt(1, dto.getRef_group());
			pstmt.setInt(2, dto.getStartRowNum());
			pstmt.setInt(3, dto.getEndRowNum());

			//select 문 수행하고, 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
			while (rs.next()) {
				VideosCommentDto tmp = new VideosCommentDto();
				tmp.setNum(rs.getInt("num"));
				tmp.setWriter(rs.getString("writer"));
				tmp.setContent(rs.getString("content"));
				tmp.setTarget_id(rs.getString("target_id"));
				tmp.setRef_group(rs.getInt("ref_group"));
				tmp.setComment_group(rs.getInt("comment_group"));
				tmp.setDeleted(rs.getString("deleted"));
				tmp.setRegdate(rs.getString("regdate"));
				tmp.setProfile(rs.getString("profile"));
				//리스트에 추가
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
			} catch (Exception e) {}
		}
		return list;
	}
	
	//delete : 댓글 지우기. 댓글의 num(pk) 로 해당 row 를 찾아 deleted 의 값을 "yes" 로 바꿈
	public boolean delete(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0; //return 값 확인을 위해 사용

		try {
			conn = new DbcpBean().getConn();
			String sql = "UPDATE video_board_comment"
					+ " SET deleted = 'yes' "
					+ " WHERE num = ?";
			pstmt = conn.prepareStatement(sql);
			// ? 에 바인딩 할 내용 있으면 여기서 바인딩
			pstmt.setInt(1, num);

			//update(insert, update, delete) 로 변경된 row 의 개수 return
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
		//변경된 개수가 1개 이상이면 성공
		if (flag > 0) {
			return true;
		} else {//0 이하면 false
			return false;
		}
	}
	
	//모든 댓글 개수
	public int getCommentCount(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		//return 할 댓글의 개수
		int count = 0;

		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT COUNT(1) AS count"
					+ " FROM video_board_comment"
					+ " WHERE ref_group = ?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩
			pstmt.setInt(1, num);

			//select 문 수행하고, 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			//ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
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
