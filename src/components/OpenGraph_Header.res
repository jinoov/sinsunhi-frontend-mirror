@react.component
let make = (~title, ~imageURL="https://app.sinsunhi.com/og_img.jpg", ~description="", ~canonicalUrl="https://sinsunhi.com") => {
    <Next.Head>
        <meta property="og:type" content="website"/>
        <meta property="og:url" content=`${canonicalUrl}`/>
        <meta property="og:title" content=`${title}`/>
        <meta property="og:image" content=`${imageURL}`/>
        <meta property="og:description" content=`${description}`/>
        <meta property="og:site_name" content="신선하이"/>
        <meta property="og:locale" content="ko"/>
    </Next.Head>
}
