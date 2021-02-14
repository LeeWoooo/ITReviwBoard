<%@page import="boardDAO.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>삭제를 담당하는 페이지</title>
	</head>
	<body>
		<%!
			static final int DELETESUCCESS = 1;
			static final int DELETEFAIL = -1;
			public String process(String msg){
				return("<script>\nalert('"+msg+"')\nlocation.href='http://localhost:8090/boardPrj/board/board.jsp'\n</script>");
			}
		%>
	
		<% 
			int boardID = Integer.parseInt(request.getParameter("boardID"));
			BoardDAO bDAO = BoardDAO.getInstance();
			int result = bDAO.deletePost(boardID);
			
			switch(result){
				case DELETESUCCESS:{
					out.println(process("게시글 삭제를 성공하였습니다."));
					break;
				}
				case DELETEFAIL:{
					out.println(process("게시글 삭제를 실패하였습니다 잠시 후 다시 이용해주세요."));
				}
			}//switch
		%>
	</body>
</html>