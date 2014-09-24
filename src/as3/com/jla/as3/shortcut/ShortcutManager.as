/**
 * Created by jlopez on 9/22/14.
 */
package com.jla.as3.shortcut
{
    import flash.display.Stage;
    import flash.events.KeyboardEvent;

    public class ShortcutManager
    {
        private static var _instance:ShortcutManager;
        private var _ctrlKey:Boolean;
        private var _shortcuts:Vector.<Shortcut> = new <Shortcut>[];

        public static function get instance():ShortcutManager
        {
            return _instance;
        }


        public static function init(stage:Stage):ShortcutManager
        {
            if (!_instance)
                _instance = new ShortcutManager(stage);
            return _instance;
        }

        public function ShortcutManager(stage:Stage)
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

        public function addShortcut(... args):Shortcut
        {
            var shortcut:Shortcut = Shortcut.create(args);
            _shortcuts.push(shortcut);
            return shortcut;
        }

        public function removeShortcut(shortcut:Shortcut):void
        {
            var ix:int = _shortcuts.indexOf(shortcut);
            if (ix >= 0)
                _shortcuts.splice(ix, 1);
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
