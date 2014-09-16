/**
 * Created by jlopez on 9/15/14.
 */
package com.jla.as3.util
{
    public class StringUtils
    {
        public static function leftPad(s:String, width:int, pad:String = ' '):String
        {
            var needed:int = width - s.length;
            if (needed <= 0) return s;
            return multiply(pad, needed) + s;
        }

        public static function multiply(s:String, times:int):String
        {
            var rv:String = '';
            for (var b:int = 128; b; b >>= 1)
            {
                if (rv.length) rv += rv;
                if (times & b) rv += s;
            }
            return rv;
        }
    }
}
