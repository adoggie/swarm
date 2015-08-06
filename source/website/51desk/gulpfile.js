//所需要的模块
// 编译Sass (gulp-ruby-sass)
// Autoprefixer (gulp-autoprefixer)
// 缩小化(minify)CSS (gulp-minify-css)
// JSHint (gulp-jshint)
// 拼接 (gulp-concat)
// 丑化(Uglify) (gulp-uglify)
// 图片压缩 (gulp-imagemin)
// 即时重整(LiveReload) (gulp-livereload) XXX
//  browser-sync
// 清理档案 (gulp-clean)
// 图片快取，只有更改过得图片会进行压缩 (gulp-cache)
// 更动通知 (gulp-notify)
//html页面压缩(gulp-htmlmin)
//重命名 (gulp-rename)
//执行bower安装(gulp-bower)
//加载所有插件 (gulp-load-plugins)
//模板引擎库 (gulp-handlebars)
//gulp-browserify
var gulp=require("gulp"),
	gulploadplugins=require("gulp-load-plugins"),
	plugins=gulploadplugins(),
	browserify=require("gulp-browserify"),
	sass=require("gulp-ruby-sass"),
	autoprefixer=require("gulp-autoprefixer"),
	rename=require("gulp-rename"),
	minifycss=require("gulp-minify-css"),
	connect=require("gulp-connect");

var paths={
	src:{

	}
}
gulp.task("browserify",function(){
	gulp.src("./app/app.js")
		.pipe(browserify({
			transform:'reactify',
		}))
		.pipe(gulp.dest('./dist'));
		// .pipe(rename({suffix:'.min'}))
		// .pipe(plugins.uglify())
		// .pipe(gulp.dest('./dist'));
})
gulp.task("sass",function(){
	return sass("app/styles/main.scss")
			.pipe(gulp.dest("dist/css/"));
})

//处理 scss
gulp.task("styles",function(){
	return gulp.src("./app/styles/main.css")
			.pipe(autoprefixer('last 2 version','safari 5','ie8','ie9','opera12.1'))
			.pipe(gulp.dest("dist/css"))
			.pipe(rename({suffix:'.min'}))
			.pipe(minifycss())
			.pipe(gulp.dest("dist/css"));
})

//压缩图片
gulp.task("images",function(){
	return gulp.src("app/images/**/*")
				//.pipe(plugins.imagemin({optimizationLevel:3,progressive:true,interlaced:true}))
				.pipe(gulp.dest("dist/images"));
})

//发布前 清理 dist 发布目录
gulp.task("clean",function(){
	return gulp.src(['dist/css','dist/img','dist/js'],{read:false})
				.pipe(plugins.clean());
})

gulp.task("connect",function(){
	connect.server();
})

gulp.task("default",['connect','watch'],function(){
	//gulp.start('styles','images','scripts');
})

// gulp.task("browsersync",function(){
// 	plugins.browsersync({
// 		server:{
// 			baseDir:'./'
// 		}
// 	})
// })

gulp.task("watch",function(){
	gulp.watch('app/styles/main.css',['styles']);
	gulp.watch("app/images/**/*",['images']);
	gulp.watch("app/app.js",["browserify"]);
})



