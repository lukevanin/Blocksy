package
{
	public class TestPolyominosFactory
	{
		private var polyominos:Polyominos;
		
		public function TestPolyominosFactory(polyominos:Polyominos)
		{
			super();
			this.polyominos = polyominos;
		}
		
		final public function addAll():void
		{
			addSimple();
			addFlat();
			addComplex();
		}
		
		final public function addSimple():void
		{
			// One
			add(new <Number>[
				0, 0, 0,
			]);
			
			// Two
			add(new <Number>[
				0, 0, 0,
				1, 0, 0,
			]);
		}
		
		final public function addFlat():void
		{
			
			// Three
			add(new <Number>[
				-1, 0, 0,
				0, 0, 0,
				+1, 0, 0,
			]);
			
			// Four
//			add(new <Number>[
//				0, 0, 0,
//				1, 0, 0,
//				2, 0, 0,
//				3, 0, 0,
//			]);
			
			// Short L
			add(new <Number>[
				0, 0, 0,
				1, 0, 0,
				0, 1, 0
			]);
			
			// Long L
			add(new <Number>[
				1, -1, 0,
				0, -1, 0,
				0, 0, 0,
				0, +1, 0
			]);
		}
		
		final public function addComplex():void
		{
			// T
			add(new <Number>[
				0, 0, 0,
				-1, 0, 0,
				+1, 0, 0,
				0, 1, 0
			]);
			
			// Square
			add(new <Number>[
				0, 0, 0,
				1, 0, 0,
				1, 1, 0,
				0, 1, 0
			]);
			
			// Plus
			add(new <Number>[
				0, 0, 0,
				1, 0, 0,
				-1, 0, 0,
				0, 1, 0,
				0, -1, 0
			]);
			
			// Zig-zag
			add(new <Number>[
				0, 0, 0,
				-1, 0, 0,
				0, 1, 0,
				1, 1, 0
			]);
			
			// C
			add(new <Number>[
				0, 0, 0,
				0, 1, 0,
				0, -1, 0,
				1, 1, 0,
				1, -1, 0
			]);
			
			// Long Zig-zag
			add(new <Number>[
				0, 0, 0,
				0, 1, 0,
				0, -1, 0,
				1, 1, 0,
				-1, -1, 0
			]);
			
			// 3D corner
			add(new <Number>[
				0, 0, 0,
				1, 0, 0,
				0, -1, 0,
				0, 0, -1
			]);
			
			// 3D Offset corner 1
			add(new <Number>[
				0, 0, 0,
				1, 0, 0,
				1, 0, -1,
				0, -1, 0,
			]);
			
			// 3D Offset corner 1
			add(new <Number>[
				0, 0, 0,
				1, 0, 0,
				0, -1, -1,
				0, -1, 0,
			]);
			
			// 3D T
			add(new <Number>[
				0, 0, 0,
				1, 0, 0,
				-1, 0, 0,
				0, -1, 0,
				0, 0, -1
			]);
			
			// 3D Zig-zag
			add(new <Number>[
				0, 0, 0,
				1, 0, 0,
				1, 0, -1,
				0, -1, 0,
				0, -1, 1
			]);
			
			// Long Zig-zag
			add(new <Number>[
				0, 0, 0,
				0, 1, 0,
				0, -1, 0,
				1, 1, 0,
				0, -1, -1
			]);			
		}
		
		private function add(points:Vector.<Number>):void
		{
			polyominos.add(Polyomino.createFromPoints(points));			
		}
	}
}