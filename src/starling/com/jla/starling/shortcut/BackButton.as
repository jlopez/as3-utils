/**
 * Created by jlopez on 9/24/14.
 */
package com.jla.starling.shortcut
{
    import flash.geom.Point;
    import flash.geom.Rectangle;

    import starling.display.DisplayObject;
    import starling.display.Quad;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.text.TextField;
    import starling.utils.HAlign;
    import starling.utils.VAlign;

    [Event(name="triggered", type="starling.events.Event")]
    internal class BackButton extends Sprite
    {
        private var _bounds:Rectangle;

        public function BackButton()
        {
            var textField:TextField = new TextField(240, 40, "Back", "_sans", 34, 0x42dd, false);
            textField.x = 40;
            textField.y = 10;
            textField.hAlign = HAlign.LEFT;
            textField.vAlign = VAlign.TOP;
            addChild(textField);
            var quad:Quad = new Quad(28, 6, 0x42dd);
            quad.rotation = -Math.PI / 4;
            quad.pivotX = 3;
            quad.pivotY = 3;
            quad.x = 10;
            quad.y = 30;
            addChild(quad);
            quad = new Quad(28, 6, 0x42dd);
            quad.rotation = Math.PI / 4;
            quad.pivotX = 3;
            quad.pivotY = 3;
            quad.x = 10;
            quad.y = 30;
            addChild(quad);
            _bounds = new Rectangle(0, 0, 40 + textField.textBounds.width, 60);

            addEventListener(TouchEvent.TOUCH, onTouch);
        }

        private function onTouch(event:TouchEvent):void
        {
            if (event.touches.length == 1 && event.touches[0].phase == TouchPhase.BEGAN)
                dispatchEventWith(Event.TRIGGERED, true);
        }

        override public function hitTest(localPoint:Point, forTouch:Boolean = false):DisplayObject
        {
            if (_bounds.containsPoint(localPoint))
                return this;
            return null;
        }
    }
}
