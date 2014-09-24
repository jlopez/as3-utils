package com.jla.as3.util
{
    /**
     *   Creates a string with variable substitutions. Very similar to printf, specially python's printf
     *   @param raw The string to be substituted.
     *   @param rest  The objects to be substituted, can be positional or by properties inside the object (in which case only one object can be passed)
     *   @return The formatted and substituted string.
     *   @example
     *   <pre>
     *
     *   // objects are substituted in the other they appear
     *
     *   printf("This is a %s library for creating %s", "Actionscript 3.0", "strings");
     *   // outputs: "This is an Actionscript 3.0 library for creating strings";
     *   // you can also format numbers:
     *
     *   printf("You can also display numbers like PI: %f, and format them to a fixed precision, such as PI with 3 decimal places %.3f", Math.PI, Math.PI);
     *   // outputs: " You can also display numbers like PI: 3.141592653589793, and format them to a fixed precision, such as PI with 3 decimal places 3.142"
     *   // Instead of positional (the order of arguments to print f, you can also use properties of an object):
     *   var userInfo : Object = {
     "name": "Arthur Debert",
     "email": "arthur@stimuli.com.br",
     "website":"http://www.stimuli.com.br/",
     "occupation": "developer"
     }
     *
     *   printf("My name is %(name)s and I am a %(occupation)s. You can read more on my personal %(website)s, or reach me through my %(email)s", userInfo);
     *   // outputs: "My name is Arthur Debert and I am a developer. You can read more on my personal http://www.stimuli.com.br/, or reach me through my arthur@stimuli.com.br"
     *   // you can also use date parts:
     *   var date : Date = new Date();
     *   printf("Today is %d/%m/%Y", date, date, date)
     *
     *   </pre>
     *   @see br.com.stimuli.string
     */
    public function vsprintf(raw : String, rest : Array) : String {
        /**
         * Pretty ugly!
         *   basically
         *   % -> the start of a substitution hole
         *   (some_var_name) -> [optional] used in named substitutions
         *   .xx -> [optional] the precision with witch numbers will be formatted
         *   x -> the formatter (string, hex, float, date part)
         */
        var SUBS_RE : RegExp = /%(?!^%)(\((?P<var_name>[\w]+[\w_\d]+)\))?(?P<padding>[0-9]{1,2})?(\.(?P<precision>[0-9]+))?(?P<formatter>[sxofaAbBcdHIjmMpSUwWxXyYZ])/ig;

        //Return empty string if raw is null, we don't want errors here
        if( raw == null ){
            return "";
        }
        //trace("\n\n" + 'input:"'+ raw+  '" , args:', rest.join(", ")) ;
        var matches : Array = [];
        var result : Object = SUBS_RE.exec(raw);
        var match : Match;
        var runs : int = 0;
        var numMatches : int = 0;
        var numberVariables : int = rest.length;
        // quick check if we find string subs amongst the text to match (something like %(foo)s
        var isPositionalSubst : Boolean = !Boolean(raw.match(/%\(\s*[\w\d_]+\s*\)/));
        var replacementValue : *;
        var formatter : String;
        var varName : String;
        var precision : String;
        var padding : String;
        var paddingNum : int;
        var paddingChar:String;

        // matched through the string, creating Match objects for easier later reuse
        while (Boolean(result)){
            match = new Match();
            match.startIndex = result.index;
            match.length = String(result[0]).length;
            match.endIndex = match.startIndex + match.length;
            match.content = String(result[0]);
            // try to get substitution properties
            formatter = result["formatter"];
            varName = result["var_name"];
            precision = result["precision"];
            padding = result["padding"];
            paddingNum = 0;
            paddingChar = null;
            //trace('formatter:', formatter, ', varName:', varName, ', precision:', precision, 'padding:', padding);
            if (padding){
                if (padding.length == 1){
                    paddingNum = int(padding);
                    paddingChar = " ";
                }else{
                    paddingNum = int (padding.substr(-1, 1));
                    paddingChar = padding.substr(-2, 1);
                    if (paddingChar != "0"){
                        paddingNum *= int(paddingChar);
                        paddingChar = " ";
                    }
                }
            }
            if (isPositionalSubst){
                // by position, grab next subs:
                replacementValue = rest[matches.length];

            }else{
                // be hash / properties
                replacementValue = rest[0] == null ? undefined : rest[0][varName];
            }
            // check for bad variable names
            if (replacementValue == undefined){
                replacementValue = "";
            }
            if (replacementValue != undefined){

                // format the string accordingly to the formatter
                if (formatter == STRING_FORMATTER){
                    var str:String = String(replacementValue);
                    match.replacement = padString(str, paddingNum, paddingChar);
                }else if (formatter == FLOAT_FORMATTER){
                    // floats, check if we need to truncate precision
                    if (precision){
                        match.replacement = padString(
                                Number(replacementValue).toFixed( int(precision)),
                                paddingNum,
                                paddingChar);
                    }else{
                        match.replacement = padString(String(replacementValue), paddingNum, paddingChar);
                    }
                }else if (formatter == INTEGER_FORMATTER){
                    match.replacement = padString(int(replacementValue).toString(), paddingNum, paddingChar);
                }else if (formatter == OCTAL_FORMATTER){
                    match.replacement = "0" + int(replacementValue).toString(8);
                }else if (formatter == HEX_FORMATTER){
                    match.replacement = "0x" + padString(int(replacementValue).toString(16), paddingNum, paddingChar);
                }else if (formatter == HEX_FORMATTER_UPPERCASE){
                    match.replacement = "0x" + padString(int(replacementValue).toString(16).toUpperCase(), paddingNum, paddingChar);
                }else if(DATES_FORMATTERS.indexOf(formatter) > -1){
                    switch (formatter){
                        case DATE_DAY_FORMATTER:
                            match.replacement = replacementValue["date"];
                            break;
                        case DATE_FULL_YEAR_FORMATTER:
                            match.replacement = replacementValue["fullYear"];
                            break;
                        case DATE_YEAR_FORMATTER:
                            match.replacement = String(replacementValue["fullYear"]).substr(2, 2);
                            break;
                        case DATE_MONTH_FORMATTER:
                            match.replacement = String(replacementValue["month"] + 1);
                            break;
                        case DATE_HOUR24_FORMATTER:
                            match.replacement = replacementValue["hours"];
                            break;
                        case DATE_HOUR_FORMATTER:
                            var hours24 : Number = replacementValue["hours"];
                            match.replacement =  (hours24 -12).toString();
                            break;
                        case DATE_HOUR_AM_PM_FORMATTER:
                            match.replacement =  (replacementValue["hours"]  >= 12 ? "p.m" : "a.m");
                            break;
                        case DATE_TO_LOCALE_FORMATTER:
                            match.replacement = (replacementValue as Date).toLocaleString();
                            break;
                        case DATE_MINUTES_FORMATTER:
                            match.replacement = replacementValue["minutes"];
                            break;
                        case DATE_SECONDS_FORMATTER:
                            match.replacement = replacementValue["seconds"];
                            break;
                    }
                }else{
                    match.replacement = formatter;
                    //no good replacement
                }
                matches.push(match);
            }

            // just a small check in case we get stuck: kludge!
            runs ++;
            if (runs > 10000){
                //something is wrong, breaking out
                break;
            }
            numMatches ++;
            // iterates next match
            result = SUBS_RE.exec(raw);
        }
        // in case there's nothing to substitute, just return the initial string
        if(matches.length == 0){
            //no matches, returning raw
            return raw;
        }
        // now actually do the substitution, keeping a buffer to be joined at
        //the end for better performance
        var buffer : Array = [];
        var lastMatch : Match = null;
        // beginning os string, if it doesn't start with a substitution
        var previous : String = raw.substr(0, matches[0].startIndex);
        var subs : String;
        for each(match in matches){
            // finds out the previous string part and the next substitution
            if (lastMatch){
                previous = raw.substring(lastMatch.endIndex  ,  match.startIndex);
            }
            buffer.push(previous);
            buffer.push(match.replacement);
            lastMatch = match;

        }
        // buffer the tail of the string: text after the last substitution
        buffer.push(raw.substr(match.endIndex, raw.length - match.endIndex));
        //trace('returning: "'+ buffer.join("")+'"');
        return buffer.join("");
    }
}

/** @private */
const BAD_VARIABLE_NUMBER : String = "The number of variables to be replaced and template holes don't match";
/** Converts to a string*/
const STRING_FORMATTER : String = "s";
/** Outputs as a Number, can use the precision specifier: %.2sf will output a float with 2 decimal digits.*/
const FLOAT_FORMATTER : String = "f";
/** Outputs as an Integer.*/
const INTEGER_FORMATTER : String = "d";
/** Converts to an OCTAL number */
const OCTAL_FORMATTER : String = "o";
/** Converts to hex (includes 0x) */
const HEX_FORMATTER : String = "x";
/** Converts to uppercase hex (includes 0x) */
const HEX_FORMATTER_UPPERCASE : String = "X";
/** @private */
const DATES_FORMATTERS : String = "aAbBcDHIjmMpSUwWxXyYZ";
/** Day of month, from 0 to 30 on <code>Date</code> objects.*/
const DATE_DAY_FORMATTER : String = "D";
/** Full year, e.g. 2007 on <code>Date</code> objects.*/
const DATE_FULL_YEAR_FORMATTER : String = "Y";
/** Year, e.g. 07 on <code>Date</code> objects.*/
const DATE_YEAR_FORMATTER : String = "y";
/** Month from 1 to 12 on <code>Date</code> objects.*/
const DATE_MONTH_FORMATTER : String = "m";
/** Hours (0-23) on <code>Date</code> objects.*/
const DATE_HOUR24_FORMATTER : String = "H";
/** Hours 0-12 on <code>Date</code> objects.*/
const DATE_HOUR_FORMATTER : String = "I";
/** a.m or p.m on <code>Date</code> objects.*/
const DATE_HOUR_AM_PM_FORMATTER : String = "p";
/** Minutes on <code>Date</code> objects.*/
const DATE_MINUTES_FORMATTER : String = "M";
/** Seconds on <code>Date</code> objects.*/
const DATE_SECONDS_FORMATTER : String = "S";
/** A string rep of a <code>Date</code> object on the current locale.*/
const DATE_TO_LOCALE_FORMATTER : String = "c";

var version : String = "$Id$";

/** @private
 * Internal class that normalizes matching information.
 */
class Match{
    public var startIndex : int;
    public var endIndex : int;
    public var length : int;
    public var content : String;
    public var replacement : String;
    public var before : String;
    public function toString() : String{
        return "Match [" + startIndex + " - " + endIndex + "] (" + length + ") " + content + ", replacement:" + replacement + ";";
    }
}

/** @private */
function padString(str:String, paddingNum:int, paddingChar:String=" ") : String
{
    if(paddingChar == null) return str;

    return new Array(paddingNum).join(paddingChar).substr(0,paddingNum-str.length).concat(str);
}