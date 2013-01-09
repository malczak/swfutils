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
	import __AS3__.vec.Vector;
	
	import com.segfaultlabs.swfutils.LogWriter.ILogWriter;
	import com.segfaultlabs.swfutils.LogWriter.TraceWriter;
	import com.segfaultlabs.swfutils.SWFDataInput;
	import com.segfaultlabs.swfutils.swfutils;
		
	/**
	 * Class used to illustrate how code form doABC tag should be dumped. Code 
	 * based on <i>dumpabc.as</i> which is a part of a Tamarin project. This should (will)
	 * be developed to dump human readable code, not only 'assembly' notation.
	 * <br>
	 * This class defines all AVM2 opcodes used in byte code (possibly some fp10 opcodes
	 * are missing).  
	 * 
	 * @author malczak
	 * @version 0.1
	 */	
	final public class ABCcodedump {		
		
		static public const OP_bkpt:int = 0x01
		static public const OP_nop:int = 0x02
		static public const OP_throw:int = 0x03
		static public const OP_getsuper:int = 0x04
		static public const OP_setsuper:int = 0x05
		static public const OP_dxns:int = 0x06
		static public const OP_dxnslate:int = 0x07
		static public const OP_kill:int = 0x08
		static public const OP_label:int = 0x09
		static public const OP_ifnlt:int = 0x0C
		static public const OP_ifnle:int = 0x0D
		static public const OP_ifngt:int = 0x0E
		static public const OP_ifnge:int = 0x0F
		static public const OP_jump:int = 0x10
		static public const OP_iftrue:int = 0x11
		static public const OP_iffalse:int = 0x12
		static public const OP_ifeq:int = 0x13
		static public const OP_ifne:int = 0x14
		static public const OP_iflt:int = 0x15
		static public const OP_ifle:int = 0x16
		static public const OP_ifgt:int = 0x17
		static public const OP_ifge:int = 0x18
		static public const OP_ifstricteq:int = 0x19
		static public const OP_ifstrictne:int = 0x1A
		static public const OP_lookupswitch:int = 0x1B
		static public const OP_pushwith:int = 0x1C
		static public const OP_popscope:int = 0x1D
		static public const OP_nextname:int = 0x1E
		static public const OP_hasnext:int = 0x1F
		static public const OP_pushnull:int = 0x20
		static public const OP_pushundefined:int = 0x21
		static public const OP_pushconstant:int = 0x22
		static public const OP_nextvalue:int = 0x23
		static public const OP_pushbyte:int = 0x24
		static public const OP_pushshort:int = 0x25
		static public const OP_pushtrue:int = 0x26
		static public const OP_pushfalse:int = 0x27
		static public const OP_pushnan:int = 0x28
		static public const OP_pop:int = 0x29
		static public const OP_dup:int = 0x2A
		static public const OP_swap:int = 0x2B
		static public const OP_pushstring:int = 0x2C
		static public const OP_pushint:int = 0x2D
		static public const OP_pushuint:int = 0x2E
		static public const OP_pushdouble:int = 0x2F
		static public const OP_pushscope:int = 0x30
		static public const OP_pushnamespace:int = 0x31
		static public const OP_hasnext2:int = 0x32
		static public const OP_newfunction:int = 0x40
		static public const OP_call:int = 0x41
		static public const OP_construct:int = 0x42
		static public const OP_callmethod:int = 0x43
		static public const OP_callstatic:int = 0x44
		static public const OP_callsuper:int = 0x45
		static public const OP_callproperty:int = 0x46
		static public const OP_returnvoid:int = 0x47
		static public const OP_returnvalue:int = 0x48
		static public const OP_constructsuper:int = 0x49
		static public const OP_constructprop:int = 0x4A
		static public const OP_callsuperid:int = 0x4B
		static public const OP_callproplex:int = 0x4C
		static public const OP_callinterface:int = 0x4D
		static public const OP_callsupervoid:int = 0x4E
		static public const OP_callpropvoid:int = 0x4F
		static public const OP_newobject:int = 0x55
		static public const OP_newarray:int = 0x56
		static public const OP_newactivation:int = 0x57
		static public const OP_newclass:int = 0x58
		static public const OP_getdescendants:int = 0x59
		static public const OP_newcatch:int = 0x5A
		static public const OP_findpropstrict:int = 0x5D
		static public const OP_findproperty:int = 0x5E
		static public const OP_finddef:int = 0x5F
		static public const OP_getlex:int = 0x60
		static public const OP_setproperty:int = 0x61
		static public const OP_getlocal:int = 0x62
		static public const OP_setlocal:int = 0x63
		static public const OP_getglobalscope:int = 0x64
		static public const OP_getscopeobject:int = 0x65
		static public const OP_getproperty:int = 0x66
		static public const OP_getouterscope:int = 0x67
		static public const OP_initproperty:int = 0x68
		static public const OP_setpropertylate:int = 0x69
		static public const OP_deleteproperty:int = 0x6A
		static public const OP_deletepropertylate:int = 0x6B
		static public const OP_getslot:int = 0x6C
		static public const OP_setslot:int = 0x6D
		static public const OP_getglobalslot:int = 0x6E
		static public const OP_setglobalslot:int = 0x6F
		static public const OP_convert_s:int = 0x70
		static public const OP_esc_xelem:int = 0x71
		static public const OP_esc_xattr:int = 0x72
		static public const OP_convert_i:int = 0x73
		static public const OP_convert_u:int = 0x74
		static public const OP_convert_d:int = 0x75
		static public const OP_convert_b:int = 0x76
		static public const OP_convert_o:int = 0x77
		static public const OP_coerce:int = 0x80
		static public const OP_coerce_b:int = 0x81
		static public const OP_coerce_a:int = 0x82
		static public const OP_coerce_i:int = 0x83
		static public const OP_coerce_d:int = 0x84
		static public const OP_coerce_s:int = 0x85
		static public const OP_astype:int = 0x86
		static public const OP_astypelate:int = 0x87
		static public const OP_coerce_u:int = 0x88
		static public const OP_coerce_o:int = 0x89
		static public const OP_negate:int = 0x90
		static public const OP_increment:int = 0x91
		static public const OP_inclocal:int = 0x92
		static public const OP_decrement:int = 0x93
		static public const OP_declocal:int = 0x94
		static public const OP_typeof:int = 0x95
		static public const OP_not:int = 0x96
		static public const OP_bitnot:int = 0x97
		static public const OP_concat:int = 0x9A
		static public const OP_add_d:int = 0x9B
		static public const OP_add:int = 0xA0
		static public const OP_subtract:int = 0xA1
		static public const OP_multiply:int = 0xA2
		static public const OP_divide:int = 0xA3
		static public const OP_modulo:int = 0xA4
		static public const OP_lshift:int = 0xA5
		static public const OP_rshift:int = 0xA6
		static public const OP_urshift:int = 0xA7
		static public const OP_bitand:int = 0xA8
		static public const OP_bitor:int = 0xA9
		static public const OP_bitxor:int = 0xAA
		static public const OP_equals:int = 0xAB
		static public const OP_strictequals:int = 0xAC
		static public const OP_lessthan:int = 0xAD
		static public const OP_lessequals:int = 0xAE
		static public const OP_greaterthan:int = 0xAF
		static public const OP_greaterequals:int = 0xB0
		static public const OP_instanceof:int = 0xB1
		static public const OP_istype:int = 0xB2
		static public const OP_istypelate:int = 0xB3
		static public const OP_in:int = 0xB4
		static public const OP_increment_i:int = 0xC0
		static public const OP_decrement_i:int = 0xC1
		static public const OP_inclocal_i:int = 0xC2
		static public const OP_declocal_i:int = 0xC3
		static public const OP_negate_i:int = 0xC4
		static public const OP_add_i:int = 0xC5
		static public const OP_subtract_i:int = 0xC6
		static public const OP_multiply_i:int = 0xC7
		static public const OP_getlocal0:int = 0xD0
		static public const OP_getlocal1:int = 0xD1
		static public const OP_getlocal2:int = 0xD2
		static public const OP_getlocal3:int = 0xD3
		static public const OP_setlocal0:int = 0xD4
		static public const OP_setlocal1:int = 0xD5
		static public const OP_setlocal2:int = 0xD6
		static public const OP_setlocal3:int = 0xD7
		static public const OP_debug:int = 0xEF
		static public const OP_debugline:int = 0xF0
		static public const OP_debugfile:int = 0xF1
		static public const OP_bkptline:int = 0xF2
		
		/**
		 * Names of all opcodes taht can be used inside a doABC bytecode block 
		 */
		protected var opNames:Array;
		
		public function ABCcodedump():void
		{
			super();
			
			opNames = [
				"OP_0x00       ",
				"bkpt          ",
				"nop           ",
				"throw         ",
				"getsuper      ",
				"setsuper      ",
				"dxns          ",
				"dxnslate      ",
				"kill          ",
				"label         ",
				"OP_0x0A       ",
				"OP_0x0B       ",
				"ifnlt         ",
				"ifnle         ",
				"ifngt         ",
				"ifnge         ",
				"jump          ",
				"iftrue        ",
				"iffalse       ",
				"ifeq          ",
				"ifne          ",
				"iflt          ",
				"ifle          ",
				"ifgt          ",
				"ifge          ",
				"ifstricteq    ",
				"ifstrictne    ",
				"lookupswitch  ",
				"pushwith      ",
				"popscope      ",
				"nextname      ",
				"hasnext       ",
				"pushnull      ",
				"pushundefined ",
				"pushconstant  ",
				"nextvalue     ",
				"pushbyte      ",
				"pushshort     ",
				"pushtrue      ",
				"pushfalse     ",
				"pushnan       ",
				"pop           ",
				"dup           ",
				"swap          ",
				"pushstring    ",
				"pushint       ",
				"pushuint      ",
				"pushdouble    ",
				"pushscope     ",
				"pushnamespace ",
				"hasnext2      ",
				"OP_0x33       ",
				"OP_0x34       ",
				"OP_0x35       ",
				"OP_0x36       ",
				"OP_0x37       ",
				"OP_0x38       ",
				"OP_0x39       ",
				"OP_0x3A       ",
				"OP_0x3B       ",
				"OP_0x3C       ",
				"OP_0x3D       ",
				"OP_0x3E       ",
				"OP_0x3F       ",
				"newfunction   ",
				"call          ",
				"construct     ",
				"callmethod    ",
				"callstatic    ",
				"callsuper     ",
				"callproperty  ",
				"returnvoid    ",
				"returnvalue   ",
				"constructsuper",
				"constructprop ",
				"callsuperid   ",
				"callproplex   ",
				"callinterface ",
				"callsupervoid ",
				"callpropvoid  ",
				"OP_0x50       ",
				"OP_0x51       ",
				"OP_0x52       ",
				"OP_0x53       ",
				"OP_0x54       ",
				"newobject     ",
				"newarray      ",
				"newactivation ",
				"newclass      ",
				"getdescendants",
				"newcatch      ",
				"OP_0x5B       ",
				"OP_0x5C       ",
				"findpropstrict",
				"findproperty  ",
				"finddef       ",
				"getlex        ",
				"setproperty   ",
				"getlocal      ",
				"setlocal      ",
				"getglobalscope",
				"getscopeobject",
				"getproperty   ",
				"getouterscope ",
				"initproperty  ",
				"OP_0x69       ",
				"deleteproperty",
				"OP_0x6A       ",
				"getslot       ",
				"setslot       ",
				"getglobalslot ",
				"setglobalslot ",
				"convert_s     ",
				"esc_xelem     ",
				"esc_xattr     ",
				"convert_i     ",
				"convert_u     ",
				"convert_d     ",
				"convert_b     ",
				"convert_o     ",
				"checkfilter   ",
				"OP_0x79       ",
				"OP_0x7A       ",
				"OP_0x7B       ",
				"OP_0x7C       ",
				"OP_0x7D       ",
				"OP_0x7E       ",
				"OP_0x7F       ",
				"coerce        ",
				"coerce_b      ",
				"coerce_a      ",
				"coerce_i      ",
				"coerce_d      ",
				"coerce_s      ",
				"astype        ",
				"astypelate    ",
				"coerce_u      ",
				"coerce_o      ",
				"OP_0x8A       ",
				"OP_0x8B       ",
				"OP_0x8C       ",
				"OP_0x8D       ",
				"OP_0x8E       ",
				"OP_0x8F       ",
				"negate        ",
				"increment     ",
				"inclocal      ",
				"decrement     ",
				"declocal      ",
				"typeof        ",
				"not           ",
				"bitnot        ",
				"OP_0x98       ",
				"OP_0x99       ",
				"concat        ",
				"add_d         ",
				"OP_0x9C       ",
				"OP_0x9D       ",
				"OP_0x9E       ",
				"OP_0x9F       ",
				"add           ",
				"subtract      ",
				"multiply      ",
				"divide        ",
				"modulo        ",
				"lshift        ",
				"rshift        ",
				"urshift       ",
				"bitand        ",
				"bitor         ",
				"bitxor        ",
				"equals        ",
				"strictequals  ",
				"lessthan      ",
				"lessequals    ",
				"greaterthan   ",
				"greaterequals ",
				"instanceof    ",
				"istype        ",
				"istypelate    ",
				"in            ",
				"OP_0xB5       ",
				"OP_0xB6       ",
				"OP_0xB7       ",
				"OP_0xB8       ",
				"OP_0xB9       ",
				"OP_0xBA       ",
				"OP_0xBB       ",
				"OP_0xBC       ",
				"OP_0xBD       ",
				"OP_0xBE       ",
				"OP_0xBF       ",
				"increment_i   ",
				"decrement_i   ",
				"inclocal_i    ",
				"declocal_i    ",
				"negate_i      ",
				"add_i         ",
				"subtract_i    ",
				"multiply_i    ",
				"OP_0xC8       ",
				"OP_0xC9       ",
				"OP_0xCA       ",
				"OP_0xCB       ",
				"OP_0xCC       ",
				"OP_0xCD       ",
				"OP_0xCE       ",
				"OP_0xCF       ",
				"getlocal0     ",
				"getlocal1     ",
				"getlocal2     ",
				"getlocal3     ",
				"setlocal0     ",
				"setlocal1     ",
				"setlocal2     ",
				"setlocal3     ",
				"OP_0xD8       ",
				"OP_0xD9       ",
				"OP_0xDA       ",
				"OP_0xDB       ",
				"OP_0xDC       ",
				"OP_0xDD       ",
				"OP_0xDE       ",
				"OP_0xDF       ",
				"OP_0xE0       ",
				"OP_0xE1       ",
				"OP_0xE2       ",
				"OP_0xE3       ",
				"OP_0xE4       ",
				"OP_0xE5       ",
				"OP_0xE6       ",
				"OP_0xE7       ",
				"OP_0xE8       ",
				"OP_0xE9       ",
				"OP_0xEA       ",
				"OP_0xEB       ",
				"OP_0xEC       ",
				"OP_0xED       ",
				"OP_0xEE       ",
				"debug         ",
				"debugline     ",
				"debugfile     ",
				"bkptline      ",
				"timestamp     ",
				"OP_0xF4       ",
				"verifypass    ",
				"alloc         ",
				"mark          ",
				"wb            ",
				"prologue      ",
				"sendenter     ",
				"doubletoatom  ",
				"sweep         ",
				"codegenop     ",
				"verifyop      ",
				"decode        "
			];
		};
		
		/**
		 * Method dump code for a single method, from doABC tag described by ABCinfo object.
		 *  
		 * @param abcinfo - valid ABCinfo object
		 * @param method - method which code should be dumped using _logWriter
		 * @param _logWriter - aka. trace
		 * @param indent - single line leading indent
		 * 
		 */
		public function dumpMethodCode( abcinfo:ABCinfo, method:ABCMethodInfo, _logWriter:ILogWriter, indent:String = ""  ):void
		{
				if ( method.body == null )
				{
					_logWriter.print( indent + " code not available for '" + method.name + "'" );
					return ;
				};
				
			var reader:SWFDataInput = new SWFDataInput(method.body.code);
			
			if (reader.swfutils::_dataInput)
			{
				/*L*/_logWriter.print(indent+"{")
				var oldindent:String = indent
				indent += " ";
				/*
				if (flags & ABCConsts.NEED_ACTIVATION) {
					abcinfo.logWriter.print(indent+"activation {")
					activation.dump(ABCinfo, indent+ABCConsts.TAB, "")
					abcinfo.logWriter.print(indent+"}")
				}
				*/
				
				/*L*/_logWriter.print(indent+"// local_count="+method.body.local_count+
					  " max_scope=" + method.body.max_scope +
					  " max_stack=" + method.body.max_stack +
					  " oplen=" + reader.dataInstance.length) 
				reader.dataInstance.position = 0
				var labels:ABCLabelInfo = new ABCLabelInfo()
				while (reader.swfutils::_dataInput.bytesAvailable > 0)
				{
					var start:int = reader.dataInstance.position
					var s:String = indent + start
					while (s.length < 12) s += ' ';
					var opcode:int = reader.swfutils::_dataInput.readUnsignedByte()

					if (opcode == OP_label || ((reader.dataInstance.position-1) in labels)) {
						/*L*/_logWriter.print(indent)
						/*L*/_logWriter.print(indent + labels.labelFor(reader.dataInstance.position-1) + ": ")
					}

					s += opNames[opcode]
					s += opNames[opcode].length < 8 ? "\t\t" : "\t"
						
					switch(opcode)
					{
						case OP_debugfile:
						case OP_pushstring:
							s += '"' + abcinfo.cpool.strings[reader.readEU32()].replace(/\n/g,"\\n").replace(/\t/g,"\\t") + '"'
							break
						case OP_pushnamespace:
							s += abcinfo.cpool.namespaces[reader.readEU32()]
							break
						case OP_pushint:
							var i:int = abcinfo.cpool.ints[reader.readEU32()]
							s += i + "\t// 0x" + i.toString(16)
							break
						case OP_pushuint:
							var u:uint = abcinfo.cpool.uints[reader.readEU32()]
							s += u + "\t// 0x" + u.toString(16)
							break;
						case OP_pushdouble:
							s += abcinfo.cpool.doubles[reader.readEU32()]
							break;
						case OP_getsuper: 
						case OP_setsuper: 
						case OP_getproperty: 
						case OP_initproperty: 
						case OP_setproperty: 
						case OP_getlex: 
						case OP_findpropstrict: 
						case OP_findproperty:
						case OP_finddef:
						case OP_deleteproperty: 
						case OP_istype: 
						case OP_coerce: 
						case OP_astype: 
						case OP_getdescendants:
							s += abcinfo.cpool.names[reader.readEU32()]
							break;
						case OP_constructprop:
						case OP_callproperty:
						case OP_callproplex:
						case OP_callsuper:
						case OP_callsupervoid:
						case OP_callpropvoid:
							s += abcinfo.cpool.names[reader.readEU32()]
							s += " (" + reader.readEU32() + ")"
							break;
						case OP_newfunction: //annonimous function, dump it in-place
							var method_id:int = reader.readEU32()
							s += abcinfo.methods[ method_id ].name;
							abcinfo.methods[method_id].annonimous = true;
							abcinfo.methods[method_id].kind = ABCConsts.TRAIT_Function;
							/*L*/_logWriter.print(s)
							dumpMethodCode( abcinfo, abcinfo.methods[ method_id ], _logWriter, indent + "    ");  
							//break;							
							continue;
						case OP_callstatic:
							s += abcinfo.methods[reader.readEU32()].name
							s += " (" + reader.readEU32() + ")"
							break;
						case OP_newclass: 
							s += (abcinfo.instances[ reader.readEU32() ] as ABCInstance).name;
							break;
						case OP_lookupswitch:
							var pos:int = reader.dataInstance.position-1;
							var target:int = pos + reader.readS24()
							var maxindex:int = reader.readEU32()
							s += "default:" + labels.labelFor(target) // target + "("+(target-pos)+")"
							s += " maxcase:" + maxindex
							for (i=0; i <= maxindex; i++) {
								target = pos + reader.readS24();
								s += " " + labels.labelFor(target) // target + "("+(target-pos)+")"
							}
							break;
						case OP_jump:
						case OP_iftrue:		case OP_iffalse:
						case OP_ifeq:		case OP_ifne:
						case OP_ifge:		case OP_ifnge:
						case OP_ifgt:		case OP_ifngt:
						case OP_ifle:		case OP_ifnle:
						case OP_iflt:		case OP_ifnlt:
						case OP_ifstricteq:	case OP_ifstrictne:
							var offset:int = reader.readS24()
							target = reader.dataInstance.position + offset;
							//s += target + " ("+offset+")"
							s += labels.labelFor(target)
							if (!((reader.dataInstance.position) in labels))
								s += "\n"
							break;
						case OP_inclocal:
						case OP_declocal:
						case OP_inclocal_i:
						case OP_declocal_i:
						case OP_getlocal:
						case OP_kill:
						case OP_setlocal:
						case OP_debugline:
						case OP_getglobalslot:
						case OP_getslot:
						case OP_setglobalslot:
						case OP_setslot:
						case OP_pushshort:
						case OP_newcatch:
							s += reader.readEU32()
							break
						case OP_debug:
							s += reader.swfutils::_dataInput.readUnsignedByte() 
							s += " " + reader.readEU32()
							s += " " + reader.swfutils::_dataInput.readUnsignedByte()
							s += " " + reader.readEU32()
							break;
						case OP_newobject:
							s += "{" + reader.readEU32() + "}"
							break;
						case OP_newarray:
							s += "[" + reader.readEU32() + "]"
							break;
						case OP_call:
						case OP_construct:
						case OP_constructsuper:
							s += "(" + reader.readEU32() + ")"
							break;
						case OP_pushbyte:
						case OP_getscopeobject:
							s += reader.swfutils::_dataInput.readByte()
							break;
						case OP_hasnext2:
							s += reader.readEU32() + " " + reader.readEU32()
						default:
							/*if (opNames[opreader.swfutils::_dataInput] == ("0x"+opreader.swfutils::_dataInput.toString(16).toUpperCase()))
								s += " UNKNOWN OPreader.swfutils::_dataInput"*/
							break
					}
					var size:int = reader.dataInstance.position - start
//					totalSize += size
					ABCConsts.opSizes[opcode] = int(ABCConsts.opSizes[opcode]) + size
					/*L*/_logWriter.print(s)
				}
				/*L*/_logWriter.print(oldindent+"}\n")
			}						
			
		};		
		
		/**
		 * Method dump information about traits for specified object (script, class, method body)  
		 * @param abcinfo - valid ABCinfo object
		 * @param tr - object which traits should be dumped using _logWriter 
		 * @param _logWriter - aka. trace
		 * @param indent - single line leading indent
		 * 
		 */		
		public function traitsInfo( abcinfo:ABCinfo, tr:ABCTraitsInfo, _logWriter:ILogWriter, indent:String="" ):void
		{
				if (tr.metadata) 
				{
					_logWriter.print( indent + "/- metadata" );
						for each (var md:* in tr.metadata)
							_logWriter.print(indent + md);
					_logWriter.print( indent + "\- metadata");
				}			

			switch( tr.kind & 0x0F )			
			{
				case ABCConsts.TRAIT_Class:
						_logWriter.print( indent + "class " + tr.name );
					break;
				case ABCConsts.TRAIT_Const:
				case ABCConsts.TRAIT_Slot:
					var trcs:ABCTraitConstSlot = tr as ABCTraitConstSlot;
						_logWriter.print(  indent + ABCConsts.traitKinds[trcs.kind] + " " + trcs.name + ":" + trcs.type + 
								(trcs.value !== undefined ? (" = " + (trcs.value is String ? ('"'+trcs.value+'"') : trcs.value)) : "") + 
								"\t/* slot_id " + trcs.id + " */" );
					break;				
				case ABCConsts.TRAIT_Function:				
				case ABCConsts.TRAIT_Method:
				case ABCConsts.TRAIT_Getter:
				case ABCConsts.TRAIT_Setter:
					var trm:ABCMethodInfo = tr as ABCMethodInfo;
						_logWriter.print( indent + ((trm.flags & ABCConsts.NATIVE)?"native ":"") + ABCConsts.traitKinds[trm.kind & 0x0F] + " " + trm.name + "(" + trm.paramTypes + "):" + trm.returnType + "\t/* disp_id " + trm.id + "*/" );
						dumpMethodCode( abcinfo, trm, _logWriter, indent );
					break;
			}
			_logWriter.print( " " );
		};
		
		/**
		 * Method is used to dump all inforamtion stored in a valid ABCinfo object. 
		 * 
		 * @param abcinfo - valid ABCinfo object
		 * @param _logWriter - aka. trace
		 * @param indent - signle line leading indent
		 * 
		 */		
		public function dumpABC( abcinfo:ABCinfo, _logWriter:ILogWriter=null,  indent:String=""):void
		{
				if ( !_logWriter ) _logWriter = new TraceWriter();
			var line:String;
			var t:ABCTraits;
			var c:ABCClass;
			var tr:ABCTraitsInfo;
			var traits:Vector.<ABCTraitsInfo>;
			var idx:uint;
			/*L*/_logWriter.print("+--------- METADATA --");
//			for each ( var n:Namespace in abcinfo.namespaces )
			for each ( var n:String in abcinfo.cpool.namespaces )
				/*L*/_logWriter.print(indent + n +" :: ");
				
			/*L*/_logWriter.print("+--------- SCRIPTS --");
			/* dump package initialization code (scripts), including registering user classes and any package internal data */
			idx = 0;
			for each ( t in abcinfo.scripts)
			{				
				/*L*/_logWriter.print(indent + "script" + (idx++) + " {");
						for each ( tr in t.traits )
							traitsInfo( abcinfo, tr, _logWriter );
					traitsInfo( abcinfo, t.init, _logWriter );
				/*L*/_logWriter.print(indent + "}");				
			};
			
			/*L*/_logWriter.print("+--------- CLASS INITIALIZATION, CLASS STATIC DATA --");
			/* dump class initialization code, and classes static variables */
			for each ( c in abcinfo.classes)
			{				
				/*L*/_logWriter.print(indent + "class " + c.name +" {");
				/*L*/_logWriter.print(indent + "traits count: "+ c.traits.length );
				traits = c.traits;
						for each ( tr in traits )							
							traitsInfo( abcinfo, tr, _logWriter );
					traitsInfo( abcinfo, c.init, _logWriter );
				/*L*/_logWriter.print(indent + "}");				
			};

			/*L*/_logWriter.print("+--------- INSTANCES --");
			/* dump all classes (instances) with traits (methods, variables, consts) */
			for each (var inst:ABCInstance in abcinfo.instances)
			{							
				if (inst.flags & ABCConsts.CLASS_FLAG_interface)
					line = "interface"
				else {
					line  = "class";
					if ( !(inst.flags & ABCConsts.CLASS_FLAG_sealed) )
						line = "dynamic " + line;
					if ( inst.flags & ABCConsts.CLASS_FLAG_final )
						line = "final " + line;
						
				};
			
			line += " " + inst.name + " extends " + inst.base;
				
				if ( inst.interfaces )
				{
					line += " implements " + inst.interfaces[0];
						for ( var i:int = 1; i < inst.interfaces.length; i += 1)
						 line += ", " + inst.interfaces[i];
				};
			
				_logWriter.print( indent + line + " { " );
				 if ( (inst.flags & 0x08 ) ) _logWriter.print( indent + " /* protected namespace : "+ inst.protectedNs + "*/" );
				 
				if ( inst.init )
					traitsInfo( abcinfo, inst.init, _logWriter );				 
						else _logWriter.print("/* no constructor code*/");
				
						for each ( tr in inst.traits )
							traitsInfo( abcinfo, tr, _logWriter );				 
							
				/*L*/_logWriter.print(indent + "}");				
			};

			/*L*/_logWriter.print("+--------- ANNONIMOUS FUNCTIONS --");
			/* dump any anonimous function */			
			for each ( var meth:ABCMethodInfo in abcinfo.methods )
				if ( meth && meth.annonimous ) traitsInfo( abcinfo, meth, _logWriter );
			
			/*L*/_logWriter.print("+-----------");			
			/* podsumowanie */
			var done:Array = []
			for (;;)
			{
				var max:int = -1;
				var maxsize:int = 0;
				for (i=0; i < 256; i++)
				{
					if (ABCConsts.opSizes[i] > maxsize && !done[i])
					{
						max = i;
						maxsize = ABCConsts.opSizes[i];
					}
				}
				if (max == -1)
					break;
				done[max] = 1;
				/*L*/_logWriter.print(opNames[max]+"\t"+int(ABCConsts.opSizes[max]))
			}
		}
		
	}
	
};

dynamic internal class ABCLabelInfo
{
	public var count:int;
	public function labelFor (target:int):String
	{
		if (target in this)
			return this[target]
		return this[target] = "L" + (++count)
	}
}