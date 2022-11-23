// 매칭 상품 PDP의 PC 화면에 대응하기 위한 컴포넌트입니다.
// 추후 매칭상품 PDP PC 화면이 나오게 될 경우, 이 컴포넌트를 삭제해야 합니다.

module Like_Mutation = %relay(`
  mutation PDPLikeButtonMO_Like_Mutation($input: LikeProductInput!) {
    likeProduct(input: $input) {
      __typename
      ... on LikeProductResult {
        product {
          id
          name
          viewerHasLiked
        }
      }
      ... on Error {
        code
        message
      }
    }
  }
`)

module UnLike_Mutation = %relay(`
  mutation PDPLikeButtonMO_Unlike_Mutation($input: UnlikeProductInput!) {
    unlikeProduct(input: $input) {
      __typename
      ... on UnlikeProductResult {
        product {
          id
          name
          viewerHasLiked
        }
      }
      ... on Error {
        code
        message
      }
    }
  }
`)

@module("../../../../../public/assets/check-fill-circle.svg")
external checkFillCircleIcon: string = "default"

@module("../../../../../public/assets/error-fill-circle.svg")
external errorFillCircleIcon: string = "default"

module Skeleton = {
  @react.component
  let make = () => {
    <div className=%twc("w-14 h-14 xl:w-16 xl:h-16 animate-pulse rounded-xl bg-gray-100") />
  }
}

@react.component
let make = (~query) => {
  let router = Next.Router.useRouter()
  let (likeMutate, isLikeMutating) = Like_Mutation.use()
  let (unlikeMutate, isUnlikeMutating) = UnLike_Mutation.use()
  let user = CustomHooks.Auth.use()
  let {id, viewerHasLiked} = query->PDP_Like_Button.Fragment.use
  let {addToast} = ReactToastNotifications.useToasts()
  let (showLoginDialog, setShowLoginDialog) = React.Uncurried.useState(_ => Dialog.Hide)

  let productId = router.query->Js.Dict.get("pid")

  let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)
  let like = viewerHasLiked->Option.getWithDefault(false)
  let (userActioned, setUserActioned) = React.Uncurried.useState(_ => false)

  let handleOnClick = _ => {
    switch like {
    | false =>
      likeMutate(
        ~variables=Like_Mutation.makeVariables(~input={id: id}),
        ~onCompleted=({likeProduct}, _) => {
          switch likeProduct {
          | #LikeProductResult(_) => {
              addToast(.
                <div className=%twc("flex items-center")>
                  <Image
                    loading=Image.Loading.Lazy
                    src=checkFillCircleIcon
                    className=%twc("h-6 w-6 mr-2")
                  />
                  {`찜한 상품에 추가했어요.`->React.string}
                </div>,
                {appearance: "success"},
              )
              setUserActioned(._ => true)
            }

          | #Error(error) =>
            addToast(.
              <div className=%twc("flex items-center")>
                <Image
                  loading=Image.Loading.Lazy src=errorFillCircleIcon className=%twc("h-6 w-6 mr-2")
                />
                {error.message->Option.getWithDefault("")->React.string}
              </div>,
              {appearance: "error"},
            )
          | #UnselectedUnionMember(_) => ()
          }
        },
        ~onError={
          err => {
            addToast(.
              <div className=%twc("flex items-center")>
                <IconCheck height="24" width="24" fill="#12B564" className=%twc("mr-2") />
                {err.message->React.string}
              </div>,
              {appearance: "error"},
            )
          }
        },
        (),
      )->ignore
    | true =>
      unlikeMutate(
        ~variables=UnLike_Mutation.makeVariables(~input={id: id}),
        ~onCompleted=({unlikeProduct}, _) => {
          switch unlikeProduct {
          | #UnlikeProductResult(_) => {
              addToast(.
                <div className=%twc("flex items-center")>
                  {`찜한 상품에서 삭제했어요 .`->React.string}
                </div>,
                {appearance: "success"},
              )
              setUserActioned(._ => true)
            }

          | #Error(error) =>
            addToast(.
              <div className=%twc("flex items-center")>
                <Image
                  loading=Image.Loading.Lazy src=errorFillCircleIcon className=%twc("h-6 w-6 mr-2")
                />
                {error.message->Option.getWithDefault("")->React.string}
              </div>,
              {appearance: "error"},
            )
          | #UnselectedUnionMember(_) => ()
          }
        },
        ~onError={
          err => {
            addToast(.
              <div className=%twc("flex items-center")>
                <Image
                  loading=Image.Loading.Lazy src=errorFillCircleIcon className=%twc("h-6 w-6 mr-2")
                />
                {err.message->React.string}
              </div>,
              {appearance: "error"},
            )
          }
        },
        (),
      )->ignore
    }
  }

  React.useEffect0(() => {
    setIsCsr(._ => true)
    None
  })

  React.useEffect1(_ => {
    setUserActioned(._ => false)
    None
  }, [productId])

  //초기 렌더시에 좋아요 스타일이 적용되는 것과, 사용자가 사용자가 찜하기 버튼을 눌렀을 때의 스타일이 적용되는 것을 구분하기 위해
  //userActioned라는 state를 만들어서 구분하였다.
  let likeStyle = switch (like, userActioned) {
  | (true, false) => "pdp-liked"
  | (true, true) => "pdp-like-action"
  | (false, false) => "pdp-disliked"
  | (false, true) => "pdp-dislike-action"
  }

  //Fixme: Skeleton & Error Scenario
  <RescriptReactErrorBoundary fallback={_ => <Skeleton />}>
    {switch isCsr {
    | true =>
      switch user {
      //로그인을 하지 않으면 찜하기를 눌렀을 때 로그인 모달을 보여준다.
      | LoggedIn(_) =>
        <button
          type_="button"
          onClick=handleOnClick
          disabled={isLikeMutating || isUnlikeMutating}
          className=%twc(
            "w-14 h-14 bg-gray-100 rounded-xl flex justify-center items-center cursor-pointer"
          )>
          <IconHeart className={Cn.make([likeStyle, %twc("w-8 h-8 cursor-pointer")])} />
        </button>
      | _ =>
        <>
          <button
            onClick={_ => setShowLoginDialog(._ => Dialog.Show)}
            type_="button"
            className=%twc(
              "w-14 h-14 xl:w-16 xl:h-16 bg-gray-100 rounded-xl flex justify-center items-center cursor-pointer"
            )>
            <IconHeart
              className={Cn.make(["pdp-dislike-action", %twc("w-8 h-8 cursor-pointer")])}
            />
          </button>
          <Dialog
            boxStyle=%twc("text-center rounded-2xl")
            isShow={showLoginDialog}
            textOnCancel={`취소`}
            textOnConfirm={`로그인`}
            kindOfConfirm=Dialog.Positive
            onConfirm={_ => {
              router->Next.Router.push(
                `/buyer/signin?redirect=/products/${productId->Option.getWithDefault("")}`,
              )
              setShowLoginDialog(._ => Dialog.Hide)
            }}
            onCancel={_ => setShowLoginDialog(._ => Dialog.Hide)}>
            <p className=%twc("whitespace-pre")>
              {`로그인 후에.\n견적을 받으실 수 있습니다.`->React.string}
            </p>
          </Dialog>
        </>
      }
    | false => <Skeleton />
    }}
  </RescriptReactErrorBoundary>
}
