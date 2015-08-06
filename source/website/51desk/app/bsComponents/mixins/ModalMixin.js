var React=require("react");
var getScrollbarWidth=require("../utils/getScrollbarWidth");
var CSSCore=require("../utils/CSSCore");

var ModalMixin=React.createClass({
	setModalContainer:function(){
		var container = (this.props.container &&
	      React.findDOMNode(this.props.container)) || document.body;
	    var bodyPaddingRight = parseInt((container.style.paddingRight || 0), 10);
	    var barWidth = getScrollbarWidth();

	    if (barWidth) {
	      container.style.paddingRight = bodyPaddingRight + barWidth + 'px';
	    }

	    CSSCore.addClass(container, this.setClassNamespace('modal-open'));
	},
	resetModalContainer:function(){
		var container = (this.props.container &&
	      React.findDOMNode(this.props.container)) || document.body;
		CSSCore.removeClass(container,this.setClassNamespace('modal-open'));
		container.style.paddingRight='';
	}
});
module.exports=ModalMixin;