package shader
{
	import flash.display3D.Context3DProgramType;

	public class VertexShader extends Shader
	{
		// Vertex Attribute
		protected static const va0:Register = new Register("va0");
		protected static const va1:Register = new Register("va1");
		protected static const va2:Register = new Register("va2");
		protected static const va3:Register = new Register("va3");
		protected static const va4:Register = new Register("va4");
		protected static const va5:Register = new Register("va5");
		protected static const va6:Register = new Register("va6");
		
		// Vertex Constant
		protected static const vc0:Register = new Register("vc0");
		protected static const vc1:Register = new Register("vc1");
		protected static const vc2:Register = new Register("vc2");
		protected static const vc3:Register = new Register("vc3");
		protected static const vc4:Register = new Register("vc4");
		protected static const vc5:Register = new Register("vc5");
		protected static const vc6:Register = new Register("vc6");
		protected static const vc7:Register = new Register("vc7");
		protected static const vc8:Register = new Register("vc8");
		protected static const vc9:Register = new Register("vc9");
		protected static const vc10:Register = new Register("vc10");
		protected static const vc11:Register = new Register("vc11");
		protected static const vc12:Register = new Register("vc12");
		protected static const vc13:Register = new Register("vc13");
		protected static const vc14:Register = new Register("vc14");
		protected static const vc15:Register = new Register("vc15");
		protected static const vc16:Register = new Register("vc16");
		protected static const vc17:Register = new Register("vc17");
		protected static const vc18:Register = new Register("vc18");
		protected static const vc19:Register = new Register("vc19");
		protected static const vc20:Register = new Register("vc20");
		protected static const vc21:Register = new Register("vc21");
		protected static const vc22:Register = new Register("vc22");
		protected static const vc23:Register = new Register("vc23");
		protected static const vc24:Register = new Register("vc24");
		protected static const vc25:Register = new Register("vc25");
		protected static const vc26:Register = new Register("vc26");
		protected static const vc27:Register = new Register("vc27");
		protected static const vc28:Register = new Register("vc28");
		protected static const vc29:Register = new Register("vc29");
		protected static const vc30:Register = new Register("vc30");
		protected static const vc31:Register = new Register("vc31");
		protected static const vc32:Register = new Register("vc32");
		protected static const vc33:Register = new Register("vc33");
		protected static const vc34:Register = new Register("vc34");
		protected static const vc35:Register = new Register("vc35");
		protected static const vc36:Register = new Register("vc36");
		protected static const vc37:Register = new Register("vc37");
		protected static const vc38:Register = new Register("vc38");
		protected static const vc39:Register = new Register("vc39");
		protected static const vc40:Register = new Register("vc40");
		protected static const vc41:Register = new Register("vc41");
		protected static const vc42:Register = new Register("vc42");
		protected static const vc43:Register = new Register("vc43");
		protected static const vc44:Register = new Register("vc44");
		protected static const vc45:Register = new Register("vc45");
		protected static const vc46:Register = new Register("vc46");
		protected static const vc47:Register = new Register("vc47");
		protected static const vc48:Register = new Register("vc48");
		protected static const vc49:Register = new Register("vc49");
		protected static const vc50:Register = new Register("vc50");
		protected static const vc51:Register = new Register("vc51");
		protected static const vc52:Register = new Register("vc52");
		protected static const vc53:Register = new Register("vc53");
		protected static const vc54:Register = new Register("vc54");
		protected static const vc55:Register = new Register("vc55");
		protected static const vc56:Register = new Register("vc56");
		protected static const vc57:Register = new Register("vc57");
		protected static const vc58:Register = new Register("vc58");
		protected static const vc59:Register = new Register("vc59");
		protected static const vc60:Register = new Register("vc60");
		protected static const vc61:Register = new Register("vc61");
		protected static const vc62:Register = new Register("vc62");
		protected static const vc63:Register = new Register("vc63");
		protected static const vc64:Register = new Register("vc64");
		protected static const vc65:Register = new Register("vc65");
		protected static const vc66:Register = new Register("vc66");
		protected static const vc67:Register = new Register("vc67");
		protected static const vc68:Register = new Register("vc68");
		protected static const vc69:Register = new Register("vc69");
		protected static const vc70:Register = new Register("vc70");
		protected static const vc71:Register = new Register("vc71");
		protected static const vc72:Register = new Register("vc72");
		protected static const vc73:Register = new Register("vc73");
		protected static const vc74:Register = new Register("vc74");
		protected static const vc75:Register = new Register("vc75");
		protected static const vc76:Register = new Register("vc76");
		protected static const vc77:Register = new Register("vc77");
		protected static const vc78:Register = new Register("vc78");
		protected static const vc79:Register = new Register("vc79");
		protected static const vc80:Register = new Register("vc80");
		protected static const vc81:Register = new Register("vc81");
		protected static const vc82:Register = new Register("vc82");
		protected static const vc83:Register = new Register("vc83");
		protected static const vc84:Register = new Register("vc84");
		protected static const vc85:Register = new Register("vc85");
		protected static const vc86:Register = new Register("vc86");
		protected static const vc87:Register = new Register("vc87");
		protected static const vc88:Register = new Register("vc88");
		protected static const vc89:Register = new Register("vc89");
		protected static const vc90:Register = new Register("vc90");
		protected static const vc91:Register = new Register("vc91");
		protected static const vc92:Register = new Register("vc92");
		protected static const vc93:Register = new Register("vc93");
		protected static const vc94:Register = new Register("vc94");
		protected static const vc95:Register = new Register("vc95");
		protected static const vc96:Register = new Register("vc96");
		protected static const vc97:Register = new Register("vc97");
		protected static const vc98:Register = new Register("vc98");
		protected static const vc99:Register = new Register("vc99");
		protected static const vc100:Register = new Register("vc100");
		protected static const vc101:Register = new Register("vc101");
		protected static const vc102:Register = new Register("vc102");
		protected static const vc103:Register = new Register("vc103");
		protected static const vc104:Register = new Register("vc104");
		protected static const vc105:Register = new Register("vc105");
		protected static const vc106:Register = new Register("vc106");
		protected static const vc107:Register = new Register("vc107");
		protected static const vc108:Register = new Register("vc108");
		protected static const vc109:Register = new Register("vc109");
		protected static const vc110:Register = new Register("vc110");
		protected static const vc111:Register = new Register("vc111");
		protected static const vc112:Register = new Register("vc112");
		protected static const vc113:Register = new Register("vc113");
		protected static const vc114:Register = new Register("vc114");
		protected static const vc115:Register = new Register("vc115");
		protected static const vc116:Register = new Register("vc116");
		protected static const vc117:Register = new Register("vc117");
		protected static const vc118:Register = new Register("vc118");
		protected static const vc119:Register = new Register("vc119");
		protected static const vc120:Register = new Register("vc120");
		protected static const vc121:Register = new Register("vc121");
		protected static const vc122:Register = new Register("vc122");
		protected static const vc123:Register = new Register("vc123");
		protected static const vc124:Register = new Register("vc124");
		protected static const vc125:Register = new Register("vc125");
		protected static const vc126:Register = new Register("vc126");
		protected static const vc127:Register = new Register("vc127");
		
		// Vertex Temporary
		protected static const vt0:Register = new Register("vt0");
		protected static const vt1:Register = new Register("vt1");
		protected static const vt2:Register = new Register("vt2");
		protected static const vt3:Register = new Register("vt3");
		protected static const vt4:Register = new Register("vt4");
		protected static const vt5:Register = new Register("vt5");
		protected static const vt6:Register = new Register("vt6");
		protected static const vt7:Register = new Register("vt7");
		 
		// Output Position
		protected static const op:Register = new Register("op");
		
		public function VertexShader()
		{
			super(Context3DProgramType.VERTEX);
		}
	}
}