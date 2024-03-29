open ReactHookForm

module Fragment = %relay(`
  fragment UpdateQuotedProductFormAdminFragment on QuotedProduct {
    id
    displayCategories {
      fullyQualifiedName {
        type_: type
        id
        name
      }
    }
    category {
      fullyQualifiedName {
        id
        name
      }
    }
    displayName
    name
    displayName
    productId: number
    status
    origin
    grade
    producer {
      id
      name
      bossName
    }
    status
    notice
    description
    image {
      original
      thumb1000x1000
      thumb100x100
      thumb1920x1920
      thumb400x400
      thumb800x800
      thumb800xall
    }
    salesDocument
    noticeStartAt
    noticeEndAt
    salesType
  }
`)

module Mutation = %relay(`
   mutation UpdateQuotedProductFormAdminMutation(
     $id: ID!
     $categoryId: ID!
     $description: String!
     $displayCategoryIds: [ID!]!
     $displayName: String!
     $image: ImageInput!
     $name: String!
     $notice: String
     $noticeEndAt: DateTime
     $noticeStartAt: DateTime
     $origin: String!
     $salesDocument: String
     $status: ProductStatus!
     $grade: String!
     $salesType: ProductSalesType!
   ) {
     updateQuotedProduct(
       input: {
         id: $id
         categoryId: $categoryId
         description: $description
         displayCategoryIds: $displayCategoryIds
         displayName: $displayName
         image: $image
         name: $name
         notice: $notice
         noticeEndAt: $noticeEndAt
         noticeStartAt: $noticeStartAt
         origin: $origin
         salesDocument: $salesDocument
         status: $status
         grade: $grade
         salesType: $salesType
       }
     ) {
       ... on UpdateQuotedProductResult {
         product {
           id
         }
       }
       ... on Error {
         code
         message
       }
     }
   } 
`)

let getTextInputStyle = disabled => {
  let defaultStyle = %twc(
    "px-3 py-2 border border-border-default-L1 rounded-lg h-9 focus:outline-none min-w-1/2 max-w-2xl"
  )
  disabled ? cx([defaultStyle, %twc("bg-disabled-L3")]) : defaultStyle
}

// Form 에 대한 정보
// names, submit data
module Form = {
  type fromName = {
    producerProductName: string,
    buyerProductName: string,
    origin: string,
    productCategory: string,
    displayCategories: string,
    operationStatus: string,
    grade: string,
    notice: string,
    noticeDateTo: string,
    noticeDateFrom: string,
    thumbnail: string,
    documentURL: string,
    editor: string,
    salesType: string,
  }

  let formName = {
    producerProductName: "producer-product-name",
    buyerProductName: "buyer-product-name",
    origin: "origin",
    productCategory: "product-category",
    displayCategories: "display-categories",
    operationStatus: "product-operation-status",
    grade: "product-grade",
    notice: "notice",
    noticeDateFrom: "notice-date-from",
    noticeDateTo: "notice-date-to",
    thumbnail: "thumbnail",
    documentURL: "document-url",
    editor: "description-html",
    salesType: "sales-type",
  }

  @spice
  type submit = {
    @spice.key(formName.producerProductName) producerProductName: string,
    @spice.key(formName.buyerProductName) buyerProductName: string,
    @spice.key(formName.origin) origin: string,
    @spice.key(formName.productCategory)
    productCategory: Select_Product_Category.Form.submit,
    @spice.key(formName.displayCategories)
    displayCategories: array<Select_Display_Categories.Form.submit>,
    @spice.key(formName.operationStatus)
    operationStatus: Select_Product_Operation_Status.Base.status,
    @spice.key(formName.grade) grade: string,
    @spice.key(formName.notice) notice: option<string>,
    @spice.key(formName.noticeDateFrom) noticeStartAt: option<string>,
    @spice.key(formName.noticeDateTo) noticeEndAt: option<string>,
    @spice.key(formName.thumbnail) thumbnail: Upload_Thumbnail_Admin.Form.image,
    @spice.key(formName.documentURL) documentURL: option<string>,
    @spice.key(formName.editor) editor: string,
    @spice.key(formName.salesType) salesType: Select_Product_QuotationType_Admin.QuotationType.t,
  }
}

// 생산자
module ReadOnlyProducer = {
  @react.component
  let make = (~value) => {
    <div className=%twc("flex flex-col gap-2")>
      <div>
        <span className=%twc("font-bold")> {`생산자(대표자명)`->React.string} </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </div>
      <div className=%twc("relative max-w-md w-1/3 h-9")>
        <div className=%twc("absolute w-full")>
          <ReactSelect
            value
            cacheOptions=false
            defaultOptions=false
            //dummy
            loadOptions={_ => Js.Promise.resolve(Some([ReactSelect.NotSelected]))}
            onChange={_ => ()}
            placeholder={`생산자명으로 찾기`}
            noOptionsMessage={_ => `검색 결과가 없습니다.`}
            isClearable=true
            isDisabled=true
            styles={ReactSelect.stylesOptions(
              ~menu=(provide, _) => {
                Js.Obj.assign(Js.Obj.empty(), provide)->Js.Obj.assign({
                  "position": "inherit",
                })
              },
              ~control=(provide, _) => {
                Js.Obj.assign(Js.Obj.empty(), provide)->Js.Obj.assign({
                  "minHeight": "unset",
                  "height": "2.25rem",
                })
              },
              (),
            )}
          />
        </div>
      </div>
    </div>
  }
}

// 표준카테고리
module Category = {
  @react.component
  let make = (~name) => {
    let {control} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

    <div className=%twc("flex flex-col gap-2")>
      <div>
        <span className=%twc(" font-bold")> {`표준카테고리`->React.string} </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </div>
      <Select_Product_Categories control name disabled=false />
    </div>
  }
}

module DisplayCategoryInput = {
  @react.component
  let make = (~name, ~disabled) => {
    let {control} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

    <div className=%twc("flex flex-col gap-2")>
      <div>
        <span className=%twc(" font-bold")> {`전시카테고리`->React.string} </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </div>
      <Product_Detail_Display_Categories control name disabled />
      <div />
    </div>
  }
}

// 상품명(생산자용, 바어어용)
module ProductNameInputs = {
  @react.component
  let make = (
    ~producerProductName,
    ~producerProductNameDefaultValue: string,
    ~buyerProductName,
    ~buyerProductNameDefaultValue: string,
    ~disabled,
  ) => {
    let {formState: {errors}, register} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    let producerProductNameInput = register(.
      producerProductName,
      Some(Hooks.Register.config(~required=true, ~maxLength=100, ())),
    )

    let buyerProductNameInput = register(.
      buyerProductName,
      Some(Hooks.Register.config(~required=true, ~maxLength=100, ())),
    )

    <>
      <div className=%twc("flex flex-col gap-2")>
        <label className=%twc("block") htmlFor=producerProductNameInput.name>
          <span className=%twc("font-bold")> {`생산자용 상품명`->React.string} </span>
          <span className=%twc("text-notice")> {`*`->React.string} </span>
        </label>
        <div>
          <input
            id=producerProductNameInput.name
            defaultValue={producerProductNameDefaultValue}
            name=producerProductNameInput.name
            onChange=producerProductNameInput.onChange
            onBlur=producerProductNameInput.onBlur
            ref=producerProductNameInput.ref
            className={getTextInputStyle(disabled)}
            disabled
            placeholder={`생산자용 상품명 입력(최대 100자)`}
          />
          <ErrorMessage
            name=producerProductNameInput.name
            errors
            render={_ =>
              <span className=%twc("flex")>
                <IconError width="20" height="20" />
                <span className=%twc("text-sm text-notice ml-1")>
                  {`생산자용 상품명을 입력해주세요.(최대100자)`->React.string}
                </span>
              </span>}
          />
        </div>
      </div>
      // 바이어용 상품명
      <div className=%twc("flex flex-col gap-2")>
        <label className=%twc("block") htmlFor=buyerProductNameInput.name>
          <span className=%twc("font-bold")> {`바이어용 상품명`->React.string} </span>
          <span className=%twc("text-notice")> {`*`->React.string} </span>
        </label>
        <input
          id=buyerProductNameInput.name
          defaultValue={buyerProductNameDefaultValue}
          name=buyerProductNameInput.name
          onChange=buyerProductNameInput.onChange
          onBlur=buyerProductNameInput.onBlur
          ref=buyerProductNameInput.ref
          className={getTextInputStyle(disabled)}
          disabled
          placeholder={`바이어용 상품명 입력, 상품매장에 노출됨(최대 100자)`}
        />
        <ErrorMessage
          name=buyerProductNameInput.name
          errors
          render={_ =>
            <span className=%twc("flex")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")>
                {`바이어용 상품명을 입력해주세요.(최대100자)`->React.string}
              </span>
            </span>}
        />
      </div>
    </>
  }
}

// 상품번호
module ReadOnlyProductId = {
  @react.component
  let make = (~productId: string) => {
    <div className=%twc("flex flex-col gap-2")>
      <div> <span className=%twc("font-bold")> {`상품번호`->React.string} </span> </div>
      <div
        className=%twc(
          "px-3 py-2 border border-border-default-L1 bg-disabled-L3 text-disabled-L1 rounded-lg h-9 max-w-md w-1/3"
        )>
        <span className=%twc("text-enabled-L1")> {productId->React.string} </span>
      </div>
    </div>
  }
}

// 운영상태
module OperationStatusInput = {
  @react.component
  let make = (~name, ~defaultValue, ~disabled) => {
    let {control, formState: {errors}, setValue} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )
    let (
      isShowProductOperationNoSale,
      setShowProductOperationNoSale,
    ) = React.Uncurried.useState(_ => Dialog.Hide)

    let handleProductOperation = (
      changeFn,
      status: Select_Product_Operation_Status.Base.status,
    ) => {
      switch status {
      | RETIRE => setShowProductOperationNoSale(._ => Dialog.Show)
      | _ =>
        changeFn(
          Controller.OnChangeArg.value(status->Select_Product_Operation_Status.Base.status_encode),
        )
      }
    }

    <>
      <div className=%twc("flex flex-col gap-2 max-w-md w-1/3")>
        <div>
          <span className=%twc("font-bold")> {`운영상태`->React.string} </span>
          <span className=%twc("text-notice")> {`*`->React.string} </span>
        </div>
        <Controller
          name
          control
          defaultValue=?{defaultValue->Option.map(
            Select_Product_Operation_Status.Base.status_encode,
          )}
          rules={Rules.make(~required=true, ())}
          render={({field: {onChange, value, ref}}) =>
            <div>
              <Select_Product_Operation_Status.Base
                status={value
                ->Select_Product_Operation_Status.Base.status_decode
                ->Result.mapWithDefault(None, status => Some(status))}
                onChange={handleProductOperation(onChange)}
                forwardRef={ref}
                disabled
              />
              <ErrorMessage
                errors
                name
                render={_ =>
                  <span className=%twc("flex")>
                    <IconError width="20" height="20" />
                    <span className=%twc("text-sm text-notice ml-1")>
                      {`운영상태를 선택해주세요.`->React.string}
                    </span>
                  </span>}
              />
            </div>}
        />
      </div>
      <Dialog
        isShow=isShowProductOperationNoSale
        textOnConfirm={`확인`}
        textOnCancel={`닫기`}
        boxStyle=%twc("rounded-2xl text-center")
        kindOfConfirm=Dialog.Negative
        onConfirm={_ => {
          setValue(. name, RETIRE->Select_Product_Operation_Status.Base.status_encode)
          setShowProductOperationNoSale(._ => Dialog.Hide)
        }}
        onCancel={_ => setShowProductOperationNoSale(._ => Dialog.Hide)}>
        <p>
          {`영구판매중지 상태를 선택 후 저장하시면`->React.string}
          <br />
          {`추후 해당 상품을 수정할 수 없습니다.`->React.string}
          <br />
          <br />
          {`영구판매중지 상태로 변경할까요?`->React.string}
        </p>
      </Dialog>
    </>
  }
}

// 원산지
module OriginInput = {
  @react.component
  let make = (~name, ~defaultValue, ~disabled) => {
    let {register, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )
    let productOrigin = register(. name, Some(Hooks.Register.config(~required=true, ())))

    // 원산지
    <div className=%twc("flex flex-col gap-2 max-w-md w-1/3")>
      <label className=%twc("block") htmlFor=productOrigin.name>
        <span className=%twc("font-bold")> {`원산지`->React.string} </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </label>
      <input
        id=productOrigin.name
        name=productOrigin.name
        defaultValue=?{defaultValue}
        onChange=productOrigin.onChange
        onBlur=productOrigin.onBlur
        ref=productOrigin.ref
        className={getTextInputStyle(disabled)}
        placeholder={`원산지 입력`}
        disabled
      />
      <ErrorMessage
        errors
        name
        render={_ =>
          <span className=%twc("flex")>
            <IconError width="20" height="20" />
            <span className=%twc("text-sm text-notice ml-1")>
              {`원산지를 입력해주세요.`->React.string}
            </span>
          </span>}
      />
    </div>
  }
}

// 견적 유형 선택
module QuotationTypeInput = {
  @react.component
  let make = (~name, ~defaultValue) => {
    let {control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    <div className=%twc("flex flex-col gap-2 max-w-md w-1/3")>
      <div>
        <span className=%twc("font-bold")> {`견적 유형`->React.string} </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </div>
      <Controller
        name
        control
        defaultValue=?{defaultValue->Option.map(
          Select_Product_QuotationType_Admin.QuotationType.t_encode,
        )}
        rules={Rules.make(~required=true, ())}
        render={({field: {onChange, value, ref}}) =>
          <div>
            <Select_Product_QuotationType_Admin
              forwardRef=ref
              status={value
              ->Select_Product_QuotationType_Admin.QuotationType.t_decode
              ->Result.mapWithDefault(None, status => Some(status))}
              onChange={s =>
                s
                ->Select_Product_QuotationType_Admin.QuotationType.t_encode
                ->Controller.OnChangeArg.value
                ->onChange}
            />
            <ErrorMessage
              errors
              name
              render={_ =>
                <span className=%twc("flex")>
                  <IconError width="20" height="20" />
                  <span className=%twc("text-sm text-notice ml-1")>
                    {`견적 유형을 선택해주세요.`->React.string}
                  </span>
                </span>}
            />
          </div>}
      />
    </div>
  }
}

// 등급
module GradeInput = {
  @react.component
  let make = (~name, ~defaultValue, ~disabled) => {
    let {register, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )
    let grade = register(. name, Some(Hooks.Register.config(~required=true, ())))

    // 원산지
    <div className=%twc("flex flex-col gap-2 max-w-md w-1/3")>
      <label className=%twc("block") htmlFor=grade.name>
        <span className=%twc("font-bold")> {`등급`->React.string} </span>
        <span className=%twc("text-notice")> {`*`->React.string} </span>
      </label>
      <input
        id=grade.name
        name=grade.name
        defaultValue
        onChange=grade.onChange
        onBlur=grade.onBlur
        ref=grade.ref
        className={getTextInputStyle(disabled)}
        placeholder={`등급 입력`}
      />
      <ErrorMessage
        errors
        name={grade.name}
        render={_ =>
          <span className=%twc("flex")>
            <IconError width="20" height="20" />
            <span className=%twc("text-sm text-notice ml-1")>
              {`등급을 입력해주세요.`->React.string}
            </span>
          </span>}
      />
    </div>
  }
}

// 공지사항, 적용 날짜
module NoticeAndDateInput = {
  module DateInput = {
    @react.component
    let make = (~name, ~minDate=?, ~defaultValue=?, ~disabled=?) => {
      let {control} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())

      let strToJson = dateStr => {
        dateStr->Js.Date.fromString->DateFns.format("yyyy-MM-dd")->Js.Json.string
      }

      let jsonToStr = jsonStr => {
        jsonStr->Js.Json.decodeString->Option.keep(str => str != "")->Option.map(Js.Date.fromString)
      }

      <Controller
        name
        control
        defaultValue={defaultValue->Option.mapWithDefault(Js.Json.string(""), strToJson)}
        render={({field: {name, value, onChange}}) => {
          <DatePicker
            id=name
            date=?{value->jsonToStr}
            onChange={e => {
              (e->DuetDatePicker.DuetOnChangeEvent.detail).value
              ->Js.Json.string
              ->Controller.OnChangeArg.value
              ->onChange
            }}
            ?minDate
            firstDayOfWeek=0
            ?disabled
          />
        }}
      />
    }
  }

  @react.component
  let make = (
    ~noticeName,
    ~defaultNotice,
    ~noticeFromName,
    ~defaultNoticeFrom,
    ~noticeToName,
    ~defaultNoticeTo,
    ~disabled,
  ) => {
    let {register, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    let noticeDateFrom = Hooks.WatchValues.use(
      Hooks.WatchValues.Text,
      ~config=Hooks.WatchValues.config(~name=noticeFromName, ()),
      (),
    )

    let notice = register(. noticeName, Some(Hooks.Register.config(~maxLength=1000, ())))

    <>
      // 공지사항
      <div className=%twc("flex flex-col gap-2")>
        <label htmlFor={notice.name}>
          <span className=%twc("font-bold")> {`공지사항`->React.string} </span>
        </label>
        <textarea
          id=notice.name
          name=notice.name
          defaultValue=?{defaultNotice}
          onBlur=notice.onBlur
          onChange=notice.onChange
          ref=notice.ref
          className=%twc(
            "px-3 py-2 border border-border-default-L1 rounded-lg h-24 focus:outline-none min-w-1/2 max-w-2xl"
          )
          placeholder={`공지사항 또는 메모 입력(최대 1000자)`}
          disabled
        />
        <ErrorMessage
          errors
          name={notice.name}
          render={_ =>
            <span className=%twc("flex")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")>
                {`공지사항은 최대 1000자까지 입력 가능합니다.`->React.string}
              </span>
            </span>}
        />
      </div>
      // 공지사항 적용기간
      <div className=%twc("flex flex-col gap-2")>
        <span className=%twc("font-bold")> {`공지사항 적용기간`->React.string} </span>
        <div className=%twc("flex gap-1")>
          <DateInput
            name=noticeFromName minDate="2021-01-01" defaultValue=?{defaultNoticeFrom} disabled
          />
          <span className=%twc("flex items-center")> {`~`->React.string} </span>
          <DateInput
            name=noticeToName
            minDate={noticeDateFrom->Option.getWithDefault("")}
            defaultValue=?{defaultNoticeTo}
            disabled
          />
        </div>
      </div>
    </>
  }
}

// 대표 이미지 썸네일
module ThumbnailUploadInput = {
  @react.component
  let make = (~name, ~defaultValue, ~disabled) => {
    let {control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    <div className=%twc("flex flex-col gap-2")>
      <div>
        <span className=%twc("font-bold")> {`대표이미지(썸네일)`->React.string} </span>
        <span className=%twc("text-red-500")> {`*`->React.string} </span>
        <span className=%twc("text-text-L2 ml-2")>
          {`*이미지 파일 형식 등록 가능`->React.string}
        </span>
      </div>
      <div>
        <Controller
          name
          control
          defaultValue={defaultValue->Upload_Thumbnail_Admin.Form.image_encode}
          rules={Rules.make(
            ~required=true,
            ~validate=Js.Dict.fromArray([
              (
                "required",
                Validation.sync(value =>
                  value
                  ->Upload_Thumbnail_Admin.Form.image_decode
                  ->Result.mapWithDefault(false, image => image.original !== "")
                ),
              ),
            ]),
            (),
          )}
          render={({field: {value, onChange, name}}) =>
            <Upload_Thumbnail_Admin
              name
              updateFn={imageUrls =>
                onChange(
                  Controller.OnChangeArg.value(imageUrls->Upload_Thumbnail_Admin.Form.image_encode),
                )}
              value={value
              ->Upload_Thumbnail_Admin.Form.image_decode
              ->Result.getWithDefault(Upload_Thumbnail_Admin.Form.resetImage)}
              disabled
            />}
        />
        <ErrorMessage
          errors
          name
          render={_ =>
            <span className=%twc("flex")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")>
                {`대표이미지(썸네일)을 선택해주세요.`->React.string}
              </span>
            </span>}
        />
      </div>
    </div>
  }
}

// 판매자료 URL
module SalesDocumentURLInput = {
  @react.component
  let make = (~name, ~defaultValue, ~disabled) => {
    let {register} = Hooks.Context.use(. ~config=Hooks.Form.config(~mode=#onChange, ()), ())
    let documentURL = register(. name, None)

    <div className=%twc("flex flex-col gap-2")>
      <label className=%twc("block font-bold")> {`판매자료 URL`->React.string} </label>
      <input
        id=documentURL.name
        name=documentURL.name
        ?defaultValue
        className=%twc(
          "py-2 px-3 h-9 border-border-default-L1 border rounded-lg focus:outline-none min-w-1/2 max-w-2xl"
        )
        onChange=documentURL.onChange
        onBlur=documentURL.onBlur
        ref=documentURL.ref
        disabled
      />
    </div>
  }
}

// 에디터
module EditorInput = {
  @react.component
  let make = (~name, ~defaultValue, ~disabled) => {
    let {control, formState: {errors}} = Hooks.Context.use(.
      ~config=Hooks.Form.config(~mode=#onChange, ()),
      (),
    )

    <div className=%twc("flex flex-col gap-2")>
      <div className=%twc("flex gap-2")>
        <div>
          <span className=%twc("font-bold")> {`상품설명`->React.string} </span>
          <span className=%twc("text-red-500")> {`*`->React.string} </span>
        </div>
        <ErrorMessage
          errors
          name
          render={_ =>
            <span className=%twc("flex")>
              <IconError width="20" height="20" />
              <span className=%twc("text-sm text-notice ml-1")>
                {`상품설명을 추가해주세요.`->React.string}
              </span>
            </span>}
        />
      </div>
      <div> <Product_Detail_Editor control name defaultValue disabled /> </div>
    </div>
  }
}

let producerToReactSelected = (
  p: UpdateQuotedProductFormAdminFragment_graphql.Types.fragment_producer,
) => {
  ReactSelect.Selected({
    value: p.id,
    label: p.bossName->Option.mapWithDefault(p.name, bn => `${p.name}(${bn})`),
  })
}

let toDisplayCategory = query => {
  let generateForm: array<
    UpdateQuotedProductFormAdminFragment_graphql.Types.fragment_displayCategories_fullyQualifiedName,
  > => Select_Display_Categories.Form.submit = categories => {
    categoryType: switch categories->Garter.Array.first->Option.map(({type_}) => type_) {
    | Some(#NORMAL) => ReactSelect.Selected({value: "normal", label: `일반`})
    | Some(#SHOWCASE) => ReactSelect.Selected({value: "showcase", label: `기획전`})
    | _ => ReactSelect.NotSelected
    },
    c1: categories
    ->Array.get(0)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
    c2: categories
    ->Array.get(1)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
    c3: categories
    ->Array.get(2)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
    c4: categories
    ->Array.get(3)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
    c5: categories
    ->Array.get(4)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
  }
  query->generateForm
}

let toProductCategory = query => {
  let generateForm: array<
    UpdateQuotedProductFormAdminFragment_graphql.Types.fragment_category_fullyQualifiedName,
  > => Select_Product_Category.Form.submit = categories => {
    c1: categories
    ->Array.get(0)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
    c2: categories
    ->Array.get(1)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
    c3: categories
    ->Array.get(2)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
    c4: categories
    ->Array.get(3)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
    c5: categories
    ->Array.get(4)
    ->Option.mapWithDefault(ReactSelect.NotSelected, d => {
      ReactSelect.Selected({value: d.id, label: d.name})
    }),
  }

  query->generateForm
}

let toImage: UpdateQuotedProductFormAdminFragment_graphql.Types.fragment_image => Upload_Thumbnail_Admin.Form.image = image => {
  original: image.original,
  thumb1000x1000: image.thumb1000x1000,
  thumb100x100: image.thumb100x100,
  thumb1920x1920: image.thumb1920x1920,
  thumb400x400: image.thumb400x400,
  thumb800x800: image.thumb800x800,
  thumb800xall: image.thumb800xall->Option.getWithDefault(image.thumb1920x1920),
}

let encodeStatus = (status: Select_Product_Operation_Status.Base.status) => {
  switch status {
  | SALE => #SALE
  | SOLDOUT => #SOLDOUT
  | HIDDEN_SALE => #HIDDEN_SALE
  | NOSALE => #NOSALE
  | RETIRE => #RETIRE
  }
}

let decodeStatus = (
  s: UpdateQuotedProductFormAdminFragment_graphql.Types.enum_ProductStatus,
): option<Select_Product_Operation_Status.Base.status> => {
  switch s {
  | #SALE => SALE->Some
  | #SOLDOUT => SOLDOUT->Some
  | #HIDDEN_SALE => HIDDEN_SALE->Some
  | #NOSALE => NOSALE->Some
  | #RETIRE => RETIRE->Some
  | _ => None
  }
}

let decodeSalesType = (
  s: UpdateQuotedProductFormAdminFragment_graphql.Types.enum_ProductSalesType,
): option<Select_Product_QuotationType_Admin.QuotationType.t> => {
  switch s {
  | #RFQ_LIVESTOCK => RFQ_LIVESTOCK->Some
  | #TRADEMATCH_AQUATIC => TRADEMATCH_AQUATIC->Some
  | _ => None
  }
}

let makeQuotedProductVariables = (productId, form: Form.submit) => {
  Mutation.makeVariables(
    ~id=productId,
    ~categoryId=form.productCategory.c5->ProductForm.makeCategoryId,
    ~displayCategoryIds=form.displayCategories->ProductForm.makeDisplayCategoryIds,
    ~displayName=form.buyerProductName,
    ~image={
      original: form.thumbnail.original,
      thumb1000x1000: form.thumbnail.thumb1000x1000,
      thumb100x100: form.thumbnail.thumb100x100,
      thumb1920x1920: form.thumbnail.thumb1920x1920,
      thumb400x400: form.thumbnail.thumb400x400,
      thumb800x800: form.thumbnail.thumb800x800,
      thumb800xall: form.thumbnail.thumb800xall,
    },
    ~description=form.editor,
    ~name=form.producerProductName,
    ~grade=form.grade,
    ~notice=?{form.notice->Option.keep(str => str != "")},
    ~noticeStartAt=?{form.noticeStartAt->ProductForm.makeNoticeDate(DateFns.startOfDay)},
    ~noticeEndAt=?{form.noticeEndAt->ProductForm.makeNoticeDate(DateFns.endOfDay)},
    ~origin=form.origin,
    ~salesDocument=?{form.documentURL->Option.keep(str => str != "")},
    ~status=form.operationStatus->encodeStatus,
    ~salesType={
      switch form.salesType {
      | RFQ_LIVESTOCK => #RFQ_LIVESTOCK
      | TRADEMATCH_AQUATIC => #TRADEMATCH_AQUATIC
      }
    },
    (),
  )
}

@react.component
let make = (~query) => {
  let router = Next.Router.useRouter()
  let product = Fragment.use(query)
  let (quotedlMutate, isQuotedlMutating) = Mutation.use()
  let {addToast} = ReactToastNotifications.useToasts()
  let (isShowUpdateSuccess, setShowUpdateSuccess) = React.Uncurried.useState(_ => Dialog.Hide)
  let (errorStatus, setErrorStatus) = React.Uncurried.useState(_ => (Dialog.Hide, None))
  let (isShowInitalize, setShowInitialize) = React.Uncurried.useState(_ => Dialog.Hide)

  let methods = Hooks.Form.use(.
    ~config=Hooks.Form.config(
      ~mode=#onChange,
      ~defaultValues=[
        //다이나믹하게 생성되는 Field array 특성상 defaultValue를 Form에서 초기 설정을 해주어 맨 처음 마운트 될때만 값이 유지되도록 한다.
        (
          Product_Detail_Basic_Admin.Form.formName.displayCategories,
          product.displayCategories
          ->Array.map(d => d.fullyQualifiedName)
          ->Array.map(toDisplayCategory)
          ->Array.map(Select_Display_Categories.Form.submit_encode)
          ->Js.Json.array,
        ),
        (
          Product_Detail_Basic_Admin.Form.formName.productCategory,
          product.category.fullyQualifiedName
          ->toProductCategory
          ->Select_Product_Category.Form.submit_encode,
        ),
      ]
      ->Js.Dict.fromArray
      ->Js.Json.object_,
      (),
    ),
    (),
  )

  let {handleSubmit} = methods

  let disabled = product.status == #RETIRE

  let {
    producerProductName,
    buyerProductName,
    origin,
    productCategory,
    displayCategories,
    operationStatus,
    grade,
    notice,
    noticeDateFrom,
    noticeDateTo,
    thumbnail,
    documentURL,
    editor,
    salesType,
  } = Form.formName

  let onSubmit = (data: Js.Json.t, _) => {
    switch data->Form.submit_decode {
    | Ok(data) =>
      quotedlMutate(
        ~variables=makeQuotedProductVariables(product.id, data),
        ~onCompleted={
          ({updateQuotedProduct}, _) => {
            switch updateQuotedProduct {
            | #UpdateQuotedProductResult(_) => setShowUpdateSuccess(._ => Dialog.Show)
            | #Error({message}) => setErrorStatus(._ => (Dialog.Show, message))
            | _ => setErrorStatus(._ => (Dialog.Show, None))
            }
          }
        },
        (),
      )->ignore
    | Error(error) => {
        Js.log(error)
        addToast(.
          <div className=%twc("flex items-center")>
            <IconError height="24" width="24" className=%twc("mr-2") />
            {j`오류가 발생하였습니다. 수정내용을 확인하세요.`->React.string}
          </div>,
          {appearance: "error"},
        )
      }
    }
  }

  let handleReset = ReactEvents.interceptingHandler(_ => {
    setShowInitialize(._ => Dialog.Show)
  })

  <ReactHookForm.Provider methods>
    <form onSubmit={handleSubmit(. onSubmit)}>
      <section className=%twc("p-7 mx-4 bg-white rounded-b-md")>
        <h2 className=%twc("text-text-L1 text-lg font-bold")> {j`기본정보`->React.string} </h2>
        <div className=%twc("divide-y text-sm")>
          <div className=%twc("flex flex-col space-y-6 py-6")>
            <ReadOnlyProducer value={product.producer->producerToReactSelected} />
            <Category name=productCategory />
            <DisplayCategoryInput name=displayCategories disabled />
          </div>
          <div className=%twc("flex flex-col space-y-6 py-6")>
            <ProductNameInputs
              producerProductName
              buyerProductName
              producerProductNameDefaultValue={product.name}
              buyerProductNameDefaultValue={product.displayName}
              disabled
            />
            <ReadOnlyProductId productId={product.productId->Int.toString} />
          </div>
          <div className=%twc("py-6 flex flex-col space-y-6")>
            <div className=%twc("flex gap-2")>
              <OperationStatusInput
                name=operationStatus defaultValue={product.status->decodeStatus} disabled
              />
              <QuotationTypeInput
                name=salesType defaultValue={product.salesType->decodeSalesType}
              />
            </div>
            <div className=%twc("flex gap-2 text-sm")>
              <OriginInput name=origin defaultValue={product.origin} disabled />
              <GradeInput name=grade defaultValue={product.grade} disabled />
            </div>
          </div>
        </div>
      </section>
      <section className=%twc("p-7 mt-4 mx-4 mb-7 bg-white rounded shadow-gl")>
        <h2 className=%twc("text-text-L1 text-lg font-bold")>
          {j`상품상세설명`->React.string}
        </h2>
        <div className=%twc("text-sm py-6 flex flex-col space-y-6")>
          <NoticeAndDateInput
            noticeName=notice
            noticeFromName=noticeDateFrom
            noticeToName=noticeDateTo
            defaultNotice={product.notice}
            defaultNoticeFrom={product.noticeStartAt}
            defaultNoticeTo={product.noticeEndAt}
            disabled
          />
          <ThumbnailUploadInput name=thumbnail defaultValue={product.image->toImage} disabled />
          <SalesDocumentURLInput name=documentURL defaultValue={product.salesDocument} disabled />
          <EditorInput name=editor defaultValue={product.description} disabled />
        </div>
      </section>
      <div
        className=%twc(
          "fixed bottom-0 h-16 max-w-gnb-panel bg-white flex items-center gap-2 justify-end pr-10 w-full z-50"
        )>
        {switch product.status {
        | #RETIRE =>
          <button
            type_="submit"
            disabled=true
            className=%twc("px-3 py-2 bg-disabled-L2 text-white rounded-lg focus:outline-none")>
            {`상품을 수정할 수 없습니다.`->React.string}
          </button>
        | _ => <>
            <button
              type_="reset"
              className=%twc("px-3 py-2 bg-div-shape-L1 rounded-lg focus:outline-none")
              onClick={handleReset}
              disabled={isQuotedlMutating}>
              {`수정내용 초기화`->React.string}
            </button>
            <button
              type_="submit"
              disabled={isQuotedlMutating}
              className=%twc(
                "px-3 py-2 bg-green-gl text-white rounded-lg hover:bg-green-gl-dark focus:outline-none"
              )>
              {`상품 수정`->React.string}
            </button>
          </>
        }}
      </div>
    </form>
    <Dialog
      boxStyle=%twc("text-center rounded-2xl")
      isShow={isShowInitalize}
      textOnCancel={`닫기`}
      textOnConfirm={`초기화`}
      kindOfConfirm=Dialog.Negative
      onConfirm={_ => {
        router->Next.Router.reload(router.pathname)
        setShowInitialize(._ => Dialog.Hide)
      }}
      onCancel={_ => setShowInitialize(._ => Dialog.Hide)}>
      <p> {`수정한 모든 내용을 초기화 하시겠어요?`->React.string} </p>
    </Dialog>
    <Dialog
      boxStyle=%twc("text-center rounded-2xl")
      isShow={isShowUpdateSuccess}
      textOnCancel={`확인`}
      onCancel={_ => {
        setShowUpdateSuccess(._ => Dialog.Hide)
        router->Next.Router.reload(router.pathname)
      }}>
      <p className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
        {`상품정보가 수정되었습니다.`->React.string}
      </p>
    </Dialog>
    {
      let (isShow, errorMessage) = errorStatus
      <Dialog
        boxStyle=%twc("text-center rounded-2xl")
        isShow={isShow}
        textOnCancel={`확인`}
        onCancel={_ => setErrorStatus(._ => (Dialog.Hide, None))}>
        <div className=%twc("text-gray-500 text-center whitespace-pre-wrap")>
          {`상품정보 수정에 실패하였습니다.`->React.string}
          {switch errorMessage {
          | Some(msg) => <p> {msg->React.string} </p>
          | None => React.null
          }}
        </div>
      </Dialog>
    }
  </ReactHookForm.Provider>
}
