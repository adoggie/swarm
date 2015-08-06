require('object.assign').shim();
var ValidationFactory=require("./ValidationFactory");
var ValidationMixin={
	handleValidation:function(key,callback){
		return function(e){
			e.preventDefault();
			this.validate(key,callback);
		}.bind(this);
	},
	validate:function(key,callback){
		var schema=this.validatorTypes || {};
		var validationErrors=Object.assign({},this.state.errors,ValidationFactory.validate(schema,this.state,key));
		this.setState({
			errors:validationErrors
		})
	},
	clearValidations:function(){
		return this.setState({
			errors:{}
		})
	},
	getValdationMessages:function(key){
		var errors=this.state.errors;
		if(errors){
			return errors[key];
		}else{
			return "";
		}
	}
};
module.exports=ValidationMixin;