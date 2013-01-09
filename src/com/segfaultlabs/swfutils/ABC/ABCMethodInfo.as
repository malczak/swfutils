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
		
	import flash.utils.ByteArray;	
	import com.segfaultlabs.swfutils.ABC.ABCinfo;
	import com.segfaultlabs.swfutils.ABC.ABCTraits;
	import com.segfaultlabs.swfutils.ABC.ABCMultiname;
	import com.segfaultlabs.swfutils.ABC.ABCMethodInfo;
	import com.segfaultlabs.swfutils.ABC.ABCConsts;

	/**
	 * Single method, function object description. This class stores basic information about
	 * functions (methods). Code is stored in related ABCMethodBody object, and can be accessed 
	 * throught <i>body</i> property.
	 * 
	 * ABCMethodInfo are defined for both annonimous and well defined functions. The difference
	 * is, that for annonimous functions <i>body</b> property is empty. That is code is unknown
	 * at this level, it is defined at runtime. 
	 * 
	 * @author malczak
	 * @verison 0.2
	 */
	final public class ABCMethodInfo extends ABCTraitsInfo
	{
		/* method_info */
		/* (ommited) param count */
		public var returnType  	  :		String;
		public var paramTypes	  :		Array;
		public var debugName      : 	String;
		public var flags		  :		uint;
			/* if ( flags | HAS_OPTIONAL ) */
		public var optionalValues : 	Array;
			/* if ( flags | HAS_PARAM_NAMES ) */
		public var paramNames	  : 	Array;
		
		/* ABC opcodes for this method */
		public var body 		  : 	ABCMethodBody;
		
		/* traits */
		//public var activation	  :  	ABCTraits
		
		/* annonimouse function, created somewhere in code */
		public var annonimous:Boolean;
		
		public function ABCMethodInfo()
		{
			returnType = debugName = null;
			paramTypes = optionalValues = paramNames = null;
			body = null;
			annonimous = true;
		};
	}
	
	
}