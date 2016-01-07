/*
 Adobe Systems Incorporated(r) Source Code License Agreement
 Copyright(c) 2005 Adobe Systems Incorporated. All rights reserved.
 Please read this Source Code License Agreement carefully before using
 the source code.
 Adobe Systems Incorporated grants to you a perpetual, worldwide, non-exclusive,
 no-charge, royalty-free, irrevocable copyright license, to reproduce,
 prepare derivative works of, publicly display, publicly perform, and
 distribute this source code and such derivative works in source or
 object code form without any attribution requirements.
 The name "Adobe Systems Incorporated" must not be used to endorse or promote products
 derived from the source code without prior written permission.
 You agree to indemnify, hold harmless and defend Adobe Systems Incorporated from and
 against any loss, damage, claims or lawsuits, including attorney's
 fees that arise or result from your use or distribution of the source
 code.
 THIS SOURCE CODE IS PROVIDED "AS IS" AND "WITH ALL FAULTS", WITHOUT
 ANY TECHNICAL SUPPORT OR ANY EXPRESSED OR IMPLIED WARRANTIES, INCLUDING,
 BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE ARE DISCLAIMED. ALSO, THERE IS NO WARRANTY OF
 NON-INFRINGEMENT, TITLE OR QUIET ENJOYMENT. IN NO EVENT SHALL MACROMEDIA
 OR ITS SUPPLIERS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
 OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOURCE CODE, EVEN IF
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

package ru.kubline.crypto {


public class MD5 extends Object {

    public function MD5() {
        return;
    }// end function

    private static function HH(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int):int {
        param1 = AddUnsigned(param1, AddUnsigned(AddUnsigned(H(param2, param3, param4), param5), param7));
        return AddUnsigned(RotateLeft(param1, param6), param2);
    }// end function

    private static function ConvertToWordArray(param1:String):Array {
        var _loc_2:Number = NaN;
        var _loc_3:* = param1.length;
        var _loc_4:* = _loc_3 + 8;
        var _loc_5:* = (_loc_4 - _loc_4 % 64) / 64;
        var _loc_6:* = (_loc_5 + 1) * 16;
        var _loc_7:* = new Array((_loc_6 - 1));
        var _loc_8:Number = 0;
        var _loc_9:Number = 0;
        while (_loc_9 < _loc_3) {

            _loc_2 = (_loc_9 - _loc_9 % 4) / 4;
            _loc_8 = _loc_9 % 4 * 8;
            _loc_7[_loc_2] = _loc_7[_loc_2] | param1.charCodeAt(_loc_9) << _loc_8;
            _loc_9 = _loc_9 + 1;
        }
        _loc_2 = (_loc_9 - _loc_9 % 4) / 4;
        _loc_8 = _loc_9 % 4 * 8;
        _loc_7[_loc_2] = _loc_7[_loc_2] | 128 << _loc_8;
        _loc_7[_loc_6 - 2] = _loc_3 << 3;
        _loc_7[(_loc_6 - 1)] = _loc_3 >>> 29;
        return _loc_7;
    }

    private static function RotateLeft(param1:int, param2:int) : Number {
        return param1 << param2 | param1 >>> 32 - param2;
    }

    public static function encrypt(param1:String):String {
        var _loc_2:Array = null;
        var _loc_3:Number = NaN;
        var _loc_4:Number = NaN;
        var _loc_5:Number = NaN;
        var _loc_6:Number = NaN;
        var _loc_7:Number = NaN;
        var _loc_8:Number = NaN;
        var _loc_9:Number = NaN;
        var _loc_10:Number = NaN;
        var _loc_11:Number = NaN;
        var _loc_12:Number = 7;
        var _loc_13:Number = 12;
        var _loc_14:Number = 17;
        var _loc_15:Number = 22;
        var _loc_16:Number = 5;
        var _loc_17:Number = 9;
        var _loc_18:Number = 14;
        var _loc_19:Number = 20;
        var _loc_20:Number = 4;
        var _loc_21:Number = 11;
        var _loc_22:Number = 16;
        var _loc_23:Number = 23;
        var _loc_24:Number = 6;
        var _loc_25:Number = 10;
        var _loc_26:Number = 15;
        var _loc_27:Number = 21;
        param1 = Utf8Encode(param1);
        _loc_2 = ConvertToWordArray(param1);
        _loc_8 = 1732584193;
        _loc_9 = 4023233417;
        _loc_10 = 2562383102;
        _loc_11 = 271733878;
        _loc_3 = 0;
        while (_loc_3 < _loc_2.length) {
            _loc_4 = _loc_8;
            _loc_5 = _loc_9;
            _loc_6 = _loc_10;
            _loc_7 = _loc_11;
            _loc_8 = FF(_loc_8, _loc_9, _loc_10, _loc_11, _loc_2[_loc_3 + 0], _loc_12, 3614090360);
            _loc_11 = FF(_loc_11, _loc_8, _loc_9, _loc_10, _loc_2[(_loc_3 + 1)], _loc_13, 3905402710);
            _loc_10 = FF(_loc_10, _loc_11, _loc_8, _loc_9, _loc_2[_loc_3 + 2], _loc_14, 606105819);
            _loc_9 = FF(_loc_9, _loc_10, _loc_11, _loc_8, _loc_2[_loc_3 + 3], _loc_15, 3250441966);
            _loc_8 = FF(_loc_8, _loc_9, _loc_10, _loc_11, _loc_2[_loc_3 + 4], _loc_12, 4118548399);
            _loc_11 = FF(_loc_11, _loc_8, _loc_9, _loc_10, _loc_2[_loc_3 + 5], _loc_13, 1200080426);
            _loc_10 = FF(_loc_10, _loc_11, _loc_8, _loc_9, _loc_2[_loc_3 + 6], _loc_14, 2821735955);
            _loc_9 = FF(_loc_9, _loc_10, _loc_11, _loc_8, _loc_2[_loc_3 + 7], _loc_15, 4249261313);
            _loc_8 = FF(_loc_8, _loc_9, _loc_10, _loc_11, _loc_2[_loc_3 + 8], _loc_12, 1770035416);
            _loc_11 = FF(_loc_11, _loc_8, _loc_9, _loc_10, _loc_2[_loc_3 + 9], _loc_13, 2336552879);
            _loc_10 = FF(_loc_10, _loc_11, _loc_8, _loc_9, _loc_2[_loc_3 + 10], _loc_14, 4294925233);
            _loc_9 = FF(_loc_9, _loc_10, _loc_11, _loc_8, _loc_2[_loc_3 + 11], _loc_15, 2304563134);
            _loc_8 = FF(_loc_8, _loc_9, _loc_10, _loc_11, _loc_2[_loc_3 + 12], _loc_12, 1804603682);
            _loc_11 = FF(_loc_11, _loc_8, _loc_9, _loc_10, _loc_2[_loc_3 + 13], _loc_13, 4254626195);
            _loc_10 = FF(_loc_10, _loc_11, _loc_8, _loc_9, _loc_2[_loc_3 + 14], _loc_14, 2792965006);
            _loc_9 = FF(_loc_9, _loc_10, _loc_11, _loc_8, _loc_2[_loc_3 + 15], _loc_15, 1236535329);
            _loc_8 = GG(_loc_8, _loc_9, _loc_10, _loc_11, _loc_2[(_loc_3 + 1)], _loc_16, 4129170786);
            _loc_11 = GG(_loc_11, _loc_8, _loc_9, _loc_10, _loc_2[_loc_3 + 6], _loc_17, 3225465664);
            _loc_10 = GG(_loc_10, _loc_11, _loc_8, _loc_9, _loc_2[_loc_3 + 11], _loc_18, 643717713);
            _loc_9 = GG(_loc_9, _loc_10, _loc_11, _loc_8, _loc_2[_loc_3 + 0], _loc_19, 3921069994);
            _loc_8 = GG(_loc_8, _loc_9, _loc_10, _loc_11, _loc_2[_loc_3 + 5], _loc_16, 3593408605);
            _loc_11 = GG(_loc_11, _loc_8, _loc_9, _loc_10, _loc_2[_loc_3 + 10], _loc_17, 38016083);
            _loc_10 = GG(_loc_10, _loc_11, _loc_8, _loc_9, _loc_2[_loc_3 + 15], _loc_18, 3634488961);
            _loc_9 = GG(_loc_9, _loc_10, _loc_11, _loc_8, _loc_2[_loc_3 + 4], _loc_19, 3889429448);
            _loc_8 = GG(_loc_8, _loc_9, _loc_10, _loc_11, _loc_2[_loc_3 + 9], _loc_16, 568446438);
            _loc_11 = GG(_loc_11, _loc_8, _loc_9, _loc_10, _loc_2[_loc_3 + 14], _loc_17, 3275163606);
            _loc_10 = GG(_loc_10, _loc_11, _loc_8, _loc_9, _loc_2[_loc_3 + 3], _loc_18, 4107603335);
            _loc_9 = GG(_loc_9, _loc_10, _loc_11, _loc_8, _loc_2[_loc_3 + 8], _loc_19, 1163531501);
            _loc_8 = GG(_loc_8, _loc_9, _loc_10, _loc_11, _loc_2[_loc_3 + 13], _loc_16, 2850285829);
            _loc_11 = GG(_loc_11, _loc_8, _loc_9, _loc_10, _loc_2[_loc_3 + 2], _loc_17, 4243563512);
            _loc_10 = GG(_loc_10, _loc_11, _loc_8, _loc_9, _loc_2[_loc_3 + 7], _loc_18, 1735328473);
            _loc_9 = GG(_loc_9, _loc_10, _loc_11, _loc_8, _loc_2[_loc_3 + 12], _loc_19, 2368359562);
            _loc_8 = HH(_loc_8, _loc_9, _loc_10, _loc_11, _loc_2[_loc_3 + 5], _loc_20, 4294588738);
            _loc_11 = HH(_loc_11, _loc_8, _loc_9, _loc_10, _loc_2[_loc_3 + 8], _loc_21, 2272392833);
            _loc_10 = HH(_loc_10, _loc_11, _loc_8, _loc_9, _loc_2[_loc_3 + 11], _loc_22, 1839030562);
            _loc_9 = HH(_loc_9, _loc_10, _loc_11, _loc_8, _loc_2[_loc_3 + 14], _loc_23, 4259657740);
            _loc_8 = HH(_loc_8, _loc_9, _loc_10, _loc_11, _loc_2[(_loc_3 + 1)], _loc_20, 2763975236);
            _loc_11 = HH(_loc_11, _loc_8, _loc_9, _loc_10, _loc_2[_loc_3 + 4], _loc_21, 1272893353);
            _loc_10 = HH(_loc_10, _loc_11, _loc_8, _loc_9, _loc_2[_loc_3 + 7], _loc_22, 4139469664);
            _loc_9 = HH(_loc_9, _loc_10, _loc_11, _loc_8, _loc_2[_loc_3 + 10], _loc_23, 3200236656);
            _loc_8 = HH(_loc_8, _loc_9, _loc_10, _loc_11, _loc_2[_loc_3 + 13], _loc_20, 681279174);
            _loc_11 = HH(_loc_11, _loc_8, _loc_9, _loc_10, _loc_2[_loc_3 + 0], _loc_21, 3936430074);
            _loc_10 = HH(_loc_10, _loc_11, _loc_8, _loc_9, _loc_2[_loc_3 + 3], _loc_22, 3572445317);
            _loc_9 = HH(_loc_9, _loc_10, _loc_11, _loc_8, _loc_2[_loc_3 + 6], _loc_23, 76029189);
            _loc_8 = HH(_loc_8, _loc_9, _loc_10, _loc_11, _loc_2[_loc_3 + 9], _loc_20, 3654602809);
            _loc_11 = HH(_loc_11, _loc_8, _loc_9, _loc_10, _loc_2[_loc_3 + 12], _loc_21, 3873151461);
            _loc_10 = HH(_loc_10, _loc_11, _loc_8, _loc_9, _loc_2[_loc_3 + 15], _loc_22, 530742520);
            _loc_9 = HH(_loc_9, _loc_10, _loc_11, _loc_8, _loc_2[_loc_3 + 2], _loc_23, 3299628645);
            _loc_8 = II(_loc_8, _loc_9, _loc_10, _loc_11, _loc_2[_loc_3 + 0], _loc_24, 4096336452);
            _loc_11 = II(_loc_11, _loc_8, _loc_9, _loc_10, _loc_2[_loc_3 + 7], _loc_25, 1126891415);
            _loc_10 = II(_loc_10, _loc_11, _loc_8, _loc_9, _loc_2[_loc_3 + 14], _loc_26, 2878612391);
            _loc_9 = II(_loc_9, _loc_10, _loc_11, _loc_8, _loc_2[_loc_3 + 5], _loc_27, 4237533241);
            _loc_8 = II(_loc_8, _loc_9, _loc_10, _loc_11, _loc_2[_loc_3 + 12], _loc_24, 1700485571);
            _loc_11 = II(_loc_11, _loc_8, _loc_9, _loc_10, _loc_2[_loc_3 + 3], _loc_25, 2399980690);
            _loc_10 = II(_loc_10, _loc_11, _loc_8, _loc_9, _loc_2[_loc_3 + 10], _loc_26, 4293915773);
            _loc_9 = II(_loc_9, _loc_10, _loc_11, _loc_8, _loc_2[(_loc_3 + 1)], _loc_27, 2240044497);
            _loc_8 = II(_loc_8, _loc_9, _loc_10, _loc_11, _loc_2[_loc_3 + 8], _loc_24, 1873313359);
            _loc_11 = II(_loc_11, _loc_8, _loc_9, _loc_10, _loc_2[_loc_3 + 15], _loc_25, 4264355552);
            _loc_10 = II(_loc_10, _loc_11, _loc_8, _loc_9, _loc_2[_loc_3 + 6], _loc_26, 2734768916);
            _loc_9 = II(_loc_9, _loc_10, _loc_11, _loc_8, _loc_2[_loc_3 + 13], _loc_27, 1309151649);
            _loc_8 = II(_loc_8, _loc_9, _loc_10, _loc_11, _loc_2[_loc_3 + 4], _loc_24, 4149444226);
            _loc_11 = II(_loc_11, _loc_8, _loc_9, _loc_10, _loc_2[_loc_3 + 11], _loc_25, 3174756917);
            _loc_10 = II(_loc_10, _loc_11, _loc_8, _loc_9, _loc_2[_loc_3 + 2], _loc_26, 718787259);
            _loc_9 = II(_loc_9, _loc_10, _loc_11, _loc_8, _loc_2[_loc_3 + 9], _loc_27, 3951481745);
            _loc_8 = AddUnsigned(_loc_8, _loc_4);
            _loc_9 = AddUnsigned(_loc_9, _loc_5);
            _loc_10 = AddUnsigned(_loc_10, _loc_6);
            _loc_11 = AddUnsigned(_loc_11, _loc_7);
            _loc_3 = _loc_3 + 16;
        }
        var _loc_28:* = WordToHex(_loc_8) + WordToHex(_loc_9) + WordToHex(_loc_10) + WordToHex(_loc_11);
        return _loc_28.toLowerCase();
    }

    private static function F(param1:int, param2:int, param3:int):int {
        return param1 & param2 | ~param1 & param3;
    }

    private static function GG(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int):int {
        param1 = AddUnsigned(param1, AddUnsigned(AddUnsigned(G(param2, param3, param4), param5), param7));
        return AddUnsigned(RotateLeft(param1, param6), param2);
    }

    private static function H(param1:int, param2:int, param3:int):int {
        return param1 ^ param2 ^ param3;
    }

    private static function I(param1:int, param2:int, param3:int):int {
        return param2 ^ (param1 | ~param3);
    }

    private static function G(param1:int, param2:int, param3:int):int {
        return param1 & param3 | param2 & ~param3;
    }

    private static function II(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int):Number {
        param1 = AddUnsigned(param1, AddUnsigned(AddUnsigned(I(param2, param3, param4), param5), param7));
        return AddUnsigned(RotateLeft(param1, param6), param2);
    }

    private static function AddUnsigned(param1:int, param2:int):Number {
        var _loc_3:int = 0;
        var _loc_4:int = 0;
        var _loc_5:int = 0;
        var _loc_6:int = 0;
        var _loc_7:int = 0;
        _loc_5 = param1 & 2147483648;
        _loc_6 = param2 & 2147483648;
        _loc_3 = param1 & 1073741824;
        _loc_4 = param2 & 1073741824;
        _loc_7 = (param1 & 1073741823) + (param2 & 1073741823);
        if (_loc_3 & _loc_4) {
            return _loc_7 ^ 2147483648 ^ _loc_5 ^ _loc_6;
        }
        if (_loc_3 | _loc_4) {
            if (_loc_7 & 1073741824) {
                return _loc_7 ^ 3221225472 ^ _loc_5 ^ _loc_6;
            }
            return _loc_7 ^ 1073741824 ^ _loc_5 ^ _loc_6;
        } else {
            return _loc_7 ^ _loc_5 ^ _loc_6;
        }
    }

    private static function FF(param1:int, param2:int, param3:int, param4:int, param5:int, param6:int, param7:int):int {
        param1 = AddUnsigned(param1, AddUnsigned(AddUnsigned(F(param2, param3, param4), param5), param7));
        return AddUnsigned(RotateLeft(param1, param6), param2);
    }

    private static function WordToHex(param1:Number):String {
        var _loc_4:Number = NaN;
        var _loc_5:Number = NaN;
        var _loc_2:String = "";
        var _loc_3:String = "";
        _loc_5 = 0;
        while (_loc_5 <= 3) {
            _loc_4 = param1 >>> _loc_5 * 8 & 255;
            _loc_3 = "0" + _loc_4.toString(16);
            _loc_2 = _loc_2 + _loc_3.substr(_loc_3.length - 2, 2);
            _loc_5 = _loc_5 + 1;
        }
        return _loc_2;
    }

    private static function Utf8Encode(param1:String):String {
        var _loc_4:Number = NaN;
        var _loc_2:String = "";
        var _loc_3:Number = 0;
        while (_loc_3 < param1.length) {
            _loc_4 = param1.charCodeAt(_loc_3);
            if (_loc_4 < 128) {
                _loc_2 = _loc_2 + String.fromCharCode(_loc_4);
            } else {
                if (_loc_4 > 127) {
                }
                if (_loc_4 < 2048) {
                    _loc_2 = _loc_2 + String.fromCharCode(_loc_4 >> 6 | 192);
                    _loc_2 = _loc_2 + String.fromCharCode(_loc_4 & 63 | 128);
                } else {
                    _loc_2 = _loc_2 + String.fromCharCode(_loc_4 >> 12 | 224);
                    _loc_2 = _loc_2 + String.fromCharCode(_loc_4 >> 6 & 63 | 128);
                    _loc_2 = _loc_2 + String.fromCharCode(_loc_4 & 63 | 128);
                }
            }
            _loc_3 = _loc_3 + 1;
        }
        return _loc_2;
    }// end function
}
}