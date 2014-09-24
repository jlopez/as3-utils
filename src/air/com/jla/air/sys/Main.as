package com.jla.air.sys
{
    import com.jla.as3.util.sprintf;

    import flash.desktop.NativeApplication;
    import flash.display.Sprite;
    import flash.events.ErrorEvent;
    import flash.events.InvokeEvent;
    import flash.events.UncaughtErrorEvent;

    public class Main extends Sprite
    {
        public function Main()
        {
            System.init(this);
            loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
            NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, onInvoke);
        }

        protected function main(strings:Vector.<String>):void
        {
        }

        protected static function error(msg:String, ...rest):void
        {
            System.err.println(sprintf(msg, rest));
            System.exit(1);
        }

        private function onInvoke(event:InvokeEvent):void
        {
            System.cwd = event.currentDirectory;
            main(Vector.<String>(event.arguments));
        }

        private static function onUncaughtError(event:UncaughtErrorEvent):void
        {
            event.stopPropagation();
            event.preventDefault();
            var errorCode:int = 1;
            if (event.error is ErrorEvent)
                System.err.printf("ErrorEvent: %s", ErrorEvent(event.error).text);
            else if (event.error is ExitError)
                errorCode = ExitError(event.error).errorCode;
            else if (event.error is Error)
                System.err.printf("%s\n%s", (event.error as Error).message, (event.error as Error).getStackTrace());
            else
                System.err.printf("Uncaught Error: [%s]", event.error);
            NativeApplication.nativeApplication.exit(errorCode);
        }
    }
}
