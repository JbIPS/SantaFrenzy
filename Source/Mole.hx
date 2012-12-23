package;


import com.eclecticdesignstudio.motion.Actuate;
import com.eclecticdesignstudio.motion.easing.Quad;
import nme.display.Sprite;


class Mole extends Sprite {
	
	
	public var active:Bool;
	public var dispose:Bool;
	public var points:Int;
	
	private var Graphic:Sprite;
	
	private var currentFrame:Int;
	
	
	public function new () {
		
		super ();
		
		active = true;
		currentFrame = 0;
		dispose = false;
		
		var rand = Math.random ();
		
		if (rand < 0.2) {
			
			Graphic = Utils.loadGraphic ("images/santa.png", true);
			points = 15;
			
		} else if( rand <0.8){
			
			Graphic = Utils.loadGraphic ("images/Reindeer.png", true);
			points = 10;
			
		}
		else {
			Graphic = Utils.loadGraphic("images/Grinch.png", true);
			points = -20;
		}
		
		
		Graphic.alpha = 0;
		Graphic.width = 32*WhackAMole.screenRatioX;
		Graphic.height = 32 * WhackAMole.screenRatioY;
		graphics.beginFill (0xFFFFFF, 0.01);
		graphics.drawRect (-4, -4, 36, 36);
		Actuate.tween (Graphic, 0.6, { alpha: 1 } );
		addChild (Graphic);
		
	}
	
	
	public function hide (showCloud:Bool = false):Void {
		
		if (showCloud) {
			
			Graphic.visible = false;
			
			var cloud:Sprite = Utils.loadGraphic ("images/Cloud.png", true);
			cloud.x = -17;
			cloud.y = -4;
			addChild (cloud);
			Actuate.tween (cloud, 1, { alpha: 0 } ).ease (Quad.easeOut);
			
		} else {
			
			Actuate.tween (Graphic, 0.5, { alpha: 0 } );
			
		}
		
		active = false;
		
	}
	
	
	public function step ():Void {
		
		currentFrame ++;
		
		if (points == 10 ) {
			
			if (currentFrame == 90) {
				
				hide ();
				
			} else if (currentFrame >= 100) {
				
				dispose = true;
				
			}
			
		} else {
			
			if (currentFrame == 70) {
				
				hide ();
				
			} else if (currentFrame >= 80) {
				
				dispose = true;
				
			}
			
		}
		
		
	}
	
	
}
