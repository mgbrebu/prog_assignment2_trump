<%@page import="java.lang.String"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="dbconnection.DBConnect"%>
<%@page import="java.sql.Connection"%>

<!-- >Login.jsp XSS VULN FIX Part.1 -->
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> <!-- Importing JSTL to use to secure the form -->
<!-- ---------- -->


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
        <link rel="stylesheet" type="text/css" href="style.css" />
        <title>We Love Trump!</title>
    </head>
    <%
        Connection con = new DBConnect().connect(getServletContext().getRealPath("/WEB-INF/config.properties"));
        if (session.getAttribute("isLoggedIn") != null && session.getAttribute("isLoggedIn").equals("1")) {
            out.print("Hello " + session.getAttribute("user") + ", Welcome to Our Forum !");
        }
    %>
    <body>
        <div id="container">
            <div id="mainpic">         
            </div>   

            <div id="menu">
                <ul>
                    <li class="menuitem"><a href="index.jsp">Home</a></li>
                    <li class="menuitem"><a href="quotes.jsp">Quotes</a></li>
                    <li class="menuitem"><a href="news.jsp">News</a></li>
                    <li class="menuitem"><a href="profile.jsp?id=<% if(session.getAttribute("userid")!=null){ out.print(session.getAttribute("userid"));} %>">Profile</a></li>
                    <li class="menuitem"><a href="forum.jsp">Members Forum</a></li>
                    <li class="menuitem"><a href="ValidateLogout">Logout</a></li>
                </ul>
            </div>

            <div id="content">
                <h3>Create Post:</h3>
                <form action="forum.jsp" method="POST">
                    Title : <input type="text" name="title" value="" size="50"/><br/>
                    Message: <br/><textarea name="content" rows="2" cols="50"></textarea>
                    <input type="hidden" name="user" value="<% if (session.getAttribute("user") != null) {
               out.print(session.getAttribute("user"));
           } else {
               out.print("Anonymous");
           } %>"/><br/>
                    <input type="submit" value="Post" name="post"/> 
                </form>

                <%

                    if (request.getParameter("post") != null) {
                        String user = request.getParameter("user");
                        String content = request.getParameter("content");
                        String title = request.getParameter("title");
                
                        if (con != null && !con.isClosed()) {
                           
                            // VULN SQLi -----------------------------------------------------------
                            // stmt.executeUpdate("INSERT into posts(content,title,user) values ('" + content + "','" + title + "','" + user + "')");
                            // VULN SQLi -----------------------------------------------------------

                            
                                // FIXED XSS AND SQLi VULNERABILITIES -----------------------------------------------------------
                                String sql = "INSERT into posts(content, title, user) values (?, ?, ?);";
                                PreparedStatement pstmt = con.prepareStatement(sql);
                                pstmt.setString(1, content); 
                                pstmt.setString(2, title);
                                pstmt.setString(3, user);
                                pstmt.executeUpdate();
                                // FIXED VULNERABILITY -----------------------------------------------------------
                            


                            out.print("Successfully posted");
                        }
                    }

                %>
                <p>&nbsp;</p>
                <p>&nbsp;</p>
                <p>&nbsp;</p>
                <h3>List of Posts:</h3> 
                    
                <%        
                // Forum.jsp XSS VULN FIX
                // Fixed by creating a method that escapes common XSS characters 
                // and applied it to each string being pulled from the result set
                    if (con != null && !con.isClosed()) {
                        Statement stmt = con.createStatement();

                        ResultSet rs = null;
                        rs = stmt.executeQuery("select * from posts");
                        out.println("<table border='1' width='80%'>");
                        while (rs.next()) {
                            out.print("<tr>");
                            out.print("<td><a href='forumposts.jsp?postid=" + escape(rs.getString("id")) + "'>" + escape(rs.getString("title")) + "</a></td>");
                            out.print("<td> - Posted By ");
                            out.print(escape(rs.getString("user")));
                            out.println("</td></tr>");
                        }   
                    out.println("</table>");
                    }
                %>
                
                <%!
                // Forum.jsp XSS VULN FIX Part.2
                // This is the method that escapes common XSS characters
                // Used to escape data shown to the user in the forum
                private String escape(String in) {
                    return in.replaceAll("&", "&amp;")
                    .replaceAll("<", "&lt;")
                    .replaceAll(">", "&gt;")
                    .replaceAll("\"", "&quot;")
                    .replaceAll("'", "&#39;");
                }
                // ------------
                %>

                <div id="footer"><h3><a href="http://www.trump.com/">Trump Web Design</a></h3></div>
            </div>
        </div>
    </body>
</html>
