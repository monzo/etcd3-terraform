const path = require('path');

module.exports = {
    target: 'node',
    entry: [
        'babel-polyfill',
        './src/dns.js'
    ],
    output: {
        filename: 'bundle.js',
        path: path.resolve(__dirname, 'dist')
    },
    module: {
        loaders: [
            {
                loader: "babel-loader",
                include: [path.resolve(__dirname, "src")],
                test: /\.jsx?$/,
                query: {
                    plugins: ['transform-runtime'],
                    presets: ['es2017', 'stage-0']
                }
            },
        ]
    }
};
