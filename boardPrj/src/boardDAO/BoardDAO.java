package boardDAO;

import java.io.BufferedReader;
import java.io.IOException;
import java.sql.Clob;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import boardVO.BoardVO;
import boardVO.PostBean;
import boardVO.PostVO;

public class BoardDAO {

	private static BoardDAO bDAO;

	private BoardDAO() {
	}

	public static BoardDAO getInstance() {
		if (bDAO == null) {
			bDAO = new BoardDAO();
		}
		return bDAO;
	};

	public Connection getConnection() throws SQLException {
		try {
			Class.forName("oracle.jdbc.OracleDriver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} // 드라이버 로딩

		String url = "jdbc:oracle:thin:@localhost:1521:orcl";
		String user = "scott";
		String password = "tiger";
		return DriverManager.getConnection(url, user, password);
	}// getConnection

	public List<BoardVO> loadBoard(int pageNumber) {
		List<BoardVO> list = new ArrayList<BoardVO>();
		String sql = new StringBuilder()
				.append("SELECT BOARDID,BOARDTITLE,ID,TO_CHAR(BOARDDATE,'yyyy-MM-DD HH24:MI:SS') BOARDDATE, SEQ FROM ")
				.append("(SELECT BOARDID, BOARDTITLE,ID,BOARDDATE, ROW_NUMBER()OVER(ORDER BY BOARDID DESC) SEQ ")
				.append("FROM REVIEWBOARD WHERE BOARDID > 0 AND BOARDAVAILABLE = 1) ")
				.append("WHERE SEQ > ? AND SEQ <= ? ").toString();
		try (Connection con = bDAO.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)) {
			// 페이징 처리
			pstmt.setInt(1, (5 * pageNumber) - 5);
			pstmt.setInt(2, (5 * pageNumber));
			try (ResultSet rs = pstmt.executeQuery()) {
				BoardVO bVO = null;
				while (rs.next()) {
					bVO = new BoardVO(rs.getInt("BOARDID"), rs.getString("BOARDTITLE"), rs.getString("ID"),
							rs.getString("BOARDDATE"));
					list.add(bVO);
				} // while
			} // end try
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return list;
	}// loadBoard

	// 현재 pageNumber번호보다 1 큰수로 조회했을 때 검색 결과가 있으면 다음페이지 존재
	public boolean nextPage(int pageNumber) {
		boolean flag = false;
		String sql = new StringBuilder().append("SELECT BOARDID, SEQ FROM ")
				.append("(SELECT BOARDID, ROW_NUMBER()OVER(ORDER BY BOARDDATE DESC) SEQ ")
				.append("FROM REVIEWBOARD WHERE BOARDID > 0 AND BOARDAVAILABLE = 1) ")
				.append("WHERE SEQ > ? AND SEQ <= ?").toString();
		try (Connection con = bDAO.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)) {
			pstmt.setInt(1, (5 * pageNumber) - 5);
			pstmt.setInt(2, (5 * pageNumber));
			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					flag = true;
				} // end if
			} // try
		} catch (SQLException e) {
			e.printStackTrace();
		} // end catch
		return flag;
	}// nextPage

	//CLOB는 로컬일때 rs.getString로 가져올 수 있지만 서버에 올라가 있는 것이라면 getString이 아닌 스트림을 연결하여 사용해야한다.
	public PostVO loadPost(int boardID) {
		PostVO pVO = null;
		String sql = "SELECT BOARDTITLE,ID,TO_CHAR(BOARDDATE,'yyyy-MM-DD HH24:MI:SS') BOARDDATE,BOARDCONTENT FROM REVIEWBOARD WHERE BOARDID=?";
		try (Connection con = bDAO.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)) {
			pstmt.setInt(1, boardID);
			try (ResultSet rs = pstmt.executeQuery()) {
				String readContent = "";
				StringBuilder sbContent = new StringBuilder();
				if(rs.next()) {
					Clob clob = rs.getClob("BOARDCONTENT");
					try(BufferedReader br = new BufferedReader(clob.getCharacterStream())){
						while((readContent=br.readLine())!=null) {
							sbContent.append(readContent);
						}
					}catch(IOException e) {
						e.printStackTrace();
					}
				}//end if
				pVO = new PostVO(rs.getString("BOARDTITLE"), rs.getString("ID"), rs.getString("BOARDDATE"), sbContent.toString());
			}//end try
			}catch (SQLException e) {
				e.printStackTrace();
			}//end catch
		return pVO;
	}// loadPost

	public int insertPost(String userID, PostBean pBean) {
		int flag = -1;
		String sql = "INSERT INTO REVIEWBOARD VALUES ((SELECT NVL(MAX(BOARDID),0)+1 BOARDID FROM REVIEWBOARD),?,?,SYSDATE,?,?)";
		try(Connection con = bDAO.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)){
			pstmt.setString(1, pBean.getBoardTitle());
			pstmt.setString(2, pBean.getBoardContent());
			pstmt.setString(3, userID);
			pstmt.setInt(4, 1);
			flag = pstmt.executeUpdate();
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}
	
	public int updatePost(int boardID,PostBean pBean) {
		int flag=-1;
		String sql = "UPDATE REVIEWBOARD SET BOARDTITLE=?,BOARDCONTENT=? ,BOARDDATE=SYSDATE WHERE BOARDID=?";
		try(Connection con = bDAO.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)){
			pstmt.setString(1, pBean.getBoardTitle());
			pstmt.setString(2, pBean.getBoardContent());
			pstmt.setInt(3, boardID);
			flag = pstmt.executeUpdate();
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}//updatePost
	
	public int deletePost(int boardID){
		int flag = -1;
		String sql = "UPDATE REVIEWBOARD SET BOARDAVAILABLE=0 WHERE BOARDID =?";
		try(Connection con = bDAO.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)){
			pstmt.setInt(1, boardID);
			flag = pstmt.executeUpdate();
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}//deletePost
}
