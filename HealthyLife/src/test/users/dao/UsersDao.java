package test.users.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import test.users.dto.UsersDto;
import test.util.DbcpBean;

public class UsersDao {
	private static UsersDao dao;
	//생성자 - 외부 접근X
	private UsersDao() {}
	
	/*
	 * [ static 초기화 블럭  ]
	 * - 이 클래스가 최초 사용될 때 한 번만 수행하는 블럭
	 * - static 자원을 초기화할 때 사용한다.
	 */
	static {
		dao = new UsersDao();
	}
	
	public static UsersDao getInstance() {
		return dao;
	}
	
	//id 가 존재하는지 확인
	public boolean isExist(String id) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		//return 할 boolean 값 : id 값이 존재하면 true
		boolean isExist = false;

		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT 1 FROM users"
					+ " WHERE id = ?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, id);

			//select 문 수행하고, 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			// ResultSet 객체에 row 가 존재하면 -> id 가 존재한다.
			if (rs.next()) {
				//이미 존재하는 id
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
	
	//회원가입 - 회원 정보 저장
	public boolean insert(UsersDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0; //return 값 확인을 위해 사용

		try {
			conn = new DbcpBean().getConn();
			String sql = "INSERT INTO users"
					+ " (id, pwd, regdate)"
					+ " VALUES(?, ?, SYSDATE)";
			pstmt = conn.prepareStatement(sql);
			// ? 에 바인딩 할 내용 있으면 여기서 바인딩
			pstmt.setString(1, dto.getId());
			pstmt.setString(2, dto.getPwd());

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
