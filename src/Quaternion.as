package
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class Quaternion
	{
		private var cos:Function = Math.cos;
		private var sin:Function = Math.sin;
		private var sqrt:Function = Math.sqrt;
		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		public var w:Number;
		
		public function Quaternion(x:Number = 0, y:Number = 0, z:Number = 0, w:Number = 0)
		{
			super();
			this.x = x;
			this.y = y;
			this.z = z;
			this.w = w;
		}
		
		final public function get magnitude():Number
		{
			return sqrt(x*x + y*y + z*z + w*w);			
		}
		
		final public function identity():void
		{
			x = 0;
			y = 0;
			z = 0;
			w = 0;
		}
		
		final public function normalise():void
		{
			var m:Number = 1 / magnitude;
			x *= m;
			y *= m;
			z *= m;
			w *= m;
		}
		
		final public function multiply(a:Quaternion, b:Quaternion):void
		{
			w = a.w * b.w - a.x * b.x - a.y * b.y - a.z * b.z
			x = a.w * b.x + a.x * b.w + a.y * b.z - a.z * b.y
			y = a.w * b.y + a.y * b.w + a.z * b.x - a.x * b.z
			z = a.w * b.z + a.z * b.w + a.x * b.y - a.y * b.x
		}
		
		final public function copy(input:Quaternion):void
		{
			x = input.x;
			y = input.y;
			z = input.z;
			w = input.w;
		}
		
		final public function clone():Quaternion
		{
			return new Quaternion(x, y, z, w);
		}
		
		final public function lerp(a:Quaternion, b:Quaternion, i:Number):void
		{
			x = a.x + (b.x - a.x) * i;
			y = a.y + (b.y - a.y) * i;
			z = a.z + (b.z - a.z) * i;
			w = a.w + (b.w - a.w) * i;
		}
		
		final public function toVector3D():Vector3D
		{
			return new Vector3D(x, y, z, w);
		}
		
		final public function toMatrix3D():Matrix3D
		{
			var xx:Number = x * x;
			var xy:Number = x * y;
			var xz:Number = x * z;
			var xw:Number = x * w;
			var yy:Number = y * y;
			var yz:Number = y * z;
			var yw:Number = y * w;
			var zz:Number = z * z;
			var zw:Number = z * w;
			
			var v:Vector.<Number> = new <Number>[];
			v[0]  = 1 - 2 * ( yy + zz );
			v[1]  =     2 * ( xy - zw );
			v[2]  =     2 * ( xz + yw );
			v[3]  = 0;
			
			v[4]  =     2 * ( xy + zw );
			v[5]  = 1 - 2 * ( xx + zz );
			v[6]  =     2 * ( yz - xw );
			v[7]  = 0;
			
			v[8]  =     2 * ( xz - yw );
			v[9]  =     2 * ( yz + xw );
			v[10] = 1 - 2 * ( xx + yy );
			v[11] = 0;
			
			v[12] = 0;
			v[13] = 0;
			v[14] = 0;
			v[15] = 1;
			
			return new Matrix3D(v);
		}
		
		final public function fromVector3D(input:Vector3D):void
		{
			x = input.x;
			y = input.y;
			z = input.z;
			w = input.w;
		}
		
		final public function fromEuler(xAngle:Number, yAngle:Number, zAngle:Number):void
		{
			var fSinPitch:Number = sin(yAngle * 0.5);
			var fCosPitch:Number = cos(yAngle * 0.5);
			var fSinYaw:Number = sin(zAngle * 0.5);
			var fCosYaw:Number = cos(zAngle * 0.5);
			var fSinRoll:Number = sin(xAngle * 0.5);
			var fCosRoll:Number = cos(xAngle * 0.5);
			var fCosPitchCosYaw:Number = fCosPitch * fCosYaw;
			var fSinPitchSinYaw:Number = fSinPitch * fSinYaw;
			x = fSinRoll * fCosPitchCosYaw     - fCosRoll * fSinPitchSinYaw;
			y = fCosRoll * fSinPitch * fCosYaw + fSinRoll * fCosPitch * fSinYaw;
			z = fCosRoll * fCosPitch * fSinYaw - fSinRoll * fSinPitch * fCosYaw;
			w = fCosRoll * fCosPitchCosYaw     + fSinRoll * fSinPitchSinYaw;
		}

		public static function createFromVector3D(input:Vector3D):Quaternion
		{
			var output:Quaternion = new Quaternion();
			output.fromVector3D(input);
			return output;
		}
		
		public static function createFromEuler(x:Number, y:Number, z:Number):Quaternion
		{
			var output:Quaternion = new Quaternion();
			output.fromEuler(x, y, z);
			return output;
		}
	}
}