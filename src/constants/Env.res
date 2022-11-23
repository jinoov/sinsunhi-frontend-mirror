type env = {
  "NEXT_PUBLIC_VERCEL_ENV": string,
  "NEXT_PUBLIC_API_URL": string,
  "NEXT_PUBLIC_IMWEB_PAY_URL": string,
  "NEXT_PUBLIC_CHANNEL_TALK_KEY": string,
  "NEXT_PUBLIC_BUYER_SIGNUP_SURVEY_KEY": string,
  "NEXT_PUBLIC_BUYER_UPLOAD_GUIDE_URI": string,
  "NEXT_PUBLIC_BUYER_ORDER_EXCEL_FORM_URI": string,
  "NEXT_PUBLIC_CANCEL_FORM_URL": string,
  "NEXT_PUBLIC_S3_PUBLIC_URL": string,
  "NEXT_PUBLIC_LOGO_150x50_URI": string,
  "NEXT_PUBLIC_KCP_WEB_API_URL": string,
  "NEXT_PUBLIC_KCP_MOBILE_API_URL": string,
  "NEXT_PUBLIC_KCP_SITE_CD": string,
  "NEXT_PUBLIC_KCP_SITE_KEY": string,
  "NEXT_PUBLIC_AFTER_PAY_API_URL": string,
  "NEXT_PUBLIC_STATUSPAGE_KEY": string,
  "NEXT_PUBLIC_STATUSPAGE_PAGE_ID": string,
  "NEXT_PUBLIC_BRAZE_WEB_API_KEY": string,
  "NEXT_PUBLIC_TOGGLE_ORDER_BUTTON": string,
  "NEXT_PUBLIC_ORDER_ADMINS": string,
  "NEXT_PUBLIC_TERMS": string,
  "NEXT_PUBLIC_PRIVACY_AGREE": string,
  "NEXT_PUBLIC_PRIVACY_POLICY": string,
  "NEXT_PUBLIC_PRIVACY_MARKETING": string,
  "NEXT_PUBLIC_COPYRIGHT": string,
}

@val external env: env = "process.env"

let vercelEnv = env["NEXT_PUBLIC_VERCEL_ENV"]
// "development", "preview", "production"

let apiUrl = env["NEXT_PUBLIC_API_URL"]
let restApiUrl = apiUrl
// 신선하이 그래프큐엘 API
// https://api.sinsunhi.com/graphql
let graphqlApiUrl = apiUrl ++ "/graphql"
// 팜모닝 브릿지 그래프큐엘 API : 안심판매
// https://api.sinsunhi.com/farmmorning-bridge/graphql
let fmbGraphqlApiUrl = apiUrl ++ "/farmmorning-bridge/graphql"
let channelTalkKey = env["NEXT_PUBLIC_CHANNEL_TALK_KEY"]

// 나중 결제 API
let afterPayApiUrl = env["NEXT_PUBLIC_AFTER_PAY_API_URL"]

// let amplitudeApiKey = "9487848bf1b535343b25ff67fe4530c8"

let originProd = "https://app.sinsunhi.com"

let sweettrackerUrl = "https://info.sweettracker.co.kr/tracking/5" // http://info.sweettracker.co.kr/apidoc 템플릿 스타일은 url 마지막 번호 1~5 변경

let customerServiceUrl = "https://freshmarket.channel.io/support-bots"
let customerServicePaths = {"rfqContactManager": `/40022`, "rfqMeatProcess": `/40277`}
let kakaotalkChannel = "https://pf.kakao.com/_JftIs"

// 바이어 주문서 등록 가이드
let buyerUploadGuideUri = env["NEXT_PUBLIC_BUYER_UPLOAD_GUIDE_URI"]

// 바이어 주문 양식
let buyerOrderExcelFormUri = env["NEXT_PUBLIC_BUYER_ORDER_EXCEL_FORM_URI"]

// 취소양식 url
let cancelFormUrl = env["NEXT_PUBLIC_CANCEL_FORM_URL"]

// 크롬 다운로드 url
let downloadChromeUrl = "https://www.google.com/intl/ko/chrome/"
// 엣지 다운로드 url
let downloadEdgeUrl = "https://www.microsoft.com/ko-kr/edge"
// 아임웹 결제 url
let imwebPayUrl = env["NEXT_PUBLIC_IMWEB_PAY_URL"]

// S3 public url
let s3PublicUrl = env["NEXT_PUBLIC_S3_PUBLIC_URL"]

// 페이퍼폼 (3rd party 서베이 페이지, 마케팅팀 요청으로 삽입)
let paperformEmbedUrl = "https://paperform.co/__embed.min.js"
let buyerSignupSurveyKey = env["NEXT_PUBLIC_BUYER_SIGNUP_SURVEY_KEY"]

// Logo 150x50 uri
let logo150x50 = env["NEXT_PUBLIC_LOGO_150x50_URI"]

let statusPageKey = env["NEXT_PUBLIC_STATUSPAGE_KEY"]

let statusPagePageId = env["NEXT_PUBLIC_STATUSPAGE_PAGE_ID"]
let brazeWebApiKey = env["NEXT_PUBLIC_BRAZE_WEB_API_KEY"]

// 장바구니 배포 전,후 주문-결제 기능 관련 환경변수 (삭제예정)
let toggleOrderButton = env["NEXT_PUBLIC_TOGGLE_ORDER_BUTTON"]
// e.g. ON 또는 OFF
let orderAdmins = env["NEXT_PUBLIC_ORDER_ADMINS"]
// e.g. abc@greenlabs.co.kr, abc.abc@example.com

/** 이용약관 */
let termsUrl = env["NEXT_PUBLIC_TERMS"]
/** 개인정보 이용동의 */
let privacyAgreeUrl = env["NEXT_PUBLIC_PRIVACY_AGREE"]
/** 개인정보 처리방침 */
let privacyPolicyUrl = env["NEXT_PUBLIC_PRIVACY_POLICY"]
/** 마케팅 이용동의 */
let privacyMarketing = env["NEXT_PUBLIC_PRIVACY_MARKETING"]
/** 저작권 보호 */
let copyrightUrl = env["NEXT_PUBLIC_COPYRIGHT"]
