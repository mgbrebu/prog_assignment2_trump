<%-- 
    Document   : forumposts
    Created on : 10-Dec-2016, 16:11:57
    Author     : Stephen
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="dbconnection.DBConnect"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link rel="stylesheet" type="text/css" href="style.css" />
        <title>We Love Trump!</title>
    </head>

    <body>
        <div id="container">
            <div id="mainpic">         
            </div>   

            <div id="menu">
                <ul>
                    <li class="menuitem"><a href="index.jsp">Home</a></li>
                    <li class="menuitem"><a href="quotes.jsp">Quotes</a></li>
                    <li class="menuitem"><a href="news.jsp">News</a></li>
                    <li class="menuitem"><a href="profile.jsp?id=<% if (session.getAttribute("userid") != null) {out.print(session.getAttribute("userid"));} %>">Profile</a></li>
                    <li class="menuitem"><a href="forum.jsp">Members Forum</a></li>
                    <li class="menuitem"><a href="ValidateLogout">Logout</a></li>
                </ul>
            </div>

            <div id="content">
                <%
                    Connection con = new DBConnect().connect(getServletContext().getRealPath("/WEB-INF/config.properties"));

                    String postid = request.getParameter("postid"); //get the postid from the URL
                    if (postid != null && !postid.trim().isEmpty()) { //if the postid is not null or empty
                        PreparedStatement pstmt = con.prepareStatement("SELECT * FROM posts WHERE id = ?"); //prepare the statement
                        pstmt.setString(1, postid); //set the postid parameter
                        ResultSet rs = pstmt.executeQuery(); //execute the query
                        if (rs != null && rs.next()) { //if the resultset is not null and has a row
                            out.print("<b style='font-size:22px'>Title:" + rs.getString("title") + "</b>"); //print the title
                            out.print("<br/>-  Posted By " + rs.getString("user")); //print the user
                            out.print("<br/><br/>Content:<br/>" + rs.getString("content")); //print the content
                        }
                    } else {
                        out.print("ID Parameter is Missing");
                    }

                    out.print("<br/><br/><a href='forum.jsp'>Return to Forum &gt;&gt;</a>");
                %>
                <p>&nbsp;</p>
                <p>&nbsp;</p>
                <p>&nbsp;</p>
                <div id="footer"><h3><a href="http://www.trump.com/">Trump Web Design</a></h3></div>
            </div>
        </div>



    </body>
</html>

