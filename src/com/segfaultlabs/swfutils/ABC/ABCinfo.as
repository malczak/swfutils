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
	import __AS3__.vec.Vector;
	
	import com.segfaultlabs.swfutils.LogWriter.ILogWriter;
	import com.segfaultlabs.swfutils.LogWriter.TraceWriter;
	import com.segfaultlabs.swfutils.SWFDataInput;
	import com.segfaultlabs.swfutils.swfutils;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	use namespace swfutils;
	
	/**
	 * This class is an easy to read representation of code from parsed doABC tag. Single
	 * doABC tag (ABCinfo) can store information about many classes used in SWF. In Action 
	 * Script 3 each class is always defined in a seperate source file, called 'script'.
	 * Each script can have only one externally visible class, function or variable.
	 * Beside single public definition, script can store a numer of internal (script private)
	 * objects (classes, functions or variables). This can be presented as a following structure :
	 * <listing>
 	 *	+--------- 
 	 *	| Script
 	 *  |  +--------
 	 *  |  |package 
 	 *	|  | +-------
 	 *	|  | |public resource (class / function / variable)
 	 *	|  | +-------
 	 *	|  +--------
 	 *	|  +--------
 	 *	|  | internal classes
 	 *	|  +--------
 	 *	+---------
 	 * </listing>
 	 * Where single class (both public and internal) is build of namespaced properties and methods:
 	 * <listing> 
 	 *	+-------------
 	 *	| Class
 	 *	|  +-------
 	 *	|  | static data (properties, methods)
 	 *	|  +-------
 	 *	|  +-------
 	 *	|  | class instance (object) data
 	 *	|   +-------
	 *  +-------------
	 * </listing>
	 * 
	 * For more informationa refere to : 
	 * <ul>
	 * 	<li> ActionScript Virtual Machine 2 (AVM2) Overview </li>
	 *  <li> Programming Action Script 3.0 </li>
	 * 	<li> Tamarin project (http://www.mozilla.org/projects/tamarin/) </li>
	 * </ul>
	 * @author malczak
	 * @version 0.2
	 * 
	 */	
	final public class ABCinfo	
	{
		public var major:int
		public var minor:int
		public var target:String;
			
		/* abc info */
		public var methods   : Vector.<ABCMethodInfo>;
		public var metadata  : Vector.<ABCMetaData>;
		public var instances : Vector.<ABCInstance>
		public var classes   : Vector.<ABCClass>
		public var scripts   : Vector.<ABCTraits>
		
		public var cpool : ABCCPool;
			
		public function ABCinfo():void
		{
			methods = null; metadata = null; instances = null; classes = null; scripts = null;
		};
		
		/**
		 * 'Release memory', remove all stored inforamtion  
		 * 
		 */
		public function dispose():void
		{
			var i:uint;
				for each ( var mth:ABCMethodInfo in methods )						
						if ( mth.body && mth.body.code ) mth.body.code.length = 0;
					mth.body.code = null;
				
				for each ( var inst:ABCInstance in instances ) 
				{
					inst.cref = null;
					inst.traits.splice(0,inst.traits.length);
					inst.init = null;	 
				};
				
				for each ( var cls:ABCClass in classes )
				{
					cls.iref = null;
					cls.sref = null;
					cls.init = null;
					cls.traits.splice(0,cls.traits.length);
				};
				
				for each ( var str:ABCTraits in scripts )
				{
					str.init = null;
					str.traits.splice( 0, str.traits.length );
				};
				
			methods.splice(0,methods.length); methods = null;
			instances.splice(0,instances.length); instances = null;
			classes.splice(0,classes.length); classes = null;
			scripts.splice(0,scripts.length); scripts = null;
			metadata.splice(0,metadata.length); metadata = null;
		};
		
	}    
}