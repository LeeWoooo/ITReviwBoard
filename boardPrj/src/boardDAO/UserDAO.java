package boardDAO;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import boardVO.JoinBean;

public class UserDAO {
	

	private static UserDAO uDAO;
	
	private UserDAO() {}
	
	public static UserDAO getInstance() {
		if (uDAO == null) {uDAO = new UserDAO();}
		return uDAO;
	}

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
	
	public int login(String id, String password) {
		int flag = -2;//DB 오류
		
		String sql = "SELECT PASSWORD FROM MEMBER WHERE ID = ?";
		
		try(Connection con = uDAO.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)){
			pstmt.setString(1, id);
			try(ResultSet rs = pstmt.executeQuery()){
				if(rs.next()) {
					if(password.equals(rs.getString("PASSWORD"))){
						flag = 1;
						return flag;
					}//end if
					flag = 0;
					return flag;
				}//end if
				flag = -1;
				return flag;
			}//end try;
		}catch(SQLException e) {
			e.printStackTrace();
		}//end catch
		return flag;
	}//login
	
	public int validation(String id){
		int flag = -1;
		String sql = "SELECT * FROM MEMBER WHERE ID=?"; 
		try(Connection con = uDAO.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)){
			pstmt.setString(1, id);
			try(ResultSet rs = pstmt.executeQuery()){
				if(rs.next()) {
					flag = 1;
				}//end if
			}//try
		}catch(SQLException e) {
			e.printStackTrace();
		}//end catch
		return flag;
	}//validation
	
	
	public int join(JoinBean jBean) {
		int flag = -1; //이미 아이디가 존재.
		String sql = "INSERT INTO MEMBER VALUES (?,?,?)";
		try(Connection con = uDAO.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)){
			pstmt.setString(1, jBean.getName());
			pstmt.setString(2, jBean.getId());
			pstmt.setString(3, jBean.getPassword());
			flag = pstmt.executeUpdate();
		}catch(SQLException e) {
			e.printStackTrace();
		}
		return flag;
	}//join

}
