/**
 * Created by jlopez on 9/16/14.
 */
package com.jla.as3.util
{
    public class NumberUtils
    {
        public static function round(n:Number, decimals:int):Number
        {
            var m:Number = Math.pow(10, decimals);
            return Math.round(n * m) / m;
        }
    }
}
