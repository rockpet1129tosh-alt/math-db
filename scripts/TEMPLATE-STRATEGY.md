# テンプレート戦略メモ

**作成日**: 2026-03-02  
**対象**: 東京都立高等学校入試 数学（高度数学、2008-2026）

## 基本方針

### ✅ ひな形主義アプローチ

大問1・大問2 を正規ひな形として確立し、**他の年度の制作は部分修正で対応** する戦略を採用します。

### 📋 理由

東京都立の入試問題は「傾向がはっきりしている」：
- **問題構造**: 年度による「設問パターン」が固定化しやすい
- **出題範囲**: カリキュラム改訂の際を除き、大きな変更がない
- **テンプレート活用**: ほぼ同一構造で本文の数値・表現のみ置換すれば足りる
- **効率性**: 1つの完成度高い原型を用意することで、残り36インスタンスはスクリプト化・一括生成可能

---

## 実装済み事例

### 大問1: 多問形式テンプレート
**ファイル**: `high_school_exam/tokyo/2025/1st/01/hsm_tok_2025_1st_01_q.tex`

**特徴**：
- 9つのサブ問題（01-09）に split
- 各サブファイル独立・subfiles で結合
- `\subfile{01/hsm_tok_2025_1st_01_01_q.tex}` 形式で参照

**伝播方法**：
- Source: `2025/1st/01/` → Target: `YYYY/TERM/01/`
- Token: `2025_1st` → `{YYYY}_{TERM}`
- 全37年度×期間 に一括生成済み ✅

---

### 大問2: 単一ファイル・複数図版テンプレート
**ファイル**: `high_school_exam/tokyo/2025/1st/02/hsm_tok_2025_1st_02_q.tex`

**特徴**：
- 単ファイル設計（sub-split なし）
- 2つの tcolorbox 段落（先生問題 + Sさんグループ問題）
- 2つの TikZ 図版（12分割圏 fig_01、24分割圏 fig_02）
- 連番 enumerate with `[resume]` で問番号を継続

**スタイリング**：
- `tcolorbox` enhanced mode で title 括弧装飾
- `before upper={\parindent=1\zw}` で CJK 段落インデント
- `colback=white, colframe=black` で枠線スタイル

**伝播方法**：
- Source: `2025/1st/02/` → Target: `YYYY/TERM/02/`
- Token: `2025_1st` → `{YYYY}_{TERM}` （ファイル名・内容両方）
- 全37年度×期間 に一括生成済み ✅
- Figure TeX ファイル（fig_01, fig_02）も同時伝播

---

## 大問3-5 制策略（今後の展開）

### 📌 基本ステップ

1. **原型作成**: `2025/1st/03/` (Q1, Q2, ...)
   - 完成度高く、美的・構造的に「完成形」として整備
   - 数値・文言は固定値のまま OK

2. **テンプレート化マーク**:
   - Token `2025_1st` を明示的に埋め込む（年度別置換用）
   - 図版も同じ Token 規則に従わせる

3. **一括伝播**:
   - PowerShell / Python スクリプトで全37カンバ先へ複製
   - Token 置換 + 図版ファイル複製は自動処理

4. **差分修正**:
   - 「例年と異なる年」（カリキュラム変更，難度調整など）のみ個別修正
   - 大多数は「複製 + 置換」で完成

### 🎯 設計の原則

- **ファイル分割**:
  - 複雑・長い問題 (6問以上) → sub-split (01-09)
  - 単純・短い問題 (2-3問) → 単ファイル設計
  - 判断基準: 1ファイル = 1-2 pages 目安

- **図版命名規則**:
  ```
  fig_hsm_tok_{YYYY}_{TERM}_0{N}_0{M}_q.pdf
  ├─ N: 大問番号
  └─ M: 当該大問内の図版番号
  ```

- **Token 置換ルール**:
  ```
  2025_1st → {YYYY}_{TERM}
  ```
  ファイル名・内容・相対パス内 全て対象

- **Path 統一**:
  - `\documentclass[../../hsm_tok_q.tex]{subfiles}` （2段階上）
  - 大問別ディレクトリ: `YYYY/TERM/0N/` は常に1階層

---

## チェックリスト（新規大問作成時）

- [ ] **ひな形候補を** `2025/1st/0N/` に作成
- [ ] **全図版を** `fig_hsm_tok_2025_1st_0N_0{M}_q.tex` (TikZ standalone) で用意
- [ ] **Token 埋め込み**: `2025_1st` をファイル名・参照両方に記載
- [ ] **相対パス確認**: `[../../hsm_tok_q.tex]` が正確
- [ ] **コンパイル確認**: 2025/1st/0N がエラーなく PDF 出力
- [ ] **Script 作成**: 一括伝播用 Python/PowerShell (37カンバ先対応)
- [ ] **Git コミット**: ひな形 + Script
- [ ] **一括伝播実行** + **複数サンプル検証**
- [ ] **Git コミット**: 全伝播完了版

---

## Git ワークフロー

各大問ごと：

1. **ひな形完成後**:
   ```bash
   git add high_school_exam/tokyo/2025/1st/0N/
   git commit -m "feat: Create Problem N template with tcolorbox design and figures"
   ```

2. **一括伝播後**:
   ```bash
   git add high_school_exam/tokyo/*/*/0N/
   git commit -m "feat: Propagate Problem N to all 37 year/term combinations"
   ```

3. **図版補完後**:
   ```bash
   git add high_school_exam/tokyo/*/*/0N/fig_*
   git commit -m "feat: Complete all figure files for Problem N"
   ```

---

## 参考: 完成度の目安（「ひな形として OK」の基準）

✅ **Ready for Template**:
- LaTeX 構文完全・コンパイルエラーなし
- 図版2+ 個含む（テンプレートの有効性証明）
- tcolorbox など装飾要素も含む（スタイリング確定）
- 本体ファイル + 図版ファイル の構造が明確

❌ **Not Ready**:
- まだ数値が仮置きで確定していない
- 図版が 1 個または未着手
- LaTeX Warning が多い
- 構造が流動的（修正予定がある）

---

## 将来の拡張（Problems 3-5 の見通し）

| 大問 | 想定構造 | ひな形状態 | Propagation |
|------|--------|----------|-------------|
| 1 | 9sub-files | ✅ 完成 | ✅ 全37済 |
| 2 | 単ファイル | ✅ 完成 | ✅ 全37済 |
| 3 | ? | 🔜 制作中 | 🔜 予定 |
| 4 | ? | 🔜 予定 | 🔜 予定 |
| 5 | ? | 🔜 予定 | 🔜 予定 |

**見積**: 大問3-5 それぞれ 1-2 日で「ひな形完成 + 全伝播」実現可能（Problems 1-2 実績ベース）

