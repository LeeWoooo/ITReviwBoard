<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>로그인 세션 검증을 하는 jsp</title>
	</head>
	<body>
		<%
			String userID = null;
			
			if(session.getAttribute("userID")!=null){
				userID = (String)session.getAttribute("userID");
			}else{
				out.println("<script>");
				out.println("alert('로그인을 하고 이용해주세요')");
				out.println("location.href='http://localhost:8090/boardPrj/loginjoin.html'");
				out.println("</script>");
			}//end else;
		%>
	</body>
</html>