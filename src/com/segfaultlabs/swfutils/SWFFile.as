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

package com.segfaultlabs.swfutils {
	
	import flash.errors.IOError;
	import flash.errors.IllegalOperationError;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	
	use namespace swfutils;
	
	/**
	* SWFFile is class for reading SWF files. This class can be used to read basic information
	* from swf file.
	* 
	* @author Mateusz Malczak
	* @version 0.3
	* 	
	*/
	public class SWFFile
	{
		/**
		 * SWF file type headers (in big-endian format) 
		 */		
		static public const COMPRESSED : uint = 0x435753;
		static public const NOT_COMPRESSED : uint = 0x465753;  
		
		private var _type 		 : uint;
		
		private var _ver  		 : uint;
		private var _filesize 	 : uint
		private var _rect 		 : Rectangle;
		private var _framerate   : Number;
		private var _framescount : int;
		/* valid only for version >=9 */
		private var _fileAttr 	 : uint;
		/* * */
		swfutils var _dataInput  : SWFDataInput;				
		
		/*
		 * 
		 * CONSTRUCTOR
		 * 
		 */		
		public function SWFFile( swfbytes:IDataInput )
		{
					if ( swfbytes==null ) throw new IllegalOperationError("SWFFile byte data cannot be null");
				if ( !swfbytes.bytesAvailable ) throw new IllegalOperationError("SWFFile byte data cannot be empty");
			
			swfbytes.endian = Endian.BIG_ENDIAN;
			_type = (swfbytes.readUnsignedByte()<<16)|(swfbytes.readUnsignedByte()<<8)|swfbytes.readUnsignedByte();
			swfbytes.endian = Endian.LITTLE_ENDIAN;
			
			_ver = swfbytes.readUnsignedByte();			
			_filesize = swfbytes.readUnsignedInt();			
			_rect = null;
			_framerate = NaN;
			_framescount = NaN;								
			_fileAttr = 0;
			_dataInput = new SWFDataInput(swfbytes);
			
					if ( _type == NOT_COMPRESSED )	
					{
						_rect = _dataInput.readBitRect();
						_framerate = _dataInput.readFixed8();
						_framescount = _dataInput.readShort();							
					} else if ( _type != COMPRESSED )
								throw new IOError("Not a swf file or data corrupted");
		}
		
		/*
		 * 
		 * PUBLIC PROPERTIES
		 * 
		 */
		public function get compressed():Boolean { return (_type == COMPRESSED); };
		public function get size():uint { return _filesize; };
		public function get version():uint { return _ver; };
		public function get movieRect():Rectangle { return _rect; };
		public function get framerate():Number { return _framerate; };
		public function get framescount():int { return _framescount; };
		public function get hasMetadata():Boolean { return Boolean( _fileAttr & 0x10 ); };
		public function get avm2():Boolean { return Boolean( _fileAttr & 0x08 ); };
		public function get useNetwork():Boolean { return Boolean( _fileAttr & 0x01 ); };
		
		public function get dataInput():IDataInput { return _dataInput; }
			
		public function set dataInput(value:IDataInput):void {
			_dataInput.data = value;
		}
		
		public function get dataInstance():* { return _dataInput.dataInstance; };

		/*
		 * 
		 * PUBLIC METHODS
		 * 
		 */
		
		/**
		 * Method reads swf header data
		 */
		public function readHeader():void
		{
				if ( _dataInput == null ) throw new IOError("No IDataInput specified");
			_rect = _dataInput.readBitRect();
			_framerate = _dataInput.readFixed8();
			_framescount = _dataInput.readShort();							
		};
		
		/**
		 * Read tag data from file and store in in ByteArray. 
		 * 
		 * @param tag tag form which data should be read 
		 */
		public function readTagData( tag:SWFTag ):ByteArray
		{
			var ba:ByteArray = new ByteArray();
			var oldpos:uint = _dataInput.dataInstance.position;
			_dataInput.dataInstance.position = tag.position;
			_dataInput.readBytes(ba, 0, tag.size);
			_dataInput.dataInstance.position = oldpos;
			ba.position = 0;
			return ba;			
		}
		
		/**
		 * Return file metadata. In Flash this is set n Document property. In Flex
		 * metadata can be passed in command line compiler.
		 * 
		 * @param tags array of all tags
		 */
		public function readMetadata( tags:Array ):XML
		{
			if ( tags[77] )
			{
				var metadata:XML = null;
				var oldpos:uint = this.swfutils::_dataInput.dataInstance.position;
				this.swfutils::_dataInput.dataInstance.position = tags[77][0].position;
				metadata = new XML( this.swfutils::_dataInput.readUTFBytes(tags[77][0].size) );
				this.swfutils::_dataInput.dataInstance.position = oldpos;
				return metadata;
			};
			return null;
		}
		
		/**
		 * Method scans all tags in swf file.
		 * 
		 * @params tagsToStore which tags are we interested in. only these tag will be stored. 
		 */			
		public function parseTags(tagsToStore:Array = null ):Array
		{
					if ( _dataInput == null ) throw new IOError("No IDataInput specified");
				if ( !_dataInput.bytesAvailable ) throw new IOError("Input data is empty");								
			_dataInput.endian = Endian.LITTLE_ENDIAN;				
			var bpos:uint = _dataInput.dataInstance.position;			
			var tag:SWFTag = new SWFTag();
			var saveTag:Boolean;
			var tags : Array = [];
			
				do {
					_dataInput.readTag( tag );					
					saveTag = true;
						//if ( tag.type == 0 ) break;
						if ( tag.type == 69/*FileAttributes*/ )
						{
							_fileAttr = _dataInput.readUnsignedInt();
							continue;
						};
						
					_dataInput.dataInstance.position += tag.size;						
					saveTag = (tagsToStore == null)?true:((tagsToStore.indexOf(tag.type) > -1)?true:false);
							  
						if ( saveTag )
						{
								if ( tags[tag.type] == null ) tags[tag.type] = [];
							tags[tag.type].push( tag );
							tag = new SWFTag();
						};					
						
				} while ( _dataInput.bytesAvailable );
				
			_dataInput.dataInstance.position = bpos;
			return tags;
		};
		 
		/*
		 * 
		 * STATIC METODS
		 * 
		 */
		 
		/**
		 * method uncompresses swf content and returns ByteArray
		 */		
		public function uncompress():IDataInput
		{
				if ( this.swfutils::_dataInput == null ) throw new IOError("No IDataInput specified");
			var byteArray : ByteArray = new ByteArray();
			this.swfutils::_dataInput.readBytes( byteArray );
			byteArray.position = 0;
			byteArray.uncompress();
			byteArray.position = 0;
			return byteArray;
		};
		
		/**
		 * get all exported classes/definitions (as3 only)
		 * @param	reader
		 * @param	tagArr array of tags returned by parseTags function
		 * @return	array of exported classes available for applicationDomain.getDefinition(...)
		 */
		public function getDefinitions( tagArr:Array ):Array
		{
			var tag:SWFTag;
			var clazzArr:Array = [];
			var num:uint;
			var bpos:uint = this.swfutils::_dataInput.dataInstance.position;			
				for each ( tag in tagArr[76] )
				{
					this.swfutils::_dataInput.dataInstance.position = tag.position;
					num = this.swfutils::_dataInput.readUnsignedShort();
					  while ( num )
					  {
						clazzArr[ this.swfutils::_dataInput.readUnsignedShort() ] = this.swfutils::_dataInput.readString();
						num -= 1;
					  };
				};				
			this.swfutils::_dataInput.dataInstance.position = bpos;
			return clazzArr;
		};
		
		/**
		 * Check if there are any actions in swf file. Valid only for AVM1. In case of
		 * AVM2 code is always present in file. If second parameters is set true, method
		 * also scans alll sprites present in file. 
		 * 
		 * @param	tagArr tags array readed with SWFFile object
		 * @param	checkSprites if true function checks all defined sprites
		 * @return if return value is true then reader contains swf file with actions
		 */
		public function hasActions( tagArr:Array, checkSprites:Boolean=true ):Boolean
		{
			if ( avm2 ) return true;	
			var _hasActions:Boolean = ( tagArr[82] != null ) || ( tagArr[59] != null ) || ( tagArr[12] != null );			
			_hasActions = _hasActions || ( tagArr[7] != null) || (tagArr[34] != null);
				if ( checkSprites )
				{
					var tag:SWFTag;
					var wtag:SWFTag;
					var pos:uint;
						for each ( tag in tagArr[39] )
						{
							wtag = new SWFTag();
							this.swfutils::_dataInput.dataInstance.position = tag.position + 2;
							/* animated is treated as if it has actions */
								if ( this.swfutils::_dataInput.dataInstance.readUnsignedShort() > 1 ) return true;
							pos = tag.position + tag.size;
								while ( this.swfutils::_dataInput.dataInstance.position < pos )
								{
									this.swfutils::_dataInput.readTag(wtag);
										if ( wtag.type == 12 ) return true;
									this.swfutils::_dataInput.dataInstance.position += wtag.size;
								};
						};
				};
			return _hasActions;
		};

	}	
	
}
