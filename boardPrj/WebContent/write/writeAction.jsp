<%@page import="boardDAO.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8");%>
<jsp:useBean id="pBean" class="boardVO.PostBean"/>
<jsp:setProperty property="*" name="pBean"/>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>게시글 작성을 처리하는 페이지</title>
	</head>
	<body>
		<%@include file="../validation/sessionValidation.jsp" %>
		
		<%!
			static final int INSERTSUCCESS = 1;
			static final int INSERTFAIL = -1;
			public String process(String msg){
				return("<script>\nalert('"+msg+"')\nlocation.href='http://localhost:8090/boardPrj/board/board.jsp'\n</script>");
			}
		%>
		<%
			BoardDAO bDAO = BoardDAO.getInstance();
			int result = bDAO.insertPost(userID, pBean);
			
			switch(result){
			case INSERTSUCCESS:{
				out.println(process("게시글 작성이 완료되었습니다."));
				break;
			}
			case INSERTFAIL:{
				out.println(process("게시글 작성에 실패하였습니다. 잠시 후 다시 이용해주세요."));
			}
		}
		%>
	</body>
</html>