package test.homeW.dao;

public class HomeWDao {
	
	private static HomeWDao dao;
	private HomeWDao() {}
	public static HomeWDao getInstance() {
		if(dao==null) {
			dao=new HomeWDao ();
		}
		return dao;
	}
	
	//글 목록을 리턴하는 메소드
	
}
