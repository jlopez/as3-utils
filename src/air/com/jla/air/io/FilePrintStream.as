/**
 * Created by jlopez on 8/12/14.
 */
package com.jla.air.io
{
    import com.jla.as3.util.vsprintf;

    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;

    public class FilePrintStream implements PrintStream
    {
        private var _stream:FileStream;

        public function FilePrintStream(path:String)
        {
            _stream = new FileStream();
            _stream.open(new File(path), FileMode.WRITE);
        }

        public function print(s:String):void
        {
            _stream.writeUTFBytes(s);
        }

        public function println(s:String):void
        {
            _stream.writeUTFBytes(s + "\n");
        }

        public function printf(fmt:String, ...args):void
        {
            _stream.writeUTFBytes(vsprintf(fmt, args));
        }
    }
}
