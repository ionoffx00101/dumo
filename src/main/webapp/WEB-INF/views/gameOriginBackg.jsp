<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Websocket Client</title>
<style type="text/css">
canvas {
	border: 1px solid #555555;
}
#gamebackground {
	width:1200px;
	height:850px;
	margin:100px 0 0 350px;
}
body {
	background:url(../resources/img/spacebackground1.jpg);
	background-size:cover;  
	width:100%;
	height:100%;
}
#myPageScore {
	width:150px;
	height:15%;
	color:white;
	font-weight:bold;
	text-align:center;
	border:1px solid white;
}
#yourPageScore {
	width:500px;
	height:50px;
	color:white;
	font-weight:bold;
	text-align:center;
}
#canvas {
	border:5px solid;
}
#canvas2 {
	border:5px solid;
}
</style>
<script type="text/javascript" src="http://code.jquery.com/jquery-2.1.4.min.js"></script>
<script type="text/javascript">

	var nick = "${nick}";
	var rnum = "${rnum}";
	var gnum = "${gnum}";
	//추가된곳
	var victory = true;
	
	var twopexplosion=false;
	
	var realGameEnd = false;
	
	var endcheck = false;
	$(function() {
		var vid = document.getElementById("audio");
		vid.volume = 0.2;
		
		//글씨
		
		var database = new Array();
		var data = new Array();
		var datacnt = 0;
		var datastop = false;
	
		var ws = new WebSocket("ws://192.168.8.17:8888/SGP/game?position=game&nick=" + nick + "&gnum=" + gnum + "&rnum=" + rnum);
		ws.onopen = function() {

		};
		ws.onmessage = function(event) {
			var ob = eval("(" + event.data + ")");
			if (ob.cmd == "start") {
				scrollImg.src = "<c:url value="../resources/img/backGround2.jpg"/>";
				scrollImg.onload = loadImage;
				/*  배경 이미지 로드 선언 스크롤링 변수는 위쪽 변수 선언때 캔버스 템프 안에 들어가 있다 */
				scrollImg2.src = "<c:url value="../resources/img/backGround2.jpg"/>";
				scrollImg2.onload = loadImage2;
			}
			if (ob.cmd == 'end') {
				if (!endcheck) {
					endcheck = true;
					realGameEnd = true;
					// score, victory
					if (victory) {
						//1p
						ctx.font = 'bold 55px Verdana';
						ctx.fillStyle = '#ffffff';
						ctx.fillText('Win!', 180, 350);			
					} else if (!victory) {
						//1p
						ctx.font = 'bold 55px Verdana';
						ctx.fillStyle = '#ffffff';
						ctx.fillText('lose..', 170, 350);
					}
					
					// 게임 결과 처리
					$.ajax({
						url : "gameResult",
						type : "post",
						dataType : "json",
						data : {score:score, victory:victory, nick:nick},
						success : function(result) {
							if(result.ok) {
								setTimeout(function() {
									location.href = "roomIn?rnum=" + rnum;
								}, 3000);
							}
						},
						error : function(err) {
							bootbox.alert("에러", function(){
								setTimeout(function() {
									location.href = "roomIn?rnum=" + rnum;
								}, 3000);
							});
						}
					});  
				}
			}
		};
		ws.onclose = function(event) {
		};

		$('#end').click(function() {
			var msg = {
				position : "game",
				cmd : "end",
				gnum : gnum
			};
			ws.send(JSON.stringify(msg));

		});

		function loadImage2() {
			/* 사용된 이미지의 폭과 너비를 저장하고 그림용 펜의 역할을 수행하는 캔버스 템프에도 담아둔다  */
			imgWidth2 = scrollImg2.width, imgHeight2 = scrollImg2.height;
			canvasTemp2.width = imgWidth2;
			canvasTemp2.height = imgHeight2;

			/* 그림을 그리고 현재 그림의 테이터를 담아둔다 */
			tempContext2.drawImage(scrollImg2, 0, 0, imgWidth2, imgHeight2);
			imageData2 = tempContext2.getImageData(0, 0, imgWidth2, imgHeight2);

			/* 캔버스 버퍼 객체에 펜을 담는다 */
			canvasBuffer2 = document.createElement("canvas");

		}

		function remoteTwoplayer() {
			if(!endcheck){
			var gameEnd2 = data.gameend;
			if (gameEnd2) {
				var explosion2 = data.explosion;
				if(!twopexplosion){
				playerExplosionsound();
				twopexplosion=true;
				}
			} else {
				var Player2 = data.remotePlayer;
			}

			var enemyBalls2 = data.remoteenemyBalls;
			var playerBullet2 = data.remoteplayerBullet;
			var item2 = data.remoteitem;
			var laser2 = data.remotelaser;

			ctx2.clearRect(0, 0, canvasWidth2, canvasHeight2);
			/*  캔버스를 한번 지운다 */

			if (scrollVal2 >= canvasHeight2 - speed2) {
				scrollVal2 = 0;
			}
			/* 혹시 스크롤 한바퀴 다돌아 간경우 스크롤을 초기화한다 */

			scrollVal2 += speed2;
			/* 지정된 속도를 기준으로 스크롤의 값이 늘어난다(그리는 위치가 변경된다) */

			imageData2 = tempContext2.getImageData(0, canvasHeight2 - scrollVal2, canvasWidth2, canvasHeight2);
			ctx2.putImageData(imageData2, 0, 0, 0, 0, canvasWidth2, imgHeight2);

			/* 배경 스크롤을 그려주는 부분 */
			imageData2 = tempContext2.getImageData(0, 0, canvasWidth2, canvasHeight2 - scrollVal2);
			ctx2.putImageData(imageData2, 0, scrollVal2, 0, 0, canvasWidth2, imgHeight2);

			/* 아군 탄환 그리기   */
			for (var i = 0; i < playerBullet2.length; i++) {
				if (playerBullet2[i].use) {
					ctx2.drawImage(playerBulletimg2, //Source Image
					0, 0, //X, Y Position on spaceShipSprit
					9, 54, //Cut Size from spaceShipSprit
					playerBullet2[i].x, playerBullet2[i].y, //View Position
					8, 20 //View Size
					);
					ctx2.drawImage(canvasBuffer2, 0, 0);
				}
			}
			if (!gameEnd2) {
				/* 플레이어 기체를 그려준다 */
				ctx2.drawImage(spaceShipSprit2, //Source Image
				405, 180, 36, 36, //고정시켜버림
				Player2.x, Player2.y, //View Position
				36, 36 //고정시켜버림
				);
				ctx2.drawImage(canvasBuffer2, 0, 0);
			}

			for (var i = 0; i < enemyBalls2.length; i++) {
				ctx2.drawImage(enemyimg2, //Source Image
						0, 0, //X, Y Position on spaceShipSprit
						36, 36, //Cut Size from spaceShipSprit
						enemyBalls2[i].x,enemyBalls2[i].y, //View Position
						26, 26 //View Size
						);
			}
			/* 아이템을 그려준다   */
			for (var i = 0; i < item2.length; i++) {
				
				switch (i) {
				case 0:
					ctx2.drawImage(itemImg_02, //Source Image
							0, 0, //X, Y Position on spaceShipSprit
							88, 80, //Cut Size from spaceShipSprit
							item2[i].x,item2[i].y, //View Position
							26, 24 //View Size
					);
					break;
				case 1:
					ctx2.drawImage(itemImg_12, //Source Image
							0, 0, //X, Y Position on spaceShipSprit
							88, 80, //Cut Size from spaceShipSprit
							item2[i].x,item2[i].y, //View Position
							26, 24 //View Size
					);
					break;
				case 2:
					ctx2.drawImage(itemImg_22, //Source Image
							0, 0, //X, Y Position on spaceShipSprit
							88, 80, //Cut Size from spaceShipSprit
							item2[i].x,item2[i].y, //View Position
							26, 24 //View Size
					);
					break;
				case 3:
					ctx2.drawImage(itemImg_32, //Source Image
							0, 0, //X, Y Position on spaceShipSprit
							88, 80, //Cut Size from spaceShipSprit
							item2[i].x,item2[i].y, //View Position
							26, 24 //View Size
					);
					break;
				case 4:
					ctx2.drawImage(itemImg_42, //Source Image
							0, 0, //X, Y Position on spaceShipSprit
							88, 80, //Cut Size from spaceShipSprit
							item2[i].x,item2[i].y, //View Position
							26, 24 //View Size
					);
					break;
				default:
					ctx2.fillStyle = '#ffffff';
					ctx2.fillRect(item2[i].x, item2[i].y, 30, 30);
					break;
				}
			}

			/* 탄환 충돌 이펙트를 그린다 */
			for (var i = 0; i < laser2.length; i++) {
				if (laser2[i].use) {
					
					ctx2.drawImage(laserimg2, laserdraw[i].x, laserdraw[i].y, laserdraw[i].w, laserdraw[i].h, laser2[i].exx, laser2[i].exy, 32, 32);
				
					laserdraw[i].x += laserdraw[i].w;
					laserdraw[i].idx++;
					if (laserdraw[i].idx % 8 == 0) {
						laserdraw[i].x = 0;
						laserdraw[i].y += laserdraw[i].h;

					}
					if (laserdraw[i].idx > laserdraw[i].frame_cnt) {
						laserdraw[i].x = 0;
						laserdraw[i].y = 0;
						laserdraw[i].w = 64;
						laserdraw[i].h = 64;
						laserdraw[i].idx = 0;
						laserdraw[i].frame_cnt = 32;
					}

				}
				///변화를 줘야한다
			}

			if (gameEnd2) {
				ctx2.drawImage(explosionimg2, explosiondraw.x, explosiondraw.y, explosiondraw.w, explosiondraw.h, explosion2.px, explosion2.py, 64, 64);
				explosiondraw.x += explosiondraw.w;
				explosiondraw.idx++;
				if (explosiondraw.idx % 5 == 0) {
					explosiondraw.x = 0;
					explosiondraw.y += explosiondraw.h;
				}

				if (explosiondraw.idx > explosiondraw.frame_cnt) {
					console.log(realGameEnd+'바뀌는곳');
					realGameEnd = true;
					var msg = {
							position : "game",
							cmd : "end",
							nick : nick,
							gnum : gnum
						};
						ws.send(JSON.stringify(msg));

				}
			}
			}
		}

		var ctx = document.getElementById("canvas").getContext("2d");
		var canvasTemp = document.createElement("canvas");
		var scrollImg = new Image();
		var tempContext = canvasTemp.getContext("2d");
		var imgWidth = 0;
		var imgHeight = 0;
		var imageData = {};
		var canvasWidth = 500;
		var canvasHeight = 1530;
		var scrollVal = 0;
		var speed = 2;
		/* 위쪽은 선생님 코드의 변수 선언, 그림을 그려주는 개체가 둘 필요하기때문에(그림의 처음과 끝을 이어 붙여야 하므로) 두 객체를 선언한다. 아래쪽 캔버스 템프는 조금 간략화된 클래스 선언으로 해당 객체에 상기와 같은 속성을 집어 넣어 준것이다 */

		var playerUnit = {};
		var keyPressOn = {};//pressed - true
		var spaceShipSprit;
		var canvasBuffer;
		/*  참조 블로그의 기체 움직임 변수들 각각 플레이어 유닛,버튼 입력 감지,기체 그림용,캔버스 객체의 펜을 담기위한 변수다(캔버스 객체는 실체 게임코드시 위쪽 코드와 일원화 시킬수 있다. 현재로선 기능 가동을 우선하여 객체를 하나 더 만들어둔 셈) */

		var enemyBalls;
		var enemyBallsinfo;
		var enemyBallsMax=100;
		var enemyBallscnt=0;
		var enemyimg;
		var gameEnd = false;
		var timeCheckLevel1 = 0;
		/* 위에서 부터 적 탄환 객체, 게임종료트리거용 객체, 시간이 지나가는것을 체크하는 객체 */

		/* 사용자 탄환 관련 변수   */
		var playerBulletimg;
		var playerBullet;
		var playerBulletinfo;
		var playerBulletMax = 50;/* 최대 탄환갯수  100개넘어가면 안쾌적함*/
		var playerBulletcnt = 0;

		var spacekey = false; // 스페이스바 활성화 되있는지 체크
		var spacetimer = false; // 탄환발사 시간 여부 체크
		var spacecnt = 0;

		/* 아이템 관련 변수  */
		var itemImg_0;
		var itemImg_1;
		var itemImg_2;
		var itemImg_3;
		var itemImg_4;
		var item;
		var iteminfo;
		var itemroot;
		var itemMax = 5;

		/* 아이템 기능 관련 변수  */
		var item_twoweapon = 2; //탄환 개수늘어남

		/* 플레이어 폭발 관련 변수  */
		var explosion; //폭발 이미지 변수 저장할때 씀
		var explosioninfo;
		var explosiontimer = false;
		var explosionimg;

		/* 적 탄환과 아군 탄환 충돌시 폭발 애니메이션 관련 변수  */
		var laser;
		var laserinfo;
		var lasermax = 10; /* 동시에 터지는 갯수 */
		var lasercnt = 0;
		var laserimg;

		//아이템 타이머
		var itemtimer1=0;
		var itemtimer3=0;
		var itemtimer4=0;
		
		//스코어
		var score=0;
		
		/* 1.아래쪽부터 돌아가는 로드 이미지는 게임에 시동을 거는 역할을 한다. */
		function loadImage() {
			/* 사용된 이미지의 폭과 너비를 저장하고 그림용 펜의 역할을 수행하는 캔버스 템프에도 담아둔다  */
			imgWidth = scrollImg.width, imgHeight = scrollImg.height;
			canvasTemp.width = imgWidth;
			canvasTemp.height = imgHeight;

			/* 그림을 그리고 현재 그림의 테이터를 담아둔다 */
			tempContext.drawImage(scrollImg, 0, 0, imgWidth, imgHeight);
			imageData = tempContext.getImageData(0, 0, imgWidth, imgHeight);

			/* 캔버스 버퍼 객체에 펜을 담는다 */
			canvasBuffer = document.createElement("canvas");

			/* 중요!! 플레이어 유닛 선언으로 자바 스크립트의 클래스(객체) 선언의 표준으로 삼을 만 하다 저장하고 싶은 값은 클래스 내부의 변수, 펑션을 담는다면 메소드가 된다 */
			playerUnit = {
				x : canvas.width / 2 - 18,
				y : canvas.height / 2 - 18,
				width : 36,
				height : 36,
				speed : 9
			};

			/*   창 자체에 이벤트 리스너를 설정하고 이미지를 불러와 기체 그림에 집어 넣는다 */
			document.addEventListener("keydown", getKeyDown, false);
			document.addEventListener("keyup", getKeyUp, false);
			setImage();

			/*  탄환 객체 선언 특정 개체를 배열로 만들고  */
			enemyBalls = new Array();
			enemyBallsinfo = new Array();
			createEnemyBalls(enemyBallsMax);
			useEnemyBalls(20);

			/* 플레이어 탄환 객체 선언 및 배열 내용 생성   */
			playerBullet = new Array();
			playerBulletinfo = new Array();
			createplayerBullet(playerBulletMax);

			/* 아이템 객체 선언 및 배열 내용 생성   */
			item = new Array();
			iteminfo = new Array();
			itemroot = new Array();
			createitem(itemMax);

			/* 탄환 충돌시 애니메이션 발생 관련 객체 선언 및 배열 내용 생성   */
			laser = new Array();
			laserinfo = new Array();
			createlaser(lasermax);

			/* 조건이 맞을 때까지 루프를 돌도록 설정된 게임 펑션을 돌린다. */
			imageData = tempContext.getImageData(0, canvasHeight - scrollVal, canvasWidth, canvasHeight);
			ctx.putImageData(imageData, 0, 0, 0, 0, canvasWidth, imgHeight);

			imageData = tempContext.getImageData(0, 0, canvasWidth, canvasHeight - scrollVal);
			ctx.putImageData(imageData, 0, scrollVal, 0, 0, canvasWidth, imgHeight);


			ctx.font = 'bold 55px Verdana';
			ctx.fillStyle = '#ffffff';
			ctx.fillText('Ready!', 150, 350);

			setTimeout(function() {
				ctx.clearRect(0, 0, canvasWidth, canvasHeight);
				ctx2.clearRect(0, 0, canvasWidth, canvasHeight);

				imageData = tempContext.getImageData(0, canvasHeight - scrollVal, canvasWidth, canvasHeight);
				ctx.putImageData(imageData, 0, 0, 0, 0, canvasWidth, imgHeight);

				imageData = tempContext.getImageData(0, 0, canvasWidth, canvasHeight - scrollVal);
				ctx.putImageData(imageData, 0, scrollVal, 0, 0, canvasWidth, imgHeight);

				imageData = tempContext.getImageData(0, canvasHeight - scrollVal, canvasWidth, canvasHeight);
				ctx2.putImageData(imageData, 0, 0, 0, 0, canvasWidth, imgHeight);

				imageData = tempContext.getImageData(0, 0, canvasWidth, canvasHeight - scrollVal);
				ctx2.putImageData(imageData, 0, scrollVal, 0, 0, canvasWidth, imgHeight);

				ctx.font = 'bold 55px Verdana';
				ctx.fillStyle = '#ffffff';
				ctx.fillText('Go!', 195, 350);

				ctx2.font = 'bold 55px Verdana';
				ctx2.fillStyle = '#ffffff';
				ctx2.fillText('Go!', 195, 350);

				setTimeout(function() {
					render();
				}, 1000);
			}, 2000);

		}

		/* 2.기체이미지를 가져오는 펑션 */
		function setImage() {

			spaceShipSprit = new Image();
			spaceShipSprit.src = "<c:url value="../resources/img/samplespaceships.png"/>";
			
			/* 아군 탄환 이미지 */
			playerBulletimg = new Image();
			playerBulletimg.src = "<c:url value="../resources/img/laserGreen11.png"/>";
			
			enemyimg = new Image();
			enemyimg.src = "<c:url value="../resources/img/enemy_2_3.png"/>";
			
			
			/* 아이템 이미지 > 현재는 네모칸으로 해놔서 이미지를 사용하지 않는다 */
			itemImg_0 = new Image();
			itemImg_0.src = "<c:url value="../resources/img/item_R.png"/>";
			itemImg_1 = new Image();
			itemImg_1.src = "<c:url value="../resources/img/item_B.png"/>";
			itemImg_2 = new Image();
			itemImg_2.src = "<c:url value="../resources/img/item_A.png"/>";
			itemImg_3 = new Image();
			itemImg_3.src = "<c:url value="../resources/img/item_S_1.png"/>";
			itemImg_4 = new Image();
			itemImg_4.src = "<c:url value="../resources/img/item_S_2.png"/>";
			/* 적 탄환 플레이어 충돌 이미지 */
			explosionimg = new Image();
			explosionimg.src = "<c:url value="../resources/img/explosion-sprite-sheet.png"/>";

			/* 아군 탄환 적탄환 충돌 이미지 */
			laserimg = new Image();
			laserimg.src = "<c:url value="../resources/img/laser_exp.png"/>";
		}

		/* 3.탄환객체를 만드는 펑션 */
		function createEnemyBalls(iCount) {
			for (var i = 0; i < iCount; i++) {
				
				var startX= Math.floor(Math.random() * (canvas.width - 1)) + 1;
				
				var enemy = {
					x : startX,
					y : 1500
				};
				var enemyinfo = {
					radius : 8,
					speed : 0,
					angle : 0,
					radians : Math.PI / 180,
					width : 26,
					height : 26,
					use : false
				};
				
				enemyBalls.push(enemy);
				enemyBallsinfo.push(enemyinfo);
			}
		}
		function useEnemyBalls(iCount) {
			
			for (var i = 0; i < iCount; i++) {
			/* 	if(enemyBallscnt>enemyBallsMax-1){
					enemyBallscnt=0;
				} */
				console.log(enemyBallscnt+'개 작동중');
				if(enemyBallscnt<enemyBallsMax){
				/* 탄환의 시작 위치 설정 */
				
				enemyBalls[enemyBallscnt].y = 0;

				/* 탄환의 방향,속도 설정 */
				enemyBallsinfo[enemyBallscnt].angle = Math.floor((Math.random() * 60) + 60);
				enemyBallsinfo[enemyBallscnt].speed = Math.floor(Math.random() * (2)) + 6;
				enemyBallsinfo[enemyBallscnt].use = true; 
				enemyBallscnt++;
				}
			}
		}

		/* 4.두종류의 키값모두 하나의 키캆으로 받기 위한 펑션들, 이 펑션들이 있는한 두키는 하나의 키값을 공유한다. */
		function getKeyDown(event) {
			var keyValue;
			if (event == null) {
				return;
			} else {
				keyValue = event.keyCode;
				event.preventDefault();
			}
			if (keyValue == "87")
				keyValue = "38"; //up
			else if (keyValue == "83")
				keyValue = "40"; //down
			else if (keyValue == "65")
				keyValue = "37"; //left
			else if (keyValue == "68")
				keyValue = "39"; //right
			keyPressOn[keyValue] = true;

			/* 아군 탄환 발사 키값 받음   */
			if (keyValue == "32") {
				spacekey = true;
			}
		}

		function getKeyUp(event) {
			var keyValue;
			if (event == null) {
				keyValue = window.event.keyCode;
				window.event.preventDefault();
			} else {
				keyValue = event.keyCode;
				event.preventDefault();
			}
			if (keyValue == "87")
				keyValue = "38"; //up
			else if (keyValue == "83")
				keyValue = "40"; //down
			else if (keyValue == "65")
				keyValue = "37"; //left
			else if (keyValue == "68")
				keyValue = "39"; //right
			keyPressOn[keyValue] = false;

			/* 아군 탄환 발사 종료 기능 받음  */
			if (keyValue == "32") {
				spacekey = false;
			}
		}

		/* 5. 입력된 키값이 지정해둔 키와 일치할 경우 플레이어 유닛의 정보를 갱신시키는 펑션 */
		function calcKeyInnput() {
			if (keyPressOn["38"] && playerUnit.y >= -playerUnit.height / 2)
				playerUnit.y -= playerUnit.speed; //up
			if (keyPressOn["40"] && playerUnit.y <= canvas.height - playerUnit.height / 2)
				playerUnit.y += playerUnit.speed; //down
			if (keyPressOn["37"] && playerUnit.x >= -playerUnit.width / 2)
				playerUnit.x -= playerUnit.speed; //left
			if (keyPressOn["39"] && playerUnit.x <= canvas.width - playerUnit.width / 2)
				playerUnit.x += playerUnit.speed; //right

		}

		/* 6. 유닛의 과 탄환간의 거리를 재어 피격판정을내는 펑션, 피격의 경우 게임을 정지 시키기 위한 값을 돌려주고 그렇지 않을 경우 계속시킨다 */
		function checkHitPlayer() {
			var rtnVal = false;
			for (var i = 0; i < enemyBalls.length; i++) {
				var distanceX = (playerUnit.x + playerUnit.width / 2) - (enemyBalls[i].x+ enemyBallsinfo[i].width / 2);
				var distanceY = (playerUnit.y + playerUnit.height / 2) - (enemyBalls[i].y+ enemyBallsinfo[i].height / 2);
				var distance = distanceX * distanceX + distanceY * distanceY;

				if (distance <= (enemyBallsinfo[i].width / 2 + (playerUnit.width / 2 - 5)) * (enemyBallsinfo[i].height / 2 + (playerUnit.height / 2 - 5))) {
					rtnVal = true;
					break;
				}
			}

			return rtnVal;
		}

		/* 7.탄환의 위치를 조정하는 평션 */
		function calcEnemy() {
			/* 일정 시간이 지날때마다 탄환 갯수를 추가하는 부분  */
			if (timeCheckLevel1>100 && timeCheckLevel1 % 150==0) {
				var itemcode = Math.floor(Math.random() * itemMax);
				useplayeritem(itemcode);
			}
			if (timeCheckLevel1 > 600) {
				/* 적 탄환이 2개 추가 될때 랜덤아이템 1개를 활성화시킨다   */
				/* var itemcode = Math.floor(Math.random() * itemMax);
				useplayeritem(itemcode); */

				/* 적 탄환을 두개 추가한다   */
				useEnemyBalls(2);
				
				timeCheckLevel1 = 0;
			}
			timeCheckLevel1++;

			/*   해당탄환이 원래 가지고 있는속도, 현재위치, 방향값을 이용하여 다음위치를 산출하여 적용한다. */
			for (var i = 0; i < enemyBalls.length; i++) {
				if(enemyBallsinfo[i].use){
				enemyBallsinfo[i].radians = enemyBallsinfo[i].angle * Math.PI / 180;
				enemyBalls[i].x += Math.cos(enemyBallsinfo[i].radians) * enemyBallsinfo[i].speed;
				enemyBalls[i].y += Math.sin(enemyBallsinfo[i].radians) * enemyBallsinfo[i].speed;

				if (enemyBalls[i].x > canvas.width || enemyBalls[i].x < -25) {//원래 값 enemyBalls[i].x < 0
					enemyBallsinfo[i].angle = Math.floor((Math.random() * 60) + 60);
					enemyBalls[i].y = 0;
				} else if (enemyBalls[i].y > canvas.height) {// || enemyBalls[i].y < 0
					enemyBallsinfo[i].angle = Math.floor((Math.random() * 60) + 60);
					/*  enemyBalls[i].angle = 360 - enemyBalls[i].angle; */
					enemyBalls[i].y = 0;
				}
				}
			}

		}

		/*   8.게임 루프 펑션 */
		function render() {
			if(!endcheck){
				/* render 돌릴때마다 메세지 전송 */
			
			if(itemtimer1>=1){
				itemtimer1--;
			}else{
				item_twoweapon = 2;
			}
			if(itemtimer3>=1){
				itemtimer3--;
			}else{
				for (var i = 0; i < enemyBalls.length; i++) {
					enemyBallsinfo[i].speed = 10;
				}
			}
			if(itemtimer4>=1){
				itemtimer4--;
			}else{
				playerUnit.speed = 9;
			}
			
			var remotePlayer = {
				x : playerUnit.x,
				y : playerUnit.y
			};
			var data = {
				remotePlayer : remotePlayer,
				remoteplayerBullet : playerBullet,
				remoteenemyBalls : enemyBalls,
				remoteitem : item,
				remotelaser : laser,
				gameend : false
			};
			/* database.push(data); */
			spacecnt++;
			/* 탄환 속도 제한을 위해 시간 체크 */

			if (spacecnt % 2 == 0) {
				var msg = {
					position : "game",
					cmd : "playing",
					nick : nick,
					gnum : gnum,
					gamedata : data,
					itemroot : itemroot
				};
				ws.send(JSON.stringify(msg));
			for(var i=0;i<itemroot.length;i++){
				if(itemroot[i].two){
					itemroot[i].two=false;
		
				}
			}
				
			}
			if (spacecnt % 5 == 0) {
				spacetimer = true;
			} else {
				spacetimer = false;
			}

			useplayerBullet();
			calcitem();
			calcKeyInnput();
			calcEnemy();
			calcBullet();
			calclaser();
			/* 키값을 받아 플레이어 기체 위치를 변경하고 다음으로 적 기체 위치를 변경한다 */

			ctx.clearRect(0, 0, canvasWidth, canvasHeight);
			/*  캔버스를 한번 지운다 */

			if (scrollVal >= canvasHeight - speed) {
				scrollVal = 0;
			}
			/* 혹시 스크롤 한바퀴 다돌아 간경우 스크롤을 초기화한다 */

			scrollVal += speed;
			/* 지정된 속도를 기준으로 스크롤의 값이 늘어난다(그리는 위치가 변경된다) */

			// This is the bread and butter, you have to make sure the imagedata isnt larger than the canvas your putting image data to.
			//back buffer에 그려진 배경이미지의 끝부분(아래쪽)을 복사해서 Canvas의 앞부분(위쪽)에 붙여 넣는다
			imageData = tempContext.getImageData(0, canvasHeight - scrollVal, canvasWidth, canvasHeight);
			ctx.putImageData(imageData, 0, 0, 0, 0, canvasWidth, imgHeight);

			//back buffer에 그려진 배경이미지의 시작부분(위쪽)을 복사해서 Canavas의 뒷부분(아래쪽)에 붙여 넣는다
			imageData = tempContext.getImageData(0, 0, canvasWidth, canvasHeight - scrollVal);
			ctx.putImageData(imageData, 0, scrollVal, 0, 0, canvasWidth, imgHeight);
			/* 배경 스크롤을 그려주는 부분 */

			/* 아군 탄환 그리기   */
			for (var i = 0; i < playerBullet.length; i++) {
				ctx.drawImage(playerBulletimg, //Source Image
				0, 0, //X, Y Position on spaceShipSprit
				9, 54, //Cut Size from spaceShipSprit
				playerBullet[i].x, playerBullet[i].y, //View Position
				8, 20 //View Size
				);
				ctx.drawImage(canvasBuffer, 0, 0);
			}

			/* 플레이어 기체를 그려준다 */
			ctx.drawImage(spaceShipSprit, //Source Image
			405, 180, //X, Y Position on spaceShipSprit
			playerUnit.width, playerUnit.height, //Cut Size from spaceShipSprit
			playerUnit.x, playerUnit.y, //View Position
			playerUnit.width, playerUnit.height //View Size
			);
			ctx.drawImage(canvasBuffer, 0, 0);

			/*  탄환(적기체)를 그려준다 */
			for (var i = 0; i < enemyBalls.length; i++) {
				/* ctx.fillStyle = enemyBallsinfo[i].color;
				ctx.beginPath();
				ctx.arc(enemyBalls[i].x, enemyBalls[i].y, enemyBallsinfo[i].radius, 0, Math.PI * 2, true)
				ctx.closePath();
				ctx.fill(); */
				
				// ctx.drawImage(enemyimg,enemyBalls[i].x,enemyBalls[i].y);
					ctx.drawImage(enemyimg, //Source Image
							0, 0, //X, Y Position on spaceShipSprit
							36, 36, //Cut Size from spaceShipSprit
							enemyBalls[i].x,enemyBalls[i].y, //View Position
							26, 26 //View Size
							);
			}

			/* 아이템을 그려준다   */
			for (var i = 0; i < item.length; i++) {
				/* 아이템에 따라 다른 색을 넣어준다 */
				switch (i) {
				case 0:
					ctx.drawImage(itemImg_0, //Source Image
							0, 0, //X, Y Position on spaceShipSprit
							88, 80, //Cut Size from spaceShipSprit
							item[i].x,item[i].y, //View Position
							26, 24 //View Size
					);
					break;
				case 1:
					ctx.drawImage(itemImg_1, //Source Image
							0, 0, //X, Y Position on spaceShipSprit
							88, 80, //Cut Size from spaceShipSprit
							item[i].x,item[i].y, //View Position
							26, 24 //View Size
					);
					break;
				case 2:
					ctx.drawImage(itemImg_2, //Source Image
							0, 0, //X, Y Position on spaceShipSprit
							88, 80, //Cut Size from spaceShipSprit
							item[i].x,item[i].y, //View Position
							26, 24 //View Size
					);
					break;
				case 3:
					ctx.drawImage(itemImg_3, //Source Image
							0, 0, //X, Y Position on spaceShipSprit
							88, 80, //Cut Size from spaceShipSprit
							item[i].x,item[i].y, //View Position
							26, 24 //View Size
					);
					break;
				case 4:
					ctx.drawImage(itemImg_4, //Source Image
							0, 0, //X, Y Position on spaceShipSprit
							88, 80, //Cut Size from spaceShipSprit
							item[i].x,item[i].y, //View Position
							26, 24 //View Size
					);
					break;
				default:
					ctx.fillStyle = iteminfo[i].color;
					ctx.fillRect(item[i].x, item[i].y, iteminfo[i].width, iteminfo[i].height);
					break;
				}
				/* 그린다 */
			}

			/* 탄환 충돌 이펙트를 그린다 */
			for (var i = 0; i < laser.length; i++) {
				if (laser[i].use) {
					ctx.drawImage(laserimg, laserinfo[i].x, laserinfo[i].y, laserinfo[i].w, laserinfo[i].h, laser[i].exx, laser[i].exy, 32, 32);
				}
			}

			/* 충돌 이벤트를 확인한다 */
			checkHitBullet();
			checkHititem();
			/*  피격판정을 실시한다 */
			gameEnd = checkHitPlayer();

			if (gameEnd) {
				
				victory=false;
				/* 아군기체와 적탄환 춛돌시 아군 기체를 없애고 그 자리에서 충돌 이펙트를 보여준다 */
				explosion = {
					px : playerUnit.x,
					py : playerUnit.y
				}
				explosioninfo = {
					x : 0,
					y : 0,
					w : 64,
					h : 64,
					idx : 0,
					frame_cnt : 25
				}
				//밑에 함수가 settimeout 천밀리초? 뒤에 실행되어야한다
				//여기서 같이 기다렸다가 메세지가 가야한다
				playerExplosionsound() ;
				playerExplosion();

			}
			 
			 
			/*  판정에의해 게임 종료 혹은 속행을 판단하고 루프를 다시 돌릴 것인지를 결정한다. 이 과정은 10 밀리세컨드의 인터벌을 둔다 */
			if (!gameEnd  && !realGameEnd) {//
				setTimeout(function() {
					if (itemroot[0].one) {
						$('#canvas').css('border', '5px solid green');
						setTimeout(function() {
							$('#canvas').css('border', '5px solid black');
						}, 500);
						enemyBalls = new Array();
						enemyBallsinfo = new Array();
						enemyBallscnt=0;
						createEnemyBalls(100);
						useEnemyBalls(10);
						/* 기능설정하고나면 값 바꿔줌 */
						itemroot[0].one = false;
					}
					if (itemroot[1].one) {
						$('#canvas').css('border', '5px solid green');
						setTimeout(function() {
							$('#canvas').css('border', '5px solid black');
						}, 500);
						itemtimer1=100; //900
						if (item_twoweapon < 3) {
							item_twoweapon += 1;
						}
						itemroot[1].one = false;
					} 
					// 상대방이 아이템을 먹었을때 방해효과 작용
					if (itemroot[2].one) {
						$('#canvas').css('border', '5px solid red');
						setTimeout(function() {
							$('#canvas').css('border', '5px solid black');
						}, 500);
						
						if (enemyBallscnt < 90) {
							useEnemyBalls(10);
						}
						itemroot[2].one = false;
					}
					if (itemroot[3].one) {
						$('#canvas').css('border', '5px solid red');
						setTimeout(function() {
							$('#canvas').css('border', '5px solid black');
						}, 500);
						
						itemtimer3=100;
						for (var i = 0; i < enemyBalls.length; i++) {
							enemyBallsinfo[i].speed = 15;
						}
						itemroot[3].one = false;
					}
					if (itemroot[4].one) {
						$('#canvas').css('border', '5px solid red');
						setTimeout(function() {
							$('#canvas').css('border', '5px solid black');
						}, 500);
						
						itemtimer4=100;
						playerUnit.speed = 5;
						itemroot[4].one = false;
					} 
					
					
					render();
				}, 1000 / 30);
			}
		}
		}

		/* thirdmix에서 추가된 함수   */

		//아군 탄환 객체 생성 함수
		function createplayerBullet(iCount) {
			for (var i = 0; i < iCount; i++) {

				var bullet = {
					x : 600,
					y : 1500,
					use : false
				};
				/* 탄환 객체를 만들어 지금까지 생성한 값을 집어 넣는다 */
				var bulletinfo = {
					color : "#00ffff",
					radius : 4, /*원의 크기*/
					speed : 0,
					angle : 4,
					radians : 0
				};
				playerBullet.push(bullet);
				playerBulletinfo.push(bulletinfo);
				/* 탄환 배열에 집어 넣는다. 이 펑션으로 확실해지는 것은 화면내에 물체 하나를 추가 할때마다 다수의 값을 가진(용량이 제법 되는)객체가 만들어져야 한다는것, 패턴 가짓수 만들기에는 주의가 필요하다 */
			}
		}

		//아군 탄환 객체 사용 함수
		function useplayerBullet() {

			if (spacekey && spacetimer) { /*  스페이스 키가 눌러져 있고 스페이스타이머(reder()가 돌때마다 시간을 재는 용이다)값을 받아 둘다 트루일때만 객체를 캔버스로 부른다 */

				if (playerBulletcnt > (playerBulletMax - 1)) {
					playerBulletcnt = 0;
				}

				/* 아이템을 먹었을때 발사되는 탄환수 늘리고 탄환수가 늘면 플레이어 기체 안에서 영역을 나눠서 예쁘게 나가게 함  */
				var width = playerUnit.width / item_twoweapon;
				/* 이 for은 아이템을 먹었을때 탄환이 두개면 2번 호출해서 각자 좌료를 잡아주는 함수이다 */
				for (var i = 1; i < item_twoweapon; i++) {

					playerBullet[playerBulletcnt].x = playerUnit.x + (width * i) - 2;
					playerBullet[playerBulletcnt].y = playerUnit.y + playerUnit.height / 2;
					playerBulletinfo[playerBulletcnt].speed = 25;//9 16;
					playerBullet[playerBulletcnt].use = true;
					playerBulletcnt++;
					if (playerBulletcnt > (playerBulletMax - 1)) {
						playerBulletcnt = 0;
					}
					Bulletsound();
				}
				/* 발사 탄환 증가 기능 끝 */
			}

		}

		//아군 탄환 객체 이동 함수
		function calcBullet() {

			for (var i = 0; i < playerBullet.length; i++) {
				if (playerBullet[i].use) {/* 사용하는 공만 움직임 */
					playerBullet[i].y -= playerBulletinfo[i].speed;

					if (playerBullet[i].x > canvas.width || playerBullet[i].x < 0) {
						nouseplayerBullet(i);
					}
					if (playerBullet[i].y > canvas.height || playerBullet[i].y < 0) {
						nouseplayerBullet(i);
					}
				}
			} /*   해당탄환이 원래 가지고 있는속도, 현재위치, 방향값을 이용하여 다음위치를 산출하여 적용한다. */

		}

		//아군 탄환 객체 사용하지않음으로 변경 후 객체 값 초기화
		function nouseplayerBullet(i) {
			playerBullet[i].x = 600;
			playerBullet[i].y = 1600;
			playerBulletinfo[i].speed = 0;/* 0으로 해서 보이지 않는공은 아무것도 안함 */
			playerBullet[i].use = false;
		}

		/* 플레이어 탄환과 ball 충돌 확인*/
		function checkHitBullet() {

			for (var i = 0; i < playerBullet.length; i++) {
				if (playerBullet[i].use) {/* 사용하는 공만 충돌판정 확인함 */

					for (var j = 0; j < enemyBalls.length; j++) {
						var distanceX = playerBullet[i].x - (enemyBalls[j].x+ enemyBallsinfo[j].width / 2);
						var distanceY = playerBullet[i].y - (enemyBalls[j].y+ enemyBallsinfo[j].height / 2);
						var distance = distanceX * distanceX + distanceY * distanceY;

						if (distance <= ((enemyBallsinfo[j].width / 2)+18 * (enemyBallsinfo[j].height / 2) + 18)) { // 탄환범위 늘릴수 있음+ 18
							/* 아군 탄환 없앰 */
							nouseplayerBullet(i);
							score+=100;
							/* 폭발이펙트 발생 */
							uselaser(enemyBalls[j].x, enemyBalls[j].y);// - 15
							emenyExplosionsound();
							/* 충돌한 적 탄환 초기화 */
							enemyBalls[j].y = 0;
							break;
						}
					}

				}
			}

		}

		/* 아이템 첫 생성 */
		function createitem(imax) {
			for (var i = 0; i < imax; i++) {

				var newitem = {
					itemcode : i,
					x : 600,
					y : 1500,
					use : false
				};
				var newiteminfo = {
					color : "#ffffff",
					width : 30,
					height : 30,
					xspeed : 0,
					yspeed : 0,
					angle : 0,
					radius : 4,
					radians : Math.PI / 180
				};
				
				var newitemroot = {
						itemcode : i,
						one : false,
						two : false
					};
				/* 아이템 객체를 만들어 지금까지 생성한 값을 집어 넣는다 */
				item.push(newitem)
				iteminfo.push(newiteminfo);
				itemroot.push(newitemroot);
				/* 아이템 배열에 집어 넣는다. 이 펑션으로 확실해지는 것은 화면내에 물체 하나를 추가 할때마다 다수의 값을 가진(용량이 제법 되는)객체가 만들어져야 한다는것, 패턴 가짓수 만들기에는 주의가 필요하다 */
			}

		}
		/* 아이템을 활성화될때*/
		function useplayeritem(i) {

			item[i].x = Math.floor(Math.random() * (canvas.width - 1)) + 1;
			item[i].y = 0;
			iteminfo[i].xspeed = 10; //7 이였다 15빠르다
			iteminfo[i].yspeed = 10;
			iteminfo[i].angle = Math.floor((Math.random() * 60) + 60);
			item[i].use = true;

		}
		/* 아이템 이동 */
		function calcitem() {
			for (var i = 0; i < item.length; i++) {
				if (item[i].use) {
					iteminfo[i].radians = iteminfo[i].angle * Math.PI / 180;
					item[i].x += Math.cos(iteminfo[i].radians) * iteminfo[i].xspeed;
					item[i].y += Math.sin(iteminfo[i].radians) * iteminfo[i].yspeed;

					if (item[i].x > canvas.width - 30 || item[i].x < 5) {
						iteminfo[i].xspeed *= -1;
					} else if (item[i].y > canvas.height || item[i].y < 0) {
						nouseplayeritem(i);
					}

					if (item[i].x > canvas.width - 30) {
						item[i].x = canvas.width - 30;
					} else if (item[i].x < 5) {
						item[i].x = 5;
					}
				}
			}
			/*   해당탄환이 원래 가지고 있는속도, 현재위치, 방향값을 이용하여 다음위치를 산출하여 적용한다. */
		}
		/*아이템 충돌확인 */
		function checkHititem() {

			for (var i = 0; i < item.length; i++) {
				/* 사용하는 공만 충돌판정 확인함 */
				if (item[i].use) {

					var distanceX = (playerUnit.x + playerUnit.width / 2) - (item[i].x + iteminfo[i].width / 2);
					var distanceY = (playerUnit.y + playerUnit.height / 2) - (item[i].y + iteminfo[i].height / 2);
					var distance = distanceX * distanceX + distanceY * distanceY;

					if (distance <= (iteminfo[i].width / 2 + (playerUnit.width / 2 - 10)) * (iteminfo[i].height / 2 + (playerUnit.height / 2 - 10))) {
						/*아이템 초기화 */
						nouseplayeritem(i);
						/*아이템 기능 넣기 */
						getitemsound();
						if (i==0) {
							itemroot[0].one = true;
						}
						else if (i==1) {
							itemroot[1].one = true;
						} else {
							itemroot[i].two = true;
							$('#canvas2').css('border', '5px solid red');
							setTimeout(function() {
								$('#canvas2').css('border', '5px solid black');
							}, 500)
						}
					}

				}
			}

		}
		/*아이템 초기화 */
		function nouseplayeritem(i) {
			item[i].x = 600;
			item[i].y = 1500;
			iteminfo[i].xspeed = 0;
			iteminfo[i].yspeed = 0;
			iteminfo[i].angle = 0;
			item[i].use = false;

		}

		/* 풀레이어 기체와 적탄환 충돌시 이 함수가 호출됨 */
		function playerExplosion() {
			if(!endcheck){
				var data = {
				explosion : explosion,
				remoteplayerBullet : playerBullet,
				remoteenemyBalls : enemyBalls,
				remoteitem : item,
				remotelaser : laser,
				gameend : true
			};
			var msg = {
				position : "game",
				cmd : "playing",
				nick : nick,
				gnum : gnum,
				gamedata : data,
				itemroot : itemroot
			};
			ws.send(JSON.stringify(msg));
			/* 아군 기체를 없애고 키값도 받지않는다 */
			calcitem();
			calcEnemy();
			calcBullet();
			calclaser();

			/*  캔버스를 한번 지운다 */
			ctx.clearRect(0, 0, canvasWidth, canvasHeight);

			/* 혹시 스크롤 한바퀴 다돌아 간경우 스크롤을 초기화한다 */
			if (scrollVal >= canvasHeight - speed) {
				scrollVal = 0;
			}

			/* 지정된 속도를 기준으로 스크롤의 값이 늘어난다(그리는 위치가 변경된다) */
			scrollVal += speed;

			// This is the bread and butter, you have to make sure the imagedata isnt larger than the canvas your putting image data to.
			//back buffer에 그려진 배경이미지의 끝부분(아래쪽)을 복사해서 Canvas의 앞부분(위쪽)에 붙여 넣는다
			imageData = tempContext.getImageData(0, canvasHeight - scrollVal, canvasWidth, canvasHeight);
			ctx.putImageData(imageData, 0, 0, 0, 0, canvasWidth, imgHeight);

			//back buffer에 그려진 배경이미지의 시작부분(위쪽)을 복사해서 Canavas의 뒷부분(아래쪽)에 붙여 넣는다
			imageData = tempContext.getImageData(0, 0, canvasWidth, canvasHeight - scrollVal);
			ctx.putImageData(imageData, 0, scrollVal, 0, 0, canvasWidth, imgHeight);
			/* 배경 스크롤을 그려주는 부분 */

			/* 아군 탄환 그리기 */
			for (var i = 0; i < playerBullet.length; i++) {
				ctx.drawImage(playerBulletimg, //Source Image
				0, 0, //X, Y Position on spaceShipSprit
				9, 54, //Cut Size from spaceShipSprit
				playerBullet[i].x, playerBullet[i].y, //View Position
				5, 20 //View Size
				);
				ctx.drawImage(canvasBuffer, 0, 0);
			}

			/* 적군 탄환 그리기*/
			for (var i = 0; i < enemyBalls.length; i++) {
			/* 	ctx.fillStyle = enemyBallsinfo[i].color;
				ctx.beginPath();
				ctx.arc(enemyBalls[i].x, enemyBalls[i].y, enemyBallsinfo[i].radius, 0, Math.PI * 2, true)
				ctx.closePath();
				ctx.fill();	 */
				ctx.drawImage(enemyimg, //Source Image
						0, 0, //X, Y Position on spaceShipSprit
						36, 36, //Cut Size from spaceShipSprit
						enemyBalls[i].x,enemyBalls[i].y, //View Position
						26, 26 //View Size
						);
			}

			/* 아이템 그리기*/
			for (var i = 0; i < item.length; i++) {
				switch (i) {
				case 0:
					ctx.drawImage(itemImg_0, //Source Image
							0, 0, //X, Y Position on spaceShipSprit
							88, 80, //Cut Size from spaceShipSprit
							item[i].x,item[i].y, //View Position
							26, 24 //View Size
					);
					break;
				case 1:
					ctx.drawImage(itemImg_1, //Source Image
							0, 0, //X, Y Position on spaceShipSprit
							88, 80, //Cut Size from spaceShipSprit
							item[i].x,item[i].y, //View Position
							26, 24 //View Size
					);
					break;
				case 2:
					ctx.drawImage(itemImg_2, //Source Image
							0, 0, //X, Y Position on spaceShipSprit
							88, 80, //Cut Size from spaceShipSprit
							item[i].x,item[i].y, //View Position
							26, 24 //View Size
					);
					break;
				case 3:
					ctx.drawImage(itemImg_3, //Source Image
							0, 0, //X, Y Position on spaceShipSprit
							88, 80, //Cut Size from spaceShipSprit
							item[i].x,item[i].y, //View Position
							26, 24 //View Size
					);
					break;
				case 4:
					ctx.drawImage(itemImg_4, //Source Image
							0, 0, //X, Y Position on spaceShipSprit
							88, 80, //Cut Size from spaceShipSprit
							item[i].x,item[i].y, //View Position
							26, 24 //View Size
					);
					break;
				default:
					ctx.fillStyle = iteminfo[i].color;
					ctx.fillRect(item[i].x, item[i].y, iteminfo[i].width, iteminfo[i].height);
					break;
				}
			}

			/* 탄환 충돌 이펙트를 그린다 */
			for (var i = 0; i < laser.length; i++) {
				if (laser[i].use) {
					ctx.drawImage(laserimg, laserinfo[i].x, laserinfo[i].y, laserinfo[i].w, laserinfo[i].h, laser[i].exx, laser[i].exy, 32, 32);
				}
			}

			/* 탄환 끼리의 충돌 감지 */
			checkHitBullet();

			/*  아군 기체 폭발을 그려준다 */
			ctx.drawImage(explosionimg, explosioninfo.x, explosioninfo.y, explosioninfo.w, explosioninfo.h, playerUnit.x, playerUnit.y, 64, 64);
			explosioninfo.x += explosioninfo.w;
			explosioninfo.idx++;
			if (explosioninfo.idx % 5 == 0) {
				explosioninfo.x = 0;
				explosioninfo.y += explosioninfo.h;
			}

			if (explosioninfo.idx > explosioninfo.frame_cnt) {
				explosiontimer = true;

			}

			if (!explosiontimer) {

				setTimeout(function() {
					playerExplosion();
				}, 1000 / 20);
			} else {
				/*  폭발이벤트가 끝나면 배경을 뺀 모든 그림을 초기화 시킨다. */
				ctx.clearRect(0, 0, canvasWidth, canvasHeight);

				if (scrollVal >= canvasHeight - speed) {
					scrollVal = 0;
				}
				/* 혹시 스크롤 한바퀴 다돌아 간경우 스크롤을 초기화한다 */

				scrollVal += speed;
				/* 지정된 속도를 기준으로 스크롤의 값이 늘어난다(그리는 위치가 변경된다) */

				// This is the bread and butter, you have to make sure the imagedata isnt larger than the canvas your putting image data to.
				//back buffer에 그려진 배경이미지의 끝부분(아래쪽)을 복사해서 Canvas의 앞부분(위쪽)에 붙여 넣는다
				imageData = tempContext.getImageData(0, canvasHeight - scrollVal, canvasWidth, canvasHeight);
				ctx.putImageData(imageData, 0, 0, 0, 0, canvasWidth, imgHeight);

				//back buffer에 그려진 배경이미지의 시작부분(위쪽)을 복사해서 Canavas의 뒷부분(아래쪽)에 붙여 넣는다
				imageData = tempContext.getImageData(0, 0, canvasWidth, canvasHeight - scrollVal);
				ctx.putImageData(imageData, 0, scrollVal, 0, 0, canvasWidth, imgHeight);
				/* 배경 스크롤을 그려주는 부분 */
			}
			}
		}

		/* 아군 탄환 적탄환 충돌했을때 생기는 이펙트 만들기  */
		function createlaser(max) {
			for (var i = 0; i < max; i++) {
				var newlaser = {
					exx : 600, //  폭발이 일어나는 위치 담기	
					exy : 600, //  폭발이 일어나는 위치 담기	
					use : false
				};
				var newlaserinfo = {
					x : 0,
					y : 0,
					w : 64,
					h : 64,
					idx : 0,
					frame_cnt : 32,
				};

				/* 아이템 객체를 만들어 지금까지 생성한 값을 집어 넣는다 */

				laser.push(newlaser);
				laserinfo.push(newlaserinfo);
				/* 아이템 배열에 집어 넣는다. 이 펑션으로 확실해지는 것은 화면내에 물체 하나를 추가 할때마다 다수의 값을 가진(용량이 제법 되는)객체가 만들어져야 한다는것, 패턴 가짓수 만들기에는 주의가 필요하다 */
			}

		}
		/* 폭발이 일어났을떄 폭발이벤트를 활성화 시킨다*/
		function uselaser(x, y) {
			if (lasercnt > (lasermax - 1)) {
				lasercnt = 0;
			}

			laser[lasercnt].exx = x; /* 폭발이 일어났을때 적탄환 위치를 가져온다*/
			laser[lasercnt].exy = y;
			laser[lasercnt].use = true;
			lasercnt++;
		}

		/* 탄환 충돌 폭발 이벤트 초기화 */
		function nouselaser(i) {
			laser[i].exx = 600;
			laser[i].exy = 600;
			laserinfo[i].x = 0;
			laserinfo[i].y = 0;
			laserinfo[i].w = 64;
			laserinfo[i].h = 64;
			laserinfo[i].idx = 0;
			laserinfo[i].frame_cnt = 32;
			laser[i].use = false;

		}

		/* 탄환 충돌 폭발 이벤트 애니메이션 효과용 보여주는 장면을 다르게 해준다 */
		function calclaser() {
			for (var i = 0; i < laser.length; i++) {
				if (laser[i].use) {
					laserinfo[i].x += laserinfo[i].w;
					laserinfo[i].idx++;
					if (laserinfo[i].idx % 8 == 0) {
						laserinfo[i].x = 0;
						laserinfo[i].y += laserinfo[i].h;

					}
					if (laserinfo[i].idx > laserinfo[i].frame_cnt) {
						nouselaser(i);
					}

				}
			}
		}
		function playerExplosionsound() {
			var explosionsound = document.createElement("audio");
			explosionsound.volume=0.8;
			explosionsound.src = "<c:url value="../resources/music/explode.mp3"/>";
			explosionsound.setAttribute('id', 'explosionsound');
			document.body.appendChild(explosionsound);
			explosionsound.play();
			setTimeout(function() {
				$('#explosionsound').remove();
			}, 500);
		}

		function emenyExplosionsound() {
			var explosionemeny = document.createElement("audio");
			explosionemeny.volume=0.5;
			explosionemeny.src = "<c:url value="../resources/music/explosion_enemy.wav"/>";
			explosionemeny.setAttribute('id', 'explosionemeny');
			document.body.appendChild(explosionemeny);
			explosionemeny.play();
			setTimeout(function() {
				$('#explosionemeny').remove();
			}, 500);
			//
		}
		
		function getitemsound() {
			var getitem = document.createElement("audio");
			getitem.src = "<c:url value="../resources/music/8-bit-pickup.wav"/>";
			getitem.setAttribute('id', 'getitem');
			document.body.appendChild(getitem);
			getitem.play();
			setTimeout(function() {
				$('#getitem').remove();
			}, 500);

		}
		
		function Bulletsound() {
			var shotsound = document.createElement("audio");
			shotsound.volume=1.0;
			shotsound.src = "<c:url value="../resources/music/8-bit-laser.wav"/>";
			shotsound.setAttribute('id', 'shotsound');
			document.body.appendChild(shotsound);
			shotsound.play();
			setTimeout(function() {
				$('#shotsound').remove();
			}, 500);
		}
	});
</script>
</head>
<body>
<div style="width:200px !important; height:200px !important; float:left; margin-top:-70px; margin-left:50px;">
	<img style="width:100%; height:100%;" src="../resources/img/starwars.png">
</div> 
<div id="gamebackground">
	<div style="width:500px; height: 850px; float:left;"><canvas id="canvas" width="500" height="750"></canvas></div>
	<div style="width:150px !important; height:300px !important; float:left; margin:230px 0 0 25px;">
		<div id="myPageScore">닉네임<br>스코어</div>
		<img style="width:100%; height:50%;" src="../resources/img/terran1.png"></div>
	<div style="width:500px; height: 850px; float:right;"><canvas id="canvas2" width="500" height="750"></canvas></div>
</div>
<div style="width:300px !important; height:300px !important; float:right; margin-top:-165px;">
	<img style="width:100%; height:100%;" src="../resources/img/earthside.png">
</div>	
<audio id="audio" src="../resources/music/game4.mp3" loop="-1" autoplay/> 
</body>
</html>