module Query = %relay(`
  query RfqPurchasesTabsAdminQuery {
    categories {
      id
      name
    }
  }
`)

module Spec = {
  type departmentType =
    | All // 전체
    | Agriculture // 농산
    | Meat // 축산
    | Seafood // 수산

  type department = {
    originId: string,
    originName: string,
    department: departmentType,
    label: string,
  }

  let fromCategory = (~id, ~name) => {
    if name == `농산물` {
      {
        originId: id,
        originName: name,
        department: Agriculture,
        label: `농산`,
      }->Some
    } else if name == `축산물` {
      {
        originId: id,
        originName: name,
        department: Meat,
        label: `축산`,
      }->Some
    } else if name == `수산물/건수산` {
      {
        originId: id,
        originName: name,
        department: Seafood,
        label: `수산`,
      }->Some
    } else {
      None
    }
  }

  let toString = department => {
    switch department {
    | All => "all"
    | Agriculture => "agriculture"
    | Meat => "meat"
    | Seafood => "seafood"
    }
  }
}

let set = (dict, k, v) => {
  let new = dict
  new->Js.Dict.set(k, v)
  new
}

module Skeleton = {
  @react.component
  let make = () => {
    <ol className=%twc("w-full px-2 border-b border-[#EDEFF2] flex items-center text-text-L1")>
      <li className=%twc("mx-2 p-2 border-b-2 border-text-L1")>
        <button className=%twc("font-bold")> {`전체`->React.string} </button>
      </li>
      <li className=%twc("mx-2 p-2 text-disabled-L1")>
        <button> {`농산`->React.string} </button>
      </li>
      <li className=%twc("mx-2 p-2 text-disabled-L1")>
        <button> {`축산`->React.string} </button>
      </li>
      <li className=%twc("mx-2 p-2 text-disabled-L1")>
        <button> {`수산`->React.string} </button>
      </li>
    </ol>
  }
}

@react.component
let make = () => {
  let {useRouter, push} = module(Next.Router)
  let router = useRouter()
  let current = router.query->Js.Dict.get("category-id")->Option.getWithDefault("")

  let {categories} = Query.use(~variables=(), ())
  let departments = categories->Array.keepMap(({id, name}) => Spec.fromCategory(~id, ~name))

  let selectedStyle = %twc("mx-2 p-2 border-b-2 border-text-L1 font-bold cursor-pointer")
  let unselectedStyle = %twc("mx-2 p-2 text-disabled-L1 cursor-pointer")

  <ol className=%twc("w-full px-2 border-b border-[#EDEFF2] flex items-center text-text-L1")>
    <li
      className={current == "" ? selectedStyle : unselectedStyle}
      onClick={_ => router->push(`${router.pathname}?catetory-id=`)}>
      {`전체`->React.string}
    </li>
    {departments
    ->Array.map(({originId, label}) => {
      <li
        key=originId
        className={current == originId ? selectedStyle : unselectedStyle}
        onClick={_ => {
          router->push(`${router.pathname}?category-id=${originId}`)
        }}>
        {label->React.string}
      </li>
    })
    ->React.array}
  </ol>
}
