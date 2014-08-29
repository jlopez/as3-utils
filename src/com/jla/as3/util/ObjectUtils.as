/**
 * Created by jlopez on 8/29/14.
 */
package com.jla.as3.util
{
    public class ObjectUtils
    {
        public static function addAll(dst:Object, src:Object):void
        {
            for (var name:String in src)
                dst[name] = src[name];
        }
    }
}
