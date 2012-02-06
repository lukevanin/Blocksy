package shader
{
	import flash.display3D.Context3DProgramType;
	import flash.sampler.Sample;

	public class FragmentShader extends Shader
	{
		// Fragment Constant
		protected static const fc0:Register = new Register("fc0");
		protected static const fc1:Register = new Register("fc1");
		protected static const fc2:Register = new Register("fc2");
		protected static const fc3:Register = new Register("fc3");
		protected static const fc4:Register = new Register("fc4");
		protected static const fc5:Register = new Register("fc5");
		protected static const fc6:Register = new Register("fc6");
		protected static const fc7:Register = new Register("fc7");
		protected static const fc8:Register = new Register("fc8");
		protected static const fc9:Register = new Register("fc9");
		protected static const fc10:Register = new Register("fc10");
		protected static const fc11:Register = new Register("fc11");
		protected static const fc12:Register = new Register("fc12");
		protected static const fc13:Register = new Register("fc13");
		protected static const fc14:Register = new Register("fc14");
		protected static const fc15:Register = new Register("fc15");
		protected static const fc16:Register = new Register("fc16");
		protected static const fc17:Register = new Register("fc17");
		protected static const fc18:Register = new Register("fc18");
		protected static const fc19:Register = new Register("fc19");
		protected static const fc20:Register = new Register("fc20");
		protected static const fc21:Register = new Register("fc21");
		protected static const fc22:Register = new Register("fc22");
		protected static const fc23:Register = new Register("fc23");
		protected static const fc24:Register = new Register("fc24");
		protected static const fc25:Register = new Register("fc25");
		protected static const fc26:Register = new Register("fc26");
		protected static const fc27:Register = new Register("fc27");
		
		// Fragment Temporary
		protected static const ft0:Register = new Register("ft0");
		protected static const ft1:Register = new Register("ft1");
		protected static const ft2:Register = new Register("ft2");
		protected static const ft3:Register = new Register("ft3");
		protected static const ft4:Register = new Register("ft4");
		protected static const ft5:Register = new Register("ft5");
		protected static const ft6:Register = new Register("ft6");
		protected static const ft7:Register = new Register("ft7");
		
		// Fragment Sampler
		protected static const fs0:Sampler = new Sampler("fs0");
		protected static const fs1:Sampler = new Sampler("fs1");
		protected static const fs2:Sampler = new Sampler("fs2");
		protected static const fs3:Sampler = new Sampler("fs3");
		protected static const fs4:Sampler = new Sampler("fs4");
		protected static const fs5:Sampler = new Sampler("fs5");
		protected static const fs6:Sampler = new Sampler("fs6");
		protected static const fs7:Sampler = new Sampler("fs7");
		
		// Output Color
		protected static const oc:Register = new Register("oc");
		
		// texture type
		protected static const flat:TexType = new TexType("2d");
		protected static const cube:TexType = new TexType("cube");
		
		// texture wrap
		protected static const clamp:TexWrap = new TexWrap("clamp");
		protected static const repeat:TexWrap = new TexWrap("repeat");
		
		// texture filter
		protected static const nearest:TexFilter = new TexFilter("nearest");
		protected static const linear:TexFilter = new TexFilter("linear");
		protected static const mipnearest:TexFilter = new TexFilter("mipnearest");
		protected static const miplinear:TexFilter = new TexFilter("miplinear");
		
		
		public function FragmentShader()
		{
			super(Context3DProgramType.FRAGMENT);
		}
		
		final public function tex(t:Register, a:Register, b:Sampler, type:TexType, wrap:TexWrap, filter:TexFilter):void
		{
			opcode("tex", t, a, flags(b, type, wrap, filter));
		}
		
		final public function kil(a:Scalar):void
		{
			opcode("kil", a);	
		}
		
		private function flags(s:Sampler, type:TexType, wrap:TexWrap, filter:TexFilter):Value
		{
			return new Value(s.code + " <" + [type.code, wrap.code, filter.code].join(",") + ">");
		}
	}
}