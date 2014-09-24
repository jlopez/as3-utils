/**
 * Created by jlopez on 8/12/14.
 */
package com.jla.air.io
{
    public interface PrintStream
    {
        function print(s:String):void;
        function println(s:String):void;
        function printf(fmt:String, ...args):void;
    }
}
