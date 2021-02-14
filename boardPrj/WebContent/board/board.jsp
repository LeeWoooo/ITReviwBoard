<%@page import="boardVO.BoardVO"%>
<%@page import="java.util.List"%>
<%@page import="boardDAO.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>REVIEW 게시판</title>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
 		<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
  		<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
	</head>
	<body>
		<%@include file="../validation/sessionValidation.jsp" %>
		<%
			//기존 페이지 번호를 1로 설정한다.
			//만약 요청 url에 pageNumber를 포함한 query문자열이라면 값을 얻어온다.
			int pageNumber = 1;
			if(request.getParameter("pageNumber")!=null){
				pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
			}//end if
		%>
		
		<%@include file ="../header/header.jsp" %>
				
		<div class="container mt-3">
		  <h2>Review</h2>
		  <p>IT기기의 사용 후기를 남겨주세요.</p>  
		  <input class="form-control" id="myInput" type="text" placeholder="Search..">
		  <br>
		  <table class="table table-bordered" style="text-align: center;">
		    <thead>
		      <tr>
		        <th>글 번호</th>
		        <th>제목</th>
		        <th>작성자</th>
		        <th>작성/수정 일자</th>
		      </tr>
		    </thead>
		    <tbody id="myTable">
		    	<%
		    		BoardDAO bDAO = BoardDAO.getInstance();
		    		List<BoardVO> list = bDAO.loadBoard(pageNumber);
		    		for(BoardVO bVO : list){
		    	%>
		    		<tr>
		    			<td><%=bVO.getBoardID()%></td>
		    			<td><a href="http://localhost:8090/boardPrj/view/view.jsp?boardID=<%=bVO.getBoardID()%>"><%=bVO.getBoardTitle()%></a></td>
		    			<td><%=bVO.getId()%></td>
		    			<td><%=bVO.getBoardDate()%></td>
		    		</tr>
		    	<%
		    		}
		    	%>
		    </tbody>
		  </table>
		  <div class="d-flex mb-3">
		  	<%
		  		if(pageNumber > 1){
		  	%>
			    <div class="p-2">
			    	<a href="http://localhost:8090/boardPrj/board/board.jsp?pageNumber=<%=pageNumber-1%>" class="btn btn-dark p-2 ml-auto">이전</a>	
			    </div>
		  	<%
		  		}//end if
		  	%>
		  	<%
		  		if(bDAO.nextPage(pageNumber+1)){
		  	%>
			    <div class="p-2">
				    <a href="http://localhost:8090/boardPrj/board/board.jsp?pageNumber=<%=pageNumber+1%>" class="btn btn-dark p-2 ml-auto p-2">다음</a>	
			    </div>
		  	<%
		  		}//end if
		  	%>
		  	<div class="p-2 ml-auto">
			    <a href="http://localhost:8090/boardPrj/write/write.jsp" class="btn btn-dark p-2 ml-auto">글쓰기</a>
		  	</div>
		  </div>
		</div>
		
		<script>
		$(document).ready(function(){
		  $("#myInput").on("keyup", function() {
		    var value = $(this).val().toLowerCase();
		    $("#myTable tr").filter(function() {
		      $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1)
		    });
		  });
		});
		</script>
	</body>
</html>