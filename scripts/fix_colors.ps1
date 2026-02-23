Get-ChildItem -Path "lib" -Recurse -Filter "*.dart" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $newContent = $content -replace 'primaryBlue', 'primary'
    if ($content -ne $newContent) {
        Set-Content -Path $_.FullName -Value $newContent -NoNewline
        Write-Host "Updated: $($_.FullName)"
    }
}
Write-Host "Color replacement complete!"
