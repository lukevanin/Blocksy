package
{
	public class Plane3D extends Shape3D
	{
		public function Plane3D(w:Number = 1, h:Number = 1)
		{
			super()
			
			w *= 0.5;
			h *= 0.5;
			
			vertices = new <Number>[
				-w, -h, 0,  0, 0, -1,  0, 0,
				-w, +h, 0,  0, 0, -1,  0, 1,
				+w, +h, 0,  0, 0, -1,  1, 1,
				+w, -h, 0,  0, 0, -1,  1, 0,
			];
			
			indices = new <uint>[
				0, 1, 2,
				2, 3, 0,
			];				
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