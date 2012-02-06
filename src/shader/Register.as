package shader
{
	final internal class Register extends Value
	{
		private var internalX:Scalar;
		private var internalY:Scalar;
		private var internalZ:Scalar;
		private var internalW:Scalar;
		private var internalXYZ:Value;
		
		public function Register(code:String)
		{
			super(code);
			internalX = scalar("x");
			internalY = scalar("y");
			internalZ = scalar("z");
			internalW = scalar("w");
			internalXYZ = value("xyz");
		}
		
		final public function get x():Scalar
		{
			return internalX;
		}
		
		final public function get y():Scalar
		{
			return internalY;
		}
		
		final public function get z():Scalar
		{
			return internalZ
		}
		
		final public function get w():Scalar
		{
			return internalW;
		}
		
		final public function get xyz():Value
		{
			return internalXYZ;
		}
		
		final public function get r():Scalar
		{
			return internalX;
		}
		
		final public function get g():Scalar
		{
			return internalY;
		}
		
		final public function get b():Scalar
		{
			return internalZ
		}
		
		final public function get a():Scalar
		{
			return internalW;
		}
		
		final public function get rgb():Value
		{
			return internalXYZ;
		}
		
		private function scalar(code:String):Scalar
		{
			return new Scalar(component(code));
		}
		
		private function value(code:String):Value
		{
			return new Value(component(code));
		}
		
		private function component(code:String):String
		{
			return this.code + "." + code;
		}
	}
}