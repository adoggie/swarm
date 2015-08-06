var React=require("react");
var classNames=require("classnames");
var ClassNameMixin=require("../mixins/ClassNameMixin");
var ModalMixin=require("../mixins/ModalMixin");
var Events=require("../utils/Events");
var Icon=require("../Icon");
var Close=require("../Close");

var Modal=React.createClass({
	mixins:[ModalMixin,ClassNameMixin],
	propTypes:{
		classPrefix:React.PropTypes.string,
		type: React.PropTypes.oneOf(['alert', 'confirm', 'prompt', 'loading',
		      'actions', 'popup']),
	    title: React.PropTypes.node,
	    confirmText: React.PropTypes.string,
	    cancelText: React.PropTypes.string,
	    closeIcon: React.PropTypes.bool,
	    closeViaDimmer: React.PropTypes.bool,
	},
	getDefaultProps:function(){
		return {
			classPrefix:'modal',
			closeIcon:true,
			confirmText:"确定",
			cancelText:'取消',
		}
	},
	render:function(){

	}
});
module.exports=Modal;