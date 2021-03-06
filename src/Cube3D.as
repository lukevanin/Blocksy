package
{
	import flash.geom.Matrix3D;
	import flash.geom.Utils3D;
	import flash.geom.Vector3D;

	public class Cube3D extends Shape3D
	{
		private var color:Vector.<Number>;
		
		public function Cube3D(w:Number, h:Number, d:Number, color:Vector.<Number>)
		{
			super();
			this.color = color;
			
			w /= 2;
			h /= 2;
			d /= 2;
			
			createPlane(w, h,  0, 0, -d,  0, 0, 0, 0); 
			createPlane(w, h,  0, 0, -d,  0, 1, 0, 90); 
			createPlane(w, h,  0, 0, -d,  0, 1, 0, 180); 
			createPlane(w, h,  0, 0, -d,  0, 1, 0, 270); 
			createPlane(w, h,  0, 0, -d,  1, 0, 0, 90); 
			createPlane(w, h,  0, 0, -d,  1, 0, 0, 270);
		}
		
		private function createPlane(w:Number, h:Number, x:Number, y:Number, z:Number, i:Number, j:Number, k:Number, angle:Number):void
		{
			var m:Matrix3D = new Matrix3D();
			m.appendTranslation(x, y, z);
			m.appendRotation(angle, new Vector3D(i, j, k));
			
			var plane:Plane3D = new Plane3D(1, 1, color);
			plane.transform(m);
			plane.calculateNormals();
			append(plane);
		}
	}
}