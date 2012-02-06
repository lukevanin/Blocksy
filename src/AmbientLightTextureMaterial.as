package
{
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix3D;
	import flash.utils.ByteArray;
	
	import shader.Material;
	import shader.VertexShader;

	public class AmbientLightTextureMaterial extends Material
	{
		private static var vertexShader:ByteArray;
		private static var fragmentShader:ByteArray;
		
		public var clamp:Vector.<Number>;
		public var max:Vector.<Number>;
		public var ambience:Vector.<Number>;
		public var direction:Vector.<Number>;
		public var color:Vector.<Number>;		
		public var texture:Texture;
		public var zFar:Number;
		
		public function AmbientLightTextureMaterial()
		{
			if (vertexShader == null)
				vertexShader = VShader.output;
			
			if (fragmentShader == null)
				fragmentShader = FShader.output;
			
			super(vertexShader, fragmentShader);
			this.texture = texture;
		}
		
		override protected function applyOverride(world:Matrix3D, view:Matrix3D, projection:Matrix3D):void
		{
			context.setTextureAt(0, texture);
			
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 0, clamp);
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 1, ambience);
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 2, direction);
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 3, color);
			
			var s:Number = 1 / zFar;
			var fog:Vector.<Number> = new <Number>[s, s, s,	0];
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 4, fog);
			context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT, 5, max);
			
			var m:Matrix3D = world.clone();
			m.append(view);
			m.append(projection);
			
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, m, true);			
			
			var _m:Matrix3D = world.clone();
			_m.transpose();
			_m.invert();
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, _m, true); //vc4
			
		}
		
		public static function create(texture:Texture):AmbientLightTextureMaterial
		{
			var output:AmbientLightTextureMaterial = new AmbientLightTextureMaterial();
			output.texture = texture;
			output.clamp = new <Number>[0, 0, 0, 0];
			output.max = new <Number>[1, 1, 1, 1];
			output.ambience = new <Number>[0.25, 0.25, 0.25, 0];
			output.direction = new <Number>[-0.5, 0.5, -0.75, 1];
			output.color = new <Number>[0.9, 0.9, 0.9, 1];
			output.zFar = 20;
			return output;
		}
	}
}

import flash.utils.ByteArray;

import shader.FragmentShader;
import shader.VertexShader;

class VShader extends VertexShader
{
	public function VShader()
	{
		m44(vt3, va0, vc0); 	//transform vertex x,y,z
		mov(op, vt3); 			//output vertex x,y,z
		
		m44(v1, va1, vc4); 		//transform vertex normal, send to fragment shader
		mov(v2, va2);			//move vertex u,v to fragment shader
		
		mov(v3, vt3.z);			// move z to fragment shader
		
		mov(v4, va3); 			// move color to fragment shader
	}
	
	public static function get output():ByteArray
	{
		return new VShader().output;
	}
}

class FShader extends FragmentShader
{
	public function FShader()
	{
		nrm(ft0.xyz, v1);			//normalize the fragment normal (v1)
		mov(ft0.w, fc0.w);			//set the w component to 0
		tex(ft2, v2, fs0, flat, repeat, miplinear);	//sample texture (fs0) using uv coordinates (v2)
		
		dp3(ft1, fc2, ft0); 		//dot the transformed normal (ft0) with key light direction (fc2)
		max(ft1, ft1, fc0);			//clamp any negative values to 0
		mul(ft1, ft2, ft1);			//multiply original fragment color (ft2) by key light amount (ft1)
		mul(ft3, ft1, fc3); 		//multiply new fragment color (ft1) by key light color (fc3)
		
		mul(ft2, ft2, fc1);			//multiply original fragment color (ft2) by ambient light intensity and color (fc1)
		
		add(ft4, ft2, ft3);			//add ambient light result (ft2) to combined three-light result (ft1)
		
//		mul(ft4, ft4, v4);			// scale shape color
		add(ft4, ft4, v4);			// add shape color
		
		mul(ft5, fc4, v3);			// multiply fog scale by vertex z
		sub(ft5, fc5, ft5);
		mul(ft3, ft4, ft5);			// multiply output color by color scale
		
		mov(ft3.w, v4.w);
	
		mov(oc, ft3);			
//		add(oc, ft2, ft3);			//add ambient light result (ft2) to combined three-light result (ft1) and output
	}
	
	public static function get output():ByteArray
	{
		return new FShader().output;
	}
}