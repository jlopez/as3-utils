/**
 * Created by jlopez on 8/12/14.
 */
package com.jla.air.sys
{
    import com.jla.air.io.*;
    import flash.desktop.NativeApplication;
    import flash.display.Sprite;
    import flash.errors.IOError;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;

    public class System
    {
        private static var _root:Sprite;
        private static var _stdin:FileStream;
        private static var _stdout:PrintStream;
        private static var _stderr:PrintStream;
        private static var _cwd:File;

        public function System()
        {
            throw new Error("Static class");
        }

        public static function init(root:Sprite):void
        {
            if (_root)
                throw new Error("Already initialized");
            _root = root;
            _initializeStreams();
        }

        public static function get stdin():FileStream
        {
            return _stdin;
        }

        public static function get out():PrintStream
        {
            return _stdout;
        }

        public static function get err():PrintStream
        {
            return _stderr;
        }

        public static function get root():Sprite
        {
            return _root;
        }

        public static function set root(value:Sprite):void
        {
            if (_root)
                throw new Error("Read-only");
            _root = value;
        }

        public static function get cwd():File
        {
            return _cwd;
        }

        public static function set cwd(value:File):void
        {
            if (_cwd)
                throw new Error("Read-only");
            _cwd = value;
        }

        public static function exit(errorCode:int):void
        {
            NativeApplication.nativeApplication.exit(errorCode);
        }

        public static function nameWithoutExtension(file:File):String
        {
            if (file.extension == null)
                return file.name;
            return file.name.substring(0, file.name.length - file.extension.length - 1);
        }

        private static function _getStdStream(path:String):PrintStream
        {
            try
            {
                return new FilePrintStream(path);
            }
            catch (err:IOError)
            {
                return new TracePrintStream();
            }
        }

        private static function _initializeStreams():void
        {
            _stdin = new FileStream();
            _stdin.open(new File("/dev/fd/0"), FileMode.READ);
            _stdout = _getStdStream("/dev/fd/1");
            _stderr = _getStdStream("/dev/fd/2");
        }
    }
}
