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

function Editor(Props) {
  var initOptions = Props.initOptions;
  var height = Props.height;
  var plugins = Props.plugins;
  var initialValue = Props.initialValue;
  var id = Props.id;
  var name = Props.name;
  var value = Props.value;
  var onEditorChange = Props.onEditorChange;
  var disabled = Props.disabled;
  var init = {
    height: height,
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
  var plugins$p = Garter_Array.joinWith(Belt_Array.map(plugins, TinyMCE.$$Plugin.toString), " ", Garter_Fn.identity);
  var tmp = {
    init: init,
    plugins: plugins$p,
    tinymceScriptSrc: "/tinymce/tinymce.min.js"
  };
  if (id !== undefined) {
    tmp.id = id;
  }
  if (name !== undefined) {
    tmp.name = name;
  }
  if (value !== undefined) {
    tmp.value = value;
  }
  if (onEditorChange !== undefined) {
    tmp.onEditorChange = Caml_option.valFromOption(onEditorChange);
  }
  if (initialValue !== undefined) {
    tmp.initialValue = initialValue;
  }
  if (disabled !== undefined) {
    tmp.disabled = disabled;
  }
  return React.createElement(TinymceReact.Editor, tmp);
}

function Editor$Viewer(Props) {
  var id = Props.id;
  var name = Props.name;
  var value = Props.value;
  var tmp = {
    tinymceScriptSrc: "/tinymce/tinymce.min.js",
    disabled: true,
    inline: true
  };
  if (id !== undefined) {
    tmp.id = id;
  }
  if (name !== undefined) {
    tmp.name = name;
  }
  if (value !== undefined) {
    tmp.value = value;
  }
  return React.createElement("div", {
              id: "editor-inline"
            }, React.createElement(TinymceReact.Editor, tmp));
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
