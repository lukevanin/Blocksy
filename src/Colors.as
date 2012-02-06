package
{
	public class Colors
	{
		private var colors:Vector.<Vector.<Number>>;
		
		public function Colors()
		{
			super();
			colors = new Vector.<Vector.<Number>>();
		}
		
		final public function get count():uint
		{
			return colors.length;
		}
		
		final public function add(input:Vector.<Number>):void
		{
			colors.push(new <Number>[input[0], input[1], input[2], input[3]]);
		}
		
		final public function get(index:uint):Vector.<Number>
		{
			return colors[index % count];
		}
	}
}