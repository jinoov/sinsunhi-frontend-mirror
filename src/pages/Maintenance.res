module MaintenanceTime = {
  type t = {
    from: Js.Date.t,
    to_: option<Js.Date.t>,
  }

  let make = (from, to_) => {
    let now = Js.Date.now()->Js.Date.fromFloat
    let isBetween = (from, now, to') => {
      DateFns.isAfter(now, from) && DateFns.isBefore(now, to')
    }
    switch (from->Js.Date.fromString, to_->Option.map(Js.Date.fromString)) {
    | (from', Some(to_')) if isBetween(from', now, to_') =>
      Some({
        from: from',
        to_: Some(to_'),
      })

    | (from', None) if DateFns.isAfter(now, from') => Some({from: from', to_: None})
    | _ => None
    }
  }

  let format = ({from, to_}) => {
    let formatForDisplay = date => date->DateFns.format(`MM월 dd일 HH시`)

    `${from->formatForDisplay} ~ ${to_->Option.mapWithDefault("", formatForDisplay)}`
  }
}

module StatusPageAPI = {
  // statuspage의 api에 대한 모델링입니다.
  module Component = {
    @spice
    type t = {name: string}
  }

  module IncidentUpdate = {
    @spice
    type t = {
      @spice.key("affected_components") components: option<array<Component.t>>,
      body: string,
      @spice.key("created_at") createdAt: string,
    }
  }
  module Incident = {
    @spice
    type incident = {
      components: array<Component.t>,
      id: string,
      impact: string,
      name: option<string>,
      @spice.key("created_at") createdAt: string,
      @spice.key("scheduled_for") scheduledFor: option<string>,
      @spice.key("scheduled_until") scheduledUntil: option<string>,
      @spice.key("started_at") startedAt: option<string>,
      @spice.key("incident_updates") incidentUpdates: array<IncidentUpdate.t>,
    }
  }

  @spice
  type incidents = array<Incident.incident>

  let useStatusPage = apiEndpoint => {
    let fetcher = url => {
      open FetchHelper

      url->Fetch.fetchWithInit(
        Fetch.RequestInit.make(
          ~method_=Get,
          ~headers=Fetch.HeadersInit.make({
            "Authorization": `OAuth ${Env.statusPageKey}`,
          }),
          (),
        ),
      )
      |> Js.Promise.then_(res =>
        if res->Fetch.Response.ok {
          res->Fetch.Response.json
        } else {
          res->Fetch.Response.json
          |> Js.Promise.then_(errJson => {
            Js.Promise.reject({
              let error = makeError(`요청에 실패했습니다.`)
              error->setStatus(res->Fetch.Response.status)
              error->setInfo(errJson)
              switch errJson->errJson_decode {
              | Ok(errJson') => error->setMessage(errJson'.message)
              | Error(_) => ()
              }
              error->convertToExn
            })
          })
          |> Js.Promise.catch(err => {
            Js.Promise.reject(err->convertToExnFromPromiseError)
          })
        }
      )
      |> Js.Promise.then_(data => Js.Promise.resolve(data))
      |> Js.Promise.catch(_ => Js.Promise.resolve(Js.Json.null))
    }

    let {data, error} = Swr.useSwr(
      `https://api.statuspage.io/v1/pages/${Env.statusPagePageId}/incidents/${apiEndpoint}`,
      fetcher,
      Swr.fetcherOptions(
        ~revalidateIfStale=false,
        ~revalidateOnFocus=false,
        ~revalidateOnReconnect=false,
        ~errorRetryCount=0,
        ~shouldRetryOnError=false,
        (),
      ),
    )

    switch (data, error) {
    | (Some(data), None) =>
      data->incidents_decode->Result.mapWithDefault(None, incident => incident->Some)
    | _ => None
    }
  }
}

module Match = {
  type t = {
    message: option<string>,
    maintenanceTime: MaintenanceTime.t,
  }

  let make = (currentSubPage, incidentTargets, message, from, to_) => {
    let pathCheck = (currentSubPage, incidentTargets) => {
      incidentTargets
      ->Array.getBy(incidentTarget => currentSubPage == incidentTarget)
      ->Option.isSome
    }

    switch (pathCheck(currentSubPage, incidentTargets), MaintenanceTime.make(from, to_)) {
    | (true, Some(maintenanceTime)) =>
      Some([
        {
          message,
          maintenanceTime,
        },
      ])
    | _ => None
    }
  }

  let fromIncident = (incident: StatusPageAPI.Incident.incident, currentSubPage) => {
    // 이 incident의 가장 마지막 업데이트의 메시지를 가져옵니다.
    let message =
      incident.incidentUpdates
      ->SortArray.stableSortBy((incidentA, incidentB) =>
        DateFns.compareDesc(
          incidentA.createdAt->Js.Date.fromString,
          incidentB.createdAt->Js.Date.fromString,
        )
      )
      ->Array.get(0)
      ->Option.map(latestIncident => latestIncident.body)

    let incidentTarget = incident.components->Array.map(component => component.name)

    switch (incident.scheduledFor, incident.scheduledUntil) {
    | (Some(scheduledFor), Some(_)) =>
      // 예정된 시작 시간과 예정된 종료 시간이 제시된 경우 -> Maintenance
      make(currentSubPage, incidentTarget, message, scheduledFor, incident.scheduledUntil)
    | _ =>
      // 사건 발생 시작 시간만 존재하는 경우 -> Incident
      make(currentSubPage, incidentTarget, message, incident.createdAt, None)
    }
  }
}

module View = {
  @react.component
  let make = (~message, ~maintenanceTime=?) => {
    <section
      className=%twc(
        "w-screen h-screen flex flex-col items-center justify-start dialog-overlay bg-white pointer-events-none"
      )>
      <div className=%twc("flex flex-col h-full items-center justify-center")>
        <img src="/images/maintenance.png" width="140" height="156" />
        <h1 className=%twc("mt-7 text-3xl text-gray-800 whitespace-pre text-center")>
          {`더 나은 서비스를 위해서\n시스템 점검 중입니다`->React.string}
        </h1>
        <div className=%twc("flex flex-col justify-center items-center gap-5")>
          <h3 className=%twc("mt-7 text-[17px] whitespace-pre text-center")>
            {message
            ->Option.getWithDefault(`점검 시간 동안 서비스 이용이 일시 중단됩니다.\n이용에 불편을 드려서 죄송합니다.`)
            ->React.string}
          </h3>
          <div className=%twc("flex flex-col items-center py-3 bg-gray-gl rounded-lg w-[320px]")>
            <span className=%twc("")> {`점검 시간`->React.string} </span>
            <span className=%twc("text-gray-800 font-bold")>
              {maintenanceTime
              ->Option.map(MaintenanceTime.format)
              ->Option.getWithDefault(`불러오는 중입니다`)
              ->React.string}
            </span>
          </div>
        </div>
      </div>
    </section>
  }
}

module Container = {
  @react.component
  let make = () => {
    // 점검 페이지 로직
    let router = Next.Router.useRouter()
    let routerPathNames = router.pathname->Js.String2.split("/")
    let currentSubPage = switch (routerPathNames->Array.get(1), routerPathNames->Array.get(2)) {
    | (Some("seller"), _) => "SELLER"
    | (Some("admin"), _) => "ADMIN"
    | (Some("buyer"), Some("products"))
    | (Some("buyer"), Some(_)) => "BUYER"
    | (Some("buyer"), None)
    | (_, _) => "COMMON"
    }

    let incidents = StatusPageAPI.useStatusPage("unresolved")
    let maintenance = StatusPageAPI.useStatusPage("scheduled")

    let currentIncident =
      switch (incidents, maintenance) {
      | (Some(incidents'), Some(maintenance')) => incidents'->Js.Array.concat(maintenance')
      | (Some(incidents'), None) => incidents'
      | (None, Some(maintenance')) => maintenance'
      | (None, None) => []
      }
      ->Array.keepMap(incidentList => Match.fromIncident(incidentList, currentSubPage))
      ->Array.get(0)

    switch currentIncident {
    | Some([{message, maintenanceTime}, _])
    | Some([{message, maintenanceTime}]) =>
      <RadixUI.Dialog.Root _open=true>
        <RadixUI.Dialog.Portal>
          <RadixUI.Dialog.Overlay className=%twc("dialog-overlay") />
          <RadixUI.Dialog.Content className=%twc("top-0 bg-white fixed z-20")>
            <Next.Head>
              <title> {`🚧 신선하이 점검중입니다 🚧`->React.string} </title>
            </Next.Head>
            <View message maintenanceTime />
          </RadixUI.Dialog.Content>
        </RadixUI.Dialog.Portal>
      </RadixUI.Dialog.Root>
    | _ => React.null
    }
  }
}

@react.component
let make = () => {
  let (isCsr, setIsCsr) = React.Uncurried.useState(_ => false)
  React.useEffect0(() => {
    setIsCsr(._ => true)
    None
  })
  switch isCsr {
  | true => <Container />
  | false => React.null
  }
}
