@module("../../../public/images/empty-gray-square-sm-3x.png")
external placeholderSm: string = "default"

@module("../../../public/images/empty-gray-square-lg-3x.png")
external placeholderLg: string = "default"

module Placeholder = {
  type t =
    | Sm
    | Lg

  let getSrc = t => {
    switch t {
    | Sm => placeholderSm
    | Lg => placeholderLg
    }
  }
}

module Loading = {
  type t =
    | Eager // default
    | Lazy // lazy loading

  let encode = t => {
    switch t {
    | Eager => "eager"
    | Lazy => "lazy"
    }
  }
}

module MakeImage = {
  @deriving({abstract: light})
  type imageProps = {
    src: string,
    onError: ReactEvent.Media.t => unit,
    @optional className: string,
    @optional alt: string,
    @optional loading: string,
  }

  let defaultImage = Placeholder.Sm->Placeholder.getSrc

  @react.component
  let make = (
    ~src=defaultImage,
    ~placeholder=Placeholder.Sm,
    ~loading=Loading.Eager,
    ~alt=?,
    ~className=?,
  ) => {
    let (source, setSource) = React.Uncurried.useState(_ => src)

    let props = imageProps(
      ~src=source,
      ~loading={loading->Loading.encode},
      ~onError={_ => setSource(._ => placeholder->Placeholder.getSrc)},
      ~className?,
      ~alt?,
      (),
    )

    <ReactUtil.SpreadProps props>
      <img />
    </ReactUtil.SpreadProps>
  }
}

// src가 갱신되었을 때 반응하도록 하기 위해 한번 감싸서 key=src 적용
@react.component
let make = (~src=?, ~placeholder=?, ~loading=?, ~alt=?, ~className=?) => {
  <MakeImage key={src->Option.getWithDefault("")} ?src ?placeholder ?className ?alt ?loading />
}
