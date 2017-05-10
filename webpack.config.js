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
		path: path.join(__dirname, 'dist'),
		filename: "index.bundle.js"
	},
    plugins: [
		new ExtractTextPlugin("Gdip2.ahk"),
		new OnBuildPlugin(function() {
			var bundlePath = path.join(__dirname, 'dist', 'index.bundle.js');
			if (fs.existsSync(bundlePath)) {
				fs.unlinkSync(bundlePath);
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