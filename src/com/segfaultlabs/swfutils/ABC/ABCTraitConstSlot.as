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
	
	import com.segfaultlabs.swfutils.ABC.ABCTraitsInfo;
	
	/**
	 * Single typed property (variable) or constant property trait<br>
	 * eg.<br>
	 *  namespace var name : type [ = value ]<br>
	 * or<br>
	 *  namespace const name : type [ = value ]<br>
	 * @author malczak
	 * @version 0.1
	 */	
	final public class ABCTraitConstSlot extends ABCTraitsInfo
	{
		/* data */
		public var type 	 : * ;//QName; 					
		public var value	 : * ; /*set for Trait_Slot, Trait_Const */		
	}
	
}