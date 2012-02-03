package
{
	import com.adobe.utils.AGALMiniAssembler;
	import com.adobe.utils.PerspectiveMatrix3D;
	
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	public class QuaternionTest extends Sprite
	{
		private var stage3D:Stage3D;
		private var context3D:Context3D;
		private var vertexBuffer:VertexBuffer3D;
		private var indexBuffer:IndexBuffer3D;
		private var program:Program3D;
		private var projectionMatrix:PerspectiveMatrix3D;
		private var qA:Quaternion;
		private var qB:Quaternion;
		private var isMouseDown:Boolean;
		private var startPoint:Point;
		private var endPoint:Point;
		private var qC:Quaternion;
		private var delta:Point;
		private var total:Point;
		
		public function QuaternionTest()
		{
			super();
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.quality = StageQuality.LOW;
			stage.frameRate = 60;
			
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

			context3D.configureBackBuffer(stage.stageWidth, stage.stageHeight, 2, true);
			
			context3D.setCulling(Context3DTriangleFace.FRONT);
			
			var shape:Cube3D = new Cube3D();
			
			var numVertices:int = 8;
			var dataPerVertex:int = 6;
			var numIndices:int = shape.indices.length;
			
			vertexBuffer = context3D.createVertexBuffer(numVertices, dataPerVertex);
			vertexBuffer.uploadFromVector(shape.vertices, 0, numVertices);
			
			indexBuffer = context3D.createIndexBuffer(numIndices);
			
			indexBuffer.uploadFromVector(shape.indices, 0, numIndices);
			
			var vertexShader:ByteArray = assembleVertexShader( 
				"m44 op, va0, vc0\n" +
				"mov v0, va1");
			
			var fragmentShader:ByteArray = assembleFragmentShader(
				"mov oc, v0");
			
			program = context3D.createProgram();
			program.upload(vertexShader, fragmentShader);

			qA = new Quaternion();
			qA.fromEuler(0, 0, 0);
			
			qB = new Quaternion();
			qB.fromEuler(0, 0, 0);
			
			qC = new Quaternion();
			qC.fromEuler(0, 0, 0);

			startPoint = new Point();
			endPoint = new Point();
			delta = new Point();
			total = new Point();
						
			var aspect:Number = stage.stageWidth / stage.stageHeight;
			var zNear:Number = 0.1;
			var zFar:Number = 1000;
			var fov:Number = 45 * Math.PI / 180;
			
			projectionMatrix = new PerspectiveMatrix3D();
			projectionMatrix.perspectiveFieldOfViewLH(fov, aspect, zNear, zFar);			

//			context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
//			context3D.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
//			context3D.setProgram(program);
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, handleMouse);
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouse);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouse);
			addEventListener(Event.ENTER_FRAME, handleFrame);
		}
		
		private function assembleVertexShader(input:String):ByteArray
		{
			return assemble(Context3DProgramType.VERTEX, input);
		}
		
		private function assembleFragmentShader(input:String):ByteArray
		{
			return assemble(Context3DProgramType.FRAGMENT, input);
		}
		
		private function assemble(type:String, input:String):ByteArray
		{
			var assembler:AGALMiniAssembler = new AGALMiniAssembler();
			assembler.assemble(type, input);
			return assembler.agalcode;
		}
		
		private function handleMouse(event:MouseEvent):void
		{
			if (event.type == MouseEvent.MOUSE_DOWN) {
				isMouseDown = true;
//				qA.copy(qC);
				startPoint = new Point(event.stageX, event.stageY);
				endPoint = startPoint.clone();
				calculateRotation();
			}
			else if (event.type == MouseEvent.MOUSE_UP) {
				isMouseDown = false;
			}
			else if (event.type == MouseEvent.MOUSE_MOVE) {
				if (isMouseDown) {
					startPoint = endPoint.clone();
					endPoint = new Point(event.stageX, event.stageY);
					calculateRotation();
				}
			}
		}
		
		private function calculateRotation():void
		{
			delta = new Point(endPoint.x- startPoint.x, endPoint.y - startPoint.y);
//			trace("delta=" + delta);
//			qB.fromEuler(delta.y / 100, delta.x / 100, 0);
		}
		
		private function handleFrame(event:Event):void
		{
			if (context3D) {
				var v:Vector3D;
				
				context3D.clear(1.0, 1.0, 1.0, 1.0);
				
				context3D.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
				context3D.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_3);
				context3D.setProgram(program);
				
//				var t:Number = getTimer() / 1000;
				
				delta.x *= 0.9;
				delta.y *= 0.9;
				
				total.x += delta.x;
				total.y += delta.y;

				total.x *= 0.9;
				total.y *= 0.9;
				
				qB.fromEuler(total.y * 0.0005, total.x * 0.0005, 0);
				
				qA.copy(qC);
				qC.multiply(qA, qB);			

				var m:Matrix3D = qC.toMatrix3D();
				
//				m.appendRotation(getTimer() / 20, Vector3D.X_AXIS);
//				m.appendRotation(getTimer() / 100, Vector3D.Y_AXIS);
//				m.appendRotation(getTimer() / 4000, Vector3D.Z_AXIS);
				
				m.appendTranslation(0, 0, 5);
				
				m.append(projectionMatrix);
				
				context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, m, true);
				
				context3D.drawTriangles(indexBuffer);
				context3D.present();
			}
		}
	}
}