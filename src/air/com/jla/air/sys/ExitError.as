/**
 * Created by jlopez on 8/13/14.
 */
package com.jla.air.sys
{
    import flash.desktop.NativeApplication;

    internal class ExitError extends Error
    {
        private var _errorCode:int;

        public function ExitError(errorCode:int)
        {
            super("Exiting with code " + errorCode);
            _errorCode = errorCode;
        }

        public function get errorCode():int
        {
            return _errorCode;
        }

        public function exit():void
        {
            NativeApplication.nativeApplication.exit(_errorCode);
        }
    }
}
