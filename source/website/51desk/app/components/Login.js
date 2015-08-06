'use strict'

var React=require("react");
var Reflux=require("reflux");
var Form=require("../bsComponents/Form/Form");
var Input=require("../bsComponents/Form/Input");
var Button=require("../bsComponents/Form/Button");
var Util=require("./Util");
var actions=require("../actions/actions");
var loginStore=require("../stores/loginStore");
var userStore=require("../stores/userStore");

var Login=React.createClass({
	mixins: [
		Util,
	    require('react-router').Navigation, // needed for transitionto
	    Reflux.listenTo(loginStore,'loginErr'),
	    Reflux.listenTo(userStore,'loginSuccess')
	  ],
	getInitialState:function(){
		var user=userStore.getUser();
		console.log("init");
		return {
			codesrc:"",
			fields:{
				username:user.username,
				password:'',
				valcode:''
			},
			isCheck:user.savename,
			errors:{},
			errormsg:'',
			errcount:0
		}
	},
	loginErr:function(msg){
		this.setState({errormsg:msg});
	},
	loginSuccess:function(resp){
		this.setState({errcount:0});
		if(this.state.isCheck){ //save username
			userStore.setUser(this.state.fields.username);
		}else{
			userStore.setUser("");
		}
		this.transitionTo("/main/Dashbord");
	},
	validationFun:function(vals,value){
		var curvalue=value,reval="";
		if(vals.length > 0){
			for(var i=0;i<vals.length;i++){
				var curval=vals[i];
				switch(curval){
					case 'required':
						reval=curvalue !=0 ? '':"error";
						break;
				}
				if(reval !="")
					break;
			}
			return reval;
		}
	},
	handleChange:function(field,e){
		e.stopPropagation();
		var thisfields=this.state.fields,thiserror=this.state.errors,
		targetObj=e.target,valtypes=targetObj.getAttribute("data-valtypes");
		thisfields[field]=targetObj.value;
		if(valtypes){
			var vals=valtypes.split(" ");
			var curerror=this.validationFun(vals,e.target.value);
			thiserror[field]=curerror;
		}
		this.setState({fields:thisfields,errors:thiserror});
	},
	handleCkChange:function(e){
		var targetObj=e.target;
		this.setState({isCheck:targetObj.checked});
	},
	handleSubmit:function(e){
		e.preventDefault();
		e.stopPropagation();
		//先执行验证
		var errors=this.state.errors,fields=this.state.fields,haserror=false;
		for(var key in fields){
			if(key == "valcode" && this.state.errcount<3)
				continue;
			if(!fields[key]){
				errors[key]="error";haserror=true;
			}
		}
		if(haserror){
			this.setState({errors:errors});
		}else{
			//发送请求验证账号
			var curobj=this,postData={user:this.state.fields.username,
				password:this.state.fields.password,domain:""};
			if(this.state.fields.valcode)
				postData.code=this.state.fields.valcode;
			actions.login(postData);
		}
	},
	redriectTo:function(e){
		e.preventDefault();e.stopPropagation();
		this.transitionTo("findpwd");
	},
	reloadcode:function(){
		this.setState({codesrc:this.state.codesrc+"?ran="+Math.random()});
	},
	render:function(){
		if(this.state.errcount >=3){
			var imagecode=(
					<img src={this.state.codesrc} onClick={this.reloadcode} alt='change' style={{cursor:pointer}} />
				);
			var validationsinput=(
					<Input style={{marginBottom:15}} label="validation" labelClassName="sr-only" id="validateinput"
					 wrapperClassName="col-sm-8 pl0" after={imagecode} value={this.state.fields.valcode}
					 onChange={this.handleChange.bind(this,'valcode')}>
					</Input>
				);
		}
		else
			var validationsinput="";
		return (
				<div>
					<div className="login_header"></div>
					<Form className="login_form" onSubmit={ this.handleSubmit }>
						<div className="login_logo center-block"></div>
						<Input value={this.state.fields.username} label="username" labelClassName="sr-only"
						 placeholder="Username" id="userName" valtypes="required" validation={this.state.errors.username}
						 onChange={this.handleChange.bind(this,'username')} />
						<Input value={this.state.fields.password} type="password" label="password" labelClassName="sr-only"
						 placeholder="Password" id="password" valtypes="required" validation={this.state.errors.password} 
						 onChange={this.handleChange.bind(this,'password')}/>
						{validationsinput}
						<Input inline type="checkbox" label="Save username" id="rembercheck" defchecked={this.state.isCheck}
							onChange={this.handleCkChange} />
						<a style={{float:'right',marginBottom:"10",cursor:"pointer"}} onClick={this.redriectTo}>Forgot Password?</a>
						<Button type="submit" block >Login</Button>
						<span style={{color:"red"}}>{this.state.errormsg}</span>
					</Form>
				</div>
			)
	}
});
module.exports=Login;

