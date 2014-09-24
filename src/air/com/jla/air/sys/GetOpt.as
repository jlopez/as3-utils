/**
 * Created by jlopez on 8/12/14.
 */
package com.jla.air.sys
{
    public class GetOpt
    {
        private var _args:Vector.<String>;
        private var _arg:String;
        private var _spec:String;
        private var _opt:String;
        private var _optarg:String;

        public function GetOpt(args:Vector.<String>, spec:String)
        {
            _args = args;
            _spec = spec;
        }

        public function next():Boolean
        {
            if (!_arg)
            {
                if (!_args.length || _args[0].charAt(0) != '-' && _args[0].length > 1)
                    return false;
                _arg = _args.shift().substr(1);
            }
            _opt = _arg.charAt(0);
            _arg = _arg.substr(1);
            _optarg = null;
            var ix:int = _spec.indexOf(_opt);
            if (ix == -1)
                _opt = '?';
            if (ix >= 0 && _spec.charAt(ix + 1) == ':')
            {
                if (_arg)
                    _optarg = _arg;
                else if (_args.length)
                    _optarg = _args.shift();
                else
                    throw new Error("option requires an argument -- " + _opt);
                _arg = null;
            }
            return true;
        }

        public function get opt():String
        {
            return _opt;
        }

        public function get optarg():String
        {
            return _optarg;
        }
    }
}
