package com.jla.as3.util
{
    public function bindIgnore(closure:Function, thisArg:*, ...args):Function
    {
        return wrapper;

        function wrapper(...more):*
        {
            return closure.apply(thisArg, args);
        }
    }
}
