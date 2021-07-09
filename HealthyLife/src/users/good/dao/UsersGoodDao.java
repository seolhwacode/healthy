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
					+ " WHERE id = ? AND video_board = ?";
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
}
