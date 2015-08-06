var React=require("react");
// var Reflux=require("reflux");
//route
var Router=require("react-router");
var RouteHandler=Router.RouteHandler;
var Route=Router.Route;
var DefaultRoute=Router.DefaultRoute;
var NotFoundRoute=Router.NotFoundRoute;

var LoginComponent=require("./components/Login");
var MainComponent=require("./components/Main");
var FindpwdComponent=require("./components/Findpwd");
var NotFound=require("./components/NotFound");
 
var routes=(
		<Route handler={app} path="/">
			<Route name="login" handler={LoginComponent} path="login"></Route>
			<Route name="findpwd" handler={FindpwdComponent} path="findpwd"></Route>
			<Route name="main" handler={MainComponent} path="main"></Route>
			<Route name="secmenu" handler={MainComponent} path="/main/:secmenu"></Route>
			<Route name="submenu" handler={MainComponent} path="/main/:secmenu/:menu"></Route>
			<DefaultRoute name="home" handler={LoginComponent}></DefaultRoute>
			<NotFoundRoute handler={NotFound}/>
		</Route>
	); 
          
var app=React.createClass({
	render:function(){
		return (
				<RouteHandler />
			)
	}
})
 
Router.run(routes,function(Handler){
	React.render(<Handler />,
		document.getElementById("app"))
})