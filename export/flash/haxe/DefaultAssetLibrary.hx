package;


import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.text.Font;
import flash.media.Sound;
import flash.net.URLRequest;
import flash.utils.ByteArray;
import haxe.Unserializer;
import openfl.Assets;

#if (flash || js)
import flash.display.Loader;
import flash.events.Event;
import flash.net.URLLoader;
#end

#if ios
import openfl.utils.SystemPath;
#end


class DefaultAssetLibrary extends AssetLibrary {
	
	
	public static var className (default, null) = new Map <String, Dynamic> ();
	public static var path (default, null) = new Map <String, String> ();
	public static var type (default, null) = new Map <String, AssetType> ();
	
	
	public function new () {
		
		super ();
		
		#if flash
		
		className.set ("gfx/debug/console_debug.png", __ASSET__gfx_debug_console_debug_png);
		type.set ("gfx/debug/console_debug.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/debug/console_logo.png", __ASSET__gfx_debug_console_logo_png);
		type.set ("gfx/debug/console_logo.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/debug/console_output.png", __ASSET__gfx_debug_console_output_png);
		type.set ("gfx/debug/console_output.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/debug/console_pause.png", __ASSET__gfx_debug_console_pause_png);
		type.set ("gfx/debug/console_pause.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/debug/console_play.png", __ASSET__gfx_debug_console_play_png);
		type.set ("gfx/debug/console_play.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/debug/console_step.png", __ASSET__gfx_debug_console_step_png);
		type.set ("gfx/debug/console_step.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("gfx/preloader/haxepunk.png", __ASSET__gfx_preloader_haxepunk_png);
		type.set ("gfx/preloader/haxepunk.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("font/04B_03__.ttf", __ASSET__font_04b_03___ttf);
		type.set ("font/04B_03__.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
		className.set ("art/background.png", __ASSET__art_background_png);
		type.set ("art/background.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("art/bomb.png", __ASSET__art_bomb_png);
		type.set ("art/bomb.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("art/bunker.png", __ASSET__art_bunker_png);
		type.set ("art/bunker.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("art/HaxePunkConsole/console_debug.png", __ASSET__art_haxepunkconsole_console_debug_png);
		type.set ("art/HaxePunkConsole/console_debug.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("art/HaxePunkConsole/console_logo.png", __ASSET__art_haxepunkconsole_console_logo_png);
		type.set ("art/HaxePunkConsole/console_logo.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("art/HaxePunkConsole/console_output.png", __ASSET__art_haxepunkconsole_console_output_png);
		type.set ("art/HaxePunkConsole/console_output.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("art/HaxePunkConsole/console_pause.png", __ASSET__art_haxepunkconsole_console_pause_png);
		type.set ("art/HaxePunkConsole/console_pause.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("art/HaxePunkConsole/console_play.png", __ASSET__art_haxepunkconsole_console_play_png);
		type.set ("art/HaxePunkConsole/console_play.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("art/HaxePunkConsole/console_step.png", __ASSET__art_haxepunkconsole_console_step_png);
		type.set ("art/HaxePunkConsole/console_step.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("art/inscrutablegames.png", __ASSET__art_inscrutablegames_png);
		type.set ("art/inscrutablegames.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("art/particle-fire.png", __ASSET__art_particle_fire_png);
		type.set ("art/particle-fire.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("art/particle-smoke.png", __ASSET__art_particle_smoke_png);
		type.set ("art/particle-smoke.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("art/robot.png", __ASSET__art_robot_png);
		type.set ("art/robot.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("art/stockpile.png", __ASSET__art_stockpile_png);
		type.set ("art/stockpile.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("art/tent.png", __ASSET__art_tent_png);
		type.set ("art/tent.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("art/truck.png", __ASSET__art_truck_png);
		type.set ("art/truck.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("sound/explode1.wav", __ASSET__sound_explode1_wav);
		type.set ("sound/explode1.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
		className.set ("sound/explode2.wav", __ASSET__sound_explode2_wav);
		type.set ("sound/explode2.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
		className.set ("sound/explode3.wav", __ASSET__sound_explode3_wav);
		type.set ("sound/explode3.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
		className.set ("font/04B_03__.ttf", __ASSET__font_5);
		type.set ("font/04B_03__.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
		className.set ("font/AccidentalPresidency.ttf", __ASSET__font_accidentalpresidency_ttf);
		type.set ("font/AccidentalPresidency.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
		className.set ("data/game.xml", __ASSET__data_game_xml);
		type.set ("data/game.xml", Reflect.field (AssetType, "text".toUpperCase ()));
		
		
		#elseif html5
		
		path.set ("gfx/debug/console_debug.png", "gfx/debug/console_debug.png");
		type.set ("gfx/debug/console_debug.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/debug/console_logo.png", "gfx/debug/console_logo.png");
		type.set ("gfx/debug/console_logo.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/debug/console_output.png", "gfx/debug/console_output.png");
		type.set ("gfx/debug/console_output.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/debug/console_pause.png", "gfx/debug/console_pause.png");
		type.set ("gfx/debug/console_pause.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/debug/console_play.png", "gfx/debug/console_play.png");
		type.set ("gfx/debug/console_play.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/debug/console_step.png", "gfx/debug/console_step.png");
		type.set ("gfx/debug/console_step.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("gfx/preloader/haxepunk.png", "gfx/preloader/haxepunk.png");
		type.set ("gfx/preloader/haxepunk.png", Reflect.field (AssetType, "image".toUpperCase ()));
		className.set ("font/04B_03__.ttf", __ASSET__font_04b_03___ttf);
		type.set ("font/04B_03__.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
		path.set ("art/background.png", "art/background.png");
		type.set ("art/background.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("art/bomb.png", "art/bomb.png");
		type.set ("art/bomb.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("art/bunker.png", "art/bunker.png");
		type.set ("art/bunker.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("art/HaxePunkConsole/console_debug.png", "art/HaxePunkConsole/console_debug.png");
		type.set ("art/HaxePunkConsole/console_debug.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("art/HaxePunkConsole/console_logo.png", "art/HaxePunkConsole/console_logo.png");
		type.set ("art/HaxePunkConsole/console_logo.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("art/HaxePunkConsole/console_output.png", "art/HaxePunkConsole/console_output.png");
		type.set ("art/HaxePunkConsole/console_output.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("art/HaxePunkConsole/console_pause.png", "art/HaxePunkConsole/console_pause.png");
		type.set ("art/HaxePunkConsole/console_pause.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("art/HaxePunkConsole/console_play.png", "art/HaxePunkConsole/console_play.png");
		type.set ("art/HaxePunkConsole/console_play.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("art/HaxePunkConsole/console_step.png", "art/HaxePunkConsole/console_step.png");
		type.set ("art/HaxePunkConsole/console_step.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("art/inscrutablegames.png", "art/inscrutablegames.png");
		type.set ("art/inscrutablegames.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("art/particle-fire.png", "art/particle-fire.png");
		type.set ("art/particle-fire.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("art/particle-smoke.png", "art/particle-smoke.png");
		type.set ("art/particle-smoke.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("art/robot.png", "art/robot.png");
		type.set ("art/robot.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("art/stockpile.png", "art/stockpile.png");
		type.set ("art/stockpile.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("art/tent.png", "art/tent.png");
		type.set ("art/tent.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("art/truck.png", "art/truck.png");
		type.set ("art/truck.png", Reflect.field (AssetType, "image".toUpperCase ()));
		path.set ("sound/explode1.wav", "sound/explode1.wav");
		type.set ("sound/explode1.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
		path.set ("sound/explode2.wav", "sound/explode2.wav");
		type.set ("sound/explode2.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
		path.set ("sound/explode3.wav", "sound/explode3.wav");
		type.set ("sound/explode3.wav", Reflect.field (AssetType, "sound".toUpperCase ()));
		className.set ("font/04B_03__.ttf", __ASSET__font_5);
		type.set ("font/04B_03__.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
		className.set ("font/AccidentalPresidency.ttf", __ASSET__font_accidentalpresidency_ttf);
		type.set ("font/AccidentalPresidency.ttf", Reflect.field (AssetType, "font".toUpperCase ()));
		path.set ("data/game.xml", "data/game.xml");
		type.set ("data/game.xml", Reflect.field (AssetType, "text".toUpperCase ()));
		
		
		#else
		
		try {
			
			#if blackberry
			var bytes = ByteArray.readFile ("app/native/manifest");
			#elseif tizen
			var bytes = ByteArray.readFile ("../res/manifest");
			#else
			var bytes = ByteArray.readFile ("manifest");
			#end
			
			if (bytes != null) {
				
				bytes.position = 0;
				
				if (bytes.length > 0) {
					
					var data = bytes.readUTFBytes (bytes.length);
					
					if (data != null && data.length > 0) {
						
						var manifest:Array<AssetData> = Unserializer.run (data);
						
						for (asset in manifest) {
							
							path.set (asset.id, asset.path);
							type.set (asset.id, asset.type);
							
						}
						
					}
					
				}
				
			} else {
				
				trace ("Warning: Could not load asset manifest");
				
			}
			
		} catch (e:Dynamic) {
			
			trace ("Warning: Could not load asset manifest");
			
		}
		
		#end
		
	}
	
	
	public override function exists (id:String, type:AssetType):Bool {
		
		var assetType = DefaultAssetLibrary.type.get (id);
		
		#if pixi
		
		if (assetType == IMAGE) {
			
			return true;
			
		} else {
			
			return false;
			
		}
		
		#end
		
		if (assetType != null) {
			
			if (assetType == type || ((type == SOUND || type == MUSIC) && (assetType == MUSIC || assetType == SOUND))) {
				
				return true;
				
			}
			
			#if flash
			
			if ((assetType == BINARY || assetType == TEXT) && type == BINARY) {
				
				return true;
				
			} else if (path.exists (id)) {
				
				return true;
				
			}
			
			#else
			
			if (type == BINARY || type == null) {
				
				return true;
				
			}
			
			#end
			
		}
		
		return false;
		
	}
	
	
	public override function getBitmapData (id:String):BitmapData {
		
		#if pixi
		
		return BitmapData.fromImage (path.get (id));
		
		#elseif flash
		
		return cast (Type.createInstance (className.get (id), []), BitmapData);
		
		#elseif js
		
		return cast (ApplicationMain.loaders.get (path.get (id)).contentLoaderInfo.content, Bitmap).bitmapData;
		
		#else
		
		return BitmapData.load (path.get (id));
		
		#end
		
	}
	
	
	public override function getBytes (id:String):ByteArray {
		
		#if pixi
		
		return null;
		
		#elseif flash
		
		return cast (Type.createInstance (className.get (id), []), ByteArray);
		
		#elseif js
		
		var bytes:ByteArray = null;
		var data = ApplicationMain.urlLoaders.get (path.get (id)).data;
		
		if (Std.is (data, String)) {
			
			bytes = new ByteArray ();
			bytes.writeUTFBytes (data);
			
		} else if (Std.is (data, ByteArray)) {
			
			bytes = cast data;
			
		} else {
			
			bytes = null;
			
		}

		if (bytes != null) {
			
			bytes.position = 0;
			return bytes;
			
		} else {
			
			return null;
		}
		
		#else
		
		return ByteArray.readFile (path.get (id));
		
		#end
		
	}
	
	
	public override function getFont (id:String):Font {
		
		#if pixi
		
		return null;
		
		#elseif (flash || js)
		
		return cast (Type.createInstance (className.get (id), []), Font);
		
		#else
		
		return new Font (path.get (id));
		
		#end
		
	}
	
	
	public override function getMusic (id:String):Sound {
		
		#if pixi
		
		//return null;		
		
		#elseif flash
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
		#elseif js
		
		return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		return new Sound (new URLRequest (path.get (id)), null, true);
		
		#end
		
	}
	
	
	public override function getPath (id:String):String {
		
		#if ios
		
		return SystemPath.applicationDirectory + "/assets/" + path.get (id);
		
		#else
		
		return path.get (id);
		
		#end
		
	}
	
	
	public override function getSound (id:String):Sound {
		
		#if pixi
		
		return null;
		
		#elseif flash
		
		return cast (Type.createInstance (className.get (id), []), Sound);
		
		#elseif js
		
		return new Sound (new URLRequest (path.get (id)));
		
		#else
		
		return new Sound (new URLRequest (path.get (id)), null, type.get (id) == MUSIC);
		
		#end
		
	}
	
	
	public override function isLocal (id:String, type:AssetType):Bool {
		
		#if flash
		
		if (type != AssetType.MUSIC && type != AssetType.SOUND) {
			
			return className.exists (id);
			
		}
		
		#end
		
		return true;
		
	}
	
	
	public override function loadBitmapData (id:String, handler:BitmapData -> Void):Void {
		
		#if pixi
		
		handler (getBitmapData (id));
		
		#elseif (flash || js)
		
		if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event:Event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getBitmapData (id));
			
		}
		
		#else
		
		handler (getBitmapData (id));
		
		#end
		
	}
	
	
	public override function loadBytes (id:String, handler:ByteArray -> Void):Void {
		
		#if pixi
		
		handler (getBytes (id));
		
		#elseif (flash || js)
		
		if (path.exists (id)) {
			
			var loader = new URLLoader ();
			loader.addEventListener (Event.COMPLETE, function (event:Event) {
				
				var bytes = new ByteArray ();
				bytes.writeUTFBytes (event.currentTarget.data);
				bytes.position = 0;
				
				handler (bytes);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {
			
			handler (getBytes (id));
			
		}
		
		#else
		
		handler (getBytes (id));
		
		#end
		
	}
	
	
	public override function loadFont (id:String, handler:Font -> Void):Void {
		
		#if (flash || js)
		
		/*if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {*/
			
			handler (getFont (id));
			
		//}
		
		#else
		
		handler (getFont (id));
		
		#end
		
	}
	
	
	public override function loadMusic (id:String, handler:Sound -> Void):Void {
		
		#if (flash || js)
		
		/*if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {*/
			
			handler (getMusic (id));
			
		//}
		
		#else
		
		handler (getMusic (id));
		
		#end
		
	}
	
	
	public override function loadSound (id:String, handler:Sound -> Void):Void {
		
		#if (flash || js)
		
		/*if (path.exists (id)) {
			
			var loader = new Loader ();
			loader.contentLoaderInfo.addEventListener (Event.COMPLETE, function (event) {
				
				handler (cast (event.currentTarget.content, Bitmap).bitmapData);
				
			});
			loader.load (new URLRequest (path.get (id)));
			
		} else {*/
			
			handler (getSound (id));
			
		//}
		
		#else
		
		handler (getSound (id));
		
		#end
		
	}
	
	
}


#if pixi
#elseif flash

class __ASSET__gfx_debug_console_debug_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_debug_console_logo_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_debug_console_output_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_debug_console_pause_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_debug_console_play_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_debug_console_step_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__gfx_preloader_haxepunk_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__font_04b_03___ttf extends flash.text.Font { }
class __ASSET__art_background_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__art_bomb_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__art_bunker_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__art_haxepunkconsole_console_debug_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__art_haxepunkconsole_console_logo_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__art_haxepunkconsole_console_output_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__art_haxepunkconsole_console_pause_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__art_haxepunkconsole_console_play_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__art_haxepunkconsole_console_step_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__art_inscrutablegames_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__art_particle_fire_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__art_particle_smoke_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__art_robot_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__art_stockpile_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__art_tent_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__art_truck_png extends flash.display.BitmapData { public function new () { super (0, 0); } }
class __ASSET__sound_explode1_wav extends flash.media.Sound { }
class __ASSET__sound_explode2_wav extends flash.media.Sound { }
class __ASSET__sound_explode3_wav extends flash.media.Sound { }
class __ASSET__font_5 extends flash.text.Font { }
class __ASSET__font_accidentalpresidency_ttf extends flash.text.Font { }
class __ASSET__data_game_xml extends flash.utils.ByteArray { }


#elseif html5








class __ASSET__font_04b_03___ttf extends flash.text.Font { }



















class __ASSET__font_5 extends flash.text.Font { }
class __ASSET__font_accidentalpresidency_ttf extends flash.text.Font { }



#end