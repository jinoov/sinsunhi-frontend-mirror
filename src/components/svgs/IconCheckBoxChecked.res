@react.component
let make = (~width="20", ~height="20") =>
  <svg width height viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg">
    <rect x="0.5" y="0.5" width="19" height="19" rx="4.5" fill="#12B564" stroke="#12B564" />
    <path
      fillRule="evenodd"
      clipRule="evenodd"
      d="M16.6783 5.2652C17.0841 5.63981 17.1094 6.27246 16.7348 6.67829L9.35019 14.6783C9.16089 14.8834 8.89449 15 8.61539 15C8.33629 15 8.06989 14.8834 7.88059 14.6783L3.2652 9.67829C2.8906 9.27246 2.9159 8.63981 3.32172 8.2652C3.72755 7.8906 4.3602 7.9159 4.73481 8.32172L8.61539 12.5257L15.2652 5.32172C15.6398 4.9159 16.2725 4.8906 16.6783 5.2652Z"
      fill="white"
    />
  </svg>