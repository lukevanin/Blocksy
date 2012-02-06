package
{
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	// TODO: fix bug where parts extend past edges of grid
	public class Blocks extends Sprite
	{
		[Embed(source="..\\assets\\textures\\grid-transparent.png")]
		private static const TransparentGridTextureClass:Class;

		[Embed(source="..\\assets\\textures\\grid-opaque.png")]
		private static const OpaqueGridTextureClass:Class;

		[Embed(source="..\\assets\\textures\\texture-wall.png")]
		private static const WallTextureClass:Class;

		[Embed(source="..\\assets\\textures\\texture-block-placed-01.png")]
		private static const BlockTextureClass:Class;

		[Embed(source="..\\assets\\textures\\texture-block-placed-01.png")]
		private static const PlaceTextureClass:Class;

		private var stage3D:Stage3D;
		private var context:Context3D;
		private var viewMatrix:Matrix3D;
		private var projectionMatrix:PerspectiveMatrix3D;
		private var keys:Dictionary;
		private var shape:Shape3D;
		private var grid:Shape3D;
		private var gridWidth:int;
		private var gridHeight:int;
		private var gridDepth:int;
		private var wallTexture:Texture;
		private var blockTexture:Texture;
		private var polyomino:Polyomino;
		private var places:Shape3D;
		private var placeTexture:Texture;
		private var timer:Timer;
		private var wallMaterial:AmbientLightTextureMaterial;
		private var blockMaterial:AmbientLightTextureMaterial;
		private var placeMaterial:AmbientLightTextureMaterial;
		private var polyominos:Polyominos;
		private var cells:Cells;
//		private var piece:PolyominoController;
		private var finalRotation:Quaternion;
		private var finalPosition:Vector3D;
		private var rotationAnimator:QuaternionAnimator;
		private var positionAnimator:Vector3DAnimator;
		private var currentPosition:Vector3D;
		private var currentRotation:Quaternion;
		private var isGameRunning:Boolean;
		private var colors:Colors;
		
		public function Blocks()
		{
			super();
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.LOW;
			stage.frameRate = 1000;
			
			addEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
		}
		
		private function handleAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, handleAddedToStage);
			stage3D = stage.stage3Ds[0] as Stage3D;
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, handleContext3DCreate);
			stage3D.requestContext3D(Context3DRenderMode.AUTO);
		}
		
		private function handleContext3DCreate(event:Event):void
		{
			stage3D.removeEventListener(Event.CONTEXT3D_CREATE, handleContext3DCreate);
			context = stage3D.context3D;
			
			trace(">> driverInfo=" + context.driverInfo);
			
			context.enableErrorChecking = true;
			
			updateContext();

			viewMatrix = new Matrix3D();
			projectionMatrix = new PerspectiveMatrix3D();
			
			wallTexture = Util.createMipTexture(context, (new WallTextureClass() as Bitmap).bitmapData);
			blockTexture = Util.createMipTexture(context, (new BlockTextureClass() as Bitmap).bitmapData);
			placeTexture = Util.createMipTexture(context, (new PlaceTextureClass() as Bitmap).bitmapData);
			
			wallMaterial = AmbientLightTextureMaterial.create(wallTexture);
			blockMaterial = AmbientLightTextureMaterial.create(blockTexture);
			placeMaterial = AmbientLightTextureMaterial.create(placeTexture);
			
			polyominos = new Polyominos();
			
			var factory:TestPolyominosFactory = new TestPolyominosFactory(polyominos);
			factory.addSimple();
			factory.addFlat();
//			factory.addComplex();
			
			var a:Number = 0.25;
			var b:Number = 0.125;
			var c:Number = 0.0625;
			
			colors = new Colors();
			colors.add(new <Number>[a, c, c, 1]); // red
//			colors.add(new <Number>[a, b, c, 1]); // orange
			colors.add(new <Number>[a, a, c, 1]); // yellow
//			colors.add(new <Number>[b, a, c, 1]); // yellow green
			colors.add(new <Number>[c, a, c, 1]); // green
//			colors.add(new <Number>[c, a, b, 1]); // blue green
			colors.add(new <Number>[c, a, a, 1]); // cyan
//			colors.add(new <Number>[c, b, a, 1]); // green blue
			colors.add(new <Number>[c, c, a, 1]); // blue
//			colors.add(new <Number>[b, c, a, 1]); // purple blue
			colors.add(new <Number>[a, c, a, 1]); // magenta
//			colors.add(new <Number>[a, c, b, 1]); // magenta red
			
			polyominos.random();
			
			finalRotation = Quaternion.createFromEuler(0, 0, 0);
			currentRotation = finalRotation.clone();
			
			finalPosition = new Vector3D(0, 0, 0, 0);
			currentPosition = finalPosition.clone();
			
			rotationAnimator = QuaternionAnimator.create(currentRotation);
			positionAnimator = Vector3DAnimator.create(currentPosition);			
			
			gridWidth = 5;
			gridHeight = 5;
			gridDepth = 10;
			
			updateGrid();
			updatePolyomino();
			updatePlaces();
			
			keys = new Dictionary();
			
			addEventListener(Event.RESIZE, handleResize);
			addEventListener(Event.FULLSCREEN, handleResize);
			addEventListener(Event.ENTER_FRAME, handleFrame);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKey);
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKey);
			
			polyominos.addEventListener(Event.CHANGE, handlePolyominosChange);
			
			startGame();
		}
		
		private function startGame():void
		{
			if (!isGameRunning) {
				isGameRunning = true;
				reset();
			}
		}
		
		private function stopGame():void
		{
			isGameRunning = false;
			disposeTimer();
		}
		
		private function reset():void
		{
			cells.fill(0);
			updateGrid();
			updatePolyomino();
			updatePlaces();
			initialiseTimer();
			restartTimer();
			startGame();
		}
		
		private function handlePolyominosChange(event:Event):void
		{
			updatePolyomino();
		}
		
		private function updateGrid():void
		{
			grid = new Grid3D(gridWidth, gridHeight, gridDepth);
			grid.viewMatrix = viewMatrix;
			grid.projectionMatrix = projectionMatrix;
			
//			grid.texture = wallTexture;
			grid.material = wallMaterial;
			
			cells = new Cells(gridWidth, gridHeight, gridDepth);
			cells.fill(0);
			
			
//			cells = new Vector.<Number>(gridWidth * gridHeight * gridDepth, true);
//			
//			for (var z:int = 0; z < gridDepth; z++) {
//				for (var y:int = 0; y < gridHeight; y++) {
//					for (var x:int = 0; x < gridWidth; x++) {
//						setCell(x, y, z, 0);
//					}
//				}
//			}
		}
		
		private function updatePlaces():void
		{
			places = new Shape3D();
			places.viewMatrix = viewMatrix;
			places.projectionMatrix = projectionMatrix;
			places.material = placeMaterial;
			
			for (var z:int = 0; z < gridDepth; z++) {
				for (var y:int = 0; y < gridHeight; y++) {
					for (var x:int = 0; x < gridWidth; x++) {
						if (cells.get(x, y, z) != 0) {
							var m:Matrix3D = new Matrix3D();
							m.appendTranslation(x, y, z);

							var cube:Cube3D = new Cube3D(1, 1, 1, colors.get(gridDepth - z - 1));
							cube.transform(m);
				
							
							places.append(cube);
						}
					}
				}
			}
		}
		
		private function updatePolyomino():void
		{
			rotationAnimator.stop();
			positionAnimator.stop();
			restartTimer();

			polyomino = polyominos.current;
			
			shape = polyomino.toShape3D();
			shape.viewMatrix = viewMatrix;
			shape.projectionMatrix = projectionMatrix;
			
			shape.material = blockMaterial;
			
			
//			piece.rotation = Quaternion.createFromEuler(0, 0, 0);
			finalRotation.fromEuler(0, 0, 0);
			currentRotation.copy(finalRotation);
			
			var x:int = gridWidth * 0.5;
			var y:int = gridHeight * 0.5;
			var z:int = 1;
			
//			piece.position = new Vector3D(x, y, z);
			finalPosition.x = x;
			finalPosition.y = y;
			finalPosition.z = z;
			
			currentPosition.copyFrom(finalPosition);
			
		}
		
		private function handleKey(event:KeyboardEvent):void
		{
			if (event.type == KeyboardEvent.KEY_DOWN)
				keys[event.keyCode] = true;
			else if (event.type == KeyboardEvent.KEY_UP)
				delete keys[event.keyCode];
			
			updateKeys();
		}
		
		private function isKeyPressed(keyCode:uint):Boolean
		{
			return keys[keyCode] != undefined;
		}

		private function updateKeys():void
		{
			var krotate:Boolean = false;
			var kmove:Boolean = false;
			var kcheck:Boolean = false;
			
			var p:Vector3D = new Vector3D();
			var r:Vector3D = new Vector3D();
			
			p.x = 0;
			p.y = 0;
			p.z = 0;
			
			r.x = 0;
			r.y = 0;
			r.z = 0;
			
			var a:Number = 90 * Math.PI / 180;
			var d:Number = 1;
			
			if (isKeyPressed(Keyboard.W)) {
				r.x = -a;
				krotate = true;
			}
			
			if (isKeyPressed(Keyboard.S)) {
				r.x = +a;
				krotate = true;
			}
			
			if (isKeyPressed(Keyboard.A)) {
				r.y = -a;
				krotate = true;
			}
			
			if (isKeyPressed(Keyboard.D)) {
				r.y = +a;
				krotate = true;
			}
			
			if (isKeyPressed(Keyboard.Q)) {
				r.z = -a;
				krotate = true;
			}
			
			if (isKeyPressed(Keyboard.E)) {
				r.z = +a;
				krotate = true;				
			}
			
			if (isKeyPressed(Keyboard.LEFT)) {
				p.x = -d;
				kmove = true;
			}
			
			if (isKeyPressed(Keyboard.RIGHT)) {
				p.x = +d;
				kmove = true;
			}
			
			if (isKeyPressed(Keyboard.UP)) {
				p.y = +d;
				kmove = true;
			}
			
			if (isKeyPressed(Keyboard.DOWN)) {
				p.y = -d;
				kmove = true;
			}
			
			if (isKeyPressed(Keyboard.EQUAL)) {
				p.z = -d;
				kmove = true;
			}
			
			if (isKeyPressed(Keyboard.MINUS)) {
				p.z = +d;
				kmove = true;
			}
			
			if (isKeyPressed(Keyboard.R))
				reset();
			
			if (isKeyPressed(Keyboard.COMMA))
				polyominos.previous();
			
			if (isKeyPressed(Keyboard.PERIOD))
				polyominos.next();
			
			if (isKeyPressed(Keyboard.SLASH))
				polyominos.random();
			
			if (isKeyPressed(Keyboard.ENTER))
				kcheck = true;
			
			if (isKeyPressed(Keyboard.SPACE)) {
				p.z = +d;
//				kcheck = true;
				kmove = true;
				checkNextMove();
			}
			
			if (isKeyPressed(Keyboard.F))
				toggleFullScreen();
			
			if (isKeyPressed(Keyboard.T))
				toggleTimer();
			
			if (krotate)
				rotate(r.x, r.y, r.z);
			
			if (kmove)
				move(p);
			
			if (kcheck)
				checkNextMove();
		}
		
		private function rotate(x:Number, y:Number, z:Number):void
		{
			if (!isGameRunning)
				return;
			
			var q:Quaternion = new Quaternion();
			q.fromEuler(x, y, z);
			
			var rotation:Quaternion = new Quaternion();
			rotation.multiply(finalRotation, q);
			rotation.normalise();
			
//			var pending:Polyomino = polyomino.clone(); 
//			pending.transform(Util.getVectorQuaternionMatrix(finalPosition, rotation));
//			pending.normalise();
			
			var pending:Polyomino = getTransformedPolyomino(finalPosition, rotation);
			
			if (!checkPolyominoCollision(pending)) {
				finalRotation = rotation;
				rotationAnimator.animate(currentRotation.clone(), finalRotation, 0.25);
//				piece.animateRotation(finalRotation);
			}
		}
		
		private function move(input:Vector3D):void
		{
			if (!isGameRunning)
				return;
			
//			var p:Vector3D = new Vector3D(x, y, z);
			var position:Vector3D = finalPosition.add(input);
			
			var pending:Polyomino = getTransformedPolyomino(position, finalRotation);
			
			if (!checkPolyominoCollision(pending)) {
				finalPosition = position;
//				piece.animatePosition(finalPosition);
				positionAnimator.animate(currentPosition.clone(), finalPosition, 0.25);
			}
		}
		
		private function getTransformedPolyomino(position:Vector3D, rotation:Quaternion):Polyomino
		{
			var output:Polyomino = polyomino.clone(); 
			output.transform(Util.getVectorQuaternionMatrix(position, rotation));
			output.normalise();
			return output;
		}
		
		private function handleMoveComplete():void
		{
//			checkPlace();
		}
		
		private function handleRotateComplete():void
		{
//			checkPlace();
		}
		
		private function checkNextMove():void
		{
			if (!isGameRunning)
				return;
				
			var v:Vector3D = new Vector3D(0, 0, 1);
			var pending:Polyomino = getTransformedPolyomino(finalPosition.add(v), finalRotation);
			
			if (checkPolyominoCollision(pending)) {
				var current:Polyomino = getTransformedPolyomino(finalPosition, finalRotation);
				placePolyomino(current);
				checkLevelDelay();
			}
			else {
				move(v);
			}
		}
		
//		private function checkPlace():void
//		{
//			if (!isGameRunning || rotationAnimator.isAnimating || positionAnimator.isAnimating)
//			if (!isGameRunning || rotationAnimator.isAnimating || positionAnimator.isAnimating)
//				return;
			
//			var pending:Polyomino = getTransformedPolyomino(finalPosition, finalRotation);
//			
//			if (checkCollision(pending)) {
//				placePolyomino(pending);
//				checkLevelDelay();
//			}
//		}
		
		private function placePolyomino(input:Polyomino):void
		{
			cells.setCoordinates(input.points, 1);
			updatePlaces();
			polyominos.random();
		}
		
		private function checkEndGame():void
		{
			if (!isLevelFilled(0, 0) || !isLevelFilled(1, 0))
				stopGame();
		}
		
		private function checkLevelDelay():void
		{
			setTimeout(checkLevels, 250);			
		}
		
		private function checkLevels():void
		{
			clearCompletedLevels();
			updatePlaces();
			checkEndGame();
		}
		
		private function clearCompletedLevels():void
		{
			var j:int = gridDepth - 1;
			var i:int = j;
			
			while (i >= 0) {
				if (isLevelFilled(i, 1)) {
					clearLevel(i);
					dropLevel(i - 1);
					checkLevelDelay();
					return;
				}
				else {
					i--;
				}
			}
		}
		
		private function isLevelFilled(z:int, value:int):Boolean
		{
			for (var y:int = 0; y < gridHeight; y++) {
				for (var x:int = 0; x < gridWidth; x++) {
					if (cells.get(x, y, z) != value)
						return false;
				}
			}
			
			return true;
		}
		
		private function clearLevel(z:int):void
		{
			for (var y:int = 0; y < gridHeight; y++) {
				for (var x:int = 0; x < gridWidth; x++) {
					cells.set(x, y, z, 0);
				}
			}
		}
		
		private function dropLevel(z:int):void
		{
			if (z > 0) {
				for (var y:int = 0; y < gridHeight; y++) {
					for (var x:int = 0; x < gridWidth; x++) {
						cells.set(x, y, z + 1, cells.get(x, y, z));
					}
				}
				
				dropLevel(z - 1);
			}
			else if (z == 0) {
				clearLevel(0);
			}
		}
		
		private function fillGrid(input:Shape3D):void
		{
			grid.append(input);
		}
		
//		private function checkCollision(input:Polyomino):Boolean
//		{
//			var points:Vector.<Number> = input.points;
//			
//			for (var i:int = 0, n:int = points.length; i < n; i+= 3) {
//				var x:Number = points[i];
//				var y:Number = points[i + 1];
//				var z:Number = points[i + 2] + 1;
//				
//				if (!cells.isValid(x, y, z) || (cells.get(x, y, z) != 0))
//					return true;
//			}			
//			
//			return false;
//		}
		
		private function checkPolyominoCollision(input:Polyomino):Boolean
		{
			var points:Vector.<Number> = input.points;
			
			for (var i:int = 0, n:int = points.length; i < n; i+= 3) {
				var x:Number = points[i];
				var y:Number = points[i + 1];
				var z:Number = points[i + 2];
				
				if (!cells.isValid(x, y, z) || (cells.get(x, y, z) != 0))
					return true;
			}			
			
			return false;
		}
		
		private function toggleFullScreen():void
		{
			if (stage.displayState != StageDisplayState.NORMAL)
				stage.displayState = StageDisplayState.NORMAL;
			else
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			
			updateContext();
		}
		
		private function toggleTimer():void
		{
			if (timer == null)
				initialiseTimer();
			else
				disposeTimer();
		}
		
		private function initialiseTimer():void
		{
			if (timer == null) {
				timer = new Timer(1500);
				timer.addEventListener(TimerEvent.TIMER, handleTimer);
				timer.start();
			}
		}
		
		private function disposeTimer():void
		{
			if (timer != null) {
				timer.removeEventListener(TimerEvent.TIMER, handleTimer);
				timer.stop();
				timer = null;
			}
		}
		
		private function restartTimer():void
		{
			if (timer != null) {
				timer.reset();
				timer.start();
			}
		}
		
		private function handleTimer(event:TimerEvent):void
		{
			checkNextMove();
		}
		
		private function handleResize(event:Event):void
		{
			updateContext();
		}
		
		private function updateContext():void
		{
			context.configureBackBuffer(stage.stageWidth, stage.stageHeight, 2, true);			
		}
		
		private function handleFrame(event:Event):void
		{
//			checkPlace();
			
			var aspect:Number = stage.stageWidth / stage.stageHeight;
			var zNear:Number = 0.1;
			var zFar:Number = 50;
			var fov:Number = 60 * Math.PI / 180;
			
			projectionMatrix.perspectiveFieldOfViewLH(fov, aspect, zNear, zFar);
			
			//			
			viewMatrix.identity();
			viewMatrix.appendTranslation((-gridWidth * 0.5) + 0.5, (-gridHeight * 0.5) + 0.5, 5);
			
			var m:Matrix3D;

			context.clear(1.0, 1.0, 1.0, 1.0);
			context.setCulling(Context3DTriangleFace.BACK);
			context.setBlendFactors(Context3DBlendFactor.ONE, Context3DBlendFactor.ZERO);
			context.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
			
			// grid
			m = new Matrix3D();
			m.appendTranslation(-0.5, -0.5, -0.5);
			grid.worldMatrix = m;
			grid.render(context);

			
			// placed pieces
			m = new Matrix3D();
			places.worldMatrix = m;
			places.render(context);


			
			// polyomino
			m = Util.getVectorQuaternionMatrix(currentPosition, currentRotation);
			
			shape.worldMatrix = m;
			
			context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			context.setCulling(Context3DTriangleFace.FRONT);
			shape.render(context);
			
			context.setBlendFactors(Context3DBlendFactor.SOURCE_ALPHA, Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA);
			context.setCulling(Context3DTriangleFace.BACK);
			shape.render(context);
			
			context.present();
		}
	}
}