<!--
김영원: 전체적인 코딩, CSS
서동학: note, upload, download
-->


<%@page import="file.FileDAO"%>
<%@ page import="file.FileDTO"%>
<%@ page import="java.io.File" %>
<%@page import="map.PublicmapDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="map.Item" %>
<%@ page import="map.ItemDAO" %>
<%@ page import="map.Line" %>
<%@ page import="map.LineDAO" %>
<%@page import="map.Counts"%>
<%@page import="map.CountsDAO"%>
<%@page import="user.User"%>
<%@page import="user.UserDAO"%>

<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>My 로드맵</title>

    <style>
	  @font-face {
	    font-family: "aTitleGothic2";
	    src: url('fonts/aTitleGothic2.ttf');
	  }
	  @font-face {
	    font-family: "aTitleGothic3";
	    src: url('fonts/aTitleGothic3.ttf');
	  }
	  @font-face {
	    font-family: "uninote";
	    src: url('fonts/UNINOTE.otf');
	  }

      html, body {
        margin: 0;
        width: auto;
        height: auto;
        font-family: aTitleGothic2;
      }

      .up_box {
        position: fixed;
        top: 0px;
        display: flex;
        width: 100%;
        height: 80px;
        background-color: white;
        align-items: center;
        z-index: 10;
        border-bottom: 2px solid #93c9eb;
      }
      
      .up_box a {
        text-decoration: none;
        font-size: 50px;
        color: #93c9eb;
        margin-left: 50px;
        font-weight: 1000;
        font-family: uninote;
      }

      .up_box button {
        background-color: white;
        color: black;
        border: 2px solid black;
        width: 100px;
        height: 30px;
        padding: 0px;
        margin: 0px 10px;
        border-radius: 5px;
        font-family: aTitleGothic2;
      }
	  
      .main_box {
        position: relative;
        width: 100%;
        height: 100%;
        background-color: #f9f9f9;
      }

      .main_box button {
        padding: 0px;
        background-color: white;
        color: black;
        border: 2px solid black;
      }

      .item {
        position: absolute;
        top: 20px;
        left: 20px;
        padding: 0;
        background-color: white;
        color: black;
        border: 2px solid #828282;
        width: 150px;
        height: 50px;
        flex-direction: column;
        display: flex;
        justify-content: center;
        align-items: center;
        overflow: auto;
        resize: both;
        border-radius: 5px;
        color: #464646;
        font-weight: bold;
        background-color: white;
        max-width: 200px;
        max-height: 200px;
      }
      
      #root, #grade1, #grade2, #grade3, #grade4 {
        position: absolute;
        width: 146px;
        height: 46px;
        border: 2px solid #828282;
        display: flex;
        justify-content: center;
        align-items: center;
        border-radius: 5px;
        color: #464646;
        font-weight: bold;
        background-color: white;
      }
      
      #counts_box {
        display: flex;
        margin-left: auto;
      }
      
      #hits {
        margin-left: 10px;
        margin-right: 10px;
        font-weight: bold;
      }
      
      #rcm {
        font-weight: bold;
      }
      
      .rcm_box {
        margin-left: 10px;
        margin-right: 10px;
      }
      
      #rcm_btn {
        width: 50px;
        height: 30px;
        font-weight: bold;
        border: 2px solid black;
      }
      
    	.contextmenu, #gradesContext {
		  display: none;
		  position: absolute;
		  width: 200px;
		  margin: 0;
		  padding: 0;
		  background: #FFFFFF;
		  border-radius: 5px;
		  list-style: none;
		  box-shadow:
		    0 15px 35px rgba(50,50,90,0.1),
		    0 5px 15px rgba(0,0,0,0.07);
		  overflow: hidden;
		  z-index: 999;
		}

		.contextmenu li, #gradesContext li {
		  border-left: 3px solid transparent;
		  transition: ease .2s;
		}
		
		.contextmenu li a, #gradesContext li a {
		  display: block;
		  padding: 10px;
		  color: #464646;
		  text-decoration: none;
		  transition: ease .2s;
		}
		
		.contextmenu li:hover, #gradesContext li:hover {
		  background: #93c9eb;
		  border-left: 3px solid #9C27B0;
		}
		
		.contextmenu li:hover a, #gradesContext li:hover {
		  color: #464646;
		}
		
		.new {
		  position: absolute;
		}
    </style>
  </head>

  <body>
    <script src="http://code.jquery.com/jquery-3.5.1.min.js"></script>
     <%
     	  // userID: login ID
     	  // mapID: map master ID
     	  // myLink: check come from home.jsp Mymap link
     	  // isMyMap: check map is mine
	      String userID = null;
          String mapID = null;
          String myLink = request.getParameter("myLink");
     	  boolean isMyMap = false;
     	  
     	  // get login ID
	      if(session.getAttribute("userID") != null){
	          userID = (String)session.getAttribute("userID");
	      }
     	  // get map masterID
	      if(request.getParameter("userID") != null) {
	    	  mapID = request.getParameter("userID");
	    	  System.out.println(mapID);
	      }
     	  // check correct access
	      if(userID == null && "yes".equals(myLink)) {
	    	  PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('로그인을 해주세요.');");
				script.println("history.back();");
				script.println("</script>");
	      }
     	  // check current map is mine
	      if(mapID.equals(userID)) {
	    	  isMyMap = true;
	      }

     	  // hitsUp and get hits, recommend counts
	      CountsDAO countsDAO = new CountsDAO();
	      countsDAO.hitsUp(mapID);
          Counts counts = new Counts();
          counts = countsDAO.readCounts(mapID);
          
          // get state of map is public or private
          PublicmapDAO publicmapDAO = new PublicmapDAO();
          int publicmap = publicmapDAO.getPublicmap(mapID);
          
          String mapPW = "mapPW";
          boolean needMapPW = false;
          // if map is private and isn't my map check password
          if(publicmap == 0 && !isMyMap) {
        	  needMapPW = true;
        	  mapPW = publicmapDAO.getPassword(mapID);
          }
     %>
  
    <div class="up_box" id="up_box">
	  <p style="margin:0;"><a href='home.jsp'><img src="img/LogoColor.png" alt="no image" height="50" style="vertical-align: middle;"><span style="vertical-align: middle;">UNINOTE</span></a></p>
      
      <!-- 조회수와 추천수 -->
      <div id="counts_box">
        <% // if current map is my map create public/privateMap button %>
        <% if(isMyMap) { %>
	        <% if(publicmap == 1) { %> 
	        <form id="publicMapForm" method="post">
	          <button type="button" name="publicMap" id="publicMap" onclick="publicMapAction(); return false" style="font-weight: bold;">비공개</button>
	        </form>
	        <% }else { %>
	        <form id="publicMapForm" method="post">
	          <button type="button" name="publicMap" id="publicMap" onclick="publicMapAction(); return false" style="font-weight: bold;">공개</button>
	        </form>    
	        <% } %>
        <% } %>
      
        <% if(userID == null) { %>
          <div class="rcm_box">
          <span id="hits">조회수 : <%=counts.getHits() %></span>
          <span id="rcm">추천 : <%=counts.getRecommend() %> </span>
        </div>
        <% }
           else { %>
          <div class="rcm_box">
          <span id="hits">조회수 : <%=counts.getHits() %></span>
          <span id="rcm">추천 : <%=counts.getRecommend() %> </span>
          <button id="rcm_btn" type="button" onclick="location.replace('recommendUp.jsp?userID=<%=userID%>&mapID=<%=mapID%>')">추천</button>
        </div>
        <% } %>
      </div>
      
      <!-- hidden form for ajax -->
      <!-- use for sending itemSql, lineSql -->
      <form id="saveActionForm" method="post">
        <input type="hidden" id="itemSql" name="itemSql" value="">
        <input type="hidden" id="lineSql" name="lineSql" value="">
      </form>
      <!-- use for sending fileData -->
      <form id="fileForm" method="post">
        <input type="hidden" id="fileData" name="fileData">
      </form>
      <!-- use for sending noteData -->
      <form id="noteForm" method="post">
        <input type="hidden" id="noteItemID" name="noteItemID">
        <input type="hidden" id="noteType" name="noteType">
      </form>
    </div>

    <!-- set initial 5 root items -->
    <div id="mainBox_wrap">
    <div class="main_box" id="main_box">
      <div id="root">UNINOTE</div>
      <div class="grades" id="grade1" onclick="clicked(event)" ondragover="allowDrop(event)" ondrop="drop(event)" oncontextmenu="contextmenu(event)">1학년</div>
      <div class="grades" id="grade2" onclick="clicked(event)" ondragover="allowDrop(event)" ondrop="drop(event)" oncontextmenu="contextmenu(event)">2학년</div>
      <div class="grades" id="grade3" onclick="clicked(event)" ondragover="allowDrop(event)" ondrop="drop(event)" oncontextmenu="contextmenu(event)">3학년</div>
      <div class="grades" id="grade4" onclick="clicked(event)" ondragover="allowDrop(event)" ondrop="drop(event)" oncontextmenu="contextmenu(event)">4학년</div>

      <svg width="100%" height="100%" id="svg" ondragover="allowDrop(event)" ondrop="drop(event)" onmouseup="svgMouseUp(event)">
       <%
         // get line data from DB and draw hidden on document
         // It will be positioned by drawAllLines() in <script> when onshow document
         LineDAO lineDAO = new LineDAO();
         ArrayList<Line> lineList = lineDAO.getList(mapID);
         for(int i=0; i<lineList.size(); i++) {
       %>
         <line class="itemLines" id=<%=lineList.get(i).getLineID()%> style="stroke: rgb(170, 170, 170); stroke-width: 2;"></line>
       <%
         }
       %>
      </svg>
      
   <%
     // get all data to itemList
     // make itemIdList to use create not APP items
     // make itemAppList to send itemAppList in <script> (check it is created from APP)
     // make appIdxList to send appIdxList in <script>
     ItemDAO itemDAO = new ItemDAO(); 
     ArrayList<Item> itemList = itemDAO.getList(mapID);
     ArrayList<String> itemIdList = new ArrayList<>();
     ArrayList<String> itemAppList = new ArrayList<>();
     ArrayList<Integer> appIdxList = new ArrayList<>();
     
     int size = itemList.size();
     for(int i=0; i<size; i++) {
    	 // if it's from APP
    	 if(itemList.get(i).getItemTop().equals("APP")) {
    		 itemAppList.add("'" + itemList.get(i).getItemID() + "'");
    		 appIdxList.add(i);
    		 
    		 // create hidden item, It's authorized, It will be positioned by checkNewItems() in <script>
    		 if(isMyMap) {
    %>
    	         <div class="item" id=<%= itemList.get(i).getItemID() %> draggable="true" ondragstart="dragStart(event)" ondrag="onDrag(event)" ondragover="allowDrop(event)" ondrop="drop(event)" onclick="clicked(event)" ondblclick="popup()" onmousedown="mouseDown(event)" onmouseup="mouseUp(event)" oncontextmenu="contextmenu(event)" style="2px solid black; top: 0px; left: 0px; width: <%=itemList.get(i).getItemWidth()%>; height: <%=itemList.get(i).getItemHeight()%>; displasy: none;"><%= itemList.get(i).getItemContent() %></div>
    <%
    		 }
    		 // create hidden item, It's not authorized, It will be positioned by checkNewItems() in <script>
    		 else {
    %>
                 <div class="item" id=<%= itemList.get(i).getItemID() %> onclick="clicked(event)" ondblclick="popup()" oncontextmenu="contextmenu(event)" style="2px solid black; resize: none; top: 0px; left: 0px; width: <%=itemList.get(i).getItemWidth()%>; height: <%=itemList.get(i).getItemHeight()%>; displasy: none;"><%= itemList.get(i).getItemContent() %></div>
    <%	 
    		 }
    	 }
     }
     //System.out.println(appIdxList);
     
     // remove APP items in itemList
     // if it's not from APP items, It will be positioned by positionItems(); in <script>
     for(int i=0; i<appIdxList.size(); i++) {
    	 int idx = appIdxList.get(appIdxList.size()-i-1);
    	 itemList.remove(idx);
     }
     //System.out.println(itemAppList);
     
     for(int i=0; i<itemList.size(); i++) {
    	 itemIdList.add(itemList.get(i).getItemID());
     }
     //System.out.println(itemIdList);
     
     
     //System.out.println("1. " + itemIdList); 
     // itemCnt is used to prevent creating same itemID
     int itemCnt = itemDAO.getNext(mapID);
     
     
     /*
     onload item position algorithm explain
     at DB item has attribute itemTop(ChildY - ParentY), itemLeft(ChildX - ParentX)
     get target from itmeList, save all parent in stack until finding grade(root)
     add each ParentX, ParentY by stack start with target X,Y
     
     ps) top=1875, left=1843 is fitted my monitor size
         to fit other monitor positionItems() in <script> will be run
     */
     // if myMap create authorized items
     if(isMyMap) {
       for(int i=0; i<itemList.size(); i++) {
	      	 String target = itemIdList.get(i);
	      	 String from = target.substring(0, target.indexOf("_"));
	      	 ArrayList<String> stack = new ArrayList<>();
	      	 stack.add(target);
	      	 //System.out.println("2. " + stack);
	      	 
	      	 while(!from.equals("grade1") && !from.equals("grade2") && !from.equals("grade3") && !from.equals("grade4")) {
	      		 for(int j=0; j<itemList.size(); j++) {
	      			 String str = itemIdList.get(j);
	      			 if(str.contains("_" + from)) {
	      				 stack.add(str);
	      				 from = str.substring(0, str.indexOf("_"));
	      				 break;
	      			 }
	      		 }
	      	 }
	      	 stack.add(from);
	      	 //System.out.println("3. " + stack);
	      	 
	      	 String pop = stack.get(stack.size()-1);
	      	 stack.remove(stack.size()-1);
	      	 
	      	 int idx = 0;
	      	 float top = 0;
	      	 float left = 0;
	      	 if(pop.equals("grade1")) {
	      		 //System.out.println("(1) " + stack);
	      		 top = 1875;
	      		 left = 1843;
	      		 for(int j=0; j<stack.size(); j++) {
	      			 pop = stack.get(j);
	      			 idx = itemIdList.indexOf(pop);
	      			 //System.out.println("(2) " +itemList.get(idx).getItemTop());
	      			 top = top + Float.parseFloat(itemList.get(idx).getItemTop());
	      			 left = left + Float.parseFloat(itemList.get(idx).getItemLeft());
	      		 }
	      	 }
	      	 else if(pop.equals("grade2")) {
	      		 top = 2235;
	      		 left = 1843;
	      		 for(int j=0; j<stack.size(); j++) {
	      			 pop = stack.get(j);
	      			 idx = itemIdList.indexOf(pop);
	      			 top = top + Float.parseFloat(itemList.get(idx).getItemTop());
	      			 left = left + Float.parseFloat(itemList.get(idx).getItemLeft());
	      		 }
	      	 }
	      	 else if(pop.equals("grade3")) {
	      		 top = 1875;
	      		 left = 2423;
	      		 for(int j=0; j<stack.size(); j++) {
	      			 pop = stack.get(j);
	      			 idx = itemIdList.indexOf(pop);
	      			 top = top + Float.parseFloat(itemList.get(idx).getItemTop());
	      			 left = left + Float.parseFloat(itemList.get(idx).getItemLeft());
	      		 }
	      	 }
	      	 else if(pop.equals("grade4")) {
	      		 top = 2235;
	      		 left = 2423;
	      		 for(int j=0; j<stack.size(); j++) {
	      			 pop = stack.get(j);
	      			 idx = itemIdList.indexOf(pop);
	      			 top = top + Float.parseFloat(itemList.get(idx).getItemTop());
	      			 left = left + Float.parseFloat(itemList.get(idx).getItemLeft());
	      		 }
	      	 }
	      	 
	      	 for(int j=0; j<stack.size(); j++) {
	      		 stack.remove(0);
	      	 }
	      	 
	      	 //System.out.println("End. " + top + " " + left);
	      	 String topPX = top + "px";
	      	 String leftPX = left + "px";
	   %>
	         <div class="item" id=<%= itemList.get(i).getItemID() %> draggable="true" ondragstart="dragStart(event)" ondrag="onDrag(event)" ondragover="allowDrop(event)" ondrop="drop(event)" onclick="clicked(event)" ondblclick="popup()" onmousedown="mouseDown(event)" onmouseup="mouseUp(event)" oncontextmenu="contextmenu(event)" style="2px solid black; top: <%=topPX %>; left: <%= leftPX %>; width: <%=itemList.get(i).getItemWidth()%>; height: <%=itemList.get(i).getItemHeight()%>"><%= itemList.get(i).getItemContent() %></div>
	   <%
    	 }
     }
     // if not myMap create no authorized items
     else {
       for(int i=0; i<itemList.size(); i++) {
        	 String target = itemIdList.get(i);
          	 String from = target.substring(0, target.indexOf("_"));
          	 ArrayList<String> stack = new ArrayList<>();
          	 stack.add(target);
          	 //System.out.println("2. " + stack);
          	 
          	 while(!from.equals("grade1") && !from.equals("grade2") && !from.equals("grade3") && !from.equals("grade4")) {
          		 for(int j=0; j<itemList.size(); j++) {
          			 String str = itemIdList.get(j);
          			 if(str.contains("_" + from)) {
          				 stack.add(str);
          				 from = str.substring(0, str.indexOf("_"));
          				 break;
          			 }
          		 }
          	 }
          	 stack.add(from);
          	 //System.out.println("3. " + stack);
          	 
          	 String pop = stack.get(stack.size()-1);
          	 stack.remove(stack.size()-1);
          	 
          	 int idx = 0;
          	 float top = 0;
          	 float left = 0;
          	 if(pop.equals("grade1")) {
          		 //System.out.println("(1) " + stack);
          		 top = 1843;
          		 left = 1875;
          		 for(int j=0; j<stack.size(); j++) {
          			 pop = stack.get(j);
          			 idx = itemIdList.indexOf(pop);
          			 //System.out.println("(2) " +itemList.get(idx).getItemTop());
          			 top = top + Float.parseFloat(itemList.get(idx).getItemTop());
          			 left = left + Float.parseFloat(itemList.get(idx).getItemLeft());
          		 }
          	 }
          	 else if(pop.equals("grade2")) {
          		 top = 2235;
          		 left = 1843;
          		 for(int j=0; j<stack.size(); j++) {
          			 pop = stack.get(j);
          			 idx = itemIdList.indexOf(pop);
          			 top = top + Float.parseFloat(itemList.get(idx).getItemTop());
          			 left = left + Float.parseFloat(itemList.get(idx).getItemLeft());
          		 }
          	 }
          	 else if(pop.equals("grade3")) {
          		 top = 1875;
          		 left = 2423;
          		 for(int j=0; j<stack.size(); j++) {
          			 pop = stack.get(j);
          			 idx = itemIdList.indexOf(pop);
          			 top = top + Float.parseFloat(itemList.get(idx).getItemTop());
          			 left = left + Float.parseFloat(itemList.get(idx).getItemLeft());
          		 }
          	 }
          	 else if(pop.equals("grade4")) {
          		 top = 2235;
          		 left = 2423;
          		 for(int j=0; j<stack.size(); j++) {
          			 pop = stack.get(j);
          			 idx = itemIdList.indexOf(pop);
          			 top = top + Float.parseFloat(itemList.get(idx).getItemTop());
          			 left = left + Float.parseFloat(itemList.get(idx).getItemLeft());
          		 }
          	 }
          	 
          	 for(int j=0; j<stack.size(); j++) {
          		 stack.remove(0);
          	 }
          	 
          	 //System.out.println("End. " + top + " " + left);
          	 String topPX = top + "px";
          	 String leftPX = left + "px";
   %>
         <div class="item" id=<%= itemList.get(i).getItemID() %> onclick="clicked(event)" ondblclick="popup()" oncontextmenu="contextmenu(event)" style="2px solid black; resize: none; top: <%=topPX %>; left: <%=leftPX %>; width: <%=itemList.get(i).getItemWidth()%>; height: <%=itemList.get(i).getItemHeight()%>"><%= itemList.get(i).getItemContent() %></div>
   <%
       }
     }
   %>
    </div>
    </div>
    
    <% // create hidden contextmenu by authorization %>
    <% if(isMyMap) { %>
    <ul class="contextmenu">
    	<li><a href="javascript:createItem();">항목 추가</a></li>
    	<li><a href="javascript:deleteItem(fromID);">항목 삭제</a></li>
    	<li><a href="javascript:popup();">추가 내용</a></li>
    	<li><a href="javascript:upload_download_window();">업/다운로드</a></li>
    </ul>
    
    <ul id="gradesContext">
    	<li><a href="javascript:createItem();">항목 추가</a></li>
    </ul>
    <% }else { %>
    <ul class="contextmenu">
    	<li><a href="javascript:popup();">추가 내용</a></li>
    	<li><a href="javascript:upload_download_window();">다운로드</a></li>
    </ul>
    <% } %>


    <script>
      // mainBox is parent of svg
      // upBox is fixed upBox
      // svg is using for drawing lines
      var mainBox = document.getElementsByClassName("main_box")[0];
      var upBox = document.getElementById("up_box");
      var svg = document.getElementById("svg");

      // lastItem X,Y,W,H is current selected items data
      // checkLR is check item's root is grade1,2 or grade3,4 to draw line at left side or right side
      var lastItemX = 0;
      var lastItemY = 0;
      var lastItemW = 0;
      var lastItemH = 0;
      var checkLR = 0;

      // current mouse X,Y on svg
      var mouseX = 0;
      var mouseY = 0;

      // fromID is selected item
      // toID is using any-action is change fromID to toID
      // itemCnt is prevent creating same itemID
      var fromID = "";
      var toID = "";
      var itemCnt = <%=itemCnt%>;
      var itemID = "item" + itemCnt;

      // findingParent is check item is trying to change its parent item
      // publicmap is show current map is public or private
      // userID is login ID
      // mapID is map mater ID
      var findingParent = 0;
      var publicmap = <%=publicmap%>;
      var userID = "<%=mapID%>"; // 로그인한 사용자의 ID가 아니라 map의 ID를 사용
      var mapID = "<%=mapID%>";

      // get (root, grade1,2,3,4)'s (X,Y,W,H) by functions
      var rootX = getX("root");
      var rootY = getY("root");
      var rootW = getW("root");
      var rootH = getH("root");
      var grade1X = getX("grade1");
      var grade1Y = getY("grade1");
      var grade2X = getX("grade2");
      var grade2Y = getY("grade2");
      var grade3X = getX("grade3");
      var grade3Y = getY("grade3");
      var grade4X = getX("grade4");
      var grade4Y = getY("grade4");
      
      // itemSQL, lineSQL is using at deleteItem(fromID)
      // itemWidth, Height is basic item width and height
      // beforeContent is using window.addEventListener("keyup", event)
      var itemSQL = {};
      var lineSQL = {};
      var itemWidth = "150px";
      var itemHeight = "50px";
      var beforeContent = "";
      //var saveFlag = false;
      
      // 동학
      var fileData = document.getElementById("fileData");
      var fileChangeID = "";
      var fileForm;
      
      // 동학
      var noteItemID = document.getElementById("noteItemID");
      var noteType = document.getElementById("noteType");
      var noteForm;
      
      // sql is using for making String itemSql, lineSql
      // saveActionForm points hidden saveActionForm in HTML
      // itemSql, lineSql is using for setAttribute on saveActionForm
      // removedLine is using clicked(e) (findingParent == 1)
      var sql = "";
      var saveActionForm;
      var itemSql = document.getElementById("itemSql");
      var lineSql = document.getElementById("lineSql");
      var removedLine;
      
      // isMymap is checking map is mine
      var isMyMap = <%=isMyMap%>;
	  
      // itemAppList, Dict is using about APP items action
	  var itemAppList = <%=itemAppList %>;
	  var itemAppDict = {};
	  //console.log(itemAppList);
	  
	  var itemSizeFlag = false;
	  var mouseDownItem;
	  
	  // if map isn't mine and map is private check password
	  var needMapPW = <%=needMapPW %>;
	  if(needMapPW) {
		  var mapPW ='<%=mapPW%>';
    	  var password = "";
          password = prompt('비밀번호를 입력하세요.', '비밀번호를 입력하세요(10자)');
          if(password != mapPW) {
        	  alert("비밀번호가 틀렸습니다.");
        	  history.back();
          }
	  }
	  
	  var mainWrap = document.getElementById("mainBox_wrap");
	  //console.log(screen.availWidth + "   " + screen.availHeight);
	  mainWrap.style.width = screen.availWidth*2.3 + "px";
	  mainWrap.style.height = screen.availHeight*4 + "px";
	  mainWrap.style.maxWidth = screen.availWidth*2.3 + "px";
	  mainWrap.style.maxHeight = screen.availHeight*4 + "px";
	  
	  // position root items
      var grades = document.getElementById("grade1");
      grades.style.left = (mainBox.offsetWidth/2 - 365) + "px";
      grades.style.top = (mainBox.offsetHeight/2 - 205) + "px";
      
      grades = document.getElementById("grade2");
      grades.style.left = (mainBox.offsetWidth/2 - 365) + "px";
      grades.style.top = (mainBox.offsetHeight/2 + 155) + "px";
      
      grades = document.getElementById("grade3");
      grades.style.left = (mainBox.offsetWidth/2 + 215) + "px";
      grades.style.top = (mainBox.offsetHeight/2 - 205) + "px";
      
      grades = document.getElementById("grade4");
      grades.style.left = (mainBox.offsetWidth/2 + 215) + "px";
      grades.style.top = (mainBox.offsetHeight/2 + 155) + "px";
      
      grades = document.getElementById("root");
      grades.style.left = (mainBox.offsetWidth/2 - 75) + "px";
      grades.style.top = (mainBox.offsetHeight/2 - 25) + "px";
      
      // draw root items lines
      drawLineByID("rootL", mainBox.offsetWidth/2-145, mainBox.offsetHeight/2, mainBox.offsetWidth/2-75, mainBox.offsetHeight/2);
      drawLineByID("g12", mainBox.offsetWidth/2-145, mainBox.offsetHeight/2 - 180, mainBox.offsetWidth/2-145, mainBox.offsetHeight/2 + 180);
      drawLineByID("g1", mainBox.offsetWidth/2-215, mainBox.offsetHeight/2 - 180, mainBox.offsetWidth/2-145, mainBox.offsetHeight/2 - 180);
      drawLineByID("g2", mainBox.offsetWidth/2-215, mainBox.offsetHeight/2 + 180, mainBox.offsetWidth/2-145, mainBox.offsetHeight/2 + 180);
      drawLineByID("rootR", mainBox.offsetWidth/2+75, mainBox.offsetHeight/2, mainBox.offsetWidth/2+145, mainBox.offsetHeight/2);
      drawLineByID("g34", mainBox.offsetWidth/2+145, mainBox.offsetHeight/2 - 180, mainBox.offsetWidth/2+145, mainBox.offsetHeight/2 + 180);
      drawLineByID("g3", mainBox.offsetWidth/2+215, mainBox.offsetHeight/2 - 180, mainBox.offsetWidth/2+145, mainBox.offsetHeight/2 - 180);
      drawLineByID("g4", mainBox.offsetWidth/2+215, mainBox.offsetHeight/2 + 180, mainBox.offsetWidth/2+145, mainBox.offsetHeight/2 + 180);
      
      // position items for fitting each monitor
      // draw lines for fitting each monitor
      // check New items from APP
      positionItems();
      drawAllLines();
      checkNewItems();

      // show center of svg
      document.documentElement.scrollLeft = mainBox.offsetWidth/2 - screen.availWidth/2;
      document.documentElement.scrollTop = mainBox.offsetHeight/2 - screen.availHeight/2;
      //console.log(mainBox.offsetWidth/2-75);

      // 세션 만료시 home으로 이동
      var maxtime = <%= session.getMaxInactiveInterval() %>;
      setTimeout(function() {
    	  if(isMyMap) {
              console.log("timeout");
              location.href="home.jsp";
    	  }
      }, maxtime*1000);
      
      /*
      function clicked explain
      if change parent item
        change itemID
        change file DB, folder name
        change note DB
        modify selected item's line
        change itemID, lineID DB (only selected item and it's line)
      
        if need not change L, R
          change lineID DB (directly connected from selected item)
        else need change L, R
          change itemID, lineID DB by Tree traversal (all child of selected-item)
      
        change selected-item to parent-item
        update itemTop, itemLeft DB (calculate relative X, Y)
      else just change selected item
        change selected item
      */
      function clicked(e) {
       var beforeItemID = fromID;
       var beforeItem = document.getElementById(beforeItemID);
       var afterItemID = "";
       var changeLRFlag = false;
       
        // if change parent item
        if(findingParent == 1) {
           // change itemID
           if(e.target.id == "grade1" || e.target.id == "grade2") {
               var items = document.getElementsByClassName("item");
               var toFrom = "_" + fromID.substring(fromID.indexOf("_")+1, fromID.length);
                for (var i=0; i<items.length; i++) {
                    if(items[i].id.indexOf(toFrom) > -1) {
                      var item = document.getElementById(items[i].id);
                      if(item.id.substring(item.id.length-1, item.id.length) == "R") {
                    	  changeLRFlag = true;
                      }
                      item.id = e.target.id + "_" + fromID.substring(fromID.indexOf("_")+1, fromID.length - 1) + "L";
                      fromID = e.target.id + "_" + fromID.substring(fromID.indexOf("_")+1, fromID.length - 1) + "L";
                      break;
                    }
                }
           }
           else if(e.target.id == "grade3" || e.target.id == "grade4") {
               var items = document.getElementsByClassName("item");
               var toFrom = "_" + fromID.substring(fromID.indexOf("_")+1, fromID.length);
                for (var i=0; i<items.length; i++) {
                    if(items[i].id.indexOf(toFrom) > -1) {
                      var item = document.getElementById(items[i].id);
                      if(item.id.substring(item.id.length-1, item.id.length) == "L") {
                    	  changeLRFlag = true;
                      }
                      item.id = e.target.id + "_" + fromID.substring(fromID.indexOf("_")+1, fromID.length - 1) + "R";
                      fromID = e.target.id + "_" + fromID.substring(fromID.indexOf("_")+1, fromID.length - 1) + "R";
                      break;
                    }
                }
           }
           else {
               var items = document.getElementsByClassName("item");
               var toFrom = "_" + fromID.substring(fromID.indexOf("_")+1, fromID.length);
                for (var i=0; i<items.length; i++) {
                    if(items[i].id.indexOf(toFrom) > -1) {
                      var item = document.getElementById(items[i].id);
                      item.id = e.target.id.substring(e.target.id.indexOf("_")+1, e.target.id.length-1) + "_" + fromID.substring(fromID.indexOf("_")+1, fromID.length - 1) + e.target.id.substring(e.target.id.length-1, e.target.id.length);
                      fromID = e.target.id.substring(e.target.id.indexOf("_")+1, e.target.id.length-1) + "_" + fromID.substring(fromID.indexOf("_")+1, fromID.length - 1) + e.target.id.substring(e.target.id.length-1, e.target.id.length);
                      break;
                    }
                }
           }
           afterItemID = fromID;
           
           //change file DB, folder name
           // 파일 db, 폴더 변경
           fileChangeID = (beforeItemID + "/" + afterItemID);
           fileData.setAttribute("value", fileChangeID);
           fileForm = $("#fileForm").serialize();
           $.ajax({
              url: "updateFileAction.jsp",
              type: "post",
              dataType : 'json',
              cache: false,
              data: fileForm,
              success: function(data) {
                 //console.log(data);
            	  //console.log("success");
              },
              error: function (request, status, error) {
                 console.log(error);
              }
           });
           
           // change note DB
           noteItemID.setAttribute("value", beforeItemID + "/" + afterItemID);
           noteType.setAttribute("value", "change");
           noteForm = $("#noteForm").serialize();
           $.ajax({
              url: "noteAction.jsp",
              type: "post",
              cache: false,
              data: noteForm,
              dataType: "html",
              success: function(data) {
                 //console.log(data);
            	  //console.log("success");
              },
              error: function (request, status, error) {
                 console.log(error);
              }
           });
           
           
            //saveFlag = true;
            // modify selected item's line
            drawLine(e.target.id, fromID);
            findingParent = 0;
            
            // change itemID, lineID DB (only selected item and it's line)
            var lines = document.getElementsByClassName("itemLines");
            var toFrom = "To" + afterItemID;
            for(var j=0; j<lines.length; j++) {
               if(lines[j].id.indexOf(toFrom) > -1) {
                  var line = document.getElementById(lines[j].id);
                  sql = "update line set lineID='"+line.getAttribute("id")+"' where lineID='"+removedLine+"' and userID='"+userID+"'";
               }
            }
            lineSql.setAttribute("value", sql);
            
            sql = "update item set itemID='"+afterItemID+"' where itemID='"+beforeItemID+"' and userID='"+userID+"'";
            itemSql.setAttribute("value", sql);
            saveActionForm = $("#saveActionForm").serialize();
            $.ajax({
               url: "saveItemAction.jsp",
               type: "post",
               cache: false,
               data: saveActionForm,
               dataType: "html",
               success: function(data) {
            	   //console.log("success");
                  //console.log(data);
               },
               error: function (request, status, error) {
                  console.log(error);
               }
            });
            itemSql.setAttribute("value", "");
            lineSql.setAttribute("value", "");
            
            
            var lines = document.getElementsByClassName("itemLines");
            var fromTo = beforeItemID + "To";
            for(var j=0; j<lines.length; j++) {
               if(lines[j].id.indexOf(fromTo) > -1) {
                  var line = document.getElementById(lines[j].id);
                  sql = "update line set lineID='"+afterItemID+"To"+line.getAttribute("id").substring(line.getAttribute("id").indexOf("To")+2, line.getAttribute("id").length)+"' where lineID='"+line.getAttribute("id")+"' and userID='"+userID+"'";
                  line.id = afterItemID+"To"+line.getAttribute("id").substring(line.getAttribute("id").indexOf("To")+2, line.getAttribute("id").length);
               }
               lineSql.setAttribute("value", sql);
               
               saveActionForm = $("#saveActionForm").serialize();
               $.ajax({
                  url: "saveItemAction.jsp",
                  type: "post",
                  cache: false,
                  data: saveActionForm,
                  dataType: "html",
                  async: false,
                  success: function(data) {
                     //console.log("success");
                     //console.log(data);
                  },
                  error: function (request, status, error) {
                     console.log(error);
                  }
               });
				//console.log(itemSql.getAttribute("value"));
				//console.log(lineSql.getAttribute("value"));
               itemSql.setAttribute("value", "");
               lineSql.setAttribute("value", "");
            }
            
            //-----------------------------------------------------------
            //console.log("---------------")
            // if need not change L, R
            if(!changeLRFlag) { // L -> L or R -> R
            	// change lineID DB (directly connected from selected item)
                for(var j=0; j<lines.length; j++) {
                    var lines = document.getElementsByClassName("itemLines");
                    var fromTo = beforeItemID + "To";
                    if(lines[j].id.indexOf(fromTo) > -1) {
                       var line = document.getElementById(lines[j].id);
                       sql = "update line set lineID='"+afterItemID+"To"+line.getAttribute("id").substring(line.getAttribute("id").indexOf("To")+2, line.getAttribute("id").length)+"' where lineID='"+line.getAttribute("id")+"' and userID='"+userID+"'";
                       line.id = afterItemID+"To"+line.getAttribute("id").substring(line.getAttribute("id").indexOf("To")+2, line.getAttribute("id").length);
                    }
                    lineSql.setAttribute("value", sql);
                    
                    saveActionForm = $("#saveActionForm").serialize();
                    $.ajax({
                       url: "saveItemAction.jsp",
                       type: "post",
                       cache: false,
                       data: saveActionForm,
                       dataType: "html",
                       async: false,
                       success: function(data) {
                     	  //console.log("success");
                          //console.log(data);
                       },
                       error: function (request, status, error) {
                          console.log(error);
                       }
                    });
                    itemSql.setAttribute("value", "");
                    lineSql.setAttribute("value", "");
                 }
            }
            // else need change L, R
            else { // L -> R or R -> L
            	// change itemID, lineID DB by Tree traversal (all child of selected-item)
            	var stack = [];
            	var root = afterItemID.substring(afterItemID.indexOf("_")+1, afterItemID.length-1);
            	var items = document.getElementsByClassName("item");
            	var lines = document.getElementsByClassName("itemLines");
            	var itemP = root + "_";
            	var isL = false;
            	var stackDone =	[];
            	
            	stack.push(afterItemID);
            	if(afterItemID.substring(afterItemID.length-1, afterItemID.length) == "R") {
            		isL = true;
            	}
            	
            	//console.log("1. " + stack + " " + root + " " + itemP);
            	while(true) {
            		var j=0;
                	for(j=0; j<items.length; j++) {
                        if(items[j].id.indexOf(itemP) > -1) {
                            var item = document.getElementById(items[j].id);
                            if(stackDone.indexOf(item.id) == -1) {
                                stack.push(item.id);
                                itemP = item.id.substring(item.id.indexOf("_")+1, item.id.length-1) + "_";
                                break;
                            }
                         }
                	}
                	//console.log("2. " + stack + " " + itemP);
                	
                	if(j == items.length && itemP == root+"_") {
                		//console.log("while OUT");
                		break;
                	}
                	
                	if(j == items.length) {
                		//console.log("(1)");
                		var leaf = document.getElementById(stack.pop());
                		if(isL) {
                			//console.log("(2L)");
                            sql = "update item set itemID='" + leaf.id.substring(0, leaf.id.length-1)+"R" + "' where itemID='"+ leaf.id +"'";
                            itemSql.setAttribute("value", sql);
                			leaf.id = leaf.id.substring(0, leaf.id.length-1) + "R";
                			
                        	for(var j=0; j<lines.length; j++) {
                                if(lines[j].id.indexOf("To" + leaf.id.substring(0, leaf.id.length-1)) > -1) {
                                    var line = document.getElementById(lines[j].id);
    		                        sql = "update line set lineID='"+ line.id.substring(0, line.id.indexOf("To")-1)+"RTo"+line.id.substring(line.id.indexOf("To")+2, line.id.length-1)+"R" +"' where lineID='"+ line.id +"'";
    		                        lineSql.setAttribute("value", sql);
    								line.id = line.id.substring(0, line.id.indexOf("To")-1) + "RTo" + line.id.substring(line.id.indexOf("To")+2, line.id.length-1) + "R";
    		                        
    								itemP = line.id.substring(line.id.indexOf("To")+2, line.id.length);
    								itemP = itemP.substring(0, itemP.indexOf("_")) + "_";
    								stackDone.push(line.id.substring(line.id.indexOf("To")+2, line.id.length));
    								//console.log(itemSql.getAttribute("value"));
    								//console.log(lineSql.getAttribute("value"));
                                    break;
                                 }
                        	}
                		}
                		else {
                			//console.log("(2R)");
                            sql = "update item set itemID='" + leaf.id.substring(0, leaf.id.length-1)+"L" + "' where itemID='"+ leaf.id +"'";
                            itemSql.setAttribute("value", sql);
                			leaf.id = leaf.id.substring(0, leaf.id.length-1) + "L";
                            
                        	for(var j=0; j<lines.length; j++) {
                                if(lines[j].id.indexOf("To" + leaf.id.substring(0, leaf.id.length-1)) > -1) {
                                    var line = document.getElementById(lines[j].id);
    		                        sql = "update line set lineID='"+ line.id.substring(0, line.id.indexOf("To")-1)+"LTo"+line.id.substring(line.id.indexOf("To")+2, line.id.length-1)+"L" +"' where lineID='"+ line.id +"'";
    		                        lineSql.setAttribute("value", sql);
    								line.id = line.id.substring(0, line.id.indexOf("To")-1) + "LTo" + line.id.substring(line.id.indexOf("To")+2, line.id.length-1) + "L";
    		                        
    								itemP = line.id.substring(line.id.indexOf("To")+2, line.id.length);
    								itemP = itemP.substring(0, itemP.indexOf("_")) + "_";
    								stackDone.push(line.id.substring(line.id.indexOf("To")+2, line.id.length));
    								//console.log(itemSql.getAttribute("value"));
    								//console.log(lineSql.getAttribute("value"));
                                    break;
                                 }
                        	}
                		}
                		
                		//console.log("(3Ajax)");
                        saveActionForm = $("#saveActionForm").serialize();
                        $.ajax({
                           url: "saveItemAction.jsp",
                           type: "post",
                           cache: false,
                           data: saveActionForm,
                           dataType: "html",
                           async: false,
                           success: function(data) {
                         	  //console.log("success");
                              //console.log(data);
                           },
                           error: function (request, status, error) {
                              console.log(error);
                           }
                        });
                        itemSql.setAttribute("value", "");
                        lineSql.setAttribute("value", "");
                	}
					//console.log("End---------------");
            	}
            }
            
              // change selected-item to parent-item
              if(e.target.className == "item" || e.target.className == "grades") { 
                 var afterID = "";
               if(fromID == "") {
                   var after = document.getElementById(e.target.id);
                   after.style.border = "2px solid #93c9eb";
               }
               else if(e.target.id != fromID) {
                   var before = document.getElementById(fromID);
                   before.style.border = "2px solid #828282";

                   var after = document.getElementById(e.target.id);
                   after.style.border = "2px solid #93c9eb";
                   
                   afterID = e.target.id;
               }
                
               afterID = e.target.id;
               fromID = afterID;
               lastItemX = getX(e.target.id);
               lastItemY = getY(e.target.id);
               lastItemW = getW(e.target.id);
               lastItemH = getH(e.target.id);
            }
              
              // update itemTop, itemLeft DB (calculate relative X, Y)
              //console.log(e.target.id);
              //console.log(afterItemID);
              var itemP = document.getElementById(e.target.id);
              var itemC = document.getElementById(afterItemID); 
              var topPC = parseFloat(itemC.style.top.substring(0,itemC.style.top.length-2)) - parseFloat(itemP.style.top.substring(0,itemP.style.top.length-2));
              var leftPC = parseFloat(itemC.style.left.substring(0,itemC.style.left.length-2)) - parseFloat(itemP.style.left.substring(0,itemP.style.left.length-2));
              //console.log(itemC.style.top.substring(0,itemC.style.top.length-2) + " " + itemC.style.left.substring(0,itemC.style.left.length-2));
              //console.log(itemP.style.top.substring(0,itemP.style.top.length-2) + " " + itemP.style.left.substring(0,itemP.style.left.length-2));
              //console.log(topPC + " " + leftPC);
              sql = "update item set itemTop='"+topPC+"', itemLeft='"+leftPC+"' where itemID='"+itemC.id+"'";
              itemSql.setAttribute("value", sql);
              saveActionForm = $("#saveActionForm").serialize();
              $.ajax({
                 url: "saveItemAction.jsp",
                 type: "post",
                 cache: false,
                 data: saveActionForm,
                 dataType: "html",
                 success: function(data) {
              	   //console.log("success");
                    //console.log(data);
                 },
                 error: function (request, status, error) {
                    console.log(error);
                 }
              });
              itemSql.setAttribute("value", "");
              lineSql.setAttribute("value", ""); 
        }
        // else just change selected item
        else {
        	  // change selected item
              if(e.target.className == "item" || e.target.className == "grades") {
                  if(fromID == "") {
                      var after = document.getElementById(e.target.id);
                      after.style.border = "2px solid #93c9eb";
                  }
                  else if(e.target.id != fromID) {
                      var before = document.getElementById(fromID);
                      before.style.border = "2px solid #828282";

                      var after = document.getElementById(e.target.id);
                      after.style.border = "2px solid #93c9eb";
                  }
                  
                  fromID = e.target.id;
                  lastItemX = getX(e.target.id);
                  lastItemY = getY(e.target.id);
                  lastItemW = getW(e.target.id);
                  lastItemH = getH(e.target.id);
              }
        }
      }

      // get item's X, Y, W, H
      function getX(id) { 
        var target = document.getElementById(id);
        return target.getBoundingClientRect().left;
      }

      function getY(id) {
        var target = document.getElementById(id);
        return target.getBoundingClientRect().top;
      }

      function getW(id) {
        var element = document.getElementById(id);
        var w = element.offsetWidth;
        return w;
      }

      function getH(id) {
        var element = document.getElementById(id);
        var h = element.offsetHeight;
        return h;
      }

      /*
      function createItem explain
      if selected item has New APP item
        activate and get hidden APP item which is created at HTML
        check like "1 New!!" whether delete or count down before changing innerHTML
        draw line
        insert new line, note DB (APP item has item DB but hasn't line, note DB)
      
        if selected item still has New APP item
        put on selected item
        
      else if myMap
        create new item <div>
        if it's root is grade1,2 put left side else put right side
        draw line
        insert item, line, note DB
        itemCnt++;
        
        check if create APP item has connected APP item
        if exist put like "1 New!!" on connected APP item
      */
      function createItem() {
    	  // new 가 있으면 새로 만들지 말고 app에서 만든거 가져오기
    	  var spanNew = document.getElementById(fromID+"New");
    	  var appItem;
    	  //console.log("------------------------");
    	  // if selected item has New APP item
		  if(spanNew != null) {
			  //console.log("spanNew start");
			  var connID;
			  if(spanNew.id == "grade1New"){
				  connID = "grade1";
			  }
			  else if(spanNew.id == "grade2New"){
				  connID = "grade2";
			  }
			  else if(spanNew.id == "grade3New"){
				  connID = "grade3";
			  }
			  else if(spanNew.id == "grade4New"){
				  connID = "grade4";
			  }
			  else {
				  connID = spanNew.id.substring(spanNew.id.indexOf("_")+1, spanNew.id.length-4);
			  }
			  //console.log("connID: " + connID);
			  
			  // activate and get hidden APP item which is created at HTML
			  var top;
			  var left;
			  for(var i=0; i<itemAppList.length; i++) {
				  if(itemAppList[i] != null) {
					  if(itemAppList[i].indexOf(connID+"_") > -1) {
						  //console.log("spanNew find");
						  appItem = document.getElementById(itemAppList[i]);
						  appItem.style.display = "flex";
						  
				          if(appItem.id.indexOf("L") > 0) {
				        	  //console.log("spanNew Left");
				        	  appItem.style.top = 20 + 80 + document.documentElement.scrollTop + "px";
				        	  appItem.style.left = 20 + document.documentElement.scrollLeft +"px";
				          }
				          else {
				        	  //console.log("spanNew Right");
				        	  appItem.style.top = 20 + 80 + document.documentElement.scrollTop + "px";
				        	  appItem.style.left = upBox.offsetWidth - 170 + document.documentElement.scrollLeft +"px";
				          }
				          
				          delete itemAppList[i];
				          break;
					  }
				  } 
			  }
			  
			  // check like "1 New!!" whether delete or count down 
			  var spanNewID = spanNew.id.substring(0, spanNew.id.length-3);
			  if(spanNew.innerText == "1New!!") {
				  //console.log("spanNew 1New");
				  spanNew.remove();
			  }
			  else {
				  //console.log("spanNew 2New");
				  var cnt = parseInt(spanNew.innerText.substring(0, 1));
				  spanNew.innerText = cnt-1 + "New!!";
			  }
			  //console.log("spanNew End");
			  
			  //console.log(spanNewID);
			  //console.log(appItem.id);
			  drawLine(spanNewID, appItem.id);
			  
			  // insert new line, note DB (APP item has item DB but hasn't line, note DB)
			  var appLineID = spanNewID + "To" + appItem.id;
			  sql = "insert into line values('"+appLineID+"', '"+userID+"')";
	          lineSql.setAttribute("value", sql);
	          saveActionForm = $("#saveActionForm").serialize();
	          $.ajax({
	             url: "saveItemAction.jsp",
	             type: "post",
	             cache: false,
	             data: saveActionForm,
	             dataType: "html",
	             success: function(data) {
	          	 //console.log("success");
	              //console.log(data);
	             },
	             error: function (request, status, error) {
	               console.log(error);
	             }
	          });
	          itemSql.setAttribute("value", "");
	          lineSql.setAttribute("value", "");
			  
	          /*noteItemID.setAttribute("value", itemID); 
	          noteType.setAttribute("value", "insert");
	          noteForm = $("#noteForm").serialize();
	          $.ajax({
	             url: "noteAction.jsp",
	             type: "post",
	             cache: false,
	             data: noteForm,
	             dataType: "html",
	             success: function(data) {
	                //console.log(data);
	          	   //console.log("success");
	             },
	             error: function (request, status, error) {
	                console.log(error);
	             }
	          });*/
	          
	          // if selected item still has New APP item
	          for(var i=0; i<itemAppList.length; i++) {
	        	  var connID = appItem.id.substring(appItem.id.indexOf("_")+1, appItem.id.length-1);
	        	  var cnt = 0;
	        	  if(itemAppList[i] != null) {
		        	  if(itemAppList[i].indexOf(connID) > -1) {
		        		  cnt = cnt + 1;
		        	  }
	        	  }
	          }
	          // put on selected item
	          //console.log(itemAppDict);
	          if(cnt > 0) {
	        	  var spanNew = document.getElementById(appItem.id+"New");
	        	  spanNew.style.top = parseFloat(appItem.style.top.substring(0, appItem.style.top.length-2)) - 25 + "px"; 
	        	  spanNew.style.left = appItem.style.left;
	          }
		  }
    	  // else if myMap
		  else if(isMyMap) {
            const newDiv = document.createElement('div');
            itemID = "item" + itemCnt;

            var str = document.getElementById(fromID);
            if(str.id.indexOf("_") <= -1) {
                  if(str.id.indexOf("grade1") > -1) {
                    itemID = "grade1_" + itemID + "L";
                  }
                  else if(str.id.indexOf("grade2") > -1) {
                    itemID = "grade2_" + itemID + "L";
                  }
                  else if(str.id.indexOf("grade3") > -1) {
                    itemID = "grade3_" + itemID + "R";
                  }
                  else if(str.id.indexOf("grade4") > -1) {
                    itemID = "grade4_" + itemID + "R";
                  }
            }
            else if(str.id.indexOf("_") > -1) {
               itemID = str.id.substring(str.id.indexOf("_")+1, str.id.length-1) + "_" + itemID + str.id.substring(str.id.length-1, str.id.length);
            }
            
            
			// create new item <div>
            newDiv.setAttribute("class", "item");
            newDiv.setAttribute("id", itemID);
            toID = itemID;

            newDiv.setAttribute("draggable", "true");
            newDiv.setAttribute("ondragstart", "dragStart(event)");
            newDiv.setAttribute("ondrag", "onDrag(event)");
            newDiv.setAttribute("ondragover", "allowDrop(event)");
            newDiv.setAttribute("ondrop", "drop(event)");
            newDiv.setAttribute("onclick", "clicked(event)");
            newDiv.setAttribute("ondblclick", "popup()");
            newDiv.setAttribute("onmousedown", "mouseDown(event)");
            newDiv.setAttribute("onmouseup", "mouseUp(event)");
            newDiv.setAttribute("oncontextmenu", "contextmenu(event)");
            
            // if it's root is grade1,2 put left side else put right side
            var top;
            var left;
            if(itemID.indexOf("L") > 0) {
                top = 20 + 80 + document.documentElement.scrollTop + "px";
                left = 20 + document.documentElement.scrollLeft +"px";
            }
            else {
                top = 20 + 80 + document.documentElement.scrollTop + "px";
                left = upBox.offsetWidth - 170 + document.documentElement.scrollLeft +"px";
            }
            newDiv.style.top = top;
            newDiv.style.left = left;

            mainBox.appendChild(newDiv); 
            drawLine(fromID, itemID);
            
            // insert line, item, note DB
            var lines = document.getElementsByClassName("itemLines");
            var toFrom = "To" + itemID;
            for(var j=0; j<lines.length; j++) {
               if(lines[j].id.indexOf(toFrom) > -1) {
                  var line = document.getElementById(lines[j].id);
                  sql = "insert into line values('"+line.getAttribute("id")+"', '"+userID+"')";
               }
            }
            lineSql.setAttribute("value", sql);
            
            var itemP = document.getElementById(fromID);
            var itemC = document.getElementById(itemID); 
            var topPC = parseFloat(itemC.style.top.substring(0,itemC.style.top.length-2)) - parseFloat(itemP.style.top.substring(0,itemP.style.top.length-2));
            var leftPC = parseFloat(itemC.style.left.substring(0,itemC.style.left.length-2)) - parseFloat(itemP.style.left.substring(0,itemP.style.left.length-2));
            //console.log(itemC.style.top.substring(0,itemC.style.top.length-2) + " " + itemC.style.left.substring(0,itemC.style.left.length-2));
            //console.log(itemP.style.top.substring(0,itemP.style.top.length-2) + " " + itemP.style.left.substring(0,itemP.style.left.length-2));
            //console.log(topPC + " " + leftPC);
            sql = "insert into item values ('"+itemID+"', '" + topPC + "', '" + leftPC + "',  '"+userID+"', '', "+itemCnt+", '150px', '50px')";
            itemSql.setAttribute("value", sql);
            saveActionForm = $("#saveActionForm").serialize();
            $.ajax({
               url: "saveItemAction.jsp",
               type: "post",
               cache: false,
               data: saveActionForm,
               dataType: "html",
               success: function(data) {
            	   //console.log("success");
                  //console.log(data);
               },
               error: function (request, status, error) {
                  console.log(error);
               }
            });
            itemSql.setAttribute("value", "");
            lineSql.setAttribute("value", ""); 
            
            noteItemID.setAttribute("value", itemID); 
            noteType.setAttribute("value", "insert");
            noteForm = $("#noteForm").serialize();
            $.ajax({
               url: "noteAction.jsp",
               type: "post",
               cache: false,
               data: noteForm,
               dataType: "html",
               success: function(data) {
                  //console.log(data);
            	   //console.log("success");
               },
               error: function (request, status, error) {
                  console.log(error);
               }
            });
            
            //saveFlag = true;
            //console.log(itemSQL[itemID]);
            itemCnt = itemCnt + 1;
    	}
    	
    	
    	// check new!! 
        var backID = itemID.substring(itemID.indexOf("_"+1, itemID.length-1));
        const newDiv = document.createElement('div');
        
           // check if create APP item has connected APP item
           // if exist put like "1 New!!" on connected APP item
	   	   if(backID in itemAppDict) {
	   		   //console.log("create new");
	           newDiv.setAttribute("class", "new");
	           newDiv.setAttribute("id", itemID+"New");
	           newDiv.style.top = parseFloat(item.style.top.substring(0, item.style.top.length-2)) - 25 + "px";
	           newDiv.style.left = item.style.left;
	           newDiv.innerText = itemAppDict[backID] + "New!!";
	           
	           mainBox.appendChild(newDiv);
			   delete itemAppDict[backID];
		   }
      }

      // change selected item
      function dragStart(event) {
        event.dataTransfer.setData("ID", event.target.id);
      
        if(fromID != ""){
            var before = document.getElementById(fromID);
            before.style.border = "2px solid #828282";
        }

        var after = document.getElementById(event.target.id);
        after.style.border = "2px solid #93c9eb";
      }

      /*
      function drop explain
      if myMap
        if drop on item or grades
          change selected itemID
          change(): delete item's line and set changeParent flag
          clicked(event): do change parent action
        else drop on blank space
          check overflow
          change position selected item X,Y
          re-draw selected item's line
          update selected item X,Y DB
          
          re-draw connected lines, items backward of selected item
          update connected lines, items DB
          
          if selected item has New APP item position text "1 New!!" 
      */
      function drop(event) {
    	  var id = event.dataTransfer.getData("ID");
          var item = document.getElementById(id);
          var spanNew = document.getElementById(id+"New");
          var afterTop;
          var afterLeft;
          //console.log(item.id);
          //console.log(spanNew.id);
          
         // if myMap
    	 if(isMyMap) {
             event.preventDefault();
             var upBox = document.getElementById("up_box");
             
             // if drop on item or grades
             if(item.id != event.target.id && event.target.className == "item" || item.id != event.target.id && event.target.className == "grades") {
                // change selected itemID
                // change(): delete item's line and set changeParent flag
                // clicked(event): do change parent action
            	fromID = id;
                change();
                clicked(event);
             }
             // else drop on blank space
             else {
                afterTop = (mouseY - upBox.offsetHeight - item.clientHeight/2 + 80 + document.documentElement.scrollTop).toString() + "px";
                afterLeft = (mouseX - item.clientWidth/2 + document.documentElement.scrollLeft).toString() + "px";
                
                var afterX = parseInt(afterLeft.substring(0, afterLeft.length-2));
                var afterY = parseInt(afterTop.substring(0, afterTop.length-2));
                var itemW = parseInt(item.style.width.substring(0, item.style.width.length-2));
                var itemH = parseInt(item.style.height.substring(0, item.style.height.length-2));
          	   //mainWrap.style.width = screen.availWidth*2.3 + "px";
        	   //mainWrap.style.height = screen.availHeight*4 + "px";
                // top overflow
                if(afterY < 80) {
                	afterTop = "80px";
                }
                // right overflow
                if(afterX+itemW > screen.availWidth*2.3) {
                	afterLeft = screen.availWidth*2.3 - itemW + "px";
                }
                // left overflow
                if(afterX < 0) {
                	afterLeft = "0px";
                }
                // bottom overflow
                if(afterY+itemH > screen.availHeight*4) {
                	afterTop = screen.availHeight*4 - itemH + "px";
                }
                

                //saveFlag = true;
                
                // change position selected item X,Y
                mouseX = mouseX - item.clientWidth/2 + document.documentElement.scrollLeft;
                mouseY = mouseY - upBox.offsetHeight - item.clientHeight/2 + 80 + document.documentElement.scrollTop;
                item.style.top = afterTop;
                item.style.left = afterLeft;
                
                // re-draw selected item's line
                var lines = document.getElementsByClassName("itemLines");
                var idTo = id + "To";
                var toId = "To" + id;
                var cnt = 0;
                for (var i=0; i<lines.length; i++) {
                  if(lines[i].id.indexOf(toId) != -1) {
                    fromID = lines[i].id.substring(0, lines[i].id.indexOf("To"));
                    toID = lines[i].id.substring(lines[i].id.indexOf("To")+2, lines[i].id.length);
                    var line = document.getElementById(lines[i].id);
                    line.remove();
                    drawLine(fromID, toID);
                  }
                  else {
                    cnt += 1;
                  }
                }
                if(cnt == lines.length) {
                  drawLine(fromID, toID);
                }
                
                
                var itemPId = item.id.substring(0, item.id.indexOf("_"));
                var items = document.getElementsByClassName("item");
                //console.log("1. " + itemPId);
                for(var i=0; i<items.length; i++) {
                	var item = document.getElementById(items[i].id);
                	if(item.id.indexOf("_" + itemPId) > 0) {
                		itemPId = item.id;
                		//console.log("2. " + itemPId);
                	}
                }
                
                var itemP = document.getElementById(itemPId);
                var itemPTop = itemP.style.top;
                var itemPLeft = itemP.style.left;
                var relTop = parseFloat(afterTop.substring(0, afterTop.length-2)) - parseFloat(itemPTop.substring(0, itemPTop.length-2));
                var relLeft = parseFloat(afterLeft.substring(0, afterLeft.length-2)) - parseFloat(itemPLeft.substring(0, itemPLeft.length-2));
                relTop = String(relTop);
                relLeft = String(relLeft);

             	// update selected item X,Y DB
                sql = "update item set itemTop='"+relTop+"', itemLeft='"+relLeft+"' where itemID='"+id+"' and userID='"+userID+"'";;
                itemSql.setAttribute("value", sql);
                saveActionForm = $("#saveActionForm").serialize();
                $.ajax({
                   url: "saveItemAction.jsp",
                   type: "post",
                   cache: false,
                   data: saveActionForm,
                   dataType: "html",
                   success: function(data) {
                	  //console.log("success");
                      //console.log(data);
                   },
                   error: function (request, status, error) {
                	  //console.log("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
                      console.log(error);
                   }
                });
                itemSql.setAttribute("value", "");
                lineSql.setAttribute("value", "");
          
                // re-draw connected lines, items backward of selected item
                var arr = [];
                for (var i=0; i<lines.length; i++) {
                  if(lines[i].id.indexOf(idTo) != -1) {
                    fromID = lines[i].id.substring(0, lines[i].id.indexOf("To"));
                    toID = lines[i].id.substring(lines[i].id.indexOf("To")+2, lines[i].id.length);
          
                    arr.push(fromID);
                    arr.push(toID);
                  }
                }
                for(var i=0; i<arr.length; i += 2) { 
                  var line = document.getElementById(arr[i] + "To" + arr[i+1]);
                  line.remove();
                  drawLine(arr[i], arr[i+1]);

                  // update connected lines, items DB
                  line.id.substring(0, line.id.indexOf("To"))
                  var itemP = document.getElementById(line.id.substring(0, line.id.indexOf("To")));
                  var itemC = document.getElementById(line.id.substring(line.id.indexOf("To")+2, line.id.length)); 
                  var topPC = parseFloat(itemC.style.top.substring(0,itemC.style.top.length-2)) - parseFloat(itemP.style.top.substring(0,itemP.style.top.length-2));
                  var leftPC = parseFloat(itemC.style.left.substring(0,itemC.style.left.length-2)) - parseFloat(itemP.style.left.substring(0,itemP.style.left.length-2));
                  //console.log(itemC.style.top.substring(0,itemC.style.top.length-2) + " " + itemC.style.left.substring(0,itemC.style.left.length-2));
                  //console.log(itemP.style.top.substring(0,itemP.style.top.length-2) + " " + itemP.style.left.substring(0,itemP.style.left.length-2));
                  //console.log(topPC + " " + leftPC);
                  sql = "update item set itemTop='"+topPC+"', itemLeft='"+leftPC+"' where itemID='"+itemC.id+"'";
                  itemSql.setAttribute("value", sql);
                  saveActionForm = $("#saveActionForm").serialize();
                  $.ajax({
                     url: "saveItemAction.jsp",
                     type: "post",
                     cache: false,
                     data: saveActionForm,
                     dataType: "html",
                     success: function(data) {
                  	   //console.log("success");
                        //console.log(data);
                     },
                     error: function (request, status, error) {
                        console.log(error);
                     }
                  });
                  itemSql.setAttribute("value", "");
                  lineSql.setAttribute("value", "");
                }
                
                fromID = id;
             }
             
             // if selected item has New APP item position text "1 New!!" 
             //console.log(afterTop);
             //console.log(afterLeft);
             if(spanNew != null) {
           	  spanNew.style.top = parseFloat(afterTop.substring(0, afterTop.length-2)) - 25 + "px";
           	  spanNew.style.left = afterLeft; 
             }
             
             itemSizeFlag = false;
    	 }
      }

      // allowDrop item and grades
      function allowDrop(event) {
    	if(isMyMap) {
            event.preventDefault();
    	}
      }

      // trace current mouse X,Y
      function onDrag(event) {
        mouseX = event.clientX;
        mouseY = event.clientY;
      }

      // draw line fromID to toID by L,R
      function drawLine(fromID, toID) { 
        if(fromID == "grade1") {
          const newLine = document.createElementNS("http://www.w3.org/2000/svg", "line");
          var lineID = fromID + "To" + toID;
          newLine.setAttribute("class", "itemLines");
          newLine.setAttribute("id", lineID);
          newLine.setAttribute("x1", getItemX(toID)+getW(toID));
          newLine.setAttribute("y1", getItemY(toID)-getH(toID)/2);
          newLine.setAttribute("x2", getX(fromID) + document.documentElement.scrollLeft);
          newLine.setAttribute("y2", getItemY(fromID)-getH(fromID)/2);
          newLine.style.stroke = "rgb(170,170,170)";
          newLine.style.strokeWidth = "2";
          svg.appendChild(newLine);
        }
        else if(fromID == "grade2") {
            const newLine = document.createElementNS("http://www.w3.org/2000/svg", "line");
            var lineID = fromID + "To" + toID;
            newLine.setAttribute("class", "itemLines");
            newLine.setAttribute("id", lineID);
            newLine.setAttribute("x1", getItemX(toID)+getW(toID));
            newLine.setAttribute("y1", getItemY(toID)-getH(toID)/2);
            newLine.setAttribute("x2", getX(fromID) + document.documentElement.scrollLeft);
            newLine.setAttribute("y2", getItemY(fromID)-getH(fromID)/2);
            newLine.style.stroke = "rgb(170,170,170)";
            newLine.style.strokeWidth = "2";
            svg.appendChild(newLine);
        }
        else if(fromID.indexOf("L") != -1) {
          const newLine = document.createElementNS("http://www.w3.org/2000/svg", "line");
          var lineID = fromID + "To" + toID;
          newLine.setAttribute("class", "itemLines");
          newLine.setAttribute("id", lineID);
          newLine.setAttribute("x1", getItemX(toID)+getW(toID));
          newLine.setAttribute("y1", getItemY(toID)-getH(toID)/2);
          newLine.setAttribute("x2", getItemX(fromID));
          newLine.setAttribute("y2", getItemY(fromID)-getH(fromID)/2);
          newLine.style.stroke = "rgb(170,170,170)";
          newLine.style.strokeWidth = "2";
          svg.appendChild(newLine);
        }
        else if(fromID == "grade3") {
          const newLine = document.createElementNS("http://www.w3.org/2000/svg", "line");
          var lineID = fromID + "To" + toID;
          newLine.setAttribute("class", "itemLines");
          newLine.setAttribute("id", lineID);
          newLine.setAttribute("x1", getX(fromID)+getW(fromID) + document.documentElement.scrollLeft);
          newLine.setAttribute("y1", getY(fromID)+getH(fromID)/2 + document.documentElement.scrollTop);
          newLine.setAttribute("x2", getItemX(toID));
          newLine.setAttribute("y2", getItemY(toID)-getH(toID)/2);
          newLine.style.stroke = "rgb(170,170,170)";
          newLine.style.strokeWidth = "2";
          svg.appendChild(newLine);
        }
        else if(fromID == "grade4") {
            const newLine = document.createElementNS("http://www.w3.org/2000/svg", "line");
            var lineID = fromID + "To" + toID;
            newLine.setAttribute("class", "itemLines");
            newLine.setAttribute("id", lineID);
            newLine.setAttribute("x1", getX(fromID)+getW(fromID) + document.documentElement.scrollLeft);
            newLine.setAttribute("y1", getY(fromID)+getH(fromID)/2 + document.documentElement.scrollTop);
            newLine.setAttribute("x2", getItemX(toID));
            newLine.setAttribute("y2", getItemY(toID)-getH(toID)/2);
            newLine.style.stroke = "rgb(170,170,170)";
            newLine.style.strokeWidth = "2";
            svg.appendChild(newLine);
        }
        else if(fromID.indexOf("R") != -1) {
          const newLine = document.createElementNS("http://www.w3.org/2000/svg", "line");
          var lineID = fromID + "To" + toID;
          newLine.setAttribute("class", "itemLines");
          newLine.setAttribute("id", lineID);
          newLine.setAttribute("x1", getItemX(fromID)+getW(fromID));
          newLine.setAttribute("y1", getItemY(fromID)-getH(fromID)/2);
          newLine.setAttribute("x2", getItemX(toID));
          newLine.setAttribute("y2", getItemY(toID)-getH(toID)/2);
          newLine.style.stroke = "rgb(170,170,170)";
          newLine.style.strokeWidth = "2";
          svg.appendChild(newLine);
        }
      }

      // draw line with pointed start X,Y and end X,Y
      function drawLineByID(id, x1, y1, x2, y2) { 
        var newLine = document.createElementNS("http://www.w3.org/2000/svg", "line");
        newLine.setAttribute("class", "lines");
        newLine.setAttribute("id", id);
        newLine.setAttribute("x1", x1);
        newLine.setAttribute("y1", y1);
        newLine.setAttribute("x2", x2);
        newLine.setAttribute("y2", y2);
        newLine.style.stroke = "rgb(170,170,170)";
        newLine.style.strokeWidth = "2";
        svg.appendChild(newLine);
      }

      /*
      function delete explain
      check one more time are you sure delete?
      delete selected item, item's line DB
      delete selected item file DB, folder
      delete selected item note DB
      delete selected item
      
      delete connected item, item's lines
      delete connected item, line DB
      delete connected item file DB
      delete connected item note DB
      */
      function deleteItem(fromID) {
    	  // check one more time are you sure delete?
          if(confirm("노드를 삭제하시겠습니까?")) {
               var arrItems = [];
               arrItems.push(fromID);
               var item = document.getElementById(fromID);
            
           // delete selected item, item's line DB
           var lines = document.getElementsByClassName("itemLines");
           var toFrom = "To" + item.id;
           for(var j=0; j<lines.length; j++) {
              if(lines[j].id.indexOf(toFrom) > -1) {
                 var line = document.getElementById(lines[j].id);
                 sql = "delete from line where lineID='"+line.getAttribute("id")+"' and userID='"+userID+"'";
              }
           }
           lineSql.setAttribute("value", sql);
            
            sql = "delete from item where itemID='"+item.id+"' and userID='"+userID+"'";;
            itemSql.setAttribute("value", sql);
            saveActionForm = $("#saveActionForm").serialize();
            $.ajax({
               url: "saveItemAction.jsp",
               type: "post",
               cache: false,
               data: saveActionForm,
               dataType: "html",
               success: function(data) {
            	   //console.log("success");
                  //console.log(data);
               },
               error: function (request, status, error) {
                  console.log(error);
               }
            });
            itemSql.setAttribute("value", "");
            lineSql.setAttribute("value", ""); 
            
            var form = document.getElementById("fileForm");
            
            var hiddenField = document.createElement("input");
            hiddenField.setAttribute("type", "hidden");
            hiddenField.setAttribute("name", "action");
            hiddenField.setAttribute("value", "itemDelete");
            form.appendChild(hiddenField);
            
            // delete selected item file DB, folder
            fileChangeID = fromID;
            fileData.setAttribute("value", fileChangeID);
            fileForm = $("#fileForm").serialize();
            $.ajax({
               url: "deleteFileAction.jsp",
               type: "post",
               cache: false,
               data: fileForm,
               dataType: "html",
               success: function(data) {
                  //console.log(data);
            	   //console.log("success");
               },
               error: function (request, status, error) {
                  console.log(error);
               }
            });
            
			// delete selected item note DB
            noteItemID.setAttribute("value", fromID);
            noteType.setAttribute("value", "delete");
            noteForm = $("#noteForm").serialize();
            $.ajax({
               url: "noteAction.jsp",
               type: "post",
               cache: false,
               data: noteForm,
               dataType: "html",
               success: function(data) {
                  //console.log(data);
            	   //console.log("success");
               },
               error: function (request, status, error) {
                  console.log(error);
               }
            });
            
            // delete selected item
            item.remove(); 
            
            //-------------------------------------------------------------------------
            // delete connected item, item's lines
            var lines = document.getElementsByClassName("itemLines");
            var toFrom = "To" + fromID;
             for (var i=0; i<lines.length; i++) {
                 if(lines[i].id.indexOf(toFrom) > -1) {
                   var line = document.getElementById(lines[i].id);
                   lineSQL[line.id] = "delete from line where lineID='"+line.getAttribute("id")+"'";
                   line.remove();
                   break;
                 }
             }
            
             while(true) {
                var items = document.getElementsByClassName("item");
                var target = arrItems[arrItems.length-1];
                target = target.substring(target.indexOf("_")+1, target.length-1);
                
                if(items.length < 1) {
                   break;
                }
                
                 for (var i=0; i<items.length; i++) {
                     if(items[i].id.indexOf(target) > -1) {
                         lines = document.getElementsByClassName("itemLines");
                         fromTo = arrItems[arrItems.length-1] + "To";
                         for (var j=0; j<lines.length; j++) {
                             if(lines[j].id.indexOf(fromTo) > -1) {
                               var line = document.getElementById(lines[j].id);
                               lineSQL[line.id] = "delete from line where lineID='"+line.getAttribute("id")+"'";
                               sql = "delete from line where lineID='"+line.id+"' and userID='"+userID+"'";
                               lineSql.setAttribute("value", sql);
                               line.remove();
                               break;
                             }
                         }
                        
                       arrItems.push(items[i].id);
                       item = document.getElementById(items[i].id);
                       if(itemSQL[item.id] != null) {
                             itemSQL[item.id] = itemSQL[item.id] + "delete from item where itemID='"+item.id+"'";
                       }
                       else{
                            itemSQL[item.id] = "delete from item where itemID='"+item.id+"'";
                       }
                        sql = "delete from item where itemID='"+item.id+"' and userID='"+userID+"'";;
                        itemSql.setAttribute("value", sql);
                        item.remove();
                        
                        //console.log("--------------------------");
                        //console.log("lineSql: " + lineSql.getAttribute("value"));
                        //console.log("itemSql: " + itemSql.getAttribute("value"));
                        //console.log("--------------------------");
                        // delete connected item, line DB
                        saveActionForm = $("#saveActionForm").serialize();
                        $.ajax({
                           url: "saveItemAction.jsp",
                           type: "post",
                           cache: false,
                           data: saveActionForm,
                           dataType: "html",
                           success: function(data) {
                        	   //console.log("success");
                              //console.log(data);
                           },
                           error: function (request, status, error) {
                              console.log(error);
                           }
                        });
                        itemSql.setAttribute("value", "");
                        lineSql.setAttribute("value", "");
                        
                        var form = document.getElementById("fileForm");
                        
                        var hiddenField = document.createElement("input");
                        hiddenField.setAttribute("type", "hidden");
                        hiddenField.setAttribute("name", "action");
                        hiddenField.setAttribute("value", "itemDelete");
                        form.appendChild(hiddenField);
                        
                        // delete connected item file DB
                        fileChangeID = item.id;
                        fileData.setAttribute("value", fileChangeID);
                        fileForm = $("#fileForm").serialize();
                        $.ajax({
                           url: "deleteFileAction.jsp",
                           type: "post",
                           cache: false,
                           data: fileForm,
                           dataType: "html",
                           success: function(data) {
                              //console.log(data);
                        	   //console.log("success");
                           },
                           error: function (request, status, error) {
                              console.log(error);
                           }
                        });
                        
                        // delete connected item note DB
                        noteItemID.setAttribute("value", item.id);
                        noteType.setAttribute("value", "delete");
                        noteForm = $("#noteForm").serialize();
                        $.ajax({
                           url: "noteAction.jsp",
                           type: "post",
                           cache: false,
                           data: noteForm,
                           dataType: "html",
                           success: function(data) {
                              //console.log(data);
                        	   //console.log("success");
                           },
                           error: function (request, status, error) {
                              console.log(error);
                           }
                        });
                        
                        break;
                     }

                     if(i == items.length-1) {
                        arrItems.pop();
                     }
                 }
         
                 if(arrItems.length == 0) {
                    break;
                 }
             }
             
             
            //saveFlag = true;
            //console.log(itemSQL[item.id]);
            window.fromID = "";
          }
       }

      /*
      function modify explain
      onkeyup(event) calls modify()
      change item content
      update item content DB
      */
      // onkeyup(event) calls modify()
      function modify() {
    	  if(isMyMap) {
    		   // change item content
    	       const inputItem = document.getElementById("inputItem");
    	       var item = document.getElementById(inputItem.getAttribute("name"));
    	       var afterContent = inputItem.value;
    	       
    	       //saveFlag = true;
    	       
    	       // update item content DB
    	       sql = "update item set itemContent='"+afterContent+"' where itemID='"+item.id+"' and userID='"+userID+"'";;
    	       itemSql.setAttribute("value", sql);
    	       saveActionForm = $("#saveActionForm").serialize();
    	       $.ajax({
    	          url: "saveItemAction.jsp",
    	          type: "post",
    	          cache: false,
    	          data: saveActionForm,
    	          dataType: "html",
    	          success: function(data) {
    	        	  //console.log("success");
    	             //console.log(data);
    	          },
    	          error: function (request, status, error) {
    	             console.log(error);
    	          }
    	       });
    	       itemSql.setAttribute("value", "");
    	       lineSql.setAttribute("value", "");
    	       

    	        item.innerText = inputItem.value;
    	        inputItem.remove();
    	  }
      }

      // get item X,Y
      function getItemX(id) { 
        var x = document.getElementById(id).style.left;
        x = x.substring(0, x.indexOf("px"));
        x = parseFloat(x);
        return x;
      }

      function getItemY(id) {
        var y = document.getElementById(id).style.top;
        y.substring(0, y.indexOf("px"));
        y = parseFloat(y);
        y = y + getH(id);
        return y;
      }
      
      /*
      function publicmapAction explain
      if map is private ask to user and change public
      if map is public ask to user and change private
      */
      function publicMapAction() {
    	  if(isMyMap) {
        	  var form = document.getElementById("publicMapForm");
        	  var hiddenField = document.createElement("input");
        	  var formData;
              var btn = document.getElementById("publicMap");
        	  
              // if map is private ask to user and change public
              if(publicmap == 0) {
                var confirmflag = confirm('공개로 바꾸시겠습니까?');
                if(confirmflag) {
                      formData = $("#publicMapForm").serialize();
                      //console.log(formData);
                      $.ajax({
                         url: "publicmapAction.jsp?userID="+userID+"&publicmap="+publicmap,
                         type: "post",
                         cache: false,
                         data: formData,
                         dataType: "html",
                         success: function(data) {
                            //console.log(data);
                        	 //console.log("success");
                         },
                         error: function (request, status, error) {
                            console.log(error);
                         }
                      });
                      
                      publicmap = 1;
                      btn.innerHTML = "비공개";
                }
             }
             // if map is public ask to user and change private
             else if(publicmap == 1) {
            	  var password = "";
                  password = prompt('비밀번호를 입력하세요(10자)');
                  if(password != "" && password != null) {
                      
                      hiddenField = document.createElement("input");
                      hiddenField.setAttribute("type", "hidden");
                      hiddenField.setAttribute("name", "password");
                      hiddenField.setAttribute("value", password);
                      form.appendChild(hiddenField);

                      
                      formData = $("#publicMapForm").serialize();
                      //console.log(formData);
                      $.ajax({
                         url: "publicmapAction.jsp?userID="+userID+"&publicmap="+publicmap,
                         type: "post",
                         cache: false,
                         data: formData,
                         dataType: "html",
                         success: function(data) {
                             //console.log(data);
                        	 //console.log("success");
                         },
                         error: function (request, status, error) {
                             console.log(error);
                         }
                      });
                      
                      publicmap = 0;
                      btn.innerHTML = "공개";
                 }
             }
    	  }
      }

      // 여기부터 팝업 조회수 추천
      // open popup window
      function popup() {   // 팝업 이벤트
        var popup_name = fromID;
        var opwin = window.open('popup.jsp?itemID='+fromID+'&mapID='+mapID, popup_name, 'width=400,height=450,left=300px,top=100px,status=no,scrollbars=yes');
      }

      // delete selected item's line
      // set change parent flag
      function change() {
    	  if(isMyMap) {
    	        var lines = document.getElementsByClassName("itemLines");
    	        var toFrom = "To" + fromID;
    	        for (var i=0; i<lines.length; i++) {
    	          if(lines[i].id.indexOf(toFrom) != -1) {
    	            var line = document.getElementById(lines[i].id);
    	            lineSQL[line.id] = "delete from line where lineID='"+line.getAttribute("id")+"'";
    	            removedLine = line.id;
    	            line.remove();
    	            break;
    	          }
    	        }

    	        findingParent = 1;
    	  }
      }
      
      // 업로드 다운로드 팝업 띄우기
      // open up/download popup window
      function upload_download_window() {
         var up_down_name = fromID;
         var opwin = window.open('upload_map.jsp?itemID='+fromID+"&mapID="+mapID,up_down_name, 
               'width=400,height=450,left=300px,top=100px,status=no,scrollbars=yes');
      }
      
      /*
      keyup event explain
      if item or grades is selected
        if key-up 'a'~'z', 'A'~'Z'
          if item hasn't content
            user can modify item content + add content
            user can finish modifying with button
          else item has content
            get item content
            user can modify item content
            user can finish modifying with button
      */ 
      window.addEventListener("keyup", e => {
    	  if(isMyMap) {
    		  // if item or grades is selected
    		  if(fromID != "grade1" && fromID != "grade2" && fromID != "grade3" && fromID != "grade4") {
    			 // if key-up 'a'~'z', 'A'~'Z'
     	         if(48 <= e.keyCode && e.keyCode <= 57
         	            || 65 <= e.keyCode && e.keyCode <= 90) {
     	        	 		// if item hasn't content
         	                if(document.getElementById("inputItem") == null) {
         	                    var target = document.getElementById(fromID);
         	                     var inputItem = document.createElement("textarea");
         	                     var text = "";
         	                     
         	                     if(target.innerText == "") {
         	                        text = text + e.key;
         	                     }
         	                     else {
         	                        text = target.innerText + e.key;
         	                        target.innerText = "";
         	                     }
         	                     beforeContent = text.substring(0, text.length-1);
         	                     
         	                     // user can modify item content + add content
         	                     inputItem.setAttribute("type", "text");
         	                     inputItem.style.display = "flex";
         	                     inputItem.style.width = "90%";
         	                     inputItem.style.height = "90%";
         	                     inputItem.setAttribute("id", "inputItem");
         	                     inputItem.setAttribute("name", fromID);
         	                     inputItem.setAttribute("rows", 1);
         	                     inputItem.setAttribute("cols", 10);
         	                     
         	                     target.appendChild(inputItem);
         	                     inputItem.focus();
         	                     inputItem.value = text;
         	                     
         	                     // user can finish modifying with button
         	                     var btn = document.createElement("button");
         	                     btn.setAttribute("id", "inputBtn");
         	                     btn.setAttribute("type", "button");
         	                     btn.style.width = "50px";
         	                     btn.style.height = "30px";
         	                     btn.style.alignSelf = "flex-end";
         	                     btn.style.marginRight = "6px";
         	                     btn.innerText = "확인";
         	                     btn.setAttribute("onclick", "modify()");
         	                     target.appendChild(btn);
         	                }
     	        	 		// else item has content
         	                else {
         	                    if(fromID != document.getElementById("inputItem").getAttribute("name")) {
         	                        modify();
         	                        
         	                        var target = document.getElementById(fromID);
         	                         var inputItem = document.createElement("textarea");
         	                         var text = "";
         	                         
         	                         // get item content
         	                         text = target.innerText + e.key;
         	                         target.innerText = "";
         	                         beforeContent = text.substring(0, text.length-1);
         	                         
         	                         // user can modify item content
         	                         inputItem.setAttribute("type", "text");
         	                         inputItem.style.width = "90%";
         	                         inputItem.style.height = "90%";
         	                         inputItem.style.display = "flex";
         	                         inputItem.setAttribute("id", "inputItem");
         	                         inputItem.setAttribute("name", fromID);
         	                         inputItem.setAttribute("rows", 1);
         	                         inputItem.setAttribute("cols", 10);
         	                         
         	                         target.appendChild(inputItem);
         	                         inputItem.focus();
         	                         inputItem.value = text;
         	                         
         	                         // user can finish modifying with button
         	                         var btn = document.createElement("button");
         	                         btn.setAttribute("id", "inputBtn");
         	                         btn.setAttribute("type", "button");
         	                         btn.style.width = "50px";
         	                         btn.style.height = "30px";
         	                         btn.style.alignSelf = "flex-end";
         	                         btn.style.marginRight = "6px";
         	                         btn.innerText = "확인";
         	                         btn.setAttribute("onclick", "modify()");
         	                         target.appendChild(btn);
         	                    }
         	                }
     	         }
    		  }

    	  }
      });
     
      // 실시간 반영이 되긴하는데 for문 낭비가 심함
      // 크기조절 빠르게하고 다른 item으로 넘어가면 안됨
      // if target is item
      // save start width, height
       function mouseDown(e) {
    	  if(isMyMap) {
    	         var item = document.getElementById(e.target.id);
    	         if(e.target.className == "item") {
    	              itemWidth = item.offsetWidth + "px";
    	              itemHeight = item.offsetHeight + "px";
    	              //alert(itemWidth + "   " + itemHeight);
    	              
    	              itemSizeFlag = true;
    	              mouseDownItem = document.getElementById(e.target.id);
    	         }
    	  }
     }
      
      // if before item size and after item size is different
      //   re-draw item's line
      //   update item width, height DB
      function mouseUp(e) { 
    	  if(isMyMap) {
    	         var tmpID = fromID;
    	         var id = e.target.id;
    	         var item = document.getElementById(id);
    	         //var beforeWidth = itemWidth;
    	         //var beforeHeight = itemHeight;
    	         var afterWidth = item.offsetWidth + "px";
    	         var afterHeight = item.offsetHeight + "px";

    	         //var beforeWH = "itemWidth='"+beforeWidth+"', itemHeight='"+beforeHeight+"'";
    	         var afterWH = "itemWidth='"+afterWidth+"', itemHeight='"+afterHeight+"'";
    	         //alert(afterWidth + "   " + afterHeight);
    	         
    	        //saveFlag = true;

    	        // if before item size and after item size is different
    	        if(afterWidth != itemWidth || afterHeight != itemHeight) {
    	            e.preventDefault();
    	            
    	            var lines = document.getElementsByClassName("itemLines");
    	            var toId = "To" + id;
    	            var line;

    	            for (var i=0; i<lines.length; i++) {
    	              if(lines[i].id.indexOf(toId) != -1) {
    	                fromID = lines[i].id.substring(0, lines[i].id.indexOf("To"));
    	                toID = lines[i].id.substring(lines[i].id.indexOf("To")+2, lines[i].id.length);
    	                line = document.getElementById(lines[i].id);
    	                break;
    	              }
    	            }

    	            // re-draw item's line
    	            if(line != null) {
    	                line.remove();
    	                drawLine(fromID, toID);
    	            }
    	            fromID = tmpID;
    	            
        	        itemWidth = item.offsetWidth + "px";
        	        itemHeight = item.offsetHeight + "px";
        	        
        	        // update item width, height DB
        	        sql = "update item set "+afterWH+" where itemID='"+item.id+"' and userID='"+userID+"'";;
        	        itemSql.setAttribute("value", sql);
        	        saveActionForm = $("#saveActionForm").serialize();
        	        $.ajax({
        	           url: "saveItemAction.jsp",
        	           type: "post",
        	           cache: false,
        	           data: saveActionForm,
        	           dataType: "html",
        	           success: function(data) {
        	        	   //console.log("success");
        	              //console.log(data);
        	           },
        	           error: function (request, status, error) {
        	              console.log(error);
        	           }
        	        });
        	        itemSql.setAttribute("value", "");
        	        lineSql.setAttribute("value", "");
    	        }
    	        
    	        itemSizeFlag = false;
    	  }
      }
      
      // limit itemSize
      function svgMouseUp(e) { 
    	  if(itemSizeFlag) {
	          var lines = document.getElementsByClassName("itemLines");
	          var toId = "To" + mouseDownItem.id;
	          var line;
	          var tmpFromID = fromID;

	          for (var i=0; i<lines.length; i++) {
	            if(lines[i].id.indexOf(toId) != -1) {
	              fromID = lines[i].id.substring(0, lines[i].id.indexOf("To"));
	              toID = lines[i].id.substring(lines[i].id.indexOf("To")+2, lines[i].id.length);
	              line = document.getElementById(lines[i].id);
	              break;
	            }
	          }

	          // re-draw item's line
	          if(line != null) {
	              line.remove();
	              drawLine(fromID, toID);
	          }
    		  
    		  mouseDownItem.style.width = "200px";
    		  mouseDownItem.style.height = "200px";
    		  
    		  var afterWH = "itemWidth='200px', itemHeight='200px'";
    	      sql = "update item set "+afterWH+" where itemID='"+mouseDownItem.id+"' and userID='"+userID+"'";;
    	      itemSql.setAttribute("value", sql);
    	      saveActionForm = $("#saveActionForm").serialize();
    	      $.ajax({
    	         url: "saveItemAction.jsp",
    	         type: "post",
    	         cache: false,
    	         data: saveActionForm,
    	         dataType: "html",
    	         success: function(data) {
    	        	 //console.log("success");
    	             //console.log(data);
    	         },
    	         error: function (request, status, error) {
    	            console.log(error);
    	         }
    	      });
    	      itemSql.setAttribute("value", "");
    	      lineSql.setAttribute("value", "");
    	      
        	  // change selected item
        	  console.log("fromID: " + tmpFromID);
              if(tmpFromID == "") {
                  var after = document.getElementById(mouseDownItem.id);
                  after.style.border = "2px solid #93c9eb";
              }
              else if(mouseDownItem.id != tmpFromID) {
                  var before = document.getElementById(tmpFromID);
                  before.style.border = "2px solid #828282";

                  var after = document.getElementById(mouseDownItem.id);
                  after.style.border = "2px solid #93c9eb";
              }
              
              fromID = mouseDownItem.id;
              lastItemX = getX(mouseDownItem.id);
              lastItemY = getY(mouseDownItem.id);
              lastItemW = getW(mouseDownItem.id);
              lastItemH = getH(mouseDownItem.id);
              
    	  }
      }
      
      /*
      function contextmenu explain
      on item or grades right click event change selected item
      prevent page overflow
      show different contextmenu by item, grades
      Hide contextmenu
      */
      // on item right click event change selected item
      function contextmenu(e) {
    	  e.preventDefault(); // 원래 있던 오른쪽 마우스 이벤트를 무효화한다.
    	  
          var afterID = "";
          if(fromID == "") {
              var after = document.getElementById(e.target.id);
              after.style.border = "2px solid #93c9eb";
          }
          else if(e.target.id != fromID) {
              var before = document.getElementById(fromID);
              before.style.border = "2px solid #828282";

              var after = document.getElementById(e.target.id);
              after.style.border = "2px solid #93c9eb";
              
              afterID = e.target.id;
          }
           
          afterID = e.target.id;
          fromID = afterID;
          lastItemX = getX(e.target.id);
          lastItemY = getY(e.target.id);
          lastItemW = getW(e.target.id);
          lastItemH = getH(e.target.id);
    	  
	   	  //Get window size:
	   	  var winWidth = $(document).width();
	   	  var winHeight = $(document).height();
	   	  //Get pointer position:
	   	  var posX = e.pageX;
	   	  var posY = e.pageY;
	   	  //Get contextmenu size:
	      var menuWidth;
	      var menuHeight;
	      
	      if(e.target.className == "grades") {
	    	  menuWidth = $("#gradesContext").width();
	    	  menuHeight = $("#gradesContext").height();
	      }
	      else {
	    	  menuWidth = $(".contextmenu").width();
	    	  menuHeight = $(".contextmenu").height();
	      }
	   	  //Security margin:
	   	  var secMargin = 10;
	   	  //Prevent page overflow:
	   	  if(posX + menuWidth + secMargin >= winWidth
	   	  && posY + menuHeight + secMargin >= winHeight){
	   	    //Case 1: right-bottom overflow:
	   	    posLeft = posX - menuWidth - secMargin + "px";
	   	    posTop = posY - menuHeight - secMargin + "px";
	   	  }
	   	  else if(posX + menuWidth + secMargin >= winWidth){
	   	    //Case 2: right overflow:
	   	    posLeft = posX - menuWidth - secMargin + "px";
	   	    posTop = posY + secMargin + "px";
	   	  }
	   	  else if(posY + menuHeight + secMargin >= winHeight){
	   	    //Case 3: bottom overflow:
	   	    posLeft = posX + secMargin + "px";
	   	    posTop = posY - menuHeight - secMargin + "px";
	      }
	      else {
	        //Case 4: default values:
	   	    posLeft = posX + secMargin + "px";
	   	    posTop = posY + secMargin + "px";
	   	  };
	   	  
	   	  // show different contextmenu by item, grades
	      if(e.target.className == "grades") {
		   	  $("#gradesContext").css({
			   	 "left": posLeft,
			   	 "top": posTop
			  }).show();
		   	  $(".contextmenu").hide();
	      }
	      else {
		   	  $(".contextmenu").css({
		   		 "left": posLeft,
			   	 "top": posTop
			  }).show();
		   	  $("#gradesContext").hide();
	      }

      }
   	  //Hide contextmenu:
	  $(document).click(function(){
    	  $(".contextmenu").hide();
    	  $("#gradesContext").hide();
      });
      
      // position and show all hidden lines
      function drawAllLines() {
          var lines = document.getElementsByClassName("itemLines");
          var lineIDs = [];
          var from;
          var to;
           for (var i=0; i<lines.length; i++) {   
        	   lineIDs.push(lines[i].id);
               //console.log("from,to: " + from + ", " + to);
               //console.log("line.id: " + line.id);
           }
           for(var i=0; i<lineIDs.length; i++) {
        	   //console.log("length: " + lineIDs.length);
        	   //console.log(lineIDs[i]);
        	   
        	   line = document.getElementById(lineIDs[i]);
        	   line.remove();
        	   
        	   from = lineIDs[i].substring(0, lineIDs[i].indexOf("To"));
        	   to = lineIDs[i].substring(lineIDs[i].indexOf("To")+2, lineIDs[i].length);
        	   //console.log(from);
        	   //console.log(to);
        	   drawLine(from, to);
           }
      }
      
      // position all items by each monitor
      function positionItems() {
    	  var top;
    	  var left;
    	  if((mainBox.offsetWidth/2 - 365) < 1843) {
    		  left = 1843 - (mainBox.offsetWidth/2 - 365);
    	  }
    	  else if((mainBox.offsetWidth/2 - 365) > 1843) {
    		  left = (mainBox.offsetWidth/2 - 365) - 1843;
    	  }
    	  else {
    		  left = 0;
    	  }
    	  
    	  if((mainBox.offsetHeight/2 - 205) < 1875) {
    		  top = 1875 - (mainBox.offsetHeight/2 - 205);
    	  }
    	  else if((mainBox.offsetHeight/2 - 205) > 1875) {
    		  top = (mainBox.offsetHeight/2 - 205) - 1875;
    	  }
    	  else {
    		  top = 0;
    	  }
    	  //console.log(top + " " + left);
    	  
          var items = document.getElementsByClassName("item");
           for (var i=0; i<items.length; i++) {
               var item = document.getElementById(items[i].id);
               var itemTop = item.style.top;
               var itemLeft = item.style.left;
               
               var tmpTop = parseFloat(itemTop.substring(0, itemTop.length-2)) - top;
               var tmpLeft = parseFloat(itemLeft.substring(0, itemLeft.length-2)) - left
               //console.log(tmpTop + " " + tmpLeft);
               
               item.style.top = tmpTop + "px";
               item.style.left = tmpLeft + "px";
           }
      }
      
      // check all showing items and grades if they have New APP items
      // if have New APP item show like "1 New!!" text up-side of it
      function checkNewItems() {
    	  var len = itemAppList.length;
    	  //console.log(itemAppList);
    	  for(var i=0; i<len; i++) {
    		  //console.log(itemAppList[i]);
    		  //console.log(itemAppList[i].substring(0, itemAppList[i].indexOf("_")));
    		  var key = itemAppList[i].substring(0, itemAppList[i].indexOf("_"));
    		  if(key in itemAppDict) {
    			  itemAppDict[key] = itemAppDict[key] + 1;
    		  }
    		  else {
    			  itemAppDict[key] = 1;
    		  }
    	  }
    	  //console.log("-----------------dictStart");
    	  //for (var key in itemAppDict) { console.log("key : " + key +", value : " + itemAppDict[key]); }

    	  
          var items = document.getElementsByClassName("item");
          var backID;
          console.log(itemAppDict);
          
	   	   if("grade1" in itemAppDict) {
	   		   const newDiv = document.createElement('div');
	   		   console.log("grade1");
	   		   var grade1 = document.getElementById("grade1")
	           newDiv.setAttribute("class", "new");
	           newDiv.setAttribute("id", "grade1New");
	           newDiv.style.top = parseFloat(grade1.style.top.substring(0, grade1.style.top.length-2)) - 25 + "px";
	           newDiv.style.left = grade1.style.left;
	           newDiv.innerText = itemAppDict["grade1"] + "New!!";
	           
	           mainBox.appendChild(newDiv);
			   delete itemAppDict['grade1'];
		   }
		   if("grade2" in itemAppDict) {
			   const newDiv = document.createElement('div');
			   console.log("grade2");
	   		   var grade2 = document.getElementById("grade2")
	           newDiv.setAttribute("class", "new");
	           newDiv.setAttribute("id", "grade2New");
	           newDiv.style.top = parseFloat(grade2.style.top.substring(0, grade2.style.top.length-2)) - 25 + "px";
	           newDiv.style.left = grade2.style.left;
	           newDiv.innerText = itemAppDict["grade2"] + "New!!";
	           
	           mainBox.appendChild(newDiv);
			   delete itemAppDict['grade2'];
		   }
		   if("grade3" in itemAppDict) {
			   const newDiv = document.createElement('div');
			   console.log("grade3");
	   		   var grade3 = document.getElementById("grade3")
	           newDiv.setAttribute("class", "new");
	           newDiv.setAttribute("id", "grade3New");
	           newDiv.style.top = parseFloat(grade3.style.top.substring(0, grade3.style.top.length-2)) - 25 + "px";
	           newDiv.style.left = grade3.style.left;
	           newDiv.innerText = itemAppDict["grade3"] + "New!!";
	           
	           mainBox.appendChild(newDiv);
			   delete itemAppDict['grade3'];
		   }
		   if("grade4" in itemAppDict) {
			   const newDiv = document.createElement('div');
			   console.log("grade4");
	   		   var grade4 = document.getElementById("grade4")
	           newDiv.setAttribute("class", "new");
	           newDiv.setAttribute("id", "grade4New");
	           newDiv.style.top = parseFloat(grade4.style.top.substring(0, grade4.style.top.length-2)) - 25 + "px";
	           newDiv.style.left = grade4.style.left;
	           newDiv.innerText = itemAppDict["grade4"] + "New!!";
	           
	           mainBox.appendChild(newDiv);
			   delete itemAppDict['grade4'];
		   }
          
           for (var i=0; i<items.length; i++) {
        	   const newDiv = document.createElement('div');
        	   var item = document.getElementById(items[i].id);
        	   backID = item.id.substring(item.id.indexOf("_")+1, item.id.length-1);
  	   
        	   if(backID in itemAppDict) {
    	           newDiv.setAttribute("class", "new");
    	           newDiv.setAttribute("id", item.id+"New");
    	           newDiv.style.top = parseFloat(item.style.top.substring(0, item.style.top.length-2)) - 25 + "px";
    	           newDiv.style.left = item.style.left;
    	           newDiv.innerText = itemAppDict[backID] + "New!!";
    	           
    	           mainBox.appendChild(newDiv);
        		   delete itemAppDict[backID];
        	   }
           }
           //console.log("-----------------dictEnd");
           //for (var key in itemAppDict) { console.log("key : " + key +", value : " + itemAppDict[key]); }
      }
    </script>
  </body>
</html>