type kind = Seller | Buyer | AfterPay | Admin
external unsafeToBlob: Webapi.File.t => Fetch.blob = "%identity"
external makeJsPromiseError: string => Js.Promise.error = "%identity"

@spice
type responseData = {url: string}
@spice
type response = {
  message: string,
  data: responseData,
}

let upload = (~userId=?, ~kind, ~file, ~onSuccess, ~onFailure, ()) => {
  open FetchHelper

  let filename = file->Webapi.File.name

  let url = switch (userId, kind) {
  | (Some(userId'), Seller) =>
    `${Env.restApiUrl}/order/delivery/upload-url?file-name=${filename}&user-id=${userId'}`
  | (None, Seller) => `${Env.restApiUrl}/order/delivery/upload-url?file-name=${filename}`
  | (Some(userId'), Buyer) =>
    `${Env.restApiUrl}/order/upload-url?file-name=${filename}&user-id=${userId'}`
  | (Some(userId'), AfterPay) =>
    `${Env.restApiUrl}/order/upload-url?file-name=${filename}&user-id=${userId'}&pay-type=AFTER_PAY`
  | (None, AfterPay) =>
    `${Env.restApiUrl}/order/upload-url?file-name=${filename}&pay-type=AFTER_PAY`
  | (None, Buyer) => `${Env.restApiUrl}/order/upload-url?file-name=${filename}`
  | (Some(userId'), Admin) =>
    `${Env.restApiUrl}/offlineOrder/upload-url?file-name=${filename}&user-id=${userId'}`
  | (None, Admin) => `${Env.restApiUrl}/offline-order/upload-url?file-name=${filename}`
  }

  // GET the S3 presigned-url first
  fetchWithRetry(~fetcher=getWithToken, ~url, ~body=Js.Nullable.undefined, ~count=3)
  |> Js.Promise.then_(json => {
    switch json->response_decode {
    | Ok(response) =>
      // PUT file to the presigned-url
      fetchWithRetry(
        ~fetcher=putWithFile,
        ~url=response.data.url,
        ~body=file->unsafeToBlob,
        ~count=3,
      )
      |> Js.Promise.then_(res => Js.Promise.resolve(res->onSuccess))
      |> Js.Promise.catch(err => Js.Promise.resolve(err->onFailure))
    | Error(err) =>
      err->Js.Console.log
      Js.Promise.resolve(makeJsPromiseError(err.message)->onFailure)
    }
  })
  |> Js.Promise.catch(err => {
    err->Js.Console.log
    Js.Promise.resolve(err->onFailure)
  })
}

@spice
type responseDataBulkSale = {url: string, path: string}

let uploadBulkSale = (~file, ~farmmorningUserId, ~onSuccess, ~onFailure, ()) => {
  open FetchHelper

  let filename = file->Webapi.File.name

  let url = `${Env.restApiUrl}/farmmorning-bridge/api/bulk-sale/product-sale-ledger/issue-s3-put-url?filename=${filename}&farmmorning-user-id=${farmmorningUserId}`

  // GET the S3 presigned-url first
  fetchWithRetry(~fetcher=getWithToken, ~url, ~body=Js.Nullable.undefined, ~count=3)
  |> Js.Promise.then_(json => {
    switch json->responseDataBulkSale_decode {
    | Ok(response) =>
      // PUT file to the presigned-url
      fetchWithRetry(
        ~fetcher=putWithFileAsAttachment,
        ~url=response.url,
        ~body=file->unsafeToBlob,
        ~count=3,
      )
      /*
       * 안심판매의 판매원표 저장/수정 시, AWS S3의 presigned-url이 필요해서 response 대신 전달
       * */
      |> Js.Promise.then_(_res => Js.Promise.resolve(response.path->onSuccess))
      |> Js.Promise.catch(err => Js.Promise.resolve(err->onFailure))
    | Error(err) =>
      err->Js.Console.log
      Js.Promise.resolve(makeJsPromiseError(err.message)->onFailure)
    }
  })
  |> Js.Promise.catch(err => {
    err->Js.Console.log
    Js.Promise.resolve(err->onFailure)
  })
}

let uploadImage = (~file, ~original, ~resizedImg, ~onSuccess, ~onFailure, ()) => {
  open FetchHelper

  // hotfix
  // cdn 캐시정책으로 인해 이미지는 한번 실패하면 캐싱된 실패 리턴이 유지되므로, 매 재요청마다 count값을 반영하여, 재시도합니다
  // 이미지 서버의 업로딩 방식을 async하게 변경하는 것으로 협의 중
  let rec recFetchCdnImage = (~url, ~count=10, ~interval=0, ~err=?, ()) => {
    let urlWithCount = `${url}?count=${count->Int.toString}`

    if count <= 0 {
      err->Option.forEach(error => Sentry.captureException(error))
      Js.Promise.reject(
        err->Option.getWithDefault(Js.Exn.raiseError(`요청 재시도를 실패하였습니다.`)),
      )
    } else {
      urlWithCount->Fetch.fetchWithInit(Fetch.RequestInit.make(~method_=Get, ()))
      |> Js.Promise.then_(res => {
        switch res->Fetch.Response.ok {
        | true => res->Js.Promise.resolve
        | false =>
          Js.Exn.raiseError(`처리된 이미지를 찾을 수 없습니다.`)->Js.Promise.reject
        }
      })
      |> Js.Promise.catch(err => {
        switch (err->convertFromJsPromiseError).status {
        | 401 =>
          refreshToken()
          |> Js.Promise.then_(_ => {
            wait(interval) |> Js.Promise.then_(
              _ => recFetchCdnImage(~url, ~count=count - 1, ~interval, ()),
            )
          })
          |> Js.Promise.catch(_ => {
            Redirect.redirectByRole()
            Js.Promise.reject(err->convertToExnFromPromiseError)
          })

        | _ =>
          wait(interval) |> Js.Promise.then_(_ =>
            recFetchCdnImage(
              ~url,
              ~count=count - 1,
              ~interval,
              ~err=err->convertToExnFromPromiseError,
              (),
            )
          )
        }
      })
    }
  }

  // PUT file to the presigned-url
  fetchWithRetry(~fetcher=putWithFile, ~url=original, ~body=file->unsafeToBlob, ~count=3)
  |> Js.Promise.then_(_ =>
    recFetchCdnImage(~url=resizedImg, ~interval=3000, ())
    |> Js.Promise.then_(res => Js.Promise.resolve(res))
    |> Js.Promise.catch(err => Js.Promise.reject(err->convertToExnFromPromiseError))
  )
  |> Js.Promise.then_(res => Js.Promise.resolve(res->onSuccess))
  |> Js.Promise.catch(err => Js.Promise.resolve(err->onFailure))
}
