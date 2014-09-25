/**
 * Created by jlopez on 9/22/14.
 */
package com.jla.as3.shortcut
{
    import flash.events.KeyboardEvent;

    import starling.events.Event;

    import starling.events.EventDispatcher;

    [Event(name="change", type="starling.events.Event")]
    public class Shortcut extends EventDispatcher
    {
        private var _id:String;
        private var _label:String;
        private var _hotKey:String;
        private var _callback:Function;
        private var _options:Array;
        private var _optionLabels:Array;
        private var _optionIndex:int;
        private var _option:Object;

        public function get id():String
        {
            return _id;
        }

        public function set id(value:String):void
        {
            _id = value;
        }

        public function get label():String
        {
            return _label;
        }

        public function set label(value:String):void
        {
            _label = value;
        }

        public function get hotKey():String
        {
            return _hotKey;
        }

        public function set hotKey(value:String):void
        {
            _hotKey = value;
        }

        public function get callback():Function
        {
            return _callback;
        }

        public function set callback(value:Function):void
        {
            _callback = value;
        }

        public function get options():Array
        {
            return _options;
        }

        public function set options(value:Array):void
        {
            _options = value;
        }

        public function get optionLabels():Array
        {
            return _optionLabels;
        }

        public function set optionLabels(value:Array):void
        {
            _optionLabels = value;
        }

        public function get option():*
        {
            return _options ? _options[_optionIndex] : _option;
        }

        public function get optionLabel():String
        {
            return _optionLabels ? optionLabels[_optionIndex] : String(option || '');
        }

        public function matches(event:KeyboardEvent):Boolean
        {
            if (!_hotKey)
                return false;
            if (_hotKey.length == 1 && event.charCode == _hotKey.charCodeAt(0))
                return true;
            return event.ctrlKey && _hotKey.length == 2 &&
                    _hotKey.charAt(0) == '^' && event.charCode == _hotKey.charCodeAt(1);
        }

        public function execute():void
        {
            if (options)
            {
                _optionIndex = (_optionIndex + 1) % options.length;
                if (callback)
                {
                    if (callback.length == 0) callback();
                    else                      callback(option);
                }
            }
            else
            {
                if (callback)
                {
                    if (callback.length == 0) _option = callback();
                    else                      _option = callback(this);
                }
            }
            dispatchEventWith(Event.CHANGE, false, option);
        }

        public static function create(args:Array):Shortcut
        {
            var shortcut:Shortcut = new Shortcut();
            while (args.length)
            {
                var arg:* = args.shift();
                if (arg is String && arg.length <= 2 && arg.indexOf('^') == 0)
                    shortcut.hotKey = arg;
                else if (arg is String && arg.indexOf(' ') == -1 && arg.toUpperCase() == arg)
                    shortcut.id = arg;
                else if (arg is String)
                    shortcut.label = arg;
                else if (arg is Function)
                    shortcut.callback = arg;
                else if (arg is Array && !shortcut.options)
                    shortcut.options = arg;
                else if (arg is Array)
                    shortcut.optionLabels = arg;
                else
                {
                    for (var p:String in arg)
                    {
                        if (arg.hasOwnProperty(p) && p in shortcut)
                            shortcut[p] = arg[p];
                    }
                }
            }
            if (!shortcut.label && !shortcut.hotKey)
                return null;
            if (shortcut.callback === null && shortcut.options === null)
            {
                shortcut.options = [ false, true ];
                shortcut.optionLabels ||= [ 'Off', 'On' ];
            }
            return shortcut;
        }

        public function equalTo(other:Shortcut):Boolean
        {
            return _id && other._id == _id || _label && other._label == _label ||
                   !_id && !_label && _hotKey && _hotKey == other._hotKey;
        }
    }
}