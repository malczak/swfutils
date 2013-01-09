/*  ***** BEGIN LICENSE BLOCK *****
 * 
 * Version 1.1 (the "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 * 
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an "AS IS" basis, 
 * WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License 
 * for the specific language governing rights and
 * limitations under the License.
 * 
 * The Original Code is [ swfutils ].
 * 
 * The Initial Developer of the Original Code is 
 * 	Mateusz Malczak ( http://segfaultlabs.com ).
 * Portions created by Initial Developer are Copyright (C) 2008
 * by Initial Developer. All Rights Reserved.
 * 
 * ***** END LICENSE BLOCK ***** */

package com.segfaultlabs.swfutils
{	
	import flash.display.GraphicsGradientFill;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	
	use namespace swfutils;
	
	/**
	 * This class is used to read data from SWF file. Currently this class can 
	 * read all (or almost all) SWF specific types. For a complete list of SWF
	 * types refere to SWF file format documentation.
	 * 
	 * @version 0.2
	 * @author malczak
	 */ 
	final public class SWFDataInput implements IDataInput 
	{
		/* * */
		private var _endianDouble : ByteArray;
		private var _bitbuff : uint;
		private var _bitleft : uint;

		swfutils var _dataInput : IDataInput;
		swfutils var _dataClass : Class;
		
		public function SWFDataInput( data:IDataInput ):void
		{
			_dataInput = data;			
			_dataClass = Object(data).constructor as Class;
			_bitbuff = _bitleft = 0;
			_endianDouble = new ByteArray();
			_endianDouble.endian = Endian.LITTLE_ENDIAN;
		};
			
		public function get data():IDataInput { return _dataInput; }
		
		public function set data(value:IDataInput):void 
		{
			_dataInput = value;
			_dataInput.endian = Endian.LITTLE_ENDIAN;
			_dataClass = Object(data).constructor as Class;
			_bitbuff = _bitleft = 0;
		}		
		
		public function get dataInstance():* { return (_dataInput as _dataClass); };
		
		/*
		 * 
		 * SWF reading functions
		 * 
		 */		
		public function flushBits():void
		{
			_bitbuff = _bitleft = 0;
		};
		
		public function readTag( tag:SWFTag ):void
		{
			tag.type = _dataInput.readUnsignedShort();
			tag.size = tag.type & 0x3f;
				if ( tag.size == 0x3f )
					tag.size = _dataInput.readUnsignedInt();
			tag.type >>= 6;
			tag.position = (_dataInput as _dataClass).position;								
		};
		
		public function readSB( bits:uint ):int
		{
	        var num:int = readUB(bits);
	        var shift:int = 32-bits;
	        num = (num << shift) >> shift;			
	        return num;
		};
		
		public function readUB( bits:uint ):uint
		{			
				if ( bits > 64 || bits == 0 ) return 0;
			var r:uint = (_bitbuff >> (8 - _bitleft));
			    if ( _bitleft >= bits )
			    {
					_bitleft -= bits;
					_bitbuff <<= bits;
					return (r >> (8-bits));
			    };
			bits -= _bitleft;
				while ( bits>7 )
				{
					_bitbuff = _dataInput.readUnsignedByte();
				 
				 r = ( r<<8 ) | _bitbuff;
				 bits -= 8;
				 _bitleft = 0;
				};
			_bitbuff = 0;
			    if ( bits )
			    {
					_bitbuff = _dataInput.readUnsignedByte();
					_bitleft = 8-bits;
					r = (r<<bits)|(_bitbuff>>_bitleft);
					_bitbuff <<= bits;
			    };
			_bitbuff &= 0xff;
			return r;
        };	
		
		public function readFB( bits:uint ):Number 
		{
			var fb:uint = readUB( bits );
			return Number( ((fb >> 16) & 0xffff) * 1.0 + ((fb & 0xffff) * 0.1 ) );
		}
		
		public function readFixed():Number
		{
			flushBits();
			_bitbuff = _dataInput.readUnsignedInt();
			var n:Number = Number( ((_bitbuff >> 16) & 0xffff) * 1.0 + ((_bitbuff & 0xffff) * 0.1 ) );
			_bitbuff = 0;
			return n;			
		};
		
		public function readFixed8():Number 
		{
			flushBits();
			_bitbuff = _dataInput.readUnsignedShort();
			var n:Number = Number( ((_bitbuff >> 8) & 0xff) * 1.0 + ((_bitbuff & 0xff) * 0.1 ) );
			_bitbuff = 0;
			return n;
		};
	
		public function readFloat16():Number
		{
			flushBits();
			var n:uint = _dataInput.readUnsignedShort();
			var exp:uint = (n >> 10) & 0x1f;
			var man:uint = (n & 0x3FF);
			var f:Number;
				if ( n & 0x8000 )
					f = man * Math.pow( 2, exp - 16 );
				else
					f = -man * Math.pow( 2, exp - 16 );
			return f;
		}
				
		public function readS24():int
		{
			var b:int = _dataInput.readUnsignedByte();
			b |= _dataInput.readUnsignedByte()<<8;
			b |= _dataInput.readByte()<<16;
			return b
		}
	
		public function readES32():int
		{
			var result:int = _dataInput.readUnsignedByte();
				if (!(result & 0x00000080))
					return (result << 25 ) >> 25;
			result = (result & 0x0000007f) | _dataInput.readUnsignedByte()<<7;
				if (!(result & 0x00004000))
					return (result << 18 ) >> 18;
			result = (result & 0x00003fff) | _dataInput.readUnsignedByte()<<14;
				if (!(result & 0x00200000))
					return (result << 11 ) >> 11;
			result = (result & 0x001fffff) | _dataInput.readUnsignedByte()<<21;
				if (!(result & 0x10000000))
					return (result << 4 ) >> 4;
			return (result & 0x0fffffff) | _dataInput.readUnsignedByte()<<28;
		}
		
		public function readEU32():uint
		{
			var result:uint = _dataInput.readUnsignedByte();
				if (!(result & 0x00000080))
					return result;
			result = (result & 0x0000007f) | _dataInput.readUnsignedByte()<<7;
				if (!(result & 0x00004000))
					return result;
			result = (result & 0x00003fff) | _dataInput.readUnsignedByte()<<14;
				if (!(result & 0x00200000))
					return result;
			result = (result & 0x001fffff) | _dataInput.readUnsignedByte()<<21;
				if (!(result & 0x10000000))
					return result;
			return (result & 0x0fffffff) | _dataInput.readUnsignedByte()<<28;
		};
		
		public function readRGB():uint 
		{
			var rgb:uint = 0x0;
			rgb = _dataInput.readByte() << 16;
			rgb = _dataInput.readByte() << 8;
			rgb = _dataInput.readByte();
			return rgb;			
		}
		
		public function readARGB():uint 
		{
			var argb:uint = 0x0;
			argb = _dataInput.readByte() << 24;
			argb = _dataInput.readByte() << 16;
			argb = _dataInput.readByte() << 8;
			argb = _dataInput.readByte();
			return argb;			
		}

		public function readRGBA():uint 
		{
			var rgba:uint = 0x0;
			rgba = _dataInput.readByte() << 16;
			rgba = _dataInput.readByte() << 8;
			rgba = _dataInput.readByte();
			rgba = _dataInput.readByte() << 24;
			return rgba;			
		}
		
		public function readString():String
		{
			var str:String = "";
			var chr:uint = _dataInput.readUnsignedByte();
				while ( chr > 0 )
				{				
					str += String.fromCharCode( chr );
					chr = _dataInput.readUnsignedByte();
				};
			return str;
		};		

		public function readBitRect():Rectangle
		{
			var bits:uint = readUB(5);
			trace( bits );
			var r:Rectangle = new Rectangle();
			r.x      = int(readSB(bits));
			r.width  = int(readSB(bits));
			r.y      = int(readSB(bits));
			r.height = int(readSB(bits));
			flushBits();
			return r;		 
		};
		
		public function readMatrix():Matrix
		{
			var mtx:Matrix = new Matrix();
			var flag:uint;
			var nbits:uint;
				flag = readUB(1); /* scale */
					if ( flag )
					{
						nbits = readUB(5);
						mtx.a = readFB( nbits );
						mtx.d = readFB( nbits );
					};
				flag = readUB(1); /* rotate */
					if ( flag )
					{
						nbits = readUB(5);
						mtx.b = readFB( nbits );
						mtx.c = readFB( nbits );
					};
				nbits = readUB(5);
				mtx.tx = readFB( nbits ) / 20;
				mtx.ty = readFB( nbits ) / 20;
			return mtx;
		};
		
		public function readColorTransform():ColorTransform
		{
			var ct:ColorTransform = new ColorTransform();
			var flag:uint = readUB(1) | ( readUB(1) << 1 );
			var n:uint = readUB(4);
				if ( flag&1 )
				{
					ct.redMultiplier = readSB( n );
					ct.greenMultiplier = readSB( n );
					ct.blueMultiplier = readSB( n ); 
				};
				if ( flag&2 )
				{
					ct.redOffset = readSB( n );
					ct.greenOffset = readSB( n );
					ct.blueOffset = readSB( n );
				};
			return ct;
		};
		
		public function readGradient( stype:uint = 3 ):GraphicsGradientFill
		{
			var g:GraphicsGradientFill = new GraphicsGradientFill();
				switch ( readUB(2) )
				{
					case 0: g.type = SpreadMethod.PAD; break;
					case 1: g.type = SpreadMethod.REFLECT; break;
					case 2: g.type = SpreadMethod.REPEAT; break;
					// reserved -> case 3: break;
				};
			g.interpolationMethod = ( readUB(2) == 0 )?InterpolationMethod.RGB:InterpolationMethod.LINEAR_RGB; //reserved 2,3
			var numg:uint = readUB(4);
			g.ratios = [];
			g.colors = [];
			var colf:Function = (stype>2)?readARGB:readRGB;
				while ( numg )
				{
					g.ratios.push( _dataInput.readUnsignedByte() );
					g.colors.push( colf.call(this) );
				};						
			return g;
		};
		
		public function readFocalGradient( stype:uint = 4 ):GraphicsGradientFill
		{
			var g:GraphicsGradientFill = readGradient( stype );
			g.focalPointRatio = readFloat();	
			return g;
		};
		
		
		/*
		 * 
		 * IDataInput interface methods
		 * 
		 */
		public function get bytesAvailable():uint  { return _dataInput.bytesAvailable; };
		public function get endian():String { return _dataInput.endian; };
		public function set endian(value:String):void { if ( value != _dataInput.endian ) _dataInput.endian = value; };
		public function get objectEncoding():uint { return _dataInput.objectEncoding; };
		public function set objectEncoding(value:uint):void { if ( value != _dataInput.objectEncoding ) _dataInput.objectEncoding = value; };
			
		public function readBoolean():Boolean { return _dataInput.readBoolean(); };
		public function readByte():int { return _dataInput.readByte(); };
		public function readBytes(bytes:ByteArray, offset:uint = 0, length:uint = 0):void { _dataInput.readBytes( bytes, offset, length ); }
		public function readDouble():Number 
		{
			/**
			 * this is needed to read doubles, by default readDouble reads 8 bytes in specified-endiannes,
			 * but it should read two 4 bytes groups in little endian. 
			 */
			var b:ByteArray = new ByteArray();			
			_endianDouble.position = 0;
			_endianDouble.writeUnsignedInt( _dataInput.readUnsignedInt() );
			_endianDouble.position = 0;
			_endianDouble.writeUnsignedInt( _dataInput.readUnsignedInt() );
			_endianDouble.position = 0;
			var n:Number = b.readDouble();
			_endianDouble.length = 0;
			return n; 
		};
		public function readFloat():Number { return _dataInput.readFloat(); };
		public function readInt():int { return _dataInput.readInt(); };
		public function readMultiByte(length:uint, charSet:String):String  { return _dataInput.readMultiByte( length, charSet ); };
		public function readObject():*  { return _dataInput.readObject(); };
		public function readShort():int  { return _dataInput.readShort(); };
		public function readUnsignedByte():uint  { return _dataInput.readUnsignedByte(); };
		public function readUnsignedInt():uint { return _dataInput.readUnsignedInt(); };
		public function readUnsignedShort():uint { return _dataInput.readUnsignedShort(); };
		public function readUTF():String { return _dataInput.readUTF(); };
		public function readUTFBytes(length:uint):String  { return _dataInput.readUTFBytes(length); };
	}
	
}