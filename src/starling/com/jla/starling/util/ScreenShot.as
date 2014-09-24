/**
 * Created by jlopez on 9/20/14.
 */
package com.jla.starling.util
{
    import com.jla.air.util.FileUtils;

    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;

    import starling.core.RenderSupport;
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.display.Stage;
    import starling.textures.RenderTexture;

    public class ScreenShot
    {
        private static var sHelperMatrix:Matrix = new Matrix();

        public static function take(displayObject:DisplayObject, backgroundColor:uint = 0, bounds:Rectangle = null):BitmapData
        {
            var scl:Number = 1;
            var stage:Stage = Starling.current.stage;

            if (!bounds) bounds = displayObject.bounds;

            var rs:RenderSupport = new RenderSupport();

            rs.clear(backgroundColor & 0xFFFFFF, (backgroundColor >> 24) / 255.0);
            rs.scaleMatrix(scl, scl);
            rs.setOrthographicProjection(0, 0, stage.stageWidth, stage.stageHeight);
            rs.translateMatrix(-bounds.x, -bounds.y);

            displayObject.render(rs, 1.0);
            rs.finishQuadBatch();

            var screenShot:BitmapData = new BitmapData(bounds.width * scl, bounds.height * scl, true);
            Starling.context.drawToBitmapData(screenShot);

            return screenShot;
        }

        public static function save(file:*, displayObject:DisplayObject):void
        {
            var screenShot:BitmapData = take(displayObject);
            FileUtils.writePNG(file, screenShot);
            screenShot.dispose();
        }

        public static function asImage(displayObject:DisplayObject, scale:Number = 1, backgroundColor:uint = 0, bounds:Rectangle = null):Image
        {
            if (!bounds) bounds = displayObject.bounds;
            var texture:RenderTexture = new RenderTexture(bounds.width * scale, bounds.height * scale, false);
            texture.clear(backgroundColor & 0xFFFFFF, (backgroundColor >> 24) / 255.0);
            sHelperMatrix.identity();
            sHelperMatrix.scale(scale, scale);
            sHelperMatrix.translate(-bounds.x, -bounds.y);
            texture.draw(displayObject, sHelperMatrix);
            return new Image(texture);
        }
    }
}
