<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="food.Dbcon" %>
<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Confirmation</title>
<style>
body{
  font-family: "Open Sans", sans-serif;
  
  background: url("food1.jpg");
  background:no repeat;
  background-size: cover;
}
.wrapper {
     display: flex;
    align-items: center;
    flex-direction: column;
    justify-content: center;
    width: 97%;
    min-height: 100%;
    padding: 20px;
}
.login {
 border-radius: 2px 2px 5px 5px;
padding: 10px 20px 80px;
width: 800px;

background: none repeat scroll 0% 0% #FFF;
position: relative;
box-shadow: 0px 1px 5px rgba(0, 0, 0, 0.3);
height: 500px;
opacity: 0.9;
}
h1 {
  font-family: 'Helvetica Neue', Helvetica, Arial, sans-serif;
  font-size: 2.5em;
  line-height: 1.5em;
  letter-spacing: -0.05em;
  margin-bottom: 20px;
  padding: .1em 0;
  color: #444;
    position: relative;
    overflow: hidden;
    white-space: nowrap;
    text-align: center;
}
h1:before,
h1:after {
  content: "";
  position: relative;
  display: inline-block;
  width: 50%;
  height: 1px;
  vertical-align: middle;
  background: #f0f0f0;
}
h1:before {  
  left: -.5em;
  margin: 0 0 0 -50%;
}
h1:after {  
  left: .5em;
  margin: 0 -50% 0 0;
}
h1 > span {
  display: inline-block;
  vertical-align: middle;
  white-space: normal;
}
p {
  display: block;
  font-size: 1.35em;
  line-height: 1.5em;
  margin-bottom: 22px;
  text-align:center;
}

</style>
</head>
<body>
	<%	

	Dbcon d = new Dbcon();
	HttpSession ses = request.getSession();
	String customer_name =(String) ses.getAttribute("name");
	String phone = (String)ses.getAttribute("ph");
	
	PrintWriter p = response.getWriter();
	String[] slno = request.getParameterValues("checkbox[]");
	String[] qt = request.getParameterValues("quantity[]");
	String table_no = request.getParameter("table_no");
	String manager_name = request.getParameter("manager");
	
	int amount = 0;
	int id=0;String tmp="";
	Date sysdate = new Date();
	DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
	String date = dateFormat.format(sysdate);
	String ord =  date.substring(11,18);
	StringTokenizer stz = new StringTokenizer(ord,":");
	 while (stz.hasMoreTokens()) {  
        
         tmp = tmp + stz.nextToken();
     }  
	id = Integer.parseInt(tmp);
	
	int[] quantity = new int[11];
	int[] cost = new int[11];
	String[] name = new String[11];
	int[] temp = new int[11];
	//for(int i = 0 ; i < slno.length ; i++ ){
		//p.println(slno[i]);
	//}
	
	for(int i = 0 ; i < qt.length ; i++ ){
		quantity[i] = Integer.parseInt(qt[i]);
	}
	
	try{
		Connection con = d.getConnection();
		Statement st = con.createStatement();
		
		
		for(int k = 0 ; k < slno.length ; k++ ){
			ResultSet rs = st.executeQuery("select * from Menu where Id="+slno[k]);
			while(rs.next()){
				
				
				name[k] = rs.getString(1);
				cost[k] = rs.getInt(2);
			}
		
		}
		PreparedStatement ps = con.prepareStatement("INSERT into Master VALUES (?,?,?,?,?,?,?,?,?,?)" );
		for(int i = 0 ,j = 0; i < slno.length && j < quantity.length ; i++ ,j++){
			temp[i] = cost[i] * quantity[i];
			ps.setInt(1, id+i);
			ps.setString(2, slno[i]);
			ps.setString(3, name[i] );
			ps.setInt(4, quantity[j]);
			ps.setInt(5, temp[i]);
			ps.setString(6,date);
			ps.setString(7, table_no);
			ps.setString(8, manager_name);
			ps.setString(9, customer_name);
			ps.setString(10, phone);
			ps.executeUpdate();
		}
		
		con.commit();
	}catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		e.getMessage();
	}
	
	try{
		
		Connection con = d.getConnection();
		Statement st= con.createStatement();
		ResultSet rs = st.executeQuery("select cost from master where time='"+date+"'");
		while(rs.next()){
			amount = amount + rs.getInt("cost");
		}
		
		//System.out.println(amount);
	}catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		e.getMessage();
	}
	%>
	
	<div class="wrapper">
	 <form class="login" name="form">
	 <img src="logo.png" alt="logo" height=50 width=50 />
	 <div id="content">
	  <!-- Icons source -->
	  <div class="notify successbox">
	    <h1>Success!</h1>
	    <span class="alerticon"><img src="check.png" alt="checkmark" height="50" width="50" style="margin-left:48%;"/></span>
	    <p>Thanks You  for your Order. Your Order will be Served within 20 Minutes.</p>
	    <p>Amount to be paid:<%=amount %> Rs./-</p>
  	</div>
  	</div>
	 </form>
	 </div>
</body>
<% 	ses.invalidate();
	response.setHeader("REFRESH","10;url='index.html'");
	%>
</html>