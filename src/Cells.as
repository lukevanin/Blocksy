package
{
	public class Cells
	{
		private var width:int;
		private var height:int;
		private var depth:int;
		private var cells:Vector.<uint>;
		
		public function Cells(width:int, height:int, depth:int)
		{
			super();
			this.width = width;
			this.height = height;
			this.depth = depth;
			cells = new Vector.<uint>(width * height * depth, true);
		}
		
		final public function set(x:int, y:int, z:int, value:uint):void
		{
			cells[offset(x, y, z)] = value;
		}
		
		final public function get(x:int, y:int, z:int):uint
		{
			return cells[offset(x, y, z)];
		}
		
		final public function isValid(x:int, y:int, z:int):Boolean
		{
			return ((x >= 0) && (x < width) && (y >= 0) && (y < height) && (z >= 0) && (z < depth));
		}		
		
		final public function setCoordinates(points:Vector.<Number>, value:int):void
		{
			for (var i:int = 0, n:int = points.length; i < n; i+= 3) {
				var x:Number = points[i];
				var y:Number = points[i + 1];
				var z:Number = points[i + 2];
				set(x, y, z, value);
			}
		}
		
		final public function fill(value:int):void
		{
			for (var z:int = 0; z < depth; z++) {
				for (var y:int = 0; y < height; y++) {
					for (var x:int = 0; x < width; x++) {
						set(x, y, z, value);
					}
				}
			}
		}
		
		private function offset(x:int, y:int, z:int):int
		{
			return (z * width * height) + (y * width) + x;
		}
	}
}