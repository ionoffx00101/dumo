
var stageOneEnd = false;
var stageTwoEnd = false;
var stargeThreeEnd =false;
$(function() {
	
		// 캔버스 친구들
		var canvas = document.getElementById("canvas");
		var ctx = canvas.getContext("2d"); // 캔버스 객체 생성

		var canvasTemp;
		var tempContext;
		var canvasBuffer ;
		
		// 스크롤 이미지
		var scrollImg= new Image();
				
		// 기본 객체
		var backGroundMusic; // 배경음악 객체 생성
		var canvasPen; // 캔버스에 그림을 그리는 펜
		var keyPressOn = {}; //키 배열, pressed - true
		var spacekey = false; // 스페이스 키
		var oneSpacekey =false; 
		
		// 플레이어 객체
		var playerUnit={}; // 플레이어
		
		// 스테이지 1 적 객체
		var EnemyHangul; // 스테이지1 적객체
		var EnemyHangulWord = 
		{
				"EnemyHangulWord":
		[
				{"boolean":"false","word":"댕댕이"},
				{"boolean":"true","word":"아버지가 방에 들어가신다"},
				{"boolean":"true","word":"지친다"}
		]
		};
		
		
		// 시동 걸기
		function loadGame() {
			// 기본 객체들 채워주기
			canvasBuffer = document.createElement("canvas"); // 캔버스에 펜있다고 넣어주기
			makeBackGroungMusic(); // 배경음악 객체 채워주는 함수 호출
			
			// 백그라운드 이미지
			// scrollImg.src = "<c:url value="../resources/img/backGround2.jpg"/>";
			// scrollImg.onload = loadImage;
		
			scrollImg.src = "../images/city.png";
			
			// 플레이 객체들 채워주기
			makePlayerUnit();
			
			// 한글 객체 채우기
			
			makeEnemyHangulUnit();
			
			// 창 자체에 이벤트 리스너를 설정 //document O, canvas X , window O
			document.addEventListener("keydown", getKeyDown, false);
			document.addEventListener("keyup", getKeyUp, false);
			
			// 게임 스타트
			// loopGame(); // 게임 스타트 함수 호출
			scrollImg.onload = loopGame;
		}
		
		// 게임 실행
		function loopGame(){
			// 한번 실행
			// backGroundMusic.play(); // 배경음악 객체 플레이
			
			// 반복 실행
			// 배경 

		/* setInterval(() => {
				// 사용된 이미지의 폭과 너비를 저장하고 그림용 펜의 역할을 수행하는 캔버스 템프에도 담아둔다 
				imgWidth = scrollImg.width, imgHeight = scrollImg.height;
				canvasTemp.width = imgWidth;
				canvasTemp.height = imgHeight;
	
				// 그림을 그리고 현재 그림의 테이터를 담아둔다 
				tempContext.drawImage(scrollImg, 0, 0, imgWidth, imgHeight);
				imageData = tempContext.getImageData(0, 0, imgWidth, imgHeight);
	
				//캔버스 버퍼 객체에 펜을 담는다
				canvasBuffer = document.createElement("canvas");

				renderGame();
			},  1000);  //60
			*/
			
			
			
			// 적이 지정된 시간마다 움직임 // setTimeout, setInterval
			setInterval(() => {
				// 값 계산
				renderGame();
			},  1000 / 60);  //60
		
		}
		
		// 지우고 전체 다 다시 그려주는 곳
		function renderGame(){
			// 지우기
			ctx.clearRect(0, 0, canvas.width, canvas.height);
			
			// 배경 그리기
			ctx.drawImage(scrollImg, 0, 0);
			// ,새로 받은 배경의 값을 넣어야함 스크롤 이미지를 넣는게 아니고 위에서 반복되는 이미지 캡쳐부분만 그리는 걸걸
			// 원하는 부분만 캡처하는 방법이 뭐드라
			
			// 플레이어 그리기
			var rectangle = new Path2D();
  			rectangle.rect(playerUnit.x, playerUnit.y, playerUnit.width, playerUnit.height);
			ctx.fill(rectangle);
			
			// 단어장들 그리기

			
		}
	
		// 배경 이미지 로딩
		function loadImage() {
			
			if (scrollVal >= canvasHeight - speed) {
				scrollVal = 0;
			}
			/* 혹시 스크롤 한바퀴 다돌아 간경우 스크롤을 초기화한다 */

			scrollVal += speed;
			/* 지정된 속도를 기준으로 스크롤의 값이 늘어난다(그리는 위치가 변경된다) */
			
			/* 사용된 이미지의 폭과 너비를 저장하고 그림용 펜의 역할을 수행하는 캔버스 템프에도 담아둔다  */
			imgWidth = scrollImg.width;
			imgHeight = scrollImg.height;
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
			playerUnit = {
					x : 100,
					y : 330,
					width : 150,
					height : 150
			};
		}

		// 한글 객체를 만드는 곳
		function makeEnemyHangulUnit(){
			EnemyHangul={
				x:0,
				y:0,
				width:0,
				height:0
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
			
			calcKeyInnput(); // 방향키 입력 // 플레이어 위치값 
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
			calcKeyInnput(); // 방향키 입력 // 플레이어 위치값 
		}
		// 방향키 입력 처리
		function calcKeyInnput() {
			if (keyPressOn["287"] && playerUnit.y >= -playerUnit.height / 2)
				//console.log("287");
			if (keyPressOn["283"] && playerUnit.y <= canvas.height - playerUnit.height / 2)
				//console.log("283");
			if (keyPressOn["265"] && playerUnit.x >= -playerUnit.width / 2)
				//console.log("265");
			if (keyPressOn["268"] && playerUnit.x <= canvas.width - playerUnit.width / 2)
				//console.log("268");
			
			console.log("spacekey"+spacekey);

			if(spacekey){
				if(!oneSpacekey){
				playerUnit.y-=75;
				oneSpacekey=true;
				}
			}else{
				playerUnit.y+=75;
				oneSpacekey=false;
			}
			// 그림 다시 그리기
			renderGame();
		}
		
		// 배경음악 객체 채워주기
		function makeBackGroungMusic(){
			backGroundMusic = document.createElement("audio");
			backGroundMusic.volume = 1.0;
			// BackGroundMusic.src = "<c:url value="../resources/sound/war.mp3"/>"; // 안됨
			backGroundMusic.src = "../resources/sound/war.mp3";
			backGroundMusic.setAttribute('id', 'backGroundMusic');
			document.body.appendChild(backGroundMusic);
		}
		
		// 스타트 버튼 클릭 시 
		$('#startBtn').click(function(){
    		$('#startBtn').remove(); // 스타트 버튼을 화면에서 없애기
			loadGame(); // 시작버튼을 누르면 해당 함수가 실행되게 변경
		});
	});