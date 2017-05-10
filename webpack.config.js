const path = require('path');
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const fs = require('fs');

function OnBuildPlugin(callback) {
	this.callback = callback;
	this.apply = function(compiler) {
		compiler.plugin('done', this.callback);
	};
};

module.exports = {
	entry: "./index.js",
	output: {
		path: path.join(__dirname, 'build'),
		filename: "index.bundle.js"
	},
    plugins: [
		new ExtractTextPlugin("Gdip2.ahk"),
		new OnBuildPlugin(function() {
			var build = path.join(__dirname, 'build', 'index.bundle.js');
			if (fs.existsSync(build)) {
				fs.unlinkSync(build);
			}
		})		
    ],
	module: {
		loaders: [{
			test: /\.ahk$/,
			exclude: /node_modules/,
			use: ExtractTextPlugin.extract({
                use: [{
                    loader: 'ahk-loader'
                }]
			})
		}]
	}
}