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
	
	/**
	 * TypeName is used in SWF files starting from version 10. Not documented anywhere, 
	 * based on abcdump.as and Tamarin internals.
	 * 
	 * @author malczak
	 * @version 0.2
	 */
	public final class ABCTypeName extends Object
	{
		public var name:String;
		public var types:Vector.<String>;
		
		public function ABCTypeName( name:String, types:Vector.<String>)
		{
			this.name = name;
			this.types = types;
		};
		
		public function toString():String
		{
	       var s : String = name.toString();
            s += ".<"
            for( var i:uint = 0; i < types.length; ++i )
                s += types[i] != null ? types[i].toString() : "*" + " ";
            s += ">"
            return s;
		};

	}
}