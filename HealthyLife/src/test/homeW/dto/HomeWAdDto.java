package test.homeW.dto;

public class HomeWAdDto {

	private int num;
	private String img;
	private String link;
	
	public HomeWAdDto() {}

	public HomeWAdDto(int num, String img, String link) {
		super();
		this.num = num;
		this.img = img;
		this.link = link;
	}

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	public String getImg() {
		return img;
	}

	public void setImg(String img) {
		this.img = img;
	}

	public String getLink() {
		return link;
	}

	public void setLink(String link) {
		this.link = link;
	}
	
	
}
