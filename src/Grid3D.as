package
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class Grid3D extends Shape3D
	{
		public function Grid3D(w:Number = 1.0, h:Number = 1.0, d:Number = 1.0)
		{
			super();
			
			createPlane(w, h,  w * 0.5, h * 0.5, d,  0, 0, 0, 0); 
			createPlane(d, h,  0, h * 0.5, d * 0.5,  0, 1, 0, -90); 
			createPlane(d, h,  w, h * 0.5, d * 0.5,  0, 1, 0, 90); 
			createPlane(w, d,  w * 0.5, 0, d * 0.5,  1, 0, 0, 90); 
			createPlane(w, d,  w * 0.5, h, d * 0.5,  1, 0, 0, -90); 
		}
		
		private function createPlane(w:Number, h:Number, x:Number, y:Number, z:Number, i:Number, j:Number, k:Number, angle:Number):void
		{
			var m:Matrix3D = new Matrix3D();
			m.appendRotation(angle, new Vector3D(i, j, k));
			m.appendTranslation(x, y, z);
			
			var plane:Plane3D = new Plane3D(w, h, new <Number>[0, 0, 0, 0]);
			plane.setuv(new <Number>[
				0, 0,
				0, h,
				w, h,
				w, 0
			]);
			plane.transform(m);
			plane.calculateNormals();
			append(plane);
		}
	}
}