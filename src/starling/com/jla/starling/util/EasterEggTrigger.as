/**
 * Created by jlopez on 9/22/14.
 */
package com.jla.starling.util
{
    import flash.geom.Rectangle;
    import flash.utils.clearTimeout;
    import flash.utils.setTimeout;

    import starling.display.Stage;
    import starling.events.Event;
    import starling.events.EventDispatcher;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;

    [Event(name="triggered", type="starling.events.Event")]
    public class EasterEggTrigger extends EventDispatcher
    {
        private var _stage:Stage;
        private var _hotSpot:Rectangle = new Rectangle();
        private var _triggerDelay:int = 3000;
        private var _trackedTouchId:int = -1;
        private var _triggerTimer:int;

        public function EasterEggTrigger(stage:Stage)
        {
            _stage = stage;
            _stage.addEventListener(TouchEvent.TOUCH, onTouch);
            _hotSpot.setTo(0, 0, 100, 100);
        }

        public function get hotSpot():Rectangle
        {
            return _hotSpot;
        }

        public function get triggerDelay():int
        {
            return _triggerDelay;
        }

        public function set triggerDelay(value:int):void
        {
            _triggerDelay = value;
        }

        private function onTouch(event:TouchEvent):void
        {
            var touch:Touch;
            if (_trackedTouchId == -1)
            {
                touch = event.getTouch(_stage, TouchPhase.BEGAN);
                if (touch && locationQualifies(touch))
                {
                    _trackedTouchId = touch.id;
                    _triggerTimer = setTimeout(trigger, _triggerDelay);
                }
            }
            else
            {
                touch = event.getTouch(_stage, null, _trackedTouchId);
                if (touch)
                {
                    _trackedTouchId = -1;
                    clearTimeout(_triggerTimer);
                }
            }
        }

        protected function locationQualifies(touch:Touch):Boolean
        {
            return hotSpot.contains(touch.globalX, touch.globalY);
        }

        protected function trigger():void
        {
            dispatchEventWith(Event.TRIGGERED);
        }
    }
}
