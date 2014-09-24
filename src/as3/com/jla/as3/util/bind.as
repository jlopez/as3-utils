package com.jla.as3.util
{
    public function bind(closure:Function, thisArg:*, ...args):Function
    {
        return wrapper;

        function wrapper(...more):*
        {
            return closure.apply(thisArg, args.concat(more));
        }
    }
}
