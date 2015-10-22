var	gulp = require('gulp'),
	exist = require('gulp-exist'),
	watch = require('gulp-watch'),
	newer = require('gulp-newer'),
	zip = require('gulp-zip'),
	plumber = require('gulp-plumber'),
	rename = require('gulp-rename');
	
var secrets = require('./exist-secrets.json')

var sourceDir = 'app/'

var buildDest = 'build/';


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
/*
var exist_remote_conf = {
		host: "papyri.uni-koeln.de",
		port: 8080,
		path: "/xmlrpc",
		auth: secrets.remote,
		target: "/db/apps/papyri",
		permissions: {
			"controller.xql": "rwxr-xr-x"
		}
}
*/

// ------ Copy (and compile) sources and assets to build dir ----------



gulp.task('copy', function() {
	return gulp.src(sourceDir + '**/*')
		   	.pipe(newer(buildDest))
		   	.pipe(gulp.dest(buildDest))
})


gulp.task('build', ['copy']);




// ------ Deploy build dir to eXist ----------


gulp.task('deploy-local', ['build'], function() {

	return gulp.src(buildDest + '**/*', {base: buildDest})
		.pipe(exist.newer(exist_local_conf))
		.pipe(exist.dest(exist_local_conf));
});





// ------ Update Index ----------

var exist_indexupdate_local_texts = {
		host: "localhost",
		port: 8080,
		path: "/exist/xmlrpc",
		auth: secrets.local,
		target: "/db/system/config/db/apps/coerp_new/data/texts"
}


gulp.task('upload-index-texts', function(){
	return gulp.src('indezies/texts.collection.xconf')
			.pipe(rename('collection.xconf'))
			.pipe(exist.dest(exist_indexupdate_local_texts));
});


gulp.task('update-index', ['upload-index-texts'], function() {
	return gulp.src('scripts/reindex.xql')
			.pipe(exist.query(exist_indexupdate_local_texts));
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
