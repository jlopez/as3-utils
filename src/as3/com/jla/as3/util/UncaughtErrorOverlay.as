/**
 * Created by jlopez on 9/10/14.
 */
package com.jla.as3.util
{
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.display.Stage;
    import flash.events.UncaughtErrorEvent;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.utils.getQualifiedClassName;

    public class UncaughtErrorOverlay
    {
        private static var _root:Stage;
        private static var _textField:TextField;

        public static function init(root:Stage):void
        {
            if (_root) return;
            root.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
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
            if (!_textField)
                _createTextField();
            _textField.text += vsprintf(msg + '\n', other);
        }

        private static function _createTextField():void
        {
            if (_textField) return;
            var shape:Shape = new Shape();
            shape.graphics.beginFill(0, 0.6);
            shape.graphics.drawRect(0, 0, _root.stage.fullScreenWidth, _root.stage.fullScreenHeight);
            shape.graphics.endFill();
            _root.addChild(shape);
            _textField = new TextField();
            _textField.defaultTextFormat = new TextFormat("_typewriter", 12, 0xff00, true);
            _textField.wordWrap = true;
            _textField.width = _root.stage.fullScreenWidth;
            _textField.height = _root.stage.fullScreenHeight;
            _textField.textColor = 0xff00;
            _root.addChild(_textField);
        }
    }
}
