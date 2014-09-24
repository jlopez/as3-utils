/**
 * Created by jlopez on 8/18/14.
 */
package com.jla.air.cmd
{
    import com.jla.air.sys.GetOpt;
    import com.jla.air.sys.System;
    import com.jla.as3.util.vsprintf;

    import flash.filesystem.File;

    public class BaseCommand
    {
        protected var _outputDirectory:File;

        protected var _verbose:Boolean;

        protected var _quiet:Boolean;

        protected var _args:Vector.<String>;

        public function BaseCommand(args:Vector.<String>, optSpec:String = null)
        {
            var spec:String = 'vqo:';
            if (optSpec)
                spec += optSpec;
            var go:GetOpt = new GetOpt(args, spec);
            while (go.next())
            {
                if (go.opt == 'o')
                    _outputDirectory = new File(go.optarg);
                else if (go.opt == 'v')
                    _verbose = true;
                else if (go.opt == 'q')
                    _quiet = true;
                else
                    processOption(go);
            }
            _args = args;
            execute();
        }

        protected function execute():void
        {
        }

        protected function processOption(go:GetOpt):void
        {
        }

        protected function debug(fmt:String, ...rest):void
        {
            if (_verbose)
                System.out.print(vsprintf(fmt, rest));
        }

        protected function log(fmt:String, ...rest):void
        {
            if (!_quiet)
                System.out.print(vsprintf(fmt, rest));
        }
    }
}
