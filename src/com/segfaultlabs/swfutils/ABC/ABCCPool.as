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
	 * Constant pool for a single swf file. This object stores all constants values that are
	 * refered from doABC tag. Constant pool content is common for all doABC blocks that are
	 * present in SWF file. 
	 *   
	 * @author malczak
	 * @version 0.1
	 */	
	public final class ABCCPool
	{
		public var ints:Vector.<int>;
		public var uints:Vector.<uint>;
		public var doubles:Vector.<Number>;
		public var strings:Vector.<String>;
		public var namespaces:Vector.<String>;
		public var names:Array;

		public function ABCCPool():void
		{
			super();
			ints = null; uints = null; doubles = null; strings = null; namespaces = null; names = null; 
		};
		
		/**
		 * 'Release' used memory. You should always call this method when parsing has finished, and 
		 *  no more doABC blocks will be parsed. 
		 * 
		 */		
		public function dispose():void
		{
			ints = null; uints = null; doubles = null; strings = null; namespaces = null; names = null; 
		};

	}
}