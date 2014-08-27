/**
 * Created by jlopez on 8/25/14.
 */
package com.jla.as3.util
{
    public class ColorUtils
    {
        public static function red(color:int):int
        {
            return (color >> 16) & 255;
        }

        public static function green(color:int):int
        {
            return (color >> 8) & 255;
        }

        public static function blue(color:int):int
        {
            return color & 255;
        }

        public static function rgb2hsl(color:int):Array
        {
            var r:Number = red(color) / 255.0;
            var g:Number = green(color) / 255.0;
            var b:Number = blue(color) / 255.0;
            var max:Number = Math.max(r, g, b);
            var min:Number = Math.min(r, g, b);
            var h:Number, s:Number, l:Number;
            h = s = l = (max + min) / 2;
            if (max == min) {
                h = s = 0; // achromatic
            }
            else
            {
                var d:Number = max - min;
                s = l > 0.5 ? d / (2 - max - min) : d / (max + min);
                if (max == r)
                    h = (g - b) / d + (g < b ? 6 : 0);
                else if (max == g)
                    h = (b - r) / d + 2;
                else if (max == b)
                    h = (r - g) / d + 4;
                h  /= 6;
            }
            return [h, s, l];
        }

        public static function hsl2rgb(h:Number, s:Number, l:Number):int
        {
            var r:Number, g:Number, b:Number;
            if (s == 0)
                r = g = b = l;
            else
            {
                function hue2rgb(p:Number, q:Number, t:Number):Number
                {
                    if (t < 0) t += 1;
                    if (t > 1) t -= 1;
                    if (t < 1/6) return p + (q - p) * 6 * t;
                    if (t < 1/2) return q;
                    if (t < 2/3) return p + (q - p) * (2/3 - t) * 6;
                    return p;
                }
                var q:Number = l < 0.5 ? l * (1 + s) : l + s - l * s;
                var p:Number = 2 * l - q;
                r = hue2rgb(p, q, h + 1/3);
                g = hue2rgb(p, q, h);
                b = hue2rgb(p, q, h - 1/3);
            }
            return (int(r * 255) << 16) | (int(g * 255) << 8) | int(b * 255);
        }
    }
}
