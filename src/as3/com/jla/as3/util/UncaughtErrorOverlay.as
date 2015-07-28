/**
 * Created by jlopez on 9/10/14.
 */
package com.jla.as3.util
{
import feathers.controls.Button;

import flash.display.DisplayObject;
import flash.display.MovieClip;

import flash.display.Shape;
    import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.UncaughtErrorEvent;
    import flash.events.UncaughtErrorEvents;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.getQualifiedClassName;

public class UncaughtErrorOverlay
    {
        private static var _inited:Boolean = false;
        private static var _root:Stage;
        private static var _textField:TextField;
        private static var _clearText:TextField;
        private static var _button:MovieClip;
        private static var _overlay:Shape;

        public static function init(root:Stage, uncaughtErrorEvents:UncaughtErrorEvents):void
        {
            if (_root) return;
            uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
            _root = root;

            function uncaughtErrorHandler(event:UncaughtErrorEvent):void
            {
                if (event.error is Error)
                {
                    var error:Error = event.error as Error;
                    log("uncaughtError: %s", error.getStackTrace());
                }
                else
                    log("uncaughtError: %s", getQualifiedClassName(event.error));
            }
        }

        public static function log(msg:String, ...other):void
        {
            if (!_inited)
            {
                _init();
            }
            else
            {
                _overlay.visible = true;
                _textField.visible = true;
                _clearText.visible = true;
                _button.visible = true;
            }
            _textField.text += vsprintf(msg + '\n', other);
        }

        private static function _init():void
        {
            _inited = true;

            _overlay = new Shape();
            _overlay.graphics.beginFill(0, 0.6);
            _overlay.graphics.drawRect(0, 0, _root.stage.fullScreenWidth, _root.stage.fullScreenHeight);
            _overlay.graphics.endFill();
            _root.addChild(_overlay);

            _textField = new TextField();
            _textField.defaultTextFormat = new TextFormat("_typewriter", 12, 0xff00, true);
            _textField.wordWrap = true;
            _textField.width = _root.stage.fullScreenWidth;
            _textField.height = _root.stage.fullScreenHeight;
            _textField.textColor = 0xff00;
            _root.addChild(_textField);

            _button = new MovieClip();
            _button.addEventListener(MouseEvent.CLICK, _onClear);
            _button.graphics.beginFill(0xFFFFFF, .8);
            _button.graphics.drawRect(_root.stage.stageWidth - 200, _root.stage.stageHeight - 150, 150, 75);
            _button.graphics.endFill();
            _root.addChild(_button);

            _clearText = new TextField();
            _clearText.defaultTextFormat = new TextFormat("_sans", 15, 0, true);
            _clearText.text = "Clear";
            _clearText.selectable = false;
            _clearText.x = _root.stage.stageWidth - 150;
            _clearText.y = _root.stage.stageHeight - 125;
            _root.addChild(_clearText);
        }

        private static function _onClear(event:Event):void
        {
            _textField.text = "";

            _overlay.visible = false;
            _textField.visible = false;
            _clearText.visible = false;
            _button.visible = false;
        }
    }
}
