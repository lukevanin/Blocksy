package
{
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.utils.ByteArray;

	public class Material
	{
		public var vertexShader:ByteArray;
		public var fragmentShader:ByteArray;
		private var program:Program3D;
		
		public function Material()
		{
			super();
		}
		
		public function apply(context:Context3D, matrix:Matrix3D):void
		{
			context.setTextureAt(0, texture);
			context.setProgram(program);
		}
		
		private function updateShader(context:Context3D):void
		{
			program = context.createProgram();
			program.upload(vertexShader, fragmentShader);			
		}		
	}
}