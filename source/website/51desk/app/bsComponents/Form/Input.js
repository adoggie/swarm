'use strict'

var React=require('react');
var classNames=require("classnames");
var ClassNameMixin=require("../mixins/ClassNameMixin.js");
var FormGroup=require("./FormGroup.js");
var Button=require("./Button.js");
var Constants=require("../constants.js");

var Input=React.createClass({
	mixins:[ClassNameMixin],
	propTypes:{
		type:React.PropTypes.string,
		bsSize:React.PropTypes.oneOf(['sm','lg']),
		label:React.PropTypes.node, //文本提示
		labelClassName:React.PropTypes.string,//文本提示的class
		wrapperClassName:React.PropTypes.string,//input wrapper 的class
		id:React.PropTypes.string,
		validation:React.PropTypes.oneOf(['success','wraning','error',""]),
		defdisabled:React.PropTypes.bool,
		defchecked:React.PropTypes.bool,
		defvalue:React.PropTypes.string,
		inline:React.PropTypes.bool,
		standalone:React.PropTypes.bool,// 针对 Button 只渲染input 不渲染其他wrap和label
		addonBefore: React.PropTypes.node,
	    addonAfter: React.PropTypes.node,
	    btnBefore: React.PropTypes.node,
	    btnAfter: React.PropTypes.node,
	},
	getDefaultProps:function(){
		return {
			type:'text'
		}
	},
	getFieldDOMNode:function(){
		return React.findDOMNode(this.refs.field);
	},
	isCheckboxOrRadio:function(){
		return this.props.type === 'radio' || this.props.type === 'checkbox';
	},
	renderLabel:function(children){
		var classSet={};
		if(this.isCheckboxOrRadio()){
			(this.props.inline) && (classSet[this.setClassNamespace(this.props.type+"-inline")]=true);
		}else
			classSet[this.setClassNamespace('control-label')]=true;
		return (
				<label 
					htmlFor={this.props.id}
					key="label"
					className={classNames(this.props.labelClassName,classSet)}>
					{children}
					{this.props.label}
				</label>
			)
	},
	renderInputGroup:function(children){
		var groupPrefix=this.setClassNamespace("input-group");
		var addOnClassName=groupPrefix+"-addon";
		var btnClassName=groupPrefix+"-btn";
		var addonBefore=this.props.addonBefore ? (
				<span className={addOnClassName} key="addonBefore">
					{this.props.addonBefore}
				</span>
			) : null;
		var addonAfter=this.props.addonAfter ? (
				<span className={addOnClassName} key="addonAfter">
					{this.props.addonAfter}
				</span>
			) :null;
		var btnBefore=this.props.btnBefore ? (
				<span className={btnClassName} key="btnBefore">
					{this.props.btnBefore}
				</span>
			):null;
		var btnAfter=this.props.btnAfter ? (
				<span className={btnClassName} key="btnAfter">
					{this.props.btnAfter}
				</span>
			):null;
		var classSet={};
		if(this.props.bsSize){
			classSet[groupPrefix + "-"+this.props.bsSize]=true;
		}
		if(this.props.bsStyle){
			classSet[groupPrefix + "-"+this.props.bsStyle]=true;
		}
		return addonBefore || addonAfter || btnBefore || btnAfter ? (
				<div className={classNames(groupPrefix,classSet)} key="inputGroup">
					{addonBefore}
					{btnBefore}
					{children}
					{btnAfter}
					{addonAfter}
				</div>
			):children;
	},
  	renderCheckboxAndRadioWrapper: function(children) {
	    return this.props.inline ? children :
	      (
	      <div
	        className={this.setClassNamespace(this.props.type)}
	        key="checkboxAndRadioWrapper">
	        {children}
	      </div>
	    );
  	},
	//如果 wrapperClassName存在，进行input wrap 渲染
	renderWrapper:function(children){
		return this.props.wrapperClassName ? (
				<div key="wrapper" className={this.props.wrapperClassName}>
					{children}
				</div>
			):children;
	},
	renderInput:function(){
		var input =null;
		var formcontrolclass=this.isCheckboxOrRadio() ? "" :
			 this.setClassNamespace("form-control");
		var classSet={};
		if(this.props.bsSize && !this.props.standalone)
			classSet[this.setClassNamespace("input-"+this.props.bsSize)]=true;
		var classes=classNames(formcontrolclass,this.props.className,classSet);

		switch(this.props.type){
			case 'textarea':
				input=(
					<textarea defaultDisabled={this.props.defdisabled} defaultValue={this.props.defvalue}
					 {...this.props} 
					className={classes} ref="field" key="field" />
					);
				break;
			case 'select':
				input=(
					<select 
						{...this.props}
						className={classes} ref="field" key="field">
						{this.props.children}
					</select>
					);
			break;
			case 'submit':
			case 'button':
			case 'reset':
				input= (
					<Button {...this.props} componentTag="input" ref='field' key="field" />
					);
			break;
			default:
				input=(
					<input defaultDisabled={this.props.defdisabled} defaultValue={this.props.defvalue}
						className={classes} ref={this.props.id} key={this.props.id} defaultChecked={this.props.defchecked}
						data-valtypes={this.props.valtypes}
						{...this.props} />
					);
			break;
		}
		return input;
	},
	render:function(){
		if(this.props.standalone)
			return this.renderInput();
		if(this.isCheckboxOrRadio()) {
	      return this.renderWrapper(
	        this.renderCheckboxAndRadioWrapper(
	          this.renderLabel(
	            this.renderInput()
	          )
	        )
	      );
	    }
		return (
			<FormGroup bsSize={this.props.bsSize} validation={this.props.validation}>
				{[this.renderLabel(),
					this.renderWrapper(
					this.renderInputGroup(
						this.renderInput())),
					this.props.after]}
			</FormGroup>
			)
	}
});
module.exports=Input;