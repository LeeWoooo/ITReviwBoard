<%@page import="boardDAO.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>로그인을 처리하는 페이지</title>
	</head>
	<body>
		<%!
			static final int LOGINSUCCESS = 1;
			static final int PASSWORDERROR = 0;
			static final int NOTEXISTID = -1;
			static final int DBERROR = -2;
			
			//서블릿의 필드영역이기 때문에 out객체를 아직 사용할 수 없다.
			//out객체는 service method안에서 생성된다.
			public String errMessage(String msg){
				return "<script>\nalert('"+msg+"')\nhistory.back()\n</script>";
			}//errMessage
		%>
	
		<%
			String id = request.getParameter("id");
			String password = request.getParameter("password");
			
			UserDAO uDAO = UserDAO.getInstance();
			int result = uDAO.login(id, password);
			
			switch(result){
				case LOGINSUCCESS:{
				//세션 등록 및 성공 시 게시판 페이지로 이동
				session.setAttribute("userID", id);
				out.println("<script>");
				out.println("alert('로그인 성공')");
				out.println("location.href='http://localhost:8090/boardPrj/board/board.jsp'");
				out.println("</script>");
				break;
				}
				case PASSWORDERROR:{
					out.println(errMessage("비밀번호를 확인 후 다시 입력해주세요."));
				break;
				}
				case NOTEXISTID:{
					out.println(errMessage("아이디가 존재하지 않습니다 회원가입 후 이용해주세요."));
					break;
				}
				case DBERROR:{
					out.println(errMessage("로그인에 실패하였습니다. 잠시 후 다시 이용해주세요."));
					break;
				}
			}//end switch
		%>
		
	</body>
</html>