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

package com.segfaultlabs.swfutils.avm1 {

	import com.segfaultlabs.swfutils.SWFFile;
	import com.segfaultlabs.swfutils.SWFTag;
	import com.segfaultlabs.swfutils.SWFDataInput;
	import com.segfaultlabs.swfutils.avm1.SWFActions;
	import com.segfaultlabs.swfutils.LogWriter.ILogWriter;
	import com.segfaultlabs.swfutils.LogWriter.TraceWriter;
	import com.segfaultlabs.swfutils.swfutils;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * This class is an example of how to decompile AVM1 bytecode to human readable assembly code.	
	 *  
	 * @author malczak
	 * @version 0.2
	 */
	public class SWFActionDump {
				
		static private function readActionData( swf:SWFFile, _logWriter:ILogWriter, indent:String, act:uint, datalen:uint ):void
		{
			var ui:uint;
			var ui2:uint;
			
			switch( act )
			{
				case 0x81:
						 //return "ActionGotoFrame";
						_logWriter.print(indent + " frame: " + swf.swfutils::_dataInput.readUnsignedShort() );
					break;
				case 0x83:
						 //return "ActionGetURL";
						 _logWriter.print(indent + "    url: " + swf.swfutils::_dataInput.readString() );
						 _logWriter.print(indent + " target: " + swf.swfutils::_dataInput.readString() );						 
					break;
				case 0x87:
						 //return "ActionStoreRegister";
						_logWriter.print(indent + " frame: " + swf.swfutils::_dataInput.readUnsignedByte() );
					break;
				case 0x88:
						 //return "ActionConstantPool";						 
						 ui = swf.swfutils::_dataInput.readUnsignedShort();	
						 _logWriter.print(indent + " length: " + ui );
							while ( ui ) 
							{
								 _logWriter.print(indent + "   #: " + swf.swfutils::_dataInput.readString() );
								 ui -= 1;
							};							
					break;
				case 0x8a:
						 //return "ActionWaitForFrame";
						 _logWriter.print(indent + "  frame: " + swf.swfutils::_dataInput.readUnsignedShort() );
						 _logWriter.print(indent + "   skip: " + swf.swfutils::_dataInput.readUnsignedByte() );						 
					break;
				case 0x8b:
						 //return "ActionSetTarget";
						 _logWriter.print(indent + " target: " + swf.swfutils::_dataInput.readString() );						 
					break;
				case 0x8c:
						 //return "ActionGotoLabel";
						 _logWriter.print(indent + " flags : " + swf.swfutils::_dataInput.readString() );						 
					break;
				case 0x8d:
						 //return "ActionWaitForFrame2";
						 ui = swf.swfutils::_dataInput.readByte();
						 _logWriter.print(indent + " options : " + ui.toString(2) );
							if ( ui&0x40 )
								_logWriter.print(indent + " offset : " + swf.swfutils::_dataInput.readUnsignedShort() );
					break;
				case 0x8e:
						 //return "ActionDefineFunction2";
						 _logWriter.print(indent + "         name : " + swf.swfutils::_dataInput.readString() );
						 ui = swf.swfutils::_dataInput.readUnsignedShort();
						 _logWriter.print(indent + "   regs count : " + swf.swfutils::_dataInput.readUnsignedByte() );
						 _logWriter.print(indent + "       flags  : " + swf.swfutils::_dataInput.readUnsignedByte().toString(2) );
						 _logWriter.print(indent + "  pre global  : " + swf.swfutils::_dataInput.readUnsignedByte().toString(2) );
						 _logWriter.print(indent + "       params : " + ui );
							while ( ui )
							{
								ui2 = swf.swfutils::_dataInput.readUnsignedByte();
								_logWriter.print(indent +"        #: " + ui2+", "+swf.swfutils::_dataInput.readString() );
								ui -= 1;
							}
						 /* code */
						 ui = swf.swfutils::_dataInput.readUnsignedShort();
						 _logWriter.print( indent +indent+ "  {" );								 
						 _dumpCode( swf, swf.swfutils::_dataInput.dataInstance.position, ui, _logWriter, indent + indent+"  " );								 
						 _logWriter.print( indent +indent+ "  }" );								 
					break;
				case 0x8f:
						 //return "ActionTry";
						 swf.swfutils::_dataInput.dataInstance.position += datalen;
					break;
				case 0x94:
						 //return "ActionWith";
						 swf.swfutils::_dataInput.dataInstance.position += datalen;
					break;
				case 0x96:
						//return "ActionPush";
						 var topush:int = swf.swfutils::_dataInput.dataInstance.position;
							while ( swf.swfutils::_dataInput.dataInstance.position <  topush+datalen )
							{								
								ui = swf.swfutils::_dataInput.readUnsignedByte();
									switch( ui )
									{
										case 0: _logWriter.print(indent + "  str: " + swf.swfutils::_dataInput.readString()  ); break;
										case 1: _logWriter.print(indent + "  flt: " + swf.swfutils::_dataInput.readFloat()  ); break;
										case 4: _logWriter.print(indent + "  reg: " + swf.swfutils::_dataInput.readUnsignedByte()  ); break;
										case 5: _logWriter.print(indent + " bool: " + swf.swfutils::_dataInput.readUnsignedByte()  ); break;
										case 6: _logWriter.print(indent + "  dbl: " + swf.swfutils::_dataInput.readDouble()  ); break;
										case 7: _logWriter.print(indent + "   int: " + swf.swfutils::_dataInput.readInt()  ); break;
										case 8: _logWriter.print(indent + " cpool: " + swf.swfutils::_dataInput.readUnsignedByte()  ); break;
										case 9: _logWriter.print(indent + " cpool: " + swf.swfutils::_dataInput.readUnsignedShort()  ); break;
									};
							};
					break;
				case 0x99:
						 //return "ActionJump";
						  _logWriter.print(indent + " offset: " + swf.swfutils::_dataInput.readShort()  ); break;
					break;
				case 0x9a:
						 //return "ActionGetURL2";
						 ui = swf.swfutils::_dataInput.readUnsignedByte() ;
							switch( ui & 3 )
							{
								case 0: _logWriter.print(indent + " method: None "); break;
								case 1: _logWriter.print(indent + " method: GET "); break;
								case 2: _logWriter.print(indent + " method: POST "); break;
							}
						 _logWriter.print(indent + " load flags:", (ui>>6).toString(2) ); break;
					break;
				case 0x9b:
						 //return "ActionDefineFunction";
						 _logWriter.print(indent + "         name : " + swf.swfutils::_dataInput.readString() );
						 ui = swf.swfutils::_dataInput.readUnsignedShort();
						 	while ( ui )
							{
								_logWriter.print(indent +"        #: "+ swf.swfutils::_dataInput.readString() );
								ui -= 1;
							}
						 /* code */
						 ui = swf.swfutils::_dataInput.readUnsignedShort();
						 _logWriter.print( indent +indent+ "  {" );								 
						 _dumpCode( swf, swf.swfutils::_dataInput.dataInstance.position, ui, _logWriter, indent + indent+"  " );								 
						 _logWriter.print( indent +indent+ "  }" );								 
					break;
				case 0x9d:
						 //return "ActionIf";
						  _logWriter.print(indent + " offset: " + swf.swfutils::_dataInput.readShort()  ); break;
					break;
				case 0x9e:
						 //return "ActionCall";
						swf.swfutils::_dataInput.dataInstance.position += datalen;						 
					break;
				case 0x9f:
						 //return "ActionGotoFrame2";
						 ui = swf.swfutils::_dataInput.readByte();
						 _logWriter.print(indent + " options : " + ui.toString(2) );
							if ( ui&0x40 )
								_logWriter.print(indent + " offset : " + swf.swfutils::_dataInput.readUnsignedShort() );
					break;				
			};
		};
		
		static private function _dumpCode( swf:SWFFile, pos:uint, size:uint, _logWriter:ILogWriter, indent:String = null ):void
		{
			var atype:uint = 0;
			var adatlen:uint;
			var adata:*;
				while ( swf.swfutils::_dataInput.dataInstance.position < pos+size )
				{
					atype = swf.swfutils::_dataInput.swfutils::_dataInput.readUnsignedByte();
					
						if ( atype  == 0x0 )
							_logWriter.print(indent + " warning: Possible end if data, tag=0x0");
							
					_logWriter.print( indent + SWFActions.actionName( atype  ) );
					
					adatlen = 0;
					
						if ( atype >= 0x80 )
						{
							adatlen = swf.swfutils::_dataInput.swfutils::_dataInput.readUnsignedShort();
							readActionData( swf, _logWriter, indent+"  ", atype, adatlen );
						};
						
				};
		};
		
		static public function dump( swf:SWFFile, tag:SWFTag, _logWriter:ILogWriter = null,  indent:String = ""):void
		{
				if ( !_logWriter ) _logWriter = new TraceWriter();
			
			if ( tag.type != 12 )
			{
				_logWriter.print(" 'DoAction' tag expected ");
				return;
			}
		
			var oldp:uint = swf.swfutils::_dataInput.dataInstance.position;
			swf.swfutils::_dataInput.dataInstance.position = tag.position;
				try{ 
					var codeend:uint = tag.position + tag.size;
							/* skip this if file is encrypted */
							if ( tag.size > swf.swfutils::_dataInput.bytesAvailable ) throw Error("Action tag end is beyond available data");
							
						_dumpCode( swf, tag.position, tag.size, _logWriter, indent+"  " );
						
					
				} catch ( e:Error )
				{
					_logWriter.print( e.message );
				};
				
			swf.swfutils::_dataInput.dataInstance.position  = oldp;			
		}
	
	}
}