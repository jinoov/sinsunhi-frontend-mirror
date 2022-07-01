@react.component
let make = (~height, ~width, ~className=?) =>
  <svg
    width
    height
    viewBox="0 0 16 17"
    fill="none"
    xmlns="http://www.w3.org/2000/svg"
    className={className->Option.getWithDefault("")}>
    <path
      fillRule="evenodd"
      clipRule="evenodd"
      d="M8 16.5C12.4183 16.5 16 12.9183 16 8.5C16 4.08172 12.4183 0.5 8 0.5C3.58172 0.5 0 4.08172 0 8.5C0 12.9183 3.58172 16.5 8 16.5ZM10.9593 5.07134L11.7618 5.87946L8.95312 8.70781L11.7619 11.5363L10.9594 12.3444L8.15063 9.51593L5.34184 12.3444L4.53935 11.5363L7.34814 8.70781L4.5395 5.87946L5.34199 5.07134L8.15063 7.89969L10.9593 5.07134Z"
      fill="#DADCDF"
    />
  </svg>
