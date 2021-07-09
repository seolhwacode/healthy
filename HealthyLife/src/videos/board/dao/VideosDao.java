package videos.board.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import test.util.DbcpBean;
import videos.board.dto.VideosDto;

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
					"		(SELECT num, writer, title, content, view_count, regdate, good_count, type" + 
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
				tmp.setType(rs.getString("type"));
				
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
	
	//getListTC : Title, Content 검색일 때 실행할 메소드
	//CafeDto 의 title, content 이라는 필드에 검색 키워드가 들어있다.
	//'%'||?||'%' -> || 는 연결시켜주는 연산자이다. 결국, '%검색어%' 가 완성된다.
	public List<VideosDto> getListTC(VideosDto dto){
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		//return 하기 위한 List<CafeDto>
		List<VideosDto> list = new ArrayList<VideosDto>();

		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT * " + 
					" FROM" + 
					"   (SELECT result1.*, ROWNUM AS rnum" + 
					"   FROM" + 
					"      (SELECT num, writer, title, content, view_count, regdate, good_count, type" + 
					"      FROM video_board" + 
					"      WHERE title LIKE '%'||?||'%' OR content LIKE '%'||?||'%' "+
					"      ORDER BY num DESC) result1)" + 
					" WHERE rnum >= ? AND rnum <= ?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getTitle());
			pstmt.setString(2, dto.getContent());
			pstmt.setInt(3, dto.getStartRowNum());
			pstmt.setInt(4, dto.getEndRowNum());

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
				tmp.setType(rs.getString("type"));
				
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
	
	//getListT : Title 검색일 때 실행할 메소드
	//VideosDto 의 title 이라는 필드에 검색 키워드가 들어있다.
	public List<VideosDto> getListT(VideosDto dto){
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		//return 하기 위한 List<CafeDto>
		List<VideosDto> list = new ArrayList<VideosDto>();

		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT * " + 
					" FROM" + 
					"   (SELECT result1.*, ROWNUM AS rnum" + 
					"   FROM" + 
					"      (SELECT num, writer, title, content, view_count, regdate, good_count, type" + 
					"      FROM video_board" + 
					"      WHERE title LIKE '%'||?||'%' "+
					"      ORDER BY num DESC) result1)" + 
					" WHERE rnum >= ? AND rnum <= ?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getTitle());
			pstmt.setInt(2, dto.getStartRowNum());
			pstmt.setInt(3, dto.getEndRowNum());

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
				tmp.setType(rs.getString("type"));
				
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
	
	//getListW : writer 검색일 때 실행할 메소드
	//VideosDto 의  writer 이라는 필드에 검색 키워드가 들어있다.
	public List<VideosDto> getListW(VideosDto dto){
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		//return 하기 위한 List<CafeDto>
		List<VideosDto> list = new ArrayList<VideosDto>();

		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT * " + 
					" FROM" + 
					"   (SELECT result1.*, ROWNUM AS rnum" + 
					"   FROM" + 
					"      (SELECT num, writer, title, content, view_count, regdate, good_count, type" + 
					"      FROM video_board" + 
					"      WHERE writer LIKE '%'||?||'%' "+
					"      ORDER BY num DESC) result1)" + 
					" WHERE rnum >= ? AND rnum <= ?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getWriter());
			pstmt.setInt(2, dto.getStartRowNum());
			pstmt.setInt(3, dto.getEndRowNum());

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
				tmp.setType(rs.getString("type"));
				
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
	
	//getListTy : type 검색일 때 실행할 메소드
	//VideosDto 의  type 이라는 필드에 검색 키워드가 들어있다.
	public List<VideosDto> getListTy(VideosDto dto){
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		//return 하기 위한 List<CafeDto>
		List<VideosDto> list = new ArrayList<VideosDto>();

		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT * " + 
					" FROM" + 
					"   (SELECT result1.*, ROWNUM AS rnum" + 
					"   FROM" + 
					"      (SELECT num, writer, title, content, view_count, regdate, good_count, type" + 
					"      FROM video_board" + 
					"      WHERE type = ? "+
					"      ORDER BY num DESC) result1)" + 
					" WHERE rnum >= ? AND rnum <= ?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getType());
			pstmt.setInt(2, dto.getStartRowNum());
			pstmt.setInt(3, dto.getEndRowNum());

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
				tmp.setType(rs.getString("type"));
				
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
	
	//getCountTC : title, content 검색의 row 의 개수
	public int getCountTC(VideosDto dto) {
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
					+ " FROM video_board"
					+ " WHERE title LIKE '%'||?||'%' OR content LIKE '%'||?||'%' ";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getTitle());
			pstmt.setString(2, dto.getContent());

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
	
	//getCountT : title 검색의 row 의 개수
	public int getCountT(VideosDto dto) {
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
					+ " FROM video_board"
					+ " WHERE title LIKE '%'||?||'%' ";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getTitle());

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
	
	//getCountW : writer 검색의 row 의 개수
	public int getCountW(VideosDto dto) {
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
					+ " FROM video_board"
					+ " WHERE writer LIKE '%'||?||'%' ";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getWriter());

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
	
	//getCountTy : type 검색의 row 의 개수
	public int getCountTy(VideosDto dto) {
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
					+ " FROM video_board"
					+ " WHERE type = ? ";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getType());

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
		
	//게시글 추가 - 게시글 type 또한 지정
	public boolean insert(VideosDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0; //return 값 확인을 위해 사용

		try {
			conn = new DbcpBean().getConn();
			String sql = "INSERT INTO video_board"
					+ " (num, writer, title, content, video, regdate, type)"
					+ " VALUES(video_board_seq.NEXTVAL, ?, ?, ?, ?, SYSDATE, ?)";
			pstmt = conn.prepareStatement(sql);
			// ? 에 바인딩 할 내용 있으면 여기서 바인딩
			pstmt.setString(1, dto.getWriter());
			pstmt.setString(2, dto.getTitle());
			pstmt.setString(3, dto.getContent());
			pstmt.setString(4, dto.getVideo());
			pstmt.setString(5, dto.getType());

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
	
	//게시글 조회수 증가
	public boolean addViewCount(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0; //return 값 확인을 위해 사용

		try {
			conn = new DbcpBean().getConn();
			String sql = "UPDATE video_board"
					+ " SET view_count = view_count + 1"
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
	
	//게시글 1개의 데이터 가져오기
	public VideosDto getData(VideosDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		//return 할 VideosDto
		VideosDto returnDto = null;

		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT *" + 
					" FROM" + 
					"	(SELECT num, writer, title, content, video, view_count, regdate, good_count, type," + 
					"	LAG(num, 1, 0) OVER(ORDER BY num DESC) AS prevNum," + 
					"	LEAD(num, 1, 0) OVER(ORDER BY num DESC) AS nextNum" + 
					"	FROM video_board" + 
					"	ORDER BY num DESC)" + 
					" WHERE num = ?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩
			pstmt.setInt(1, dto.getNum());

			//select 문 수행하고, 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
			if (rs.next()) {
				returnDto = new VideosDto();
				returnDto.setNum(dto.getNum());
				returnDto.setWriter(rs.getString("writer"));
				returnDto.setTitle(rs.getString("title"));
				returnDto.setContent(rs.getString("content"));
				returnDto.setVideo(rs.getString("video"));
				returnDto.setView_count(rs.getInt("view_count"));
				returnDto.setRegdate(rs.getString("regdate"));
				returnDto.setGood_count(rs.getInt("good_count"));
				returnDto.setType(rs.getString("type"));
				returnDto.setPrevNum(rs.getInt("prevNum"));
				returnDto.setNextNum(rs.getInt("nextNum"));
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
		return returnDto;
	}
	
	//getDataTC : title + content 검색 - 글 하나의 데이터를 리턴하는 메소드
	public VideosDto getDataTC(VideosDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		//return 할 VideosDto
		VideosDto returnDto = null;

		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT *" + 
					" FROM" + 
					"	(SELECT num, writer, title, content, video, view_count, regdate, good_count, type," + 
					"	LAG(num, 1, 0) OVER(ORDER BY num DESC) AS prevNum," + 
					"	LEAD(num, 1, 0) OVER(ORDER BY num DESC) AS nextNum" + 
					"	FROM video_board" + 
					"   WHERE title LIKE '%'||?||'%' OR content LIKE '%'||?||'%' " +
					"	ORDER BY num DESC)" + 
					" WHERE num = ?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getTitle());
			pstmt.setString(2, dto.getContent());
			pstmt.setInt(3, dto.getNum());

			//select 문 수행하고, 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
			if (rs.next()) {
				returnDto = new VideosDto();
				returnDto.setNum(dto.getNum());
				returnDto.setWriter(rs.getString("writer"));
				returnDto.setTitle(rs.getString("title"));
				returnDto.setContent(rs.getString("content"));
				returnDto.setVideo(rs.getString("video"));
				returnDto.setView_count(rs.getInt("view_count"));
				returnDto.setRegdate(rs.getString("regdate"));
				returnDto.setGood_count(rs.getInt("good_count"));
				returnDto.setType(rs.getString("type"));
				returnDto.setPrevNum(rs.getInt("prevNum"));
				returnDto.setNextNum(rs.getInt("nextNum"));
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
		return returnDto;
	}
	
	//getDataT : title 검색 - 글 하나의 데이터를 리턴하는 메소드
	public VideosDto getDataT(VideosDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		//return 할 VideosDto
		VideosDto returnDto = null;

		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT *" + 
					" FROM" + 
					"	(SELECT num, writer, title, content, video, view_count, regdate, good_count, type," + 
					"	LAG(num, 1, 0) OVER(ORDER BY num DESC) AS prevNum," + 
					"	LEAD(num, 1, 0) OVER(ORDER BY num DESC) AS nextNum" + 
					"	FROM video_board" + 
					"   WHERE title LIKE '%'||?||'%' " +
					"	ORDER BY num DESC)" + 
					" WHERE num = ?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getTitle());
			pstmt.setInt(2, dto.getNum());

			//select 문 수행하고, 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
			if (rs.next()) {
				returnDto = new VideosDto();
				returnDto.setNum(dto.getNum());
				returnDto.setWriter(rs.getString("writer"));
				returnDto.setTitle(rs.getString("title"));
				returnDto.setContent(rs.getString("content"));
				returnDto.setVideo(rs.getString("video"));
				returnDto.setView_count(rs.getInt("view_count"));
				returnDto.setRegdate(rs.getString("regdate"));
				returnDto.setGood_count(rs.getInt("good_count"));
				returnDto.setType(rs.getString("type"));
				returnDto.setPrevNum(rs.getInt("prevNum"));
				returnDto.setNextNum(rs.getInt("nextNum"));
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
		return returnDto;
	}
	
	//getDataW : writer 검색 - 글 하나의 데이터를 리턴하는 메소드
	public VideosDto getDataW(VideosDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		//return 할 VideosDto
		VideosDto returnDto = null;

		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT *" + 
					" FROM" + 
					"	(SELECT num, writer, title, content, video, view_count, regdate, good_count, type," + 
					"	LAG(num, 1, 0) OVER(ORDER BY num DESC) AS prevNum," + 
					"	LEAD(num, 1, 0) OVER(ORDER BY num DESC) AS nextNum" + 
					"	FROM video_board" + 
					"   WHERE writer LIKE '%'||?||'%' " +
					"	ORDER BY num DESC)" + 
					" WHERE num = ?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getWriter());
			pstmt.setInt(2, dto.getNum());

			//select 문 수행하고, 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
			if (rs.next()) {
				returnDto = new VideosDto();
				returnDto.setNum(dto.getNum());
				returnDto.setWriter(rs.getString("writer"));
				returnDto.setTitle(rs.getString("title"));
				returnDto.setContent(rs.getString("content"));
				returnDto.setVideo(rs.getString("video"));
				returnDto.setView_count(rs.getInt("view_count"));
				returnDto.setRegdate(rs.getString("regdate"));
				returnDto.setGood_count(rs.getInt("good_count"));
				returnDto.setType(rs.getString("type"));
				returnDto.setPrevNum(rs.getInt("prevNum"));
				returnDto.setNextNum(rs.getInt("nextNum"));
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
		return returnDto;
	}
	
	//getDataTy : type 검색 - 글 하나의 데이터를 리턴하는 메소드
	public VideosDto getDataTy(VideosDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		//return 할 VideosDto
		VideosDto returnDto = null;

		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT *" + 
					" FROM" + 
					"	(SELECT num, writer, title, content, video, view_count, regdate, good_count, type," + 
					"	LAG(num, 1, 0) OVER(ORDER BY num DESC) AS prevNum," + 
					"	LEAD(num, 1, 0) OVER(ORDER BY num DESC) AS nextNum" + 
					"	FROM video_board"+ 
					"	WHERE type = ?" + 
					"	ORDER BY num DESC)" + 
					" WHERE num = ?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getType());
			pstmt.setInt(2, dto.getNum());

			//select 문 수행하고, 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
			if (rs.next()) {
				returnDto = new VideosDto();
				returnDto.setNum(dto.getNum());
				returnDto.setWriter(rs.getString("writer"));
				returnDto.setTitle(rs.getString("title"));
				returnDto.setContent(rs.getString("content"));
				returnDto.setVideo(rs.getString("video"));
				returnDto.setView_count(rs.getInt("view_count"));
				returnDto.setRegdate(rs.getString("regdate"));
				returnDto.setGood_count(rs.getInt("good_count"));
				returnDto.setType(rs.getString("type"));
				returnDto.setPrevNum(rs.getInt("prevNum"));
				returnDto.setNextNum(rs.getInt("nextNum"));
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
		return returnDto;
	}
	
	//게시글 지우기
	public boolean delete(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0; //return 값 확인을 위해 사용

		try {
			conn = new DbcpBean().getConn();
			String sql = "DELETE FROM video_board"
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
	
	//게시글 수정하기 - update
	public boolean update(VideosDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0; //return 값 확인을 위해 사용

		try {
			conn = new DbcpBean().getConn();
			String sql = "UPDATE video_board"
					+ " SET title = ?, content = ?, video = ?"
					+ " WHERE num = ?";
			pstmt = conn.prepareStatement(sql);			
			// ? 에 바인딩 할 내용 있으면 여기서 바인딩
			pstmt.setString(1, dto.getTitle());
			pstmt.setString(2, dto.getContent());
			pstmt.setString(3, dto.getVideo());
			pstmt.setInt(4, dto.getNum());

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
	
	//좋아요 수 증가 메소드
	//게시글 번호 받아서 해당 good_count 증가
	public boolean addGoodCount(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0; //return 값 확인을 위해 사용

		try {
			conn = new DbcpBean().getConn();
			String sql = "UPDATE video_board"
					+ " SET good_count = good_count + 1"
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
	
	//좋아요 수 감소 메소드
	//게시글 번호 받아서 해당 good_count 감소
	public boolean subtractGoodCount(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0; //return 값 확인을 위해 사용

		try {
			conn = new DbcpBean().getConn();
			String sql = "UPDATE video_board"
					+ " SET good_count = good_count - 1"
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
	
	//게시글의 좋아요 개수 가져오기
	public int getGoodCount(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		//return 할 good_count
		int good_count = 0;

		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql 문 작성
			String sql = "SELECT good_count"
					+ " FROM video_board"
					+ " WHERE num = ?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//? 에 바인딩 할 내용이 있으면 여기서 바인딩
			pstmt.setInt(1, num);

			//select 문 수행하고, 결과를 ResultSet 으로 받아오기
			rs = pstmt.executeQuery();
			//ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
			if (rs.next()) {
				good_count = rs.getInt("good_count");
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
		return good_count;
	}
	
}
