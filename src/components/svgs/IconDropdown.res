@react.component
let make = (~width, ~height, ~className=?) =>
  <svg width height viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg" ?className>
    <path
      d="M2.66666 6L7.99999 11.3333L13.3333 6"
      stroke="#FF2B35"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
  </svg>