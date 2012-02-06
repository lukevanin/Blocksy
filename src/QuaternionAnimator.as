package
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Cubic;
	import com.greensock.easing.Sine;

	public class QuaternionAnimator
	{
		public var target:Quaternion;
		
		private var start:Quaternion;
		private var end:Quaternion;
		private var internalT:Number;
		private var internalIsAnimating:Boolean;

		public function QuaternionAnimator()
		{
			super();
			start = new Quaternion();
			end = new Quaternion();
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
		
		final public function animate(start:Quaternion, end:Quaternion, time:Number):void
		{
			stop();
			this.start.copy(start);
			this.end.copy(end);
			
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
//			start.copy(target);
//			end.copy(target);
//			t = 0;
		}
		
		private function complete():void
		{
			internalIsAnimating = false;
		}
		
		private function update():void
		{
			target.lerp(start, end, internalT);
			target.normalise();			
		}
		
		public static function create(target:Quaternion):QuaternionAnimator
		{
			var output:QuaternionAnimator = new QuaternionAnimator();
			output.target = target;
			return output;
		}
	}
}