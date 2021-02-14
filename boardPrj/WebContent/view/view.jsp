<%@page import="boardVO.PostVO"%>
<%@page import="boardDAO.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>IT기기의 Review</title>
	</head>
	<body>
		<%@include file="../validation/sessionValidation.jsp" %>
		<%
			int boardID = 0;
			if(request.getParameter("boardID")!=null){
				boardID = Integer.parseInt(request.getParameter("boardID"));
			}//end if
			
			BoardDAO bDAO = BoardDAO.getInstance();
			PostVO pVO = bDAO.loadPost(boardID);
			String title = pVO.getBoardTitle().replaceAll(" ", "&nbsp").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>");
			String cotent = pVO.getBoardContent().replaceAll(" ", "&nbsp").replaceAll("<", "&lt;").replaceAll(">", "&gt;").replaceAll("\n", "<br>");
			String postID = pVO.getId();
		%>
		<%@include file="../header/header.jsp" %>
		<div class="container" style="margin-top: 15px">
		<table class="table table-bordered" style="text-align: center">
		    <thead>
		      <tr>
		        <th colspan="3">IT Review 보기</th>
		      </tr>
		    </thead>
		    <tbody>
		      <tr>
		        <td style="width: 20%">글 제목</td>
		        <td colspan="2"><%=title%></td>
		      </tr>
		      <tr>
		        <td style="width: 20%">작성자</td>
		        <td colspan="2"><%=pVO.getId()%></td>
		      </tr>
		      <tr>
		        <td style="width: 20%">작성일자</td>
		        <td colspan="2"><%=pVO.getBoardDate()%></td>
		      </tr>
		      <tr>
				<td>내용</td>
				<td colspan="2" style="min-height: 200px; text-align: left;"><%=cotent%></td>
			  </tr>
		    </tbody>
		  </table>
		  <%
		  	//만약 작성자와 현재로그인한 아이디가 같다면 삭제와 수정 기능 제공
		  	if(postID.equals(userID)){
		  %>
		  	<a href="http://localhost:8090/boardPrj/update/update.jsp?boardID=<%=boardID%>" class="btn btn-dark">수정</a>
		  	<a onclick="return confirm('정말로 삭제하시겠습니까?')" href="http://localhost:8090/boardPrj/delete/deleteAction.jsp?boardID=<%=boardID%>" class="btn btn-dark">삭제</a>
		  <%
		  	}
		  %>
		  <a href="http://localhost:8090/boardPrj/board/board.jsp" class="btn btn-dark">목록</a>
		</div>
	</body>
</html>