import Document, { Html, Head, Main, NextScript } from "next/document";
import Script from "next/script";

class MyDocument extends Document {
  static async getInitialProps(ctx) {
    const initialProps = await Document.getInitialProps(ctx);
    return { ...initialProps };
  }

  render() {
    return (
      <Html>
        <Head>
          <meta name="naver-site-verification" content="118b9725fc68d47f420bded30c9a1fbc10ef2d6c" />
          <meta name="google-site-verification" content="hxOisu7UrmoAE5HN9HWorLkG0Y4016ojm4NQ5aCPZT8" />
          <meta name="description" content="농산물 소싱은 신선하이에서! 전국 70만 산지농가의 우수한 농산물을 싸고 편리하게 공급합니다. 국내 유일한 농산물 B2B 플랫폼 신선하이와 함께 매출을 올려보세요." />
          <link
            rel="stylesheet"
            href="https://cdn.jsdelivr.net/npm/@duetds/date-picker@1.4.0/dist/duet/themes/default.css"
          />
          <link rel="icon" type="image/ico" href="/favicon.ico" />
          <meta
            property="og:url"
            content="https://app.sinsunhi.com"
          />
          <meta property="og:type" content="website" />
          <meta property="og:title" content="신선하이" />
          <meta property="og:description" content="농산물 소싱 플랫폼" />
          <meta
            property="og:image"
            content="https://app.sinsunhi.com/og_img.jpg"
          />
          <link rel="preconnect" href="https://fonts.googleapis.com" />
          <link rel="preconnect" href="https://fonts.gstatic.com" crossOrigin="true" />
          <link rel="preload" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard-dynamic-subset.css" as="style" onLoad="this.onload=null;this.rel='stylesheet';this.type='text/css'" />
          <noscript><link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/pretendard-dynamic-subset.css" /></noscript>
          <link rel="manifest" href="/manifest.json"/>
          <link rel="apple-touch-icon" href="icon-512x512.png"/>
          <link rel="apple-touch-icon" sizes="192x192" href="icon-192x192.png"/>
          <link rel="apple-touch-icon" sizes="384x384" href="icon-384x384.png"/>
          <link rel="apple-touch-icon" sizes="512x512" href="icon-512x512.png"/>
        </Head>
        <body>
          {/* Google Tag Manager (noscript) */}
          <noscript dangerouslySetInnerHTML={{
            __html: `<iframe src="https://www.googletagmanager.com/ns.html?id=${process.env.NEXT_PUBLIC_GTM_APP_ID}"
height="0" width="0" style="display:none;visibility:hidden"></iframe>`}}></noscript>
          {/* End Google Tag Manager (noscript) */}
          <Main />
          <NextScript />
        </body>
      </Html>
    );
  }
}

export default MyDocument;
