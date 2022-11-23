// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Spice from "@greenlabs/ppx-spice/src/rescript/Spice.mjs";
import * as DataGtm from "../utils/DataGtm.mjs";
import * as Js_dict from "rescript/lib/es6/js_dict.js";
import * as Js_json from "rescript/lib/es6/js_json.js";
import * as Belt_List from "rescript/lib/es6/belt_List.js";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Garter_Math from "@greenlabs/garter/src/Garter_Math.mjs";

var name = "web-order";

function deliveryType_encode(v) {
  if (v === "PARCEL") {
    return "parcel";
  } else if (v === "SELF") {
    return "self";
  } else {
    return "freight";
  }
}

function deliveryType_decode(v) {
  var str = Js_json.classify(v);
  if (typeof str === "number") {
    return Spice.error(undefined, "Not a JSONString", v);
  }
  if (str.TAG !== /* JSONString */0) {
    return Spice.error(undefined, "Not a JSONString", v);
  }
  var str$1 = str._0;
  if ("parcel" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: "PARCEL"
          };
  } else if ("freight" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: "FREIGHT"
          };
  } else if ("self" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: "SELF"
          };
  } else {
    return Spice.error(undefined, "Not matched", v);
  }
}

function paymentMethod_encode(v) {
  if (v === "CREDIT_CARD") {
    return "card";
  } else if (v === "TRANSFER") {
    return "transfer";
  } else {
    return "virtual";
  }
}

function paymentMethod_decode(v) {
  var str = Js_json.classify(v);
  if (typeof str === "number") {
    return Spice.error(undefined, "Not a JSONString", v);
  }
  if (str.TAG !== /* JSONString */0) {
    return Spice.error(undefined, "Not a JSONString", v);
  }
  var str$1 = str._0;
  if ("card" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: "CREDIT_CARD"
          };
  } else if ("virtual" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: "VIRTUAL_ACCOUNT"
          };
  } else if ("transfer" === str$1) {
    return {
            TAG: /* Ok */0,
            _0: "TRANSFER"
          };
  } else {
    return Spice.error(undefined, "Not matched", v);
  }
}

function fixedData_encode(v) {
  return Js_dict.fromArray([
              [
                "deliveryCost",
                Spice.intToJson(v.deliveryCost)
              ],
              [
                "isTaxFree",
                Spice.boolToJson(v.isTaxFree)
              ],
              [
                "price",
                Spice.intToJson(v.price)
              ],
              [
                "productId",
                Spice.intToJson(v.productId)
              ],
              [
                "productName",
                Spice.stringToJson(v.productName)
              ],
              [
                "imageUrl",
                Spice.stringToJson(v.imageUrl)
              ],
              [
                "isCourierAvailable",
                Spice.boolToJson(v.isCourierAvailable)
              ],
              [
                "productOptionName",
                Spice.stringToJson(v.productOptionName)
              ],
              [
                "quantity",
                Spice.intToJson(v.quantity)
              ],
              [
                "stockSku",
                Spice.stringToJson(v.stockSku)
              ],
              [
                "isFreeShipping",
                Spice.boolToJson(v.isFreeShipping)
              ],
              [
                "updatedAt",
                Spice.optionToJson(Spice.stringToJson, v.updatedAt)
              ]
            ]);
}

function fixedData_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Spice.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Spice.error(undefined, "Not an object", v);
  }
  var dict$1 = dict._0;
  var deliveryCost = Spice.intFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "deliveryCost"), null));
  if (deliveryCost.TAG === /* Ok */0) {
    var isTaxFree = Spice.boolFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "isTaxFree"), null));
    if (isTaxFree.TAG === /* Ok */0) {
      var price = Spice.intFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "price"), null));
      if (price.TAG === /* Ok */0) {
        var productId = Spice.intFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "productId"), null));
        if (productId.TAG === /* Ok */0) {
          var productName = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "productName"), null));
          if (productName.TAG === /* Ok */0) {
            var imageUrl = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "imageUrl"), null));
            if (imageUrl.TAG === /* Ok */0) {
              var isCourierAvailable = Spice.boolFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "isCourierAvailable"), null));
              if (isCourierAvailable.TAG === /* Ok */0) {
                var productOptionName = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "productOptionName"), null));
                if (productOptionName.TAG === /* Ok */0) {
                  var quantity = Spice.intFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "quantity"), null));
                  if (quantity.TAG === /* Ok */0) {
                    var stockSku = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "stockSku"), null));
                    if (stockSku.TAG === /* Ok */0) {
                      var isFreeShipping = Spice.boolFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "isFreeShipping"), null));
                      if (isFreeShipping.TAG === /* Ok */0) {
                        var updatedAt = Spice.optionFromJson(Spice.stringFromJson, Belt_Option.getWithDefault(Js_dict.get(dict$1, "updatedAt"), null));
                        if (updatedAt.TAG === /* Ok */0) {
                          return {
                                  TAG: /* Ok */0,
                                  _0: {
                                    deliveryCost: deliveryCost._0,
                                    isTaxFree: isTaxFree._0,
                                    price: price._0,
                                    productId: productId._0,
                                    productName: productName._0,
                                    imageUrl: imageUrl._0,
                                    isCourierAvailable: isCourierAvailable._0,
                                    productOptionName: productOptionName._0,
                                    quantity: quantity._0,
                                    stockSku: stockSku._0,
                                    isFreeShipping: isFreeShipping._0,
                                    updatedAt: updatedAt._0
                                  }
                                };
                        }
                        var e = updatedAt._0;
                        return {
                                TAG: /* Error */1,
                                _0: {
                                  path: ".updatedAt" + e.path,
                                  message: e.message,
                                  value: e.value
                                }
                              };
                      }
                      var e$1 = isFreeShipping._0;
                      return {
                              TAG: /* Error */1,
                              _0: {
                                path: ".isFreeShipping" + e$1.path,
                                message: e$1.message,
                                value: e$1.value
                              }
                            };
                    }
                    var e$2 = stockSku._0;
                    return {
                            TAG: /* Error */1,
                            _0: {
                              path: ".stockSku" + e$2.path,
                              message: e$2.message,
                              value: e$2.value
                            }
                          };
                  }
                  var e$3 = quantity._0;
                  return {
                          TAG: /* Error */1,
                          _0: {
                            path: ".quantity" + e$3.path,
                            message: e$3.message,
                            value: e$3.value
                          }
                        };
                }
                var e$4 = productOptionName._0;
                return {
                        TAG: /* Error */1,
                        _0: {
                          path: ".productOptionName" + e$4.path,
                          message: e$4.message,
                          value: e$4.value
                        }
                      };
              }
              var e$5 = isCourierAvailable._0;
              return {
                      TAG: /* Error */1,
                      _0: {
                        path: ".isCourierAvailable" + e$5.path,
                        message: e$5.message,
                        value: e$5.value
                      }
                    };
            }
            var e$6 = imageUrl._0;
            return {
                    TAG: /* Error */1,
                    _0: {
                      path: ".imageUrl" + e$6.path,
                      message: e$6.message,
                      value: e$6.value
                    }
                  };
          }
          var e$7 = productName._0;
          return {
                  TAG: /* Error */1,
                  _0: {
                    path: ".productName" + e$7.path,
                    message: e$7.message,
                    value: e$7.value
                  }
                };
        }
        var e$8 = productId._0;
        return {
                TAG: /* Error */1,
                _0: {
                  path: ".productId" + e$8.path,
                  message: e$8.message,
                  value: e$8.value
                }
              };
      }
      var e$9 = price._0;
      return {
              TAG: /* Error */1,
              _0: {
                path: ".price" + e$9.path,
                message: e$9.message,
                value: e$9.value
              }
            };
    }
    var e$10 = isTaxFree._0;
    return {
            TAG: /* Error */1,
            _0: {
              path: ".isTaxFree" + e$10.path,
              message: e$10.message,
              value: e$10.value
            }
          };
  }
  var e$11 = deliveryCost._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".deliveryCost" + e$11.path,
            message: e$11.message,
            value: e$11.value
          }
        };
}

function productInfo_encode(v) {
  return Js_dict.fromArray([
              [
                "imageUrl",
                Spice.stringToJson(v.imageUrl)
              ],
              [
                "isCourierAvailable",
                Spice.boolToJson(v.isCourierAvailable)
              ],
              [
                "productName",
                Spice.stringToJson(v.productName)
              ],
              [
                "totalPrice",
                Spice.intToJson(v.totalPrice)
              ],
              [
                "isTaxFree",
                Spice.boolToJson(v.isTaxFree)
              ],
              [
                "updatedAt",
                Spice.optionToJson(Spice.stringToJson, v.updatedAt)
              ],
              [
                "productOptions",
                Spice.arrayToJson(fixedData_encode, v.productOptions)
              ]
            ]);
}

function productInfo_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Spice.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Spice.error(undefined, "Not an object", v);
  }
  var dict$1 = dict._0;
  var imageUrl = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "imageUrl"), null));
  if (imageUrl.TAG === /* Ok */0) {
    var isCourierAvailable = Spice.boolFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "isCourierAvailable"), null));
    if (isCourierAvailable.TAG === /* Ok */0) {
      var productName = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "productName"), null));
      if (productName.TAG === /* Ok */0) {
        var totalPrice = Spice.intFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "totalPrice"), null));
        if (totalPrice.TAG === /* Ok */0) {
          var isTaxFree = Spice.boolFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "isTaxFree"), null));
          if (isTaxFree.TAG === /* Ok */0) {
            var updatedAt = Spice.optionFromJson(Spice.stringFromJson, Belt_Option.getWithDefault(Js_dict.get(dict$1, "updatedAt"), null));
            if (updatedAt.TAG === /* Ok */0) {
              var productOptions = Spice.arrayFromJson(fixedData_decode, Belt_Option.getWithDefault(Js_dict.get(dict$1, "productOptions"), null));
              if (productOptions.TAG === /* Ok */0) {
                return {
                        TAG: /* Ok */0,
                        _0: {
                          imageUrl: imageUrl._0,
                          isCourierAvailable: isCourierAvailable._0,
                          productName: productName._0,
                          totalPrice: totalPrice._0,
                          isTaxFree: isTaxFree._0,
                          updatedAt: updatedAt._0,
                          productOptions: productOptions._0
                        }
                      };
              }
              var e = productOptions._0;
              return {
                      TAG: /* Error */1,
                      _0: {
                        path: ".productOptions" + e.path,
                        message: e.message,
                        value: e.value
                      }
                    };
            }
            var e$1 = updatedAt._0;
            return {
                    TAG: /* Error */1,
                    _0: {
                      path: ".updatedAt" + e$1.path,
                      message: e$1.message,
                      value: e$1.value
                    }
                  };
          }
          var e$2 = isTaxFree._0;
          return {
                  TAG: /* Error */1,
                  _0: {
                    path: ".isTaxFree" + e$2.path,
                    message: e$2.message,
                    value: e$2.value
                  }
                };
        }
        var e$3 = totalPrice._0;
        return {
                TAG: /* Error */1,
                _0: {
                  path: ".totalPrice" + e$3.path,
                  message: e$3.message,
                  value: e$3.value
                }
              };
      }
      var e$4 = productName._0;
      return {
              TAG: /* Error */1,
              _0: {
                path: ".productName" + e$4.path,
                message: e$4.message,
                value: e$4.value
              }
            };
    }
    var e$5 = isCourierAvailable._0;
    return {
            TAG: /* Error */1,
            _0: {
              path: ".isCourierAvailable" + e$5.path,
              message: e$5.message,
              value: e$5.value
            }
          };
  }
  var e$6 = imageUrl._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".imageUrl" + e$6.path,
            message: e$6.message,
            value: e$6.value
          }
        };
}

function productInfos_encode(v) {
  return Spice.arrayToJson(productInfo_encode, v);
}

function productInfos_decode(v) {
  return Spice.arrayFromJson(productInfo_decode, v);
}

function formData_encode(v) {
  return Js_dict.fromArray([
              [
                "delivery-desired-date",
                Spice.optionToJson(Spice.stringToJson, v.deliveryDesiredDate)
              ],
              [
                "delivery-message",
                Spice.optionToJson(Spice.stringToJson, v.deliveryMessage)
              ],
              [
                "delivery-type",
                deliveryType_encode(v.deliveryType)
              ],
              [
                "order-user-id",
                Spice.intToJson(v.orderUserId)
              ],
              [
                "orderer-name",
                Spice.stringToJson(v.ordererName)
              ],
              [
                "orderer-phone",
                Spice.stringToJson(v.ordererPhone)
              ],
              [
                "receiver-address",
                Spice.optionToJson(Spice.stringToJson, v.receiverAddress)
              ],
              [
                "receiver-name",
                Spice.optionToJson(Spice.stringToJson, v.receiverName)
              ],
              [
                "receiver-phone",
                Spice.optionToJson(Spice.stringToJson, v.receiverPhone)
              ],
              [
                "receiver-zipcode",
                Spice.optionToJson(Spice.stringToJson, v.receiverZipCode)
              ],
              [
                "receiver-detail-address",
                Spice.optionToJson(Spice.stringToJson, v.receiverDetailAddress)
              ],
              [
                "payment-method",
                paymentMethod_encode(v.paymentMethod)
              ],
              [
                "product-infos",
                Spice.arrayToJson(productInfo_encode, v.productInfos)
              ]
            ]);
}

function formData_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Spice.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Spice.error(undefined, "Not an object", v);
  }
  var dict$1 = dict._0;
  var deliveryDesiredDate = Spice.optionFromJson(Spice.stringFromJson, Belt_Option.getWithDefault(Js_dict.get(dict$1, "delivery-desired-date"), null));
  if (deliveryDesiredDate.TAG === /* Ok */0) {
    var deliveryMessage = Spice.optionFromJson(Spice.stringFromJson, Belt_Option.getWithDefault(Js_dict.get(dict$1, "delivery-message"), null));
    if (deliveryMessage.TAG === /* Ok */0) {
      var deliveryType = deliveryType_decode(Belt_Option.getWithDefault(Js_dict.get(dict$1, "delivery-type"), null));
      if (deliveryType.TAG === /* Ok */0) {
        var orderUserId = Spice.intFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "order-user-id"), null));
        if (orderUserId.TAG === /* Ok */0) {
          var ordererName = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "orderer-name"), null));
          if (ordererName.TAG === /* Ok */0) {
            var ordererPhone = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "orderer-phone"), null));
            if (ordererPhone.TAG === /* Ok */0) {
              var receiverAddress = Spice.optionFromJson(Spice.stringFromJson, Belt_Option.getWithDefault(Js_dict.get(dict$1, "receiver-address"), null));
              if (receiverAddress.TAG === /* Ok */0) {
                var receiverName = Spice.optionFromJson(Spice.stringFromJson, Belt_Option.getWithDefault(Js_dict.get(dict$1, "receiver-name"), null));
                if (receiverName.TAG === /* Ok */0) {
                  var receiverPhone = Spice.optionFromJson(Spice.stringFromJson, Belt_Option.getWithDefault(Js_dict.get(dict$1, "receiver-phone"), null));
                  if (receiverPhone.TAG === /* Ok */0) {
                    var receiverZipCode = Spice.optionFromJson(Spice.stringFromJson, Belt_Option.getWithDefault(Js_dict.get(dict$1, "receiver-zipcode"), null));
                    if (receiverZipCode.TAG === /* Ok */0) {
                      var receiverDetailAddress = Spice.optionFromJson(Spice.stringFromJson, Belt_Option.getWithDefault(Js_dict.get(dict$1, "receiver-detail-address"), null));
                      if (receiverDetailAddress.TAG === /* Ok */0) {
                        var paymentMethod = paymentMethod_decode(Belt_Option.getWithDefault(Js_dict.get(dict$1, "payment-method"), null));
                        if (paymentMethod.TAG === /* Ok */0) {
                          var productInfos = Spice.arrayFromJson(productInfo_decode, Belt_Option.getWithDefault(Js_dict.get(dict$1, "product-infos"), null));
                          if (productInfos.TAG === /* Ok */0) {
                            return {
                                    TAG: /* Ok */0,
                                    _0: {
                                      deliveryDesiredDate: deliveryDesiredDate._0,
                                      deliveryMessage: deliveryMessage._0,
                                      deliveryType: deliveryType._0,
                                      orderUserId: orderUserId._0,
                                      ordererName: ordererName._0,
                                      ordererPhone: ordererPhone._0,
                                      receiverAddress: receiverAddress._0,
                                      receiverName: receiverName._0,
                                      receiverPhone: receiverPhone._0,
                                      receiverZipCode: receiverZipCode._0,
                                      receiverDetailAddress: receiverDetailAddress._0,
                                      paymentMethod: paymentMethod._0,
                                      productInfos: productInfos._0
                                    }
                                  };
                          }
                          var e = productInfos._0;
                          return {
                                  TAG: /* Error */1,
                                  _0: {
                                    path: ".product-infos" + e.path,
                                    message: e.message,
                                    value: e.value
                                  }
                                };
                        }
                        var e$1 = paymentMethod._0;
                        return {
                                TAG: /* Error */1,
                                _0: {
                                  path: ".payment-method" + e$1.path,
                                  message: e$1.message,
                                  value: e$1.value
                                }
                              };
                      }
                      var e$2 = receiverDetailAddress._0;
                      return {
                              TAG: /* Error */1,
                              _0: {
                                path: ".receiver-detail-address" + e$2.path,
                                message: e$2.message,
                                value: e$2.value
                              }
                            };
                    }
                    var e$3 = receiverZipCode._0;
                    return {
                            TAG: /* Error */1,
                            _0: {
                              path: ".receiver-zipcode" + e$3.path,
                              message: e$3.message,
                              value: e$3.value
                            }
                          };
                  }
                  var e$4 = receiverPhone._0;
                  return {
                          TAG: /* Error */1,
                          _0: {
                            path: ".receiver-phone" + e$4.path,
                            message: e$4.message,
                            value: e$4.value
                          }
                        };
                }
                var e$5 = receiverName._0;
                return {
                        TAG: /* Error */1,
                        _0: {
                          path: ".receiver-name" + e$5.path,
                          message: e$5.message,
                          value: e$5.value
                        }
                      };
              }
              var e$6 = receiverAddress._0;
              return {
                      TAG: /* Error */1,
                      _0: {
                        path: ".receiver-address" + e$6.path,
                        message: e$6.message,
                        value: e$6.value
                      }
                    };
            }
            var e$7 = ordererPhone._0;
            return {
                    TAG: /* Error */1,
                    _0: {
                      path: ".orderer-phone" + e$7.path,
                      message: e$7.message,
                      value: e$7.value
                    }
                  };
          }
          var e$8 = ordererName._0;
          return {
                  TAG: /* Error */1,
                  _0: {
                    path: ".orderer-name" + e$8.path,
                    message: e$8.message,
                    value: e$8.value
                  }
                };
        }
        var e$9 = orderUserId._0;
        return {
                TAG: /* Error */1,
                _0: {
                  path: ".order-user-id" + e$9.path,
                  message: e$9.message,
                  value: e$9.value
                }
              };
      }
      var e$10 = deliveryType._0;
      return {
              TAG: /* Error */1,
              _0: {
                path: ".delivery-type" + e$10.path,
                message: e$10.message,
                value: e$10.value
              }
            };
    }
    var e$11 = deliveryMessage._0;
    return {
            TAG: /* Error */1,
            _0: {
              path: ".delivery-message" + e$11.path,
              message: e$11.message,
              value: e$11.value
            }
          };
  }
  var e$12 = deliveryDesiredDate._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".delivery-desired-date" + e$12.path,
            message: e$12.message,
            value: e$12.value
          }
        };
}

function webOrder_encode(v) {
  return Js_dict.fromArray([
              [
                "order-user-id",
                Spice.intToJson(v.orderUserId)
              ],
              [
                "payment-purpose",
                Spice.stringToJson(v.paymentPurpose)
              ],
              [
                "total-delivery-cost",
                Spice.intToJson(v.totalDeliveryCost)
              ],
              [
                "total-order-price",
                Spice.intToJson(v.totalOrderPrice)
              ],
              [
                "payment-method",
                paymentMethod_encode(v.paymentMethod)
              ]
            ]);
}

function webOrder_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Spice.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Spice.error(undefined, "Not an object", v);
  }
  var dict$1 = dict._0;
  var orderUserId = Spice.intFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "order-user-id"), null));
  if (orderUserId.TAG === /* Ok */0) {
    var paymentPurpose = Spice.stringFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "payment-purpose"), null));
    if (paymentPurpose.TAG === /* Ok */0) {
      var totalDeliveryCost = Spice.intFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "total-delivery-cost"), null));
      if (totalDeliveryCost.TAG === /* Ok */0) {
        var totalOrderPrice = Spice.intFromJson(Belt_Option.getWithDefault(Js_dict.get(dict$1, "total-order-price"), null));
        if (totalOrderPrice.TAG === /* Ok */0) {
          var paymentMethod = paymentMethod_decode(Belt_Option.getWithDefault(Js_dict.get(dict$1, "payment-method"), null));
          if (paymentMethod.TAG === /* Ok */0) {
            return {
                    TAG: /* Ok */0,
                    _0: {
                      orderUserId: orderUserId._0,
                      paymentPurpose: paymentPurpose._0,
                      totalDeliveryCost: totalDeliveryCost._0,
                      totalOrderPrice: totalOrderPrice._0,
                      paymentMethod: paymentMethod._0
                    }
                  };
          }
          var e = paymentMethod._0;
          return {
                  TAG: /* Error */1,
                  _0: {
                    path: ".payment-method" + e.path,
                    message: e.message,
                    value: e.value
                  }
                };
        }
        var e$1 = totalOrderPrice._0;
        return {
                TAG: /* Error */1,
                _0: {
                  path: ".total-order-price" + e$1.path,
                  message: e$1.message,
                  value: e$1.value
                }
              };
      }
      var e$2 = totalDeliveryCost._0;
      return {
              TAG: /* Error */1,
              _0: {
                path: ".total-delivery-cost" + e$2.path,
                message: e$2.message,
                value: e$2.value
              }
            };
    }
    var e$3 = paymentPurpose._0;
    return {
            TAG: /* Error */1,
            _0: {
              path: ".payment-purpose" + e$3.path,
              message: e$3.message,
              value: e$3.value
            }
          };
  }
  var e$4 = orderUserId._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".order-user-id" + e$4.path,
            message: e$4.message,
            value: e$4.value
          }
        };
}

function submit_encode(v) {
  return Js_dict.fromArray([[
                "web-order",
                formData_encode(v.webOrder)
              ]]);
}

function submit_decode(v) {
  var dict = Js_json.classify(v);
  if (typeof dict === "number") {
    return Spice.error(undefined, "Not an object", v);
  }
  if (dict.TAG !== /* JSONObject */2) {
    return Spice.error(undefined, "Not an object", v);
  }
  var webOrder = formData_decode(Belt_Option.getWithDefault(Js_dict.get(dict._0, "web-order"), null));
  if (webOrder.TAG === /* Ok */0) {
    return {
            TAG: /* Ok */0,
            _0: {
              webOrder: webOrder._0
            }
          };
  }
  var e = webOrder._0;
  return {
          TAG: /* Error */1,
          _0: {
            path: ".web-order" + e.path,
            message: e.message,
            value: e.value
          }
        };
}

function names(prefix) {
  return {
          name: prefix,
          productInfos: "" + prefix + ".product-infos",
          orderUserId: "" + prefix + ".order-user-id",
          paymentPurpose: "" + prefix + ".payment-purpose",
          paymentMethod: "" + prefix + ".payment-method",
          deliveryDesiredDate: "" + prefix + ".delivery-desired-date",
          deliveryMessage: "" + prefix + ".delivery-message",
          deliveryType: "" + prefix + ".delivery-type",
          ordererName: "" + prefix + ".orderer-name",
          ordererPhone: "" + prefix + ".orderer-phone",
          receiverAddress: "" + prefix + ".receiver-address",
          receiverName: "" + name + ".receiver-name",
          receiverPhone: "" + prefix + ".receiver-phone",
          receiverZipCode: "" + prefix + ".receiver-zipcode",
          receiverDetailAddress: "" + prefix + ".receiver-detail-address"
        };
}

function strDateToFloat(s) {
  return Belt_Option.mapWithDefault(s, 0, (function (s$p) {
                return new Date(s$p).getTime();
              }));
}

function dateCompare(str1, str2) {
  if (strDateToFloat(str2) - strDateToFloat(str1) > 0) {
    return 1;
  } else {
    return -1;
  }
}

function fixedDataSort(data) {
  return Belt_List.toArray(Belt_List.sort(Belt_List.fromArray(data), (function (item1, item2) {
                    return dateCompare(item1.updatedAt, item2.updatedAt);
                  })));
}

function productInfoSort(data) {
  return Belt_List.toArray(Belt_List.sort(Belt_List.fromArray(data), (function (item1, item2) {
                    return dateCompare(item1.updatedAt, item2.updatedAt);
                  })));
}

function concat(data) {
  var sorted = fixedDataSort(data);
  return Belt_Option.map(Belt_Array.get(sorted, 0), (function (first$p) {
                return {
                        imageUrl: first$p.imageUrl,
                        isCourierAvailable: first$p.isCourierAvailable,
                        productName: first$p.productName,
                        totalPrice: Garter_Math.sum_int(Belt_Array.map(data, (function (d) {
                                    return Math.imul(d.price, d.quantity);
                                  }))),
                        isTaxFree: first$p.isTaxFree,
                        updatedAt: first$p.updatedAt,
                        productOptions: sorted
                      };
              }));
}

function toFixedData(param) {
  var updatedAt = param.updatedAt;
  var quantity = param.quantity;
  var match = param.productOption;
  var stockSku = match.stockSku;
  var productOptionCost = match.productOptionCost;
  var price = match.price;
  var optionName = match.optionName;
  var isFreeShipping = match.isFreeShipping;
  return Belt_Option.map(param.product, (function (param) {
                return {
                        deliveryCost: productOptionCost.deliveryCost,
                        isTaxFree: !Belt_Option.getWithDefault(param.isVat, false),
                        price: Belt_Option.getWithDefault(price, 0),
                        productId: param.number,
                        productName: param.displayName,
                        imageUrl: param.image.thumb100x100,
                        isCourierAvailable: Belt_Option.getWithDefault(param.isCourierAvailable, false),
                        productOptionName: optionName,
                        quantity: quantity,
                        stockSku: stockSku,
                        isFreeShipping: isFreeShipping,
                        updatedAt: updatedAt
                      };
              }));
}

function gtmDataPush(data) {
  DataGtm.push({
        ecommerce: null
      });
  DataGtm.push(DataGtm.mergeUserIdUnsafe({
            event: "add_shipping_info",
            ecommerce: {
              value: String(Garter_Math.sum_int(Belt_Array.map(data, (function (info) {
                              return info.totalPrice;
                            })))),
              currency: "KRW",
              items: Belt_Array.mapWithIndex(Belt_Array.concatMany(Belt_Array.map(data, (function (info) {
                              return Belt_Array.map(info.productOptions, (function (option) {
                                            return {
                                                    item_id: String(option.productId),
                                                    item_name: option.productName,
                                                    price: String(option.price),
                                                    quantity: option.quantity,
                                                    item_variant: option.productOptionName
                                                  };
                                          }));
                            }))), (function (i, obj) {
                      return Object.assign(obj, {
                                  index: i
                                });
                    }))
            }
          }));
}

export {
  name ,
  deliveryType_encode ,
  deliveryType_decode ,
  paymentMethod_encode ,
  paymentMethod_decode ,
  fixedData_encode ,
  fixedData_decode ,
  productInfo_encode ,
  productInfo_decode ,
  productInfos_encode ,
  productInfos_decode ,
  formData_encode ,
  formData_decode ,
  webOrder_encode ,
  webOrder_decode ,
  submit_encode ,
  submit_decode ,
  names ,
  strDateToFloat ,
  dateCompare ,
  fixedDataSort ,
  productInfoSort ,
  concat ,
  toFixedData ,
  gtmDataPush ,
}
/* DataGtm Not a pure module */
