package test.homeW.dao;

public class HomeWCommentDao {
	
	private static HomeWCommentDao dao;
	private HomeWCommentDao() {};
	public static HomeWCommentDao getInstance() {
		if(dao==null) {
			dao=new HomeWCommentDao();
		}
		return dao;
	}
	
}
