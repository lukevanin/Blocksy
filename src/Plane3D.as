package
{
	public class Plane3D extends Shape3D
	{
		public function Plane3D(w:Number, h:Number, color:Vector.<Number>)
		{
			super()
			
			w *= 0.5;
			h *= 0.5;
			
			var r:Number = color[0];
			var g:Number = color[1];
			var b:Number = color[2];
			var a:Number = color[3];
			
			vertices = new <Number>[
				-w, -h, 0,  0, 0, -1,  0, 0,  r, g, b, a, 
				-w, +h, 0,  0, 0, -1,  0, 1,  r, g, b, a,
				+w, +h, 0,  0, 0, -1,  1, 1,  r, g, b, a,
				+w, -h, 0,  0, 0, -1,  1, 0,  r, g, b, a,
			];
			
			indices = new <uint>[
				0, 1, 2,
				2, 3, 0,
			];				
		}
		
		final public function calculateNormals():void
		{
			calculateNormal(0, 3, 0, 1);
			calculateNormal(1, 0, 1, 2);
			calculateNormal(2, 1, 2, 3);
			calculateNormal(3, 2, 3, 0);
		}
		
		final public function setuv(uv:Vector.<Number>):void
		{
			for (var i:int = 0, j:int = 0, n:int = vertices.length; i < n; i += DATA_PER_VERTEX, j += 2) {
				vertices[i + U] = uv[j];
				vertices[i + V] = uv[j + 1];
			}
		}
	}
}