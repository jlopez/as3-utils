/**
 * Created by jlopez on 8/27/14.
 */
package com.jla.as3.util
{
    public class ArrayUtils
    {
        public static function mapVector(vector:*, mapper:Function):Array
        {
            // https://gist.github.com/fljot/1078004
            var v:Vector.<*> = vector as Vector.<*>;
            var rv:Array = new Array(v.length);
            for (var ix:int = 0, l:int = v.length; ix < l; ++ix)
                rv[ix] = mapper(v[ix]);
            return rv;
        }
    }
}
