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
 * The Original Code is [Open Source Virtual Machine.].
 *
 * The Initial Developer of the Original Code is
 * Adobe System Incorporated.
 * Portions created by the Initial Developer are Copyright (C) 2004-2006
 * the Initial Developer. All Rights Reserved.
 * 
 *
 * Contributor(s):
 * 
 *   Adobe AS3 Team
 * 
 *   Mateusz Malczak ( http://segfaultlabs.com )
 * 
 * ***** END LICENSE BLOCK ***** */

package com.segfaultlabs.swfutils.ABC {
	import com.segfaultlabs.swfutils.ABC.ABCTraits;
	import com.segfaultlabs.swfutils.SWFDataInput;
	import com.segfaultlabs.swfutils.swfutils;
	import flash.utils.ByteArray;
	
	/**
	 * ABCMethodBody class is used to store code of a parsed Action Script 3 methods and functions. 
	 * Compiled source code is stored in 'code' ByteArray. This property is valid only if 
	 * 'readMethodBytes' property of used ABCParser was set to 'true'.
	 * If there were any try...except blocks used in code, thay are stored in 'exceptions' array. 
	 * But again, this property is valid only when 'readExceptions' property of a parser was set to true.
	 * 
	 * Both code and exceptions if not readed in parsing stage, can be read later on (currently not implemented). 
	 * 
	 * This object can be accessed only throught a related ABCMethodInfo object.
	 *  
	 * @author malczak
	 * @version 0.1
	 */
	final public class ABCMethodBody extends ABCTraits 
	{
		/* (omitted) method */		
		public var max_stack	  :		uint;
		public var local_count	  :		uint;
		public var init_scope	  :		uint;
		public var max_scope	  :		uint;
		public var code_length	  :		uint 
		public var code			  :		ByteArray;
		public var exceptions	  :		Array;
	};
	
}