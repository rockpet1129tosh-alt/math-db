# `\subfix{}` マクロ削除 - 親ファイル直接コンパイル対応

**実施日**: 2026年3月3日  
**対象**: 全189ファイル（`high_school_exam/tokyo` 配下の全 `*_q.tex` ファイル）

---

## 実装内容

### 変更前（subifles パッケージの制限あり）
```tex
% 子ファイル内
\includegraphics{\subfix{fig_../fig_01_q.pdf}}  # ← 親ファイルからのコンパイルでパス解決失敗
```

### 変更後（親・子ファイル両対応）
```tex
% 子ファイル内
\includegraphics{fig_hsm_tok_2024_1st_02/fig_hsm_tok_2024_1st_02_02_q.pdf}  # ← 相対パスは親ファイル基準で自動解決
```

---

## 効果・改善点

✅ **親ファイル直接コンパイルが可能に**
```bash
cd high_school_exam/tokyo
lualatex hsm_tok_q.tex  # 全37年度を一度にコンパイル（115ページ出力）
```

✅ **code の簡潔化**
- `\subfix{}` マクロの処理オーバーヘッド排除
- 相対パスが「見たままの構造」で理解しやすい

✅ **science-db との統一**
- `science-db/university_exam/physics-standard/ps_q.tex` と同じパターン
- 両プロジェクト間で運用方針を一貫化

✅ **拡張性向上**
- latexmk, arara などの外部ツール対応
- CI/CD パイプラインでの親ファイルコンパイルが標準化可能

✅ **デバッグ簡単化**
- パス解決がシンプルで、「ファイルが見つからない」エラーの原因特定が容易

---

## 実施内容の詳細

### 処理対象
- **ファイル数**: 189個
- **置換パターン**: `\subfix\{([^}]*)\}` → `$1`（正規表現）

### 確認済み
1. ✅ 子ファイル単体コンパイル（従来通り動作）
2. ✅ **親ファイル直接コンパイル**（新機能）
   ```
   lualatex hsm_tok_q.tex  
   → Output written on hsm_tok_q.pdf (115 pages, 1500654 bytes)
   ```

---

## 注意事項

### 今後のテンプレート適用時
- 大問4, 5 など新規作成時は、`\subfix{}` **を使わない**
- 相対パスは子ファイル基準で指定（例：`fig_hsm_tok_2025_1st_04/fig.pdf`）

### 他地域への拡張時
- 同じ方式を適用（science-db との統一性を保つ）

---

## 実装記録

**作業コマンド**:
```powershell
# 一括置換
$files = Get-ChildItem -Recurse -Filter "*_q.tex" | 
         Where-Object { (Get-Content $_.FullName | Select-String -Pattern "subfix" -Quiet) }

$files | ForEach-Object {
  $content = Get-Content $_.FullName
  $newContent = $content -replace '\\subfix\{([^}]*)\}', '$1'
  Set-Content $_.FullName -Value $newContent
}
```

**テストコマンド**:
```bash
cd high_school_exam/tokyo
lualatex hsm_tok_q.tex
```

---

## ファイル参照

- [hsm_tok_q.tex](../../../high_school_exam/tokyo/hsm_tok_q.tex)（親プリアンブル - 変更なし）
- [hsm_tok_2024_1st_02_q.tex](../../../high_school_exam/tokyo/2024/1st/02/hsm_tok_2024_1st_02_q.tex)（変更例）
- [hsm_tok_2025_1st_04_q.tex](../../../high_school_exam/tokyo/2025/1st/04/hsm_tok_2025_1st_04_q.tex)（新テンプレート - 既に `\subfix{}` なし）

