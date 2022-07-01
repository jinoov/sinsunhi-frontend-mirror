@react.component
let make = (~height, ~width, ~fill, ~className=?) =>
  <svg width height viewBox="0 0 20 20" fill xmlns="http://www.w3.org/2000/svg" ?className>
    <path
      d="M13.4213 10.4036C13.6165 10.2084 13.6165 9.89179 13.4213 9.69653L13.2451 9.5203C13.0498 9.32504 12.7332 9.32504 12.538 9.5203L8.82484 13.2334L7.41172 11.8203C7.21646 11.625 6.89988 11.625 6.70462 11.8203L6.52839 11.9965C6.33313 12.1918 6.33313 12.5084 6.52839 12.7036L8.47128 14.6465C8.66655 14.8418 8.98313 14.8418 9.17839 14.6465L13.4213 10.4036ZM16.6665 3.33341H15.8332V2.16675C15.8332 1.89061 15.6093 1.66675 15.3332 1.66675H14.6665C14.3904 1.66675 14.1665 1.89061 14.1665 2.16675V3.33341H5.83317V2.16675C5.83317 1.89061 5.60931 1.66675 5.33317 1.66675H4.6665C4.39036 1.66675 4.1665 1.89061 4.1665 2.16675V3.33341H3.33317C2.40817 3.33341 1.67484 4.08341 1.67484 5.00008L1.6665 16.6667C1.6665 17.5834 2.40817 18.3334 3.33317 18.3334H16.6665C17.5832 18.3334 18.3332 17.5834 18.3332 16.6667V5.00008C18.3332 4.08341 17.5832 3.33341 16.6665 3.33341ZM16.6665 16.6667H3.33317V7.50008H16.6665V16.6667Z"
      fill
    />
  </svg>
