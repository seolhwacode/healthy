package oneday.booking.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import oneday.booking.dto.BookingDto;
import test.util.DbcpBean;

public class BookingDao {

	private static BookingDao dao;
	private BookingDao() {}
	public static BookingDao getInstance() {
		if(dao==null) {
			dao= new BookingDao();
		}
		return dao;
	}
	
	
	public boolean delete(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = "DELETE FROM booking_board"
						+ " WHERE num=?";//이 템플릿을 불러왔을 때 커서가 여기서 시작
			pstmt = conn.prepareStatement(sql);
			//?에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setInt(1, num);
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
	
	public boolean update(BookingDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = "UPDATE booking_board"
						+ " SET name=?, phone=?, className=?, classDate=?, mention=?"
						+ " WHERE num=?";//이 템플릿을 불러왔을 때 커서가 여기서 시작
			pstmt = conn.prepareStatement(sql);
			//?에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getName());
			pstmt.setString(2, dto.getPhone());
			pstmt.setString(3, dto.getClassName());
			pstmt.setString(4, dto.getClassDate());
			pstmt.setString(5, dto.getMention());
			pstmt.setInt(6, dto.getNum());
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
	
	public BookingDto getDataW(BookingDto dto) {
	      BookingDto dto2=null;
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      try {
	         //Connection 객체의 참조값 얻어오기 
	         conn = new DbcpBean().getConn();
	         //실행할 sql 문 작성
	         String sql = "SELECT *" + 
	               " FROM" + 
	               "   (SELECT num, viewCount, writer, name, phone, className, classDate, mention," + 
	               "   LAG(num, 1, 0) OVER(ORDER BY num DESC) AS prevNum," + 
	               "   LEAD(num, 1, 0) OVER(ORDER BY num DESC) nextNum" + 
	               "   FROM booking_board"+ 
	               "   WHERE writer LIKE '%'||?||'%'" + 
	               "   ORDER BY num DESC)" + 
	               " WHERE num=?";
	         
	         //PreparedStatement 객체의 참조값 얻어오기
	         pstmt = conn.prepareStatement(sql);
	         //? 에 바인딩할 내용이 있으면 여기서 바인딩
	         pstmt.setString(1, dto.getWriter());
	         pstmt.setInt(2, dto.getNum());
	         //select 문 수행하고 결과를 ResultSet 으로 받아오기
	         rs = pstmt.executeQuery();
	         //ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
	         if(rs.next()) {
	     		dto2=new BookingDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setViewCount(rs.getInt("viewCount"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setName(rs.getString("name"));
				dto2.setPhone(rs.getString("phone"));
				dto2.setClassName(rs.getString("className"));
				dto2.setClassDate(rs.getString("classDate"));
				dto2.setMention(rs.getString("mention"));	
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
	      return dto2;
	   }
	 
	public BookingDto getDataN(BookingDto dto) {
	      BookingDto dto2=null;
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      try {
	         //Connection 객체의 참조값 얻어오기 
	         conn = new DbcpBean().getConn();
	         //실행할 sql 문 작성
	         String sql = "SELECT *" + 
	               " FROM" + 
	               "   (SELECT num, viewCount, writer, name, phone, className, classDate, mention," + 
	               "   LAG(num, 1, 0) OVER(ORDER BY num DESC) AS prevNum," + 
	               "   LEAD(num, 1, 0) OVER(ORDER BY num DESC) nextNum" + 
	               "   FROM booking_board"+ 
	               "   WHERE name LIKE '%'||?||'%'" + 
	               "   ORDER BY num DESC)" + 
	               " WHERE num=?";
	         
	         //PreparedStatement 객체의 참조값 얻어오기
	         pstmt = conn.prepareStatement(sql);
	         //? 에 바인딩할 내용이 있으면 여기서 바인딩
	         pstmt.setString(1, dto.getName());
	         pstmt.setInt(2, dto.getNum());
	         //select 문 수행하고 결과를 ResultSet 으로 받아오기
	         rs = pstmt.executeQuery();
	         //ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
	         if(rs.next()) {
	     		dto2=new BookingDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setViewCount(rs.getInt("viewCount"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setName(rs.getString("name"));
				dto2.setPhone(rs.getString("phone"));
				dto2.setClassName(rs.getString("className"));
				dto2.setClassDate(rs.getString("classDate"));
				dto2.setMention(rs.getString("mention"));	
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
	      return dto2;
	   }
	 
	
	 public BookingDto getDataC(BookingDto dto) {
	      BookingDto dto2=null;
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      try {
	         //Connection 객체의 참조값 얻어오기 
	         conn = new DbcpBean().getConn();
	         //실행할 sql 문 작성
	         String sql = "SELECT *" + 
	               " FROM" + 
	               "   (SELECT num, viewCount, writer, name, phone, className, classDate, mention," + 
	               "   LAG(num, 1, 0) OVER(ORDER BY num DESC) AS prevNum," + 
	               "   LEAD(num, 1, 0) OVER(ORDER BY num DESC) nextNum" + 
	               "   FROM booking_board"+ 
	               "   WHERE className LIKE '%'||?||'%'" + 
	               "   ORDER BY num DESC)" + 
	               " WHERE num=?";
	         
	         //PreparedStatement 객체의 참조값 얻어오기
	         pstmt = conn.prepareStatement(sql);
	         //? 에 바인딩할 내용이 있으면 여기서 바인딩
	         pstmt.setString(1, dto.getClassName());
	         pstmt.setInt(2, dto.getNum());
	         //select 문 수행하고 결과를 ResultSet 으로 받아오기
	         rs = pstmt.executeQuery();
	         //ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
	         if(rs.next()) {
	     		dto2=new BookingDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setViewCount(rs.getInt("viewCount"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setName(rs.getString("name"));
				dto2.setPhone(rs.getString("phone"));
				dto2.setClassName(rs.getString("className"));
				dto2.setClassDate(rs.getString("classDate"));
				dto2.setMention(rs.getString("mention"));	
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
	      return dto2;
	   }
	 
	public BookingDto getData(BookingDto dto) {
		BookingDto dto2=null;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql문 작성
			 String sql = "SELECT *" + 
		               " FROM" + 
		               "   (SELECT num, viewCount, writer, name, phone, className, classDate, mention," + 
		               "   LAG(num, 1, 0) OVER(ORDER BY num DESC) AS prevNum," + 
		               "   LEAD(num, 1, 0) OVER(ORDER BY num DESC) nextNum" + 
		               "   FROM booking_board" + 
		               "   ORDER BY num DESC)" + 
		               " WHERE num=?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//?에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setInt(1, dto.getNum());
			//select 문 수행하고 결과를 ResultSet으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용 추출해서 원하는 Data type으로 포장하기
			if (rs.next()) {
				dto2=new BookingDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setViewCount(rs.getInt("viewCount"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setName(rs.getString("name"));
				dto2.setPhone(rs.getString("phone"));
				dto2.setClassName(rs.getString("className"));
				dto2.setClassDate(rs.getString("classDate"));
				dto2.setMention(rs.getString("mention"));	
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

		return dto2;
	}
	
	public boolean addViewCount(int num) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = "UPDATE booking_board"
						+ " SET viewCount=viewCount+1"
						+ " WHERE num=?";//이 템플릿을 불러왔을 때 커서가 여기서 시작
			pstmt = conn.prepareStatement(sql);
			//?에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setInt(1, num);
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
	
	public boolean insert(BookingDto dto) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		int flag = 0;
		try {
			conn = new DbcpBean().getConn();
			String sql = "INSERT INTO booking_board"
						+ " (num, viewCount, writer, name, phone, className, classDate, mention)"
						+ " VALUES(booking_board_seq.NEXTVAL, 0, ?, ?, ?, ?, ?, ?)";//이 템플릿을 불러왔을 때 커서가 여기서 시작
			pstmt = conn.prepareStatement(sql);
			//?에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getWriter());
			pstmt.setString(2, dto.getName());
			pstmt.setString(3, dto.getPhone());
			pstmt.setString(4, dto.getClassName());
			pstmt.setString(5, dto.getClassDate()); //우선 String으로 나중에 date로 변환시키자!
			pstmt.setString(6, dto.getMention());
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
	
	public List<BookingDto> getList(BookingDto dto){
		List<BookingDto> list = new ArrayList<BookingDto>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql문 작성
	         String sql = "SELECT *" + 
	                 "      FROM" + 
	                 "          (SELECT result1.*, ROWNUM AS rnum" + 
	                 "          FROM" + 
	                 "              (SELECT num,viewCount,writer,name,className,classDate" + 
	                 "              FROM booking_board" + 
	                 "              ORDER BY num DESC) result1)" + 
	                 "      WHERE rnum BETWEEN ? AND ?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//?에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setInt(1, dto.getStartRowNum());
			pstmt.setInt(2, dto.getEndRowNum());
			//select 문 수행하고 결과를 ResultSet으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용 추출해서 원하는 Data type으로 포장하기
			while (rs.next()) {
				BookingDto dto2 = new BookingDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setViewCount(rs.getInt("viewCount"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setName(rs.getString("name"));
				dto2.setClassName(rs.getString("className"));
				dto2.setClassDate(rs.getString("classDate"));
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
	
	public List<BookingDto> getListW(BookingDto dto){
		List<BookingDto> list = new ArrayList<BookingDto>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql문 작성
	         String sql = "SELECT *" + 
	                 "      FROM" + 
	                 "          (SELECT result1.*, ROWNUM AS rnum" + 
	                 "          FROM" + 
	                 "              (SELECT num,viewCount,writer,name,className,classDate" + 
	                 "              FROM booking_board" + 
	                 "			 	WHERE writer LIKE '%' || ? || '%' "+
	                 "              ORDER BY num DESC) result1)" + 
	                 "      WHERE rnum BETWEEN ? AND ?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//?에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getWriter());
			pstmt.setInt(2, dto.getStartRowNum());
			pstmt.setInt(3, dto.getEndRowNum());
			//select 문 수행하고 결과를 ResultSet으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용 추출해서 원하는 Data type으로 포장하기
			while (rs.next()) {
				BookingDto dto2 = new BookingDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setViewCount(rs.getInt("viewCount"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setName(rs.getString("name"));
				dto2.setClassName(rs.getString("className"));
				dto2.setClassDate(rs.getString("classDate"));
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
	
	public List<BookingDto> getListN(BookingDto dto){
		List<BookingDto> list = new ArrayList<BookingDto>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql문 작성
	         String sql = "SELECT *" + 
	                 "      FROM" + 
	                 "          (SELECT result1.*, ROWNUM AS rnum" + 
	                 "          FROM" + 
	                 "              (SELECT num,viewCount,writer,name,className,classDate" + 
	                 "              FROM booking_board" + 
	                 "			 	WHERE name LIKE '%' || ? || '%' "+
	                 "              ORDER BY num DESC) result1)" + 
	                 "      WHERE rnum BETWEEN ? AND ?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//?에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getName());
			pstmt.setInt(2, dto.getStartRowNum());
			pstmt.setInt(3, dto.getEndRowNum());
			//select 문 수행하고 결과를 ResultSet으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용 추출해서 원하는 Data type으로 포장하기
			while (rs.next()) {
				BookingDto dto2 = new BookingDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setViewCount(rs.getInt("viewCount"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setName(rs.getString("name"));
				dto2.setClassName(rs.getString("className"));
				dto2.setClassDate(rs.getString("classDate"));
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
	
	public List<BookingDto> getListC(BookingDto dto){
		List<BookingDto> list = new ArrayList<BookingDto>();
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql문 작성
	         String sql = "SELECT *" + 
	                 "      FROM" + 
	                 "          (SELECT result1.*, ROWNUM AS rnum" + 
	                 "          FROM" + 
	                 "              (SELECT num,viewCount,writer,name,className,classDate" + 
	                 "              FROM booking_board" + 
	                 "			 	WHERE className LIKE '%' || ? || '%' "+
	                 "              ORDER BY num DESC) result1)" + 
	                 "      WHERE rnum BETWEEN ? AND ?";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			//?에 바인딩할 내용이 있으면 여기서 바인딩
			pstmt.setString(1, dto.getClassName());
			pstmt.setInt(2, dto.getStartRowNum());
			pstmt.setInt(3, dto.getEndRowNum());
			//select 문 수행하고 결과를 ResultSet으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용 추출해서 원하는 Data type으로 포장하기
			while (rs.next()) {
				BookingDto dto2 = new BookingDto();
				dto2.setNum(rs.getInt("num"));
				dto2.setViewCount(rs.getInt("viewCount"));
				dto2.setWriter(rs.getString("writer"));
				dto2.setName(rs.getString("name"));
				dto2.setClassName(rs.getString("className"));
				dto2.setClassDate(rs.getString("classDate"));
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
	
	//전체 글의 갯수를 리턴하는 메소드
	public int getCount() {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql문 작성
			String sql = "SELECT NVL(MAX(ROWNUM), 0) AS num"
					+" FROM booking_board";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
		
			//select 문 수행하고 결과를 ResultSet으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용 추출해서 원하는 Data type으로 포장하기
			if (rs.next()) {
				count=rs.getInt("num");
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
	
	public int getCountC(BookingDto dto) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql문 작성
			String sql = "SELECT NVL(MAX(ROWNUM), 0) AS num"
					+" FROM booking_board"
					+" WHERE className LIKE '%'||?||'%' ";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getClassName());
			//select 문 수행하고 결과를 ResultSet으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용 추출해서 원하는 Data type으로 포장하기
			if (rs.next()) {
				count=rs.getInt("num");
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
	
	public int getCountN(BookingDto dto) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql문 작성
			String sql = "SELECT NVL(MAX(ROWNUM), 0) AS num"
					+" FROM booking_board"
					+" WHERE name LIKE '%'||?||'%' ";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getName());
			//select 문 수행하고 결과를 ResultSet으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용 추출해서 원하는 Data type으로 포장하기
			if (rs.next()) {
				count=rs.getInt("num");
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
	
	public int getCountW(BookingDto dto) {
		int count = 0;
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		try {
			//Connection 객체의 참조값 얻어오기
			conn = new DbcpBean().getConn();
			//실행할 sql문 작성
			String sql = "SELECT NVL(MAX(ROWNUM), 0) AS num"
					+" FROM booking_board"
					+" WHERE writer LIKE '%'||?||'%' ";
			//PreparedStatement 객체의 참조값 얻어오기
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, dto.getWriter());
			//select 문 수행하고 결과를 ResultSet으로 받아오기
			rs = pstmt.executeQuery();
			//반복문 돌면서 ResultSet 객체에 있는 내용 추출해서 원하는 Data type으로 포장하기
			if (rs.next()) {
				count=rs.getInt("num");
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