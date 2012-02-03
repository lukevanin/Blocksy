package
{
	import com.adobe.utils.AGALMiniAssembler;
	
	import flash.display.Bitmap;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.Program3D;
	import flash.display3D.VertexBuffer3D;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.ByteArray;

	public class Shape3D
	{
		public const X:int = 0;
		public const Y:int = 1;
		public const Z:int = 2;
		public const NX:int = 3;
		public const NY:int = 4;
		public const NZ:int = 5;
		public const U:int = 6;
		public const V:int = 7;
		
		public const DATA_PER_VERTEX:int = 8;
		
		private const FAR_PLANE:Number = 50;
		private const INV_FAR_PLANE:Number = 1 / FAR_PLANE;
		
		public var vertices:Vector.<Number>;
		public var indices:Vector.<uint>;
		public var matrix:Matrix3D;
		public var texture:Texture;
		
		private var vertexBuffer:VertexBuffer3D;
		private var indexBuffer:IndexBuffer3D;
		private var program:Program3D;
		private var vertexShader:ByteArray;
		private var fragmentShader:ByteArray;
		private var fogColor:Vector.<Number>;
		private var clamp:Vector.<Number>;
		private var ambience:Vector.<Number>;
		private var direction:Vector.<Number>;
		private var color:Vector.<Number>;
		
		public function Shape3D()
		{
			super();
			vertices = new <Number>[];
			indices = new <uint>[];
			
			fogColor = new <Number>[INV_FAR_PLANE, INV_FAR_PLANE, INV_FAR_PLANE, 1];
			
			clamp = new <Number>[0, 0, 0, 0];
			ambience = new <Number>[0.25, 0.25, 0.25, 0];
			direction = new <Number>[0, 0, -1, 1];
			color = new <Number>[0.9,0.9,0.9,1];
			
			vertexShader = assembleVertexShader(
				"m44 vt0, va0, vc0 \n"+     //transform vertex x,y,z
				"mov op, vt0 \n"+           //output vertex x,y,z
				"m44 v1, va1, vc4 \n"+      //transform vertex normal, send to fragment shader
				"mov v2, va2"              //move vertex u,v to fragment shader
				);
			
			fragmentShader = assembleFragmentShader(
				"nrm ft0.xyz, v1 \n"+       //normalize the fragment normal (v1)
				"mov ft0.w, fc0.w \n"+      //set the w component to 0
				"tex ft2, v2, fs0 <2d,repeat,miplinear> \n"+  //sample texture (fs0) using uv coordinates (v2)
				
				"dp3 ft1, fc2, ft0 \n"+     //dot the transformed normal (ft0) with key light direction (fc2)
				"max ft1, ft1, fc0 \n"+     //clamp any negative values to 0
				"mul ft1, ft2, ft1 \n"+     //multiply original fragment color (ft2) by key light amount (ft1)
				"mul ft3, ft1, fc3 \n"+     //multiply new fragment color (ft1) by key light color (fc3)
				
				"mul ft2, ft2, fc1 \n"+     //multiply original fragment color (ft2) by ambient light intensity and color (fc1)
				"add oc, ft2, ft3"          //add ambient light result (ft2) to combined three-light result (ft1) and output
				);
			
			// texture
//			vertexShader = assembleVertexShader( 
//				"m44 op, va0, vc0\n" +
//				"mov v2, va2");
			
//			fragmentShader = assembleFragmentShader(
//				"tex ft0, v2, fs0 <2d,repeat,miplinear>\n" +
//				"mov oc, ft0");
			
			// fog
//			vertexShader = assembleVertexShader( 
//				"m44 vt0, va0, vc0 \n" +
//				"mov op, vt0 \n" +
//				"mov v0, vt0.z \n" +
//				"mov v1, va1 \n"
//			);
			
//			fragmentShader = assembleFragmentShader(
//				"tex ft0, v1, fs0 <2d,repeat,miplinear> \n" +
//				"mul ft1, fc0, v0 \n" +
//				"mul ft2, ft1, ft0 \n" +
//				"mov oc, ft2 \n"
//			);
			
			// unmultiply alpha
//			fragmentShader = assembleFragmentShader(
//				"mov oc, v0");			
			
//			fragmentShader = assembleFragmentShader(
//				"tex ft0, v0, fs0 <2d,repeat,linear> \n" + //sample texture
//				"div ft0.rgb, ft0.rgb, ft0.a \n" +  // un-premultiply png
//				"mov oc, ft0" //output fixed RGB
//				);
		}

		final public function append(input:Shape3D):void
		{
			var vertexOffset:int = vertices.length / DATA_PER_VERTEX;
			
			vertices = vertices.concat(input.vertices);

			for (var i:int = 0, n:int = input.indices.length; i < n; i ++)
				indices.push(input.indices[i] + vertexOffset);
			
//			trace("vertices=" + vertexOffset + " " + vertices.length);
//			trace("indices=" + indices.length);
		}
		
		final public function transform(matrix:Matrix3D):void
		{
			for (var i:int = 0, n:int = vertices.length; i < n; i += DATA_PER_VERTEX) {
				transformVertex(i, matrix);
				transformVertex(i + 3, matrix);
				normalizeVertex(i + 3);
			}
		}
		
		private function transformVertex(i:int, matrix:Matrix3D):void
		{
			var a:Vector3D = new Vector3D(vertices[i], vertices[i + 1], vertices[i + 2]);
			var b:Vector3D = matrix.transformVector(a);
			vertices[i] = b.x;
			vertices[i + 1] = b.y;
			vertices[i + 2] = b.z;
		}

		private function normalizeVertex(i:int):void {
			var a:Vector3D = new Vector3D(vertices[i], vertices[i + 1], vertices[i + 2]);
			a.normalize();
			vertices[i] = a.x;
			vertices[i + 1] = a.y;
			vertices[i + 2] = a.z;
		}
		
		final public function flipFaces():void
		{
			
		}
		
		final public function render(context:Context3D):void
		{
			if ((vertices.length > 0) && (indices.length > 0)) {
				updateShader(context);
				updateBuffers(context);
				
				context.setTextureAt(0, texture);
				
				context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_3); // position
				context.setVertexBufferAt(1, vertexBuffer, 3, Context3DVertexBufferFormat.FLOAT_3); // normal
				context.setVertexBufferAt(2, vertexBuffer, 6, Context3DVertexBufferFormat.FLOAT_2); // uv
				context.setProgram(program);
				
//				context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fogColor);
					
				context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, clamp);
				context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, ambience);
				context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, direction);
				context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, color);
				
				context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, matrix, true);
				
				context.drawTriangles(indexBuffer);
			}
		}
		
		private function assembleVertexShader(input:String):ByteArray
		{
			return assemble(Context3DProgramType.VERTEX, input);
		}
		
		private function assembleFragmentShader(input:String):ByteArray
		{
			return assemble(Context3DProgramType.FRAGMENT, input);
		}
		
		private function assemble(type:String, input:String):ByteArray
		{
			var assembler:AGALMiniAssembler = new AGALMiniAssembler();
			assembler.assemble(type, input);
			return assembler.agalcode;
		}
		
		private function updateShader(context:Context3D):void
		{
			program = context.createProgram();
			program.upload(vertexShader, fragmentShader);			
		}
		
		private function updateBuffers(context:Context3D):void
		{
			var numVertices:int = vertices.length / DATA_PER_VERTEX;
			var numIndices:int = indices.length;
			
			if (vertexBuffer != null)
				vertexBuffer.dispose();
			
			vertexBuffer = context.createVertexBuffer(numVertices, DATA_PER_VERTEX);
			vertexBuffer.uploadFromVector(vertices, 0, numVertices);
			
			if (indexBuffer != null)
				indexBuffer.dispose();
			
			indexBuffer = context.createIndexBuffer(numIndices);
			indexBuffer.uploadFromVector(indices, 0, numIndices);			
		}
	}
}