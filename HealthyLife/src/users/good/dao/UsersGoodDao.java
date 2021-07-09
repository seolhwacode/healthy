package users.good.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import test.util.DbcpBean;
import users.good.dto.UsersGoodDto;

public class UsersGoodDao {
	private static UsersGoodDao dao;
	private UsersGoodDao() {}

	static {
		dao = new UsersGoodDao();
	}
	public static UsersGoodDao getInstance() {
		return dao;
	}
	
	//게시판에 좋아요 했는지 check
	public boolean isExist(UsersGoodDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;

		//return 할 boolean 값
		boolean isExist = false;
		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT 1"
					+ " FROM users_good_list"
					+ " WHERE id = ? AND video_board_num = ?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getId());
			pstmt.setInt(2, dto.getVideo_board_num());

			//select 문 수행하고, 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			//ResultSet 객체에 내용이 있다면, true
			if (rs.next()) {
				isExist = true;
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
		return isExist;
	}
	
	//delete : db에서 삭제
	public boolean delete(UsersGoodDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0; //return 값 확인을 위해 사용

		try {
			conn = new DbcpBean().getConn();
			String sql = "DELETE FROM users_good_list"
					+ " WHERE id = ? AND video_board_num = ?";
			pstmt = conn.prepareStatement(sql);
			// ? 에 바인딩 할 내용 있으면 여기서 바인딩
			pstmt.setString(1, dto.getId());
			pstmt.setInt(2, dto.getVideo_board_num());

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
	
	//insert : db 에 추가
	public boolean insert(UsersGoodDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0; //return 값 확인을 위해 사용

		try {
			conn = new DbcpBean().getConn();
			String sql = "INSERT INTO users_good_list"
					+ " (id, video_board_num)"
					+ " VALUES(?, ?)";
			pstmt = conn.prepareStatement(sql);
			// ? 에 바인딩 할 내용 있으면 여기서 바인딩
			pstmt.setString(1, dto.getId());
			pstmt.setInt(2, dto.getVideo_board_num());

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
}
