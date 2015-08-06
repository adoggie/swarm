
// -- coding:utf-8 --
//---------------------------------
//  TCE
//  Tiny Communication Engine
//
//  sw2us.com copyright @2012
//  bin.zhang@sw2us.com / qq:24509826
//---------------------------------

	

function StringList_thlp(ds){
	//# -- SEQUENCE --
	
	this.ds = ds; // Array()
	
	this.getsize = function(){
		var size =4;
		for(var p=0;p<this.ds.length;p++){
			var _bx_1 =this.ds[p];
			var _sb_2 = utf16to8(_bx_1);
			size+= 4 + _sb_2.getBytes().length;
		}		
		return size;
	}	;	
	
	this.marshall = function(view,pos){
		view.setUint32(pos,this.ds.length);
		pos+=4;
		for(var n=0;n<this.ds.length;n++){
			var _sb_1 = utf16to8(this.ds[n]).getBytes();
			view.setInt32(pos,_sb_1.length);
			pos+=4;
			var _sb_2 = new Uint8Array(view.buffer);
			_sb_2.set(_sb_1,pos);
			pos += _sb_1.length;
		}		
		return pos;
	}	;	
	
	this.unmarshall = function(view,pos){
		var _size_1 = view.getUint32(pos);
		pos+=4;
		for(var _p=0;_p < _size_1;_p++){
			var _o = '';
			var _sb_3 = view.getUint32(pos);
			pos+=4;
			_o = view.buffer.slice(pos,pos+_sb_3);
			// this var is Uint8Array,should convert to String!!
			pos+= _sb_3;
			_o = String.fromCharCode.apply(null, _o.getBytes());
			_o = utf8to16(_o);
			this.ds.push(_o);
		}		
		return pos;
	}	;	
	
}



function IntList_thlp(ds){
	//# -- SEQUENCE --
	
	this.ds = ds; // Array()
	
	this.getsize = function(){
		var size =4;
		for(var p=0;p<this.ds.length;p++){
			var _bx_1 =this.ds[p];
			size+= 4;
		}		
		return size;
	}	;	
	
	this.marshall = function(view,pos){
		view.setUint32(pos,this.ds.length);
		pos+=4;
		for(var n=0;n<this.ds.length;n++){
			view.setInt32(pos,this.ds[n]);
			pos+=4;
		}		
		return pos;
	}	;	
	
	this.unmarshall = function(view,pos){
		var _size_1 = view.getUint32(pos);
		pos+=4;
		for(var _p=0;_p < _size_1;_p++){
			var _o = 0;
			_o = view.getInt32(pos);
			pos+=4;
			this.ds.push(_o);
		}		
		return pos;
	}	;	
	
}



function UserIdList_thlp(ds){
	//# -- SEQUENCE --
	
	this.ds = ds; // Array()
	
	this.getsize = function(){
		var size =4;
		for(var p=0;p<this.ds.length;p++){
			var _bx_1 =this.ds[p];
			var _sb_2 = utf16to8(_bx_1);
			size+= 4 + _sb_2.getBytes().length;
		}		
		return size;
	}	;	
	
	this.marshall = function(view,pos){
		view.setUint32(pos,this.ds.length);
		pos+=4;
		for(var n=0;n<this.ds.length;n++){
			var _sb_1 = utf16to8(this.ds[n]).getBytes();
			view.setInt32(pos,_sb_1.length);
			pos+=4;
			var _sb_2 = new Uint8Array(view.buffer);
			_sb_2.set(_sb_1,pos);
			pos += _sb_1.length;
		}		
		return pos;
	}	;	
	
	this.unmarshall = function(view,pos){
		var _size_1 = view.getUint32(pos);
		pos+=4;
		for(var _p=0;_p < _size_1;_p++){
			var _o = '';
			var _sb_3 = view.getUint32(pos);
			pos+=4;
			_o = view.buffer.slice(pos,pos+_sb_3);
			// this var is Uint8Array,should convert to String!!
			pos+= _sb_3;
			_o = String.fromCharCode.apply(null, _o.getBytes());
			_o = utf8to16(_o);
			this.ds.push(_o);
		}		
		return pos;
	}	;	
	
}



function SIDS_thlp(ds){
	//# -- SEQUENCE --
	
	this.ds = ds; // Array()
	
	this.getsize = function(){
		var size =4;
		for(var p=0;p<this.ds.length;p++){
			var _bx_1 =this.ds[p];
			var _sb_2 = utf16to8(_bx_1);
			size+= 4 + _sb_2.getBytes().length;
		}		
		return size;
	}	;	
	
	this.marshall = function(view,pos){
		view.setUint32(pos,this.ds.length);
		pos+=4;
		for(var n=0;n<this.ds.length;n++){
			var _sb_1 = utf16to8(this.ds[n]).getBytes();
			view.setInt32(pos,_sb_1.length);
			pos+=4;
			var _sb_2 = new Uint8Array(view.buffer);
			_sb_2.set(_sb_1,pos);
			pos += _sb_1.length;
		}		
		return pos;
	}	;	
	
	this.unmarshall = function(view,pos){
		var _size_1 = view.getUint32(pos);
		pos+=4;
		for(var _p=0;_p < _size_1;_p++){
			var _o = '';
			var _sb_3 = view.getUint32(pos);
			pos+=4;
			_o = view.buffer.slice(pos,pos+_sb_3);
			// this var is Uint8Array,should convert to String!!
			pos+= _sb_3;
			_o = String.fromCharCode.apply(null, _o.getBytes());
			_o = utf8to16(_o);
			this.ds.push(_o);
		}		
		return pos;
	}	;	
	
}



function StrStr_thlp(ds){
	//# -- THIS IS DICTIONARY! --
	this.ds = ds;
	
	
	this.getsize = function(){
		var size =4;
		for(var _k_5 in this.ds){
			var _v_6 = this.ds[_k_5];
			var _sb_7 = utf16to8(_k_5);
			size+= 4 + _sb_7.getBytes().length;
			var _sb_8 = utf16to8(_v_6);
			size+= 4 + _sb_8.getBytes().length;
		}		
		return size;
	}	;	
	
	this.marshall = function(view,pos){
		view.setUint32(pos,Object.keys(this.ds).length);
		pos+=4;
		for( var _k_1 in this.ds){
			var _v_2 = this.ds[_k_1];
			var _sb_3 = utf16to8(_k_1).getBytes();
			view.setInt32(pos,_sb_3.length);
			pos+=4;
			var _sb_4 = new Uint8Array(view.buffer);
			_sb_4.set(_sb_3,pos);
			pos += _sb_3.length;
			var _sb_5 = utf16to8(_v_2).getBytes();
			view.setInt32(pos,_sb_5.length);
			pos+=4;
			var _sb_6 = new Uint8Array(view.buffer);
			_sb_6.set(_sb_5,pos);
			pos += _sb_5.length;
		}		
		return pos;
	}	
	
	// unmarshall()
	this.unmarshall = function(view,pos){
		var _size_1 = 0;
		_size_1 = view.getInt32(pos);
		pos+=4;
		for(var _p=0;_p < _size_1;_p++){
			var _k_2 = '';
			var _sb_5 = view.getUint32(pos);
			pos+=4;
			_k_2 = view.buffer.slice(pos,pos+_sb_5);
			// this var is Uint8Array,should convert to String!!
			pos+= _sb_5;
			_k_2 = String.fromCharCode.apply(null, _k_2.getBytes());
			_k_2 = utf8to16(_k_2);
			var _v_3 = '';
			var _sb_8 = view.getUint32(pos);
			pos+=4;
			_v_3 = view.buffer.slice(pos,pos+_sb_8);
			// this var is Uint8Array,should convert to String!!
			pos+= _sb_8;
			_v_3 = String.fromCharCode.apply(null, _v_3.getBytes());
			_v_3 = utf8to16(_v_3);
			this.ds[_k_2]=_v_3;
		}		
		return pos;
	}	
}
//-- end Dictonary Class definations --



function StrStrList_thlp(ds){
	//# -- SEQUENCE --
	
	this.ds = ds; // Array()
	
	this.getsize = function(){
		var size =4;
		for(var p=0;p<this.ds.length;p++){
			var _bx_1 =this.ds[p];
			var _b_2 = new StrStr_thlp(_bx_1);
			size+=_bx_1.getsize();
		}		
		return size;
	}	;	
	
	this.marshall = function(view,pos){
		view.setUint32(pos,this.ds.length);
		pos+=4;
		for(var n=0;n<this.ds.length;n++){
			var _b_1 = new StrStr_thlp(this.ds[n]);
			pos = _b_1.marshall(view,pos);
		}		
		return pos;
	}	;	
	
	this.unmarshall = function(view,pos){
		var _size_1 = view.getUint32(pos);
		pos+=4;
		for(var _p=0;_p < _size_1;_p++){
			var _b_2 = {};
			var _b_3 = new StrStr_thlp(_b_2);
			pos=_b_3.unmarshall(view,pos);
			this.ds.push(_b_2);
		}		
		return pos;
	}	;	
	
}



function Properties_thlp(ds){
	//# -- THIS IS DICTIONARY! --
	this.ds = ds;
	
	
	this.getsize = function(){
		var size =4;
		for(var _k_4 in this.ds){
			var _v_5 = this.ds[_k_4];
			var _sb_6 = utf16to8(_k_4);
			size+= 4 + _sb_6.getBytes().length;
			var _sb_7 = utf16to8(_v_5);
			size+= 4 + _sb_7.getBytes().length;
		}		
		return size;
	}	;	
	
	this.marshall = function(view,pos){
		view.setUint32(pos,Object.keys(this.ds).length);
		pos+=4;
		for( var _k_1 in this.ds){
			var _v_2 = this.ds[_k_1];
			var _sb_3 = utf16to8(_k_1).getBytes();
			view.setInt32(pos,_sb_3.length);
			pos+=4;
			var _sb_4 = new Uint8Array(view.buffer);
			_sb_4.set(_sb_3,pos);
			pos += _sb_3.length;
			var _sb_5 = utf16to8(_v_2).getBytes();
			view.setInt32(pos,_sb_5.length);
			pos+=4;
			var _sb_6 = new Uint8Array(view.buffer);
			_sb_6.set(_sb_5,pos);
			pos += _sb_5.length;
		}		
		return pos;
	}	
	
	// unmarshall()
	this.unmarshall = function(view,pos){
		var _size_1 = 0;
		_size_1 = view.getInt32(pos);
		pos+=4;
		for(var _p=0;_p < _size_1;_p++){
			var _k_2 = '';
			var _sb_5 = view.getUint32(pos);
			pos+=4;
			_k_2 = view.buffer.slice(pos,pos+_sb_5);
			// this var is Uint8Array,should convert to String!!
			pos+= _sb_5;
			_k_2 = String.fromCharCode.apply(null, _k_2.getBytes());
			_k_2 = utf8to16(_k_2);
			var _v_3 = '';
			var _sb_8 = view.getUint32(pos);
			pos+=4;
			_v_3 = view.buffer.slice(pos,pos+_sb_8);
			// this var is Uint8Array,should convert to String!!
			pos+= _sb_8;
			_v_3 = String.fromCharCode.apply(null, _v_3.getBytes());
			_v_3 = utf8to16(_v_3);
			this.ds[_k_2]=_v_3;
		}		
		return pos;
	}	
}
//-- end Dictonary Class definations --









function ImageDataList_thlp(ds){
	//# -- SEQUENCE --
	
	this.ds = ds; // Array()
	
	this.getsize = function(){
		var size =4;
		for(var p=0;p<this.ds.length;p++){
			var _bx_1 =this.ds[p];
			size+= 4 + _bx_1.byteLength; 
		}		
		return size;
	}	;	
	
	this.marshall = function(view,pos){
		view.setUint32(pos,this.ds.length);
		pos+=4;
		for(var n=0;n<this.ds.length;n++){
			var _v_1 = new Uint8Array(view.buffer);
			view.setUint32(pos,this.ds[n].byteLength);
			pos += 4;
			var _v_2 = new Uint8Array(this.ds[n]); // ds[n] is ArrayBuffer
			_v_1.set(_v_2,pos);
			pos += _v_2.buffer.byteLength;
		}		
		return pos;
	}	;	
	
	this.unmarshall = function(view,pos){
		var _size_1 = view.getUint32(pos);
		pos+=4;
		for(var _p=0;_p < _size_1;_p++){
			var _len_3 = view.getUint32(pos);
			pos+=4;
			var _v_4 = new Uint8Array(view.buffer,pos,_len_3)
			this.ds.push( _v_4.buffer.slice(pos,pos+_len_3) );
			pos += _len_3;
		}		
		return pos;
	}	;	
	
}



function StreamDataArray_thlp(ds){
	//# -- SEQUENCE --
	
	this.ds = ds; // Array()
	
	this.getsize = function(){
		var size =4;
		for(var p=0;p<this.ds.length;p++){
			var _bx_1 =this.ds[p];
			size+= 4 + _bx_1.byteLength; 
		}		
		return size;
	}	;	
	
	this.marshall = function(view,pos){
		view.setUint32(pos,this.ds.length);
		pos+=4;
		for(var n=0;n<this.ds.length;n++){
			var _v_1 = new Uint8Array(view.buffer);
			view.setUint32(pos,this.ds[n].byteLength);
			pos += 4;
			var _v_2 = new Uint8Array(this.ds[n]); // ds[n] is ArrayBuffer
			_v_1.set(_v_2,pos);
			pos += _v_2.buffer.byteLength;
		}		
		return pos;
	}	;	
	
	this.unmarshall = function(view,pos){
		var _size_1 = view.getUint32(pos);
		pos+=4;
		for(var _p=0;_p < _size_1;_p++){
			var _len_3 = view.getUint32(pos);
			pos+=4;
			var _v_4 = new Uint8Array(view.buffer,pos,_len_3)
			this.ds.push( _v_4.buffer.slice(pos,pos+_len_3) );
			pos += _len_3;
		}		
		return pos;
	}	;	
	
}




function Error_t(){
// -- STRUCT -- 
	this.succ = false; 
	this.code = 0; 
	this.msg = ''; 
	
	this.getsize = function(){
		var size =0;
		size+= 1;
		size+= 4;
		var _sb_1 = utf16to8(this.msg);
		size+= 4 + _sb_1.getBytes().length;
		return size;
	}	;	
	
	// 
	this.marshall = function(view,pos){
		view.setUint8(pos,this.succ==true?1:0);
		pos+=1;
		view.setInt32(pos,this.code);
		pos+=4;
		var _sb_1 = utf16to8(this.msg).getBytes();
		view.setInt32(pos,_sb_1.length);
		pos+=4;
		var _sb_2 = new Uint8Array(view.buffer);
		_sb_2.set(_sb_1,pos);
		pos += _sb_1.length;
		return pos;
	}	;	
	
	this.unmarshall = function(view,pos){
		var _b_1 = view.getInt8(pos);
		this.succ = _b_1==0?false:true;
		pos+=1;
		this.code = view.getInt32(pos);
		pos+=4;
		var _sb_2 = view.getUint32(pos);
		pos+=4;
		this.msg = view.buffer.slice(pos,pos+_sb_2);
		// this var is Uint8Array,should convert to String!!
		pos+= _sb_2;
		this.msg = String.fromCharCode.apply(null, this.msg.getBytes());
		this.msg = utf8to16(this.msg);
		return pos;
	}	;	
	 // --  end function -- 
	
}




function CallReturn_t(){
// -- STRUCT -- 
	this.error = new Error_t(); 
	this.value = ''; 
	this.delta = ''; 
	
	this.getsize = function(){
		var size =0;
		size+=this.error.getsize();
		var _sb_1 = utf16to8(this.value);
		size+= 4 + _sb_1.getBytes().length;
		var _sb_2 = utf16to8(this.delta);
		size+= 4 + _sb_2.getBytes().length;
		return size;
	}	;	
	
	// 
	this.marshall = function(view,pos){
		pos= this.error.marshall(view,pos);
		var _sb_1 = utf16to8(this.value).getBytes();
		view.setInt32(pos,_sb_1.length);
		pos+=4;
		var _sb_2 = new Uint8Array(view.buffer);
		_sb_2.set(_sb_1,pos);
		pos += _sb_1.length;
		var _sb_3 = utf16to8(this.delta).getBytes();
		view.setInt32(pos,_sb_3.length);
		pos+=4;
		var _sb_4 = new Uint8Array(view.buffer);
		_sb_4.set(_sb_3,pos);
		pos += _sb_3.length;
		return pos;
	}	;	
	
	this.unmarshall = function(view,pos){
		pos = this.error.unmarshall(view,pos);
		var _sb_1 = view.getUint32(pos);
		pos+=4;
		this.value = view.buffer.slice(pos,pos+_sb_1);
		// this var is Uint8Array,should convert to String!!
		pos+= _sb_1;
		this.value = String.fromCharCode.apply(null, this.value.getBytes());
		this.value = utf8to16(this.value);
		var _sb_3 = view.getUint32(pos);
		pos+=4;
		this.delta = view.buffer.slice(pos,pos+_sb_3);
		// this var is Uint8Array,should convert to String!!
		pos+= _sb_3;
		this.delta = String.fromCharCode.apply(null, this.delta.getBytes());
		this.delta = utf8to16(this.delta);
		return pos;
	}	;	
	 // --  end function -- 
	
}




function TimeRange_t(){
// -- STRUCT -- 
	this.start = 0; 
	this.end = 0; 
	
	this.getsize = function(){
		var size =0;
		size+= 8;
		size+= 8;
		return size;
	}	;	
	
	// 
	this.marshall = function(view,pos){
		view.setFloat64(pos,this.start);
		pos+=8;
		view.setFloat64(pos,this.end);
		pos+=8;
		return pos;
	}	;	
	
	this.unmarshall = function(view,pos){
		this.start = view.getFloat64(pos);
		pos+=8;
		this.end = view.getFloat64(pos);
		pos+=8;
		return pos;
	}	;	
	 // --  end function -- 
	
}




function ResultPageCtrl_t(){
// -- STRUCT -- 
	this.page_size = 0; 
	this.page_index = 0; 
	
	this.getsize = function(){
		var size =0;
		size+= 4;
		size+= 4;
		return size;
	}	;	
	
	// 
	this.marshall = function(view,pos){
		view.setInt32(pos,this.page_size);
		pos+=4;
		view.setInt32(pos,this.page_index);
		pos+=4;
		return pos;
	}	;	
	
	this.unmarshall = function(view,pos){
		this.page_size = view.getInt32(pos);
		pos+=4;
		this.page_index = view.getInt32(pos);
		pos+=4;
		return pos;
	}	;	
	 // --  end function -- 
	
}




function AuthResult_t(){
// -- STRUCT -- 
	this.user_id = ''; 
	this.user_name = ''; 
	this.user_realname = ''; 
	this.login_time = 0; 
	this.login_type = 0; 
	this.expire_time = 0; 
	this.device_id = ''; 
	
	this.getsize = function(){
		var size =0;
		var _sb_1 = utf16to8(this.user_id);
		size+= 4 + _sb_1.getBytes().length;
		var _sb_2 = utf16to8(this.user_name);
		size+= 4 + _sb_2.getBytes().length;
		var _sb_3 = utf16to8(this.user_realname);
		size+= 4 + _sb_3.getBytes().length;
		size+= 8;
		size+= 4;
		size+= 8;
		var _sb_4 = utf16to8(this.device_id);
		size+= 4 + _sb_4.getBytes().length;
		return size;
	}	;	
	
	// 
	this.marshall = function(view,pos){
		var _sb_1 = utf16to8(this.user_id).getBytes();
		view.setInt32(pos,_sb_1.length);
		pos+=4;
		var _sb_2 = new Uint8Array(view.buffer);
		_sb_2.set(_sb_1,pos);
		pos += _sb_1.length;
		var _sb_3 = utf16to8(this.user_name).getBytes();
		view.setInt32(pos,_sb_3.length);
		pos+=4;
		var _sb_4 = new Uint8Array(view.buffer);
		_sb_4.set(_sb_3,pos);
		pos += _sb_3.length;
		var _sb_5 = utf16to8(this.user_realname).getBytes();
		view.setInt32(pos,_sb_5.length);
		pos+=4;
		var _sb_6 = new Uint8Array(view.buffer);
		_sb_6.set(_sb_5,pos);
		pos += _sb_5.length;
		view.setFloat64(pos,this.login_time);
		pos+=8;
		view.setInt32(pos,this.login_type);
		pos+=4;
		view.setFloat64(pos,this.expire_time);
		pos+=8;
		var _sb_7 = utf16to8(this.device_id).getBytes();
		view.setInt32(pos,_sb_7.length);
		pos+=4;
		var _sb_8 = new Uint8Array(view.buffer);
		_sb_8.set(_sb_7,pos);
		pos += _sb_7.length;
		return pos;
	}	;	
	
	this.unmarshall = function(view,pos){
		var _sb_1 = view.getUint32(pos);
		pos+=4;
		this.user_id = view.buffer.slice(pos,pos+_sb_1);
		// this var is Uint8Array,should convert to String!!
		pos+= _sb_1;
		this.user_id = String.fromCharCode.apply(null, this.user_id.getBytes());
		this.user_id = utf8to16(this.user_id);
		var _sb_3 = view.getUint32(pos);
		pos+=4;
		this.user_name = view.buffer.slice(pos,pos+_sb_3);
		// this var is Uint8Array,should convert to String!!
		pos+= _sb_3;
		this.user_name = String.fromCharCode.apply(null, this.user_name.getBytes());
		this.user_name = utf8to16(this.user_name);
		var _sb_5 = view.getUint32(pos);
		pos+=4;
		this.user_realname = view.buffer.slice(pos,pos+_sb_5);
		// this var is Uint8Array,should convert to String!!
		pos+= _sb_5;
		this.user_realname = String.fromCharCode.apply(null, this.user_realname.getBytes());
		this.user_realname = utf8to16(this.user_realname);
		this.login_time = view.getFloat64(pos);
		pos+=8;
		this.login_type = view.getInt32(pos);
		pos+=4;
		this.expire_time = view.getFloat64(pos);
		pos+=8;
		var _sb_7 = view.getUint32(pos);
		pos+=4;
		this.device_id = view.buffer.slice(pos,pos+_sb_7);
		// this var is Uint8Array,should convert to String!!
		pos+= _sb_7;
		this.device_id = String.fromCharCode.apply(null, this.device_id.getBytes());
		this.device_id = utf8to16(this.device_id);
		return pos;
	}	;	
	 // --  end function -- 
	
}




function NotifyMessage_t(){
// -- STRUCT -- 
	this.issue_user = ''; 
	this.issue_unit = ''; 
	this.issue_time = ''; 
	this.type = 0; 
	this.p1 = ''; 
	this.p2 = ''; 
	this.p3 = ''; 
	this.p4 = ''; 
	
	this.getsize = function(){
		var size =0;
		var _sb_1 = utf16to8(this.issue_user);
		size+= 4 + _sb_1.getBytes().length;
		var _sb_2 = utf16to8(this.issue_unit);
		size+= 4 + _sb_2.getBytes().length;
		var _sb_3 = utf16to8(this.issue_time);
		size+= 4 + _sb_3.getBytes().length;
		size+= 4;
		var _sb_4 = utf16to8(this.p1);
		size+= 4 + _sb_4.getBytes().length;
		var _sb_5 = utf16to8(this.p2);
		size+= 4 + _sb_5.getBytes().length;
		var _sb_6 = utf16to8(this.p3);
		size+= 4 + _sb_6.getBytes().length;
		var _sb_7 = utf16to8(this.p4);
		size+= 4 + _sb_7.getBytes().length;
		return size;
	}	;	
	
	// 
	this.marshall = function(view,pos){
		var _sb_1 = utf16to8(this.issue_user).getBytes();
		view.setInt32(pos,_sb_1.length);
		pos+=4;
		var _sb_2 = new Uint8Array(view.buffer);
		_sb_2.set(_sb_1,pos);
		pos += _sb_1.length;
		var _sb_3 = utf16to8(this.issue_unit).getBytes();
		view.setInt32(pos,_sb_3.length);
		pos+=4;
		var _sb_4 = new Uint8Array(view.buffer);
		_sb_4.set(_sb_3,pos);
		pos += _sb_3.length;
		var _sb_5 = utf16to8(this.issue_time).getBytes();
		view.setInt32(pos,_sb_5.length);
		pos+=4;
		var _sb_6 = new Uint8Array(view.buffer);
		_sb_6.set(_sb_5,pos);
		pos += _sb_5.length;
		view.setInt32(pos,this.type);
		pos+=4;
		var _sb_7 = utf16to8(this.p1).getBytes();
		view.setInt32(pos,_sb_7.length);
		pos+=4;
		var _sb_8 = new Uint8Array(view.buffer);
		_sb_8.set(_sb_7,pos);
		pos += _sb_7.length;
		var _sb_9 = utf16to8(this.p2).getBytes();
		view.setInt32(pos,_sb_9.length);
		pos+=4;
		var _sb_10 = new Uint8Array(view.buffer);
		_sb_10.set(_sb_9,pos);
		pos += _sb_9.length;
		var _sb_11 = utf16to8(this.p3).getBytes();
		view.setInt32(pos,_sb_11.length);
		pos+=4;
		var _sb_12 = new Uint8Array(view.buffer);
		_sb_12.set(_sb_11,pos);
		pos += _sb_11.length;
		var _sb_13 = utf16to8(this.p4).getBytes();
		view.setInt32(pos,_sb_13.length);
		pos+=4;
		var _sb_14 = new Uint8Array(view.buffer);
		_sb_14.set(_sb_13,pos);
		pos += _sb_13.length;
		return pos;
	}	;	
	
	this.unmarshall = function(view,pos){
		var _sb_1 = view.getUint32(pos);
		pos+=4;
		this.issue_user = view.buffer.slice(pos,pos+_sb_1);
		// this var is Uint8Array,should convert to String!!
		pos+= _sb_1;
		this.issue_user = String.fromCharCode.apply(null, this.issue_user.getBytes());
		this.issue_user = utf8to16(this.issue_user);
		var _sb_3 = view.getUint32(pos);
		pos+=4;
		this.issue_unit = view.buffer.slice(pos,pos+_sb_3);
		// this var is Uint8Array,should convert to String!!
		pos+= _sb_3;
		this.issue_unit = String.fromCharCode.apply(null, this.issue_unit.getBytes());
		this.issue_unit = utf8to16(this.issue_unit);
		var _sb_5 = view.getUint32(pos);
		pos+=4;
		this.issue_time = view.buffer.slice(pos,pos+_sb_5);
		// this var is Uint8Array,should convert to String!!
		pos+= _sb_5;
		this.issue_time = String.fromCharCode.apply(null, this.issue_time.getBytes());
		this.issue_time = utf8to16(this.issue_time);
		this.type = view.getInt32(pos);
		pos+=4;
		var _sb_7 = view.getUint32(pos);
		pos+=4;
		this.p1 = view.buffer.slice(pos,pos+_sb_7);
		// this var is Uint8Array,should convert to String!!
		pos+= _sb_7;
		this.p1 = String.fromCharCode.apply(null, this.p1.getBytes());
		this.p1 = utf8to16(this.p1);
		var _sb_9 = view.getUint32(pos);
		pos+=4;
		this.p2 = view.buffer.slice(pos,pos+_sb_9);
		// this var is Uint8Array,should convert to String!!
		pos+= _sb_9;
		this.p2 = String.fromCharCode.apply(null, this.p2.getBytes());
		this.p2 = utf8to16(this.p2);
		var _sb_11 = view.getUint32(pos);
		pos+=4;
		this.p3 = view.buffer.slice(pos,pos+_sb_11);
		// this var is Uint8Array,should convert to String!!
		pos+= _sb_11;
		this.p3 = String.fromCharCode.apply(null, this.p3.getBytes());
		this.p3 = utf8to16(this.p3);
		var _sb_13 = view.getUint32(pos);
		pos+=4;
		this.p4 = view.buffer.slice(pos,pos+_sb_13);
		// this var is Uint8Array,should convert to String!!
		pos+= _sb_13;
		this.p4 = String.fromCharCode.apply(null, this.p4.getBytes());
		this.p4 = utf8to16(this.p4);
		return pos;
	}	;	
	 // --  end function -- 
	
}



function ITerminalProxy(){
	this.conn = null;
	this.delta =null;
	
	this.destroy = function(){
		try{
			this.conn.close();
		}catch(e){
			RpcCommunicator.instance().getLogger().error(e.toString());
		}		
	}	;	
	
	this.onNotifyMessage_oneway = function (msg,error,props){
		var r = false;
		var m = new RpcMessage(RpcMessage.CALL|RpcMessage.ONEWAY);
		m.ifidx = 201;
		m.opidx = 0;
		m.paramsize = 1;
		error = arguments[1]?arguments[1]:null;
		m.onerror = error;
		props = arguments[2]?arguments[2]:null;
		m.extra=props;
		try{
			var size =0;
			size+=msg.getsize();
			var _bf_15 = new ArrayBuffer(size);
			var _view = new DataView(_bf_15);
			var _pos=0;
			_pos = msg.marshall(_view,_pos);
			m.paramstream =_bf_15;
			m.prx = this;
		}catch(e){
			console.log(e.toString());
			throw "RPCERROR_DATADIRTY";
		}		
		r = this.conn.sendMessage(m);
		if(!r){
			throw "RPCERROR_SENDFAILED";
		}		
	}	;	
	
	this.onNotifyMessage_async = function(msg,async,error,props,cookie){
		var r = false;
		var m = new RpcMessage(RpcMessage.CALL|RpcMessage.ASYNC);
		m.ifidx		= 201;
		m.opidx		= 0;
		error		= arguments[2]?arguments[2]:null;
		m.onerror	= error;
		props		= arguments[3]?arguments[3]:null;
		m.extra		= props;
		cookie 		= arguments[4]?arguments[4]:null;
		m.cookie	= cookie;
		m.extra		= props;
		m.paramsize = 1;
		try{
			var size =0;
			size += msg.getsize();
			var _bf_1 = new ArrayBuffer(size);
			var _view = new DataView(_bf_1);
			var _pos=0;
			_pos+=msg.marshall(_view,_pos);
			m.paramstream =_bf_1;
			m.prx = this;
			m.async = async;
		}catch(e){
			console.log(e.toString());
			throw "RPCERROR_DATADIRTY";
		}		
		r = this.conn.sendMessage(m);
		if(!r){
			throw "RpcConsts.RPCERROR_SENDFAILED";
		}		
	}	;	
	
	
	this.AsyncCallBack = function(m1,m2){
		var array = new Uint8Array(m2.paramstream);
		var view = new DataView(array.buffer);
		var pos=0;
		if(m1.opidx == 0){
			m1.async(m1.prx,m1.cookie);
		}		
	}	;	
	
}
ITerminalProxy.create = function(uri){
	var prx = new ITerminalProxy();
	prx.conn = new RpcConnection(uri);
	return prx;
};

ITerminalProxy.createWithProxy = function(proxy){
	var prx = new ITerminalProxy();
	prx.conn = proxy.conn;
	return prx;
};


// class ITerminal
function ITerminal(){
	//# -- INTERFACE -- 
	this.delegate = new ITerminal_delegate(this);
	
	//public  onNotifyMessage(msg,RpcContext ctx){
	this.onNotifyMessage = function(msg,ctx){
	}	
}

function ITerminal_delegate(inst) {
	
	this.inst = inst;
	this.ifidx = 201;
	this.invoke = function(m){
		if(m.opidx == 0 ){
			return this.func_0_delegate(m);
		}		
		return false;
	}	;	
	
	this.func_0_delegate = function(m){
		var r = false;
		var pos =0;
		var array = null;
		var view = null;
		array = new Uint8Array(m.paramstream);
		view = new DataView(array.buffer);
		var msg = new NotifyMessage_t();
		pos= msg.unmarshall(view,pos);
		var servant = this.inst;
		var ctx = new RpcContext();
		ctx.msg = m;
		servant.onNotifyMessage(msg,ctx);
		if( (m.calltype & RpcMessage.ONEWAY) !=0 ){
			return true;
		}		
		
		return r;
	}	;	
	
}


function IUserEventListenerProxy(){
	this.conn = null;
	this.delta =null;
	
	this.destroy = function(){
		try{
			this.conn.close();
		}catch(e){
			RpcCommunicator.instance().getLogger().error(e.toString());
		}		
	}	;	
	
	this.onUserOnline_oneway = function (userid,tgs_id,device,error,props){
		var r = false;
		var m = new RpcMessage(RpcMessage.CALL|RpcMessage.ONEWAY);
		m.ifidx = 413;
		m.opidx = 0;
		m.paramsize = 3;
		error = arguments[3]?arguments[3]:null;
		m.onerror = error;
		props = arguments[4]?arguments[4]:null;
		m.extra=props;
		try{
			var size =0;
			var _sb_3 = utf16to8(userid);
			size+= 4 + _sb_3.getBytes().length;
			var _sb_4 = utf16to8(tgs_id);
			size+= 4 + _sb_4.getBytes().length;
			size+= 4;
			var _bf_5 = new ArrayBuffer(size);
			var _view = new DataView(_bf_5);
			var _pos=0;
			var _sb_6 = utf16to8(userid).getBytes();
			_view.setInt32(_pos,_sb_6.length);
			_pos+=4;
			var _sb_7 = new Uint8Array(_view.buffer);
			_sb_7.set(_sb_6,_pos);
			_pos += _sb_6.length;
			var _sb_8 = utf16to8(tgs_id).getBytes();
			_view.setInt32(_pos,_sb_8.length);
			_pos+=4;
			var _sb_9 = new Uint8Array(_view.buffer);
			_sb_9.set(_sb_8,_pos);
			_pos += _sb_8.length;
			_view.setInt32(_pos,device);
			_pos+=4;
			m.paramstream =_bf_5;
			m.prx = this;
		}catch(e){
			console.log(e.toString());
			throw "RPCERROR_DATADIRTY";
		}		
		r = this.conn.sendMessage(m);
		if(!r){
			throw "RPCERROR_SENDFAILED";
		}		
	}	;	
	
	this.onUserOnline_async = function(userid,tgs_id,device,async,error,props,cookie){
		var r = false;
		var m = new RpcMessage(RpcMessage.CALL|RpcMessage.ASYNC);
		m.ifidx		= 413;
		m.opidx		= 0;
		error		= arguments[4]?arguments[4]:null;
		m.onerror	= error;
		props		= arguments[5]?arguments[5]:null;
		m.extra		= props;
		cookie 		= arguments[6]?arguments[6]:null;
		m.cookie	= cookie;
		m.extra		= props;
		m.paramsize = 3;
		try{
			var size =0;
			var _sb_1 = utf16to8(userid);
			size+= 4 + _sb_1.getBytes().length;
			var _sb_2 = utf16to8(tgs_id);
			size+= 4 + _sb_2.getBytes().length;
			size+= 4;
			var _bf_3 = new ArrayBuffer(size);
			var _view = new DataView(_bf_3);
			var _pos=0;
			var _sb_4 = utf16to8(userid).getBytes();
			_view.setInt32(_pos,_sb_4.length);
			_pos+=4;
			var _sb_5 = new Uint8Array(_view.buffer);
			_sb_5.set(_sb_4,_pos);
			_pos += _sb_4.length;
			var _sb_6 = utf16to8(tgs_id).getBytes();
			_view.setInt32(_pos,_sb_6.length);
			_pos+=4;
			var _sb_7 = new Uint8Array(_view.buffer);
			_sb_7.set(_sb_6,_pos);
			_pos += _sb_6.length;
			_view.setInt32(_pos,device);
			_pos+=4;
			m.paramstream =_bf_3;
			m.prx = this;
			m.async = async;
		}catch(e){
			console.log(e.toString());
			throw "RPCERROR_DATADIRTY";
		}		
		r = this.conn.sendMessage(m);
		if(!r){
			throw "RpcConsts.RPCERROR_SENDFAILED";
		}		
	}	;	
	
	
	this.onUserOffline_oneway = function (userid,tgs_id,device,error,props){
		var r = false;
		var m = new RpcMessage(RpcMessage.CALL|RpcMessage.ONEWAY);
		m.ifidx = 413;
		m.opidx = 1;
		m.paramsize = 3;
		error = arguments[3]?arguments[3]:null;
		m.onerror = error;
		props = arguments[4]?arguments[4]:null;
		m.extra=props;
		try{
			var size =0;
			var _sb_8 = utf16to8(userid);
			size+= 4 + _sb_8.getBytes().length;
			var _sb_9 = utf16to8(tgs_id);
			size+= 4 + _sb_9.getBytes().length;
			size+= 4;
			var _bf_10 = new ArrayBuffer(size);
			var _view = new DataView(_bf_10);
			var _pos=0;
			var _sb_11 = utf16to8(userid).getBytes();
			_view.setInt32(_pos,_sb_11.length);
			_pos+=4;
			var _sb_12 = new Uint8Array(_view.buffer);
			_sb_12.set(_sb_11,_pos);
			_pos += _sb_11.length;
			var _sb_13 = utf16to8(tgs_id).getBytes();
			_view.setInt32(_pos,_sb_13.length);
			_pos+=4;
			var _sb_14 = new Uint8Array(_view.buffer);
			_sb_14.set(_sb_13,_pos);
			_pos += _sb_13.length;
			_view.setInt32(_pos,device);
			_pos+=4;
			m.paramstream =_bf_10;
			m.prx = this;
		}catch(e){
			console.log(e.toString());
			throw "RPCERROR_DATADIRTY";
		}		
		r = this.conn.sendMessage(m);
		if(!r){
			throw "RPCERROR_SENDFAILED";
		}		
	}	;	
	
	this.onUserOffline_async = function(userid,tgs_id,device,async,error,props,cookie){
		var r = false;
		var m = new RpcMessage(RpcMessage.CALL|RpcMessage.ASYNC);
		m.ifidx		= 413;
		m.opidx		= 1;
		error		= arguments[4]?arguments[4]:null;
		m.onerror	= error;
		props		= arguments[5]?arguments[5]:null;
		m.extra		= props;
		cookie 		= arguments[6]?arguments[6]:null;
		m.cookie	= cookie;
		m.extra		= props;
		m.paramsize = 3;
		try{
			var size =0;
			var _sb_1 = utf16to8(userid);
			size+= 4 + _sb_1.getBytes().length;
			var _sb_2 = utf16to8(tgs_id);
			size+= 4 + _sb_2.getBytes().length;
			size+= 4;
			var _bf_3 = new ArrayBuffer(size);
			var _view = new DataView(_bf_3);
			var _pos=0;
			var _sb_4 = utf16to8(userid).getBytes();
			_view.setInt32(_pos,_sb_4.length);
			_pos+=4;
			var _sb_5 = new Uint8Array(_view.buffer);
			_sb_5.set(_sb_4,_pos);
			_pos += _sb_4.length;
			var _sb_6 = utf16to8(tgs_id).getBytes();
			_view.setInt32(_pos,_sb_6.length);
			_pos+=4;
			var _sb_7 = new Uint8Array(_view.buffer);
			_sb_7.set(_sb_6,_pos);
			_pos += _sb_6.length;
			_view.setInt32(_pos,device);
			_pos+=4;
			m.paramstream =_bf_3;
			m.prx = this;
			m.async = async;
		}catch(e){
			console.log(e.toString());
			throw "RPCERROR_DATADIRTY";
		}		
		r = this.conn.sendMessage(m);
		if(!r){
			throw "RpcConsts.RPCERROR_SENDFAILED";
		}		
	}	;	
	
	
	this.AsyncCallBack = function(m1,m2){
		var array = new Uint8Array(m2.paramstream);
		var view = new DataView(array.buffer);
		var pos=0;
		if(m1.opidx == 0){
			m1.async(m1.prx,m1.cookie);
		}		
		if(m1.opidx == 1){
			m1.async(m1.prx,m1.cookie);
		}		
	}	;	
	
}
IUserEventListenerProxy.create = function(uri){
	var prx = new IUserEventListenerProxy();
	prx.conn = new RpcConnection(uri);
	return prx;
};

IUserEventListenerProxy.createWithProxy = function(proxy){
	var prx = new IUserEventListenerProxy();
	prx.conn = proxy.conn;
	return prx;
};


// class IUserEventListener
function IUserEventListener(){
	//# -- INTERFACE -- 
	this.delegate = new IUserEventListener_delegate(this);
	
	//public  onUserOnline(userid,tgs_id,device,RpcContext ctx){
	this.onUserOnline = function(userid,tgs_id,device,ctx){
	}	
	
	//public  onUserOffline(userid,tgs_id,device,RpcContext ctx){
	this.onUserOffline = function(userid,tgs_id,device,ctx){
	}	
}

function IUserEventListener_delegate(inst) {
	
	this.inst = inst;
	this.ifidx = 413;
	this.invoke = function(m){
		if(m.opidx == 0 ){
			return this.func_0_delegate(m);
		}		
		if(m.opidx == 1 ){
			return this.func_1_delegate(m);
		}		
		return false;
	}	;	
	
	this.func_0_delegate = function(m){
		var r = false;
		var pos =0;
		var array = null;
		var view = null;
		array = new Uint8Array(m.paramstream);
		view = new DataView(array.buffer);
		var userid;
		var _sb_10 = view.getUint32(pos);
		pos+=4;
		userid = view.buffer.slice(pos,pos+_sb_10);
		// this var is Uint8Array,should convert to String!!
		pos+= _sb_10;
		userid = String.fromCharCode.apply(null, userid.getBytes());
		userid = utf8to16(userid);
		var tgs_id;
		var _sb_12 = view.getUint32(pos);
		pos+=4;
		tgs_id = view.buffer.slice(pos,pos+_sb_12);
		// this var is Uint8Array,should convert to String!!
		pos+= _sb_12;
		tgs_id = String.fromCharCode.apply(null, tgs_id.getBytes());
		tgs_id = utf8to16(tgs_id);
		var device;
		device = view.getInt32(pos);
		pos+=4;
		var servant = this.inst;
		var ctx = new RpcContext();
		ctx.msg = m;
		servant.onUserOnline(userid,tgs_id,device,ctx);
		if( (m.calltype & RpcMessage.ONEWAY) !=0 ){
			return true;
		}		
		
		return r;
	}	;	
	
	this.func_1_delegate = function(m){
		var r = false;
		var pos =0;
		var array = null;
		var view = null;
		array = new Uint8Array(m.paramstream);
		view = new DataView(array.buffer);
		var userid;
		var _sb_14 = view.getUint32(pos);
		pos+=4;
		userid = view.buffer.slice(pos,pos+_sb_14);
		// this var is Uint8Array,should convert to String!!
		pos+= _sb_14;
		userid = String.fromCharCode.apply(null, userid.getBytes());
		userid = utf8to16(userid);
		var tgs_id;
		var _sb_16 = view.getUint32(pos);
		pos+=4;
		tgs_id = view.buffer.slice(pos,pos+_sb_16);
		// this var is Uint8Array,should convert to String!!
		pos+= _sb_16;
		tgs_id = String.fromCharCode.apply(null, tgs_id.getBytes());
		tgs_id = utf8to16(tgs_id);
		var device;
		device = view.getInt32(pos);
		pos+=4;
		var servant = this.inst;
		var ctx = new RpcContext();
		ctx.msg = m;
		servant.onUserOffline(userid,tgs_id,device,ctx);
		if( (m.calltype & RpcMessage.ONEWAY) !=0 ){
			return true;
		}		
		
		return r;
	}	;	
	
}


function ITerminalGatewayServerProxy(){
	this.conn = null;
	this.delta =null;
	
	this.destroy = function(){
		try{
			this.conn.close();
		}catch(e){
			RpcCommunicator.instance().getLogger().error(e.toString());
		}		
	}	;	
	
	this.ping_oneway = function (error,props){
		var r = false;
		var m = new RpcMessage(RpcMessage.CALL|RpcMessage.ONEWAY);
		m.ifidx = 409;
		m.opidx = 0;
		m.paramsize = 0;
		error = arguments[0]?arguments[0]:null;
		m.onerror = error;
		props = arguments[1]?arguments[1]:null;
		m.extra=props;
		try{
			var size =0;
			var _bf_18 = new ArrayBuffer(size);
			var _view = new DataView(_bf_18);
			var _pos=0;
			m.prx = this;
		}catch(e){
			console.log(e.toString());
			throw "RPCERROR_DATADIRTY";
		}		
		r = this.conn.sendMessage(m);
		if(!r){
			throw "RPCERROR_SENDFAILED";
		}		
	}	;	
	
	this.ping_async = function(async,error,props,cookie){
		var r = false;
		var m = new RpcMessage(RpcMessage.CALL|RpcMessage.ASYNC);
		m.ifidx		= 409;
		m.opidx		= 0;
		error		= arguments[1]?arguments[1]:null;
		m.onerror	= error;
		props		= arguments[2]?arguments[2]:null;
		m.extra		= props;
		cookie 		= arguments[3]?arguments[3]:null;
		m.cookie	= cookie;
		m.extra		= props;
		m.paramsize = 0;
		try{
			var size =0;
			var _bf_1 = new ArrayBuffer(size);
			var _view = new DataView(_bf_1);
			var _pos=0;
			m.prx = this;
			m.async = async;
		}catch(e){
			console.log(e.toString());
			throw "RPCERROR_DATADIRTY";
		}		
		r = this.conn.sendMessage(m);
		if(!r){
			throw "RpcConsts.RPCERROR_SENDFAILED";
		}		
	}	;	
	
	
	this.AsyncCallBack = function(m1,m2){
		var array = new Uint8Array(m2.paramstream);
		var view = new DataView(array.buffer);
		var pos=0;
		if(m1.opidx == 0){
			m1.async(m1.prx,m1.cookie);
		}		
	}	;	
	
}
ITerminalGatewayServerProxy.create = function(uri){
	var prx = new ITerminalGatewayServerProxy();
	prx.conn = new RpcConnection(uri);
	return prx;
};

ITerminalGatewayServerProxy.createWithProxy = function(proxy){
	var prx = new ITerminalGatewayServerProxy();
	prx.conn = proxy.conn;
	return prx;
};


// class ITerminalGatewayServer
function ITerminalGatewayServer(){
	//# -- INTERFACE -- 
	this.delegate = new ITerminalGatewayServer_delegate(this);
	
	//public  ping(RpcContext ctx){
	this.ping = function(ctx){
	}	
}

function ITerminalGatewayServer_delegate(inst) {
	
	this.inst = inst;
	this.ifidx = 409;
	this.invoke = function(m){
		if(m.opidx == 0 ){
			return this.func_0_delegate(m);
		}		
		return false;
	}	;	
	
	this.func_0_delegate = function(m){
		var r = false;
		var pos =0;
		var array = null;
		var view = null;
		var servant = this.inst;
		var ctx = new RpcContext();
		ctx.msg = m;
		servant.ping(ctx);
		if( (m.calltype & RpcMessage.ONEWAY) !=0 ){
			return true;
		}		
		
		return r;
	}	;	
	
}


function IMessageServerProxy(){
	this.conn = null;
	this.delta =null;
	
	this.destroy = function(){
		try{
			this.conn.close();
		}catch(e){
			RpcCommunicator.instance().getLogger().error(e.toString());
		}		
	}	;	
	
	this.sendNotification_oneway = function (target_unit,target_user_role,msg,error,props){
		var r = false;
		var m = new RpcMessage(RpcMessage.CALL|RpcMessage.ONEWAY);
		m.ifidx = 408;
		m.opidx = 0;
		m.paramsize = 3;
		error = arguments[3]?arguments[3]:null;
		m.onerror = error;
		props = arguments[4]?arguments[4]:null;
		m.extra=props;
		try{
			var size =0;
			var _sb_3 = utf16to8(target_unit);
			size+= 4 + _sb_3.getBytes().length;
			size+= 4;
			size+=msg.getsize();
			var _bf_4 = new ArrayBuffer(size);
			var _view = new DataView(_bf_4);
			var _pos=0;
			var _sb_5 = utf16to8(target_unit).getBytes();
			_view.setInt32(_pos,_sb_5.length);
			_pos+=4;
			var _sb_6 = new Uint8Array(_view.buffer);
			_sb_6.set(_sb_5,_pos);
			_pos += _sb_5.length;
			_view.setInt32(_pos,target_user_role);
			_pos+=4;
			_pos = msg.marshall(_view,_pos);
			m.paramstream =_bf_4;
			m.prx = this;
		}catch(e){
			console.log(e.toString());
			throw "RPCERROR_DATADIRTY";
		}		
		r = this.conn.sendMessage(m);
		if(!r){
			throw "RPCERROR_SENDFAILED";
		}		
	}	;	
	
	this.sendNotification_async = function(target_unit,target_user_role,msg,async,error,props,cookie){
		var r = false;
		var m = new RpcMessage(RpcMessage.CALL|RpcMessage.ASYNC);
		m.ifidx		= 408;
		m.opidx		= 0;
		error		= arguments[4]?arguments[4]:null;
		m.onerror	= error;
		props		= arguments[5]?arguments[5]:null;
		m.extra		= props;
		cookie 		= arguments[6]?arguments[6]:null;
		m.cookie	= cookie;
		m.extra		= props;
		m.paramsize = 3;
		try{
			var size =0;
			var _sb_1 = utf16to8(target_unit);
			size+= 4 + _sb_1.getBytes().length;
			size+= 4;
			size += msg.getsize();
			var _bf_2 = new ArrayBuffer(size);
			var _view = new DataView(_bf_2);
			var _pos=0;
			var _sb_3 = utf16to8(target_unit).getBytes();
			_view.setInt32(_pos,_sb_3.length);
			_pos+=4;
			var _sb_4 = new Uint8Array(_view.buffer);
			_sb_4.set(_sb_3,_pos);
			_pos += _sb_3.length;
			_view.setInt32(_pos,target_user_role);
			_pos+=4;
			_pos+=msg.marshall(_view,_pos);
			m.paramstream =_bf_2;
			m.prx = this;
			m.async = async;
		}catch(e){
			console.log(e.toString());
			throw "RPCERROR_DATADIRTY";
		}		
		r = this.conn.sendMessage(m);
		if(!r){
			throw "RpcConsts.RPCERROR_SENDFAILED";
		}		
	}	;	
	
	
	this.AsyncCallBack = function(m1,m2){
		var array = new Uint8Array(m2.paramstream);
		var view = new DataView(array.buffer);
		var pos=0;
		if(m1.opidx == 0){
			m1.async(m1.prx,m1.cookie);
		}		
	}	;	
	
}
IMessageServerProxy.create = function(uri){
	var prx = new IMessageServerProxy();
	prx.conn = new RpcConnection(uri);
	return prx;
};

IMessageServerProxy.createWithProxy = function(proxy){
	var prx = new IMessageServerProxy();
	prx.conn = proxy.conn;
	return prx;
};


// class IMessageServer
function IMessageServer(){
	//# -- INTERFACE -- 
	this.delegate = new IMessageServer_delegate(this);
	
	//public  sendNotification(target_unit,target_user_role,msg,RpcContext ctx){
	this.sendNotification = function(target_unit,target_user_role,msg,ctx){
	}	
}

function IMessageServer_delegate(inst) {
	
	this.inst = inst;
	this.ifidx = 408;
	this.invoke = function(m){
		if(m.opidx == 0 ){
			return this.func_0_delegate(m);
		}		
		return false;
	}	;	
	
	this.func_0_delegate = function(m){
		var r = false;
		var pos =0;
		var array = null;
		var view = null;
		array = new Uint8Array(m.paramstream);
		view = new DataView(array.buffer);
		var target_unit;
		var _sb_6 = view.getUint32(pos);
		pos+=4;
		target_unit = view.buffer.slice(pos,pos+_sb_6);
		// this var is Uint8Array,should convert to String!!
		pos+= _sb_6;
		target_unit = String.fromCharCode.apply(null, target_unit.getBytes());
		target_unit = utf8to16(target_unit);
		var target_user_role;
		target_user_role = view.getInt32(pos);
		pos+=4;
		var msg = new NotifyMessage_t();
		pos= msg.unmarshall(view,pos);
		var servant = this.inst;
		var ctx = new RpcContext();
		ctx.msg = m;
		servant.sendNotification(target_unit,target_user_role,msg,ctx);
		if( (m.calltype & RpcMessage.ONEWAY) !=0 ){
			return true;
		}		
		
		return r;
	}	;	
	
}

