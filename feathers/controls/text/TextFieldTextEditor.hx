/*
Feathers
Copyright 2012-2014 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.controls.text;
import feathers.core.FeathersControl;
import feathers.core.ITextEditor;
import feathers.events.FeathersEventType;
import feathers.utils.geom.matrixToRotation;
import feathers.utils.geom.matrixToScaleX;
import feathers.utils.geom.matrixToScaleY;

import flash.display.BitmapData;
import flash.display3D.Context3DProfile;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.SoftKeyboardEvent;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFieldType;
import flash.text.TextFormat;
import flash.ui.Keyboard;

import starling.core.RenderSupport;
import starling.core.Starling;
import starling.display.Image;
import starling.events.Event;
import starling.textures.ConcreteTexture;
import starling.textures.Texture;
import starling.utils.MatrixUtil;
import starling.utils.getNextPowerOfTwo;

/**
 * Dispatched when the text property changes.
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
 *///[Event(name="change",type="starling.events.Event")]

/**
 * Dispatched when the user presses the Enter key while the editor has focus.
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
 * @eventType feathers.events.FeathersEventType.ENTER
 *///[Event(name="enter",type="starling.events.Event")]

/**
 * Dispatched when the text editor receives focus.
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
 * @eventType feathers.events.FeathersEventType.FOCUS_IN
 *///[Event(name="focusIn",type="starling.events.Event")]

/**
 * Dispatched when the text editor loses focus.
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
 * @eventType feathers.events.FeathersEventType.FOCUS_OUT
 *///[Event(name="focusOut",type="starling.events.Event")]

/**
 * Dispatched when the soft keyboard is activated. Not all text editors will
 * activate a soft keyboard.
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
 * @eventType feathers.events.FeathersEventType.SOFT_KEYBOARD_ACTIVATE
 *///[Event(name="softKeyboardActivate",type="starling.events.Event")]

/**
 * Dispatched when the soft keyboard is deactivated. Not all text editors
 * will activate a soft keyboard.
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
 * @eventType feathers.events.FeathersEventType.SOFT_KEYBOARD_DEACTIVATE
 *///[Event(name="softKeyboardDeactivate",type="starling.events.Event")]

/**
 * A Feathers text editor that uses the native <code>flash.text.TextField</code>
 * class with its <code>type</code> property set to
 * <code>flash.text.TextInputType.INPUT</code>. Textures are completely
 * managed by this component, and they will be automatically disposed when
 * the component is disposed.
 *
 * <p>For desktop apps, <code>TextFieldTextEditor</code> is recommended
 * instead of <code>StageTextTextEditor</code>. <code>StageTextTextEditor</code>
 * will still work in desktop apps, but it is more appropriate for mobile
 * apps.</p>
 *
 * @see http://wiki.starling-framework.org/feathers/text-editors
 *
 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html flash.text.TextField
 */
class TextFieldTextEditor extends FeathersControl implements ITextEditor
{
	/**
	 * @private
	 */
	inline private static var HELPER_MATRIX:Matrix = new Matrix();

	/**
	 * @private
	 */
	inline private static var HELPER_POINT:Point = new Point();

	/**
	 * Constructor.
	 */
	public function TextFieldTextEditor()
	{
		this.isQuickHitAreaEnabled = true;
		this.addEventListener(Event.ADDED_TO_STAGE, textEditor_addedToStageHandler);
		this.addEventListener(Event.REMOVED_FROM_STAGE, textEditor_removedFromStageHandler);
	}

	/**
	 * The text field sub-component.
	 */
	private var textField:TextField;

	/**
	 * An image that displays a snapshot of the native <code>TextField</code>
	 * in the Starling display list when the editor doesn't have focus.
	 */
	private var textSnapshot:Image;

	/**
	 * The separate text field sub-component used for measurement.
	 * Typically, the main text field often doesn't report correct values
	 * for a full frame if its dimensions are changed too often.
	 */
	private var measureTextField:TextField;

	/**
	 * @private
	 */
	private var _snapshotWidth:Int = 0;

	/**
	 * @private
	 */
	private var _snapshotHeight:Int = 0;

	/**
	 * @private
	 */
	private var _textFieldClipRect:Rectangle = new Rectangle();

	/**
	 * @private
	 */
	private var _textFieldOffsetX:Float = 0;

	/**
	 * @private
	 */
	private var _textFieldOffsetY:Float = 0;

	/**
	 * @private
	 */
	private var _needsNewTexture:Bool = false;

	/**
	 * @private
	 */
	private var _text:String = "";

	/**
	 * @inheritDoc
	 *
	 * <p>In the following example, the text is changed:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.text = "Lorem ipsum";</listing>
	 *
	 * @default ""
	 */
	public function get_text():String
	{
		return this._text;
	}

	/**
	 * @private
	 */
	public function set_text(value:String):Void
	{
		if(!value)
		{
			//don't allow null or undefined
			value = "";
		}
		if(this._text == value)
		{
			return;
		}
		this._text = value;
		this.invalidate(INVALIDATION_FLAG_DATA);
		this.dispatchEventWith(Event.CHANGE);
	}

	/**
	 * @inheritDoc
	 */
	public function get_baseline():Float
	{
		if(!this.textField)
		{
			return 0;
		}
		var gutterDimensionsOffset:Float = 0;
		if(this._useGutter)
		{
			gutterDimensionsOffset = 2;
		}
		return gutterDimensionsOffset + this.textField.getLineMetrics(0).ascent;
	}

	/**
	 * @private
	 */
	private var _previousTextFormat:TextFormat;

	/**
	 * @private
	 */
	private var _textFormat:TextFormat;

	/**
	 * The format of the text, such as font and styles.
	 *
	 * <p>In the following example, the text format is changed:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.textFormat = new TextFormat( "Source Sans Pro" );;</listing>
	 *
	 * @default null
	 *
	 * @see #disabledTextFormat
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFormat.html flash.text.TextFormat
	 */
	public function get_textFormat():TextFormat
	{
		return this._textFormat;
	}

	/**
	 * @private
	 */
	public function set_textFormat(value:TextFormat):Void
	{
		if(this._textFormat == value)
		{
			return;
		}
		this._textFormat = value;
		//since the text format has changed, the comparison will return
		//false whether we use the real previous format or null. might as
		//well remove the reference to an object we don't need anymore.
		this._previousTextFormat = null;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _disabledTextFormat:TextFormat;

	/**
	 * The font and styles used to draw the text when the component is disabled.
	 *
	 * <p>In the following example, the disabled text format is changed:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.isEnabled = false;
	 * textEditor.disabledTextFormat = new TextFormat( "Source Sans Pro" );</listing>
	 *
	 * @default null
	 *
	 * @see #textFormat
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextFormat.html flash.text.TextFormat
	 */
	public function get_disabledTextFormat():TextFormat
	{
		return this._disabledTextFormat;
	}

	/**
	 * @private
	 */
	public function set_disabledTextFormat(value:TextFormat):Void
	{
		if(this._disabledTextFormat == value)
		{
			return;
		}
		this._disabledTextFormat = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _embedFonts:Bool = false;

	/**
	 * Determines if the TextField should use an embedded font or not. If
	 * the specified font is not embedded, the text is not displayed.
	 *
	 * <p>In the following example, the font is embedded:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.embedFonts = true;</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#embedFonts Full description of flash.text.TextField.embedFonts in Adobe's Flash Platform API Reference
	 */
	public function get_embedFonts():Bool
	{
		return this._embedFonts;
	}

	/**
	 * @private
	 */
	public function set_embedFonts(value:Bool):Void
	{
		if(this._embedFonts == value)
		{
			return;
		}
		this._embedFonts = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _wordWrap:Bool = false;

	/**
	 * Determines if the TextField wraps text to the next line.
	 *
	 * <p>In the following example, word wrap is enabled:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.wordWrap = true;</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#wordWrap Full description of flash.text.TextField.wordWrap in Adobe's Flash Platform API Reference
	 */
	public function get_wordWrap():Bool
	{
		return this._wordWrap;
	}

	/**
	 * @private
	 */
	public function set_wordWrap(value:Bool):Void
	{
		if(this._wordWrap == value)
		{
			return;
		}
		this._wordWrap = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _multiline:Bool = false;

	/**
	 * Indicates whether field is a multiline text field.
	 *
	 * <p>In the following example, multiline is enabled:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.multiline = true;</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#multiline Full description of flash.text.TextField.multiline in Adobe's Flash Platform API Reference
	 */
	public function get_multiline():Bool
	{
		return this._multiline;
	}

	/**
	 * @private
	 */
	public function set_multiline(value:Bool):Void
	{
		if(this._multiline == value)
		{
			return;
		}
		this._multiline = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _isHTML:Bool = false;

	/**
	 * Determines if the TextField should display the value of the
	 * <code>text</code> property as HTML or not.
	 *
	 * <p>In the following example, the text is displayed as HTML:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.isHTML = true;</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#htmlText flash.text.TextField.htmlText
	 */
	public function get_isHTML():Bool
	{
		return this._isHTML;
	}

	/**
	 * @private
	 */
	public function set_isHTML(value:Bool):Void
	{
		if(this._isHTML == value)
		{
			return;
		}
		this._isHTML = value;
		this.invalidate(INVALIDATION_FLAG_DATA);
	}

	/**
	 * @private
	 */
	private var _alwaysShowSelection:Bool = false;

	/**
	 * When set to <code>true</code> and the text field is not in focus,
	 * Flash Player highlights the selection in the text field in gray. When
	 * set to <code>false</code> and the text field is not in focus, Flash
	 * Player does not highlight the selection in the text field.
	 *
	 * <p>In the following example, the selection is always shown:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.alwaysShowSelection = true;</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#alwaysShowSelection Full description of flash.text.TextField.alwaysShowSelection in Adobe's Flash Platform API Reference
	 */
	public function get_alwaysShowSelection():Bool
	{
		return this._alwaysShowSelection;
	}

	/**
	 * @private
	 */
	public function set_alwaysShowSelection(value:Bool):Void
	{
		if(this._alwaysShowSelection == value)
		{
			return;
		}
		this._alwaysShowSelection = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _displayAsPassword:Bool = false;

	/**
	 * Specifies whether the text field is a password text field that hides
	 * the input characters using asterisks instead of the actual
	 * characters.
	 *
	 * <p>In the following example, the text is displayed as as password:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.fontWeight = FontWeight.BOLD;</listing>
	 *
	 * @default false
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#displayAsPassword Full description of flash.text.TextField.displayAsPassword in Adobe's Flash Platform API Reference
	 */
	public function get_displayAsPassword():Bool
	{
		return this._displayAsPassword;
	}

	/**
	 * @private
	 */
	public function set_displayAsPassword(value:Bool):Void
	{
		if(this._displayAsPassword == value)
		{
			return;
		}
		this._displayAsPassword = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _maxChars:Int = 0;

	/**
	 * The maximum number of characters that the text field can contain, as
	 * entered by a user. A script can insert more text than <code>maxChars</code>
	 * allows. If the value of this property is <code>0</code>, a user can
	 * enter an unlimited amount of text.
	 *
	 * <p>In the following example, the maximum character count is changed:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.maxChars = 10;</listing>
	 *
	 * @default 0
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#maxChars Full description of flash.text.TextField.maxChars in Adobe's Flash Platform API Reference
	 */
	public function get_maxChars():Int
	{
		return this._maxChars;
	}

	/**
	 * @private
	 */
	public function set_maxChars(value:Int):Void
	{
		if(this._maxChars == value)
		{
			return;
		}
		this._maxChars = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _restrict:String;

	/**
	 * Indicates the set of characters that a user can enter into the text
	 * field. Only user interaction is restricted; a script can put any text
	 * into the text field.
	 *
	 * <p>In the following example, the text is restricted to numbers:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.restrict = "0-9";</listing>
	 *
	 * @default null
	 *
	 * @see http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/text/TextField.html#restrict Full description of flash.text.TextField.restrict in Adobe's Flash Platform API Reference
	 */
	public function get_restrict():String
	{
		return this._restrict;
	}

	/**
	 * @private
	 */
	public function set_restrict(value:String):Void
	{
		if(this._restrict == value)
		{
			return;
		}
		this._restrict = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _isEditable:Bool = true;

	/**
	 * Determines if the text input is editable. If the text input is not
	 * editable, it will still appear enabled.
	 *
	 * <p>In the following example, the text is not editable:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.isEditable = false;</listing>
	 *
	 * @default true
	 */
	public function get_isEditable():Bool
	{
		return this._isEditable;
	}

	/**
	 * @private
	 */
	public function set_isEditable(value:Bool):Void
	{
		if(this._isEditable == value)
		{
			return;
		}
		this._isEditable = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @private
	 */
	private var _useGutter:Bool = false;

	/**
	 * Determines if the 2-pixel gutter around the edges of the
	 * <code>flash.text.TextField</code> will be used in measurement and
	 * layout. To visually align with other text renderers and text editors,
	 * it is often best to leave the gutter disabled.
	 *
	 * <p>In the following example, the gutter is enabled:</p>
	 *
	 * <listing version="3.0">
	 * textEditor.useGutter = true;</listing>
	 *
	 * @default false
	 */
	public function get_useGutter():Bool
	{
		return this._useGutter;
	}

	/**
	 * @private
	 */
	public function set_useGutter(value:Bool):Void
	{
		if(this._useGutter == value)
		{
			return;
		}
		this._useGutter = value;
		this.invalidate(INVALIDATION_FLAG_STYLES);
	}

	/**
	 * @inheritDoc
	 */
	public function get_setTouchFocusOnEndedPhase():Bool
	{
		return false;
	}

	/**
	 * @private
	 */
	private var _textFieldHasFocus:Bool = false;

	/**
	 * @private
	 */
	private var _isWaitingToSetFocus:Bool = false;

	/**
	 * @private
	 */
	private var _pendingSelectionBeginIndex:Int = -1;

	/**
	 * @inheritDoc
	 */
	public function get_selectionBeginIndex():Int
	{
		if(this._pendingSelectionBeginIndex >= 0)
		{
			return this._pendingSelectionBeginIndex;
		}
		if(this.textField)
		{
			return this.textField.selectionBeginIndex;
		}
		return 0;
	}

	/**
	 * @private
	 */
	private var _pendingSelectionEndIndex:Int = -1;

	/**
	 * @inheritDoc
	 */
	public function get_selectionEndIndex():Int
	{
		if(this._pendingSelectionEndIndex >= 0)
		{
			return this._pendingSelectionEndIndex;
		}
		if(this.textField)
		{
			return this.textField.selectionEndIndex;
		}
		return 0;
	}

	/**
	 * @private
	 */
	private var resetScrollOnFocusOut:Bool = true;

	/**
	 * @private
	 */
	override public function dispose():Void
	{
		if(this.textSnapshot)
		{
			//avoid the need to call dispose(). we'll create a new snapshot
			//when the renderer is added to stage again.
			this.textSnapshot.texture.dispose();
			this.removeChild(this.textSnapshot, true);
			this.textSnapshot = null;
		}

		if(this.textField && this.textField.parent)
		{
			this.textField.parent.removeChild(this.textField);
		}
		//this isn't necessary, but if a memory leak keeps the text renderer
		//from being garbage collected, freeing up the text field may help
		//ease major memory pressure from native filters
		this.textField = null;
		this.measureTextField = null;

		super.dispose();
	}

	/**
	 * @private
	 */
	override public function render(support:RenderSupport, parentAlpha:Float):Void
	{
		//theoretically, this will ensure that the TextField is set visible
		//or invisible immediately after the snapshot changes visibility in
		//the rendered graphics. the OS might take longer to do the change,
		//though.
		var isTextFieldVisible:Bool = this.textSnapshot ? !this.textSnapshot.visible : this._textFieldHasFocus;
		this.textField.visible = isTextFieldVisible;

		this.transformTextField();
		this.positionSnapshot();

		super.render(support, parentAlpha);
	}

	/**
	 * @inheritDoc
	 */
	public function setFocus(position:Point = null):Void
	{
		if(this.textField)
		{
			if(!this.textField.parent)
			{
				Starling.current.nativeStage.addChild(this.textField);
			}
			if(position)
			{
				var gutterPositionOffset:Float = 2;
				if(this._useGutter)
				{
					gutterPositionOffset = 0;
				}
				var positionX:Float = position.x + gutterPositionOffset;
				var positionY:Float = position.y + gutterPositionOffset;
				if(positionX < 0)
				{
					this._pendingSelectionBeginIndex = this._pendingSelectionEndIndex = 0;
				}
				else
				{
					this._pendingSelectionBeginIndex = this.textField.getCharIndexAtPoint(positionX, positionY);
					if(this._pendingSelectionBeginIndex < 0)
					{
						if(this._multiline)
						{
							var lineIndex:Int = int(positionY / this.textField.getLineMetrics(0).height) + (this.textField.scrollV - 1);
							try
							{
								this._pendingSelectionBeginIndex = this.textField.getLineOffset(lineIndex) + this.textField.getLineLength(lineIndex);
								if(this._pendingSelectionBeginIndex != this._text.length)
								{
									this._pendingSelectionBeginIndex--;
								}
							}
							catch(error:Error)
							{
								//we may be checking for a line beyond the
								//end that doesn't exist
								this._pendingSelectionBeginIndex = this._text.length;
							}
						}
						else
						{
							this._pendingSelectionBeginIndex = this.textField.getCharIndexAtPoint(positionX, this.textField.getLineMetrics(0).ascent / 2);
							if(this._pendingSelectionBeginIndex < 0)
							{
								this._pendingSelectionBeginIndex = this._text.length;
							}
						}
					}
					else
					{
						var bounds:Rectangle = this.textField.getCharBoundaries(this._pendingSelectionBeginIndex);
						//bounds should never be null because the character
						//index passed to getCharBoundaries() comes from a
						//call to getCharIndexAtPoint(). however, a user
						//reported that a null reference error happened
						//here! I couldn't reproduce, but I might as well
						//assume that the runtime has a bug. won't hurt.
						if(bounds)
						{
							var boundsX:Float = bounds.x;
							if(bounds && (boundsX + bounds.width - positionX) < (positionX - boundsX))
							{
								this._pendingSelectionBeginIndex++;
							}
						}
					}
					this._pendingSelectionEndIndex = this._pendingSelectionBeginIndex;
				}
			}
			else
			{
				this._pendingSelectionBeginIndex = this._pendingSelectionEndIndex = -1;
			}
			if(!this._focusManager)
			{
				Starling.current.nativeStage.focus = this.textField;
			}
			this.textField.requestSoftKeyboard();
			if(this._textFieldHasFocus)
			{
				this.invalidate(INVALIDATION_FLAG_SELECTED);
			}
		}
		else
		{
			this._isWaitingToSetFocus = true;
		}
	}

	/**
	 * @inheritDoc
	 */
	public function clearFocus():Void
	{
		if(!this._textFieldHasFocus || this._focusManager)
		{
			return;
		}
		Starling.current.nativeStage.focus = Starling.current.nativeStage;
	}

	/**
	 * @inheritDoc
	 */
	public function selectRange(beginIndex:Int, endIndex:Int):Void
	{
		if(this.textField)
		{
			if(!this._isValidating)
			{
				this.validate();
			}
			this.textField.setSelection(beginIndex, endIndex);
		}
		else
		{
			this._pendingSelectionBeginIndex = beginIndex;
			this._pendingSelectionEndIndex = endIndex;
		}
	}

	/**
	 * @inheritDoc
	 */
	public function measureText(result:Point = null):Point
	{
		if(!result)
		{
			result = new Point();
		}

		var needsWidth:Bool = this.explicitWidth != this.explicitWidth; //isNaN
		var needsHeight:Bool = this.explicitHeight != this.explicitHeight; //isNaN
		if(!needsWidth && !needsHeight)
		{
			result.x = this.explicitWidth;
			result.y = this.explicitHeight;
			return result;
		}

		//if a parent component validates before we're added to the stage,
		//measureText() may be called before initialization, so we need to
		//force it.
		if(!this._isInitialized)
		{
			this.initializeInternal();
		}

		this.commit();

		result = this.measure(result);

		return result;
	}

	/**
	 * @private
	 */
	override private function initialize():Void
	{
		this.textField = new TextField();
		this.textField.needsSoftKeyboard = true;
		this.textField.addEventListener(flash.events.Event.CHANGE, textField_changeHandler);
		this.textField.addEventListener(FocusEvent.FOCUS_IN, textField_focusInHandler);
		this.textField.addEventListener(FocusEvent.FOCUS_OUT, textField_focusOutHandler);
		this.textField.addEventListener(KeyboardEvent.KEY_DOWN, textField_keyDownHandler);
		this.textField.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_ACTIVATE, textField_softKeyboardActivateHandler);
		this.textField.addEventListener(SoftKeyboardEvent.SOFT_KEYBOARD_DEACTIVATE, textField_softKeyboardDeactivateHandler);

		this.measureTextField = new TextField();
		this.measureTextField.autoSize = TextFieldAutoSize.LEFT;
		this.measureTextField.selectable = false;
		this.measureTextField.mouseWheelEnabled = false;
		this.measureTextField.mouseEnabled = false;
	}

	/**
	 * @private
	 */
	override private function draw():Void
	{
		var sizeInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_SIZE);

		this.commit();

		sizeInvalid = this.autoSizeIfNeeded() || sizeInvalid;

		this.layout(sizeInvalid);
	}

	/**
	 * @private
	 */
	private function commit():Void
	{
		var stylesInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STYLES);
		var dataInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_DATA);
		var stateInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STATE);

		if(dataInvalid || stylesInvalid || stateInvalid)
		{
			this.commitStylesAndData(this.textField);
		}
	}

	/**
	 * If the component's dimensions have not been set explicitly, it will
	 * measure its content and determine an ideal size for itself. If the
	 * <code>explicitWidth</code> or <code>explicitHeight</code> member
	 * variables are set, those value will be used without additional
	 * measurement. If one is set, but not the other, the dimension with the
	 * explicit value will not be measured, but the other non-explicit
	 * dimension will still need measurement.
	 *
	 * <p>Calls <code>setSizeInternal()</code> to set up the
	 * <code>actualWidth</code> and <code>actualHeight</code> member
	 * variables used for layout.</p>
	 *
	 * <p>Meant for internal use, and subclasses may override this function
	 * with a custom implementation.</p>
	 */
	private function autoSizeIfNeeded():Bool
	{
		var needsWidth:Bool = this.explicitWidth != this.explicitWidth; //isNaN
		var needsHeight:Bool = this.explicitHeight != this.explicitHeight; //isNaN
		if(!needsWidth && !needsHeight)
		{
			return false;
		}

		this.measure(HELPER_POINT);
		return this.setSizeInternal(HELPER_POINT.x, HELPER_POINT.y, false);
	}

	/**
	 * @private
	 */
	private function measure(result:Point = null):Point
	{
		if(!result)
		{
			result = new Point();
		}

		var needsWidth:Bool = this.explicitWidth != this.explicitWidth; //isNaN
		var needsHeight:Bool = this.explicitHeight != this.explicitHeight; //isNaN

		if(!needsWidth && !needsHeight)
		{
			result.x = this.explicitWidth;
			result.y = this.explicitHeight;
			return result;
		}

		this.commitStylesAndData(this.measureTextField);

		var gutterDimensionsOffset:Float = 4;
		if(this._useGutter)
		{
			gutterDimensionsOffset = 0;
		}

		var newWidth:Float = this.explicitWidth;
		if(needsWidth)
		{
			this.measureTextField.wordWrap = false;
			newWidth = this.measureTextField.width - gutterDimensionsOffset;
			if(newWidth < this._minWidth)
			{
				newWidth = this._minWidth;
			}
			else if(newWidth > this._maxWidth)
			{
				newWidth = this._maxWidth;
			}
		}

		var newHeight:Float = this.explicitHeight;
		if(needsHeight)
		{
			this.measureTextField.wordWrap = this._wordWrap;
			this.measureTextField.width = newWidth + gutterDimensionsOffset;
			newHeight = this.measureTextField.height - gutterDimensionsOffset;
			if(this._useGutter)
			{
				newHeight += 4;
			}
			if(newHeight < this._minHeight)
			{
				newHeight = this._minHeight;
			}
			else if(newHeight > this._maxHeight)
			{
				newHeight = this._maxHeight;
			}
		}

		result.x = newWidth;
		result.y = newHeight;

		return result;
	}

	/**
	 * @private
	 */
	private function commitStylesAndData(textField:TextField):Void
	{
		textField.maxChars = this._maxChars;
		textField.restrict = this._restrict;
		textField.alwaysShowSelection = this._alwaysShowSelection;
		textField.displayAsPassword = this._displayAsPassword;
		textField.wordWrap = this._wordWrap;
		textField.multiline = this._multiline;
		textField.embedFonts = this._embedFonts;
		textField.type = this._isEditable ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
		textField.selectable = this._isEnabled;
		var isFormatDifferent:Bool = false;
		var currentTextFormat:TextFormat;
		if(!this._isEnabled && this._disabledTextFormat)
		{
			currentTextFormat = this._disabledTextFormat;
		}
		else
		{
			currentTextFormat = this._textFormat;
		}
		if(currentTextFormat)
		{
			//for some reason, textField.defaultTextFormat always fails
			//comparison against currentTextFormat. if we save to a member
			//variable and compare against that instead, it works.
			//I guess text field creates a different TextFormat object.
			isFormatDifferent = this._previousTextFormat != currentTextFormat;
			this._previousTextFormat = currentTextFormat;
			textField.defaultTextFormat = currentTextFormat;
		}
		if(this._isHTML)
		{
			if(isFormatDifferent || textField.htmlText != this._text)
			{
				if(textField == this.textField && this._pendingSelectionBeginIndex < 0)
				{
					this._pendingSelectionBeginIndex = this.textField.selectionBeginIndex;
					this._pendingSelectionEndIndex = this.textField.selectionEndIndex;
				}
				textField.htmlText = this._text;
			}
		}
		else
		{
			if(isFormatDifferent || textField.text != this._text)
			{
				if(textField == this.textField && this._pendingSelectionBeginIndex < 0)
				{
					this._pendingSelectionBeginIndex = this.textField.selectionBeginIndex;
					this._pendingSelectionEndIndex = this.textField.selectionEndIndex;
				}
				textField.text = this._text;
			}
		}
	}

	/**
	 * @private
	 */
	private function layout(sizeInvalid:Bool):Void
	{
		var stylesInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STYLES);
		var dataInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_DATA);
		var stateInvalid:Bool = this.isInvalid(INVALIDATION_FLAG_STATE);

		if(sizeInvalid)
		{
			this.refreshSnapshotParameters();
			this.refreshTextFieldSize();
			this.transformTextField();
			this.positionSnapshot();
		}

		this.checkIfNewSnapshotIsNeeded();

		if(!this._textFieldHasFocus && (stylesInvalid || dataInvalid || stateInvalid || this._needsNewTexture))
		{
			//we need to wait a frame for the flash.text.TextField to render
			//properly. sometimes two, and this is a known issue.
			this.addEventListener(Event.ENTER_FRAME, textEditor_enterFrameHandler);
		}
		this.doPendingActions();
	}

	/**
	 * @private
	 */
	private function refreshTextFieldSize():Void
	{
		var gutterDimensionsOffset:Float = 4;
		if(this._useGutter)
		{
			gutterDimensionsOffset = 0;
		}
		this.textField.width = this.actualWidth + gutterDimensionsOffset;
		this.textField.height = this.actualHeight + gutterDimensionsOffset;
	}

	/**
	 * @private
	 */
	private function refreshSnapshotParameters():Void
	{
		this._textFieldOffsetX = 0;
		this._textFieldOffsetY = 0;
		this._textFieldClipRect.x = 0;
		this._textFieldClipRect.y = 0;

		this.getTransformationMatrix(this.stage, HELPER_MATRIX);
		var clipWidth:Float = this.actualWidth * Starling.contentScaleFactor * matrixToScaleX(HELPER_MATRIX);
		if(clipWidth < 0)
		{
			clipWidth = 0;
		}
		var clipHeight:Float = this.actualHeight * Starling.contentScaleFactor * matrixToScaleY(HELPER_MATRIX);
		if(clipHeight < 0)
		{
			clipHeight = 0;
		}
		this._textFieldClipRect.width = clipWidth;
		this._textFieldClipRect.height = clipHeight;
	}

	/**
	 * @private
	 */
	private function transformTextField():Void
	{
		if(!this.textField.visible)
		{
			return;
		}
		HELPER_POINT.x = HELPER_POINT.y = 0;
		this.getTransformationMatrix(this.stage, HELPER_MATRIX);
		MatrixUtil.transformCoords(HELPER_MATRIX, 0, 0, HELPER_POINT);
		var starlingViewPort:Rectangle = Starling.current.viewPort;
		var nativeScaleFactor:Float = 1;
		if(Starling.current.supportHighResolutions)
		{
			nativeScaleFactor = Starling.current.nativeStage.contentsScaleFactor;
		}
		var scaleFactor:Float = Starling.contentScaleFactor / nativeScaleFactor;
		var gutterPositionOffset:Float = 2;
		if(this._useGutter)
		{
			gutterPositionOffset = 0;
		}
		this.textField.x = Math.round(starlingViewPort.x + (HELPER_POINT.x * scaleFactor) - gutterPositionOffset);
		this.textField.y = Math.round(starlingViewPort.y + (HELPER_POINT.y * scaleFactor) - gutterPositionOffset);
		this.textField.rotation = matrixToRotation(HELPER_MATRIX) * 180 / Math.PI;
		this.textField.scaleX = matrixToScaleX(HELPER_MATRIX) * scaleFactor;
		this.textField.scaleY = matrixToScaleY(HELPER_MATRIX) * scaleFactor;
	}

	/**
	 * @private
	 */
	private function positionSnapshot():Void
	{
		if(!this.textSnapshot)
		{
			return;
		}
		this.getTransformationMatrix(this.stage, HELPER_MATRIX);
		this.textSnapshot.x = Math.round(HELPER_MATRIX.tx) - HELPER_MATRIX.tx;
		this.textSnapshot.y = Math.round(HELPER_MATRIX.ty) - HELPER_MATRIX.ty;
	}

	/**
	 * @private
	 */
	private function checkIfNewSnapshotIsNeeded():Void
	{
		var canUseRectangleTexture:Bool = Starling.current.profile != Context3DProfile.BASELINE_CONSTRAINED;
		if(canUseRectangleTexture)
		{
			this._snapshotWidth = this._textFieldClipRect.width;
			this._snapshotHeight = this._textFieldClipRect.height;
		}
		else
		{
			this._snapshotWidth = getNextPowerOfTwo(this._textFieldClipRect.width);
			this._snapshotHeight = getNextPowerOfTwo(this._textFieldClipRect.height);
		}
		var textureRoot:ConcreteTexture = this.textSnapshot ? this.textSnapshot.texture.root : null;
		this._needsNewTexture = this._needsNewTexture || !this.textSnapshot || this._snapshotWidth != textureRoot.width || this._snapshotHeight != textureRoot.height;
	}

	/**
	 * @private
	 */
	private function doPendingActions():Void
	{
		if(this._isWaitingToSetFocus)
		{
			this._isWaitingToSetFocus = false;
			this.setFocus();
		}

		if(this._pendingSelectionBeginIndex >= 0)
		{
			var startIndex:Int = this._pendingSelectionBeginIndex;
			var endIndex:Int = this._pendingSelectionEndIndex;
			this._pendingSelectionBeginIndex = -1;
			this._pendingSelectionEndIndex = -1;
			this.selectRange(startIndex, endIndex);
		}
	}

	/**
	 * @private
	 */
	private function texture_onRestore():Void
	{
		this.refreshSnapshot();
	}

	/**
	 * @private
	 */
	private function refreshSnapshot():Void
	{
		if(this._snapshotWidth <= 0 || this._snapshotHeight <= 0)
		{
			return;
		}
		var gutterPositionOffset:Float = 2;
		if(this._useGutter)
		{
			gutterPositionOffset = 0;
		}
		this.getTransformationMatrix(this.stage, HELPER_MATRIX);
		var globalScaleX:Float = matrixToScaleX(HELPER_MATRIX);
		var globalScaleY:Float = matrixToScaleY(HELPER_MATRIX);
		var scaleFactor:Float = Starling.contentScaleFactor;
		HELPER_MATRIX.identity();
		HELPER_MATRIX.translate(this._textFieldOffsetX - gutterPositionOffset, this._textFieldOffsetY - gutterPositionOffset);
		HELPER_MATRIX.scale(scaleFactor * globalScaleX, scaleFactor * globalScaleY);
		var bitmapData:BitmapData = new BitmapData(this._snapshotWidth, this._snapshotHeight, true, 0x00ff00ff);
		bitmapData.draw(this.textField, HELPER_MATRIX, null, null, this._textFieldClipRect);
		var newTexture:Texture;
		if(!this.textSnapshot || this._needsNewTexture)
		{
			newTexture = Texture.fromBitmapData(bitmapData, false, false, Starling.contentScaleFactor);
			newTexture.root.onRestore = texture_onRestore;
		}
		if(!this.textSnapshot)
		{
			this.textSnapshot = new Image(newTexture);
			this.addChild(this.textSnapshot);
		}
		else
		{
			if(this._needsNewTexture)
			{
				this.textSnapshot.texture.dispose();
				this.textSnapshot.texture = newTexture;
				this.textSnapshot.readjustSize();
			}
			else
			{
				//this is faster, if we haven't resized the bitmapdata
				var existingTexture:Texture = this.textSnapshot.texture;
				existingTexture.root.uploadBitmapData(bitmapData);
			}
		}
		this.getTransformationMatrix(this.stage, HELPER_MATRIX);
		this.textSnapshot.scaleX = 1 / matrixToScaleX(HELPER_MATRIX);
		this.textSnapshot.scaleY = 1 / matrixToScaleY(HELPER_MATRIX);
		bitmapData.dispose();
		this._needsNewTexture = false;
	}

	/**
	 * @private
	 */
	private function textEditor_addedToStageHandler(event:Event):Void
	{
		if(!this.textField.parent)
		{
			//the text field needs to be on the native stage to measure properly
			Starling.current.nativeStage.addChild(this.textField);
		}
	}

	/**
	 * @private
	 */
	private function textEditor_removedFromStageHandler(event:Event):Void
	{
		if(this.textField.parent)
		{
			//remove this from the stage, if needed
			//it will be added back next time we receive focus
			this.textField.parent.removeChild(this.textField);
		}
	}

	/**
	 * @private
	 */
	private function textEditor_enterFrameHandler(event:Event):Void
	{
		this.removeEventListener(Event.ENTER_FRAME, textEditor_enterFrameHandler);
		this.refreshSnapshot();
		if(this.textSnapshot)
		{
			this.textSnapshot.visible = !this._textFieldHasFocus;
			this.textSnapshot.alpha = this._text.length > 0 ? 1 : 0;
		}
	}

	/**
	 * @private
	 */
	private function textField_changeHandler(event:flash.events.Event):Void
	{
		this.text = this.textField.text;
	}

	/**
	 * @private
	 */
	private function textField_focusInHandler(event:FocusEvent):Void
	{
		this._textFieldHasFocus = true;
		if(this.textSnapshot)
		{
			this.textSnapshot.visible = false;
		}
		this.invalidate(INVALIDATION_FLAG_SKIN);
		this.dispatchEventWith(FeathersEventType.FOCUS_IN);
	}

	/**
	 * @private
	 */
	private function textField_focusOutHandler(event:FocusEvent):Void
	{
		this._textFieldHasFocus = false;

		if(this.resetScrollOnFocusOut)
		{
			this.textField.scrollH = this.textField.scrollV = 0;
		}

		this.invalidate(INVALIDATION_FLAG_DATA);
		this.invalidate(INVALIDATION_FLAG_SKIN);
		this.dispatchEventWith(FeathersEventType.FOCUS_OUT);
	}

	/**
	 * @private
	 */
	private function textField_keyDownHandler(event:KeyboardEvent):Void
	{
		if(event.keyCode == Keyboard.ENTER)
		{
			this.dispatchEventWith(FeathersEventType.ENTER);
		}
	}

	/**
	 * @private
	 */
	private function textField_softKeyboardActivateHandler(event:SoftKeyboardEvent):Void
	{
		this.dispatchEventWith(FeathersEventType.SOFT_KEYBOARD_ACTIVATE, true);
	}

	/**
	 * @private
	 */
	private function textField_softKeyboardDeactivateHandler(event:SoftKeyboardEvent):Void
	{
		this.dispatchEventWith(FeathersEventType.SOFT_KEYBOARD_DEACTIVATE, true);
	}
}
