/**
 * Created by jlopez on 8/22/14.
 */
package com.jla.as3.util
{
    import flash.filesystem.FileMode;

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
    }
}

import flash.filesystem.File;
import flash.filesystem.FileMode;
import flash.filesystem.FileStream;

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

    public function write(s:String):void
    {
        _fileStream.writeUTFBytes(s);
    }

    public function close():void
    {
        if (_owns) _fileStream.close();
    }
}