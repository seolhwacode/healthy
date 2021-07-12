package hfood.board.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import hfood.board.dto.HfoodDto;
import test.util.DbcpBean;

public class HfoodDao {
	private static HfoodDao dao;
	private HfoodDao() {}
	public static HfoodDao getInstance() {
		if(dao==null) {
			dao=new HfoodDao();
		}
		return dao;
	}
	
	 	//조회수 증가 시키는 메소드
	   	public boolean addViewCount(int num) {
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      int flag = 0;
	      try {
	         conn = new DbcpBean().getConn();
	         //실행할 sql 문 작성
	         String sql = "UPDATE hfood_board"
	               + " SET viewCount=viewCount+1"
	               + " WHERE num=?";
	         pstmt = conn.prepareStatement(sql);
	         //? 에 바인딩할 내용이 있으면 여기서 바인딩
	         pstmt.setInt(1, num);
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
	   
	   	// 글 하나의 정보를 수정하는 메소드
		public boolean update(HfoodDto dto) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			int flag = 0;
			try {
				conn = new DbcpBean().getConn();
				String sql = "update hfood_board"
						+ " set title=?, content=?"
						+ " where num=?";
				pstmt = conn.prepareStatement(sql);
				//? 에 바인딩할 내용이 있으면 여기서 바인딩
				pstmt.setString(1, dto.getTitle());
				pstmt.setString(2, dto.getContent());
				pstmt.setInt(3, dto.getNum());
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
	
		
		// 글 하나의 정보를 갖고오는 메소드
		public HfoodDto getData(int num) {
			HfoodDto dto2=null;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				//Connection 객체의 참조값 얻어오기 
				conn = new DbcpBean().getConn();
				//실행할 sql 문 작성
				String sql = "select num, title, writer, content, regdate, viewcount"
						+" from hfood_board"
						+" where num=?";
				//PreparedStatement 객체의 참조값 얻어오기
				pstmt = conn.prepareStatement(sql);
				//? 에 바인딩할 내용이 있으면 여기서 바인딩
				pstmt.setInt(1, num);
				//select 문 수행하고 결과를 ResultSet 으로 받아오기
				rs = pstmt.executeQuery();
				//반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
				if (rs.next()) {
					dto2=new HfoodDto();
					dto2.setNum(rs.getInt("num"));
		            dto2.setWriter(rs.getString("writer"));
		            dto2.setTitle(rs.getString("title"));
		            dto2.setContent(rs.getString("content"));
		            dto2.setViewCount(rs.getInt("viewCount"));
		            dto2.setRegdate(rs.getString("regdate"));
		            
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
		
		// 페이징 처리와 함께 글 하나의 정보를 리턴하는 메소드
		public HfoodDto getData(HfoodDto dto) {
			HfoodDto dto2=null;
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			try {
				//Connection 객체의 참조값 얻어오기 
				conn = new DbcpBean().getConn();
				//실행할 sql 문 작성
				String sql = "SELECT *" + 
			               " FROM" + 
			               "   (SELECT num,title,writer,content,viewCount,regdate," + 
			               "   LAG(num, 1, 0) OVER(ORDER BY num DESC) AS prevNum," + 
			               "   LEAD(num, 1, 0) OVER(ORDER BY num DESC) nextNum" + 
			               "   FROM hfood_board" + 
			               "   ORDER BY num DESC)" + 
			               " WHERE num=?";
			         
				//PreparedStatement 객체의 참조값 얻어오기
				pstmt = conn.prepareStatement(sql);
				//? 에 바인딩할 내용이 있으면 여기서 바인딩
				pstmt.setInt(1, dto.getNum());
				//select 문 수행하고 결과를 ResultSet 으로 받아오기
				rs = pstmt.executeQuery();
				//반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
				if(rs.next()) {
		            dto2=new HfoodDto();
		            dto2.setNum(rs.getInt("num"));
		            dto2.setWriter(rs.getString("writer"));
		            dto2.setTitle(rs.getString("title"));
		            dto2.setContent(rs.getString("content"));
		            dto2.setViewCount(rs.getInt("viewCount"));
		            dto2.setRegdate(rs.getString("regdate"));
		            dto2.setPrevNum(rs.getInt("prevNum"));
		            dto2.setNextNum(rs.getInt("nextNum"));
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
		
			// 제목검색 리스트 페이징 처리
		   	public HfoodDto getDataT(HfoodDto dto) {
			      HfoodDto dto2=null;
			      Connection conn = null;
			      PreparedStatement pstmt = null;
			      ResultSet rs = null;
			      try {
			         //Connection 객체의 참조값 얻어오기 
			         conn = new DbcpBean().getConn();
			         //실행할 sql 문 작성
			         String sql = "SELECT *" + 
			               " FROM" + 
			               "   (SELECT num,title,writer,content,viewCount,regdate," + 
			               "   LAG(num, 1, 0) OVER(ORDER BY num DESC) AS prevNum," + 
			               "   LEAD(num, 1, 0) OVER(ORDER BY num DESC) nextNum" + 
			               "   FROM hfood_board"+ 
			               "   WHERE title LIKE '%'||?||'%'" + 
			               "   ORDER BY num DESC)" + 
			               " WHERE num=?";
			         
			         //PreparedStatement 객체의 참조값 얻어오기
			         pstmt = conn.prepareStatement(sql);
			         //? 에 바인딩할 내용이 있으면 여기서 바인딩
			         pstmt.setString(1, dto.getTitle());
			         pstmt.setInt(2, dto.getNum());
			         //select 문 수행하고 결과를 ResultSet 으로 받아오기
			         rs = pstmt.executeQuery();
			         //ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
			         if(rs.next()) {
			            dto2=new HfoodDto();
			            dto2.setNum(rs.getInt("num"));
			            dto2.setWriter(rs.getString("writer"));
			            dto2.setTitle(rs.getString("title"));
			            dto2.setContent(rs.getString("content"));
			            dto2.setViewCount(rs.getInt("viewCount"));
			            dto2.setRegdate(rs.getString("regdate"));
			            dto2.setPrevNum(rs.getInt("prevNum"));
			            dto2.setNextNum(rs.getInt("nextNum"));
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
		   
		   	// 작성자로 검색한 리스트 페이징 처리
		   public HfoodDto getDataW(HfoodDto dto) {
			      HfoodDto dto2=null;
			      Connection conn = null;
			      PreparedStatement pstmt = null;
			      ResultSet rs = null;
			      try {
			         //Connection 객체의 참조값 얻어오기 
			         conn = new DbcpBean().getConn();
			         //실행할 sql 문 작성
			         String sql = "SELECT *" + 
			               " FROM" + 
			               "   (SELECT num,title,writer,content,viewCount,regdate," + 
			               "   LAG(num, 1, 0) OVER(ORDER BY num DESC) AS prevNum," + 
			               "   LEAD(num, 1, 0) OVER(ORDER BY num DESC) nextNum" + 
			               "   FROM hfood_board"+ 
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
			            dto2=new HfoodDto();
			            dto2.setNum(rs.getInt("num"));
			            dto2.setWriter(rs.getString("writer"));
			            dto2.setTitle(rs.getString("title"));
			            dto2.setContent(rs.getString("content"));
			            dto2.setViewCount(rs.getInt("viewCount"));
			            dto2.setRegdate(rs.getString("regdate"));
			            dto2.setPrevNum(rs.getInt("prevNum"));
			            dto2.setNextNum(rs.getInt("nextNum"));
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
		   // 제목과 내용으로 검색한 리스트 페이징 처리 
		   public HfoodDto getDataTC(HfoodDto dto) {
			      HfoodDto dto2=null;
			      Connection conn = null;
			      PreparedStatement pstmt = null;
			      ResultSet rs = null;
			      try {
			         //Connection 객체의 참조값 얻어오기 
			         conn = new DbcpBean().getConn();
			         //실행할 sql 문 작성
			         String sql = "SELECT *" + 
			               " FROM" + 
			               "   (SELECT num,title,writer,content,viewCount,regdate," + 
			               "   LAG(num, 1, 0) OVER(ORDER BY num DESC) AS prevNum," + 
			               "   LEAD(num, 1, 0) OVER(ORDER BY num DESC) nextNum" + 
			               "   FROM hfood_board"+ 
			               "   WHERE title LIKE '%'||?||'%' OR content LIKE '%'||?||'%'" + 
			               "   ORDER BY num DESC)" + 
			               " WHERE num=?";
			         
			         //PreparedStatement 객체의 참조값 얻어오기
			         pstmt = conn.prepareStatement(sql);
			         //? 에 바인딩할 내용이 있으면 여기서 바인딩
			         pstmt.setString(1, dto.getTitle());
			         pstmt.setString(2, dto.getContent());
			         pstmt.setInt(3, dto.getNum());
			         //select 문 수행하고 결과를 ResultSet 으로 받아오기
			         rs = pstmt.executeQuery();
			         //ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
			         if(rs.next()) {
			            dto2=new HfoodDto();
			            dto2.setNum(rs.getInt("num"));
			            dto2.setWriter(rs.getString("writer"));
			            dto2.setTitle(rs.getString("title"));
			            dto2.setContent(rs.getString("content"));
			            dto2.setViewCount(rs.getInt("viewCount"));
			            dto2.setRegdate(rs.getString("regdate"));
			            dto2.setPrevNum(rs.getInt("prevNum"));
			            dto2.setNextNum(rs.getInt("nextNum"));
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
		// 삭제하는 메소드
		public boolean delete(int num) {
			Connection conn = null;
			PreparedStatement pstmt = null;
			int flag = 0;
			try {
				conn = new DbcpBean().getConn();
				String sql = "delete from hfood_board"
						+ "	where num=?";
				pstmt = conn.prepareStatement(sql);
				//? 에 바인딩할 내용이 있으면 여기서 바인딩
				 pstmt.setInt(1, num);
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
		//새글 저장하는 메소드 
	   	public boolean insert(HfoodDto dto) {
	   		Connection conn = null;
		    PreparedStatement pstmt = null;
		    int flag = 0;
		    try {
	        conn = new DbcpBean().getConn();
	         //실행할 insert, update, delete 문 구성
	        String sql = "INSERT INTO hfood_board"
	               + " (num,writer,title,content,viewCount,regdate)"
	               + " VALUES(hfood_board_seq.NEXTVAL,?,?,?,0,SYSDATE)";
	        pstmt = conn.prepareStatement(sql);
	         //? 에 바인딩할 내용이 있으면 바인딩한다.
	        pstmt.setString(1, dto.getWriter());
	        pstmt.setString(2, dto.getTitle());
	        pstmt.setString(3, dto.getContent());
	        flag = pstmt.executeUpdate(); //sql 문 실행하고 변화된 row 갯수 리턴 받기
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
	   
	   //글 목록을 리턴하는 메소드 
	   public List<HfoodDto> getList(HfoodDto dto){
	      //글목록을 담을 ArrayList 객체 생성
	      List<HfoodDto> list=new ArrayList<HfoodDto>();
	      
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      try {
	         conn = new DbcpBean().getConn();
	         //select 문 작성
	         String sql = "SELECT *" + 
	               "      FROM" + 
	               "          (SELECT result1.*, ROWNUM AS rnum" + 
	               "          FROM" + 
	               "              (SELECT num,writer,title,viewCount,regdate" + 
	               "              FROM hfood_board" + 
	               "              ORDER BY num DESC) result1)" + 
	               "      WHERE rnum BETWEEN ? AND ?";
	         pstmt = conn.prepareStatement(sql);
	         // ? 에 바인딩 할게 있으면 여기서 바인딩한다.
	         pstmt.setInt(1, dto.getStartRowNum());
	         pstmt.setInt(2, dto.getEndRowNum());
	         //select 문 수행하고 ResultSet 받아오기
	         rs = pstmt.executeQuery();
	         //while문 혹은 if문에서 ResultSet 으로 부터 data 추출
	         while (rs.next()) {
	            HfoodDto dto2=new HfoodDto();
	            dto2.setNum(rs.getInt("num"));
	            dto2.setWriter(rs.getString("writer"));
	            dto2.setTitle(rs.getString("title"));
	            dto2.setViewCount(rs.getInt("viewCount"));
	            dto2.setRegdate(rs.getString("regdate"));
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
	   
	   	//제목으로 검색한 리스트 리턴 
	   	public List<HfoodDto> getListT(HfoodDto dto){
		      //글목록을 담을 ArrayList 객체 생성
		      List<HfoodDto> list=new ArrayList<HfoodDto>();
		      
		      Connection conn = null;
		      PreparedStatement pstmt = null;
		      ResultSet rs = null;
		      try {
		         conn = new DbcpBean().getConn();
		         //select 문 작성
		         String sql = "SELECT *" + 
		               "      FROM" + 
		               "          (SELECT result1.*, ROWNUM AS rnum" + 
		               "          FROM" + 
		               "              (SELECT num,writer,title,viewCount,regdate" + 
		               "              FROM hfood_board" +
		               "			  WHERE title LIKE '%' || ? || '%' "+
		               "              ORDER BY num DESC) result1)" + 
		               "      WHERE rnum BETWEEN ? AND ?";
		         pstmt = conn.prepareStatement(sql);
		         // ? 에 바인딩 할게 있으면 여기서 바인딩한다.
		         pstmt.setString(1, dto.getTitle());
		         pstmt.setInt(2, dto.getStartRowNum());
		         pstmt.setInt(3, dto.getEndRowNum());
		         //select 문 수행하고 ResultSet 받아오기
		         rs = pstmt.executeQuery();
		         //while문 혹은 if문에서 ResultSet 으로 부터 data 추출
		         while (rs.next()) {
		            HfoodDto dto2=new HfoodDto();
		            dto2.setNum(rs.getInt("num"));
		            dto2.setWriter(rs.getString("writer"));
		            dto2.setTitle(rs.getString("title"));
		            dto2.setViewCount(rs.getInt("viewCount"));
		            dto2.setRegdate(rs.getString("regdate"));
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
	   // 작성자로 검색한 결과 리스트 리턴
	   public List<HfoodDto> getListW(HfoodDto dto){
		      //글목록을 담을 ArrayList 객체 생성
		      List<HfoodDto> list=new ArrayList<HfoodDto>();
		      
		      Connection conn = null;
		      PreparedStatement pstmt = null;
		      ResultSet rs = null;
		      try {
		         conn = new DbcpBean().getConn();
		         //select 문 작성
		         String sql = "SELECT *" + 
		               "      FROM" + 
		               "          (SELECT result1.*, ROWNUM AS rnum" + 
		               "          FROM" + 
		               "              (SELECT num,writer,title,viewCount,regdate" + 
		               "              FROM hfood_board" +
		               "			  WHERE writer LIKE '%' || ? || '%' "+
		               "              ORDER BY num DESC) result1)" + 
		               "      WHERE rnum BETWEEN ? AND ?";
		         pstmt = conn.prepareStatement(sql);
		         // ? 에 바인딩 할게 있으면 여기서 바인딩한다.
		         pstmt.setString(1, dto.getWriter());
		         pstmt.setInt(2, dto.getStartRowNum());
		         pstmt.setInt(3, dto.getEndRowNum());
		         //select 문 수행하고 ResultSet 받아오기
		         rs = pstmt.executeQuery();
		         //while문 혹은 if문에서 ResultSet 으로 부터 data 추출
		         while (rs.next()) {
		            HfoodDto dto2=new HfoodDto();
		            dto2.setNum(rs.getInt("num"));
		            dto2.setWriter(rs.getString("writer"));
		            dto2.setTitle(rs.getString("title"));
		            dto2.setViewCount(rs.getInt("viewCount"));
		            dto2.setRegdate(rs.getString("regdate"));
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
	   
	   //제목과 내용으로 검색한 리스트 리턴 
	   public List<HfoodDto> getListTC(HfoodDto dto){
		      //글목록을 담을 ArrayList 객체 생성
		      List<HfoodDto> list=new ArrayList<HfoodDto>();
		      
		      Connection conn = null;
		      PreparedStatement pstmt = null;
		      ResultSet rs = null;
		      try {
		         conn = new DbcpBean().getConn();
		         //select 문 작성
		         String sql = "SELECT *" + 
		               "      FROM" + 
		               "          (SELECT result1.*, ROWNUM AS rnum" + 
		               "          FROM" + 
		               "              (SELECT num,writer,title,viewCount,regdate" + 
		               "              FROM hfood_board" +
		               "			  WHERE title LIKE '%' || ? || '%' or content LIKE '%' || ? || '%'"+
		               "              ORDER BY num DESC) result1)" + 
		               "      WHERE rnum BETWEEN ? AND ?";
		         pstmt = conn.prepareStatement(sql);
		         // ? 에 바인딩 할게 있으면 여기서 바인딩한다.
		         pstmt.setString(1, dto.getTitle());
		         pstmt.setString(2, dto.getContent());
		         pstmt.setInt(3, dto.getStartRowNum());
		         pstmt.setInt(4, dto.getEndRowNum());
		         //select 문 수행하고 ResultSet 받아오기
		         rs = pstmt.executeQuery();
		         //while문 혹은 if문에서 ResultSet 으로 부터 data 추출
		         while (rs.next()) {
		            HfoodDto dto2=new HfoodDto();
		            dto2.setNum(rs.getInt("num"));
		            dto2.setWriter(rs.getString("writer"));
		            dto2.setTitle(rs.getString("title"));
		            dto2.setViewCount(rs.getInt("viewCount"));
		            dto2.setRegdate(rs.getString("regdate"));
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
	      //글의 갯수를 담을 지역변수 
	      int count=0;
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      try {
	         conn = new DbcpBean().getConn();
	         //select 문 작성
	         String sql = "SELECT NVL(MAX(ROWNUM), 0) AS num "
	               + " FROM hfood_board";
	         pstmt = conn.prepareStatement(sql);
	         // ? 에 바인딩 할게 있으면 여기서 바인딩한다.

	         //select 문 수행하고 ResultSet 받아오기
	         rs = pstmt.executeQuery();
	         //while문 혹은 if문에서 ResultSet 으로 부터 data 추출
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
	   
	   public int getCountT(HfoodDto dto) {
		      //글의 갯수를 담을 지역변수 
		      int count=0;
		      Connection conn = null;
		      PreparedStatement pstmt = null;
		      ResultSet rs = null;
		      try {
		         conn = new DbcpBean().getConn();
		         //select 문 작성
		         String sql = "SELECT NVL(MAX(ROWNUM), 0) AS num "
		                 + " FROM hfood_board"
		                 + " WHERE title LIKE '%'||?||'%' ";
		         pstmt = conn.prepareStatement(sql);
		         // ? 에 바인딩 할게 있으면 여기서 바인딩한다.
		         pstmt.setString(1, dto.getTitle());
		         //select 문 수행하고 ResultSet 받아오기
		         rs = pstmt.executeQuery();
		         //while문 혹은 if문에서 ResultSet 으로 부터 data 추출
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
	   
	   public int getCountW(HfoodDto dto) {
		      //글의 갯수를 담을 지역변수 
		      int count=0;
		      Connection conn = null;
		      PreparedStatement pstmt = null;
		      ResultSet rs = null;
		      try {
		         conn = new DbcpBean().getConn();
		         //select 문 작성
		         String sql = "SELECT NVL(MAX(ROWNUM), 0) AS num "
		                 + " FROM hfood_board"
		                 + " WHERE writer LIKE '%'||?||'%' ";
		         pstmt = conn.prepareStatement(sql);
		         // ? 에 바인딩 할게 있으면 여기서 바인딩한다.
		         pstmt.setString(1, dto.getWriter());
		         //select 문 수행하고 ResultSet 받아오기
		         rs = pstmt.executeQuery();
		         //while문 혹은 if문에서 ResultSet 으로 부터 data 추출
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
	   
	   public int getCountTC(HfoodDto dto) {
		      //글의 갯수를 담을 지역변수 
		      int count=0;
		      Connection conn = null;
		      PreparedStatement pstmt = null;
		      ResultSet rs = null;
		      try {
		         conn = new DbcpBean().getConn();
		         //select 문 작성
		         String sql = "SELECT NVL(MAX(ROWNUM), 0) AS num "
		                 + " FROM hfood_board"
		                 + " WHERE title LIKE '%'||?||'%' or content LIKE '%'||?||'%' ";
		         pstmt = conn.prepareStatement(sql);
		         // ? 에 바인딩 할게 있으면 여기서 바인딩한다.
		         pstmt.setString(1, dto.getTitle());
		         pstmt.setString(2, dto.getContent());
		         //select 문 수행하고 ResultSet 받아오기
		         rs = pstmt.executeQuery();
		         //while문 혹은 if문에서 ResultSet 으로 부터 data 추출
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


