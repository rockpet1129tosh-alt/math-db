# 弧マクロを全37年度/期の大問4に追加

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

$updatedCount = 0

foreach ($yearTerm in $yearTerms) {
    $parts = $yearTerm -split '/'
    $year = $parts[0]
    $term = $parts[1]
    
    $qFile = Join-Path $baseDir "$year\$term\04\hsm_tok_${year}_${term}_04_q.tex"
    
    if (-not (Test-Path $qFile)) {
        Write-Host "Not found: $qFile" -ForegroundColor Yellow
        continue
    }
    
    $content = Get-Content $qFile -Raw -Encoding UTF8
    
    # すでにマクロが存在するかチェック
    if ($content -match '\\newcommand.*tightarc') {
        Write-Host "Already has macro: $yearTerm" -ForegroundColor Yellow
        continue
    }
    
    # \begin{document} の直後にマクロを追加
    $content = $content -replace '(\\begin\{document\})\s+(\\\setcounter\{figure\})',
                                  "`$1`n    `\newcommand{`\tightarc}[1]{`\overset{`\raisebox{-0.6ex}{`\scalebox{4}[4]{`$`\mkern-6mu`\frown`\mkern-6mu$`}}}}{`\!#1`\!}}`n    `$2"
    
    [System.IO.File]::WriteAllText($qFile, $content, [System.Text.Encoding]::UTF8)
    $updatedCount++
    Write-Host "Updated: $yearTerm" -ForegroundColor Green
}

Write-Host "`nTotal updated: $updatedCount / $($yearTerms.Count)" -ForegroundColor Cyan
