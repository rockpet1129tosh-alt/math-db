# math-db ワークフロー規則・今後の予定

**更新日**: 2026年3月2日

---

## 1. LaTeX プリアンブル規則（hsm_tok_q.tex）

### 1.1 フォント・言語設定
- `documentclass[jlreq]`: 日本語対応
- `luatexja`: LuaTeX による日本語処理
- 日本語フォント: noto-sans-cjk, noto-serif-cjk

### 1.2 パッケージ・マクロ設定

#### タビュラー関連
```latex
\usepackage{tabularx}
\newcolumntype{L}{>{\raggedright\arraybackslash}X}
```
- **用途**: 自動幅調整される左寄せカラム
- **使用例**: 選択肢の多列レイアウト（Problem 7）
- **幅調整**: `\begin{tabularx}{\dimexpr\linewidth-3.5mm}{@{}LLLL@{}}`

#### 数学記号・物理演算子
```latex
\let\mathdiv\div             % 保存: 元の÷記号
\usepackage[italicdiff]{physics}  % φ, ∇ など
\let\div\mathdiv             % 復元: 元の÷記号
```
- **理由**: `physics` が `\div` を再定義するため
- **対象**: 全compile済みファイル

#### ボックス（枠線）マクロ
```latex
\newcommand{\myboxa}[2][2pt]{%
  {\setlength{\fboxrule}{0.5pt}\setlength{\fboxsep}{#1}\boxed{#2}}%
}
```
- **パラメータ**: `[セパレータ幅]{内容}`
- **デフォルト**: `#1=2pt` （内側余白）
- **用途**: 回答欄の小さい四角枠（Problem 8, 9）

---

## 2. ファイル構造規則

### 2.1 ディレクトリ階層
```
high_school_exam/tokyo/
├── YYYY/
│   ├── 1st/ または 2nd/
│   │   ├── 01-05/ (各大問)
│   │   │   ├── 01-09/ (各小問)
│   │   │   │   └── （図: fig_hsm_tok_YYYY_TERM_0X_0X/）
│   │   │   ├── hsm_tok_YYYY_TERM_0X_q.tex (親問題)
│   │   │   ├── hsm_tok_YYYY_TERM_0X_a.tex (解答)
│   │   │   └── hsm_tok_YYYY_TERM_0X_0X_q.tex (小問)
```

### 2.2 ファイル命名規則
- **マスター親**: `hsm_tok_YYYY_TERM_0X_q.tex` (e.g. `hsm_tok_2025_1st_01_q.tex`)
- **小問ファイル**: `hsm_tok_YYYY_TERM_0X_0X_q.tex` (e.g. `hsm_tok_2025_1st_01_0X_q.tex`)
- **図ディレクトリ**: `fig_hsm_tok_YYYY_TERM_0X_0X/` (例: `fig_hsm_tok_2025_1st_01_09/`)

### 2.3 Documentclass パス
- **親ファイル**: `\documentclass[../../../hsm_tok_q.tex]{subfiles}`
  - 階数: 小問dir → 大問dir → 年度dir → tokyo → hsm_tok_q.tex

---

## 3. テンプレート伝播規則（一括処理）

### 3.1 マスターテンプレート選定
- **現状**: `2025/1st/01` を全年度・時期の基準テンプレートとする
- **構成**: 9 個の小問 + 親ファイル + 図ナレッジ

### 3.2 伝播スコープ
- **対象年度**: 2008-2026 (19年分)
- **対象時期**: 1st, 2nd (2回/年)
- **対象大問**: 01-05 (5問)
- **対象小問**: 01-09 (最大9問/大問)
- **総ファイル数**: 約 38 × 5 × 9 = 1710+ ファイル

### 3.3 トークン置換ルール
```python
source_tag = "2025_1st"  # マスター
target_tag = f"{YYYY}_{term}"  # 目標

# 置換対象
- `hsm_tok_2025_1st_` → `hsm_tok_{YYYY}_{term}_`
- `fig_hsm_tok_2025_1st_` → `fig_hsm_tok_{YYYY}_{term}_`
- \documentclass 内パーティアルパスは不変
```

### 3.4 パス検証方法
1. **正規表現チェック**: 全ファイルのトークンがディレクトリと一致
2. **コンパイル検証**: 代表サンプル (2024/2nd/01, 2010/1st/01) を実行
3. **リークチェック**: `grep "2025_1st" */*/01/` で他フォルダへの混在を検出

---

## 4. 完了した作業

### ✅ LaTeX 修正（hsm_tok_q.tex）
- [x] `\div` 記号の復旧 (physics パッケージ競合解決)
- [x] tabularx カラム型定義（L 型）
- [x] `\myboxa` マクロ（可変内側余白）

### ✅ Problem 設計（2025/1st/01）
- [x] Problem 7: tabularx 選択肢レイアウト (2×4 格子)
- [x] Problem 8-9: 図付き問題 + 分数回答ボックス
- [x] 親ファイル: 9 個 subfile 参照

### ✅ テンプレート伝播（全37年度×2期）
- [x] 2025/1st/01 から 2008-2026 各年の 01 フォルダへ複製
- [x] 自動トークン置換 (年度・時期タグ)
- [x] パス正規化 + 検証 (修正不要: 0件)
- [x] サンプル compile 検証 (2024/2nd, 2010/1st OK)

---

## 5. 今後の作業予定

### 🔜 Phase 1: Problem 2-5 のテンプレート化（優先度: 高）

**スケジュール**:
1. **大問2 (Problem 02)**
   - [ ] 2025/1st/02 作成・編集 (参考: 過年度に存在する場合)
   - [ ] 9 個の小問 + 図ディレクトリ配置
   - [ ] 2008-2026, 1st/2nd に伝播 (Python スクリプト)
   - [ ] パス検証 + コンパイル確認

2. **大問3-5 (Problems 03-05)**
   - [ ] 同様の手順で実施
   - [ ] テンプレート構造の一貫性を維持

### 🔜 Phase 2: 解答ファイル (Answer) の テンプレート化（優先度: 中）

- [ ] `2025/1st/0X_a.tex` の対応
- [ ] 大問1-5 について `*_a.tex` を整理

### 🔜 Phase 3: 図（Figure）の統管理化（優先度: 中）

- [ ] TikZ 図の設計パターン確立
- [ ] `figures/` フォルダとの連携構築
- [ ] 大問ごとの図集計・一括管理

### 🔜 Phase 4: コンパイル自動化スクリプト（優先度: 低）

- [ ] 全年度・全大問の一括コンパイル (PowerShell)
- [ ] PDF 出力の確認・ロギング
- [ ] CI/CD パイプライン検討

---

## 6. よくある作業パターン

### パターン A: 年度テンプレートの一括伝播

**実行コマンド** (PowerShell):
```powershell
$source = "high_school_exam/tokyo/2025/1st/01"
$source_tag = "2025_1st"

Get-ChildItem "high_school_exam/tokyo" -Directory | ForEach-Object {
  $year = $_.Name
  Get-ChildItem "$($_.FullName)" | Where-Object {$_.Name -in @('1st','2nd')} | ForEach-Object {
    $term = $_.Name
    $target_tag = "${year}_${term}"
    # Copy-Item + Regex Replace
  }
}
```

### パターン B: パスの正規化チェック

```python
import re
from pathlib import Path

root = Path("high_school_exam/tokyo")
pattern = re.compile(r"hsm_tok_(\d{4})_(1st|2nd)_")

for tex_file in root.glob("*/**/01/*.tex"):
  year, term = extract_year_term_from_path(tex_file)
  content = tex_file.read_text()
  mismatches = [m for m in pattern.finditer(content)
                if f"{m.group(1)}_{m.group(2)}" != f"{year}_{term}"]
  if mismatches:
    print(f"MISMATCH: {tex_file} - {mismatches}")
```

### パターン C: サンプルコンパイル検証

```bash
lualatex -interaction=nonstopmode high_school_exam/tokyo/2024/2nd/01/hsm_tok_2024_2nd_01_q.tex
lualatex -interaction=nonstopmode high_school_exam/tokyo/2010/1st/01/hsm_tok_2010_1st_01_q.tex
```

---

## 7. 注意事項

### ログファイル・生成物の管理
- LaTeX コンパイル出力 (`.log`, `.aux`, `.pdf`) は `.gitignore` 対象
- ソース `.tex` ファイルのみ git 管理

### 削除されたファイル
- 旧フォーマットの大問ファイル (02-05 の古いバージョン) は段階的に削除 ※Phase 1 で置き換え予定

### 図ディレクトリの命名
- 図が複数問で共用される場合は、`fig_hsm_tok_YYYY_TERM_0X_00/` など共用フォルダ検討

---

## 8. 変更履歴

| 日付 | 内容 | 状態 |
|------|------|------|
| 2026-03-02 | Phase 0 完了: LaTeX修正 + Problem 1 テンプレート伝播 | ✅ |
| 2026-03-XX | Phase 1 開始: Problem 2-5 テンプレート化 | 🔜 |
| 2026-03-XX | Phase 2 開始: Answer テンプレート化 | 🔜 |
| 2026-03-XX | Phase 3 開始: 図管理統一 | 🔜 |

---

**最終確認**: 
- ✅ github に commit & push 完了
- ✅ 全 subfile path 正規化完了
- ✅ 代表サンプル compile OK
- ✅ 本メモファイル作成

**次のアクション**: Problem 2-5 テンプレート化を開始する場合は、このドキュメントの "Phase 1" セクションを参考にして作業を進めてください。
