# university_exam/tokyo-u/配下の全.texファイルで旧命名規則（uem_tok_）を新命名規則（uem_mat_tok_）に一括置換
$basePath = "c:/Users/selec/Documents/tex_all/math-db/university_exam/tokyo-u"

# 置換パターン
$replacements = @(
    @{ Old = "uem_tok_"; New = "uem_mat_tok_" },
    @{ Old = "uem_tok_q.tex"; New = "uem_mat_tok_q.tex" },
    @{ Old = "uem_tok_a.tex"; New = "uem_mat_tok_a.tex" }
)

Get-ChildItem -Path $basePath -Filter "*.tex" -Recurse | ForEach-Object {
    $filePath = $_.FullName
    $content = Get-Content -Path $filePath -Raw -Encoding UTF8
    $original = $content
    foreach ($rep in $replacements) {
        $content = $content -replace [regex]::Escape($rep.Old), $rep.New
    }
    if ($content -ne $original) {
        Set-Content -Path $filePath -Value $content -Encoding UTF8
        Write-Host "Replaced: $filePath"
    }
}
    Write-Host "All replacements completed."
