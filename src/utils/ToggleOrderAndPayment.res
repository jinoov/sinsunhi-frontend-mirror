/*
  삭제 예정 기능
  장바구니 배포에 전,후로 주문-결제 기능을 차단하기위해 임시로 만들었습니다.
  현재 환경변수로 핸들링 되고 있지만, 추후 서버에서 내려준 값에 의존하여 핸들링되어야 합니다.
*/

let use = () => {
  let user = CustomHooks.User.Buyer.use2()
  let toggleButtonAvailable = switch Env.toggleOrderButton {
  | "OFF" => false
  | _ => true
  // 환경 변수가 잘 못 기입된 상황에서는 true
  }
  let adminUsers =
    Env.orderAdmins
    ->Js.String2.match_(%re("/[\w@.]+/g"))
    ->Option.mapWithDefault([], arr => arr->Array.keepMap(i => i->Option.flatMap(Int.fromString)))

  switch toggleButtonAvailable {
  | true => true
  | false =>
    switch user {
    | Unknown => false
    | NotLoggedIn => false
    | LoggedIn(user') =>
      switch adminUsers->Garter_Array.getBy(id => id == user'.id) {
      | Some(_) => true
      | None => false
      }
    }
  }
}
