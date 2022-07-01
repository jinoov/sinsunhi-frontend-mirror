@react.component
let make = (~height, ~width, ~fill, ~className=?) =>
  <svg width height viewBox="0 0 20 20" fill xmlns="http://www.w3.org/2000/svg" ?className>
    <path
      d="M17.2564 3.33301H2.68457V7.56404H17.2564V3.33301Z"
      fill="#262626"
      stroke="#262626"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
    <path
      d="M6.99453 9.58496H2.68457V16.4998H6.99453V9.58496Z"
      fill="#262626"
      stroke="#262626"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
    <path
      d="M17.2564 9.58496H9.00488V16.4998H17.2564V9.58496Z"
      fill="#262626"
      stroke="#262626"
      strokeLinecap="round"
      strokeLinejoin="round"
    />
  </svg>
