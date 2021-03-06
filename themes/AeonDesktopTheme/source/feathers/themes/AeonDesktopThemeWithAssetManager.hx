/*
Copyright 2012-2015 Bowler Hat LLC

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package feathers.themes
{
import starling.events.Event;
import starling.utils.AssetManager;

/**
 * Dispatched when the theme's assets are loaded, and the theme has
 * initialized. Feathers component will not be skinned automatically by the
 * theme until this event is dispatched.
 *
 * <p>The properties of the event object have the following values:</p>
 * <table class="innertable">
 * <tr><th>Property</th><th>Value</th></tr>
 * <tr><td><code>bubbles</code></td><td>false</td></tr>
 * <tr><td><code>currentTarget</code></td><td>The Object that defines the
 *   event listener that handles the event. For example, if you use
 *   <code>myButton.addEventListener()</code> to register an event listener,
 *   myButton is the value of the <code>currentTarget</code>.</td></tr>
 * <tr><td><code>data</code></td><td>null</td></tr>
 * <tr><td><code>target</code></td><td>The Object that dispatched the event;
 *   it is not always the Object listening for the event. Use the
 *   <code>currentTarget</code> property to always access the Object
 *   listening for the event.</td></tr>
 * </table>
 *
 * @eventType starling.events.Event.COMPLETE
 */
[Event(name="complete",type="starling.events.Event")]

/**
 * The "Aeon" theme for desktop Feathers apps.
 *
 * <p>This version of the theme requires loading assets at runtime. To use
 * embedded assets, see <code>AeonDesktopTheme</code> instead.</p>
 *
 * <p>To use this theme, the following files must be included when packaging
 * your app:</p>
 * <ul>
 *     <li>images/aeon_desktop.png</li>
 *     <li>images/aeon_desktop.xml</li>
 * </ul>
 *
 * @see http://feathersui.com/help/theme-assets.html
 */
public class AeonDesktopThemeWithAssetManager extends BaseAeonDesktopTheme
{
	/**
	 * @private
	 * The name of the texture atlas in the asset manager.
	 */
	inline private static var ATLAS_NAME:String = "aeon_desktop";

	/**
	 * @private
	 */
	inline private static var ATLAS_SCALE_FACTOR:Int = 2;

	/**
	 * Constructor.
	 * @param assetsBasePath The root folder of the assets.
	 * @param assetManager An optional pre-created AssetManager. The scaleFactor property must be equal to Starling.contentScaleFactor. To load assets with a different scale factor, use multiple AssetManager instances.
	 */
	public function AeonDesktopThemeWithAssetManager(assetsBasePath:String = "./", assetManager:AssetManager = null)
	{
		this.loadAssets(assetsBasePath, assetManager);
	}

	/**
	 * @private
	 */
	private var assetManager:AssetManager;

	/**
	 * @private
	 * The paths to each of the assets, relative to the base path.
	 */
	private var assetPaths:Vector.<String> = new <String>
	[
		"images/" + ATLAS_NAME + ".xml",
		"images/" + ATLAS_NAME + ".png"
	];

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		super.dispose();
		if(this.assetManager)
		{
			this.assetManager.removeTextureAtlas(ATLAS_NAME);
			this.assetManager = null;
		}
	}

	/**
	 * @private
	 */
	override private function initialize():Void
	{
		this.initializeTextureAtlas();
		super.initialize();
	}

	/**
	 * @private
	 */
	private function initializeTextureAtlas():Void
	{
		this.atlas = this.assetManager.getTextureAtlas(ATLAS_NAME);
	}

	/**
	 * @private
	 */
	private function assetManager_onProgress(progress:Float):Void
	{
		if(progress < 1)
		{
			return;
		}
		this.initialize();
		this.dispatchEventWith(Event.COMPLETE);
	}

	/**
	 * @private
	 */
	private function loadAssets(assetsBasePath:String, assetManager:AssetManager):Void
	{
		var oldScaleFactor:Float = -1;
		if(assetManager)
		{
			oldScaleFactor = assetManager.scaleFactor;
			assetManager.scaleFactor = ATLAS_SCALE_FACTOR;
		}
		else
		{
			assetManager = new AssetManager(ATLAS_SCALE_FACTOR);
		}
		this.assetManager = assetManager;
		//add a trailing slash, if needed
		if(assetsBasePath.lastIndexOf("/") != assetsBasePath.length - 1)
		{
			assetsBasePath += "/";
		}
		var assetCount:Int = this.assetPaths.length;
		for(var i:Int = 0; i < assetCount; i++)
		{
			var asset:String = this.assetPaths[i];
			this.assetManager.enqueue(assetsBasePath + asset);
		}
		if(oldScaleFactor != -1)
		{
			//restore the old scale factor, just in case
			this.assetManager.scaleFactor = oldScaleFactor;
		}
		this.assetManager.loadQueue(assetManager_onProgress);
	}
}
}
