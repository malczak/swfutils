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
	
	/**
	 * This class describes a single Action Script 3 class, or more precisely a single class instance. ABCInstance
	 * stores information about all non static properties and methods of the class. Static properties and methods
	 * are stored in ABCClass obejct, that can be accessed using the cref property of ABCInstance. ABCInstance 
	 * together with related ABCClass are fully describing single Action Script class, including information 
	 * about metadata related with clas and/or with properties.  
	 * 
	 */ 
	
	final public class ABCInstance extends ABCTraits
	{
		public var name 		: String;
		public var base		 	: String;
		/* [ CONSTANT_ClassSealed | CONSTANT_ClassFinal | CONSTANT_ClassInterface | CONSTANT_ClassProtededNs ]  */
		public var flags 		: uint;
		/* if ( flags | CONSTANT_ClassProtectedNs ) */
		public var protectedNs  : String; 
		public var interfaces 	: Array;	
			
		public var cref 		: ABCClass;
		
			public function ABCInstance():void
			{
				_traits = null;
			};		
	};
	
}