# Enumerate フォーマット調整メモ
**作成日**: 2026年3月3日  
**対象**: 都立高校入試問題 大問4 テンプレート

---

## 本日の作業サマリー

### 目標
- レベル1（大問内の問題）の enumerate 形式を「（1）」から「[問1]」「［問1］」に変更
- レベル2（ネストされた小問）は丸数字 ①②③ を維持
- ラベルと本文位置を独立に調整する

### 最終設定

**レベル1（大問内の複数問）**:
```tex
\setlist[enumerate]{label=\llap{［問\arabic*］\hspace{3\zw}},
    topsep=2pt, itemsep=7pt, itemindent=2\zw, leftmargin=2\zw}
```
- **ラベル形式**: 全角括弧 `［問1］`
- **ラベル配置**: `\llap` + `\hspace{3\zw}` で左端より少し右に配置
- **本文開始位置**: `leftmargin=2\zw + itemindent=2\zw` = **4\zw**

**レベル2（下位の細かい問）**:
```tex
\setlist[enumerate,2]{label=\textcircled{\scriptsize\arabic*},
    topsep=2pt, itemsep=5pt, leftmargin=1\zw,
    labelwidth=1.2\zw, labelsep=.4\zw, itemindent=1\zw, align=left}
```
- **ラベル形式**: 丸数字 ①②③（`\textcircled` で描画）
- **本文開始位置**: `leftmargin=1\zw + itemindent=1\zw` = **2\zw**（レベル1より1zw奥）

### 変更履歴

| 段階 | 形式 | ラベル配置方法 | 結果 |
|-----|------|-----------|------|
| 1 | `（1）` |標準構文（`label=...`） | ゴシック体、本文重い |
| 2 | `[問1]` | 半角括弧 | 原本PDFに合わせたが視認性低 |
| 3 | `[\問1]` | 全角括弧 + `labelindent=-2\zw` | labelindent効果なし |
| 4 | 全角括弧 | `labelindent=-4, -8, -12, -20\zw` | どれも効果なし（enumitem内部制約） |
| 5 | 全角括弧 | **`\llap{...}\hspace{...}`** | ✅ 成功（フレキシブルな配置可能） |

---

## 技術ノート：重要な学び

### Problem 1: enumitem の labelindent 制限
**問題**: `labelindent=-Nx\zw` で大きな負の値を指定しても、ラベルの位置が実際には変わらない
**原因**: enumitem が label 配置の計算を内部で制限している（おそらく `labelwidth` や `labelsep` との相互作用）
**解決策**: `labelindent` ではなく、`label=` の内側で直接配置制御を使う

### Solution: `\llap` + `\hspace` パターン
```tex
label=\llap{ラベルテキスト\hspace{距離}},
leftmargin=Nx\zw, itemindent=Mx\zw
```
- `\llap{...}` は内容を幅ゼロとして扱い、左端から配置
- `\hspace{Nx\zw}` でラベル右端から次の要素までの距離を指定
- 本文位置 = `leftmargin + itemindent` で独立に制御可能
- **利点**: ラベルと本文を完全に独立に制御できる

### 設定調整の自由度
`\hspace{}` と `itemindent` の組み合わせで、以下が独立制御可能：
- ラベル左端の位置（`\hspace` 値で調整）
- 本文開始位置（`leftmargin + itemindent` で調整）
- ラベルと本文の間隔（両者の差で決まる）

例：
```
\hspace{3\zw}, leftmargin=2\zw, itemindent=2\zw
→ ラベル位置: -2\zw〜3\zw, 本文位置: 4\zw
→ ラベルと本文の間: 1\zw（3zw から 4zw への間隔）
```

---

## 今後への活かし方

### 1. 他のリストやテンプレートで同じパターンを使う場合
```tex
% 基本パターン（応用可能）
\setlist[enumerate]{label=\llap{【ラベル】\hspace{X\zw}},
    itemindent=Y\zw, leftmargin=Z\zw, ...}
```
- `X`: ラベル右端から本文開始位置までの希望距離
- `Y + Z`: 本文開始位置（両者の和）

### 2. 問題時のデバッグ流れ
1. まず `labelindent` を試す（シンプルだから）
2. if 効果なし → `\llap + \hspace` に切り替え（確実）
3. 本文位置が勝手に動いたら → `itemindent` と `leftmargin` の合計を確認

### 3. 全角・半角括弧の選択基準
- **原本に合わせる**: 全角 `［問1］`（都立2025年入試PDF参照）
- **視認性重視**: ゴシック体で太くする（`\textsf{（...）}`）

---

## 大問4 の現在の進捗

✅ **完了**:
- enumerate レベル1・2 形式確定
- レベル1 ラベル配置完成（`\llap` パターン）
- 全37年度への自動伝播（preamble 一括変更）
- プリアンブル動作確認（コンパイル成功）

❌ **未完了**:
- 大問4 の図ファイル（2ファイル）は定義のみ、内容未実装

---

## ファイル参照

- **プリアンブル**: [hsm_tok_q.tex](../../../high_school_exam/tokyo/hsm_tok_q.tex#L71-L83)（lines 71-83）
- **テンプレート**: [hsm_tok_2025_1st_04_q.tex](../../../high_school_exam/tokyo/2025/1st/04/hsm_tok_2025_1st_04_q.tex)

---

## 次回の作業

1. 大問4 図ファイル の実装
2. 図コンパイル + PDF 生成確認
3. 必要に応じてレベル2 の itemindent 微調整（ネストの視認性）

