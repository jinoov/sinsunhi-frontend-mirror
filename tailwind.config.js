const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
  mode: "jit",
  purge: {
    content: ["./src/**/*.res"],
    options: {
      safelist: ["html", "body"],
    },
  },
  darkMode: false, // or 'media' or 'class'
  theme: {
    screens: {
      xs: "360px",
      sm: "640px",
      md: "768px",
      lg: "1024px",
      xl: "1280px",
      "2xl": "1536px",
      "plp-max": "1612px",
      "h-lg": { raw: "(min-height: 900px)" },
    },
    extend: {},
    /* Most of the time we customize the font-sizes,
     so we added the Tailwind default values here for
     convenience */
    fontSize: {
      "2xs": ".625rem",
      xs: ".75rem",
      sm: ".875rem",
      base: "1rem",
      lg: "1.125rem",
      xl: "1.25rem",
      "2xl": "1.5rem",
      "3xl": "1.875rem",
      "4xl": "2.25rem",
      "5xl": "3rem",
      "6xl": "4rem",
    },
    /* We override the default font-families with our own default prefs  */
    fontFamily: {
      sans: [
        "Pretendard",
        "-apple-system",
        "BlinkMacSystemFont",
        "Helvetica Neue",
        "Arial",
        "sans-serif",
      ],
      serif: [
        "Georgia",
        "-apple-system",
        "BlinkMacSystemFont",
        "Helvetica Neue",
        "Arial",
        "sans-serif",
      ],
      mono: [
        "Menlo",
        "Monaco",
        "Consolas",
        "Roboto Mono",
        "SFMono-Regular",
        "Segoe UI",
        "Courier",
        "monospace",
      ],
    },
    minWidth: {
      "4/5": "80%",
      "1/2": "50%",
      "1/3": "33.33%",
      "1/4": "25%",
      "1/5": "20%",
      ...defaultTheme.minWidth,
    },
    extend: {
      colors: {
        "blue-gray": {
          700: "#3F4C65",
        },
        gray: {
          900: "#121212",
          800: "#262626",
          700: "#4c4c4c",
          600: "#727272",
          500: "#999999",
          400: "#b2b2b2",
          300: "#cccccc",
          250: "#d9d9d9",
          200: "#e5e5e5",
          150: "#ececec",
          100: "#f2f2f2",
          50: "#f7f7f7",
        },
        green: {
          1000: "#63CC73",
          900: "#03564e",
          800: "#056855",
          700: "#09825e",
          600: "#0d9b63",
          500: "#12b564",
          400: "#44d27d",
          300: "#7aea9c",
          250: "#8ef2a6",
          200: "#a8f8b8",
          150: "#c3fbc9",
          100: "#d5fcd9",
          50: "#ebfded",
        },
        yellow: {
          900: "#8c6400",
          800: "#ae8000",
          700: "#d09e00",
          600: "#f3be00",
          500: "#ffc93e",
          400: "#fee55b",
          300: "#feed7c",
          200: "#fef4a7",
          100: "#fefad3",
          50: "#f2f6fe",
        },
        red: {
          900: "#7a0836",
          800: "#930d37",
          700: "#b7153a",
          600: "#db1f39",
          500: "#ff2b35",
          400: "#ff6660",
          300: "#ff907f",
          250: "#ffae9b",
          200: "#ffc6b7",
          150: "#ffdace",
          100: "#ffeae1",
          50: "#fff6f2",
        },
        blue: {
          900: "#07155e",
          800: "#0c1f71",
          700: "#132d8d",
          600: "#1c3ea8",
          500: "#2751c4",
          400: "#577edb",
          300: "#7ba0ed",
          250: "#9dbaf8",
          200: "#bad0fb",
          150: "#dce8fd",
          100: "#dce8fd",
          50: "#f2f6fe",
        },
        orange: {
          500: "#ff5735",
        },
        primary: "#12b564",
        "primary-variant": "#0d9b63",
        secondary: "#fed925",
        "secondary-variant": "#f3be00",
        background: "#ffffff",
        "bg-pressed-L1": "#f7f7f7",
        "bg-pressed-L2": "#ececec",
        surface: "#f7f7f7",
        default: "#262626",
        emphasis: "#ff2b35",
        lower: "#2751c4",
        inverted: "#ffffff",
        "border-active": "#262626",
        "border-default-L1": "#cccccc",
        "border-default-L2": "#ececec",
        "border-disabled": "#f2f2f2",
        "div-border-L1": "#d9d9d9",
        "div-border-L2": "#e5e5e5",
        "div-border-L3": "#F2F2F2",
        "div-shape-L1": "#f2f2f2",
        "div-shape-L2": "#f7f7f7",
        "enabled-L1": "#262626",
        "enabled-L2": "#727272",
        "enabled-L3": "#999999",
        "enabled-L4": "#b2b2b2",
        "enabled-L5": "#f2f2f2",
        "bg-pressed": "#f7f7f7",
        "disabled-L1": "#b2b2b2",
        "disabled-L2": "#cccccc",
        "disabled-L3": "#f2f2f2",
        "text-L1": "#262626",
        "text-L2": "#727272",
        "text-L3": "#999999",
        notice: "#ff2b35",
        "notice-variant": "#db1f39",
        "primary-light": "#ebfded",
        "primary-light-variant": "#d5fcd9",
        "btn-gb-L2": "#ececec",
        dummy: "#cccccc",
        dim: "rgba(0, 0, 0, 0.5)",
      },
      boxShadow: {
        tooltip: "0 4px 4px rgba(59, 189, 90, 0.08)",
        "card-box": "0 4px 16px rgba(0,0,0,0.05)",
        pane:"0px 10px 40px 10px rgba(0,0,0,0.03)"
      },
      width: {
        18: "4.5rem",
        23: "5.75rem",
      },
      width: {
        18: "4.5rem",
        23: "5.75rem",
      },
      height: {
        13: "3.25rem",
        18: "4.5rem",
        31: "7.75rem",
      },
      lineHeight: {
        4.5: "1.125rem",
      },
    },
  },
  variants: {
    width: ["responsive"],
    fontWeight: ["hover", "focus"],
    brightness: ["hover", "focus"],
    borderWidth: ["responsive", "focus"],
  },
  plugins: [
    require("@tailwindcss/line-clamp"),
    require("tailwind-scrollbar-hide"),
    function ({ addVariant }) {
      addVariant("children", "& > *");
      addVariant("state-checked", '&[data-state="checked"]');
      addVariant("state-open", '&[data-state="open"]');
      addVariant("state-active", '&[data-state="active"]');
    },
  ],
};
