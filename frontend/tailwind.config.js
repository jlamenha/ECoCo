/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        ecoco: {
          dark:   '#2a6632',
          light:  '#f0f7ee',
          mid:    '#c8dfc4',
          accent: '#7ecb6a',
          black:  '#141f14',
        },
      },
      fontFamily: {
        syne: ['Syne', 'sans-serif'],
      },
    },
  },
  plugins: [],
}