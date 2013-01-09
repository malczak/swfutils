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
 * The Original Code is [ swfutils ].
 * 
 * The Initial Developer of the Original Code is 
 * 	Mateusz Malczak ( http://segfaultlabs.com ).
 * Portions created by Initial Developer are Copyright (C) 2008
 * by Initial Developer. All Rights Reserved.
 * 
 * ***** END LICENSE BLOCK ***** */

package com.segfaultlabs.swfutils {
	
	/**
	* This is a single tag from SWF file. SWF files are build of a number of tags. Single tag
	* consists of type id and tag data.
	* <br>
	* For more information refere to : 'SWF File Format Specification Version 10'
	* [http://www.adobe.com/devnet/swf/pdf/swf_file_format_spec_v10.pdf]
	* @author Mateusz Malczak
	*/
	final public class SWFTag 
	{
		
		public var position : uint;
		public var size	    : uint;
		public var type     : uint;				
		
		/*
		 * 
		 * STATIC METODS
		 * 
		 */
		static public function tagName( tagType:uint ):String
		{
			switch( tagType )
			{
				case  0: return "End"; break;
				case  1: return "ShowFrame"; break;
				case  2: return "Shape";break;
				case  4: return "PlaceObject"; break;
				case  5: return "RemoveObject"; break;
				case  6: return "DefineBits"; break;
				case  7: return "DefineButton"; break;
				case  8: return "JPEGTables"; break;
				case  9: return "SetBackgroundColor"; break;
				case 10: return "DefineFont"; break;
				case 11: return "DefineText"; break;
				case 12: return "DoAction"; break;
				case 13: return "DefineFontInfo"; break;
				case 14: return "DefineSound"; break;
				case 15: return "StartSound"; break;
				case 17: return "DefineButtonSound"; break;
				case 18: return "SoundStreamHead"; break;
				case 19: return "SoundStreamBlock"; break;
				case 20: return "DefineBitsLossless"; break;
				case 21: return "DefineBitsJPEG2"; break;
				case 22: return "DefineShape2"; break;
				case 23: return "DefineButtonCxform"; break;
				case 24: return "Protect"; break;
				case 26: return "PlaceObject2"; break;
				case 28: return "RemnoveObject2"; break;
				case 32: return "DefineShape3"; break;
				case 33: return "DefineText2"; break;
				case 34: return "DefineButton2"; break;
				case 35: return "DefineBitsJPEG3"; break;
				case 36: return "DefineBitsLossless2"; break;
				case 37: return "DefineEditText"; break;
				case 39: return "DefineSprite"; break;
				case 43: return "FrameLabel"; break;
				case 45: return "SoundStreamHead2"; break;
				case 46: return "DefineMorphShape"; break;
				case 48: return "DefineFont2"; break;
				case 56: return "ExportAssets"; break;
				case 57: return "ImoprtAssets"; break;
				case 58: return "EnableDebugger"; break;
				case 59: return "DoInitAction"; break;
				case 60: return "DefineVideoStream"; break;
				case 61: return "VideoStream"; break;
				case 62: return "DefineFontInfo2"; break;
				case 64: return "EnableDebugger2"; break;
				case 65: return "ScriptLimits"; break;
				case 66: return "SetTabIndex"; break;
				case 69: return "FileAttributes"; break;
				case 70: return "PlaceObject3"; break;
				case 71: return "ImportAssets2"; break;
				case 73: return "DefineFontAlignZones"; break;
				case 74: return "CSMTextSettings"; break;
				case 75: return "DefineFont3"; break;
				case 76: return "SymbolClass"; break;
				case 77: return "Metadata"; break;
				case 78: return "DefineScalignGrid"; break;
				case 82: return "DoABC"; break;
				case 83: return "DefineShape4"; break;
				case 84: return "DefineMorphShape2"; break;
				case 86: return "DefineSceneAndFrameLabelData"; break;
				case 87: return "DefineBinaryData"; break;
				case 88: return "DefineFontName"; break;
				case 89: return "StartSound2"; break;
					default : return "Unknown";
			};
		};		
		
	}
	
}