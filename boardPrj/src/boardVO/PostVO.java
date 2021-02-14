package boardVO;

public class PostVO {
	private String boardTitle;
	private String id;
	private String boardDate;
	private String boardContent;
	
	public PostVO() {
	}

	public PostVO(String boardTitle, String id, String boardDate, String boardContent) {
		super();
		this.boardTitle = boardTitle;
		this.id = id;
		this.boardDate = boardDate;
		this.boardContent = boardContent;
	}

	public String getBoardTitle() {
		return boardTitle;
	}

	public String getId() {
		return id;
	}

	public String getBoardDate() {
		return boardDate;
	}

	public String getBoardContent() {
		return boardContent;
	}
	
}
