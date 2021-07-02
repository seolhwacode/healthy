package test.users.dto;

public class UsersDto {
	private String id;	//id
	private String pwd;	//password
	private String profile;	//프로필 이미지 경로
	private String regdate;	//가입일
	
	
	//default 생성자
	public UsersDto() {}


	public UsersDto(String id, String pwd, String profile, String regdate) {
		super();
		this.id = id;
		this.pwd = pwd;
		this.profile = profile;
		this.regdate = regdate;
	}


	public String getId() {
		return id;
	}


	public void setId(String id) {
		this.id = id;
	}


	public String getPwd() {
		return pwd;
	}


	public void setPwd(String pwd) {
		this.pwd = pwd;
	}


	public String getProfile() {
		return profile;
	}


	public void setProfile(String profile) {
		this.profile = profile;
	}


	public String getRegdate() {
		return regdate;
	}


	public void setRegdate(String regdate) {
		this.regdate = regdate;
	}
	
}
