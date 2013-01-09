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
	/**
	 * This class describes a single resorce trait, together with its metdata. Metadata 
	 * is stored only if source was compiled with proper compilation flag.
	 * <br>
	 * For more information refere to : 'ActionScript Virtual Machine 2 (AVM2) Overview'
	 * 
	 * @author malczak
	 * @version 0.2
	 */	
	public class ABCTraitsInfo
	{
		public var name 	 : String;		
		public var kind 	 : uint;
		/* 0000 0000
		 *  |    |----- trait kind ( Trait_Slot, Trait_Method, Trait_Getter, Trait_Setter, Trait_Class, Trait_Function, Trait_Const )
		 *  |---------- attributes 
		 * 					ATTR_Final for (Trait_Method, Trait_Setter, Trait_Getter)
		 * 					ATTR_Override for (Trait_Method, Trait_Setter, Trait_Getter)
		 * 					ATTR_Metadata has metadata
		 **/
		public var id 		 : uint;
			/* if ( type&ATTR_METADATA ) */
		public var metadata  : Array;
		
		public function get traitType():uint { return kind & 0x0f; };
		public function get traitAttrs():uint { return (kind >> 4); };
	};

}