<%@page import="boardVO.PostVO"%>
<%@page import="boardDAO.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Review 작성하기</title>
	</head>
	<body>
		<%@include file="../header/header.jsp"%>
		<div class="container" style="margin-top: 15px">
		<form action="http://localhost:8090/boardPrj/write/writeAction.jsp" method="post">
		  <table class="table table-bordered" style="text-align: center;">
		    <thead>
		      <tr>
		        <th colspan="2">Review 작성 양식</th>
		      </tr>
		    </thead>
		    <tbody>
		      <tr>
				<td><input type="text" class="form-control" placeholder="글 제목" name="boardTitle" maxlength="50" required="required" ></td> <!-- 현재 타이틀  -->
			  </tr>
			  <tr>
				<td><textarea class="form-control" placeholder="글 내용" name="boardContent" style="height: 400px" required="required"></textarea></td>
			  </tr>
		    </tbody>
		  </table>
		  <input type="submit" class="btn btn-dark pull-right" value="글 작성">
		  <a href="http://localhost:8090/boardPrj/board/board.jsp" class="btn btn-dark">목록</a>
		</form>
		</div>
	</body>
</html>