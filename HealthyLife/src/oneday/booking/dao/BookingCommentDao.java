package oneday.booking.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import oneday.booking.dto.BookingCommentDto;
import test.util.DbcpBean;

public class BookingCommentDao {

	private static BookingCommentDao dao;
	
	static {
		dao = new BookingCommentDao();
	}
	
	private BookingCommentDao() {}
	
	public static BookingCommentDao getInstance() {
		return dao;
	}
	
	//댓글 삭제하는 메소드
	public boolean delete(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = "UPDATE booking_board_comment"
						+ " SET deleted='yes'"
						+ " WHERE num=?";//이 템플릿을 불러왔을 때 커서가 여기서 시작
			pstmt = conn.prepareStatement(sql);
			//?에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setInt(1,num);
			// insert or update or delete 문 수행하고 변화된 row의 갯수 리턴 받기
			flag = pstmt.executeUpdate(); //변화된 row의 갯수값을 정수로 return한다. row하나가 수정, 추가, 삭제되면 1이 리턴된다. 5개가 되면 5가 리턴
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
		if (flag > 0) { //작업이 성공했는지 알 수 있는지 역할
			return true;
		} else {
			return false;
		}
	}
	
	//댓글 수정하는 메소드
	public boolean update(BookingCommentDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = "UPDATE booking_board_comment"
						+ " SET content = ?"
						+ " WHERE num = ?";//이 템플릿을 불러왔을 때 커서가 여기서 시작
			pstmt = conn.prepareStatement(sql);
			//?에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getContent());
			pstmt.setInt(2, dto.getNum());
			// insert or update or delete 문 수행하고 변화된 row의 갯수 리턴 받기
			flag = pstmt.executeUpdate(); //변화된 row의 갯수값을 정수로 return한다. row하나가 수정, 추가, 삭제되면 1이 리턴된다. 5개가 되면 5가 리턴
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
		if (flag > 0) { //작업이 성공했는지 알 수 있는지 역할
			return true;
		} else {
			return false;
		}
	}
	
	//댓글 추가하는 메소드
	public boolean insert(BookingCommentDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = "INSERT INTO booking_board_comment"
						+ " (num, writer, content, target_id, ref_group, comment_group, regdate)"
						+ " VALUES(?,?,?,?,?,?,SYSDATE)";//이 템플릿을 불러왔을 때 커서가 여기서 시작
			pstmt = conn.prepareStatement(sql);
			//?에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setInt(1, dto.getNum());
			pstmt.setString(2, dto.getWriter());
			pstmt.setString(3, dto.getContent());
			pstmt.setString(4, dto.getTarget_id());
			pstmt.setInt(5, dto.getRef_group());
			pstmt.setInt(6, dto.getComment_group());
			// insert or update or delete 문 수행하고 변화된 row의 갯수 리턴 받기
			flag = pstmt.executeUpdate(); //변화된 row의 갯수값을 정수로 return한다. row하나가 수정, 추가, 삭제되면 1이 리턴된다. 5개가 되면 5가 리턴
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
		if (flag > 0) { //작업이 성공했는지 알 수 있는지 역할
			return true;
		} else {
			return false;
		}
	}
	
	//댓글의 시퀀스값을 미리 리턴해주는 메소드
	public int getSequence() {
		int seq=0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql문 작성
			String sql = "SELECT booking_board_comment_seq.NEXTVAL AS seq"
						+ " FROM DUAL";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//select 문 수행하고 결과를 ResultSet으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용 추출해서 원하는 Data type으로 포장하기
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
	
	//전체 댓글 개수 리턴하는 메소드
	public int getCount(int ref_group) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql문 작성
			String sql = "SELECT NVL(MAX(ROWNUM), 0) AS count"
					+ " FROM booking_board_comment"
					+ " WHERE ref_group=?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//?에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setInt(1, ref_group);
			//select 문 수행하고 결과를 ResultSet으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용 추출해서 원하는 Data type으로 포장하기
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
	
	//댓글 목록 불러오는 메소드
	public List<BookingCommentDto> getList(BookingCommentDto dto2){
		List<BookingCommentDto> list = new ArrayList<>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql문 작성
			 String sql = "SELECT *" + 
		               " FROM" + 
		               "   (SELECT result1.*, ROWNUM AS rnum" + 
		               "    FROM" + 
		               "      (SELECT num, writer, content, target_id, ref_group," + 
		               "      comment_group, deleted, booking_board_comment.regdate, profile" + 
		               "      FROM booking_board_comment" + 
		               "      INNER JOIN users" + 
		               "      ON booking_board_comment.writer = users.id" + 
		               "      WHERE ref_group=?" + 
		               "      ORDER BY comment_group DESC, num ASC) result1)" + 
		               " WHERE rnum BETWEEN ? AND ?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//?에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setInt(1, dto2.getRef_group());
			pstmt.setInt(2, dto2.getStartRowNum());
			pstmt.setInt(3, dto2.getEndRowNum());
			//select 문 수행하고 결과를 ResultSet으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용 추출해서 원하는 Data type으로 포장하기
			while (rs.next()) {
				BookingCommentDto dto = new BookingCommentDto();
				dto.setNum(rs.getInt("num"));
		        dto.setWriter(rs.getString("writer"));
		        dto.setContent(rs.getString("content"));
		        dto.setTarget_id(rs.getString("target_id"));
		        dto.setRef_group(rs.getInt("ref_group"));
		        dto.setComment_group(rs.getInt("comment_group"));
		        dto.setDeleted(rs.getString("deleted"));
		        dto.setRegdate(rs.getString("regdate"));
		        dto.setProfile(rs.getString("profile"));
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
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			}
		}

		return list;
	}
}
