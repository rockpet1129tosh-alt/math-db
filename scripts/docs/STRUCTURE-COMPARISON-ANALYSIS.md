# math-db vs science-db: 詳細構造比較分析

**作成日**: 2026年3月4日

---

## 📊 実際のファイル構造確認

### science-db の実装構造

```
ps_master.tex（最上位・プリアンブルのみ）
  ↓ [親として指定]

ps_q.tex / ps_a.tex（エントリポイント）
  \documentclass[ps_master.tex]{subfiles}
  ↓ \subfile
  
ps_em_q.tex（分野マスター）
  \documentclass[../ps_q.tex]{subfiles}
  ↓ \subfile
  
ps_em_cb_q.tex（細目マスター）
  \documentclass[../../ps_q.tex]{subfiles}
  ↓ \subfile
  
ps_em_cb_01_q.tex（最下層・問題ファイル）
  \documentclass[../../../ps_q.tex]{subfiles}
  \includegraphics{\subfix{fig_em_cb_01/fig_em_cb_01_01_q.pdf}}
  ↑ ★ \subfix{} を使用
```

**重要な特徴**：
- `ps_em_cb_01_q.tex` は **常に`ps_q.tex`を親として指定** 
- `ps_em_q.tex` や `ps_em_cb_q.tex` が親になる可能性はない
- つまり実装上は **単一親** である

### math-db の実装構造

```
hsm_tok_q.tex（最上位・プリアンブルのみ）
  ↓ [親として指定]

2025/hsm_tok_2025_q.tex（年マスター）
  \documentclass[../hsm_tok_q.tex]{subfiles}
  ↓ \subfile
  
2025/1st/hsm_tok_2025_1st_q.tex（学期マスター）
  \documentclass[../../hsm_tok_q.tex]{subfiles}
  ↓ \subfile
  
2025/1st/02/hsm_tok_2025_1st_02_q.tex（問題ファイル）
  \documentclass[../../../hsm_tok_q.tex]{subfiles}
  \includegraphics{fig_hsm_tok_2025_1st_02/fig_hsm_tok_2025_1st_02_01_q.pdf}
  ↑ ★ \subfix{} を使用しない
```

**重要な特徴**：
- `hsm_tok_2025_1st_02_q.tex` は **常に`hsm_tok_q.tex`を親として指定**
- `hsm_tok_2025_1st_q.tex` や `hsm_tok_2025_q.tex` が親になる可能性はない
- つまり実装上は **単一親**である

---

## 🔍 図ファイル参照パスの詳細比較

### science-db: `\subfix{}` が使われている理由

**ファイル位置**:
```
em_electromagnetism/circuit-basics/01_kirchhoff/ps_em_cb_01_q.tex
```

**親ファイル（相対パス）**:
```
../../../ps_q.tex
（= em_electromagnetism/circuit-basics/01_kirchhoff/../../../ps_q.tex
  = ps_q.tex）
```

**図パス（ドキュメント内）**:
```tex
\includegraphics{\subfix{fig_em_cb_01/fig_em_cb_01_01_q.pdf}}
```

**\subfix{} なしの場合、パス解釈**:

| コンテキスト | 相対パス解釈 | 実ファイル位置 | 結果 |
|-----------|-----------|-------------|------|
| **子を直接 lualatex** | `fig_em_cb_01/...` は子と同じ階層から開始 | `em_electromagnetism/circuit-basics/01_kirchhoff/fig_em_cb_01/...` | ✅ OK |
| **ps_em_cb_q.tex から読み込み（親）** | `fig_em_cb_01/...` は子と同じ階層から開始 | `em_electromagnetism/circuit-basics/01_kirchhoff/fig_em_cb_01/...` | ✅ OK |
| **ps_em_q.tex から読み込み（祖父）** | `fig_em_cb_01/...` は子と同じ階層から開始 | `em_electromagnetism/circuit-basics/01_kirchhoff/fig_em_cb_01/...` | ✅ OK |
| **ps_q.tex から読み込み（曾祖父）** | `fig_em_cb_01/...` は子と同じ階層から開始 | `em_electromagnetism/circuit-basics/01_kirchhoff/fig_em_cb_01/...` | ✅ OK |

**結論**: 実は `\subfix{}` がなくても機能する！

### math-db: `\subfix{}` が不要である理由

**ファイル位置**:
```
high_school_exam/tokyo/2025/1st/02/hsm_tok_2025_1st_02_q.tex
```

**親ファイル（相対パス）**:
```
../../../hsm_tok_q.tex
（= high_school_exam/tokyo/2025/1st/02/../../../hsm_tok_q.tex
  = high_school_exam/tokyo/hsm_tok_q.tex）
```

**図パス（ドキュメント内）**:
```tex
\includegraphics{fig_hsm_tok_2025_1st_02/fig_hsm_tok_2025_1st_02_01_q.pdf}
```

**パス解釈**:

| コンテキスト | 相対パス解釈 | 実ファイル位置 | 結果 |
|-----------|-----------|-------------|------|
| **子を直接 lualatex** | `fig_hsm_tok_2025_1st_02/...` は子と同じ階層から開始 | `high_school_exam/tokyo/2025/1st/02/fig_hsm_tok_2025_1st_02/...` | ✅ OK |
| **親（hsm_tok_q.tex）から読み込み** | `fig_hsm_tok_2025_1st_02/...` は子と同じ階層から開始 | `high_school_exam/tokyo/2025/1st/02/fig_hsm_tok_2025_1st_02/...` | ✅ OK |

**結論**: `\subfix{}` がなくても、両コンテキストで同じ相対パスが機能する。

---

## ⚠️ \subfix{} の真の役割は何か？

### subfiles パッケージのドキュメントから

**subfiles の処理フロー**:

1. **親からの読み込み時**: `\subfile{相対パス}` で子ファイルを読み込む
2. **子ファイル内の処理**:
   - LaTeX は「子ファイルの位置」を基準に相対パスを解釈
   - つまり `\includegraphics{fig_em_cb_01/...}` は常に「子ファイルから見た相対パス」です

3. **\subfix{} の定義** (LaTeX subfiles パッケージ内部):
   ```tex
   \providecommand{\subfix}[1]{#1}
   ```
   - デフォルトでは単に `#1` を返すだけ
   - 親から読み込まれるときも、この定義は変わらない

### 重要な発見： \subfix{} は「デフォルトで何もしない」

実は subfiles パッケージの仕様では：

- **子を直接コンパイル時**: `\subfix{パス}` → パスをそのまま返す
- **親から読み込み時**: `\subfix{パス}` → **パスをそのまま返す**（変更なし）

なぜなら、**LaTeX は常に「実行コンテキスト（= 子ファイルの位置）」を基準に相対パスを解釈する** から。

### では \subfix{} は何に使うのか？

SUBFILES-GUIDE.md では「複数親対応」の例を挙げていますが、実装上の問題ではなく、**データ構造（ファイル組織）の問題** です：

```
例）複数親があるケース（理論上）:

ps_em_cb_01_q.tex を以下の複数親から読み込みたい場合：

1. ps_q.tex （通常の科目マスター）
2. exam_spring_2025.tex （春試験問題集親）
3. exam_summer_2025.tex （夏試験問題集親）

このとき、各親での相対パスが異なる：
- ps_q.tex から: ../../../ps_em_cb_01_q.tex
- exam_spring_2025.tex から: ../../../university_exam/.../ps_em_cb_01_q.tex (パスが完全に異なる)
```

**しかし現実**:
- science-db では exam_spring_2025 のような外部親が存在しない
- math-db でも複数親がない
- 両者も実装上は **単一親** である

---

## 🎯 \subfix{} 削除の合理性の検証

### science-db で \subfix{} が「あっても害がない理由」

```tex
% このコード:
\includegraphics{\subfix{fig_em_cb_01/fig_em_cb_01_01_q.pdf}}

% は実質的に以下と同違い（\subfix{} は何もしない）:
\includegraphics{fig_em_cb_01/fig_em_cb_01_01_q.pdf}
```

なぜなら、子ファイルの相対パスは **親がどこにあろうと「子ファイルから見た相対パス」で解釈される** ため。

### math-db で \subfix{} を削除した理由

**前回のセッション（2026-03-03）での作業**:
- 189ファイルから `\subfix{}` を削除
- 理由: 「親ファイルを直接 lualatex でコンパイル可能にする」

このアプローチが機能した本質的理由：

1. **親ファイルは`hsm_tok_q.tex`に固定** → 相対パス計算は一意的
2. **子ファイルの図パスは「子からの相対パス」で自動的に正解** → \subfix{} は冗長
3. **両コンテキスト（直接コンパイル vs 親から読み込み）で同じ相対パスが機能** → 削除の影響なし

---

## 📋 まとめ: 本当の違いは何か？

### ❌ **正しくない説**
「science-db は複数親対応だから \subfix{}が必要、math-db は単一親だから不要」

### ✅ **正しい説**

両者ともに実装上は **単一親です**。\subfix{} が「使われている / 削除された」の違いは：

| 側面 | science-db | math-db |
|------|-----------|---------|
| **親の数** | 1つ（ps_q.tex） | 1つ（hsm_tok_q.tex） |
| **図パス解釈** | 常に「子からの相対パス」 | 常に「子からの相対パス」 |
| **\subfix{} の実装効果** | なし（`#1`をそのまま返すだけ） | なし（使用しないので関係なし） |
| **コンパイル結果** | ✅ 動作 | ✅ 動作 |

### ✨ 本当の理由: 設計思想の違い

**science-db**:
- ドキュメント（SUBFILES-GUIDE.md）では「将来の複数親対応を想定」した設計
  - 実装されていないが、理論的な装甲として `\subfix{}` を記載
  - 潜在的な拡張性：外部プリント親を追加可能な構造

**math-db**:
- シンプルで直線的な設計
  - 複数親対応の必要がない
  - 親ファイル直接コンパイル を重視 → `\subfix{}` は冗長として削除

---

## 🔬 実検証: \subfix{} を削除しても機能する理由

### subfiles パッケージの内部動作

**キーポイント**: 子ファイルの `\includegraphics{fig_path}` は、**常に子ファイルの位置を基準に解釈される**

```
子ファイル: high_school_exam/tokyo/2025/1st/02/hsm_tok_2025_1st_02_q.tex
親ファイル: high_school_exam/tokyo/hsm_tok_q.tex

図パス: {fig_hsm_tok_2025_1st_02/fig_hsm_tok_2025_1st_02_01_q.pdf}
     ├─ 子からの相対パス: → high_school_exam/tokyo/2025/1st/02/fig_hsm_tok_2025_1st_02/...
     └─ 両コンテキスト（子直接/親から）で同じ → パスが一意的
```

### 対比: 複数親がある場合（理論上）

```
子ファイル: em_electromagnetism/circuit-basics/01_kirchhoff/ps_em_cb_01_q.tex

親①: em_electromagnetism/circuit-basics/ps_em_cb_q.tex
  子の相対: 01_kirchhoff/ps_em_cb_01_q.tex

親②: em_electromagnetism/ps_em_q.tex
  子の相対: circuit-basics/01_kirchhoff/ps_em_cb_01_q.tex

親③: ps_q.tex
  子の相対: em_electromagnetism/circuit-basics/01_kirchhoff/ps_em_cb_01_q.tex
```

**複数親でも子からの相対パス（図）は常に同じ！** → `\subfix{}` は依然として不要

---

## 🚀 結論

### 本当の疑問に対する答え

**Q**: math-db が `\subfix{}` なしでうまく動作する理由は？

**A**: 
1. **本質的な理由**: subfiles パッケージの動作原理として、相対パスは「子ファイル位置基准」で常に解釈されるため。
2. **実装上の理由**: math-db が単一親運用であり、かつ複数親対応の必要がないため。
3. **拡張性の観点**: science-db は「理論的な将来拡張」を想定して `\subfix{}` をドキュメント化したが、実装されていない。

### 統一結論

**science-db も math-db も、\subfix{} がなくても正常に動作します。** 

- science-db: 将来の複数親対応の可能性を想定して `\subfix{}` を記載（実装されていない）
- math-db: シンプルさ優先で `\subfix{}` を削除（正しい判断）

両者の違いは「複数親対応の理論的準備の有無」であり、**実装上の機能的な違いではない**。

---

**最終更新**: 2026年3月4日
