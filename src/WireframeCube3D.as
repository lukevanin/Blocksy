package
{
	import flash.geom.Matrix3D;

	public class WireframeCube3D extends Shape3D
	{
		public function WireframeCube3D(width:Number = 1, height:Number = 1, depth:Number = 1, thickness:Number = 0.01)
		{
			super();
			
			var w:Number = width * 0.5;
			var h:Number = height * 0.5;
			var d:Number = depth * 0.5;
			
			addSegment(0, -h, -d,  width - thickness, thickness, thickness);
			addSegment(0, +h, -d,  width - thickness, thickness, thickness);
			addSegment(-w, 0, -d,  thickness, height + thickness, thickness);
			addSegment(+w, 0, -d,  thickness, height + thickness, thickness);

			addSegment(0, -h, +d,  width - thickness, thickness, thickness);
			addSegment(0, +h, +d,  width - thickness, thickness, thickness);
			addSegment(-w, 0, +d,  thickness, height + thickness, thickness);
			addSegment(+w, 0, +d,  thickness, height + thickness, thickness);
			
			addSegment(-w, -h, 0,  thickness, thickness, depth - thickness);
			addSegment(+w, -h, 0,  thickness, thickness, depth - thickness);
			addSegment(-w, +h, 0,  thickness, thickness, depth - thickness);
			addSegment(+w, +h, 0,  thickness, thickness, depth - thickness);
		}
		
		private function addSegment(x:Number, y:Number, z:Number, width:Number, height:Number, depth:Number):void
		{
			var cube:Cube3D = new Cube3D(width, height, depth, new <Number>[0, 0, 0]);
			var matrix:Matrix3D = new Matrix3D();
			matrix.appendTranslation(x, y, z);
			cube.transform(matrix);
			append(cube);
		}
	}
}