package ru.kubline.logger.luminicbox {

    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.xml.XMLNode;

    /*
     * Copyright (c) 2005 Pablo Costantini (www.luminicbox.com). All rights reserved.
     *
     * Licensed under the MOZILLA PUBLIC LICENSE, Version 1.1 (the "License");
     * you may not use this file except in compliance with the License.
     * You may obtain a copy of the License at
     *
     *      http://www.mozilla.org/MPL/MPL-1.1.html
     *
     * Unless required by applicable law or agreed to in writing, software
     * distributed under the License is distributed on an "AS IS" BASIS,
     * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     * See the License for the specific language governing permissions and
     * limitations under the License.
     */

    /**
     * Publishes logging messages into the OUTPUT window of the Macromedia Flash editor.<br />
     * This publisher can only be used inside the Flash editor and uses the trace() command internally.
     */
    public class TracePublisher implements IPublisher {

        private var _maxDepth:Number;

        /**
         * Sets the max. inspection depth.<br />
         * The default value is 4.
         * The max. valid value is 255.
         */
        public function set maxDepth(value:Number) { _maxDepth = (_maxDepth>255)?255:value; }
        /**
         * Gets the max. inspection depth
         */
        public function get maxDepth():Number { return _maxDepth; }

        /**
         * Return the publishers type name: "TracePublisher".
         */
        public function toString():String { return "TracePublisher"; }

        /**
         * Creates a TracePublisher instance with a default max. inspection depth of 4.
         */
        public function TracePublisher() {
            _maxDepth = 4;
        }

        /**
         * Logs a message into the OUTPUT window of the Flash editor.
         */
        public function publish(e:LogEvent):void {
            var arg:Object = e.argument;
            var txt:String = "*" + e.level.toString() + "*";
            if(e.loggerId) txt += ":" + e.loggerId;
            txt += ":";
            txt += analyzeObj(arg, 1);
            trace(txt);
        }

        private function analyzeObj(obj:Object, depth:Number):String {
            var txt:String = "";
            var typeOf:String = typeof(obj);
            if(typeOf == "string") {
                // STRING
                txt += "\"" + obj + "\"";
            } else if(typeOf == "boolean" || typeOf == "number") {
                // BOOLEAN / NUMBER
                txt += obj;
            } else if(typeOf == "undefined" || typeOf == "null") {
                // UNDEFINED / NULL
                txt += "("+typeOf+")";
            } else {
                // OBJECT
                var stringifyObj:Boolean = false;
                var analize:Boolean = true;
                if(obj instanceof Array) {
                    // ARRAY
                    typeOf = "array";
                    stringifyObj = false;
                } else if(obj instanceof SimpleButton) {
                    // BUTTON
                    typeOf = "button";
                    stringifyObj = true;
                } else if(obj instanceof Date) {
                    // DATE
                    typeOf = "date";
                    analize = false;
                    stringifyObj = true;
                } else if(obj instanceof MovieClip) {
                    // MOVIECLIP
                    typeOf = "movieclip";
                    stringifyObj = true;
                } else if(obj instanceof XML) {
                    // XML
                    typeOf = "xml";
                    analize = false;
                    stringifyObj = true;
                } else if(obj instanceof XMLNode) {
                    // XML
                    typeOf = "xmlnode";
                    analize = false;
                    stringifyObj = true;
                }
                txt += "(" + typeOf + ") ";
                if(stringifyObj) txt += obj.toString();
                if(analize && depth <= _maxDepth) {
                    var txtProps:String = "";
                    for(var prop:Object in obj) {
                        txtProps += "\n" +
                                    StringUtility.multiply( "\t", (depth+1) ) +
                                    prop + ":" +
                                    analyzeObj(obj[prop], (depth+1) );
                    }
                    if(txtProps.length > 0) txt += "{" + txtProps + "\n" + StringUtility.multiply( "\t", depth ) + "}";
                }
            }
            return txt;
        }
    }
}