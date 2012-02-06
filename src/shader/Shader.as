package shader
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.utils.ByteArray;

	public class Shader
	{
		private static const assembler:AGALMiniAssembler = new AGALMiniAssembler();
		private static const instructionLimit:int = 200;
		
		// Varying
		protected static const v0:Register = new Register("v0");
		protected static const v1:Register = new Register("v1");
		protected static const v2:Register = new Register("v2");
		protected static const v3:Register = new Register("v3");
		protected static const v4:Register = new Register("v4");
		protected static const v5:Register = new Register("v5");
		protected static const v6:Register = new Register("v6");
		protected static const v7:Register = new Register("v7");
		
		private var type:String;
		private var instructions:Vector.<String>;
		
		public function Shader(type:String)
		{
			super();
			this.type = type;
			instructions = new <String>[];
		}
		
		final public function get output():ByteArray
		{
			return assembler.assemble(type, code);
		}
		
		final public function get code():String
		{
			return instructions.join("\n");
		}
		
		final public function mov(t:Value, a:Value):void
		{
			opcode("mov", t, a)
		}
		
		final public function add(t:Value, a:Value, b:Value):void
		{
			opcode("add", t, a, b);
		}
		
		final public function sub(t:Value, a:Value, b:Value):void
		{
			opcode("sub", t, a, b);
		}
		
		final public function mul(t:Value, a:Value, b:Value):void
		{
			opcode("mul", t, a, b);
		}
		
		final public function div(t:Value, a:Value, b:Value):void
		{
			opcode("div", t, a, b);
		}
		
		final public function rcp(t:Value, a:Value):void
		{
			opcode("rcp", t, a);
		}
		
		final public function min(t:Value, a:Value, b:Value):void
		{
			opcode("min", t, a, b);
		}
		
		final public function max(t:Value, a:Value, b:Value):void
		{
			opcode("max", t, a, b);
		}
		
		final public function frc(t:Value, a:Value):void
		{
			opcode("frc", t, a);
		}
		
		final public function sqt(t:Value, a:Value):void
		{
			opcode("sqt", t, a);
		}
		
		final public function rsq(t:Value, a:Value):void
		{
			opcode("rsq", t, a);
		}
		
		final public function pow(t:Value, a:Value, b:Value):void
		{
			opcode("pow", t, a, b);
		}
		
		final public function log(t:Value, a:Value):void
		{
			opcode("log", t, a);
		}
		
		final public function exp(t:Value, a:Value):void
		{
			opcode("exp", t, a);
		}
		
		final public function nrm(t:Value, a:Value):void
		{
			opcode("nrm", t, a);
		}
		
		final public function sin(t:Value, a:Value):void
		{
			opcode("sin", t, a);
		}
		
		final public function cos(t:Value, a:Value):void
		{
			opcode("cos", t, a);
		}
		
		final public function crs(t:Value, a:Value, b:Value):void
		{
			opcode("crs", t, a, b);
		}
		
		final public function dp3(t:Value, a:Value, b:Value):void
		{
			opcode("dp3", t, a, b);
		}
		
		final public function dp4(t:Value, a:Value, b:Value):void
		{
			opcode("dp4", t, a, b);
		}
		
		final public function abs(t:Value, a:Value):void
		{
			opcode("abs", t, a);
		}
		
		final public function neg(t:Value, a:Value):void
		{
			opcode("neg", t, a);
		}
		
		final public function sat(t:Value, a:Value):void
		{
			opcode("sat", t, a);
		}
		
		final public function m33(t:Value, a:Value, b:Value):void
		{
			opcode("m33", t, a, b);
		}
		
		final public function m44(t:Value, a:Value, b:Value):void
		{
			opcode("m44", t, a, b);
		}
		
		final public function m34(t:Value, a:Value, b:Value):void
		{
			opcode("m34", t, a, b);
		}
		
		final public function m43(t:Value, a:Value, b:Value):void
		{
			opcode("m43", t, a, b);
		}
		
		final public function sge(t:Value, a:Value, b:Value):void
		{
			opcode("sge", t, a, b);
		}
		
		final public function slt(t:Value, a:Value, b:Value):void
		{
			opcode("slt", t, a, b);
		}
		
		final protected function opcode(opcode:String, ...parameters):void
		{
			var p:Array = [];
			
			for (var i:int = 0, n:int = parameters.length; i < n; i++)
				p.push(parameters[i].code);
			
			instructions.push(opcode + " " + p.join(", "));
		}
	}
}