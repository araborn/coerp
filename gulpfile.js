var	gulp = require('gulp'),
	exist = require('gulp-exist'),
	watch = require('gulp-watch'),
	filter = require('gulp-filter')
	newer = require('gulp-newer'),
	plumber = require('gulp-plumber'),
	zip = require('gulp-zip'),
	sourcemaps = require('gulp-sourcemaps'),
	rename = require('gulp-rename'),
	replace = require('gulp-replace');

var secrets = require('./exist-secrets.json')

var sourceDir = 'app/'
var dataDir = 'transformation/new/';
var buildDest = 'build/';
var dataDest = buildDest + 'data/texts';


// ------ Copy (and compile) sources and assets to build dir ----------


gulp.task('copy', function() {
	return gulp.src(sourceDir + '**/*')
		   	.pipe(newer(buildDest))
		   	.pipe(gulp.dest(buildDest))
})

gulp.task('data', function() {
	return gulp.src(dataDir + '**/*.xml')
	             .pipe(replace('xmlns:tei','xmlns'))
		.pipe(newer(dataDest))
		.pipe(gulp.dest(dataDest));
});

gulp.task('build', ['data','copy']);


// ------ Deploy build dir to eXist ----------

var localExist = exist.createClient({
		host: "localhost",
		port: 8080,
		path: "/exist/xmlrpc",
		basic_auth: secrets.local
		// permissions: {
		// 	"controller.xql": "rwxr-xr-x"
		// },
		// mime_types: {
		// 	'.rng': "text/xml"
		// }
	});

var remoteExist = exist.createClient({
		host: "papyri.uni-koeln.de",
		port: 8080,
		path: "/xmlrpc",
		basic_auth: secrets.remote
		// permissions: {
		// 	"controller.xql": "rwxr-xr-x"
		// },
		// mime_types: {
		// 	'.rng': "text/xml"
		// }
});

exist.defineMimeTypes({ 'text/xml': ['rng'] });

var permissions = { 'controller.xql': 'rwxr-xr-x' };


gulp.task('deploy-local', ['build'], function() {

	return gulp.src(buildDest + '**/*', {base: buildDest})
		.pipe(localExist.newer({target: "/db/apps/coerp_new/"}))
		.pipe(localExist.dest({
			target: "/db/apps/coerp_new",
			permissions: permissions
		}));
});

gulp.task('remote-upload', ['build'], function() {

	return gulp.src(buildDest + '**/*', {base: buildDest})
		.pipe(remoteExist.newer({target: "/db/apps/coerp_new"}))
		.pipe(remoteExist.dest({
			target: "/db/apps/coerp_new",
			permissions: permissions
		}));
});

gulp.task('remote-post-install', ['remote-upload'], function() {
	return gulp.src('scripts/post-deploy.xql')
		.pipe(remoteExist.query());
});

gulp.task('deploy-remote', ['remote-upload', 'remote-post-install']);




// ------ Update Index ----------

gulp.task('upload-index-conf', function(){
	return gulp.src('collection/texts_collection.xconf')
	                       .pipe(rename('collection.xconf'))
			.pipe(localExist.dest({target: "/db/system/config/db/apps/coerp_new/data/texts"}));
});

gulp.task('update-index', ['upload-index-conf'], function() {
	return gulp.src('scripts/reindex.xql')
			.pipe(localExist.query());
});

gulp.task('upload-index-conf-remote', function(){
	return gulp.src('collection.xconf')
	                        .pipe(rename('collection.xconf'))
			.pipe(remoteExist.dest({target: "/db/system/config/db/apps/coerp_new/data/texts"}));
});

gulp.task('update-index-remote', ['upload-index-conf-remote'], function() {
	return gulp.src('scripts/reindex.xql')
			.pipe(remoteExist.query());
});



// ------ Make eXist XAR Package ----------


gulp.task('xar', ['build'], function() {
	var p = require('./package.json');

	return gulp.src(buildDest + '**/*', {base: buildDest})
			.pipe(zip("papyri-wl" + p.version + ".xar"))
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
	.pipe(localExist.dest({target: "/db/apps/coerp_new"}))
});

gulp.task('watch-copy', function() {
	gulp.watch([
				sourceDir + '**/*'
				], ['copy']);
});



gulp.task('watch', ['watch-copy', 'watch-main']);