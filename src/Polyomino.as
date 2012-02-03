package
{
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;

	public class Polyomino
	{
		public var points:Vector.<Number>
		
		public function Polyomino()
		{
			super();
			points = new Vector.<Number>();
		}
		
		final public function transform(input:Matrix3D):void
		{
			var output:Vector.<Number> = new Vector.<Number>(points.length);
			input.transformVectors(points, output);
			points = output;
		}
		
		final public function normalise():void
		{
			for (var i:int = 0, n:int = points.length; i < n; i ++)
				points[i] = Math.round(points[i]);
		}

		final public function clone():Polyomino
		{
			var output:Polyomino = new Polyomino();
			output.points = points.concat();
			return output;
		}
		
		final public function toShape3D():Shape3D
		{
			var output:Shape3D = new Shape3D();
			
			for (var i:int = 0, n:int = points.length; i < n; i += 3) {
				var x:Number = points[i];
				var y:Number = points[i + 1];
				var z:Number = points[i + 2];
				var matrix:Matrix3D = new Matrix3D();
				matrix.appendTranslation(x, y, z);
				
				var cube:Cube3D = new Cube3D(1, 1, 1);
				cube.transform(matrix);
				
				output.append(cube);
			}
			
			return output;
		}
		
		final public function toWireframeShape3D():Shape3D
		{
			var output:Shape3D = new Shape3D();
			
			for (var i:int = 0, n:int = points.length; i < n; i += 3) {
				var x:Number = points[i];
				var y:Number = points[i + 1];
				var z:Number = points[i + 2];
				var matrix:Matrix3D = new Matrix3D();
				matrix.appendTranslation(x, y, z);
				
				var cube:WireframeCube3D = new WireframeCube3D(1, 1, 1);
				cube.transform(matrix);
				
				output.append(cube);
			}
			
			return output;
		}
		
		public static function createFromPoints(input:Vector.<Number>):Polyomino
		{
			var output:Polyomino = new Polyomino();
			output.points = input;
			return output;
		}
	}
}