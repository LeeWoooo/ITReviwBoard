package boardVO;

public class PostBean {
	
	private String boardTitle;
	private String boardContent;
	
	public PostBean() {
	}

	public PostBean(String boardTitle, String boardContent) {
		super();
		this.boardTitle = boardTitle;
		this.boardContent = boardContent;
	}

	public String getBoardTitle() {
		return boardTitle;
	}

	public void setBoardTitle(String boardTitle) {
		this.boardTitle = boardTitle;
	}

	public String getBoardContent() {
		return boardContent;
	}

	public void setBoardContent(String boardContent) {
		this.boardContent = boardContent;
	}
	
	
}
