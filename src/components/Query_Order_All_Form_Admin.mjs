// Generated by ReScript, PLEASE EDIT WITH CARE

import * as ReForm from "@rescriptbr/reform/src/ReForm.mjs";

function get(values, field) {
  switch (field) {
    case /* ProductName */0 :
        return values.productName;
    case /* ProducerName */1 :
        return values.producerName;
    case /* BuyerName */2 :
        return values.buyerName;
    
  }
}

function set(values, field, value) {
  switch (field) {
    case /* ProductName */0 :
        return {
                productName: value,
                producerName: values.producerName,
                buyerName: values.buyerName
              };
    case /* ProducerName */1 :
        return {
                productName: values.productName,
                producerName: value,
                buyerName: values.buyerName
              };
    case /* BuyerName */2 :
        return {
                productName: values.productName,
                producerName: values.producerName,
                buyerName: value
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
  productName: "",
  producerName: "",
  buyerName: ""
};

export {
  FormFields ,
  Form ,
  initialState ,
  
}
/* Form Not a pure module */
