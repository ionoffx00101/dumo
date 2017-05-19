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
<style>
canvas {
	position: absolute;
	top: 0px;
	left: 0px;
	background: transparent;
}
</style>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script type="text/javascript">
/**
 * Initialize the Game and starts it.
 */
var game = new Game();

function init() {
	if(game.init())
		game.start();
}

var imageRepository = new function() {
	// Define images
	this.empty = null;
	this.background = new Image();
	
	// Set images src
	this.background.src = "<%=cp%>/resources/images/city.png";
}

function Drawable() {	
	this.init = function(x, y) {
		// Defualt variables
		this.x = x;
		this.y = y;
	}

	this.speed = 0;
	this.canvasWidth = 0;
	this.canvasHeight = 0;
	
	// Define abstract function to be implemented in child objects
	this.draw = function() {
	};
}

function Background() {
	this.speed = 1; // Redefine speed of the background for panning

	// Implement abstract function
	this.draw = function() {
		//clear canvas
		this.context.clearRect(0, 0, 1000, 500);
		// Pan background
		this.x -= this.speed;
		this.context.drawImage(imageRepository.background, this.x, this.y);
		
		// Draw another image at the top edge of the first image
		this.context.drawImage(imageRepository.background, this.x+ this.canvasHeight, this.y );

		// If the image scrolled off the screen, reset
		if (this.x >= this.canvasHeight)
			this.x = 1937;
	};
}
// Set Background to inherit properties from Drawable
Background.prototype = new Drawable();

function Game() {

	this.init = function() {
		// Get the canvas element
		this.bgCanvas = document.getElementById('background');
		
		// Test to see if canvas is supported
		if (this.bgCanvas.getContext) {
			this.bgContext = this.bgCanvas.getContext('2d');
			
			// Initialize objects to contain their context and canvas
			// information
			Background.prototype.context = this.bgContext;
			Background.prototype.canvasWidth = this.bgCanvas.width;
			Background.prototype.canvasHeight = this.bgCanvas.height;
			
			// Initialize the background object
			this.background = new Background();
			this.background.init(0,0); // Set draw point to 0,0
			return true;
		} else {
			return false;
		}
	};
	
	// Start the animation loop
	this.start = function() {
		animate();
	};
}


/**
 * The animation loop. Calls the requestAnimationFrame shim to
 * optimize the game loop and draws all game objects. This
 * function must be a gobal function and cannot be within an
 * object.
 */
function animate() {
	requestAnimFrame( animate );
	game.background.draw();
}


/**	
 * requestAnim shim layer by Paul Irish
 * Finds the first API that works to optimize the animation loop, 
 * otherwise defaults to setTimeout().
 */
window.requestAnimFrame = (function(){
	return  window.requestAnimationFrame       || 
			window.webkitRequestAnimationFrame || 
			window.mozRequestAnimationFrame    || 
			window.oRequestAnimationFrame      || 
			window.msRequestAnimationFrame     || 
			function(/* function */ callback, /* DOMElement */ element){
				window.setTimeout(callback, 1000 / 60);
			};
})();
</script>
</head>
<body onload="init()">
	<!-- The canvas for the panning background -->
	<canvas id="background" width="1000" height="500"> Your browser
	does not support canvas. Please try again with a different browser. </canvas>
</body>
</html>