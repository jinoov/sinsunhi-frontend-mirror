type t

type _module

module Root = {
  @module("swiper/react") @react.component
  external make: (
    ~children: React.element,
    ~className: string=?,
    ~tag: string=?,
    ~spaceBetween: int=?,
    ~slidesPerView: string=?,
    ~onSwiper: t => unit=?,
    ~allowTouchMove: bool=?,
    ~slidesOffsetAfter: int=?,
    ~slidesOffsetBefore: int=?,
    ~centeredSlides: bool=?,
    ~loop: bool=?,
    ~modules: array<_module>=?,
    ~autoplay: {..}=?,
    ~pagination: {..}=?,
    ~navigation: {..}=?,
  ) => React.element = "Swiper"
}

module Slide = {
  @module("swiper/react") @react.component
  external make: (~children: React.element, ~className: string=?) => React.element = "SwiperSlide"
}

@module("swiper")
external autoPlay: _module = "Autoplay"

@module("swiper")
external pagination: _module = "Pagination"

@module("swiper")
external navigation: _module = "Navigation"
