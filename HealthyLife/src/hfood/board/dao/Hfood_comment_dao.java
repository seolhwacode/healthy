package hfood.board.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import hfood.board.dto.Hfood_comment_dto;
import test.util.DbcpBean;

public class Hfood_comment_dao {
	private static Hfood_comment_dao dao;
	static {
		dao=new Hfood_comment_dao();
	}
	
	private Hfood_comment_dao() {
		
	}
	
	public static Hfood_comment_dao getInstance() {
		return dao;
	}
	
	public int getSequence() {
		int seq=0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기 
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "select hfood_board_comment_seq.nextval as seq"
		               + " from dual";
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
	// 댓글 추가 
	public boolean insert(Hfood_comment_dto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = "insert into hfood_board_comment"
					+ " (num, writer, content, target_id, ref_group, comment_group, regdate)"
					+ " values(?,?,?,?,?,?,sysdate)";
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩할 내용이 있으면 여기서 바인딩
	         pstmt.setInt(1, dto.getNum());
	         pstmt.setString(2, dto.getWriter());
	         pstmt.setString(3, dto.getContent());
	         pstmt.setString(4, dto.getTarget_id());
	         pstmt.setInt(5, dto.getRef_group());
	         pstmt.setInt(6, dto.getComment_group());
			//insert or update or delete문 수행하고 변화된 row의 갯수 리턴 받기 
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
