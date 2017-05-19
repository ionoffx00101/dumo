<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	//ContextPath 선언
	String cp = request.getContextPath();
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<style type="text/css">
/* 캔버스 위치, 크기 체크용 */
#canvas {
position: absolute;
	border: 1px solid #d3d3d3;;
}
/* 유리판 */
#glassPane {
	position: absolute;
	left: 50px;
	top: 50px;
	padding: 0px 20px 10px 10px;
	background: rgba(0, 0, 0, 0.3);
	border: thin solid rgba(0, 0, 0, 0.6);
	color: # #eeeeee;
	font-family: Droid Sans, Arial, Helvetica, sans-serif;
	font-size: 12px;
	cursor: pointer;
	-webkit-box-shadow: rgba(0, 0, 0, 0.5) 5px 5px 20px;
	-moz-box-shadow: rgba(0, 0, 0, 0.5) 5px 5px 20px;
	box-shadow: rgba(0, 0, 0, 0.5) 5px 5px 20px;
}
</style>

<!-- jQuery -->
<%-- <script type="text/javascript" src="<%=cp%>/resources/bootstrap/js/jquery.js"></script> --%>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script type="text/javascript">
$(function() {
		// 기본 객체
		var canvas = document.getElementById("canvas");
		var ctx = canvas.getContext("2d"); // 캔버스 객체 생성
		var backGroundMusic; // 배경음악 객체 생성
		var canvasPen; // 캔버스에 그림을 그리는 펜
		var keyPressOn = {}; //키 배열, pressed - true
		var spacekey = false; // 스페이스 키
		
		// 플레이 객체
		var playerUnit={}; // 플레이어
		var EnemyHangul={}; // 스테이지1 적객체
		
		
		// 시동 걸기
		function loadGame() {
			// 기본 객체들 채워주기
			canvasBuffer = document.createElement("canvas"); // 캔버스에 펜있다고 넣어주기
			makeBackGroungMusic(); // 배경음악 객체 채워주는 함수 호출
			
			// 플레이 객체들 채워주기
			makePlayerUnit();
			

		
			// 창 자체에 이벤트 리스너를 설정 //document O, canvas X , window O
			document.addEventListener("keydown", getKeyDown, false);
			document.addEventListener("keyup", getKeyUp, false);
			
			
			// 게임 스타트
			loopGame(); // 게임 스타트 함수 호출
		}
		
		// 게임 실행
		function loopGame(){
			
			// 게임을 위해 한번만 실행되는 것
			calcKeyInnput(); // 방향키 입력 // 플레이어 위치값 
			// backGroundMusic.play(); // 배경음악 객체 플레이
			
			
			// 적이 지정된 시간마다 움직임 // setTimeout, setInterval
			setInterval(() => {
				// 값 계산
				renderGame();
			},  1000 / 60);  //60
		
		}
		
		// 지우고 전체 다 다시 그려주는 곳
		function renderGame(){
			ctx.clearRect(0, 0, canvas.width, canvas.height);
			
			// 배경 그리기
			
			// 플레이어 그리기
			
			// 단어장들 그리기
			  var rectangle = new Path2D();
  				  rectangle.rect(100, 100, 50, 50);
			ctx.stroke(rectangle);
			
		}
		
		function makePlayerUnit(){
			playerUnit = {
					x : canvas.width / 2 - 18,
					y : canvas.height / 2 - 18,
					width : 36,
					height : 36
			};
		}
		
		// 키 누름 
		function getKeyDown(event) { 
			var keyValue;
			if (event == null) {
				return;
			} else {
				keyValue = event.keyCode;
				//event.preventDefault(); 키값 들어오면 js에서만 해당 키를 이용함
			}
			if (keyValue == "87")
				keyValue = "287"; //up 38
			else if (keyValue == "83")
				keyValue = "283"; //down 40
			else if (keyValue == "65")
				keyValue = "265"; //left 37
			else if (keyValue == "68")
				keyValue = "268"; //right 39
			keyPressOn[keyValue] = true;
				
			// 점프
			if (keyValue == "32") {
				spacekey = true;
			}
		}
		// 키 뗌 
		function getKeyUp(event) {
			var keyValue;
			if (event == null) {
				keyValue = window.event.keyCode;
				window.event.preventDefault();
			} else {
				keyValue = event.keyCode;
				//event.preventDefault();
			}
			if (keyValue == "87")
				keyValue = "287"; //up 38
			else if (keyValue == "83")
				keyValue = "283"; //down 40
			else if (keyValue == "65")
				keyValue = "265"; //left 37
			else if (keyValue == "68")
				keyValue = "268"; //right 39
			keyPressOn[keyValue] = false;

			// 점프
			if (keyValue == "32") {
				// 점프 꾸욱 누른다고 연점 되는거 아니니까 그냥 up에서 점프 처리하게 바꾸기
				spacekey = false;
			}
		}
		// 방향키 입력 처리
		function calcKeyInnput() {
			if (keyPressOn["287"] && playerUnit.y >= -playerUnit.height / 2)
				console.log("287");
			if (keyPressOn["283"] && playerUnit.y <= canvas.height - playerUnit.height / 2)
				console.log("283");
			if (keyPressOn["265"] && playerUnit.x >= -playerUnit.width / 2)
				console.log("265");
			if (keyPressOn["268"] && playerUnit.x <= canvas.width - playerUnit.width / 2)
				console.log("268");

		}
		
		// 배경음악 객체 채워주기
		function makeBackGroungMusic(){
			backGroundMusic = document.createElement("audio");
			backGroundMusic.volume = 1.0;
			// BackGroundMusic.src = "<c:url value="../resources/sound/war.mp3"/>"; // 안됨
			backGroundMusic.src = "<%=cp%>/resources/sound/war.mp3";
			backGroundMusic.setAttribute('id', 'backGroundMusic');
			document.body.appendChild(backGroundMusic);
		}
		
		loadGame(); // 시작버튼을 누르면 해당 함수가 실행되게 변경
	});
</script>
</head>
<body>

	<canvas id="canvas" width="1000" height="500"></canvas>
	<div id="glassPane">
		<h2 class="title">으응..그래..</h2>
		<a id="startBtn">o.O</a>
	</div>
</body>
</html>