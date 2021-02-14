<%@page import="boardDAO.UserDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %> 
<jsp:useBean id="jBean" class="boardVO.JoinBean" scope="page" />
<jsp:setProperty property="*" name="jBean"/>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>회원가입을 처리하는 페이지</title>
	</head>
	<body>
		<%!
			static final int JOINSUCCESS = 1;
		%>
		<%
			//아이디 중복검사를 했기 때문에 회원가입 조건에 충족할 때만 이 페이지로 이동
			UserDAO uDAO = UserDAO.getInstance();
			int result = uDAO.join(jBean);
			switch(result){
				case JOINSUCCESS:{
					out.println("<script>");
					out.println("alert('회원가입에 성공하였습니다. 로그인 해주세요:)')");
					out.println("location.href='http://localhost:8090/boardPrj/loginjoin.html'");
					out.println("</script>");
				}
			}//end switch
		%>
	</body>
</html>