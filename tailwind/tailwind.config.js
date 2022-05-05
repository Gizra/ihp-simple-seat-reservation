const plugin = require('tailwindcss/plugin');

module.exports = {
    mode: 'jit',
    theme: {
        extend: {
        },
    },
    content: [
        "Web/View/**/*.hs",
    ],
    safelist: [
        // Add custom class names.
        // https://tailwindcss.com/docs/content-configuration#safelisting-classes
    ],
    plugins: [
        require('@tailwindcss/forms'),
    ],
};