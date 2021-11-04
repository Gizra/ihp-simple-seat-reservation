const plugin = require('tailwindcss/plugin');

module.exports = {
    mode: 'jit',
    theme: {
        extend: {},
    },
    purge: {
        content: [
            "../Web/View/**/*.hs",
        ],
        options: {
            safelist: [
                // Add here custom class names. Since we're using TW's jit (Just-In-
                // Time), `safelist` must be full class names, and not regex.
            ],
        },
    },
    plugins: [
        require('@tailwindcss/forms'),
    ],
};