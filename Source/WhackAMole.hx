package;


import com.eclecticdesignstudio.motion.Actuate;
import nme.Assets;
import nme.display.Bitmap;
import nme.display.DisplayObject;
import nme.display.SimpleButton;
import nme.display.Sprite;
import nme.display.StageAlign;
import nme.display.StageScaleMode;
import nme.events.Event;
import nme.events.MouseEvent;
import nme.events.TouchEvent;
import nme.geom.Point;
import nme.net.SharedObject;
import nme.net.SharedObjectFlushStatus;
import nme.text.TextField;
import nme.text.TextFormat;
import nme.text.TextFormatAlign;
import nme.Lib;


class WhackAMole extends Sprite {
	
	
	private var Background:Sprite;
	
	private var moles:Array <Mole>;
	private var positions:Array <Point>;
	private var score:Int;
	private var scoreDisplay: TextField;
	private var timerDisplay: TextField;
	private var startTime:Int;
	private var elapsedTime: Float;
	private var menu: Array<DisplayObject>;
	private var highScore: SharedObject;
	
	public static var screenRatioX: Float = -1;
	public static var screenRatioY: Float = -1;
	
	
	public function new () {
		
		super ();
		initializeGame ();	
		highScore = SharedObject.getLocal("score");
	}
	
	
	private function createMole ():Void {
		
		var numberOfMoles:Int = 0;
		
		for (mole in moles) {
			
			if (mole != null && mole.active) {
				
				numberOfMoles ++;
				
			}	
				
		}
		
		if (numberOfMoles < 5) {
			
			var index:Int = -1;
			var position:Point = null;
			
			while (position == null) {
					
				index = Math.round (Math.random () * (moles.length - 1));
				
				if (moles[index] == null || !moles[index].active) {
					
					position = positions[index];
						
				}
				
			}
			
			var mole:Mole = new Mole ();
			mole.x = position.x*screenRatioX;
			mole.y = position.y*screenRatioY;
			mole.addEventListener (MouseEvent.MOUSE_DOWN, Mole_onClick);
			addChild (mole);
				
			moles[index] = mole;
				
		}
		
	}
	
	
	private function endGame ():Void {
		
		removeEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		removeChild(scoreDisplay);
		
		var best = saveHighScore();
		
		for (mole in moles) {
			
			if (mole != null && mole.active) {
					
				mole.hide ();	
					
			}
			
		}
		
		var endScreen:Sprite = Utils.loadGraphic ("images/TimeUp.png", true);
		endScreen.alpha = 0;
		fitScreen(endScreen);
		addChild (endScreen);
		Actuate.tween (endScreen, 2, { alpha: 1 } );
		
		var scoreText:TextField = new TextField ();
		scoreText.y = 205*screenRatioY;
		scoreText.width = 320*screenRatioX;
		scoreText.text = Std.string (score);
		scoreText.selectable = false;
		
		var scoreFormat:TextFormat = new TextFormat ("_sans", 30, 0xDDDDDD);
		scoreFormat.align = TextFormatAlign.CENTER;
		
		scoreText.setTextFormat (scoreFormat);
		scoreText.addEventListener(MouseEvent.CLICK, createMenu);
		scoreText.alpha = 0;
		Actuate.tween (scoreText, 1, { alpha: 1 } ).delay (0.4);
		addChild (scoreText);
		
		var bestScore: TextField = new TextField();
		bestScore.defaultTextFormat = scoreFormat;
		bestScore.y = 305*screenRatioY;
		bestScore.width = 320 * screenRatioX;
		bestScore.selectable = bestScore.mouseEnabled = false;
		bestScore.alpha = 0;
		Actuate.tween (bestScore, 1, { alpha: 1 } ).delay (0.4);
		bestScore.text = "Meilleur Score: " + best;
		addChild(bestScore);
		
	}
	
	
	private function initializeGame ():Void {
		
		Lib.current.stage.align = StageAlign.TOP_LEFT;
		Lib.current.stage.scaleMode = StageScaleMode.NO_SCALE;
		
		positions = new Array <Point> ();
		positions.push (new Point (34, 58));
		positions.push (new Point (99, 68));
		positions.push (new Point (178, 56));
		positions.push (new Point (256, 76));
		positions.push (new Point (52, 118));
		positions.push (new Point (123, 135));
		positions.push (new Point (188, 116));
		positions.push (new Point (242, 137));
		positions.push (new Point (18, 174));
		positions.push (new Point (81, 174));
		positions.push (new Point (164, 193));
		positions.push (new Point (242, 193));
		positions.push (new Point (41, 230));
		positions.push (new Point (118, 246));
		positions.push (new Point (195, 229));
		positions.push (new Point (53, 284));
		positions.push (new Point (122, 303));
		positions.push (new Point (194, 303));
		positions.push (new Point (18, 340));
		positions.push (new Point (88, 355));
		positions.push (new Point (163, 356));
		positions.push (new Point (265, 341));
		positions.push (new Point (255, 267));
		
		moles = new Array <Mole> ();
		
		for (i in 0...positions.length) {
			
			moles.push (null);
			
		}
		
		createMenu(null);
		
	}
	
	private function createMenu(e: MouseEvent) : Void
	{
		while(numChildren != 0)
			removeChildAt(numChildren-1);
			
		var text = "Oh Oh Oh !\nAttrape les rênes\net les pères Noël\nMais évite le Grinch !";
		var accueil: TextField = new TextField();
		var accueilFormat:TextFormat = new TextFormat ("_sans", 20, 0xFFFFFF, true);
		accueilFormat.align = TextFormatAlign.CENTER;
		
		accueil.defaultTextFormat = accueilFormat;
		accueil.y = 50;
		accueil.mouseEnabled = accueil.selectable = false;
		accueil.text = text;
		accueil.width = Lib.current.stage.stageWidth;
		
		var startBmp = new Bitmap(Assets.getBitmapData("images/start.png"));
		var startButton: SimpleButton = new SimpleButton(startBmp, startBmp, startBmp, startBmp);
		
		var start: TextField = new TextField();
		start.defaultTextFormat = accueilFormat;
		start.mouseEnabled = false;
		start.text = "Commencer";
		start.width = 150;
		
		startButton.addEventListener(MouseEvent.CLICK, startGame);
		startButton.width = 50;
		startButton.height = 50;
		startButton.y = 3 * (Lib.current.stage.stageHeight / 4);
		startButton.x = Lib.current.stage.stageWidth / 2 - startButton.width / 2;
		
		start.y = startButton.y + 40;
		start.x = startButton.x - 55;
		
		var bkg : Bitmap = Utils.loadGraphic ("images/Background_noel.jpg");
		fitScreen(bkg);
		
		menu = new Array<DisplayObject>();
		menu.push(bkg);
		menu.push(accueil);
		menu.push(startButton);
		menu.push(start);
		
		addChild (bkg);
		addChild(accueil);
		addChild(startButton);
		addChild(start);
	}
	
	
	private function removeMole (mole:Mole):Void {
		
		mole.removeEventListener (MouseEvent.CLICK, Mole_onClick);
		
		for (i in 0...moles.length) {
			
			if (moles[i] == mole) {
				
				moles[i] == null;
				
			}
			
		}
		
		removeChild (mole);
			
	}
	
	
	private function startGame (e:MouseEvent):Void {
		for (item in menu)
		{
			removeChild(item);
		}
		
		Background = Utils.loadGraphic ("images/Background.jpg", true);
		fitScreen(Background);
		addChild (Background);
		
		score = 0;
		startTime = Lib.getTimer ();
		addEventListener (Event.ENTER_FRAME, this_onEnterFrame);
		
		scoreDisplay = new TextField();
		var scoreFormat:TextFormat = new TextFormat ("_sans", 20, 0x077200, true);
		scoreFormat.align = TextFormatAlign.CENTER;
		
		scoreDisplay.defaultTextFormat = scoreFormat;
		scoreDisplay.text = "Score: 0";
		scoreDisplay.width = Lib.current.stage.stageWidth;
		scoreDisplay.selectable = false;
		
		timerDisplay = new TextField();
		timerDisplay.defaultTextFormat = scoreFormat;
		timerDisplay.text = getRemainingTime();
		timerDisplay.width = Lib.current.stage.stageWidth;
		timerDisplay.y = Lib.current.stage.stageHeight - 30;
		timerDisplay.selectable = false;
		
		addChild(scoreDisplay);
		addChild(timerDisplay);
		
	}
	
	private function getRemainingTime() : String
	{
		var time: String = Std.string(60 - elapsedTime);
		time = time.substr(0,time.indexOf("."))+"s";
		return time;
	}
	
	
	
	
	// Event Handlers
	
	
	
	
	private function Mole_onClick (event:MouseEvent):Void {
		
		var mole:Mole = cast (event.currentTarget, Mole);
		
		if (mole.active) {
			
			score += mole.points;
			scoreDisplay.text = "Score: "+Std.string(score);
			mole.hide (true);
			var sfx = null;
			if (mole.points == 10)
				sfx = Assets.getSound("sfx/kill.mp3");
			else if (mole.points == 15)
				sfx = Assets.getSound("sfx/santa.mp3");
			else
				sfx = Assets.getSound("sfx/grinch.mp3");
			sfx.play();
			
		}
		
	}
	
	
	private function this_onEnterFrame (event:Event):Void {
		
		elapsedTime = (Lib.getTimer () - startTime) / 1000;
		
		if (elapsedTime < 60) {
		
			timerDisplay.text = getRemainingTime();
			
			if (Math.random () < 0.01 * (1 + (elapsedTime * 0.45))) {
				
				createMole ();
				
			}
			
			for (mole in moles) {
				
				if (mole != null) {
					
					mole.step ();
				
					if (mole.dispose && mole.parent != null) {
						
						removeMole (mole);
						
					}
				
				}
				
			}
				
		} else {
			
			endGame ();
			
		}
		
	}
	
	private function fitScreen(bkg: DisplayObject):Void 
	{
		if(screenRatioX == -1){
			screenRatioX = Lib.current.stage.stageWidth / bkg.width;
			screenRatioY = Lib.current.stage.stageHeight / bkg.height;
		}
		bkg.width = Lib.current.stage.stageWidth+ 8;
		bkg.height = Lib.current.stage.stageHeight;
	}
	
	private static function onExit(e: Event) : Void 
	{
		Lib.exit();
	}
	
	private function saveHighScore() : Int 
	{
		var best = Std.parseInt(highScore.data.score);
		Lib.trace("Saved Score: " + best+", actual score"+score);
		
		if(score > (best==null?0:best)){
			highScore.data.score = Std.string(score);
			best = score;
		}

			
		#if ( cpp || neko )
			var flushStatus:SharedObjectFlushStatus = null;
		#else
			var flushStatus:String = null;
		#end
	
		try {
			flushStatus = highScore.flush() ;
		} 
		catch ( e: Dynamic ) {
			Lib.trace("couldn t write...");
		}
		
		if ( flushStatus != null ) {
			switch( flushStatus ) {
				case SharedObjectFlushStatus.PENDING:
						Lib.trace('requesting permission to save');
				case SharedObjectFlushStatus.FLUSHED:
						Lib.trace('value saved');
			}
		}
		Lib.trace("Best: " + best);
		return best;
	}
	
	
	public static function main () {
		Lib.current.addChild (new WhackAMole ());
		Lib.current.stage.addEventListener(Event.DEACTIVATE, onExit);		
	}
	
	
}
