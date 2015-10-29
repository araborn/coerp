var	gulp = require('gulp'),
	exist = require('gulp-exist'),
	watch = require('gulp-watch'),
	newer = require('gulp-newer'),
	zip = require('gulp-zip'),
	plumber = require('gulp-plumber'),
	rename = require('gulp-rename'),
	replace = require('gulp-replace');
	
var secrets = require('./exist-secrets.json')

var sourceDir = 'app/'

var buildDest = 'build/';
var xmlDest = buildDest + 'data/texts';


var exist_local_conf = {
		host: "localhost",
		port: 8080,
		path: "/exist/xmlrpc",
		auth: secrets.local,
		target: "/db/apps/coerp_new",
		permissions: {
			"controller.xql": "rwxr-xr-x"
		}
	};

var exist_remote_conf = {
		host: "projects.cceh.uni-koeln.de",
		port: 8080,
		path: "/xmlrpc",
		auth: secrets.remote,
		target: "/db/apps/coerp_new",
		permissions: {
			"controller.xql": "rwxr-xr-x"
		}
}



// ------ Copy (and compile) sources and assets to build dir ----------



gulp.task('copy', function() {
	return gulp.src(sourceDir + '**/*')
		   	.pipe(newer(buildDest))
		   	.pipe(gulp.dest(buildDest))
})


gulp.task('build', ['XMLEdit','copy']);




// ------ Deploy build dir to eXist ----------


gulp.task('deploy-local', ['build'], function() {

	return gulp.src(buildDest + '**/*', {base: buildDest})
		.pipe(exist.newer(exist_local_conf))
		.pipe(exist.dest(exist_local_conf));
});

gulp.task('remote-upload', ['build'], function() {

	return gulp.src(buildDest + '**/*', {base: buildDest})
		.pipe(exist.newer(exist_remote_conf))
		.pipe(exist.dest(exist_remote_conf));
});

gulp.task('remote-post-install', ['remote-upload'], function() {
	return gulp.src('scripts/post-deploy.xql')
		.pipe(exist.query(exist_remote_conf));
});

gulp.task('deploy-remote', ['remote-upload', 'remote-post-install']);




// ------ Update Index ----------

var exist_indexupdate_local_texts = {
		host: "localhost",
		port: 8080,
		path: "/exist/xmlrpc",
		auth: secrets.local,
		target: "/db/system/config/db/apps/coerp_new/data/texts"
}


gulp.task('upload-index-local-texts', function(){
	return gulp.src('app/indezies/texts_collection.xconf')
			.pipe(rename('collection.xconf'))
			.pipe(exist.dest(exist_indexupdate_local_texts));
});


gulp.task('update-index', ['upload-index-local-texts'], function() {
	return gulp.src('scripts/reindex.xql')
			.pipe(exist.query(exist_indexupdate_local_texts));
});

var exist_indexupdate_remote = {
		host: "projects.cceh.uni-koeln.de",
		port: 8080,
		path: "/xmlrpc",
		auth: secrets.remote,
		target: "/db/system/config/db/apps/coerp_new/data/texts"
}


gulp.task('upload-index-conf-remote', function(){
	return gulp.src('app/indezies/texts_collection.xconf')
			.pipe(rename('collection.xconf'))
			.pipe(exist.dest(exist_indexupdate_remote));
});

gulp.task('update-index-remote', ['upload-index-conf-remote'], function() {
	return gulp.src('scripts/reindex.xql')
			.pipe(exist.query(exist_indexupdate_remote));
});



gulp.task('XMLEdit',function() {
	gulp.src([sourceDir +'data/texts/*'])
		.pipe(replace('<coerp xmlns="http://www.coerp.uni-koeln.de/schema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://coerp.uni-koeln.de/schema/ coerp.xsd">',
			'<coerp xmlns="http://coerp.uni-koeln.de/schema/coerp" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://coerp.uni-koeln.de/schema/coerp http://coerp.uni-koeln.de/schema/coerp.xsd">'))
		.pipe(replace('<coerp xmlns="http://www.coerp.uni-koeln.de/schema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://coerp.uni-koeln.de/schema/ coerp.xsd">'
		,'<coerp xmlns="http://coerp.uni-koeln.de/schema/coerp" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://coerp.uni-koeln.de/schema/coerp http://coerp.uni-koeln.de/schema/coerp.xsd">'))
		.pipe(replace('xmlns=""',''))
		.pipe(newer(xmlDest))
		.pipe(gulp.dest(xmlDest));
	});


// ------ Make eXist XAR Package ----------


gulp.task('xar', ['build'], function() {
	var p = require('./package.json');

	return gulp.src(buildDest + '**/*', {base: buildDest})
			.pipe(zip("coerp_new-" + p.version + ".xar"))
			.pipe(gulp.dest("."));
});



// ------ WATCH ----------


gulp.task('watch-main', function() {
	return watch(buildDest, {
			ignoreInitial: true,
			base: buildDest,
			name: 'Main Watcher'
	})
	.pipe(plumber())
	.pipe(exist.dest(exist_local_conf))
});



gulp.task('watch-copy', function() {
	gulp.watch([sourceDir + '**/*'], ['copy']);
});



gulp.task('watch', ['watch-copy', 'watch-main']);
