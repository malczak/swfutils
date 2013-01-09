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
	 * Multinames defined in 'ActionScript Virtual Machine 2 (AVM2) Overview'.
	 * !NOTE!
	 * This will probably be removed or redesigned in future. Used internally somewhere
	 * in ABCinfo class.
	 *  
	 * @author malczak
	 * @version 0.1
	 */
	final public class ABCMultiname extends Object
	{
		public var nsset : Vector.<String>;
		public var name  : String;
		
		function ABCMultiname(nsset:Vector.<String>, name:String)
		{
			this.nsset = nsset
			this.name = name
		}
		
		public function toString():String
		{
			return '{' + nsset.join(":") + '}::' + name
		}
	}
	
}