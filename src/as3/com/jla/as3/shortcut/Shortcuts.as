/**
 * Created by jlopez on 9/22/14.
 */
package com.jla.as3.shortcut
{
    import flash.display.Stage;
    import flash.events.KeyboardEvent;

    import starling.events.Event;

    public class Shortcuts
    {
        private static var _instance:Shortcuts;
        private var _ctrlKey:Boolean;
        private var _shortcuts:Vector.<Shortcut> = new <Shortcut>[];

        public static function get instance():Shortcuts
        {
            return _instance;
        }


        public static function init(stage:Stage):Shortcuts
        {
            if (!_instance)
                _instance = new Shortcuts(stage);
            return _instance;
        }

        public static function add(... args):void
        {
            if (!_instance) return;
            var shortcut:Shortcut = Shortcut.create(args);
            if (!shortcut) return;
            _instance.addShortcut(shortcut);
        }

        public static function getValue(s:String):*
        {
            if (!_instance) return null;
            var shortcut:Shortcut = _instance.getShortcut(s);
            if (!shortcut) return null;
            return shortcut.option;
        }

        public static function addChangeListener(shortcut:String, listener:Function):void
        {
            if (!_instance) return;
            var sc:Shortcut = _instance.getShortcut(shortcut);
            if (!sc) return;
            sc.addEventListener(Event.CHANGE, listener);
        }

        public static function removeChangeListener(shortcut:String, listener:Function):void
        {
            if (!_instance) return;
            var sc:Shortcut = _instance.getShortcut(shortcut);
            if (!sc) return;
            sc.removeEventListener(Event.CHANGE, listener);
        }

        public function Shortcuts(stage:Stage)
        {
            if (_instance) throw new Error("Singleton");
            _instance = this;
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
        }

        public function get shortcuts():Vector.<Shortcut>
        {
            return _shortcuts;
        }

        public function get ctrlKey():Boolean
        {
            return _ctrlKey;
        }

        public function addShortcut(shortcut:Shortcut):void
        {
            var ix:int = indexOf(shortcut);
            if (ix >= 0)
                _shortcuts[ix] = shortcut;
            else
                _shortcuts.push(shortcut);
        }

        public function removeShortcut(... args):void
        {
            var shortcut:Shortcut = Shortcut.create(args);
            var ix:int = indexOf(shortcut);
            if (ix >= 0)
                _shortcuts.splice(ix, 1);
        }

        private function indexOf(shortcut:Shortcut):int
        {
            if (!shortcut)
                return -1;
            for (var ix:int = 0, l:int = _shortcuts.length; ix < l; ++ix)
            {
                var s:Shortcut = _shortcuts[ix];
                if (shortcut.equalTo(s))
                    return ix;
            }
            return -1;
        }

        protected function onKeyDown(event:KeyboardEvent):void
        {
            _ctrlKey = event.ctrlKey;
            for each (var shortcut:Shortcut in _shortcuts)
            {
                if (shortcut.matches(event))
                {
                    shortcut.execute();
                    return;
                }
            }
        }

        private function onKeyUp(event:KeyboardEvent):void
        {
            _ctrlKey = event.ctrlKey;
        }

        public function getShortcut(s:String):Shortcut
        {
            for each (var shortcut:Shortcut in _shortcuts)
            {
                if (shortcut.id == s || shortcut.label == s || shortcut.hotKey == s)
                    return shortcut;
            }
            return null;
        }
    }
}
