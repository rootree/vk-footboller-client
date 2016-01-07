package ru.kubline.logger.luminicbox {
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
import flash.events.StatusEvent;
import flash.net.LocalConnection;
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
     * Publishes logging messages into the FlashInspector (if available)<br />
     * This publisher can be used in any enviroment as long as the FlashInspector is running. It can be used from inside the Flash editor or from the final production enviroment. This allows to see the logging messages even after the final SWF is in production.
     */
    public class ConsolePublisher implements IPublisher {

        private var _version:Number=0.1;
        private var _maxDepth:Number;

        private var lc:LocalConnection = null;

        private static var isConnected:Boolean = true;
        
        /**
         * Sets the max. inspection depth.<br />
         * The default value is 4.
         * The max. valid value is 255.
         */
        public function set maxDepth(value:Number):void {
            _maxDepth = (_maxDepth>255)?255:value;
        }

        /**
         * Gets the max. inspection depth
         */
        public function get maxDepth():Number {
            return _maxDepth;
        }

        /**
         * Return the publishers type name: "ConsolePublisher".
         */
        public function toString():String {
            return "ConsolePublisher";
        }

        /**
         * Creates a ConsolePublisher instance with a default max. inspection depth of 4.
         */
        public function ConsolePublisher() {
            _maxDepth = 4;
            lc = new LocalConnection();
            lc.addEventListener(StatusEvent.STATUS, onStatusEvent);
        }

        /**
         * Serializes and sends a log message to the FlashInspector window.
         */
        public function publish(e:LogEvent):void {
            if(lc !=null && isConnected){
                var obj:Object = LogEvent.serialize(e);
                obj.argument = serializeObj(obj.argument, 1);
                lc.send("_luminicbox_log_console", "log", obj);
            }
        }

        private function onStatusEvent(e:StatusEvent): void {
           if(e.level == "error"){
                isConnected = false;               
           }
        }

        private function serializeObj(obj:Object, depth:Number):Object {
            var type:Object = getType(obj);
            var serial:Object = new Object();
            if(!type.inspectable) {
                serial.value = obj;
            } else if(type.stringify) {
                serial.value = obj + "";
            } else {
                if(depth <= _maxDepth) {
                    if(type.name == "movieclip" || type.name == "button"){
                        serial.id = obj + "";
                    }
                    var items:Array = new Array();
                    if(obj is Array) {
                        for(var pos:Number=0; pos<obj.length; pos++) {
                            items.push( {property:pos, value:serializeObj( obj[pos], (depth+1) )} );
                        }
                        serial.value = items;
                    } else {
                        var count:int = 0;
                        for(var prop:String in obj) {
                            count++;
                            items.push( {property:prop, value:serializeObj( obj[prop], (depth+1) )} );
                        }
                        if(count > 0){
                            serial.value = items;
                        } else {
                            //говорим что тип это строка
                            type = getType("string");
                            serial.value = obj.toString();
                        }
                    }
                } else {
                    serial.reachLimit =true;
                }
            }
            serial.type = type.name;
            return serial;
        }

        private function getType(o:Object):Object {
            var typeOf:String = typeof(o);
            var type:Object = new Object();
            type.inspectable = true;
            type.name = typeOf;
            if(typeOf == "string" || typeOf == "boolean" || typeOf == "number" || typeOf == "undefined" || typeOf == "null") {
                type.inspectable = false;
            } else if(o is Date) {
                // DATE
                type.inspectable = false;
                type.name = "date";
            } else if(o is Array) {
                // ARRAY
                type.name = "array";
            } else if(o is SimpleButton) {
                // BUTTON
                type.name = "button";
            } else if(o is MovieClip) {
                // MOVIECLIP
                type.name = "movieclip";
            } else if(o is XML) {
                // XML
                type.name = "xml";
                type.stringify = true;
            } else if(o is XMLNode) {
                // XML node
                type.name = "xmlnode";
                type.stringify = true;
            } else {
                type.inspectable = true;
                type.stringify = false;
            }
            return type;
        }
    }
}