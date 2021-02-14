<%@page import="boardDAO.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8");%>
<jsp:useBean id="pBean" class="boardVO.PostBean" scope="page"/>
<jsp:setProperty property="*" name="pBean"/>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>update를 처리하는 페이지</title>
	</head>
	<body>
		<%!
			static final int UPDATESUCCESS = 1;
			static final int UPDATEFAIL = -1;
			public String process(String msg){
				return("<script>\nalert('"+msg+"')\nlocation.href='http://localhost:8090/boardPrj/board/board.jsp'\n</script>");
			}
		%>
		<%
			int boardID = Integer.parseInt(request.getParameter("boardID"));
			BoardDAO bDAO = BoardDAO.getInstance();
			int result = bDAO.updatePost(boardID, pBean);
			
			switch(result){
				case UPDATESUCCESS:{
					out.println(process("게시글 수정이 완료되었습니다."));
					break;
				}
				case UPDATEFAIL:{
					out.println(process("게시글 수정에 실패하였습니다. 잠시 후 다시 이용해주세요."));
				}
			}
		%>
	</body>
</html>