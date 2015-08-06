//用户管理--新增，编辑页面
var React=require("react/addons");
var Reflux=require("reflux");
var userStore=require("../../stores/userStore");
var Form=require("../../bsComponents/Form/Form");
var Input=require("../../bsComponents/Form/Input");
var Icon=require("../../bsComponents/Icon");
var Button=require("../../bsComponents/Form/Button");
var userparam=require("../../data/UserParams");
var actions=require("../../actions/actions");
var deptStore=require("../../stores/departmentStore");
var ValidationMixin=require("../../mixins/ValidationMixin");
var UserOption=React.createClass({
	//user:userStore.getUserById(this.props.userid)
	mixins:[Reflux.listenTo(deptStore,'getDeptData'),React.addons.LinkedStateMixin,ValidationMixin],
	validatorTypes:{
		firstname:"required",
		middlename:"required",
		lastname:"required",
		username:"required email",
	},
	getInitialState:function(){
		var curUser=this.props.data || {};
		return {
			firstname:curUser[userparam.firstname.param] || "",
			middlename:curUser[userparam.middlename.param] || "",
			lastname:curUser[userparam.lastname.param] || "",
			aliasname:curUser[userparam.aliasname.param] || "",
			username:curUser[userparam.username.param] || "",
			department:curUser[userparam.depname.param] || "",
			role:curUser[userparam.rolename.param] || "",
			sysrole:curUser[userparam.sysrolename.param] || "",
		}
	},
	getDeptData:function(){

	},
	ComponentDidMount:function(){
		actions.getAllDepts();
	},
	render:function(){
		var curUser=this.props.data || {};
		var deptBtn=(
				<Button>
					<Icon icon="book" />
				</Button>
			);
		return (
				<div>
					<Form horizontal>
						<Input label="First name *" labelClassName="col-sm-2 talignright" 
			wrapperClassName="col-sm-6" bsSize="sm" id="username" valueLink={this.linkState('firstname')} />
						<Input label="Middle name *" labelClassName="col-sm-2 talignright" 
			wrapperClassName="col-sm-6" bsSize="sm" id="username" valueLink={this.linkState('middlename')}/>
						<Input label="Last name *" labelClassName="col-sm-2 talignright" 
			wrapperClassName="col-sm-6" bsSize="sm" id="username" valueLink={this.linkState('lastname')}/>
						<Input label="Alias name *" labelClassName="col-sm-2 talignright" 
			wrapperClassName="col-sm-6" bsSize="sm" id="username" valueLink={this.linkState('aliasname')}/>
						<Input label="User name *" labelClassName="col-sm-2 talignright" 
			wrapperClassName="col-sm-6" bsSize="sm" id="username" valueLink={this.linkState('username')}/>
						<Input label="Department" labelClassName="col-sm-2 talignright"  btnAfter={deptBtn}
			wrapperClassName="col-sm-6" bsSize="sm" id="username" valueLink={this.linkState('department')}/>
						<Input label="Organizational role" labelClassName="col-sm-2 talignright" 
			wrapperClassName="col-sm-6" bsSize="sm" id="username" valueLink={this.linkState('role')}/>
						<Input label="System Role *" labelClassName="col-sm-2 talignright" 
			wrapperClassName="col-sm-6" bsSize="sm" id="username" valueLink={this.linkState('sysrole')}/>
						<div className="form-group">
							<div className="col-sm-5 col-sm-offset-7" style={{textAlign:"right",marginTop:20}}>
								<Button >Save and Create a New</Button>
								<Button >Save</Button>
								<Button >Cancle</Button>
							</div>
						</div>
					</Form>
				</div>
			)
	}
});
module.exports=UserOption;