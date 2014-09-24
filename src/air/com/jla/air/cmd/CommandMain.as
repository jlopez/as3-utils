/**
 * Created by jlopez on 8/19/14.
 */
package com.jla.air.cmd
{
    import com.jla.air.sys.Main;

    public class CommandMain extends Main
    {
        private var _commands:Object;

        public function CommandMain(commands:Object)
        {
            _commands = commands;
        }

        override protected function main(args:Vector.<String>):void
        {
            if (args.length == 0)
                usage();
            else
            {
                var command:String = args.shift();
                var cls:Class = _commands[command];
                if (!cls)
                    usage();
                else
                    new cls(args);
            }
        }

        protected function usage():void
        {
        }
    }
}
