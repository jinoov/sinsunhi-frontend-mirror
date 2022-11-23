module Fragment = %relay(`
  fragment PDPMatching2BuyableProducts_fragment on MatchingProduct {
    category {
      id
      name
      parent {
        products(
          onlyBuyable: true
          statuses: [SALE]
          type: [NORMAL, QUOTABLE]
          first: 30
          orderBy: { field: UPDATED_AT, direction: DESC }
        ) {
          edges {
            node {
              id
              status
              number
              displayName
              image {
                thumb400x400
              }
              ... on NormalProduct {
                price
              }
              ... on QuotableProduct {
                price
              }
            }
          }
        }
      }
    }
  }
`)

let renderProduct = (
  product: PDPMatching2BuyableProducts_fragment_graphql.Types.fragment_category_parent_products_edges_node,
) => {
  let bgUrl = "url('" ++ product.image.thumb400x400 ++ "')"
  <Next.Link key={product.id} href={`/products/${product.number->Int.toString}`}>
    <a>
      // Image container
      // Arbitrary value for the background URL doesn't work.
      // To keep the ratio of the thumbnail, a 100% length of the padding has been set to the DIV.
      <div
        className="w-full mb-3 pt-[100%] bg-center bg-contain bg-no-repeat rounded bg-slate-100"
        style={ReactDOMStyle.make(~backgroundImage=bgUrl, ())}
      />
      <div className="text-sm text-gray-700"> {product.displayName->React.string} </div>
      {switch product.price {
      | Some(price) =>
        <div className="font-semibold text-lg">
          {(price->Locale.Int.show ++ "원")->React.string}
        </div>
      | None => React.null
      }}
    </a>
  </Next.Link>
}

@react.component
let make = (~query, ~separator) => {
  let {category: {parent}} = query->Fragment.use

  // Should show a message for no products?
  switch parent {
  | Some({products}) =>
    if products.edges->Array.length > 0 {
      <>
        {separator}
        <div className="mb-8">
          <div className="mb-6 font-semibold text-lg">
            {`즉시 구매 가능한 상품`->React.string}
          </div>
          <div className="grid grid-cols-2 sm:grid-cols-4 md:grid-cols-5 gap-4 gap-y-6">
            {products.edges
            ->Array.map(({node}) => {
              node->renderProduct
            })
            ->React.array}
          </div>
        </div>
      </>
    } else {
      React.null
    }

  | None => React.null
  }
}
