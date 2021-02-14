<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>로그아웃을 처리하는 페이지</title>
	</head>
	<body>
		<%
			//현재 세션 무력화
			session.invalidate();
		
			//로그인 페이지로 이동
			out.println("<script>");
			out.println("alert('로그아웃 되었습니다 다음에 또 놀러오세요:)')");
			out.println("location.href='http://localhost:8090/boardPrj/loginjoin.html'");
			out.println("</script>");
		%>
	</body>
</html>