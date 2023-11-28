<html xmlns="http://www.w3.org/1999/xhtml">

<%@page import="java.io.DataInputStream"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%
         if(request.getParameter("file")!=null)
        {
             String context = request.getContextPath();
             
            int BUFSIZE = 4096;
               String filePath;
            filePath = request.getParameter("file");
            
            //Sanitize the file parameter before passing forward
            filePath = filePath.replaceAll("[\\r\\n]", "");
            
            File file = new File(getServletContext().getRealPath("/") + context);
            file = new File(file.getParent()+"/docs/"+filePath);       
            int length   = 0;
            ServletOutputStream outStream = response.getOutputStream();
            response.setContentType("text/html");
            response.setContentLength((int)file.length());
            String fileName = (new File(filePath)).getName();
            response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

            byte[] byteBuffer = new byte[BUFSIZE];
            DataInputStream in = new DataInputStream(new FileInputStream(file));

            while ((in != null) && ((length = in.read(byteBuffer)) != -1))
            {
            outStream.write(byteBuffer,0,length);
            }

            in.close();
            outStream.close();
        }
        else
        {
            
        }
    %>
  
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
                <li class="menuitem"><a href="download.jsp">Downloads</a></li>
            </ul>
        </div>
    </div>
    <div id="content">
        <h3> Download Files: </h3><br/>
        <ul>
        <li><a href="download.jsp?file=Lies.pdf"> Lies! Lies! Lies! </a>  </li>
        <li><a href="download.jsp?file=Counterterror_Strategy.pdf"> Donald is here to protect us! </a></li>
    </ul>
        
    </div>
 
 </body>