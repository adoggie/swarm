var React=require("react");
var bsReact=require('./bsComponents/bsReact.js');
var Button=bsReact.Button,
	Icon=bsReact.Icon,
	GridRow=bsReact.GridRow,
	GridCol=bsReact.GridCol,
	Form=bsReact.Form,
	Input=bsReact.Input,
	Popover=bsReact.Popover,
	PopoverTrigger=bsReact.PopoverTrigger;
// var Button=require('./bsComponents/Button.js');

React.render(
	<div style={{padding:20}}>
		<Button>默认样式</Button>
		<Button bsStyle="primary" style={{marginLeft:10}}>（首选项）Primary</Button>
		<Button bsStyle="success" style={{marginLeft:10}}>（成功）Success</Button>
		<Button bsStyle="info" style={{marginLeft:10}}>（一般信息）Info</Button>
		<Button bsStyle="warning" style={{marginLeft:10}}>（警告）Warning</Button>
		<Button bsStyle="danger" style={{marginLeft:10}}>（危险）Danger</Button>
		<Button bsStyle="link" style={{marginLeft:10}}>（链接）Link</Button>
		<br/>
		<p/>
		<Button bsSize="lg">默认样式 --larger</Button>
		<Button style={{marginLeft:10}}>默认样式 -- 默认大小</Button>
		<Button bsSize="sm" style={{marginLeft:10}}>默认样式 --Small button</Button>
		<Button bsSize="xs" style={{marginLeft:10}}>默认样式 --Extra small button</Button>
		<p>块级按钮</p>
		<Button block>默认样式</Button>
		<p>active && disabled</p>
		<Button active>默认样式 active</Button>
		<Button disabled style={{marginLeft:10}}>默认样式 disabled</Button>
		<p>链接按钮</p>
		<Button href="http://baidu.com" target="_blank">链接按钮</Button>
		<p>图标按钮</p>
		<Button>
			<Icon icon="star" /> star
		</Button>
		<p>栅格布局</p>
		<div className={"container-fluid"}>
			<GridRow>
				<GridCol md="2" mdPush="4" style={{border:'1px solid #ccc'}}>col-md-2  1</GridCol>
				<GridCol md="4" mdPull="2" style={{border:'1px solid #ccc'}}>col-md-4  2</GridCol>
				<GridCol md="4" style={{border:'1px solid #ccc'}}>col-md-4 3</GridCol>
			</GridRow>
			<GridRow>
				<GridCol md="4" style={{border:'1px solid #ccc'}} mdCenter>col-md-4</GridCol>
			</GridRow>
		</div>
		<p>水平表单</p>
		<Form horizontal>
			<Input label="用户名" labelClassName="col-sm-2 sr-only" placeholder="enter your name" 
			wrapperClassName="col-sm-6" bsSize="sm" id="username"  validation="success"/>
			<Input label="备注" type="textarea" labelClassName="col-sm-2 sr-only"
			wrapperClassName="col-sm-6" id="remark" validation="error" />
			<Input type='select' label="select options" labelClassName="col-sm-2 sr-only" 
			wrapperClassName="col-sm-6">
				<option value="1">options1</option>
				<option value="2">options2</option>
				<option value="3">options3</option>
			</Input>
			<Input label="rember me" id="checkrember"  disabled type="checkbox" wrapperClassName="col-sm-offset-2 col-sm-10" />
		</Form>
		<p>默认表单</p>
		<Form>
			<Input label="用户名" placeholder="enter your name" 
			id="username"  validation="success"/>
			<Input type="radio" label="radio1" id="radio1" name="sameradio" inline />
			<Input type="radio" label="radio2" id="radio2" name="sameradio" inline/>
			<Input type="radio" label="radio3" id="radio3" name="sameradio" inline/>
			<Input type='submit' value="Submit" standalone/> 
		</Form>
		<p>内联表单</p> 
		<Form inline>
			<Input label="用户名" placeholder="enter your name" 
			id="username"  validation="success"/>
			<Input label="密码" placeholder="enter your password"  style={{marginLeft:10}}
			id="username" labelClassName="sr-only" type="password"/>
			<Input type="checkbox" label='check it' id="checkremember" style={{marginLeft:10}}/>
			<Button style={{marginLeft:10}}>Sign in</Button>
		</Form>
		<hr/>
		<p>PopOver</p> 
		<div style={{position:"relative",display:"none"}}> 
			<Popover placement="left" pleft={30} ptop={10} title="popover title">
				test popover the top
			</Popover>
			<Popover placement="bottom" pleft={200} ptop={10} title="popover title">
				test popover the bottom test ~~
			</Popover>
		</div>
		<hr/>
		<p>trigger PopOver</p>
		<PopoverTrigger trigger='click' placement='top'
			popover={<Popover noarrow>显示的tips---test</Popover>}>
			<Button style={{marginLeft:100}}>点击显示popover</Button>
		</PopoverTrigger>   
		<hr/> 
		<hr/>
		<hr/>
	</div>,
	document.getElementById("app"));