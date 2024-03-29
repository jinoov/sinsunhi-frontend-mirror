// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Jest from "@glennsl/bs-jest/src/jest.mjs";
import * as Helper from "../src/utils/Helper.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";

Jest.describe("TEST Parser PhoneNumber", (function (param) {
        Jest.test("mobile number - 010", (function (param) {
                return Jest.Expect.toEqual("010-1234-5678", Jest.Expect.expect(Belt_Option.flatMap(Helper.PhoneNumber.parse("01012345678"), Helper.PhoneNumber.format)));
              }));
        Jest.test("mobile number - 011", (function (param) {
                return Jest.Expect.toEqual("011-123-4567", Jest.Expect.expect(Belt_Option.flatMap(Helper.PhoneNumber.parse("0111234567"), Helper.PhoneNumber.format)));
              }));
        Jest.test("mobile number - 016", (function (param) {
                return Jest.Expect.toEqual("016-123-4567", Jest.Expect.expect(Belt_Option.flatMap(Helper.PhoneNumber.parse("0161234567"), Helper.PhoneNumber.format)));
              }));
        Jest.test("mobile number - 017", (function (param) {
                return Jest.Expect.toEqual("017-123-4567", Jest.Expect.expect(Belt_Option.flatMap(Helper.PhoneNumber.parse("0171234567"), Helper.PhoneNumber.format)));
              }));
        Jest.test("mobile number - 018", (function (param) {
                return Jest.Expect.toEqual("018-123-4567", Jest.Expect.expect(Belt_Option.flatMap(Helper.PhoneNumber.parse("0181234567"), Helper.PhoneNumber.format)));
              }));
        Jest.test("mobile number - 019", (function (param) {
                return Jest.Expect.toEqual("019-123-4567", Jest.Expect.expect(Belt_Option.flatMap(Helper.PhoneNumber.parse("0191234567"), Helper.PhoneNumber.format)));
              }));
        Jest.test("mobile number - 02-{3}-{4}", (function (param) {
                return Jest.Expect.toEqual("02-123-4567", Jest.Expect.expect(Belt_Option.flatMap(Helper.PhoneNumber.parse("021234567"), Helper.PhoneNumber.format)));
              }));
        Jest.test("mobile number - 02-{4}-{4}", (function (param) {
                return Jest.Expect.toEqual("02-1234-5678", Jest.Expect.expect(Belt_Option.flatMap(Helper.PhoneNumber.parse("0212345678"), Helper.PhoneNumber.format)));
              }));
        Jest.test("mobile number - 031-{3}-{4}", (function (param) {
                return Jest.Expect.toEqual("031-123-4567", Jest.Expect.expect(Belt_Option.flatMap(Helper.PhoneNumber.parse("0311234567"), Helper.PhoneNumber.format)));
              }));
        Jest.test("mobile number - 031-{4}-{4}", (function (param) {
                return Jest.Expect.toEqual("031-1234-5678", Jest.Expect.expect(Belt_Option.flatMap(Helper.PhoneNumber.parse("03112345678"), Helper.PhoneNumber.format)));
              }));
        Jest.test("mobile number - 070-{4}-{4}", (function (param) {
                return Jest.Expect.toEqual("070-1234-5678", Jest.Expect.expect(Belt_Option.flatMap(Helper.PhoneNumber.parse("07012345678"), Helper.PhoneNumber.format)));
              }));
        Jest.test("mobile number - 0504-{4}-{4}", (function (param) {
                return Jest.Expect.toEqual("0502-1234-5678", Jest.Expect.expect(Belt_Option.flatMap(Helper.PhoneNumber.parse("050212345678"), Helper.PhoneNumber.format)));
              }));
      }));

export {
  
}
/*  Not a pure module */
