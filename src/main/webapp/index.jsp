<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<% String cp = request.getContextPath(); %> <%--ContextPath 선언 --%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>Ik ben</title>
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
    <!-- Bootstrap Core CSS -->
    <!-- <link href="css/bootstrap.min.css" rel="stylesheet"> -->
	<link href="<%=cp%>/resources/bootstrap/css/bootstrap.min.css" rel="stylesheet">
	
    <!-- Custom CSS -->
    <!--  <link href="css/stylish-portfolio.css" rel="stylesheet"> -->
	<link href="<%=cp%>/resources/bootstrap/css/stylish-portfolio.css" rel="stylesheet">
	<!-- Custom CSS2 -->
	<link href="<%=cp%>/resources/css/custom.css" rel="stylesheet">
	
    <!-- Custom Fonts -->
    <!-- <link href="font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css"> -->
    <link href="<%=cp%>/resources/bootstrap/font-awesome/css/font-awesome.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,700,300italic,400italic,700italic" rel="stylesheet" type="text/css"> 
    <!-- Custom Fonts2 -->
	<!-- <link href="http://fonts.googleapis.com/earlyaccess/jejugothic.css" rel="stylesheet" type="text/css">  -->
	<%-- <link href="<%=cp%>/resources/font/koverwatch.ttf" rel="stylesheet"  type="text/css"> --%>
	
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    
    
    <!-- jQuery -->
	<script type="text/javascript" src="<%=cp%>/resources/bootstrap/js/jquery.js"></script>
	<!-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script> -->
	
    <!-- Bootstrap Core JavaScript -->
	<script type="text/javascript" src="<%=cp%>/resources/bootstrap/js/bootstrap.js"></script>

 <script type="text/javascript">

 var stageTwoEnd = false;
 var stargeThreeEnd =false;

 $(function() {
	 var stageOneEnd = false;
		/* 	
		//크기 조정 친구들
		var windowWidth = $(window).width()*2/3; //document -350
		$("canvas").attr("width", windowWidth).attr("height", 500);
		//$("#startBtn").attr("width", canvas.getWidth()/2).attr("height", canvas.getHeigth()/2);
		 
		// 창 크기 바뀌면 할 것...
	    $( window ).resize(function() {
	    	 windowWidth = $(window).width()*2/3; //document -350
	    	 $("canvas").attr("width", windowWidth).attr("height", 500);
	    }); 
		*/
		
	 	// 캔버스 친구들
		var canvas = document.getElementById("canvas");
		var ctx = canvas.getContext("2d"); // 캔버스 객체 생성
		
		// 플레이 버튼 위치 설정
		//$("#startBtn").css('top',(canvas.width/2)+75+'px');
	/* 	$("#startBtn").css('left',(canvas.height/2)+75+'px');
		console.log((canvas.width/2)+150);
		console.log((canvas.height/2)+150); */
		
		// 배경화면 그려주는 친구들
 		var canvasTemp = document.createElement("canvas");
 		var tempContext = canvasTemp.getContext("2d");
 		var canvasBuffer;
 		var imgWidth = 0;
 		var imgHeight = 0;
 		var imageData = {};
 		var scrollVal = 0;
 		var speed = 1; // 스크롤 속도
 		
 		// 스크롤 이미지 크기
 		var canvasWidth = 2937;//canvas.width;
 		var canvasHeight = 532;//canvas.height;
 		
 		// 스크롤 이미지
 		var scrollImg= new Image();
 				
 		// 기본 객체
 		var backGroundMusic; // 배경음악 객체 생성
 		var canvasPen; // 캔버스에 그림을 그리는 펜
 		var keyPressOn = {}; //키 배열, pressed - true
 		var spacekey = false; // 스페이스 키
 		var oneSpacekey = false; // 스페이스 키 중복 처리 방지용
 		
 		// 플레이어 객체
 		var playerUnit={}; // 플레이어
 		var playerImgWalk1= new Image();
 		var playerImgWalk2= new Image();
 		var playerImgJump= new Image();
 		var playerWalkTime = 0;
 		var playerWalkTimeLimit =20; // 걷는 애니메이션 반복 속도
 		
 		// 스테이지 1 적 객체
 		var EnemyHangul; // 스테이지1 적객체 배열
 		var hangulViewCount=1; // 화면에 보이는 적객체 수 설정
 		var EnemyHangulMax = 10; // 미리 준비해두는 적객체 최대수
 		var hangulWord = {"wordDB":[
 				{"word":"댕댕","wordCheck":false},
 				{"word":"강하다","wordCheck":true},
 				{"word":"마춤뻡","wordCheck":false},
 				{"word":"맞춤법","wordCheck":true},
 				{"word":"낭낭하다","wordCheck":false},
 				{"word":"배고프다","wordCheck":true},
 				{"word":"외않되","wordCheck":false},
 				{"word":"왜 안돼","wordCheck":true},
 				{"word":"껌을 싶다","wordCheck":false},
 				{"word":"안 그레요","wordCheck":false}
 			]};
 		// 단어장 DB에서 가져온 값을 여기다가 넣어야함니까  그럴꺼면 이 페이지로 이동 시킬때 모델안에 단어장DB가 JSON배열로 들어가있어야겠구뇽
 		// 힘내 미래의 나
 		// var hangulWord = "${wordDB}"; // 단어랑 단어 정답여부 두개 가져와야함
 		
 		var stageOneInterval; // 타이머 변수용
 		var scoreOne = 0; // 스코어 체크
 		
 		// 시동 걸기
 		function loadGame() {
 			// 기본 객체들 채워주기
 			canvasBuffer = document.createElement("canvas"); // 캔버스에 펜있다고 넣어주기
 			
 			// 백그라운드 이미지
 			scrollImg.src = "<%=cp%>/resources/images/city.png";
 			scrollImg.onload = loadImage; // 스크롤 이미지 불러오기 완료되야 loadimage를 호출한다
 			
 			// 배경음악 객체 채워주는 함수 호출
 			makeBackGroungMusic(); 

 			// 플레이어 객체들 채워주기
 			makePlayerUnit();
 			// 플레이어 이미지 추가
 			playerImgWalk1.src = "<%=cp%>/resources/images/charactor/female_walk1_re.png";
 			playerImgWalk2.src = "<%=cp%>/resources/images/charactor/female_walk2_re.png";
 			playerImgJump.src = "<%=cp%>/resources/images/charactor/female_jump_re.png";
 			
 			// 한글 적 객체 채우기
 			EnemyHangul= new Array();
 			createEnemyHangul(EnemyHangulMax); // 최대값 만큼 객체 생성 / 최대값은 DB에 있는 단어만큼 생성하는게 어떨까 / 그리고 서버가 터졌다 
 		
 			// 창 자체에 이벤트 리스너를 설정 //document O, canvas X , window O
 			document.addEventListener("keydown", getKeyDown, false);
 			document.addEventListener("keyup", getKeyUp, false);
 			
 			// 게임 스타트
 			startGame();
 		}
 		
 		// 게임 실행
 		function startGame(){
 			
 			// 캐릭터 짬프는 키보드 입력 받는 곳에서 해결됨
 			// 캐릭터 짬프 애니메이션 - 3씩 올라갔다가 3씩 내려옴
 			// 점프 애니메이션이 실행되는 동안에는 점프 키 입력을 받아도 모른척 해야함
 			// 라잌 쿠키런
 						
 			// 적이 지정된 시간마다 움직임
 			stageOneInterval = setInterval(() => {
 				// 배경화면 스크롤 함수
 				// 스크롤 한바퀴 다돌아 간경우 스크롤을 초기화한다
 				if (scrollVal <= speed) { //1 5 0 2가 0오류 안남
 					scrollVal = canvasWidth - speed;
 				}
 				
 				// 지정된 속도를 기준으로 스크롤의 값이 늘어난다(그리는 위치가 변경된다)
 				scrollVal -= speed;
 				
 				// 단어 움직임 로직
 				useEnemyHangul();
 				
 				// 적객체와 플레이어 충돌 처리 // 됨 범위 좁힌 버전
				for(var i=0;i<EnemyHangul.length;i++){ // 적객 체 돌려
 					
 					var oneHangul = EnemyHangul[i];
 				
 					//일단 쓰는 한글인지 조사
 				 	if(oneHangul.use){
 				 		//  Y 거리 확인 > X충돌값 확인  > 처리
 				 		var bamX = oneHangul.x - playerUnit.x;
 				 		
 				 		if(bamX<=playerUnit.width && (playerUnit.width-bamX<playerUnit.width || playerUnit.width-bamX<playerUnit.width+5)){
 				 			
 				 			if(oneHangul.y-playerUnit.y==70){//아래
 				 				// 적 객체 체크가 true면 +1 false면 -1
 	 				 			if(oneHangul.wordCheck){
 	 				 				scoreOne++;	
 	 				 			}
 				 				EnemyHangul[i].use=false;
 				 			
 		 				 	}else if (oneHangul.y-playerUnit.y==92){ // 위
 		 				 		// 적 객체 체크가 true면 +1 false면 -1
 	 				 			if(oneHangul.wordCheck){
 	 				 				scoreOne++;	
 	 				 			}
 		 				 		EnemyHangul[i].use=false;
 							}	
				 		}
 					}
 				}
 				// 그리기
 				renderGame();
 				
 				// 게임 끝나는 지 여부 확인 하고 엔딩 화면 그려줌..?
 				if(scoreOne>=5){
 					stageOneEnd=true;
 					clearInterval(stageOneInterval);
 					clearGame();
 				}
 			},  1000 / 60);  //60
 		}
 		
 		// 지우고 전체 다 다시 그려주는 곳
 		function renderGame(){
 			// 지우기
 			ctx.clearRect(0, 0, canvas.width, canvas.height);
 			
 			// 배경 그리기
 			imageData = tempContext.getImageData(canvasWidth - scrollVal,0, canvasWidth, canvasHeight);
 			ctx.putImageData(imageData, 0, 0, 0, 0, canvasWidth, imgHeight);

 			// 배경 스크롤을 그려주는 부분
 			imageData = tempContext.getImageData(0, 0, canvasWidth - scrollVal, canvasHeight);
 			ctx.putImageData(imageData, scrollVal,0 , 0, 0, imgWidth, canvasHeight);
 			
 			// ctx.fillText(scoreOne+"",playerUnit.x,playerUnit.y); // x, y 점수 체크용
 			
 			// 플레이어 그리기
 			if(!spacekey){ //playerUnit.jump
 				if(playerUnit.walk){
 					ctx.drawImage(playerImgWalk1,playerUnit.x,playerUnit.y);
 					
 					playerWalkTime++;
 					if(playerWalkTime>playerWalkTimeLimit){
 						playerUnit.walk=false;
 						playerWalkTime=0;
 					}
 				}
 				else{
 					ctx.drawImage(playerImgWalk2,playerUnit.x,playerUnit.y);
 					
 					playerWalkTime++;
 					if(playerWalkTime>playerWalkTimeLimit){
 						playerUnit.walk=true;
 						playerWalkTime=0;
 					}
 				}
 			}
 			else{
 				ctx.drawImage(playerImgJump,playerUnit.x,playerUnit.y);
 			}
 			
 			// 단어 그림
 			for(var i=0;i<EnemyHangul.length;i++){ // 적객 체 돌려
 				
 				var oneHangul = EnemyHangul[i];
 				
 			 	 if(oneHangul.use){
 					ctx.font="30px Noto Sans KR";
 					ctx.fillStyle = 'white';
 					ctx.fillText(oneHangul.word,oneHangul.x,oneHangul.y); // x, y
 						
 					if(oneHangul.x<-10){ //0
 						oneHangul.use= false;
 					}
 				}
 			}		
 		}
 		// 게임 끝났을 때 화면
 		function clearGame(){
 		// 지우기
 			ctx.clearRect(0, 0, canvas.width, canvas.height);
 		
 			ctx.font="50px Georgia";
				ctx.fillStyle = 'black';
				ctx.fillText("끝",500,250); // x, y
 		
 		}
 		
 	
 		// 배경 이미지 로딩
 		function loadImage() {
 			/* 사용된 이미지의 폭과 너비를 저장하고 그림용 펜의 역할을 수행하는 캔버스 템프에도 담아둔다  */
 			imgWidth =  scrollImg.width || scrollImg.naturalWidth;//scrollImg.width;
 			imgHeight = scrollImg.height || scrollImg.naturalHeight;//scrollImg.height;
 			canvasTemp.width = imgWidth;
 			canvasTemp.height = imgHeight;

 			/* 그림을 그리고 현재 그림의 테이터를 담아둔다 */
 			tempContext.drawImage(scrollImg, 0, 0, imgWidth, imgHeight);
 			imageData = tempContext.getImageData(0, 0, imgWidth, imgHeight);

 			/* 캔버스 버퍼 객체에 펜을 담는다 */
 			canvasBuffer = document.createElement("canvas");
 		}
 		
 		// 플레이어 객체 만드는 곳
 		function makePlayerUnit(){
 			
 			var imgWalkWidth = 80;
 			var imgWalkHeight = 92;
 			
 			playerUnit = {
 					x : 150,
 					y : 350,
 					width : imgWalkWidth,
 					height : imgWalkHeight,
 					walk:true
 			};
 		}

 		// 한글 객체를 만드는 곳
 		function createEnemyHangul(wordcount){
 			for (var i = 0; i < wordcount; i++) {
 				var enemy = {
 					x : 1000,
 					y : 600,
 					width:0,
 					height:0,
 					word:"",//Math.floor(Math.random() * 10);// 랜덤수 // 그냥 123 할까
 					wordCheck:false, // 단어의 정답 여부
 					use :false //1 캔버스에 그려주는 지 스킵하는지 용도
 				};
 				EnemyHangul.push(enemy);
 			}
 		}
 		// 한글 객체를 쓰는 곳
 		function useEnemyHangul() {
 			
 			// DB에서 가져온 배열중 
 			// 한개를 뽑아서 밑에 집어넣는다
 			//hangulWord
 			
 			var useCount = 0;
 			// 화면에 보이는 단어 3개로 조정하기 위해서
 			for(var i=0; i<EnemyHangul.length;i++){
 				if(EnemyHangul[i].use){
 					useCount++;
 					// true인 친구들은 왼쪽으로 보냄
 					EnemyHangul[i].x=EnemyHangul[i].x-3;
 				}
 			}
 			// 화면에 보이는 게 hangulViewCount이하면 한개 내보냄
 			if(useCount<hangulViewCount){
 				// 랜덤 Y값 준비
 				var startY=((Math.random() <= 0.5) ? 350 : 420);//)*150;
 				// X값 초기화, Y값이랑 word값, use 값을 고쳐야함
 				
 				var bool = true;
 				while(bool){
 					var randomNum = Math.floor((Math.random() * 10));
 					console.log();
 					
 					if(!EnemyHangul[randomNum].use){
 						bool=false; // 반복문 내보냄
 						
 						EnemyHangul[randomNum].x=1000; // x바꿈
 						EnemyHangul[randomNum].y=startY; // Y바꿈
 						EnemyHangul[randomNum].word = hangulWord.wordDB[randomNum].word;
 						EnemyHangul[randomNum].wordCheck = hangulWord.wordDB[randomNum].wordCheck;
 						EnemyHangul[randomNum].use=true;
 					}
 				}
 				
 			}
 		}

 		// 키 누름 
 		function getKeyDown(event) { 
 			var keyValue;
 			if (event == null) {
 				return;
 			} else {
 				keyValue = event.keyCode;
 				
 				if (keyValue == "123" || keyValue == "116"){} // f12 ,f5
 				else{
 					event.preventDefault(); //키값 들어오면 js에서만 해당 키를 이용함
 				}
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
 	 			calcKeyInnput(); // 방향키 입력 // 플레이어 위치값 
 			}
 			//calcKeyInnput(); // 방향키 입력 // 플레이어 위치값 // 여기 두니까 스페이스 말고도 처리함
 		}
 		// 키 뗌 
 		function getKeyUp(event) {
 			var keyValue;
 			if (event == null) {
 				keyValue = window.event.keyCode;
 				window.event.preventDefault();
 			} else {
 				keyValue = event.keyCode;
 				
 				if (keyValue == "123" || keyValue == "116"){} // f12 ,f5
 				else{
 					event.preventDefault(); //키값 들어오면 js에서만 해당 키를 이용함
 				}
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
 				calcKeyInnput(); // 방향키 입력 // 플레이어 위치값 
 			}
 			//calcKeyInnput(); // 방향키 입력 // 플레이어 위치값 // 여기 두니까 스페이스 말고도 처리함
 		}
 		// 방향키 입력 처리
 		function calcKeyInnput() {
 
 			if(spacekey){
 				if(!oneSpacekey){
 				playerUnit.y-=92;
 				oneSpacekey=true;
 				}
 			}else{
 				playerUnit.y+=92;
 				oneSpacekey=false;
 			}
 			// 게임 상태가 아닐때만 그림 다시 그리기
 			if(!stageOneEnd){
 				renderGame();
 			}
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
 		
 		// 스타트 버튼 클릭 시 
 		$('#startBtn').click(function(){
             $("#startBtn").hide();
             /*$('#startBtn').remove(); // 스타트 버튼을 화면에서 없애기 */
 			
 			/* $('#startBtn').css("display", "none"); */
 			
            $("#canvas").show();
 			
 			loadGame(); // 시작버튼을 누르면 해당 함수가 실행되게 변경
 		});
 	});
</script>
</head>
<body>
    <!-- Navigation -->
    <a id="menu-toggle" href="#" class="btn btn-dark btn-lg toggle"><i class="fa fa-bars"></i></a>
    <nav id="sidebar-wrapper">
        <ul class="sidebar-nav">
            <a class="menu-close" href="#" class="btn btn-light btn-lg pull-right toggle"><i class="fa fa-times"></i></a>
            <li class="sidebar-brand">
                <a href="#top" class="menu-close">Ik ben</a>
            </li>
            <li>
                <a href="#game" class="menu-close">Game</a>
            </li>
            <li>
                <a href="#word" class="menu-close">Word</a>
            </li>
            <li>
                <a href="#about" class="menu-close">about</a>
            </li>
             <li>
                <a href="#callout" class="menu-close">picture</a>
            </li>
            <li>
                <a href="#git" class="menu-close">git,blog</a>
            </li>
        </ul>
    </nav>

    <!-- Header -->
    <header id="top" class="header">
         <div class="container">
            <div class="row">
                <div class="col-lg-12 text-center" id="title">
                    <h1>Ik ben</h1>
                 </div>  
                   
            </div>
            <!-- /.row -->
        </div>
        <!-- /.container -->
    </header>

	<!-- game -->
	<section id="game" class="game">
	<div class="container">
		<div class="row">
			<div class="col-md-offset-1">
				<!-- col-lg-12 glasspane -->
				<canvas id="canvas" width="1000" height="500" style="display: none;"></canvas> <!-- style="display: none;" -->
				<!-- display: block; none -->
				<div class="row">
					<div class="col-md-12">
					</div><div class="col-md-12">
					</div>
					<div class="col-md-offset-5" id="playbutton">
						<!--  col-lg-12  glasspane -->
						<img id="startBtn" src="<%=cp%>/resources/images/play-button.png"
							alt="PlayButton"
							style="width: 150px; height: 150px; display: block;">
						<!-- align="middle"  -->
					</div>
				</div>
			</div>
		</div>
		<!-- /.row -->
	</div>
	<!-- /.container --> </section>

	<!-- word-->
	<section id="word" class="word">
	<div class="container">
		<div class="row">
			<div class="col-md-12 text-center">
				<h2>단어 추가</h2>
				<hr class="small">
				<form action="">
					<div class="col-md-4 col-md-offset-1">
						<input type="text" class="form-control" />
					</div>
					<div class="col-md-4" >
						<select class="form-control">
							<option value="true">올바른 맞춤법</option>
							<option value="false">잘못된 맞춤법</option>
						</select>
					</div>
					<div class="col-md-2">
					<button type="submit" class="btn btn-primary" style="float:left;">추가</button>
					</div>
				</form>
			</div>
		</div>
		<!-- /.row -->
	</div>
	<!-- /.container --> </section>

	<!-- / Services -->
    <!-- The circle icons use Font Awesome's stacked icon classes. For more information, visit http://fontawesome.io/examples/ -->
    <section id="about" class="about bg-primary">
        <div class="container">
            <div class="row text-center">
                <div class="col-lg-10 col-lg-offset-1">
                    <h2>캐릭터 정보</h2>
                    <hr class="small">
                    <div class="row">
                    
                        <div class="col-md-4">
                            <div class="service-item">
                                <span class="fa-stack fa-4x">
                                <i class="fa fa-circle fa-stack-2x"></i>
                                <i class="fa fa-user fa-stack-1x text-primary"></i>
                            </span>
                                <h4>
                                    <strong>상세 정보</strong>
                                </h4>
                                <p>이력서에 쓰던 자기소개 짧게 <br>
                                		구글링을 잘해요!</p>
                            </div>
                        </div>
                        
                        <div class="col-md-4">
                            <div class="service-item">
                                <span class="fa-stack fa-4x">
                                <i class="fa fa-circle fa-stack-2x"></i>
                                <i class="fa fa-bookmark fa-stack-1x text-primary"></i>
                            </span>
                                <h4>
                                    <strong>선호 하는 것</strong>
                                </h4>
                                <p>전시회 가기</p>
                            </div>
                        </div>
                          <div class="col-md-4">
                            <div class="service-item">
                                <span class="fa-stack fa-4x">
                                <i class="fa fa-circle fa-stack-2x"></i>
                                <i class="fa fa-code fa-stack-1x text-primary"></i>
                            </span>
                                <h4>
                                    <strong>수상 경력</strong>
                                </h4>
                                <p>써도 될까</p>
                            </div>
                        </div>
                        
        <!--                 <div class="col-md-3 col-sm-6">
                            <div class="service-item">
                                <span class="fa-stack fa-4x">
                                <i class="fa fa-circle fa-stack-2x"></i>
                                <i class="fa fa-flask fa-stack-1x text-primary"></i>
                            </span>
                                <h4>
                                    <strong>Service Name</strong>
                                </h4>
                                <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit.</p>
                            </div>
                        </div> -->
                    </div>
                    <!-- /.row (nested) -->
                </div>
                <!-- /.col-lg-10 -->
            </div>
            <!-- /.row -->
        </div>
        <!-- /.container -->
    </section>

    <!-- Callout -->
    <aside class="callout" id="callout">
        <div class="text-vertical-center">
            <h1></h1>
        </div>
    </aside>

    <!-- Portfolio -->
    <section id="git" class="git">
        <div class="container">
            <div class="row">
                <div class="col-lg-10 col-lg-offset-1 text-center">
                    <h2>코딩 일지</h2>
                    <hr class="small">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="portfolio-item">
                                <a href="https://github.com/tehon"  target="_blank">
                                   <img class="img-portfolio img-responsive" src="<%=cp%>/resources/images/GitHub.png" style="width: 100px; height: 100px;">
                                </a>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="portfolio-item">
                                <a href="http://teqoo.tistory.com/"  target="_blank">
                                    <img class="img-portfolio img-responsive" src="<%=cp%>/resources/images/Tistory.png" style="width: 100px; height: 100px;">
                                </a>
                            </div>
                        </div>
                    </div>
                    <!-- /.row (nested) -->
                </div>
                <!-- /.col-lg-10 -->
            </div>
            <!-- /.row -->
        </div>
        <!-- /.container -->
    </section>

    <!-- Call to Action -->
    <aside class="call-to-action bg-primary">
        <div class="container">
            <div class="row">
                <div class="col-lg-10 col-lg-offset-1 text-center">
                    <h2>스킬</h2>
                    <hr class="small">
                    <div class="row">
                        <div class="col-md-6">
                            <h3>사용할 줄 아는 스킬</h3>
                            <br/>
                            <p>Java</p>
                        </div>
                        <div class="col-md-6">
                            <h3>배우고 싶은 스킬</h3>
                            <p>
                            	Python <br/>
                            	Node.js<br/>
                         	</p>
                        </div>
                    </div>
                    <!-- /.row (nested) -->
                </div>
                <!-- /.col-lg-10 -->
            </div>
        </div>
    </aside>

    <!-- Footer -->
   <!--  <footer>
        <div class="container">
            <div class="row">
                <div class="col-lg-10 col-lg-offset-1 text-center">
                </div>
            </div>
        </div>
        <a id="to-top" href="#top" class="btn btn-dark btn-lg"><i class="fa fa-chevron-up fa-fw fa-1x"></i></a>
    </footer> -->

 <!-- Custom Theme JavaScript -->
    <script>
    // Closes the sidebar menu
    $(".menu-close").click(function(e) {
        e.preventDefault();
        $("#sidebar-wrapper").toggleClass("active");
    });
    // Opens the sidebar menu
    $("#menu-toggle").click(function(e) {
        e.preventDefault();
        $("#sidebar-wrapper").toggleClass("active");
    });
    // Scrolls to the selected menu item on the page
    $(function() {
        $('a[href*=#]:not([href=#],[data-toggle],[data-target],[data-slide])').click(function() {
            if (location.pathname.replace(/^\//, '') == this.pathname.replace(/^\//, '') || location.hostname == this.hostname) {
                var target = $(this.hash);
                target = target.length ? target : $('[name=' + this.hash.slice(1) + ']');
                if (target.length) {
                    $('html,body').animate({
                        scrollTop: target.offset().top
                    }, 1000);
                    return false;
                }
            }
        });
    });
    //#to-top button appears after scrolling
    var fixed = false;
    $(document).scroll(function() {
        if ($(this).scrollTop() > 250) {
            if (!fixed) {
                fixed = true;
                // $('#to-top').css({position:'fixed', display:'block'});
                $('#to-top').show("slow", function() {
                    $('#to-top').css({
                        position: 'fixed',
                        display: 'block'
                    });
                });
            }
        } else {
            if (fixed) {
                fixed = false;
                $('#to-top').hide("slow", function() {
                    $('#to-top').css({
                        display: 'none'
                    });
                });
            }
        }
    });
    </script>
</body>
</html>