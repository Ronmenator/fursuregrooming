# PowerShell script to remove the specified section from all HTML files

# Get all HTML files in the current directory
$htmlFiles = Get-ChildItem -Filter "*.html"

foreach ($file in $htmlFiles) {
    Write-Host "Processing $($file.Name)..."
    
    # Read the content of the file
    $content = Get-Content -Path $file.FullName -Raw
    
    # Replace the section with various endings
    $content = $content -replace '<section class="display-7"[^>]*>.*?mobiri\.se/271981.*?Free AI Website Maker</a></section>', '</section>'
    $content = $content -replace '<section class="display-7"[^>]*>.*?mobiri\.se/271981.*?HTML Builder</a></section>', '</section>'
    $content = $content -replace '<section class="display-7"[^>]*>.*?mobiri\.se/271981.*?No Code Website Builder</a></section>', '</section>'
    $content = $content -replace '<section class="display-7"[^>]*>.*?mobiri\.se/271981.*?Offline Website Software</a></section>', '</section>'
    $content = $content -replace '<section class="display-7"[^>]*>.*?mobiri\.se/271981.*?AI Website Generator</a></section>', '</section>'
    
    # Fix any double </section> tags
    $content = $content -replace '</section></section>', '</section>'
    
    # Write the content back to the file
    Set-Content -Path $file.FullName -Value $content
}

Write-Host "All HTML files processed successfully." 