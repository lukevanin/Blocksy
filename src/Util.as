package
{
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	final public class Util
	{
		public static function getVectorQuaternionMatrix(position:Vector3D, rotation:Quaternion):Matrix3D
		{
			var output:Matrix3D = rotation.toMatrix3D();
			output.appendTranslation(position.x, position.y, position.z);
			return output;
		}
		
		public static function interpolateVector(output:Vector3D, a:Vector3D, b:Vector3D, i:Number):void
		{
			output.x = a.x + (b.x - a.x) * i;
			output.y = a.y + (b.y - a.y) * i;
			output.z = a.z + (b.z - a.z) * i;
			output.w = a.w + (b.w - a.w) * i;
		}
		
		public static function createMipTexture(context:Context3D, input:BitmapData):Texture
		{
			var w:int = input.width;
			var h:int = input.height;
			var level:int = 0;
			var scale:Number = 1;
			
			var output:Texture = context.createTexture(w, h, Context3DTextureFormat.BGRA, false);
			
			while ((w > 0) && (h > 0)) {
				var m:Matrix = new Matrix();
				m.scale(scale, scale);
				
				var bitmapData:BitmapData = new BitmapData(w, h, true, 0);
				bitmapData.draw(input, m, null, null, null, true);
				output.uploadFromBitmapData(bitmapData, level);
				
				w *= 0.5;
				h *= 0.5;
				level ++;
				scale *= 0.5; 
				
			}
			
			return output;
		}
	}
}