# 大問4テンプレート伝播スクリプト
# Source: 2025/1st/04/ → Target: YYYY/TERM/04/ (全37組み合わせ)

$sourceDir = "c:\Users\selec\Documents\tex_all\math-db\high_school_exam\tokyo\2025\1st\04"
$baseDir = "c:\Users\selec\Documents\tex_all\math-db\high_school_exam\tokyo"

# 全年度/期の組み合わせ
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

$processedCount = 0

foreach ($yearTerm in $yearTerms) {
    $parts = $yearTerm -split '/'
    $year = $parts[0]
    $term = $parts[1]
    
    $targetDir = Join-Path $baseDir "$year\$term\04"
    
    # ソース自身はスキップ
    if ($yearTerm -eq "2025/1st") {
        Write-Host "Skipping source: $yearTerm"
        continue
    }
    
    # 対象ディレクトリが存在することを確認
    if (-not (Test-Path $targetDir)) {
        Write-Host "Target directory not found: $targetDir" -ForegroundColor Yellow
        continue
    }
    
    # 問題編ファイル（_q.tex）のコピーと置換
    $sourceQFile = Join-Path $sourceDir "hsm_tok_2025_1st_04_q.tex"
    $targetQFile = Join-Path $targetDir "hsm_tok_${year}_${term}_04_q.tex"
    
    $content = Get-Content $sourceQFile -Raw -Encoding UTF8
    $content = $content -replace '2025_1st', "${year}_${term}"
    $content = $content -replace '2025', $year
    [System.IO.File]::WriteAllText($targetQFile, $content, [System.Text.Encoding]::UTF8)
    
    # 図版フォルダの処理
    $sourceFigDir = Join-Path $sourceDir "fig_hsm_tok_2025_1st_04"
    $targetFigDir = Join-Path $targetDir "fig_hsm_tok_${year}_${term}_04"
    
    # 図版フォルダが存在しない場合は作成
    if (-not (Test-Path $targetFigDir)) {
        New-Item -ItemType Directory -Path $targetFigDir -Force | Out-Null
    }
    
    # 図版ファイル（.tex）をコピーして置換
    Get-ChildItem -Path $sourceFigDir -Filter "*.tex" | ForEach-Object {
        $sourceFigFile = $_.FullName
        $targetFigFile = Join-Path $targetFigDir ($_.Name -replace '2025_1st', "${year}_${term}")
        
        $figContent = Get-Content $sourceFigFile -Raw -Encoding UTF8
        $figContent = $figContent -replace '2025_1st', "${year}_${term}"
        $figContent = $figContent -replace '2025', $year
        [System.IO.File]::WriteAllText($targetFigFile, $figContent, [System.Text.Encoding]::UTF8)
    }
    
    $processedCount++
    Write-Host "Processed: $yearTerm" -ForegroundColor Green
}

Write-Host "`nTotal processed: $processedCount / $($yearTerms.Count - 1) (excluding source)" -ForegroundColor Cyan
