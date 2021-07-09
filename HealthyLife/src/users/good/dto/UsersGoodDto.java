package users.good.dto;

public class UsersGoodDto {
	private String id;
	private int video_board_num;
	
	public UsersGoodDto() {}

	public UsersGoodDto(String id, int video_board_num) {
		super();
		this.id = id;
		this.video_board_num = video_board_num;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public int getVideo_board_num() {
		return video_board_num;
	}

	public void setVideo_board_num(int video_board_num) {
		this.video_board_num = video_board_num;
	}
	
	
}
