@module("../../public/assets/home.svg")
external homeIcon: string = "default"

@react.component
let make = () => {
  let router = Next.Router.useRouter()
  <button
    type_="button" className=%twc("w-6 h-[30px]") onClick={_ => router->Next.Router.push("/")}>
    <img src=homeIcon />
  </button>
}
