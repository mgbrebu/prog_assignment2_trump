<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


// Login.jsp XSS VULN FIX Part.1
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %> //Importing JSTL to use to secure the form
//-----------


 <%
 String username="";
 String password="";
 Cookie[] cookies = request.getCookies();
 if (cookies != null)
  for (Cookie c : cookies) {
        if ("username".equals(c.getName())) {
         username= c.getValue();
        }
        else if("password".equals(c.getName()))
        {
            password= c.getValue();
        }
  }

 %>

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
                <li class="menuitem"><a href="login.jsp">Login</a></li>
                <li class="menuitem"><a href="sitemap.jsp">Site Map</a></li>
            </ul>
        </div>
        
        // Login.jsp XSS VULN FIX Part.2
		<div id="content">
        	<form action="ValidateLogin" method="post">
            <table> 
                <tr><td>UserName: </td><td><input type="text" name="username" value="<c:out value='${password}' />" /></td></tr> // Using JSTL tags to secure password
                <tr><td>Password :</td><td><input type="text" name="password" value="<c:out value='${username}' />"/></td></tr> // Using JSTL tags to secure username
                <tr><td><input type="submit" name="Login" value="Login"/></td></tr>
            </table>  
        </form>
        //-----------
            
            <div id="footer"><h3><a href="http://www.donaldtrumpstinks.com/">Trump Web Design</a></h3></div>
      </div>
   </div>
</body>
</html>
