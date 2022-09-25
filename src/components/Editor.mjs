// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as TinyMCE from "../bindings/TinyMCE.mjs";
import * as Garter_Fn from "@greenlabs/garter/src/Garter_Fn.mjs";
import * as Belt_Array from "rescript/lib/es6/belt_Array.js";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Garter_Array from "@greenlabs/garter/src/Garter_Array.mjs";
import * as TinymceReact from "@tinymce/tinymce-react";

var basicPlugins = [
  "lists",
  "advlist",
  "anchor",
  "print",
  "preview",
  "autolink",
  "directionality",
  "visualblocks",
  "visualchars",
  "charmap",
  "fullscreen",
  "help",
  "hr",
  "image",
  "link",
  "quickbars",
  "searchreplace",
  "wordcount",
  "paste",
  "emoticons",
  "table",
  "media"
];

function Editor(props) {
  var initOptions = props.initOptions;
  var init = {
    height: props.height,
    menubar: Garter_Array.joinWith(Belt_Array.map(Belt_Option.getWithDefault(Caml_option.undefined_to_opt(initOptions.menubar), []), TinyMCE.Menu.toString), " ", Garter_Fn.identity),
    toolbar: Garter_Array.joinWith(Belt_Option.getWithDefault(Caml_option.undefined_to_opt(initOptions.toolbar), []), " | ", (function (block) {
            return Garter_Array.joinWith(Belt_Array.map(block, TinyMCE.Tool.toString), " ", Garter_Fn.identity);
          })),
    quickbars_insert_toolbar: Belt_Option.getWithDefault(Caml_option.undefined_to_opt(initOptions.quickbars_insert_toolbar), true),
    paste_data_images: Belt_Option.getWithDefault(Caml_option.undefined_to_opt(initOptions.paste_data_images), false),
    images_upload_handler: initOptions.images_upload_handler,
    image_upload_credentials: true,
    file_picker_types: "image",
    table_responsive_width: true,
    content_css: "/tinymce/skins/content/default/content.css"
  };
  var plugins$p = Garter_Array.joinWith(Belt_Array.map(props.plugins, TinyMCE.$$Plugin.toString), " ", Garter_Fn.identity);
  return React.createElement(TinymceReact.Editor, {
              id: props.id,
              name: props.name,
              value: props.value,
              onEditorChange: props.onEditorChange,
              init: Caml_option.some(init),
              initialValue: props.initialValue,
              plugins: plugins$p,
              tinymceScriptSrc: "/tinymce/tinymce.min.js",
              disabled: props.disabled
            });
}

function Editor$Viewer(props) {
  return React.createElement("div", {
              id: "editor-inline"
            }, React.createElement(TinymceReact.Editor, {
                  id: props.id,
                  name: props.name,
                  value: props.value,
                  tinymceScriptSrc: "/tinymce/tinymce.min.js",
                  disabled: true,
                  inline: true
                }));
}

var Viewer = {
  make: Editor$Viewer
};

var make = Editor;

export {
  basicPlugins ,
  make ,
  Viewer ,
}
/* react Not a pure module */
