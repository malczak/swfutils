/*  ***** BEGIN LICENSE BLOCK *****
 * 
 * Version 1.1 (the "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 * 
 * http://www.mozilla.org/MPL/
 * 
 * Software distributed under the License is distributed on an return "AS ISreturn " basis, 
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

package com.segfaultlabs.swfutils.avm1 {

	/**
	 * This class is usefull when writing Action Script decompiler. It stores	 all
	 * opcodes used in AVM1. 
	 * 
	 * @author malczak
	 * @version 0.2
	 */
	 
	public class SWFActions 
	{		
		static public const ACT_ActionNextFrame:uint = 0x4;
		static public const ACT_ActionPreviousFrame:uint = 0x5;
		static public const ACT_ActionPlay:uint = 0x6;
		static public const ACT_ActionStop:uint = 0x7;
		static public const ACT_ActionToggleQuality:uint = 0x8;
		static public const ACT_ActionStopSound:uint = 0x9;
		static public const ACT_ActionAdd:uint = 0xa;
		static public const ACT_ActionSubstract:uint = 0xb;
		static public const ACT_ActionMultiply:uint = 0xc;
		static public const ACT_ActionDivide:uint = 0xd;
		static public const ACT_ActionEquals:uint = 0xe;
		static public const ACT_ActionLess:uint = 0xf;
		static public const ACT_ActionAnd:uint = 0x10;
		static public const ACT_ActionOr:uint = 0x11;
		static public const ACT_ActionNot:uint = 0x12;
		static public const ACT_ActionStringEquals:uint = 0x13;
		static public const ACT_ActionStringLength:uint = 0x14;
		static public const ACT_ActionStringExtract:uint = 0x15;
		static public const ACT_ActionPop:uint = 0x17;
		static public const ACT_ActionToInteger:uint = 0x18;
		static public const ACT_ActionGetVariable:uint = 0x1c;
		static public const ACT_ActionSetVariable:uint = 0x1d;
		static public const ACT_ActionSetTarget2:uint = 0x20;
		static public const ACT_ActionStringAdd:uint = 0x21;
		static public const ACT_ActionGetProperty:uint = 0x22;
		static public const ACT_ActionSetProperty:uint = 0x23;
		static public const ACT_ActionCloneSprite:uint = 0x24;
		static public const ACT_ActionRemoveSprite:uint = 0x25;
		static public const ACT_ActionTrace:uint = 0x26;
		static public const ACT_ActionStartDrag:uint = 0x27;
		static public const ACT_ActionEndDrag:uint = 0x28;
		static public const ACT_ActionStringLess:uint = 0x29;
		static public const ACT_ActionThrow:uint = 0x2a;
		static public const ACT_ActionCastOp:uint = 0x2b;
		static public const ACT_ActionImplementsOp:uint = 0x2c;
		static public const ACT_ActionRandomNunber:uint = 0x30;
		static public const ACT_ActionMBStringLength:uint = 0x31;
		static public const ACT_ActionCharToAscii:uint = 0x32;
		static public const ACT_ActionAsciiToChar:uint = 0x33;
		static public const ACT_ActionGetTime:uint = 0x34;
		static public const ACT_ActionMBStringExtract:uint = 0x35;
		static public const ACT_ActionMBCharToAsci:uint = 0x36;
		static public const ACT_ActionMBAsciiToChar:uint = 0x37;
		static public const ACT_ActionDelete:uint = 0x3a;
		static public const ACT_ActionDelete2:uint = 0x3b;
		static public const ACT_ActionDefineLocal:uint = 0x3c;
		static public const ACT_ActionCallFunction:uint = 0x3d;
		static public const ACT_ActionReturn:uint = 0x3e;
		static public const ACT_ActionModulo:uint = 0x3f;
		static public const ACT_ActionNewObject:uint = 0x40;
		static public const ACT_ActionDefineLocal2:uint = 0x41;
		static public const ACT_ActionInitArray:uint = 0x42;
		static public const ACT_ActionInitObject:uint = 0x43;
		static public const ACT_ActionTypeOf:uint = 0x44;
		static public const ACT_ActionTargetPath:uint = 0x45;
		static public const ACT_ActionEnumerate:uint = 0x46;
		static public const ACT_ActionAdd2:uint = 0x47;
		static public const ACT_ActionLess2:uint = 0x48;
		static public const ACT_ActionEquals2:uint = 0x49;
		static public const ACT_ActionToNumber:uint = 0x4a;
		static public const ACT_ActionToString:uint = 0x4b;
		static public const ACT_ActionPushDuplicate:uint = 0x4c;
		static public const ACT_ActionStackSwap:uint = 0x4d;
		static public const ACT_ActionGetMember:uint = 0x4e;
		static public const ACT_ActionSetMember:uint = 0x4f;
		static public const ACT_ActionIncrement:uint = 0x50;
		static public const ACT_ActionDecrement:uint = 0x51;
		static public const ACT_ActionCallMethod:uint = 0x52;
		static public const ACT_ActionNewMethod:uint = 0x53;
		static public const ACT_ActionInstanceOf:uint = 0x54;
		static public const ACT_ActionEnumerate2:uint = 0x55;
		static public const ACT_ActionBitAnd:uint = 0x60;
		static public const ACT_ActionBitOr:uint = 0x61;
		static public const ACT_ActionBitXor:uint = 0x62;
		static public const ACT_ActionBitLShift:uint = 0x63;
		static public const ACT_ActionBitRShift:uint = 0x64;
		static public const ACT_ActionBitURShift:uint = 0x65;
		static public const ACT_ActionStrictEquals:uint = 0x66;
		static public const ACT_ActionGreater:uint = 0x67;
		static public const ACT_ActionStringGreater:uint = 0x68;
		static public const ACT_ActionExtends:uint = 0x69;
		static public const ACT_ActionGotoFrame:uint = 0x81;
		static public const ACT_ActionGetURL:uint = 0x83;
		static public const ACT_ActionStoreRegister:uint = 0x87;
		static public const ACT_ActionConstantPool:uint = 0x88;
		static public const ACT_ActionWaitForFrame:uint = 0x8a;
		static public const ACT_ActionSetTarget:uint = 0x8b;
		static public const ACT_ActionGotoLabel:uint = 0x8c;
		static public const ACT_ActionWaitForFrame2:uint = 0x8d;
		static public const ACT_ActionDefineFunction2:uint = 0x8e;
		static public const ACT_ActionTry:uint = 0x8f;
		static public const ACT_ActionWith:uint = 0x94;
		static public const ACT_ActionPush:uint = 0x96;
		static public const ACT_ActionJump:uint = 0x99;
		static public const ACT_ActionGetURL2:uint = 0x9a;
		static public const ACT_ActionDefineFunction:uint = 0x9b;
		static public const ACT_ActionIf:uint = 0x9d;
		static public const ACT_ActionCall:uint = 0x9e;
		static public const ACT_ActionGotoFrame2:uint = 0x9f;
		
		static public function actionName( act:uint ):String
		{
			switch( act )
			{
				case 0x4:
						 return "ActionNextFrame";
					break;
				case 0x5:
						 return "ActionPreviousFrame";
					break;
				case 0x6:
						 return "ActionPlay";
					break;
				case 0x7:
						 return "ActionStop";
					break;
				case 0x8:
						 return "ActionToggleQuality";
					break;
				case 0x9:
						 return "ActionStopSound";
					break;
				case 0xa:
						 return "ActionAdd";
					break;
				case 0xb:
						 return "ActionSubstract";
					break;
				case 0xc:
						 return "ActionMultiply";
					break;
				case 0xd:
						 return "ActionDivide";
					break;
				case 0xe:
						 return "ActionEquals";
					break;
				case 0xf:
						 return "ActionLess";
					break;
				case 0x10:
						 return "ActionAnd";
					break;
				case 0x11:
						 return "ActionOr";
					break;
				case 0x12:
						 return "ActionNot";
					break;
				case 0x13:
						 return "ActionStringEquals";
					break;
				case 0x14:
						 return "ActionStringLength";
					break;
				case 0x15:
						 return "ActionStringExtract";
					break;
				case 0x17:
						 return "ActionPop";
					break;
				case 0x18:
						 return "ActionToInteger";
					break;
				case 0x1c:
						 return "ActionGetVariable";
					break;
				case 0x1d:
						 return "ActionSetVariable";
					break;
				case 0x20:
						 return "ActionSetTarget2";
					break;
				case 0x21:
						 return "ActionStringAdd";
					break;
				case 0x22:
						 return "ActionGetProperty";
					break;
				case 0x23:
						 return "ActionSetProperty";
					break;
				case 0x24:
						 return "ActionCloneSprite";
					break;
				case 0x25:
						 return "ActionRemoveSprite";
					break;
				case 0x26:
						 return "ActionTrace";
					break;
				case 0x27:
						 return "ActionStartDrag";
					break;
				case 0x28:
						 return "ActionEndDrag";
					break;
				case 0x29:
						 return "ActionStringLess";
					break;
				case 0x2a:
						 return "ActionThrow";
					break;
				case 0x2b:
						 return "ActionCastOp";
					break;
				case 0x2c:
						 return "ActionImplementsOp";
					break;
				case 0x30:
						 return "ActionRandomNunber";
					break;
				case 0x31:
						 return "ActionMBStringLength";
					break;
				case 0x32:
						 return "ActionCharToAscii";
					break;
				case 0x33:
						 return "ActionAsciiToChar";
					break;
				case 0x34:
						 return "ActionGetTime";
					break;
				case 0x35:
						 return "ActionMBStringExtract";
					break;
				case 0x36:
						 return "ActionMBCharToAsci";
					break;
				case 0x37:
						 return "ActionMBAsciiToChar";
					break;
				case 0x3a:
						 return "ActionDelete";
					break;
				case 0x3b:
						 return "ActionDelete2";
					break;
				case 0x3c:
						 return "ActionDefineLocal";
					break;
				case 0x3d:
						 return "ActionCallFunction";
					break;
				case 0x3e:
						 return "ActionReturn";
					break;
				case 0x3f:
						 return "ActionModulo";
					break;
				case 0x40:
						 return "ActionNewObject";
					break;
				case 0x41:
						 return "ActionDefineLocal2";
					break;
				case 0x42:
						 return "ActionInitArray";
					break;
				case 0x43:
						 return "ActionInitObject";
					break;
				case 0x44:
						 return "ActionTypeOf";
					break;
				case 0x45:
						 return "ActionTargetPath";
					break;
				case 0x46:
						 return "ActionEnumerate";
					break;
				case 0x47:
						 return "ActionAdd2";
					break;
				case 0x48:
						 return "ActionLess2";
					break;
				case 0x49:
						 return "ActionEquals2";
					break;
				case 0x4a:
						 return "ActionToNumber";
					break;
				case 0x4b:
						 return "ActionToString";
					break;
				case 0x4c:
						 return "ActionPushDuplicate";
					break;
				case 0x4d:
						 return "ActionStackSwap";
					break;
				case 0x4e:
						 return "ActionGetMember";
					break;
				case 0x4f:
						 return "ActionSetMember";
					break;
				case 0x50:
						 return "ActionIncrement";
					break;
				case 0x51:
						 return "ActionDecrement";
					break;
				case 0x52:
						 return "ActionCallMethod";
					break;
				case 0x53:
						 return "ActionNewMethod";
					break;
				case 0x54:
						 return "ActionInstanceOf";
					break;
				case 0x55:
						 return "ActionEnumerate2";
					break;
				case 0x60:
						 return "ActionBitAnd";
					break;
				case 0x61:
						 return "ActionBitOr";
					break;
				case 0x62:
						 return "ActionBitXor";
					break;
				case 0x63:
						 return "ActionBitLShift";
					break;
				case 0x64:
						 return "ActionBitRShift";
					break;
				case 0x65:
						 return "ActionBitURShift";
					break;
				case 0x66:
						 return "ActionStrictEquals";
					break;
				case 0x67:
						 return "ActionGreater";
					break;
				case 0x68:
						 return "ActionStringGreater";
					break;
				case 0x69:
						 return "ActionExtends";
					break;
				/* ----------- actions with data ---- */
				case 0x81:
						 return "ActionGotoFrame";
					break;
				case 0x83:
						 return "ActionGetURL";
					break;
				case 0x87:
						 return "ActionStoreRegister";
					break;
				case 0x88:
						 return "ActionConstantPool";
					break;
				case 0x8a:
						 return "ActionWaitForFrame";
					break;
				case 0x8b:
						 return "ActionSetTarget";
					break;
				case 0x8c:
						 return "ActionGotoLabel";
					break;
				case 0x8d:
						 return "ActionWaitForFrame2";
					break;
				case 0x8e:
						 return "ActionDefineFunction2";
					break;
				case 0x8f:
						 return "ActionTry";
					break;
				case 0x94:
						 return "ActionWith";
					break;
				case 0x96:
						 return "ActionPush";
					break;
				case 0x99:
						 return "ActionJump";
					break;
				case 0x9a:
						 return "ActionGetURL2";
					break;
				case 0x9b:
						 return "ActionDefineFunction";
					break;
				case 0x9d:
						 return "ActionIf";
					break;
				case 0x9e:
						 return "ActionCall";
					break;
				case 0x9f:
						 return "ActionGotoFrame2";
					break;
			};
			return "unknown";
		};
		
	}	
	
}