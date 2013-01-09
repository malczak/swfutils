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
	
	import com.segfaultlabs.swfutils.ABC.ABCMethodInfo;
	import com.segfaultlabs.swfutils.ABC.ABCTraitsInfo;
	
	/**
	 * ABCTraits is representation of a single resource from Action Script, that can
	 * be build of a number of objects (trairs). Objects that can have
	 * traits are : script, class, instance, method_body.
	 * <br>
	 * For a single Action Script 3 object (defined by ABCClass and ABCInstance), traits
	 * are all valid properties, methods, setters and getters - including static ones.
	 * <br>
	 * Script object can also have class_trait trait type. This kind of trait defines a single
	 * Action Script 3 class.
	 * <br>
	 * For more information refere to : 'ActionScript Virtual Machine 2 (AVM2) Overview' 
	 *   
	 * @author malczak
	 * @version 0.2
	 */	
	public class ABCTraits implements IABCTraits
	{
		protected var _init   : ABCMethodInfo;
		
		protected var _traits  : Vector.<ABCTraitsInfo>;
				
		public function get init():ABCMethodInfo { return _init; };
		
		public function set init( value:ABCMethodInfo ):void { _init = value; };
		
		public function get traits():Vector.<ABCTraitsInfo>
		{
				if ( _traits==null ) _traits = new Vector.<ABCTraitsInfo>(); 
			return _traits; 
		};

		public function ABCTraits():void
		{
			_traits = null;
		};
		
	};
}