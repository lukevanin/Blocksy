package
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;
	
	import flash.geom.Vector3D;

	public class Vector3DAnimator
	{
		public var target:Vector3D;
		
		private var start:Vector3D;
		private var end:Vector3D;
		private var internalT:Number;
		private var internalIsAnimating:Boolean;

		public function Vector3DAnimator()
		{
			super();
			start = new Vector3D();
			end = new Vector3D();
			internalT = 0;
			internalIsAnimating = false;
		}
		
		final public function get t():Number
		{
			return internalT;
		}
		
		final public function set t(value:Number):void
		{
			internalT = value;
			update();
		}
		
		final public function get isAnimating():Boolean
		{
			return internalIsAnimating;
		}
		
		final public function animate(start:Vector3D, end:Vector3D, time:Number):void
		{
//			stop();
			this.start.copyFrom(start);
			this.end.copyFrom(end);
			
			internalIsAnimating = true;
			
			t = 0;
			TweenLite.to(this, time, {
				t: 1,
				ease: Sine.easeOut,
				onComplete: complete
			});	
		}
		
		final public function stop():void
		{
			TweenLite.killTweensOf(this, false);
			update();
//			start.copyFrom(target);
//			end.copyFrom(target);
		}
		
		private function complete():void
		{
			internalIsAnimating = false;
		}
		
		private function update():void
		{
			target.x = start.x + (end.x - start.x) * internalT;
			target.y = start.y + (end.y - start.y) * internalT;
			target.z = start.z + (end.z - start.z) * internalT;
			target.w = start.w + (end.w - start.w) * internalT;			
		}
		
		public static function create(target:Vector3D):Vector3DAnimator
		{
			var output:Vector3DAnimator = new Vector3DAnimator();
			output.target = target;
			return output;
		}
	}
}