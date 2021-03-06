﻿/*  ***** BEGIN LICENSE BLOCK *****
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
	 * Metadata is always releated with a single trait. Is stores all metadata defined in source code.
	 * User metadata is present only if file was compiled with -compiler.keep-as3-metadata compilation flag.
	 * Source example : 
	 * <listing>
	 * package {
	 * 	[CustomMetada(className="MyClassMetadataName")]
	 *  public class MyClass {
	 *    ...
	 *  }
	 * }
	 * </listing> 
	 * This source after compilation will be parsed as a script with one public class named 'MyClass',
	 * with one related metadata object named 'CustomMetadata'. Key, value pairs are stored as
	 * properties of a ABCMetaData object.
	 * 
	 * @author malczak
	 * 
	 */
	dynamic public class ABCMetaData
	{		
		/* u30 name
		 * u30 item_count 
		 * item_info {
		 * 		u30 key
		 * 		u30 value
		 * 			 } items[item_count]
		 */
		public var name:String		
		public function toString():String 
		{
			var last:String
			var s:String = last = '['+name+'('
			for ( var n:String in this)
				s = (last = s + n + "=" + '"' + this[n] + '"') + ','
			return last + ')]'
		}
	}
	
}