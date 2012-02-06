package
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	// TODO: load polys from file
	public class Polyominos extends EventDispatcher
	{
		private var polyominos:Vector.<Polyomino>;
		private var internalIndex:int;
		
		public function Polyominos()
		{
			super();
			polyominos = new Vector.<Polyomino>();
			clear();
		}
		
		final public function get current():Polyomino
		{
			if ((index < min) || (index > max))
				return null;
			else
				return polyominos[index].clone();
		}
		
		final public function random():Polyomino
		{
			internalIndex = Math.random() * polyominos.length;
			dispatchEvent(new Event(Event.CHANGE));
			return current;
		}
		
		final public function next():Polyomino
		{
			if (index == max)
				index = min;
			else
				index++;
			
			return current;
		}
		
		final public function previous():Polyomino
		{
			if (index == min)
				index = max;
			else
				index--;
			
			return current;
		}
		
		final public function add(polyomino:Polyomino):void
		{
			polyominos.push(polyomino);
		}		
		
		final public function clear():void
		{
			polyominos.splice(0, polyominos.length);
			index = -1;
		}
		
		private function get index():int
		{
			return internalIndex;
		}
		
		private function set index(value:int):void
		{
			if (value != internalIndex) {
				internalIndex = value;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		private function get min():int
		{
			return 0;
		}
		
		private function get max():int
		{
			return polyominos.length - 1;
		}
	}
}