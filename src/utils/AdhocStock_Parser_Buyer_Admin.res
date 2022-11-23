/**
  해당 단품의 판매 가능 수량 사용설정 및 판매 가능 수량 노출설정의 유무에 따라 사용자에게 판매 가능 수량 노출 유무를 결정하는 bool을 반환합니다.  
  "판매 가능 수량 사용설정(`adhocStockIsLimited`)"과 "판매 가능 수량 노출여부(`adhocStockIsNumRemainingVisible`)"를 파라미터로 받습니다.  
  
  - `true` = 판매 가능 수량이 설정값으로 제한됨  
  - `false` = 판매 가능 수량 사용하지않음(판매 가능 수량 무제한)  
  */
let getIsShowRemaining = (~adhocStockIsLimited, ~adhocStockIsNumRemainingVisible) => {
  switch (adhocStockIsLimited, adhocStockIsNumRemainingVisible) {
  | (true, true) => true
  | _ => false
  }
}
