package shader
{
	import flash.display3D.Context3D;
	import flash.display3D.Program3D;
	import flash.geom.Matrix3D;
	import flash.utils.ByteArray;

	public class Material
	{
		protected var context:Context3D;
		
		private var vertexShader:ByteArray;
		private var fragmentShader:ByteArray;
		private var program:Program3D;
		
		public function Material(vertexShader:ByteArray, fragmentShader:ByteArray)
		{
			super();
			this.vertexShader = vertexShader;
			this.fragmentShader = fragmentShader;
		}
		
		final public function apply(context:Context3D, world:Matrix3D, view:Matrix3D, projection:Matrix3D):void
		{
			if (context != this.context) {
				this.context = context;
				invalidateProgram();
			}
			
			setProgram();
			applyOverride(world, view, projection)
		}
		
		protected function applyOverride(world:Matrix3D, view:Matrix3D, projection:Matrix3D):void
		{
			
		}
		
		private function setProgram():void
		{
			context.setProgram(program);
		}
		
		private function invalidateProgram():void
		{
			if (program != null)
				program.dispose();
			
			program = createProgram();
		}
		
		private function createProgram():Program3D
		{
			var vertexShader:ByteArray = vertexShader;
			var fragmentShader:ByteArray = fragmentShader;
			var program:Program3D = context.createProgram();
			program.upload(vertexShader, fragmentShader);
			return program;
		}		
	}
}