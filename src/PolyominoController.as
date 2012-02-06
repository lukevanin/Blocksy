package
{
	import com.greensock.TweenLite;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	public class PolyominoController
	{
		private var internalRotation:Quaternion;
		private var internalPosition:Vector3D;
		
		private var rotationAnimator:QuaternionAnimator;
		private var positionAnimator:Vector3DAnimator;
		
		public function PolyominoController()
		{
			super();
			
			internalRotation = Quaternion.createFromEuler(0, 0, 0);
			internalPosition = new Vector3D(0, 0, 0, 0);

			rotationAnimator = QuaternionAnimator.create(internalRotation);
			positionAnimator = Vector3DAnimator.create(internalPosition);
		}
		
		final public function get rotation():Quaternion
		{
			return internalRotation.clone();
		}
		
		final public function set rotation(value:Quaternion):void
		{
			rotationAnimator.stop();
			internalRotation.copy(value);
		}
		
		final public function get position():Vector3D
		{
			return internalPosition.clone();
		}
		
		final public function set position(value:Vector3D):void
		{
			positionAnimator.stop();
			internalPosition.copyFrom(value);
		}
		
		final public function animateRotation(input:Quaternion):void
		{
//			if (!rotationAnimator.isAnimating)
				rotationAnimator.animate(rotation, input, 0.25);
		}
		
		final public function animatePosition(input:Vector3D):void
		{
//			if (!positionAnimator.isAnimating)
				positionAnimator.animate(position, input, 0.25);
		}
	}
}