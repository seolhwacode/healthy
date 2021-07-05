package test.homeW.dao;

public class HomeWAdDao {

	private static HomeWAdDao dao;
	private HomeWAdDao() {};
	public static HomeWAdDao getInstance() {
		if(dao==null) {
			dao=new HomeWAdDao();
		}
		return dao;
	}
	
	
	
}
