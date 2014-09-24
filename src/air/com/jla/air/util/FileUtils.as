/**
 * Created by jlopez on 8/22/14.
 */
package com.jla.air.util
{
    import flash.display.BitmapData;
    import flash.display.PNGEncoderOptions;
    import flash.filesystem.FileMode;
    import flash.utils.ByteArray;

    public class FileUtils
    {
        public function FileUtils()
        {
        }

        public static function readJSON(file:*):Object
        {
            var json:String = readString(file);
            try
            {
                return JSON.parse(json);
            }
            catch (err:SyntaxError)
            {
                return null;
            }
        }

        public static function readString(file:*):String
        {
            var wrapper:FileStreamWrapper = FileStreamWrapper.fromArgument(file, FileMode.READ);
            if (!wrapper) return null;
            var rv:String = wrapper.read();
            wrapper.close();
            return rv;
        }

        public static function readBytes(file:*):ByteArray
        {
            var wrapper:FileStreamWrapper = FileStreamWrapper.fromArgument(file, FileMode.READ);
            if (!wrapper) return null;
            var rv:ByteArray = wrapper.readBytes();
            wrapper.close();
            return rv;
        }

        public static function writeJSON(file:*, data:Object):void
        {
            writeString(file, JSON.stringify(data));
        }

        public static function writeString(file:*, s:String):void
        {
            var wrapper:FileStreamWrapper = FileStreamWrapper.fromArgument(file, FileMode.WRITE);
            if (!wrapper) throw new Error("Unable to write to " + file);
            wrapper.write(s);
            wrapper.close();
        }

        public static function writeBytes(file:*, byteArray:ByteArray):void
        {
            var wrapper:FileStreamWrapper = FileStreamWrapper.fromArgument(file, FileMode.WRITE);
            wrapper.fileStream.writeBytes(byteArray);
            wrapper.close();
        }

        public static function writePNG(file:*, screenShot:BitmapData):void
        {
            var byteArray:ByteArray = new ByteArray();
            screenShot.encode(screenShot.rect, new PNGEncoderOptions(), byteArray);
            FileUtils.writeBytes(file, byteArray);
        }
    }
}

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;
import flash.utils.ByteArray;

class FileStreamWrapper
{
    private var _fileStream:FileStream;
    private var _owns:Boolean;

    public function FileStreamWrapper(fs:FileStream, owns:Boolean)
    {
        _fileStream = fs;
        _owns = owns;
    }

    public function read():String
    {
        return _fileStream.readUTFBytes(_fileStream.bytesAvailable);
    }

    public function readBytes():ByteArray
    {
        var bytes:ByteArray = new ByteArray();
        _fileStream.readBytes(bytes, 0, _fileStream.bytesAvailable);
        return bytes;
    }

    public static function fromArgument(file:*, mode:String):FileStreamWrapper
    {
        var fs:FileStream = file as FileStream;
        var owns:Boolean = fs == null;
        if (owns)
        {
            var f:File;
            if (file is String)
                f = File.applicationStorageDirectory.resolvePath(file as String);
            else if (file is File)
                f = file as File;
            if (!f) return null;
            if (!f.exists && mode != FileMode.WRITE) return null;
            fs = new FileStream();
            fs.open(f, mode);
        }
        return new FileStreamWrapper(fs, owns);
    }

    public function get fileStream():FileStream
    {
        return _fileStream;
    }

    public function write(s:String):void
    {
        _fileStream.writeUTFBytes(s);
    }

    public function close():void
    {
        if (_owns) _fileStream.close();
    }
}