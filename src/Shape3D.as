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
	
	import shader.Material;
	import shader.VertexShader;

	public class Shape3D
	{
		public const XYZ:int = 0;
		public const X:int = XYZ;
		public const Y:int = XYZ + 1;
		public const Z:int = XYZ + 2;
		
		public const NORMAL:int = 3;
		public const NX:int = NORMAL;
		public const NY:int = NORMAL + 1;
		public const NZ:int = NORMAL + 2;
		
		public const UV:int = 6;
		public const U:int = UV;
		public const V:int = UV + 1;
		
		public const RGBA:int = 8;
		public const R:int = RGBA;
		public const G:int = RGBA + 1;
		public const B:int = RGBA + 2;
		public const A:int = RGBA + 3;
		
		public const DATA_PER_VERTEX:int = 12;
		
		public var vertices:Vector.<Number>;
		public var indices:Vector.<uint>;
		public var worldMatrix:Matrix3D;
		public var viewMatrix:Matrix3D;
		public var projectionMatrix:Matrix3D;
		public var material:Material;
		
		private var vertexBuffer:VertexBuffer3D;
		private var indexBuffer:IndexBuffer3D;
//		private var program:Program3D;
//		private var vertexShader:ByteArray;
//		private var fragmentShader:ByteArray;
//		private var fogColor:Vector.<Number>;
//		private var clamp:Vector.<Number>;
//		private var ambience:Vector.<Number>;
//		private var direction:Vector.<Number>;
//		private var color:Vector.<Number>;
		
		public function Shape3D()
		{
			super();
			vertices = new <Number>[];
			indices = new <uint>[];
			
//			fogColor = new <Number>[INV_FAR_PLANE, INV_FAR_PLANE, INV_FAR_PLANE, 1];
			
//			clamp = new <Number>[0, 0, 0, 0];
//			ambience = new <Number>[0.25, 0.25, 0.25, 0];
//			direction = new <Number>[-0.5, 0.5, -0.75, 1];
//			color = new <Number>[0.9, 0.9, 0.9, 1];

//			var s:SimpleLightShader = new SimpleLightShader();
			
//			vertexShader = s.vertexShader;
//			fragmentShader = s.fragmentShader;
			
//			vertexShader = assembleVertexShader(
//				"m44 vt0, va0, vc0 \n"+     //transform vertex x,y,z
//				"mov op, vt0 \n"+           //output vertex x,y,z
//				"m44 v1, va1, vc4 \n"+      //transform vertex normal, send to fragment shader
//				"mov v2, va2"              //move vertex u,v to fragment shader
//				);
			
//			fragmentShader = assembleFragmentShader(
//				"nrm ft0.xyz, v1 \n"+       //normalize the fragment normal (v1)
//				"mov ft0.w, fc0.w \n"+      //set the w component to 0
//				"tex ft2, v2, fs0 <2d,repeat,miplinear> \n"+  //sample texture (fs0) using uv coordinates (v2)
//				
//				"dp3 ft1, fc2, ft0 \n"+     //dot the transformed normal (ft0) with key light direction (fc2)
//				"max ft1, ft1, fc0 \n"+     //clamp any negative values to 0
//				"mul ft1, ft2, ft1 \n"+     //multiply original fragment color (ft2) by key light amount (ft1)
//				"mul ft3, ft1, fc3 \n"+     //multiply new fragment color (ft1) by key light color (fc3)
//				
//				"mul ft2, ft2, fc1 \n"+     //multiply original fragment color (ft2) by ambient light intensity and color (fc1)
//				"add oc, ft2, ft3"          //add ambient light result (ft2) to combined three-light result (ft1) and output
//				);
			
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
			for (var i:int = 0, n:int = vertices.length; i < n; i += DATA_PER_VERTEX)
				transformVertex(i, matrix);
		}
		
		final public function calculateNormal(i:int, v0:int, v1:int, v2:int):void
		{
			var i0:int = v0 * DATA_PER_VERTEX;
			var i1:int = v1 * DATA_PER_VERTEX;
			var i2:int = v2 * DATA_PER_VERTEX;
			
			var x0:Number = vertices[i0 + X];
			var y0:Number = vertices[i0 + Y];
			var z0:Number = vertices[i0 + Z];
			
			var x1:Number = vertices[i1 + X];
			var y1:Number = vertices[i1 + Y];
			var z1:Number = vertices[i1 + Z];
			
			var x2:Number = vertices[i2 + X];
			var y2:Number = vertices[i2 + Y];
			var z2:Number = vertices[i2 + Z];
			
			var ax:Number = x1 - x0;
			var ay:Number = y1 - y0;
			var az:Number = z1 - z0;
			
			var bx:Number = x2 - x0;
			var by:Number = y2 - y0;
			var bz:Number = z2 - z0;
			
//			Cx = AyBz - AzBy 
//			Cy = AzBx - AxBz 
//			Cz = AxBy - AyBx
			
			var j:int = i * DATA_PER_VERTEX;
			
			vertices[j + NX] = ay * bz - az * by;
			vertices[j + NY] = az * bx - ax * bz;
			vertices[j + NZ] = ax * by - ay * bx;
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
		
		final public function render(context:Context3D):void
		{
			if ((vertices.length > 0) && (indices.length > 0)) {
//				updateShader(context);
				updateBuffers(context);
				
//				context.setTextureAt(0, texture);
				
//				context.setProgram(program);
				
				material.apply(context, worldMatrix, viewMatrix, projectionMatrix);
				
				context.setVertexBufferAt(0, vertexBuffer, XYZ, Context3DVertexBufferFormat.FLOAT_3); // position
				context.setVertexBufferAt(1, vertexBuffer, NORMAL, Context3DVertexBufferFormat.FLOAT_3); // normal
				context.setVertexBufferAt(2, vertexBuffer, UV, Context3DVertexBufferFormat.FLOAT_2); // uv
				context.setVertexBufferAt(3, vertexBuffer, RGBA, Context3DVertexBufferFormat.FLOAT_4); // rgb
//				context.setProgram(program);
				
//				context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, fogColor);
					
//				context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, clamp);
//				context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, ambience);
//				context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, direction);
//				context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, color);
				
//				context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, matrix, true);
				
				context.drawTriangles(indexBuffer);
			}
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