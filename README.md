IT 기기 Review 게시판 (Model1)
===

## 목차

[1.project 목표](#project-목표) <br>
[2.사용 기술](#사용-기술)<br>
[3.프로젝트를 하며 느낀점](#프로젝트를-하며-느낀점)<br>
[4.페이지 흐름도](#페이지-흐름도)<br>
[5.ERD](#ERD)<br>
[6.구현 화면 및 코드](#구현-화면)<br>

<br>

---

<br>

## project 목표

1. 기본적인 게시판의 구조 및 로직을 이해합니다.

    * 게시판의 페이징 처리
    * CRUE
    * jsp의 query문자열을 이용해 같은 페이지지만 다른 결과 보여주기

2. DataBase CRUD

    * DB에 회원 가입 및 글쓰기에 관한 CRUD
    * 게시판 글의 Column의 자료형을 CLOB로 설정 후 처리하기

3. Ajax

    * Ajax을 이용하여 아이디의 중복 정검
    * json을 사용한 데이터 교환

4. jsp

    * session에 대한 이해 및 session을 활용한 페이지 처리
    * Bean의 사용

5. DAO 및 VO의 사용

6. 자원의 반납. try with Resources

    * AutoCloseable이 구현된 객체만 사용이 가능합니다.

## 사용 기술

Java 1.8, Oracle, JDBC, JSP, Jquery, bootstrap, Gson
    
<br>

---

## 프로젝트를 하며 느낀점

1. 페이징 처리 query문 작성에 익숙해졌다.

    * 내가 원하는 데이터를 조회할 수 있다는 자신감이 조금 생길 수 있었던 것 같다. 처음에는 내가 원하는 데이터만 어떻게 가져올 수 있을까 라는 고민이 많았지만 강의 때 배웠던 서브쿼리와 함수를 사용하여 DB를 조작하는 것을 반복해가며 결국은 답을 찾을 수 있었을 때의 뿌듯함이 있었다.

2. 한 페이지에서 다른 결과물 도출

    * 이 또한 페이지 처리에 속한 이야기이지만 query문자열을 통해서 값을 보내고 request로 가져와 DB를 조회해서 같은 페이지지만 다른 결과를 보여줄 수 있다는 것을 경험하고 실습할 수 있었다.

3. 실습을 통해 배웠던 것들을 조금씩 가져다 쓸 수 있게 되었다.

    * 이전 구현을 해보고 실습한 기술들을 필요할 때 가져다 쓸 수 있는 연결지점이 조금씩 생기고 있는 것 같다.

4. 게시판 구현 숙지

    * 이 프로젝트로 인해 게시판의 구조를 이해할 수 있었으며 게시판 구현을 통해 자신감을 얻을 수 있었다. 또한 DB의 연동 및 JDBC를 충분히 다뤄보고 사용할 수 있게 되었다.

5. 만드는 재미

    * 배운 기술을 통해 무엇을 구현하고 막히는 부분에 있어서 검색을 하고 책을 찾아보며 구현을 완성하는 재미를 알 수 있었다.

<br>

---

<br>

## 페이지 흐름도

* 흐름도 

    <img src = https://user-images.githubusercontent.com/74294325/107236474-174d8a00-6a69-11eb-8b8f-12817b29911a.png>

<br>

---

## ERD

* ERD 

    <img src = https://user-images.githubusercontent.com/74294325/107245460-854a7f00-6a72-11eb-8d4b-764ca41f6f5d.JPG>

<br>

Member의 ID값을 ReviewBoard의 외래키로 설정하여 Member가 아닌 사용자는 게시글 등록을 할 수 없도록 하였습니다.

---


<br>

## 구현 화면

<Strong>이미지를 클릭하면 구현 영상을 확인하실 수 있습니다:)</strong>

[![게시판](https://user-images.githubusercontent.com/74294325/107880034-ab16ce80-6f1f-11eb-8e1a-e40887c14d03.JPG)](https://www.youtube.com/watch?v=NlKOeYy6Ye4&feature=youtu.be)

<Br>

---

<br>

## 로그인

사용자에게 ID와 PassWord를 입력받아 loginAction.jsp로 이동을 합니다. 아이디와 비밀번호는 개인 정보이기 때문에 Post방식을 사용하여 요청을 하였습니다. <br>

요청을 받은 Action 페이지에서는 사용자가 넘겨준 값을 이용하여 DAO단(UserDAO)에서 DB를 검색하여 사용자를 인증합니다. <br>

```java
//jsp
String id = request.getParameter("id");
String password = request.getParameter("password");

UserDAO uDAO = UserDAO.getInstance();
int result = uDAO.login(id, password);
```
```java
public int login(String id, String password) {
    int flag = -2;//DB 오류
    String sql = "SELECT PASSWORD FROM MEMBER WHERE ID = ?";
    try(Connection con = uDAO.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)){
        pstmt.setString(1, id);
        try(ResultSet rs = pstmt.executeQuery()){
            if(rs.next()) {
                if(password.equals(rs.getString("PASSWORD"))){
                    flag = 1;
                    return flag;
                }//end if
                flag = 0;
                return flag;
            }//end if
            flag = -1;
            return flag;
        }//end try;
    }catch(SQLException e) {
        e.printStackTrace();
    }//end catch
    return flag;
}//login
```

<br>

이렇게 받은 return 값에 따라 Action 페이지의 swtich문에서 처리를 합니다. 로그인을 성공시에는 session에 값을 저장하여 로그아웃을 하기 전까지 session을 통해 page이동을 합니다. switch문에서 case의 값은 상수로 처리하여 가독성을 높였습니다. 또한 반복되는 error Message 출력을 매개변수에 따라 출력을 동적으로 할 수 있도록 method를 생성하였습니다.<br>

```java
switch(result){
    case LOGINSUCCESS:{
    //세션 등록 및 성공 시 게시판 페이지로 이동
    session.setAttribute("userID", id);
    out.println("<script>");
    out.println("alert('로그인 성공')");
    out.println("location.href='http://localhost:8090/boardPrj/board/board.jsp'");
    out.println("</script>");
    break;
    }
    case PASSWORDERROR:{
        out.println(errMessage("비밀번호를 확인 후 다시 입력해주세요."));
    break;
    }
    case NOTEXISTID:{
        out.println(errMessage("아이디가 존재하지 않습니다 회원가입 후 이용해주세요."));
        break;
    }
    case DBERROR:{
        out.println(errMessage("로그인에 실패하였습니다. 잠시 후 다시 이용해주세요."));
        break;
    }
}//end switch
```

<br>

---

## 회원가입

회원가입 form을 통하여 사용자가 값을 입력하고 사용자가 값을 알맞게 입력을 했다면 DB에 사용자의 정보를 저장 후 회원 가입이 완료됩니다. 사용자가 입력한 값은 Bean을 생성하여 값을 받아 DAO단으로 넘겨주었습니다. <br>

입력하는 과정에서 아이디 중복검사를 진행하게 되고 아이디 중복 검사는 Ajax을 통하여 진행하였습니다. 중복검사한 값은 input 태그의 hidden에 값을 할당 한 후 알맞은 값이 할당 되고 모든 값이 입력이 되었을 때 submit이 가능합니다. <br>


```javascript
//ajax통신
//아이디 중복검사
$('#validation').click(function () {
    let inputData = {id:$(".joinid").val()}
    $.ajax({
        url:"http://localhost:8090/boardPrj/join/validation.jsp",
        datatype:"json",
        type:"post",
        data:inputData
    }).done(function (json) {
        //돌아오는 json의 값은 db의 select의 결과로 아이디가 있으면 1 없으면 -1
        let flag = Number(json.result);
        //EXISTID = 1;
        //AVAILABLEID = -1;
        switch(flag){
            case EXISTID:{
                alert('존재하는 아이디 입니다. 다른아이디를 사용해주세요.');
                $("#validationResult").val(EXISTID);
                break;
            }
            case AVAILABLEID :{
                alert('사용가능한 아이디 입니다.');
                $("#validationResult").val(AVAILABLEID);
            }
        }//end switch
    })//done
})

//회원가입 버튼이 눌렸을 경우 유효성 검사 후 회원가입
$('.joinsubmit').click(function () {
    let validation = $("#validationResult").val();
    //회원가입에 필요한 값들이 전부 입력되었는지 확인
    if($(".joinid").val() ==="" || $(".joinname").val()===""||$(".joinpassword")===""){
        alert('회원가입에 필요한 정보들을 전부 입력해주세요!');
    //아이디 중복체크를 했는지 확인
    }else if(validation === ""){
        alert("아이디 중복체크를 해주세요.");
    //사용가능한 아이디 인지 확인
    }else if(validation == EXISTID){
        alert('존재하는 아이디 입니다. 다른아이디를 사용해주세요.');
    //회원가입 조건이 충족시 form sublit
    }else{
        $(".joinForm").submit();
    }//end else
})
```
```java
public int validation(String id){
    int flag = -1;
    String sql = "SELECT * FROM MEMBER WHERE ID=?"; 
    try(Connection con = uDAO.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)){
        pstmt.setString(1, id);
        try(ResultSet rs = pstmt.executeQuery()){
            if(rs.next()) {
                flag = 1;
            }//end if
        }//try
    }catch(SQLException e) {
        e.printStackTrace();
    }//end catch
    return flag;
}//validation
	
public int join(JoinBean jBean) {
    int flag = -1; //이미 아이디가 존재.
    String sql = "INSERT INTO MEMBER VALUES (?,?,?)";
    try(Connection con = uDAO.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)){
        pstmt.setString(1, jBean.getName());
        pstmt.setString(2, jBean.getId());
        pstmt.setString(3, jBean.getPassword());
        flag = pstmt.executeUpdate();
    }catch(SQLException e) {
        e.printStackTrace();
    }
    return flag;
}//join
```

<br>

---

<br>


## 게시판 페이징

로그인에 성공하면 게시판 메인으로 이동합니다. 게시판의 한 페이지의 조회 가능한 글은 5개로 설정을 하였으며 게시판 페이지로 요청이 올 때 query 문자열로 pageNumber를 받아 pageNumber의 값에 따라 게시판을 paging 하였습니다. <br>

```java
<%
    //기존 페이지 번호를 1로 설정한다.
    //만약 요청 url에 pageNumber를 포함한 query문자열이라면 값을 얻어온다.
    int pageNumber = 1;
    if(request.getParameter("pageNumber")!=null){
        pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
    }//end if
%>
```
```java
public List<BoardVO> loadBoard(int pageNumber) {
    List<BoardVO> list = new ArrayList<BoardVO>();
    String sql = new StringBuilder()
            .append("SELECT BOARDID,BOARDTITLE,ID,TO_CHAR(BOARDDATE,'yyyy-MM-DD HH24:MI:SS') BOARDDATE, SEQ FROM ")
            .append("(SELECT BOARDID, BOARDTITLE,ID,BOARDDATE, ROW_NUMBER()OVER(ORDER BY BOARDID DESC) SEQ ")
            .append("FROM REVIEWBOARD WHERE BOARDID > 0 AND BOARDAVAILABLE = 1) ")
            .append("WHERE SEQ > ? AND SEQ <= ? ").toString();
    try (Connection con = bDAO.getConnection(); PreparedStatement pstmt = con.prepareStatement(sql)) {
        // 페이징 처리
        pstmt.setInt(1, (5 * pageNumber) - 5);
        pstmt.setInt(2, (5 * pageNumber));
        try (ResultSet rs = pstmt.executeQuery()) {
            BoardVO bVO = null;
            while (rs.next()) {
                bVO = new BoardVO(rs.getInt("BOARDID"), rs.getString("BOARDTITLE"), rs.getString("ID"),rs.getString("BOARDDATE"));
                list.add(bVO);
            } // while
        } // end try
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return list;
}// loadBoard
```

<br>

서브쿼리문을 사용하여 먼저 DB안의 값을 조회하였습니다. Oracle의 함수 중 ROW_NUMBER()OVER()를 사용하여 SEQ column을 생성하고 SEQ를 사용하여 조회되는 게시글의 갯수를 조절하였습니다. <br>

또한 현재 pageNumber보다 1큰수를 조회하여 조회한 결과가 있다면 다음 페이지로 이동할 수 있는 버튼을 보여주었으며 pageNumber가 1보다 크다면 이전 페이지 버튼을 보여주어 페이지의 이동을 가능하게 하였습니다. <br>

이후 읽어들어온 값을 List에 담아 jsp에서 동적으로 table에 tr을 생성하여 표현해줬습니다.

<br>

---

<br>

## 게시판 CLOB값 가져오기

게시글의 Content은 많은 양의 글이 들어가기 때문에 VARCHAR2로 부족할 수도 있어 CLOB로 자료형을 선정하였습니다. local에 있을 때는 조회 후 rs.getString으로 가져올 수 있지만 웹서버에서 값을 가져오는 것이라면 스트림을 연결해야 합니다. 스트림을 이용해 값을 읽어 들인 후 자원을 반납해줍니다. <br>

```java
Clob clob = rs.getClob("BOARDCONTENT");
try(BufferedReader br = new BufferedReader(clob.getCharacterStream())){
    while((readContent=br.readLine())!=null) {
        sbContent.append(readContent);
    }
}catch(IOException e) {
    e.printStackTrace();
}
```

<br>

---

<br>

## 게시판 글 보기

동적으로 게시판테이블을 만들 때 a태그를 이용하여 게시글 title을 누르면 해당 게시글로 이동되도록 하였습니다. 이 때도 동일하게 query문자열을 통하여 값을 전달 한 후 해당 값에 맞는 게시글을 조회하여 보여주었습니다.

```java
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
```
<br>

또한 injection을 대비하여 읽어들여지는 값들을 치환하여 있는 그대로 표현되도록 하였습니다.

<br>

---

<br>

## 로그아웃

로그아웃을 누르면 logoutAction페이지로 이동합니다. 페이지로 이동하게 되면 session을 무력화 시키고 다시 로그인 페이지로 이동합니다.

```java
<%
    //현재 세션 무력화
    session.invalidate();

    //로그인 페이지로 이동
    out.println("<script>");
    out.println("alert('로그아웃 되었습니다 다음에 또 놀러오세요:)')");
    out.println("location.href='http://localhost:8090/boardPrj/loginjoin.html'");
    out.println("</script>");
%>
```

<br>

---

<br>

## 삭제 및 수정

삭제 및 수정 버튼은 현재 session에 등록되어 있는 user의 id 값과 글을 쓴 user의 id 값이 동일할 때에만 버튼을 보이게 설정하여 권한을 부여한 것과 같은 효과를 내었습니다.

```jsp
<%
    //만약 작성자와 현재로그인한 아이디가 같다면 삭제와 수정 기능 제공
    if(postID.equals(userID)){
    %>
    <a href="http://localhost:8090/boardPrj/update/update.jsp?boardID=<%=boardID%>" class="btn btn-dark">수정</a>
    <a onclick="return confirm('정말로 삭제하시겠습니까?')" href="http://localhost:8090/boardPrj/delete/deleteAction.jsp?boardID=<%=boardID%>" class="btn btn-dark">삭제</a>
    <%
    }
%>
```

<br>

---

<br>

## 페이지 모듈화

게시판페이지로 이동해 사용되는 모든 페이지는 header를 가지고 있게 됩니다. 모두 동일한 형태의 header이며 코드의 중복을 피하고 유지보수를 좋게 하기 위하여 include를 이용하여 가져다 사용합니다.

```java
<%@include file="../header/header.jsp" %>
```

<Br>

또한 session을 이용하여 로그인을 하지 않은 상태에서 get방식으로 접근을 하지 못하도록 하기위하여 session을 검증하는 jsp를 만들어 include하여 session이 필요한 페이지에 첨가하였습니다. <br>

```java
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

<%@include file="../validation/sessionValidation.jsp" %>
```

<br>

---

<br>

## 참조

로그인 및 회원가입 페이지 : https://www.blueb.co.kr/?m=bluebdata&bid=css_forms&uid=4093&c=2/34