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

## 2. 実装済みファイル構造と設計パターン

### 2.1 大問1: 小問分割型（9分割）
- **構造**: 各小問が独立したファイル（`01_01_q.tex` ... `01_09_q.tex`）
  - 親ファイル `01_q.tex` が subfiles で全小問を集約
  - 各小問ファイル: `\documentclass[../../hsm_tok_q.tex]{subfiles}`
- **図**: `fig_hsm_tok_YYYY_TERM_01_0X/` に TikZ standalone
- **伝播**: 全37年度済み ✅

### 2.2 大問2: 単ファイル型（分割なし）
- **構造**: 2問を1ファイルで統合
  - 問題文 + tcolorbox + enumerate with `[resume]`
  - 2つ図版（12分割圏、24分割圏）
- **伝播**: 全37年度済み ✅

### 2.3 大問3: 単ファイル型（分割なし）
- **構造**: 3問を1ファイルで統合
  - 問題文 + 2つのグラフ図（座標系、三角形面積）
  - Q1-Q2: 選択問題、Q3: 計算問題
- **伝播**: 全37年度済み ✅

### 2.4 大問4-5: 制作予定

### 2.5 共通: Documentclass パス
```latex
% 一律採用: 2段階上（←→ でも 3段階）
\documentclass[../../hsm_tok_q.tex]{subfiles}
```
- 理由: `YYYY/TERM/0X/` の位置から `YYYY/TERM/` を経由して `tokyo/` へ

---

## 3. テンプレート伝播戦略

### 3.1 基本原則
**「テンプレート・ファースト」アプローチ**:
1. 完成度の高い原型を `2025/1st/0X/` に制作
2. Token 置換スクリプト（PowerShell/Python）で一括伝播
3. 全37年度/期間（2008-2026, 1st/2nd）に複製
4. 年度別差分は **部分修正** で対応（傾向が決まっているため）

### 3.2 伝播スコープと進捗

| 大問 | 状態 | ファイル数 | 伝播 |
|------|------|----------|------|
| 01 | ✅ 完成 | 9 sub-files + 親 | ✅全37 |
| 02 | ✅ 完成 | 単ファイル + fig×2 | ✅全37 |
| 03 | ✅ 完成 | 単ファイル + fig×2 | ✅全37 |
| 04 | 🔜 制作予定 | TBD | 🔜 |
| 05 | 🔜 制作予定 | TBD | 🔜 |

### 3.3 トークン置換ルール
```
置換対象テンプレート: 2025_1st → {YYYY}_{TERM}

- ファイル名: `hsm_tok_2025_1st_...` → `hsm_tok_{YYYY}_{TERM}_...`
- 図版参照: `fig_hsm_tok_2025_1st_...` → `fig_hsm_tok_{YYYY}_{TERM}_...`
- インライン参照: `\ref{fig/hsm_tok_2025_1st_...}` → `\ref{fig/hsm_tok_{YYYY}_{TERM}_...}`

※ Documentclass パス `[../../hsm_tok_q.tex]` は不変
```

### 3.4 実装スクリプト
```powershell
# PowerShell スクリプト: 単ファイル型テンプレート伝播
# 処理: Copy + Token 置換 + ファイル生成
# 実行: high_school_exam/tokyo/ ディレクトリで実行
```

---

## 4. 完了した作業（2026-03-02 更新）

### ✅ LaTeX マスター設定（hsm_tok_q.tex）
- [x] `\div` 記号の復旧（physics パッケージ競合解決）
- [x] tabularx カラム型定義（`\newcolumntype{L}`）
- [x] `\myboxa` マクロ（可変内側余白オプション）
- [x] `\myfraca` マクロ（分子下降分数=inline でも大サイズ）
- [x] tcolorbox グローバル設定（CJK段落インデント `\parindent=1\zw`）

### ✅ 大問テンプレート制作（2025/1st）
- [x] **大問1**: 9小問分割型 + 図版（9ファイル）
  - 複合選択問題・計算・証明スタイル混在
- [x] **大問2**: 単ファイル型・2問 + 図版2個（12分割圏、24分割圏）
  - tcolorbox スタイル（2段落、タイトル装飾）
  - enumerate with `[resume]` 番号継続
- [x] **大問3**: 単ファイル型・3問 + 図版2個（座標系、三角形面積）
  - 一次関数問題（選択肢問題×2、計算問題×1）
  - `\myfraca` マクロ使用

### ✅ テンプレート伝播（全37年度/期間）
- [x] 大問1: 全 `2008-2026 × {1st,2nd}` に伝播 + コンパイル確認
- [x] 大問2: 全 `2008-2026 × {1st,2nd}` に伝播 + 図版生成
- [x] 大問3: 全 `2008-2026 × {1st,2nd}` に伝播 + 図版生成

### ✅ Git 管理
- [x] Commit: Problem 1-2 template + 全伝播
- [x] Commit: Problem 2 figures (24-division circles)
- [x] Commit: Problem 3 template + 全伝播
- [x] Commit: TEMPLATE-STRATEGY.md メモ
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
