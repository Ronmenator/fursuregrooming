#!/bin/bash

# Change all png or jpg image links to corresponding .webp in html files if webp exists
find . -type f -name "*.html" | while read -r file; do
    sed -i -E 's/(src="assets\/images\/[^"]+?)\.(png|jpg)(-[^"]*?)?"/\1.webp\3"/g' "$file"
done

# Add lang='en-US' to <html> tags if not present
find . -type f -name "*.html" | while read -r file; do
    sed -i -E 's/<html(.*?)>/<html\1 lang="en-US">/I' "$file"
done

# Add canonical link (only if not present already)
find . -type f -name "index.html" -exec sed -i '/<head>/a\
<link rel="canonical" href="https://fursuregrooming.com">
' {} \;

# Remove Mobirise badge section
find . -type f -name "*.html" | while read -r file; do
    sed -i '/<section class="display-7"/,/<\/section>/d' "$file"
done

# Remove Mobirise generator meta tag
find . -type f -name "*.html" | while read -r file; do
    sed -i '/<meta name="generator" content="Mobirise v6.0.1, mobirise.com">/d' "$file"
done

# Replace old Google Analytics with new GTM and updated config
find . -type f -name "*.html" | while read -r file; do
    sed -i '/<!-- Analytics -->/,/<!-- \/Analytics -->/d' "$file"
    sed -i '/<head>/a\
<!-- Google Tag Manager -->\
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({\'gtm.start\':\
new Date().getTime(),event:\'gtm.js\'});var f=d.getElementsByTagName(s)[0],\
j=d.createElement(s),dl=l!=\'dataLayer\'?\'&l=\'+l:\'';j.async=true;j.src=\
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);\
})(window,document,\'script\',\'dataLayer\',\'GTM-PPRK5CXK\');</script>\
<!-- End Google Tag Manager -->
' "$file"

    sed -i '/<body>/a\
<!-- Google Tag Manager (noscript) -->\
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-PPRK5CXK"\
height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>\
<!-- End Google Tag Manager (noscript) -->
' "$file"

    sed -i '/gtag/,/\/script>/d' "$file"
    sed -i '/<head>/a\
<script async src="https://www.googletagmanager.com/gtag/js?id=G-1HY02YTECH"></script>\
<script>\
  window.dataLayer = window.dataLayer || [];\
  function gtag(){dataLayer.push(arguments);}\
  gtag(\'js\', new Date());\
  gtag(\'config\', \'AW-16967812632\');\
  gtag(\'config\', \'AW-16970986682\');\
</script>
' "$file"
done

# Add meta, favicon, and schema elements to index.html (if not already present)
cat <<EOF >> index.html

<!-- Apple + Favicon -->
<link rel="apple-touch-icon" sizes="180x180" href="https://fursuregrooming.com/apple-touch-icon.png">
<link rel="icon" type="image/png" sizes="32x32" href="https://fursuregrooming.com/favicon-32x32.png">
<link rel="icon" type="image/png" sizes="16x16" href="https://fursuregrooming.com/favicon-16x16.png">
<link rel="manifest" href="/site.webmanifest">

<!-- Keywords -->
<meta name="keywords" content="mobile dog grooming, mobile grooming, dog grooming, dog haircut, dog bath, dog salon, dog spa, dog grooming services, dog grooming near me, dog grooming in denver, dog grooming in north denver, dog grooming in arvada, dog grooming in boulder, dog grooming in broomfield, dog grooming in erie, dog grooming in federal heights, dog grooming in firestone, dog grooming in frederick, dog grooming in lafayette, dog grooming in longmont, dog grooming in louisville, dog grooming in northglenn, dog grooming in superior, dog grooming in thornton, dog grooming in westminster">

<!-- Open Graph Meta -->
<meta property="og:title" content="Fur Sure Grooming - Mobile Dog Grooming in Westminster, CO!" />
<meta property="og:description" content="Pamper your dog with professional, stress-free grooming services right at your doorstep. Serving happy tails across the North Denver area!" />
<meta property="og:url" content="https://fursuregrooming.com" />
<meta property="og:image" content="https://fursuregrooming.com/assets/images/index-meta.png">
<meta property="fb:pages" content="61572299068336" />
<meta property="og:type" content="website" />
<meta property="og:site_name" content="Fur Sure Grooming" />
<meta property="og:updated_time" content="2025-04-01T00:00:00Z" />

<!-- JSON-LD Local Business Schema Markup -->
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "PetGrooming",
  "name": "Fur Sure Grooming",
  "image": "https://fursuregrooming.com/images/logo.png",
  "@id": "https://fursuregrooming.com",
  "url": "https://fursuregrooming.com",
  "telephone": "+1-417-521-0079",
  "address": {
    "@type": "PostalAddress",
    "streetAddress": "Mobile Service",
    "addressLocality": "North Denver",
    "addressRegion": "CO",
    "addressCountry": "US"
  },
  "areaServed": [{"@type": "Place", "name": "North Denver"}, {"@type": "Place", "name": "Denver"}, {"@type": "Place", "name": "Arvada"}, {"@type": "Place", "name": "Boulder"}, {"@type": "Place", "name": "Broomfield"}, {"@type": "Place", "name": "Erie"}, {"@type": "Place", "name": "Federal Heights"}, {"@type": "Place", "name": "Firestone"}, {"@type": "Place", "name": "Frederick"}, {"@type": "Place", "name": "Lafayette"}, {"@type": "Place", "name": "Longmont"}, {"@type": "Place", "name": "Louisville"}, {"@type": "Place", "name": "Northglenn"}, {"@type": "Place", "name": "Superior"}, {"@type": "Place", "name": "Thornton"}, {"@type": "Place", "name": "Westminster"}]
}
</script>
<!-- End Schema -->
EOF
