/**
 * Created by jlopez on 9/22/14.
 */
package com.jla.starling.util
{
    import flash.geom.Matrix;

    import starling.display.DisplayObject;

    internal class Transform
    {
        public var x:Number;
        public var y:Number;
        public var pivotX:Number;
        public var pivotY:Number;
        public var scaleX:Number;
        public var scaleY:Number;
        public var skewX:Number;
        public var skewY:Number;
        public var rotation:Number;

        public function setFromMatrix(matrix:Matrix):void
        {
            const PI_Q:Number = Math.PI / 4.0;

            rotation = 0;
            pivotX = 0;
            pivotY = 0;
            x = matrix.tx;
            y = matrix.ty;

            skewX = Math.atan(-matrix.c / matrix.d);
            skewY = Math.atan(matrix.b / matrix.a);

            // NaN check ("isNaN" causes allocation)
            if (skewX != skewX) skewX = 0.0;
            if (skewY != skewY) skewY = 0.0;

            scaleY = (skewX > -PI_Q && skewX < PI_Q) ? matrix.d / Math.cos(skewX)
                    : -matrix.c / Math.sin(skewX);
            scaleX = (skewY > -PI_Q && skewY < PI_Q) ? matrix.a / Math.cos(skewY)
                    : matrix.b / Math.sin(skewY);

            if (isEquivalent(skewX, skewY))
            {
                rotation = skewX;
                skewX = skewY = 0;
            }
        }

        private static function isEquivalent(a:Number, b:Number, epsilon:Number = 0.0001):Boolean
        {
            return (a - epsilon < b) && (a + epsilon > b);
        }

        public function setFromObject(obj:DisplayObject):void
        {
            setFromMatrix(obj.transformationMatrix);
        }

        public function get isScaled():Boolean
        {
            return !isEquivalent(scaleX, 1) || !isEquivalent(scaleY, 1);
        }

        public function get isRotated():Boolean
        {
            return !isEquivalent(rotation, 0);
        }

        public function get isSkewed():Boolean
        {
            return !isEquivalent(skewX, 0) || !isEquivalent(skewY, 0);
        }
    }
}
