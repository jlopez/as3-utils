/**
 * Created by jlopez on 9/24/14.
 */
package com.jla.starling.shortcut
{
    import com.jla.as3.shortcut.Shortcut;

    import starling.animation.IAnimatable;
    import starling.core.Starling;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.TextField;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    [Event(name="triggered", type="starling.events.Event")]
    internal class Cell extends Sprite implements IAnimatable
    {
        private static const PADDING:int = 28;
        private static const DOUBLE_PADDING:int = PADDING * 2;
        private static const TEXT_FIELD_HEIGHT:int = 50;
        private static const LABEL_FONT:String = "_sans";
        private static const LABEL_FONT_SIZE:Number = 34;
        private static const CELL_HEIGHT:Number = 88;
        private static const SEPARATOR_COLOR:uint = 0xc8c8c8;
        private static const OPTION_TEXT_COLOR:uint = 0x7f7f7f;
        private var _shortcut:Shortcut;
        private var _label:TextField;
        private var _value:TextField;
        private var _background:Quad;
        private var _data:Object;
        private var _phase:Number;

        function Cell(shortcut:Shortcut, width:int):void
        {
            _shortcut = shortcut;
            _label = new TextField(width - DOUBLE_PADDING, TEXT_FIELD_HEIGHT, shortcut.label, LABEL_FONT, LABEL_FONT_SIZE);
            _value = new TextField(width - DOUBLE_PADDING, TEXT_FIELD_HEIGHT, shortcut.optionLabel || '', LABEL_FONT, LABEL_FONT_SIZE, OPTION_TEXT_COLOR);
            _background = new Quad(width, CELL_HEIGHT);
            addChild(_background);
            _label.x = PADDING;
            _label.y = 22;
            _label.hAlign = HAlign.LEFT;
            _label.vAlign = VAlign.TOP;
            addChild(_label);
            _value.x = PADDING;
            _value.y = 22;
            _value.hAlign = HAlign.RIGHT;
            _value.vAlign = VAlign.TOP;
            addChild(_value);
            var line:Quad = new Quad(width - PADDING - 2, 1, SEPARATOR_COLOR);
            line.x = PADDING + 2;
            line.y = CELL_HEIGHT - 1;
            addChild(line);
            //noinspection JSValidateTypes
            _shortcut.addEventListener(Event.CHANGE, onUpdate);
            this.addEventListener(TouchEvent.TOUCH, onTouch);
        }

        override public function dispose():void
        {
            _shortcut.removeEventListener(Event.CHANGE, onUpdate);
            super.dispose();
        }

        public function get data():Object
        {
            return _data;
        }

        public function set data(value:Object):void
        {
            _data = value;
        }

        //noinspection JSUnusedGlobalSymbols
        public function get label():String
        {
            return _label.text;
        }

        //noinspection JSUnusedGlobalSymbols
        public function set label(value:String):void
        {
            _label.text = value;
        }

        public function set value(value:String):void
        {
            _value.text = value;
        }

        public function get value():String
        {
            return _value.text;
        }

        private function onTouch(event:TouchEvent):void
        {
            if (event.touches.length == 1 && event.touches[0].phase == TouchPhase.BEGAN)
            {
                _background.color = SEPARATOR_COLOR;
                Starling.current.juggler.add(this);
                _phase = 0;
                dispatchEventWith(Event.TRIGGERED, true, _data);
            }
        }

        //noinspection JSUnusedLocalSymbols
        private function onUpdate(event:Event, value:String):void
        {
            this.value = (event.target as Shortcut).optionLabel;
        }

        public function advanceTime(passedTime:Number):void
        {
            _phase += passedTime;
            var f:Number = Math.min(Math.max(0, (_phase - 0.25) / 0.25), 1);
            var g:int = (0xff - 0xc8) * f + 0xc8;
            _background.color = g * 0x10101;
            if (f >= 1)
                dispatchEventWith(Event.REMOVE_FROM_JUGGLER);
        }
    }
}
