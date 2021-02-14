<%@page import="boardDAO.UserDAO"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String id = request.getParameter("id");
	UserDAO uDAO = UserDAO.getInstance();
	int result = uDAO.validation(id);
%>

{"result":<%=result%>}