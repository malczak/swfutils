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
 
package com.segfaultlabs.swfutils.ABC
{
	import com.segfaultlabs.swfutils.ABC.IABCTraits;
	import com.segfaultlabs.swfutils.ABC.ABCTraits;
	import com.segfaultlabs.swfutils.ABC.ABCInstance;
	import com.segfaultlabs.swfutils.ABC.ABCMethodInfo;
	
	/**
	 * This is description of a single Action Script 3 class, precisely ABCClass stores all static properties and 
	 * methods of a class. ABCClass contains reference to the script where it was defined, and a reference to an
	 * ABCInstance objects. Action Script 3 classes are fully defined with use of ABCClass together 
	 * with ABCInstance. 
	 * Class entry point is init method, this is where class static properties are initialized. 
	 * Class initialization function is always present in AVM2 bytecode it is created for all classes used in project.
	 * If class doesnt contain any static properties, class initialization is build of three opcodes. 
	 * <listing>
	 *  0          getlocal0     	 
 	 *  1          pushscope     	 
 	 *  2          returnvoid 
	 * </listing> 
 	 * 
	 * @author malczak
	 * @version 0.1
	 */	
	final public class ABCClass extends ABCTraitsInfo implements IABCTraits
	{
		public var iref : ABCInstance;
		public var sref : ABCTraits;	
		
		protected var _traits : Vector.<ABCTraitsInfo>;
		protected var _init   : ABCMethodInfo; 
		
		public function ABCClass()
		{
			_traits = null;
		}
		
		public function get init():ABCMethodInfo { return _init; }
		
		public function set init(val:ABCMethodInfo):void { _init = val; }
		
		public function get traits():Vector.<ABCTraitsInfo>
		{
				if ( _traits == null ) _traits = new Vector.<ABCTraitsInfo>();
			return _traits;
		}	
	}
}