package;


import nme.display.Bitmap;
import nme.display.BitmapData;
import nme.display.Sprite;
import nme.display.Loader;
import nme.net.URLRequest;
import nme.utils.ByteArray;
import nme.Assets;


class Utils {


	private static var loadGraphicCache:Hash <BitmapData> = new Hash <BitmapData> ();
	
	
	public static function loadGraphic (path:String, forceSprite:Bool = false, cache:Bool = true):Dynamic {
		
		var bitmap:Bitmap;
		
		if (cache) {
			
			if (!loadGraphicCache.exists (path)) {
				
				loadGraphicCache.set (path, Assets.getBitmapData (path));
				
			}
			
			bitmap = new Bitmap (loadGraphicCache.get (path));
			
		} else {
			
			bitmap = new Bitmap (Assets.getBitmapData (path));
			
		}
	
		if (forceSprite) {
			
			var sprite:Sprite = new Sprite ();
			sprite.addChild (bitmap);
			
			return sprite;
			
		} else {
			
			return bitmap;
			
		}
		
	}


}
