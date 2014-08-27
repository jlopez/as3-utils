package com.jla.as3.util
{
    public function sprintf(fmt:String, ...rest):String
    {
        return vsprintf(fmt, rest);
    }
}
