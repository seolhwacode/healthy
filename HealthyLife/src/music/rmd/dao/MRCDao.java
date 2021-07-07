package music.rmd.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import music.rmd.dto.MRCDto;
import test.util.DbcpBean;

public class MRCDao {
	
	private static MRCDao dao;
	   /*
	    *  [ static 초기화 블럭 ]
	    *  - 이 클래스가 최초 사용될때 한번만 수행되는 블럭  
	    *  - static 자원을 초기화 할때 사용된다. 
	    */
	   static {
	      dao=new MRCDao();
	   }
	   private MRCDao() {}
	   //자신의 참조값을 리턴해주는 메소드 
	   public static MRCDao getInstance() {
	      return dao;
	   }
	   
	   //전체 댓글의 갯수를 리턴하는 메소드
	   public int getCount(int ref_group) {
	      int count=0;
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      try {
	         //Connection 객체의 참조값 얻어오기 
	         conn = new DbcpBean().getConn();
	         //실행할 sql 문 작성
	         String sql = "SELECT NVL(MAX(ROWNUM), 0) AS count "
	               + " FROM board_cafe_comment"
	               + " WHERE ref_group=?";
	         //PreparedStatement 객체의 참조값 얻어오기
	         pstmt = conn.prepareStatement(sql);
	         //? 에 바인딩할 내용이 있으면 여기서 바인딩
	         pstmt.setInt(1, ref_group);
	         //select 문 수행하고 결과를 ResultSet 으로 받아오기
	         rs = pstmt.executeQuery();
	         //ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
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
	   
	   //댓글 내용을 수정하는 메소드
	   public boolean update(MRCDto dto) {
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      int flag = 0;
	      try {
	         conn = new DbcpBean().getConn();
	         //실행할 sql 문 작성
	         String sql = "UPDATE board_cafe_comment"
	               + " SET content=?"
	               + " WHERE num=?";
	         pstmt = conn.prepareStatement(sql);
	         //? 에 바인딩할 내용이 있으면 여기서 바인딩
	         pstmt.setString(1, dto.getContent());
	         pstmt.setInt(2, dto.getNum());
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
	   
	   //댓글을 삭제하는 메소드
	   public boolean delete(int num) {
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      int flag = 0;
	      try {
	         conn = new DbcpBean().getConn();
	         //실행할 sql 문 작성
	         String sql = "UPDATE board_cafe_comment"
	               + " SET deleted='yes'"
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
	   
	   //댓글 목록을 리턴하는 메소드
	   public List<MRCDto> getList(MRCDto dto2){
	      List<MRCDto> list=new ArrayList<>();
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      try {
	         //Connection 객체의 참조값 얻어오기 
	         conn = new DbcpBean().getConn();
	         //실행할 sql 문 작성
	         String sql = "SELECT *" + 
	               " FROM" + 
	               "   (SELECT result1.*, ROWNUM AS rnum" + 
	               "    FROM" + 
	               "      (SELECT num, writer, content, target_id, ref_group," + 
	               "      comment_group, deleted, board_cafe_comment.regdate, profile" + 
	               "      FROM board_cafe_comment" + 
	               "      INNER JOIN users" + 
	               "      ON board_cafe_comment.writer = users.id" + 
	               "      WHERE ref_group=?" + 
	               "      ORDER BY comment_group DESC, num ASC) result1)" + 
	               " WHERE rnum BETWEEN ? AND ?";
	         //PreparedStatement 객체의 참조값 얻어오기
	         pstmt = conn.prepareStatement(sql);
	         //? 에 바인딩할 내용이 있으면 여기서 바인딩
	         pstmt.setInt(1, dto2.getRef_group());
	         pstmt.setInt(2, dto2.getStartRowNum());
	         pstmt.setInt(3, dto2.getEndRowNum());
	         //select 문 수행하고 결과를 ResultSet 으로 받아오기
	         rs = pstmt.executeQuery();
	         //반복문 돌면서 ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
	         while (rs.next()) {
	            MRCDto dto=new MRCDto();
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
	   
	   //댓글의 시퀀스값을 미리 리턴해주는 메소드
	   public int getSequence() {
	      int seq=0;
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      ResultSet rs = null;
	      try {
	         //Connection 객체의 참조값 얻어오기 
	         conn = new DbcpBean().getConn();
	         //실행할 sql 문 작성
	         String sql = "SELECT board_cafe_comment_seq.NEXTVAL AS seq"
	               + " FROM DUAL";
	         //PreparedStatement 객체의 참조값 얻어오기
	         pstmt = conn.prepareStatement(sql);
	         //? 에 바인딩할 내용이 있으면 여기서 바인딩
	         //select 문 수행하고 결과를 ResultSet 으로 받아오기
	         rs = pstmt.executeQuery();
	         //ResultSet 객체에 있는 내용을 추출해서 원하는 Data type 으로 포장하기
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
	   //댓글 추가
	   public boolean insert(MRCDto dto) {
	      Connection conn = null;
	      PreparedStatement pstmt = null;
	      int flag = 0;
	      try {
	         conn = new DbcpBean().getConn();
	         //실행할 sql 문 작성
	         String sql = "INSERT INTO board_cafe_comment"
	               + " (num, writer, content, target_id, ref_group, comment_group, regdate)"
	               + " VALUES(?, ?, ?, ?, ?, ?, SYSDATE)";
	         pstmt = conn.prepareStatement(sql);
	         //? 에 바인딩할 내용이 있으면 여기서 바인딩
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

