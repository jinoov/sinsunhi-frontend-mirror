open RadixUI

module Fragment = %relay(`
  fragment UpdateMarketingTermBuyer_Fragment on User {
    terms(first: 10) {
      edges {
        node {
          agreement
          id
        }
      }
    }
  }
`)

module Mutation = %relay(`
  mutation UpdateMarketingTermBuyer_Mutation($isAgree: Boolean!) {
    updateUser(
      input: { terms: [{ agreement: "marketing", isAgreedByViewer: $isAgree }] }
    ) {
      ... on User {
        ...MyInfoAccountBuyer_Fragment
        ...MyInfoProfileSummaryBuyer_Fragment
        ...MyInfoProfileCompleteBuyer_Fragment
        ...UpdateMarketingTermBuyer_Fragment
      }
      ... on Error {
        message
      }
    }
  }
`)

@react.component
let make = (~isOpen, ~onClose, ~query) => {
  let {terms: {edges}} = Fragment.use(query)
  let (mutate, isMutating) = Mutation.use()

  let status =
    edges
    ->Array.map(({node: {agreement, id}}) => (agreement, (agreement, id)))
    ->List.fromArray
    ->List.getAssoc("marketing", (a, b) => a == b)
    ->Option.isSome

  let handleChange = _ => {
    mutate(~variables={isAgree: !status}, ())->ignore
  }

  <Dialog.Root _open={isOpen}>
    <Dialog.Overlay className=%twc("dialog-overlay") />
    <Dialog.Content
      className=%twc(
        "dialog-content-plain bottom-0 left-0 xl:bottom-auto xl:left-auto xl:rounded-2xl xl:state-open:top-1/2 xl:state-open:left-1/2 xl:state-open:-translate-x-1/2 xl:state-open:-translate-y-1/2"
      )
      onOpenAutoFocus={ReactEvent.Synthetic.preventDefault}>
      <div
        className=%twc(
          "fixed top-0 left-0 h-full xl:static bg-white w-full max-w-3xl xl:min-h-fit xl:min-w-min xl:w-[90vh] xl:max-w-[480px] xl:max-h-[85vh] "
        )>
        <section className=%twc("h-14 w-full xl:h-auto xl:w-auto xl:mt-10")>
          <div
            className=%twc(
              "flex items-center justify-between px-5 w-full py-4 xl:h-14 xl:w-full xl:pb-10"
            )>
            <div className=%twc("w-6") />
            <div>
              <span className=%twc("font-bold")> {`서비스 이용동의`->React.string} </span>
            </div>
            <Dialog.Close className=%twc("focus:outline-none") onClick={_ => onClose()}>
              <IconClose height="24" width="24" fill="#262626" />
            </Dialog.Close>
          </div>
        </section>
        <section className=%twc("my-6 px-4")>
          <div className=%twc("flex flex-col ")>
            <div className=%twc("flex flex-col mb-10")>
              <ol>
                <Next.Link href=Env.termsUrl>
                  <a target="_blank" rel="noopener">
                    <li className=%twc("py-4 text-sm border-b")>
                      <span className=%twc("font-bold")> {`이용약관`->React.string} </span>
                      <span className=%twc("text-text-L3 ml-1")>
                        {`자세히보기`->React.string}
                      </span>
                    </li>
                  </a>
                </Next.Link>
                <Next.Link href=Env.privacyPolicyUrl>
                  <a target="_blank" rel="noopener">
                    <li className=%twc("py-4 text-sm border-b")>
                      <span className=%twc("font-bold")>
                        {`개인정보 처리방침`->React.string}
                      </span>
                      <span className=%twc("text-text-L3 ml-1")>
                        {`자세히보기`->React.string}
                      </span>
                    </li>
                  </a>
                </Next.Link>
                <li className=%twc("py-4 text-sm flex justify-between items-center border-b")>
                  <Next.Link href=Env.privacyMarketing>
                    <a target="_blank" rel="noopener">
                      <span className=%twc("font-bold")>
                        {`마케팅 이용 동의(선택)`->React.string}
                      </span>
                      <span className=%twc("text-text-L3 ml-1")>
                        {`자세히보기`->React.string}
                      </span>
                    </a>
                  </Next.Link>
                  <div className=%twc("mr-2")>
                    <Switcher
                      checked={status} onCheckedChange={handleChange} disabled={isMutating}
                    />
                  </div>
                </li>
              </ol>
            </div>
          </div>
        </section>
      </div>
    </Dialog.Content>
  </Dialog.Root>
}
