# 大問4の全図版をコンパイル

$baseDir = "c:\Users\selec\Documents\tex_all\math-db\high_school_exam\tokyo"

$yearTerms = @(
    "2008/1st", "2008/2nd",
    "2009/1st", "2009/2nd",
    "2010/1st", "2010/2nd",
    "2011/1st", "2011/2nd",
    "2012/1st", "2012/2nd",
    "2013/1st", "2013/2nd",
    "2014/1st", "2014/2nd",
    "2015/1st", "2015/2nd",
    "2016/1st", "2016/2nd",
    "2017/1st", "2017/2nd",
    "2018/1st", "2018/2nd",
    "2019/1st", "2019/2nd",
    "2020/1st", "2020/2nd",
    "2021/1st", "2021/2nd",
    "2022/1st", "2022/2nd",
    "2023/1st", "2023/2nd",
    "2024/1st", "2024/2nd",
    "2025/1st", "2025/2nd",
    "2026/1st"
)

$compiledCount = 0
$errorCount = 0

foreach ($yearTerm in $yearTerms) {
    $parts = $yearTerm -split '/'
    $year = $parts[0]
    $term = $parts[1]
    
    $figDir = Join-Path $baseDir "$year\$term\04\fig_hsm_tok_${year}_${term}_04"
    
    if (-not (Test-Path $figDir)) {
        Write-Host "Figure directory not found: $figDir" -ForegroundColor Yellow
        $errorCount++
        continue
    }
    
    # 図版TeXファイルをコンパイル
    $texFiles = Get-ChildItem -Path $figDir -Filter "*.tex"
    
    foreach ($texFile in $texFiles) {
        Push-Location $figDir
        $output = lualatex -interaction=nonstopmode $texFile.Name 2>&1 | Out-String
        Pop-Location
        
        $pdfFile = $texFile.FullName -replace '\.tex$', '.pdf'
        if (Test-Path $pdfFile) {
            $compiledCount++
        } else {
            Write-Host "Failed to compile: $($texFile.Name)" -ForegroundColor Red
            $errorCount++
        }
    }
}

Write-Host "`nCompilation complete!" -ForegroundColor Cyan
Write-Host "Successfully compiled: $compiledCount PDFs" -ForegroundColor Green
if ($errorCount -gt 0) {
    Write-Host "Errors: $errorCount" -ForegroundColor Red
}
