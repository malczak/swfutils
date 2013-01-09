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
	import com.segfaultlabs.swfutils.LogWriter.NullWriter;
	import com.segfaultlabs.swfutils.SWFDataInput;
	import com.segfaultlabs.swfutils.swfutils;
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * Code in this class is heavily based om code from Tamarin project. ABCParser class
	 * is used to parse a single doABC tag from SWF file. On exit we get obejcts representing
	 * Action Script code compiled into parsed doABC block.
	 *  
	 * @author malczak
	 * @version 0.2
	 */	
	public final class ABCParser
	{
		public var readMethodBytes : Boolean;
		public var readExceptions : Boolean;
		private var _inputData : SWFDataInput;
		
		public function ABCParser()
		{ 
			super();
			readMethodBytes = false;
			readExceptions = true;
		};
		
		/**
		 * Method for parsing doABC code block. All parse out data is stored in ABCInfo instance, and all constants used in
		 * block are stored in a ABCCPool object. Constant pool is common for all doABC blocks in file, this is why it is stored
		 * in seperate object.
		 * Function can also write out some debug information (if compiled with -define=sflabs::debug,true compilation flag)
		 * if log writer object is specified.
		 * 
		 * @param data - swf file reading stream
		 * @param abc - ABCinfo what will store all data from parsed doABC block
		 * @param cpool - ABCCPool, constant pool used in parsed file
		 * @param _logWriter - [optional] class to write logs
		 * 
		 */		
		public function parse( data:SWFDataInput, abc:ABCinfo, cpool:ABCCPool, _logWriter:ILogWriter = null):void
		{
		sflabs::debug{
				if ( !_logWriter ) _logWriter = new NullWriter();
		};
				
			abc.cpool = cpool;	
			this._inputData = data;			
			_inputData.endian = Endian.LITTLE_ENDIAN;
			/* flags */
			abc.minor = _inputData.readInt();
			/* this field is set in flex/air applications */
			abc.target = _inputData.readString();
			abc.minor = _inputData.readShort();
			abc.major = _inputData.readShort();
				if ( abc.minor!=16 && abc.major!=46  )
					throw new Error("not an ABCinfo file.  magic=" + ((abc.major<<16)|abc.minor).toString(16))
			
			var i:int, j:int, k:int, n:int;
			var start:int;

	/* cpool - begin */
		sflabs::debug{
			start = _inputData.dataInstance.position
		};
			// ints
			n = _inputData.readEU32();
				if ( cpool.ints==null )
					cpool.ints = Vector.<int>([0]);
			for (i=1; i < n; i++)
				cpool.ints.push( _inputData.readEU32() );
				
			// uints
			n = _inputData.readEU32();
				if ( cpool.uints==null )
					cpool.uints = Vector.<uint>([0]);
			for (i=1; i < n; i++)
				cpool.uints.push( uint(_inputData.readEU32()) );
				
			// doubles
			n = _inputData.readEU32();
				if ( cpool.doubles==null )
					cpool.doubles = Vector.<Number>([NaN]);
			for (i=1; i < n; i++)
				cpool.doubles.push( _inputData.swfutils::_dataInput.readDouble() );
	
		sflabs::debug{
			/*L*/_logWriter.print("Cpool numbers size "+(_inputData.dataInstance.position-start))
			start = _inputData.dataInstance.position
		};
			
			// strings
			n = _inputData.readEU32()
				if ( cpool.strings==null )
					cpool.strings = Vector.<String>([""]);
			for (i = 1; i < n; i++)
				cpool.strings.push( _inputData.swfutils::_dataInput.readUTFBytes(_inputData.readEU32()) );

		sflabs::debug{
			/*L*/_logWriter.print("Cpool strings count "+ n +" size "+(_inputData.dataInstance.position-start))
			start = _inputData.dataInstance.position
		};
		
			// namespaces
			n = _inputData.readEU32();
				if ( cpool.namespaces==null )
					cpool.namespaces = Vector.<String>(["*"]);
			for (i = 1; i < n; i++)			
			{
				k = _inputData.swfutils::_dataInput.readByte();
				j = _inputData.readEU32();
				switch ( k )
				{
					case ABCConsts.CONSTANT_Namespace: /* user ns */
					case ABCConsts.CONSTANT_ExplicitNamespace:							
									cpool.namespaces.push( cpool.strings[j] );
								break;
					
					case ABCConsts.CONSTANT_PackageNs:/* package public ns */
					case ABCConsts.CONSTANT_PackageInternalNs:/* internal ns */
									cpool.namespaces.push( cpool.strings[j] );
								break;
								
					case ABCConsts.CONSTANT_ProtectedNs:
					case ABCConsts.CONSTANT_StaticProtectedNs:
									cpool.namespaces.push( "protected" );
								break;
					case ABCConsts.CONSTANT_PrivateNs:
									cpool.namespaces.push( "private" );
								break;
					};
			};

		sflabs::debug{
			/*L*/_logWriter.print("Names : "+cpool.namespaces.join("\n\t") );
			/*L*/_logWriter.print("Cpool namespaces count "+ n +" size "+(_inputData.dataInstance.position-start))
			start = _inputData.dataInstance.position
		};
		
			// namespace sets
			n = _inputData.readEU32()
			var nssets:Vector.<Vector.<String>> = new Vector.<Vector.<String>>(n+1);
			nssets[0] = null;
			for (i=1; i < n; i++)
			{
				k = _inputData.readEU32()
				var nsset:Vector.<String> = new Vector.<String>(k,true);
					for (j = 0; j < k; j++)		
						nsset[j] = cpool.namespaces[_inputData.readEU32()]
				nssets[i] = nsset;
		sflabs::debug{
				/*L*/_logWriter.print( nsset.join(":") );
		};
			};

		sflabs::debug{
			/*L*/_logWriter.print("Cpool nssets count "+ n +" size "+(_inputData.dataInstance.position-start))
			start = _inputData.dataInstance.position
		};
		
			// multinames
			n = _inputData.readEU32();
				if ( cpool.names==null )
					cpool.names = [ new QName("", "*") ];
			for (i=1; i < n; i+=1)			
				switch ( k = _inputData.swfutils::_dataInput.readByte() )
				{
				case ABCConsts.CONSTANT_Qname:
				case ABCConsts.CONSTANT_QnameA:
						cpool.names.push( new QName( cpool.namespaces[_inputData.readEU32()], cpool.strings[_inputData.readEU32()]) );
					break;
				
				case ABCConsts.CONSTANT_RTQname:
				case ABCConsts.CONSTANT_RTQnameA:
						cpool.names.push( new QName( cpool.strings[_inputData.readEU32()]) );
					break;
				
				case ABCConsts.CONSTANT_RTQnameL:
				case ABCConsts.CONSTANT_RTQnameLA:
						cpool.names.push( null );
					break;
				
				case ABCConsts.CONSTANT_NameL:
				case ABCConsts.CONSTANT_NameLA:
						cpool.names.push( new QName(new Namespace(""), null) );
					break;
				
				case ABCConsts.CONSTANT_Multiname:
				case ABCConsts.CONSTANT_MultinameA:
						var name:String = cpool.strings[_inputData.readEU32()]
						cpool.names.push( new ABCMultiname(nssets[_inputData.readEU32()], name) );
					break;

				case ABCConsts.CONSTANT_MultinameL:
				case ABCConsts.CONSTANT_MultinameLA:
						cpool.names.push( new ABCMultiname(nssets[_inputData.readEU32()], null) );
					break;
					
				case ABCConsts.CONSTANT_TypeName: 
						/* TypeName, used since fp10. not documented, based on abcdump.as */
						var tn:ABCTypeName = new ABCTypeName( cpool.names[ _inputData.readEU32() ], new Vector.<String> );
						j = _inputData.readEU32();
							for ( ;j>0;j-=1)
								tn.types.push( cpool.names[ _inputData.readEU32() ] );
						 cpool.names.push( tn ); 
					break;
					
				default:
					throw new Error("invalid kind : "+k.toString(16) );
				};
				
			nssets.splice(0,nssets.length);
			nssets = null;
			
		sflabs::debug{
			/*L*/_logWriter.print("Cpool names count "+ n +" size "+(_inputData.dataInstance.position-start))
			start = _inputData.dataInstance.position
		};
		
	/* cpool - end */
	
			//parseMethodInfos(_logWriter)
	/* method infos - begin */			
		sflabs::debug{
			start = _inputData.dataInstance.position;
		};
		
			var m:ABCMethodInfo;
			n = _inputData.readEU32()
			abc.methods = new Vector.<ABCMethodInfo>();
			for ( i = 0; i < n; i+=1 )
			{
				m = new ABCMethodInfo();
				abc.methods.push( m );			
				var param_count:int = _inputData.readEU32();
				m.returnType = cpool.names[ _inputData.readEU32() ];
				m.paramTypes = []
					for ( j = 0; j < param_count; j++)
						m.paramTypes[j] = cpool.names[_inputData.readEU32()]
			
				m.name = cpool.strings[ _inputData.readEU32() ]; /* this is just a debug name */
				m.flags = _inputData.swfutils::_dataInput.readByte()
				if (m.flags & ABCConsts.HAS_OPTIONAL)
				{
					// has_optional
					var optional_count:int = _inputData.readEU32();
					m.optionalValues = []
					for( k = param_count-optional_count; k < param_count; ++k)
					{
						var index:int = _inputData.readEU32()    // optional value index
						var kind:int = _inputData.swfutils::_dataInput.readByte() // kind byte for each default value
						if (index == 0)
							m.optionalValues[k] = undefined;
								else m.optionalValues[k] = defaultValue( kind, index, cpool );
					};
				};
				
				if (m.flags & ABCConsts.HAS_ParamNames)
				{
					m.paramNames = [];
						for( k = 0; k < param_count; ++k)							
							m.paramNames.push( cpool.strings[ _inputData.readEU32() ] );
                };
			};
		
		sflabs::debug{
			/*L*/_logWriter.print("ABCMethodInfo count " + n + " size "+(_inputData.dataInstance.position-start))
	/* method infos - end */

	/* metadata info - begin */
			start = _inputData.dataInstance.position
		};
			n = _inputData.readEU32();
			abc.metadata = new Vector.<ABCMetaData>();
			var md:ABCMetaData;
			while ( n )
	        {
				// MetadataInfo
				md = new ABCMetaData();
				abc.metadata.push( md );
				md.name = cpool.strings[_inputData.readEU32()];
	            var values_count:int = _inputData.readEU32();
	            var metaname:Array = []
	            for( i = 0; i < values_count; ++i )
					metaname[i] = cpool.strings[_inputData.readEU32()] // name 
				for( i = 0; i < values_count; ++i )
					md[metaname[i]] = cpool.strings[_inputData.readEU32()] // value
				n-=1;
			};
		sflabs::debug{
			/*L*/_logWriter.print("MetadataInfo size "+(_inputData.dataInstance.position-start));
	/* metdaata info - end */
			
	/* parse information about classes/objects */
	
	//parseInstanceInfos(_logWriter); /* klasa jest zapisana po nazwnie tu napewno nie ma odniesien do class bo classes sa tutaj puste, functions/methods const, vars */
	/* instance info - begin */
			start = _inputData.dataInstance.position
		};
			n = _inputData.readEU32()
			abc.instances = new Vector.<ABCInstance>();
			var t:ABCInstance;
			while ( n )
	        {
	        	t = new ABCInstance();
	        	abc.instances.push( t );
	        	t.name = cpool.names[ _inputData.readEU32() ];
	        	t.base = cpool.names[ _inputData.readEU32() ];
	        	t.flags = _inputData.swfutils::_dataInput.readByte();		        	
					if (t.flags & 8)
						t.protectedNs = cpool.namespaces[_inputData.readEU32()];
				/* interfaces */	
	        	var interface_count:int = _inputData.readEU32();
					if ( interface_count )
					{
						t.interfaces = [];
							for ( j = 0; j < interface_count; j++)
								t.interfaces.push( cpool.names[ _inputData.readEU32() ] );
					};
				/* instance initializer */
				t.init = abc.methods[ _inputData.readEU32() ];
				t.init.name = t.name; /* constructor */
				t.init.kind = ABCConsts.TRAIT_Method;
				/* set of traits for instance */
	        	parseTraits( t, abc );
	        	n-=1;
	        }
	        
		sflabs::debug{	        
			/*L*/_logWriter.print("InstanceInfo size "+(_inputData.dataInstance.position-start));
	/* instance info - end */ 
			
	/* parse information about static class elements, and class initialization code */
	//parseClassInfos(_logWriter); /* klasa po nazwie, odniesienia do instances, nie ma classes bo w as3 classes cannot be nested :), can have functions, variables, consts, slots */
	/* class info - begin */
			start = _inputData.dataInstance.position
		};
			n = abc.instances.length
			var ct:ABCClass;
			abc.classes = new Vector.<ABCClass>();
			for ( i=0; i < n; i+=1 )
	        {
	        	ct = new ABCClass();
	        	abc.classes.push( ct );
				/* ith class_info i always connected with ith instance_info */
				ct.iref = abc.instances[i];
				ct.iref.cref = ct;
				/* static class initializer */
	        	ct.init = abc.methods[ _inputData.readEU32() ]
	        	/* class name */
				ct.kind = ABCConsts.TRAIT_Class; 
				ct.init.kind = ABCConsts.TRAIT_Method;
				/* class traits ~ static properties & methods */
	        	parseTraits(ct,abc);
			}			
		sflabs::debug{
			/*L*/_logWriter.print("ClassInfo size "+(_inputData.dataInstance.position-start));			
	/* class info - end */
			
	/* parse information about scripts, that is class initializations and package elements */			
	//parseScriptInfos(_logWriter) /* can have funcitons, variables, consts, slots, classes ! one script for every class :) internal and ONE public class */
	/* script info - begin */
	/* single as3 script, here only one public class */
			start = _inputData.dataInstance.position;
		};
			n = _inputData.readEU32()
			abc.scripts = new Vector.<ABCTraits>();
			var st:ABCTraits;
			for ( i = 0; i < n; i+=1 )
	        {
	        	st = new ABCTraits();
	        	abc.scripts.push( st );
				/* AS3 initial script */
	        	st.init = abc.methods[ _inputData.readEU32() ];
				st.init.name = "script"+i+"$init";
				st.init.kind = ABCConsts.TRAIT_Function;
				/* traits for script, public class definition and all internal data */
	        	parseTraits(st,abc);
	        	st.traits.forEach( function (item:ABCTraitsInfo, index:int, vector:Vector.<ABCTraitsInfo>):void 
	        					   {
	        					   		var c:ABCClass = item as ABCClass;
	        					   			if ( c ) c.sref = this; 
	        					   }, st ); 
	        						
	        }
		sflabs::debug{	        
			/*L*/_logWriter.print("ScriptInfo size : "+(_inputData.dataInstance.position-start)+", total scripts : "+n)
	/* script info - end */
			
	/* method bodies - begin */
			start = _inputData.dataInstance.position;
		};
			var mi:ABCMethodInfo;
			var ex:ABCExceptionInfo;
			n = _inputData.readEU32();
			var bytes : ByteArray = new ByteArray();
			/* annonimous functions has kind set to 0, which means function is a variable of type Function.
			 * code is assigned in runtime. this way package funcitons are dealed. 
			 **/
			for ( i=0; i < n; i+=1 )
	        {
	        	m = abc.methods[ _inputData.readEU32() ];
	        	m.annonimous = false;
				m.body = new ABCMethodBody();
				//m.body.name = m.name + "$Body";
				m.body.init = m;
				m.body.max_stack = _inputData.readEU32();
	        	m.body.local_count = _inputData.readEU32();
				m.body.init_scope =  _inputData.readEU32();
				m.body.max_scope =  _inputData.readEU32();
				m.body.code_length =  _inputData.readEU32()
				/*m.body.core_offset = _inputData.position;*/
				
				bytes.endian = Endian.LITTLE_ENDIAN;
				_inputData.swfutils::_dataInput.readBytes(bytes, 0, m.body.code_length);
					if ( readMethodBytes==true )
					{
						m.body.code = bytes;
						bytes = new ByteArray();
					} else bytes.length = 0;
					
	       		/* exception blocks */
				if ( (k = _inputData.readEU32())>0 )
				{
					m.body.exceptions = [];
					ex = new ABCExceptionInfo();
						for ( j = 0; j < k; j++)
						{
							ex.from = _inputData.readEU32()
							ex.to = _inputData.readEU32();
							ex.target = _inputData.readEU32()
							/**
							 *  we have indices to 'names' array not to 'strings' array as docu says 
							 *  usage
							 * 		 cpool.names[ ex.var_type ] : cpool.names[ ex.exc_type ] 
							 */
							ex.exc_type = _inputData.readEU32();
							ex.var_name = _inputData.readEU32();
							
								if ( readExceptions )
								{
									m.body.exceptions.push( ex );
									ex = new ABCExceptionInfo();
								};
						}
				};
	       		parseTraits( m.body, abc );
	        };
	    bytes.length = 0;
	    bytes = null;
	    
		sflabs::debug{	        
			/*L*/_logWriter.print("MethodBodies size "+(_inputData.dataInstance.position-start) )
		};

	/* method bodies - end */
	
		};

		/**
		 * Method is used to read all traits_info entries for specified object.
		 * Traits are defined for classes (static methods, static slots/consts), 
		 * for scripts (script public/private classes, script methods, script variables)
		 * and for instances (slots, consts, methods). 
		 * For more information refere to : "ActionScript Virtual Machine 2 (AVM2) Overview"
		 *  
		 * 
		 * @param t - objects for which traits should be read  
		 * @param abc - ABCinfo object
		 * 
		 */	
		private function parseTraits( t:IABCTraits, abc:ABCinfo ):void
		{
			var trait:ABCTraitsInfo;
			var namecount:int = _inputData.readEU32();
			var dummy:uint;
			var name:String;
			var kind:uint;
			var id:uint;
			var traits:Vector.<ABCTraitsInfo> = t.traits;
			
				for (var i:int=0; i < namecount; i++)
				{
					/* trait name ~ property name */
					name = abc.cpool.names[ _inputData.readEU32() ];
					/* trait kind */
					kind = _inputData.swfutils::_dataInput.readByte();
					/* meaning depands on trait kind */
					id = _inputData.readEU32(); 
						switch( kind & 0x0f ) 
						{
							/* primitive var & const properties */
							case ABCConsts.TRAIT_Slot:
							case ABCConsts.TRAIT_Const:
									var cs:ABCTraitConstSlot = new ABCTraitConstSlot();
									trait = cs as ABCTraitsInfo;
									cs.type = abc.cpool.names[ _inputData.readEU32() ];
									dummy = _inputData.readEU32();
										if ( dummy ) 
											//cs.value = defaults[ _inputData.swfutils::_dataInput.readByte() ][ dummy ];
											cs.value = defaultValue( _inputData.swfutils::_dataInput.readByte(), dummy, abc.cpool );
								break;
							/* class property this is only present for scripts ? */
							case ABCConsts.TRAIT_Class:
									trait = abc.classes[ _inputData.readEU32() ];
								break;
							/* methods */
							case ABCConsts.TRAIT_Function:
							case ABCConsts.TRAIT_Method:
							case ABCConsts.TRAIT_Getter:
							case ABCConsts.TRAIT_Setter:
									trait = abc.methods[ _inputData.readEU32() ];
								break;
						};
						
					trait.name = name;
					trait.kind = kind;
					trait.id = id;
						
					if ( (trait.kind >> 4) & ABCConsts.ATTR_metadata ) 
					{
						trait.metadata = []	
						dummy = _inputData.readEU32();
							for(var j:int=0; j < dummy; ++j)
								trait.metadata.push(  abc.metadata[_inputData.readEU32()] );
 					};
					
					traits.push( trait );
				};
		};
		
		/**
		 * For information refere to : "ActionScript Virtual Machine 2 (AVM2) Overview"
		 */
		protected function defaultValue( kind : uint, idx : uint, cpool : ABCCPool ):*
		{
			switch ( kind )
			{
				case ABCConsts.CONSTANT_Utf8:   return cpool.strings[idx];
				case ABCConsts.CONSTANT_UInt:
				case ABCConsts.CONSTANT_Int:    return cpool.ints[idx];
				case ABCConsts.CONSTANT_UInt:   return cpool.uints[idx];
				case ABCConsts.CONSTANT_Double: return cpool.doubles[idx];				
				
				case ABCConsts.CONSTANT_Namespace:
				case ABCConsts.CONSTANT_PrivateNs:
				case ABCConsts.CONSTANT_PackageNs:
				case ABCConsts.CONSTANT_PackageInternalNs:
				case ABCConsts.CONSTANT_ProtectedNs:
				case ABCConsts.CONSTANT_ExplicitNamespace:
				case ABCConsts.CONSTANT_StaticProtectedNs: 
												return cpool.namespaces[idx];
				
				case ABCConsts.CONSTANT_False:  return false;// { 10:false }
				case ABCConsts.CONSTANT_True:   return true;// { 11:true }
				case ABCConsts.CONSTANT_Null:   return null;//{ 12: null }
			};		
		}; 

	};
}