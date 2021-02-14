package boardVO;

public class BoardVO {

	
	private int boardID;
	private String boardTitle;
	private String id;
	private String boardDate;
	
	public BoardVO() {
	}
	
	public BoardVO(int boardID, String boardTitle, String id, String boardDate) {
		super();
		this.boardID = boardID;
		this.boardTitle = boardTitle;
		this.id = id;
		this.boardDate = boardDate;
	}

	public int getBoardID() {
		return boardID;
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
	
	
}
