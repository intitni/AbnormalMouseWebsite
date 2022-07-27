module.exports = {
  content: ['Sources/**/*.swift'],
  theme: {
    extend: {
        colors: {
            'footer': '#f2f2f2',
        },
    },
  },
  plugins: [require('@tailwindcss/typography')],
}
