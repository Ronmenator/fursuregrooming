#!/bin/bash

# This script removes the specified section from all HTML files

# Find all HTML files in the current directory
for html_file in *.html; do
  echo "Processing $html_file..."
  
  # Use sed to remove the section with the Free AI Website Maker link
  sed -i 's|<section class="display-7"[^>]*>.*mobiri\.se/271981.*Free AI Website Maker</a></section>|</section>|' "$html_file"
  
  # Clean up any other variations of the section
  sed -i 's|<section class="display-7"[^>]*>.*mobiri\.se/271981.*HTML Builder</a></section>|</section>|' "$html_file"
  sed -i 's|<section class="display-7"[^>]*>.*mobiri\.se/271981.*No Code Website Builder</a></section>|</section>|' "$html_file"
  sed -i 's|<section class="display-7"[^>]*>.*mobiri\.se/271981.*Offline Website Software</a></section>|</section>|' "$html_file"
  sed -i 's|<section class="display-7"[^>]*>.*mobiri\.se/271981.*AI Website Generator</a></section>|</section>|' "$html_file"
  
  # Fix any double </section> tags
  sed -i 's|</section></section>|</section>|g' "$html_file"
done

echo "All HTML files processed successfully." 