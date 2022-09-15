import "styles/main.css";

// Note:
// Just renaming $$default to ResApp alone
// doesn't help FastRefresh to detect the
// React component, since an alias isn't attached
// to the original React component function name.
import ResApp from "src/App.mjs";
import React from "react";
import Head from "next/head";
import Script from "next/script";
import { ErrorBoundary } from "@sentry/react";

// Note:
// We need to wrap the make call with
// a Fast-Refresh conform function name,
// (in this case, uppercased first letter)
//
// If you don't do this, your Fast-Refresh will
// not work!
export default function App(props) {
  let gtmAppId = null;
  if (process && process.env && process.env.NEXT_PUBLIC_GTM_APP_ID) {
    gtmAppId = process.env.NEXT_PUBLIC_GTM_APP_ID;
  }

  return (
    <>
      <Head>
        {/* Viewport는 _app.js에 선언되어야 한다 - by Next (https://nextjs.org/docs/messages/no-document-viewport-meta) */}
        <meta
          name="viewport"
          content="width=device-width, initial-scale=1.0, maximum-scale=1.0"
        />
      </Head>
      {/* Google Tag Manager */}
      <Script
        id="google-tag-manager"
        strategy="afterInteractive"
        dangerouslySetInnerHTML={{
          __html: `
          (function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
          new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
          j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
          'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
          })(window,document,'script','dataLayer','${gtmAppId}');
          `,
        }}
      />
      {/* Channel Talk */}
      <Script
        id="channelIO"
        strategy="lazyOnload"
        dangerouslySetInnerHTML={{
          __html: `
            (function () {
              var w = window;
              if (w.ChannelIO) {
                return (window.console.error || window.console.log || function () {})(
                  "ChannelIO script included twice."
                );
              }
              var ch = function () {
                ch.c(arguments);
              };
              ch.q = [];
              ch.c = function (args) {
                ch.q.push(args);
              };
              w.ChannelIO = ch;
              function l() {
                if (w.ChannelIOInitialized) {
                  return;
                }
                w.ChannelIOInitialized = true;
                var s = document.createElement("script");
                s.type = "text/javascript";
                s.async = true;
                s.src = "https://cdn.channel.io/plugin/ch-plugin-web.js";
                s.charset = "UTF-8";
                var x = document.getElementsByTagName("script")[0];
                x.parentNode.insertBefore(s, x);
              }
              if (document.readyState === "complete") {
                l();
              } else if (window.attachEvent) {
                window.attachEvent("onload", l);
              } else {
                window.addEventListener("DOMContentLoaded", l, false);
                window.addEventListener("load", l, false);
              }
            })();
            `,
        }}
      />
      <ResApp {...props} />
    </>
  );
}
