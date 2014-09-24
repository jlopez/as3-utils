/**
 * Created by jlopez on 9/22/14.
 */
package com.jla.starling.shortcut
{
    import com.jla.as3.shortcut.Shortcut;
    import com.jla.as3.shortcut.ShortcutManager;
    import com.jla.starling.util.*;

    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.display.Stage;
    import starling.events.Event;
    import starling.filters.BlurFilter;
    import starling.text.TextField;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    public class ShortcutPanel
    {
        private var _overlay:Sprite;

        public function ShortcutPanel(stage:Stage)
        {
            var trigger:EasterEggTrigger = new EasterEggTrigger(stage);
            //noinspection JSValidateTypes
            trigger.addEventListener(Event.TRIGGERED, show);

            ShortcutManager.instance.addShortcut('^ ', togglePanel);
        }

        private function togglePanel():void
        {
            if (_overlay) hide();
            else          show();
        }

        private function show():void
        {
            if (_overlay) return;
            _create();
        }

        private function hide():void
        {
            if (!_overlay) return;
            _overlay.removeFromParent(true);
            _overlay = null;
        }

        private function _create():void
        {
            var stage:Stage = Starling.current.stage;
            var width:int = stage.stageWidth;
            var height:int = stage.stageHeight;
            _overlay = new Sprite();
            var background:Image = ScreenShot.asImage(stage, 1, 0xffffffff);
            background.filter = new BlurFilter();
            _overlay.addChild(background);
            var dimmer:Quad = new Quad(width, height);
            dimmer.alpha = 0.95;
            _overlay.addChild(dimmer);
            _overlay.addChild(new Quad(width, height, 0xf8f8f8));
            var header:TextField = new TextField(stage.stageWidth, 50, "Shortcuts", "_sans", 34, 0, true);
            header.x = 0;
            header.y = 64;
            header.hAlign = HAlign.CENTER;
            header.vAlign = VAlign.TOP;
            _overlay.addChild(header);
            var backButton:BackButton = new BackButton();
            backButton.x = 11;
            backButton.y = 54;
            _overlay.addChild(backButton);
            _addLine(0x8b8b8b, 128, width);

            var y:int = 129;
            for each (var shortcut:Shortcut in ShortcutManager.instance.shortcuts)
            {
                if (!shortcut.label) continue;
                var cell:Cell = new Cell(shortcut, width);
                cell.data = shortcut;
                cell.y = y;
                _overlay.addChild(cell);
                y += 88;
            }
            //noinspection JSValidateTypes
            _overlay.addEventListener(Event.TRIGGERED, onSelection);

            stage.addChild(_overlay);
        }

        //noinspection JSUnusedLocalSymbols
        private function onSelection(event:Event, shortcut:Shortcut):void
        {
            if (event.target is BackButton)
                hide();
            else if (event.target is Cell)
                shortcut.execute();
        }

        private function _addLine(color:uint, y:int, width:int, x0:int = 0):void
        {
            var line:Quad = new Quad(width - x0, 1, color);
            line.x = x0;
            line.y = y;
            _overlay.addChild(line);
        }
    }
}















