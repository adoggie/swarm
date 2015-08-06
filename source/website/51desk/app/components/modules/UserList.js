var React=require("react");
var Reflux=require("reflux");
var Table=require("../../bsComponents/Elements/Table");
var Icon=require("../../bsComponents/Icon");
var Button=require("../../bsComponents/Form/Button");
var actions=require("../../actions/actions");
var userStore=require("../../stores/userStore");
var userparam=require("../../data/UserParams");
var Pagination=require("../../bsComponents/Elements/Pagination");
var PagerDataMixin=require("../../mixins/PagerDataMixin");
var Popover=require("../../bsComponents/Popover/Popover");
var PopoverTrigger=require("../../bsComponents/Popover/PopoverTrigger");
var Form=require("../../bsComponents/Form/Form");
var Input=require("../../bsComponents/Form/Input");
var sortBy=require("lodash/collection/sortBy");

var UserList=React.createClass({
	mixins:[
		Reflux.listenTo(userStore,"renderTableBody"),
		PagerDataMixin,
	],
	getInitialState:function(){
		return {
			userlist:null,
			users:null,
			pageindex:1,
			columns:[
				{param:'aliasname',active:true},
				{param:'firstname',active:false},
				{param:'middlename',active:false},
				{param:'lastname',active:true},
				{param:'depname',active:true},
				{param:'rolename',active:true},
				{param:'sysrolename',active:false},
				{param:'active',active:true},
			],
		}
	},
	componentDidMount:function(){
		actions.getAllUsers();
	},
	renderTableBody:function(data){
		if(data){
			var userlist=this.rendertbody(data.slice(0,this.pageSize));
			this.setState({
				users:data,
				userlist:userlist,
			})
		}
	},
	itemHandleClick:function(curuser,userid,e){
		this.props.itemClick(userid,curuser,e);
	},
	rendertbody:function(data){
		if(data){
			return data.map(function(user,index){
				return (
						<tr>
							<td><input type='checkbox' /></td>
							<td><a onClick={this.itemHandleClick.bind(this,user,user[userparam.userid.param])}>{user[userparam.username.param]}</a></td>
							{this.getTableColumn(false,user)}
						</tr>
					);
			}.bind(this));
		}
	},
	pageHandler:function(link,disabled,e){ //分页处理函数
		e.preventDefault();
		e.stopPropagation();
		if(disabled)
			return;
		link=link.substring(1);
		var pageindex=this.state.pageindex;
		if(parseInt(link)){
			pageindex=parseInt(link);
		}else{
			switch(link){
				case 'prev':
					if(this.state.pageindex != 1){
						pageindex-=1;
					}
				break;
				case 'next':
					if(this.state.pageindex!=this.pageCounts)
						pageindex+=1;
				break;
				case 'first':
					if(this.state.pageindex != 1){
						pageindex=1;
					}
				break;
				case 'last':
					if(this.state.pageindex != this.pageCounts){
						pageindex=this.pageCounts;
					}
				break;
			}
		}
		var pagedata=this.state.users;
		var start=(pageindex-1)*this.pageSize;
		var userlist=this.rendertbody(pagedata.slice(start,start+this.pageSize));
		if(pageindex != this.state.pageindex)
			this.setState({
				pageindex:pageindex,
				userlist:userlist,
			})
	},
	getTableColumn:function(header,user){
		if(header)
			return this.state.columns.map(function(col,index){
				if(col.active)
					return (
						<th>
							{userparam[col.param].title}
						</th>
						);
			})
		else
			return this.state.columns.map(function(col,index){
				var content=user[userparam[col.param].param];
				if(userparam[col.param].type && userparam[col.param].type == 'checkbox'){
					content= content ? 'active':'deactive';
				}
				if(col.active)
					return (
						<td>
							{content}
						</td>
						);
			})
	},
	getConfigColumn:function(){
		return this.state.columns.map(function(col,index){
				// if(col.active)
					return (
						<Input labelClassName="col-sm-5" label={userparam[col.param].title} type="checkbox"  inline
							onChange={this.tableConfigChange.bind(this,index)} checked={col.active} />
						);
			}.bind(this));
	},
	tableConfigChange:function(index,e){  //显示 /隐藏列
		var columns=this.state.columns;
		columns[index].active=!columns[index].active;
		var userlist=this.rendertbody(this.state.users.slice(0,this.pageSize));
		this.setState({
			columns:columns,
			userlist:userlist,
		})
	},
	sortChange:function(e){  //列 排序 回调
		var targetval=e.target.value;
		var users=sortBy(this.state.users,userparam[targetval].param);
		var userlist=this.rendertbody(users.slice(0,this.pageSize));
		this.setState({
			users:users,
			userlist:userlist,
		})
	},
	render:function(){
		var paginationData=this.getPagerData(this.state.pageindex,this.state.users ? this.state.users.length : 0);
		
		var tableConfigPopover=(
				<Popover>
					<div style={{width:'100%'}}>
						<Form>
							<h4>Columns</h4>
							<Input label="UserName" type="checkbox" labelClassName="col-sm-5 ml10"  checked inline/>
							{this.getConfigColumn()}
							<div className="clearfix"></div>
							<hr />
							<Input label="SortBy" type="select" onChange={this.sortChange}>
								<option value="firstname">FirstName</option>
								<option value="lastname">LastName</option>
								<option value="aliasname">AliasName</option>
							</Input>
							<Input label="GroupBy" type="select"/>
						</Form>
					</div>
				</Popover>
			);
		return (
				<div>
					<div style={{marginBottom:14}}>
						<Button><Icon icon="download" /> Import</Button>
						<Button><Icon icon="minus-sign"/> Deactive</Button>
						<Button><Icon icon="share-alt"/> ResetPassword</Button>
						<PopoverTrigger trigger="click" 
							popover={tableConfigPopover}>
							<Button style={{float:"right"}}><Icon icon="cog"/></Button>
						</PopoverTrigger>
					</div>
					<Table striped bordered hover>
						<thead>
							<tr>
								<th></th>
								<th>UserName</th>
								{this.getTableColumn(true)}
							</tr>
						</thead>
						<tbody>
							{this.state.userlist}
						</tbody>
					</Table>
					<Pagination data={paginationData} right  onSelect={this.pageHandler}/>
				</div>
			)
	}
});
module.exports=UserList;