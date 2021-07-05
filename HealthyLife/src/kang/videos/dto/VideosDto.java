package kang.videos.dto;

public class VideosDto {
	private int num;	//글번호
	private String writer;	//작성자(users의 id)
	private String title;	//글 제목
	private String content;	//글 내용
	private String video;	//비디오 link
	private int view_count;	//조회수
	private String regdate;	//글 작성일
	private int good_count;	//좋아요 수
	private String type;	//게시판 종류(운동 분류)
	private int startRowNum;	//출력할 시작 row num
	private int endRowNum;		//출력할 끝 row num
	private int prevNum;	//이전 글 번호
	private int nextNum;	//다음 글 번호
	
	public VideosDto() {}

	public VideosDto(int num, String writer, String title, String content, String video, int view_count, String regdate,
			int good_count, String type, int startRowNum, int endRowNum, int prevNum, int nextNum) {
		super();
		this.num = num;
		this.writer = writer;
		this.title = title;
		this.content = content;
		this.video = video;
		this.view_count = view_count;
		this.regdate = regdate;
		this.good_count = good_count;
		this.type = type;
		this.startRowNum = startRowNum;
		this.endRowNum = endRowNum;
		this.prevNum = prevNum;
		this.nextNum = nextNum;
	}

	public VideosDto(int num) {
		super();
		this.num = num;
	}

	public VideosDto(String type) {
		super();
		this.type = type;
	}

	public VideosDto(int startRowNum, int endRowNum) {
		super();
		this.startRowNum = startRowNum;
		this.endRowNum = endRowNum;
	}

	public int getNum() {
		return num;
	}

	public void setNum(int num) {
		this.num = num;
	}

	public String getWriter() {
		return writer;
	}

	public void setWriter(String writer) {
		this.writer = writer;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getVideo() {
		return video;
	}

	public void setVideo(String video) {
		this.video = video;
	}

	public int getView_count() {
		return view_count;
	}

	public void setView_count(int view_count) {
		this.view_count = view_count;
	}

	public String getRegdate() {
		return regdate;
	}

	public void setRegdate(String regdate) {
		this.regdate = regdate;
	}

	public int getGood_count() {
		return good_count;
	}

	public void setGood_count(int good_count) {
		this.good_count = good_count;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public int getStartRowNum() {
		return startRowNum;
	}

	public void setStartRowNum(int startRowNum) {
		this.startRowNum = startRowNum;
	}

	public int getEndRowNum() {
		return endRowNum;
	}

	public void setEndRowNum(int endRowNum) {
		this.endRowNum = endRowNum;
	}

	public int getPrevNum() {
		return prevNum;
	}

	public void setPrevNum(int prevNum) {
		this.prevNum = prevNum;
	}

	public int getNextNum() {
		return nextNum;
	}

	public void setNextNum(int nextNum) {
		this.nextNum = nextNum;
	}
	
}
