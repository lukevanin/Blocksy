package
{
	import com.adobe.utils.AGALMiniAssembler;
	import com.adobe.utils.PerspectiveMatrix3D;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
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
	import flash.display3D.Context3DClearMask;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	public class Blocks extends Sprite
	{
//		[Embed(source="..\\assets\\textures\\grid-test.png")]
//		private static const TestTextureClass:Class;

		[Embed(source="..\\assets\\textures\\texture-wall.png")]
		private static const WallTextureClass:Class;

		[Embed(source="..\\assets\\textures\\texture-block.png")]
		private static const BlockTextureClass:Class;

		[Embed(source="..\\assets\\textures\\texture-block-placed.png")]
		private static const PlaceTexture:Class;
		
		private var stage3D:Stage3D;
		private var context3D:Context3D;
		private var worldMatrix:Matrix3D;
		private var viewMatrix:Matrix3D;
		private var projectionMatrix:PerspectiveMatrix3D;
		private var keys:Dictionary;
		private var qStart:Quaternion;
		private var qEnd:Quaternion;
		private var qCurrent:Quaternion;
		private var p:Vector3D;
		private var r:Vector3D;
		private var i:Number;
		private var j:Number;
		private var vCurrent:Vector3D;
		private var vEnd:Vector3D;
		private var vStart:Vector3D;
		private var polyominos:Vector.<Polyomino>;
		private var index:int;
		private var shape:Shape3D;
		private var grid:Shape3D;
		private var gridWidth:int;
		private var gridHeight:int;
		private var gridDepth:int;
		private var wallTexture:Texture;
		private var blockTexture:Texture;
		private var cells:Vector.<Number>;
		private var polyomino:Polyomino;
		private var places:Shape3D;
		private var placeTexture:Texture;
		
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
			context3D = stage3D.context3D;
			
			trace(">> driverInfo=" + context3D.driverInfo);
			
			context3D.enableErrorChecking = true;
			
			updateContext();
			
//			context3D.setCulling(Context3DTriangleFace.FRONT);
//			context3D.setCulling(Context3DTriangleFace.BACK);
//			context3D.setCulling(Context3DTriangleFace.NONE);

			wallTexture = createMipTexture((new WallTextureClass() as Bitmap).bitmapData);
			blockTexture = createMipTexture((new BlockTextureClass() as Bitmap).bitmapData);
			placeTexture = createMipTexture((new PlaceTexture() as Bitmap).bitmapData);
			
//			vertexShader = assembleVertexShader( 
//				"m44 op, va0, vc0\n" +
//				"mov v0, va1");
			
			//			fragmentShader = assembleFragmentShader(
			//				"mov oc, v0");			
			
//			fragmentShader = assembleFragmentShader(
//				"tex ft0, v0, fs0 <2d,repeat,miplinear>\n" +
//				"mov oc, ft0");
			
			//			fragmentShader = assembleFragmentShader(
			//				"tex ft0, v0, fs0 <2d,repeat,linear> \n" + //sample texture
			//				"div ft0.rgb, ft0.rgb, ft0.a \n" +  // un-premultiply png
			//				"mov oc, ft0" //output fixed RGB
			//				);
			
			polyominos = new Vector.<Polyomino>();
			
			// One
			addPolyomino(new <Number>[
				0, 0, 0,
				]);
			
			// Two
			addPolyomino(new <Number>[
				0, 0, 0,
				1, 0, 0,
				]);

			// Three
			addPolyomino(new <Number>[
				0, 0, 0,
				1, 0, 0,
				2, 0, 0,
				]);

			// Four
			addPolyomino(new <Number>[
				0, 0, 0,
				1, 0, 0,
				2, 0, 0,
				3, 0, 0,
				]);
			
			// Short L
			addPolyomino(new <Number>[
				0, 0, 0,
				1, 0, 0,
				0, 1, 0
				]);
			
			// Long L
			addPolyomino(new <Number>[
				0, 0, 0,
				1, 0, 0,
				0, 1, 0,
				0, 2, 0
				]);
			
			// T
			addPolyomino(new <Number>[
				0, 0, 0,
				-1, 0, 0,
				+1, 0, 0,
				0, 1, 0
				]);
			
			// Square
			addPolyomino(new <Number>[
				0, 0, 0,
				1, 0, 0,
				1, 1, 0,
				0, 1, 0
				]);
			
			// Plus
			addPolyomino(new <Number>[
				0, 0, 0,
				1, 0, 0,
				-1, 0, 0,
				0, 1, 0,
				0, -1, 0
			]);
			
			// Zig-zag
			addPolyomino(new <Number>[
				0, 0, 0,
				-1, 0, 0,
				0, 1, 0,
				1, 1, 0
				]);
			
			// C
			addPolyomino(new <Number>[
				0, 0, 0,
				0, 1, 0,
				0, -1, 0,
				1, 1, 0,
				1, -1, 0
			]);
			
			// Long Zig-zag
			addPolyomino(new <Number>[
				0, 0, 0,
				0, 1, 0,
				0, -1, 0,
				1, 1, 0,
				-1, -1, 0
			]);
			
			// 3D corner
			addPolyomino(new <Number>[
				0, 0, 0,
				1, 0, 0,
				0, -1, 0,
				0, 0, -1
				]);
			
			// 3D Offset corner 1
			addPolyomino(new <Number>[
				0, 0, 0,
				1, 0, 0,
				1, 0, -1,
				0, -1, 0,
				]);
			
			// 3D Offset corner 1
			addPolyomino(new <Number>[
				0, 0, 0,
				1, 0, 0,
				0, -1, -1,
				0, -1, 0,
				]);
			
			// 3D T
			addPolyomino(new <Number>[
				0, 0, 0,
				1, 0, 0,
				-1, 0, 0,
				0, -1, 0,
				0, 0, -1
				]);
			
			// 3D Zig-zag
			addPolyomino(new <Number>[
				0, 0, 0,
				1, 0, 0,
				1, 0, -1,
				0, -1, 0,
				0, -1, 1
				]);
			
			// Long Zig-zag
			addPolyomino(new <Number>[
				0, 0, 0,
				0, 1, 0,
				0, -1, 0,
				1, 1, 0,
				0, -1, -1
			]);			
			index = 0;
			
			gridWidth = 5;
			gridHeight = 5;
			gridDepth = 2;
			
			updateGrid();
			updateShape();
			updatePlaces();
			
			p = new Vector3D();
			r = new Vector3D();
			
			worldMatrix = new Matrix3D();
			
			viewMatrix = new Matrix3D();

			projectionMatrix = new PerspectiveMatrix3D();
			
			i = 0;
			j = 0;
			
			keys = new Dictionary();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKey);
			stage.addEventListener(KeyboardEvent.KEY_UP, handleKey);
			
			addEventListener(Event.ENTER_FRAME, handleFrame);
			addEventListener(Event.RESIZE, handleResize);
			addEventListener(Event.FULLSCREEN, handleResize);
		}
		
//		private function assembleVertexShader(input:String):ByteArray
//		{
//			return assemble(Context3DProgramType.VERTEX, input);
//		}
		
//		private function assembleFragmentShader(input:String):ByteArray
//		{
//			return assemble(Context3DProgramType.FRAGMENT, input);
//		}
		
//		private function assemble(type:String, input:String):ByteArray
//		{
//			var assembler:AGALMiniAssembler = new AGALMiniAssembler();
//			assembler.assemble(type, input);
//			return assembler.agalcode;
//		}
		
		private function createMipTexture(input:BitmapData):Texture
		{
			var w:int = input.width;
			var h:int = input.height;
			var level:int = 0;
			var scale:Number = 1;
			
			var output:Texture = context3D.createTexture(w, h, Context3DTextureFormat.BGRA, false);
			
			while ((w > 0) && (h > 0)) {
				var m:Matrix = new Matrix();
				m.scale(scale, scale);
				
				var bitmapData:BitmapData = new BitmapData(w, h, true, 0);
				bitmapData.draw(input, m, null, null, null, true);
				output.uploadFromBitmapData(bitmapData, level);
				
				w *= 0.5;
				h *= 0.5;
				level ++;
				scale *= 0.5; 
				
			}
			
			return output;
		}
		
		private function addPolyomino(points:Vector.<Number>):void
		{
			polyominos.push(Polyomino.createFromPoints(points));
		}
		
		private function updateGrid():void
		{
			grid = new Grid3D(gridWidth, gridHeight, gridDepth);
			grid.texture = wallTexture;
			
			cells = new Vector.<Number>(gridWidth * gridHeight * gridDepth, true);
			
			for (var z:int = 0; z < gridDepth; z++) {
				for (var y:int = 0; y < gridHeight; y++) {
					for (var x:int = 0; x < gridWidth; x++) {
						setCell(x, y, z, 0);
					}
				}
			}
		}
		
		private function updatePlaces():void
		{
			places = new Shape3D();
			places.texture = placeTexture;
			
			for (var z:int = 0; z < gridDepth; z++) {
				for (var y:int = 0; y < gridHeight; y++) {
					for (var x:int = 0; x < gridWidth; x++) {
						if (getCell(x, y, z) != 0) {
							var m:Matrix3D = new Matrix3D();
							m.appendTranslation(x, y, z);

							var cube:Cube3D = new Cube3D();
							cube.transform(m);
							
							places.append(cube);
						}
					}
				}
			}
		}
		
		private function updateShape():void
		{
			var min:int = 0;
			var max:int = polyominos.length - 1;
			
			if (index < min)
				index = max;
			
			if (index > max)
				index = min;
			
//			polyomino = polyominos[index].toWireframeShape3D();
			
			polyomino = polyominos[index]
			shape = polyomino.toShape3D();
			shape.texture = blockTexture;
			
			resetRotation();
			resetPosition();
		}
		
		private function resetRotation():void
		{
			qStart = Quaternion.createFromEuler(0, 0, 0);
			qEnd = Quaternion.createFromEuler(0, 0, 0);
			qCurrent = Quaternion.createFromEuler(0, 0, 0);
		}
		
		private function resetPosition():void
		{
			var x:int = gridWidth * 0.5;
			var y:int = gridHeight * 0.5;
			var z:int = 1;
			
			vStart = new Vector3D(x, y, z);
			vEnd = new Vector3D(x, y, z);
			vCurrent = new Vector3D(x, y, z);			
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
			var rotate:Boolean = false;
			var move:Boolean = false;
			var check:Boolean = false;
			
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
				rotate = true;
			}
			
			if (isKeyPressed(Keyboard.S)) {
				r.x = +a;
				rotate = true;
			}
			
			if (isKeyPressed(Keyboard.A)) {
				r.y = -a;
				rotate = true;
			}
			
			if (isKeyPressed(Keyboard.D)) {
				r.y = +a;
				rotate = true;
			}
			
			if (isKeyPressed(Keyboard.Q)) {
				r.z = -a;
				rotate = true;
			}
			
			if (isKeyPressed(Keyboard.E)) {
				r.z = +a;
				rotate = true;				
			}
			
			if (isKeyPressed(Keyboard.LEFT)) {
				p.x = -d;
				move = true;
			}
			
			if (isKeyPressed(Keyboard.RIGHT)) {
				p.x = +d;
				move = true;
			}
			
			if (isKeyPressed(Keyboard.UP)) {
				p.y = +d;
				move = true;
			}
			
			if (isKeyPressed(Keyboard.DOWN)) {
				p.y = -d;
				move = true;
			}
			
			if (isKeyPressed(Keyboard.EQUAL)) {
				p.z = -d;
				move = true;
			}
			
			if (isKeyPressed(Keyboard.MINUS)) {
				p.z = +d;
				move = true;
			}
			
			if (isKeyPressed(Keyboard.COMMA)) {
				index --;
				updateShape();
			}
			
			if (isKeyPressed(Keyboard.PERIOD)) {
				index ++;
				updateShape();
			}
			
			if (isKeyPressed(Keyboard.ENTER)) {
				check = true;
			}
			
			if (isKeyPressed(Keyboard.SPACE)) {
				p.z = +d;
				check = true;
				move = true;
			}
			
			if (isKeyPressed(Keyboard.F)) {
				toggleFullScreen();
			}
			
			if (rotate || move || check) {
				var rotation:Quaternion;
				var position:Vector3D;
				
				if (rotate) {
					var q:Quaternion = new Quaternion();
					q.fromEuler(r.x, r.y, r.z);
					
					rotation = new Quaternion();
					rotation.multiply(qEnd, q);
					rotation.normalise();
				}
				else {
					rotation = qEnd;
				}
				
				if (move) {
					position = vEnd.add(p);
				}
				else {
					position = vEnd;
				}
				
				var pending:Polyomino = polyomino.clone(); 
				pending.transform(getPolyominoMatrix(position, rotation));
				pending.normalise();
				
				if (check) {
					if (checkCollision(pending)) {
						fillCells(pending.points);
						updatePlaces();
						updateShape();
						return;
					}
				}
				
				if ((rotate || move) && checkMove(pending)) {

					if (rotate) {
						i = 0;
						qStart.copy(qCurrent);
						qEnd.multiply(qEnd.clone(), q);
						qEnd.normalise();						
					}
					
					if (move) {
						j = 0;
						vStart.copyFrom(vCurrent);
						vEnd = vEnd.add(p);
					}

				}
			}
		}
		
		private function fillCells(points:Vector.<Number>):void
		{
			for (var i:int = 0, n:int = points.length; i < n; i+= 3) {
				var x:Number = points[i];
				var y:Number = points[i + 1];
				var z:Number = points[i + 2];
				setCell(x, y, z, 1);
			}
		}
		
		private function fillGrid(input:Shape3D):void
		{
			grid.append(input);
		}
		
		private function checkCollision(input:Polyomino):Boolean
		{
			var points:Vector.<Number> = input.points;
			
			for (var i:int = 0, n:int = points.length; i < n; i+= 3) {
				var x:Number = points[i];
				var y:Number = points[i + 1];
				var z:Number = points[i + 2] + 1;
				
				if (!isCoordinateValid(x, y, z) || (getCell(x, y, z) != 0))
					return true;
			}			
			
			return false;
		}
		
		private function checkMove(input:Polyomino):Boolean
		{
			var points:Vector.<Number> = input.points;
			
			for (var i:int = 0, n:int = points.length; i < n; i+= 3) {
				var x:Number = points[i];
				var y:Number = points[i + 1];
				var z:Number = points[i + 2];
				
				if (!isCoordinateValid(x, y, z) || (getCell(x, y, z) != 0))
					return false;
			}			
			
			return true;
		}
		
		private function setCell(x:int, y:int, z:int, value:Number):void
		{
			cells[(z * gridWidth * gridHeight) + (y * gridWidth) + x] = value;
		}
		
		private function getCell(x:int, y:int, z:int):Number
		{
			return cells[(z * gridWidth * gridHeight) + (y * gridWidth) + x];
		}
		
		private function isCoordinateValid(x:int, y:int, z:int):Boolean
		{
			return ((x >= 0) && (x < gridWidth) && (y >= 0) && (y < gridHeight) && (z >= 0) && (z < gridDepth));
		}
		
		private function toggleFullScreen():void
		{
			if (stage.displayState != StageDisplayState.NORMAL)
				stage.displayState = StageDisplayState.NORMAL;
			else
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			
			updateContext();
		}
		
		private function handleResize(event:Event):void
		{
			updateContext();
		}
		
		private function updateContext():void
		{
			context3D.configureBackBuffer(stage.stageWidth, stage.stageHeight, 2, true);			
		}
		
		private function getPolyominoMatrix(position:Vector3D, rotation:Quaternion):Matrix3D
		{
			var output:Matrix3D = rotation.toMatrix3D();
			output.appendTranslation(position.x, position.y, position.z);
			return output;
		}
		
		private function interpolateVector(output:Vector3D, a:Vector3D, b:Vector3D, i:Number):void
		{
			output.x = a.x + (b.x - a.x) * i;
			output.y = a.y + (b.y - a.y) * i;
			output.z = a.z + (b.z - a.z) * i;
			output.w = a.w + (b.w - a.w) * i;
		}
		
		private function handleFrame(event:Event):void
		{
			var aspect:Number = stage.stageWidth / stage.stageHeight;
			var zNear:Number = 0.1;
			var zFar:Number = 50;
			var fov:Number = 45 * Math.PI / 180;
			
			projectionMatrix.perspectiveFieldOfViewLH(fov, aspect, zNear, zFar);

			
			
			//
			i = i + ((1 - i) * 0.125);
			i = Math.min(i, 1);

			j = j + ((1 - j) * 0.125);
			j = Math.min(j, 1);
			
			qCurrent.lerp(qStart, qEnd, i);
			qCurrent.normalise();
		
			interpolateVector(vCurrent, vStart, vEnd, j);
			
			worldMatrix.identity();
//			worldMatrix.appendTranslation((-gridWidth * 0.5) + 0.5, (-gridHeight * 0.5) + 0.5, gridHeight + 2);
			worldMatrix.appendTranslation(0.5, 0.5, 0.5);
			
			viewMatrix.identity();
			viewMatrix.appendTranslation(-gridWidth * 0.5, -gridHeight * 0.5, gridHeight + 2);			
			
			var m:Matrix3D;
			var _m:Matrix3D;

			context3D.clear(1.0, 1.0, 1.0, 1.0);
			context3D.setCulling(Context3DTriangleFace.BACK);
			
			
			m = new Matrix3D();
			m.appendTranslation(-0.5, -0.5, -0.5);
			m.append(worldMatrix);
			
			_m = m.clone();
			_m.transpose();
			_m.invert();
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, _m, true); //vc4
			
			m.append(viewMatrix);
			m.append(projectionMatrix);
			
			grid.matrix = m;

			grid.render(context3D);

			
			m = new Matrix3D();
			m.append(worldMatrix);
			
			_m = m.clone();
			_m.transpose();
			_m.invert();
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, _m, true); //vc4
			
			m.append(viewMatrix);
			m.append(projectionMatrix);
			
			places.matrix = m;

			places.render(context3D);

			
			
			m = getPolyominoMatrix(vCurrent, qCurrent);
			m.append(worldMatrix);
			
			_m = m.clone();
			_m.transpose();
			_m.invert();
			context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, _m, true); //vc4
			
			m.append(viewMatrix);			
			m.append(projectionMatrix);

			shape.matrix = m;
			
			context3D.setCulling(Context3DTriangleFace.BACK);
			shape.render(context3D);
			
			context3D.present();
		}
	}
}