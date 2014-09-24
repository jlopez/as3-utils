/**
 * Created by jlopez on 8/12/14.
 */
package com.jla.air.io
{
    import com.jla.as3.util.vsprintf;

    public class TracePrintStream implements PrintStream
    {
        public function print(s:String):void
        {
            trace(s);
        }

        public function println(s:String):void
        {
            trace(s + "\n");
        }

        public function printf(fmt:String, ...args):void
        {
            trace(vsprintf(fmt, args));
        }
    }
}
