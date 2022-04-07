module.exports = {
    entry: './src/main.js',
    mode: 'development',
    output: {
        path: `${__dirname}/public/js`,
        filename: 'bundle.js',
    },
};