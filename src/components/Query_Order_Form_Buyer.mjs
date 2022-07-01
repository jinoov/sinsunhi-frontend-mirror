// Generated by ReScript, PLEASE EDIT WITH CARE

import * as ReForm from "@rescriptbr/reform/src/ReForm.mjs";

function get(values, field) {
  switch (field) {
    case /* OrderProductNo */0 :
        return values.orderProductNo;
    case /* ProductId */1 :
        return values.productId;
    case /* OrdererName */2 :
        return values.ordererName;
    case /* ReceiverName */3 :
        return values.receiverName;
    case /* Sku */4 :
        return values.sku;
    
  }
}

function set(values, field, value) {
  switch (field) {
    case /* OrderProductNo */0 :
        return {
                orderProductNo: value,
                productId: values.productId,
                ordererName: values.ordererName,
                receiverName: values.receiverName,
                sku: values.sku
              };
    case /* ProductId */1 :
        return {
                orderProductNo: values.orderProductNo,
                productId: value,
                ordererName: values.ordererName,
                receiverName: values.receiverName,
                sku: values.sku
              };
    case /* OrdererName */2 :
        return {
                orderProductNo: values.orderProductNo,
                productId: values.productId,
                ordererName: value,
                receiverName: values.receiverName,
                sku: values.sku
              };
    case /* ReceiverName */3 :
        return {
                orderProductNo: values.orderProductNo,
                productId: values.productId,
                ordererName: values.ordererName,
                receiverName: value,
                sku: values.sku
              };
    case /* Sku */4 :
        return {
                orderProductNo: values.orderProductNo,
                productId: values.productId,
                ordererName: values.ordererName,
                receiverName: values.receiverName,
                sku: value
              };
    
  }
}

var FormFields = {
  get: get,
  set: set
};

var Form = ReForm.Make({
      set: set,
      get: get
    });

var initialState = {
  orderProductNo: "",
  productId: "",
  ordererName: "",
  receiverName: "",
  sku: ""
};

export {
  FormFields ,
  Form ,
  initialState ,
  
}
/* Form Not a pure module */
