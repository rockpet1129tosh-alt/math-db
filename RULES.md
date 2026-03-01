# math-db LaTeX 規則・ガイドライン

**対象**: 東京都高校入試数学問題・解答テンプレート  
**更新日**: 2026年3月2日

---

## 1. マスタープリアンブル (hsm_tok_q.tex)

### 1.1 主要パッケージと目的

| パッケージ | 目的 | 特記事項 |
|-----------|------|--------|
| `jlreq` | 日本語レイアウト | クラスオプション |
| `luatexja` | LuaTeX 日本語サポート | `\useunder` で傍点・傍線 |
| `tabularx` | 自動幅調整表 | カスタム列型 `L` 定義 |
| `physics` | 物理・数学演算子 | `\div` 競合に注意 |
| `tikz` | グラフ・図形 | 別ファイル `figures/` で管理 |
| `caption` | 図表キャプション | `\captionsetup` で日本語対応 |

### 1.2 競合回避パターン

#### ≣ Problem: `physics` package による `\div` 再定義
```latex
% ==== 【修正】====
\let\mathdiv\div                        % 元の符号を保存
\usepackage[italicdiff]{physics}        % physics load
\let\div\mathdiv                        % 元の符号を復元
```

**なぜ？**
- `physics` は `\div` を "divergence operator (∇·)" に再定義
- 除算記号 ÷ が必要な場合は元の `\div` を使う

---

## 2. Problem ファイルの構造

### 2.1 親ファイル (`hsm_tok_YYYY_TERM_0X_q.tex`)

```latex
\documentclass[../../../hsm_tok_q.tex]{subfiles}

\begin{document}

\subfile{01/hsm_tok_YYYY_TERM_0X_01_q.tex}  % Problem 1
\subfile{02/hsm_tok_YYYY_TERM_0X_02_q.tex}  % Problem 2
% ... (最大9個)

\end{document}
```

**パス規則**:
- 親 (e.g. `2025/1st/01/`) → マスタープリアンブル: `../../../hsm_tok_q.tex`
- 小問フォルダ (e.g. `2025/1st/01/01/`) は `01-09/` のみ

### 2.2 小問ファイル (`01/hsm_tok_YYYY_TERM_0X_0X_q.tex`)

```latex
\documentclass[../../../../hsm_tok_q.tex]{subfiles}

\begin{document}

\textbf{【問 一】}
% コンテンツ

\end{document}
```

**パス規則**:
- 小問ファイル (e.g. `2025/1st/01/01/`) → マスタープリアンブル: `../../../../hsm_tok_q.tex`

---

## 3. よく使うマクロ

### 3.1 ボックス (答案欄)

#### `\myboxa[sep]{content}`
```latex
% デフォルト: 内側余白 2pt
\myboxa{答案}         % → [ 答案 ]

% カスタム内側余白
\myboxa[1pt]{小さい}   % → [ 小さい ]
\myboxa[5pt]{大きい}   % → [ 大きい ]
```

**実装**:
```latex
\newcommand{\myboxa}[2][2pt]{%
  {\setlength{\fboxrule}{0.5pt}\setlength{\fboxsep}{#1}\boxed{#2}}%
}
```

- `\fboxrule`: 枠線の太さ (0.5pt)
- `\fboxsep`: 内側余白 (デフォルト 2pt)

---

## 4. 表 (tabularx) の標準パターン

### 4.1 選択肢レイアウト（4列）

```latex
\begin{tabularx}{\dimexpr\linewidth-3.5mm}{@{}LLLL@{}}
\textbf{①} & \textbf{②} & \textbf{③} & \textbf{④} \\[0.3em]
ア & イ & ウ & エ \\[0.3em]
オ & カ & キ & ク
\end{tabularx}
```

**パラメータ**:
- `\dimexpr\linewidth-3.5mm`: 標準行幅から 3.5mm 減
- `@{}`: 両端の余白削除
- `L` 列型: 左寄せ + 自動幅調整

**実装の注意**:
```latex
\newcolumntype{L}{>{\raggedright\arraybackslash}X}
```

---

## 5. 図・図ディレクトリの管理

### 5.1 対象図の配置パターン

#### パターン A: 小問ごと独立図
```
2025/1st/01/
├── 08/
│   ├── fig_hsm_tok_2025_1st_01_08/    # ← ここに TikZ ソース
│   ├── hsm_tok_2025_1st_01_08_q.tex
```

#### パターン B: 複数小問で共用図（将来拡張）
```
2025/1st/01/
├── fig_hsm_tok_2025_1st_01_shared/     # 大問全体で共用
├── 01/, 02/, ..., 09/
```

### 5.2 図の参照方法

```latex
% 小問内から図を参照
\subfix{fig_hsm_tok_2025_1st_01_08/tikz_file.pdf}

% または compile 時に生成される PDFs
\includegraphics{fig_hsm_tok_2025_1st_01_08/figure.pdf}
```

---

## 6. テンプレート伝播ルール

### 6.1 トークン置換の範囲

**置換対象**:
- ファイル名: `hsm_tok_2025_1st_` → `hsm_tok_YYYY_TERM_`
- ファイル内容: 同上
- 図参照: `fig_hsm_tok_2025_1st_` → `fig_hsm_tok_YYYY_TERM_`

**非置換対象**:
- `\documentclass[../../../hsm_tok_q.tex]{subfiles}` (相対パス)
- パッケージ定義・マクロ名
- 実際の問題コンテンツ

### 6.2 削除する非マスターファイル

大問2-5について旧フォーマットが存在する場合、Phase 1時に削除予定:
- `high_school_exam/tokyo/{YYYY}/{1st|2nd}/02-05/{01,02,...}/hsm_tok_*_*_*_a.tex` (古いAnswerファイル)
- ※ 新テンプレートで全置き換え

---

## 7. コンパイル・検証作業フロー

### 7.1 単一問題のコンパイル

```powershell
cd high_school_exam/tokyo/2025/1st/01
lualatex -interaction=nonstopmode hsm_tok_2025_1st_01_q.tex
# PDF出力: hsm_tok_2025_1st_01_q.pdf
```

### 7.2 複数年度の一括検証 (推奨)

```powershell
$years = @(2008..2026)
$terms = @('1st', '2nd')

foreach ($year in $years) {
  foreach ($term in $terms) {
    $dir = "high_school_exam/tokyo/$year/$term/01"
    if (Test-Path $dir) {
      Push-Location $dir
      lualatex -interaction=nonstopmode hsm_tok_${year}_${term}_01_q.tex | Out-Null
      $success = Test-Path hsm_tok_${year}_${term}_01_q.pdf
      Write-Host "$year/$term: $success"
      Pop-Location
    }
  }
}
```

### 7.3 パス検証スクリプト (Python)

```python
import re
from pathlib import Path

def validate_paths(root_dir):
    issues = {}
    for tex in Path(root_dir).glob("*/**/01/*.tex"):
        year, term = extract_from_path(tex)
        content = tex.read_text()
        
        # Regex: hsm_tok_YYYY_TERM_
        tokens = re.findall(r'hsm_tok_(\d{4})_(1st|2nd)_', content)
        for token_year, token_term in tokens:
            if f"{token_year}_{token_term}" != f"{year}_{term}":
                issues[str(tex)] = (year, term, token_year, token_term)
    
    return issues

issues = validate_paths("high_school_exam/tokyo")
if not issues:
    print("✅ All paths consistent")
else:
    print(f"❌ Found {len(issues)} mismatches")
    for f, (y, t, ty, tt) in issues.items():
        print(f"  {f}: expected {y}_{t}, found {ty}_{tt}")
```

---

## 8. キーワード一覧

### LaTeX 関連
- **subfiles**: マルチファイル document class
- **tabularx**: 自動幅調整テーブル環境
- **\dimexpr**: 寸法計算式 (LaTeX3)
- **\let**: マクロ割り当て

### ファイル構造
- **Master template**: `2025/1st/01` (基準テンプレート)
- **Token replacement**: 年度・時期タグの自動置換
- **Path normalization**: 相対パス検証

### 作業フェーズ
- **Phase 0**: LaTeX修正 + Problem 1 伝播 (✅ 完了)
- **Phase 1**: Problem 2-5 テンプレート化 (🔜 予定)
- **Phase 2**: Answer ファイル統一 (🔜 予定)
- **Phase 3**: 図管理の統一 (🔜 予定)
- **Phase 4**: CI/CD 自動化 (🔜 予定)

---

## 9. トラブルシューティング

### Q: `\div` が ÷ の代わりに変な記号になる
**A**: `physics` パッケージ活動後に `\let\div\mathdiv` を追加  
参照: [1.2 競合回避パターン](#12-競合回避パターン)

### Q: tabularx のセルが overfull hbox になる
**A**: `\dimexpr\linewidth-3.5mm` の値を調整。または `@{}` で両端余白削除  
例: `\begin{tabularx}{\dimexpr\linewidth-5mm}{@{}LLLL@{}}`

### Q: subfile パスが見つからない (File not found)
**A**: `\documentclass[path]{subfiles}` の相対パス階数を数える  
- 親ファイル (01/) → マスター: `../../../hsm_tok_q.tex` (3階層up)
- 小問ファイル (01/01/) → マスター: `../../../../hsm_tok_q.tex` (4階層up)

### Q: 新年度を追加したい
**A**: `2025/1st/01` をコピーして token 置換 (Python script）を実行  
参照: [WORKFLOW.md - Pattern A](./WORKFLOW.md#pattern-a-年度テンプレートの一括伝播)

---

**最終チェックリスト**:
- [ ] hsm_tok_q.tex に必要なパッケージが全て定義されているか
- [ ] 各年度の 01/ に親ファイル + 9 小問があるか
- [ ] トークンが PATH と一致しているか (validate_paths.py)
- [ ] 代表年度 (2024, 2010) で compile OK か
