const colors = require('tailwindcss/colors');

module.exports = {
  content: ["./views/**/*.tx", "./public/**/*.html"],
  theme: {
    extend: {
      colors: {
        primary: colors.sky,
        secondary: colors.amber,
      },
    },
    minWidth: {
      'admin': '1024px',
      'full': '100%',
      '16': '16rem',
    },
  },
  plugins: [],
  safelist: [
    'text-sm',
    'bg-white',
    'focus:bg-white',
    'bg-cyan-600',
    'bg-indigo-600',
    'bg-orange-600',
    'bg-pink-600',
    'hover:bg-cyan-500',
    'appearance-none',
    'w-full',
    'h-full',
    'rounded-l',
    'rounded-r',
    'border',
    'border-t',
    'border-r',
    'border-b',
    'sm:border',
    'md:border',
    'focus:border-l',
    'focus:border-r',
    'sm:rounded-r-none',
    'sm:border-r-0',
    'border-gray-400',
    'focus:border-gray-500',
    'block',
    'text-gray-700',
    'focus:text-gray-700',
    'h-2',
    'h-4',
    'h-8',
    'w-2',
    'w-4',
    'w-8',
    'py-2',
    'px-4',
    'pl-8',
    'pr-6',
    'pr-8',
    'leading-tight',
    'focus:outline-none',
    'placeholder-gray-400',
    'focus:placeholder-gray-600',
  ],
}
