/**
 * Created by jlopez on 9/22/14.
 */
package com.jla.starling.util
{
    import com.jla.as3.util.StringUtils;
    import com.jla.as3.util.sprintf;

    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import flash.utils.getQualifiedClassName;

    import starling.display.DisplayObject;
    import starling.display.DisplayObjectContainer;
    import starling.text.TextField;
    import starling.utils.rad2deg;

    public class DisplayListUtils
    {
        private static var sHelperPoint:Point = new Point();
        private static var sHelperRect:Rectangle = new Rectangle();
        private static var sHelperMatrix:Matrix = new Matrix();
        private static var sHelperTransform:Transform = new Transform();

        public static function visit(root:DisplayObject, visitor:Function):void {
            _visit(root, 0, 0);

            function _visit(obj:DisplayObject, ix:int, depth:int):void {
                visitor(obj, ix, depth);
                var container:DisplayObjectContainer = obj as DisplayObjectContainer;
                if (container) {
                    for (var j:int = 0, l:int = container.numChildren; j < l; ++j)
                        _visit(container.getChildAt(j), j, depth + 1);
                }
            }
        }

        public static function describe(obj:DisplayObject):String {
            obj.getBounds(null, sHelperRect);
            sHelperPoint.setTo(0, 0);
            obj.localToGlobal(sHelperPoint, sHelperPoint);
            var className:String = getQualifiedClassName(obj);
            if (className.indexOf('starling.display::') == 0)
                className = className.substr(18);
            var label:String = obj is TextField ? (obj as TextField).text : obj.name || '<anon>';
            sHelperTransform.setFromObject(obj);
            var scale:String = sHelperMatrix.toString();
            var rv:String = sprintf("(%3s %3s) (%3s %3s) %3dx%3d",
                    round(sHelperPoint.x), round(sHelperPoint.y),
                    round(sHelperTransform.x), round(sHelperTransform.y), sHelperRect.width, sHelperRect.height);
            if (sHelperTransform.isScaled)
                rv += sprintf(" scale(%.2f, %.2f)", sHelperTransform.scaleX, sHelperTransform.scaleY);
            if (sHelperTransform.isRotated)
                rv += sprintf(" rot(%.0f)", rad2deg(sHelperTransform.rotation));
            if (sHelperTransform.isSkewed)
                rv += sprintf(" skew(%.0f, %.0f)", rad2deg(sHelperTransform.skewX), rad2deg(sHelperTransform.skewY));
            rv += sprintf(" %s (%s)", className, label);
            return rv;

            function round(n:Number):Number
            {
                return Math.round(n * 100) / 100;
            }
        }

        public static function dumpTree(root:DisplayObject):void
        {
            visit(root, visitor);

            function visitor(obj:DisplayObject, childIndex:int, depth:int):void
            {
                trace(sprintf("%s%2d. (%d) %s", StringUtils.multiply('  ', depth), childIndex + 1, depth + 1, describe(obj)));
            }
        }
    }
}
