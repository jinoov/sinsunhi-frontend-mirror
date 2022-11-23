module PhoneNumberConfig = {
  type t = string
  let key = "SS_PHONENUMBER"
  let fromString = Garter.Fn.identity
  let toString = value => value
}

module BuyerEmailConfig = {
  type t = string
  let key = "SS_BUYER_EMAIL"
  let fromString = Garter.Fn.identity
  let toString = value => value
}

module EmailAdminConfig = {
  type t = string
  let defaultValue = ""
  let key = "SS_EMAIL_ADMIN"
  let fromString = Garter.Fn.identity
  let toString = value => value
}

module AdminMenuConfig = {
  @spice
  type t = array<string>

  let key = "SS_ADMIN_MENU"
  let fromString = str =>
    try {
      str->Js.Json.parseExn->t_decode->Result.getExn
      // Result.getExn()
    } catch {
    | _ => []
    }

  let toString = arr => arr->t_encode->Js.Json.stringify
}

module AccessTokenConfig = {
  type t = string
  let key = "SS_ACCESS_TOKEN"
  let fromString = Garter.Fn.identity
  let toString = value => value
}

module RefreshTokenConfig = {
  type t = string
  let key = "SS_REFRESH_TOKEN"
  let fromString = Garter.Fn.identity
  let toString = value => value
}

module BuyerInfoConfig = {
  type t = string
  let key = "SS_BUYER_INFO_LAST_SHOWN"
  let fromString = Garter.Fn.identity
  let toString = value => value
}

module RecentSearchKeywordConfig = {
  @spice
  type t = Js.Dict.t<string>
  let key = "SS_RECENT_SEARCH_KEYWORD"
  let fromString = str =>
    try {
      str->Js.Json.parseExn->t_decode->Result.getExn
    } catch {
    | _ => Js.Dict.empty()
    }

  let toString = (value: t) => value->t_encode->Js.Json.stringify
}

module PhoneNumber = LocalStorage.Make(PhoneNumberConfig)

module BuyerEmail = LocalStorage.Make(BuyerEmailConfig)

module EmailAdmin = LocalStorage.Make(EmailAdminConfig)

module AdminMenu = LocalStorage.Make(AdminMenuConfig)

module AccessToken = LocalStorage.Make(AccessTokenConfig)

module RefreshToken = LocalStorage.Make(RefreshTokenConfig)

module BuyerInfoLastShown = LocalStorage.Make(BuyerInfoConfig)

module RecentSearchKeyword = LocalStorage.Make(RecentSearchKeywordConfig)
