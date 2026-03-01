# math-db フォルダ構造ガイド

**作成日**: 2026年3月1日

## 概要

このリポジトリは、高校数学・大学入試数学の問題・解答データベースです。
`physics-db` を参考にした階層的な subfiles 構造を採用しています。

### 運用ルール（重要）
- 一括処理で自動生成される作業用ファイル（ログ、一覧、移行補助ファイル、臨時出力など）は、
   原則としてすべて `scripts/` 配下に配置する。
- 問題・解答の本体ソース（TeX）は `university_exam/` および `high_school_exam/` に配置し、
   `scripts/` には置かない。

---

## フォルダ構造

```
math-db/
├── figures/                          # TikZ図形・ロゴ
│   ├── logo_miyoshi_1/
│   ├── logo_miyoshi_2/
│   ├── logo_miyoshi_3/
│   ├── logo_miyoshi_4/
│   ├── logo_miyoshi_5/
│   ├── logo_physics_1/
│   ├── logo_physics_2/
│   ├── logo_physics_3/
│   ├── logo_physics_4/
│   ├── logo_physics_5/
│   └── logo_physics_6/
│
├── scripts/                          # Copilotで作成した一括処理等
│   ├── compile/                      # LaTeX コンパイルスクリプト
│   │   ├── compile_all.ps1
│   │   ├── compile_all_standalone.ps1
│   │   ├── compile_all_tikz.ps1
│   │   └── ...
│   └── migration/                    # ファイル移行・変換スクリプト
│       └── ...
│
├── high_school_exam/                 # 高校入試問題
│   ├── tokyo_2026/                   # 東京都 2026年度
│   │   ├── ms_hs_tokyo_2026_q.tex    # 全問題
│   │   ├── ms_hs_tokyo_2026_a.tex    # 全解答
│   │   └── ...
│   ├── osaka_2026/                   # (将来) 大阪府 2026年度
│   └── ...
│
├── university_exam/                  # 大学入試問題
│   └── math-standard/                # 数学標準コース
│       │
│       ├── ms_q.tex                  # 【全体マスター】全科目・全問題
│       ├── ms_a.tex                  # 【全体マスター】全科目・全解答
│       │
│       ├── 1_suuI/                   # 数学 I
│       │   ├── ms_1_q.tex            # 【科目マスター】数I・全問題
│       │   ├── ms_1_a.tex            # 【科目マスター】数I・全解答
│       │   ├── 1_1_numbers-expressions/
│       │   │   ├── ms_1_1_q.tex      # 【大項目マスター】
│       │   │   ├── ms_1_1_a.tex
│       │   │   ├── polynomial-basics/
│       │   │   │   ├── ms_1_1_pb_q.tex   # 【細目）多項式基礎・問題
│       │   │   │   └── ms_1_1_pb_a.tex   # 【細目】多項式基礎・解答
│       │   │   └── ...
│       │   ├── 1_2_quadratic-functions/
│       │   │   ├── ms_1_2_q.tex
│       │   │   ├── ms_1_2_a.tex
│       │   │   └── ...
│       │   └── ...
│       │
│       ├── 2_suuII/                  # 数学 II
│       │   ├── ms_2_q.tex            # 【科目マスター】数II・全問題
│       │   ├── ms_2_a.tex            # 【科目マスター】数II・全解答
│       │   ├── 2_1_expressions-proofs/
│       │   │   ├── ms_2_1_q.tex      # 【大項目マスター】
│       │   │   ├── ms_2_1_a.tex
│       │   │   ├── polynomial-division/
│       │   │   │   ├── ms_2_1_pd_q.tex
│       │   │   │   └── ms_2_1_pd_a.tex
│       │   │   └── ...
│       │   ├── 2_2_complex-numbers/
│       │   │   ├── ms_2_2_q.tex
│       │   │   ├── ms_2_2_a.tex
│       │   │   ├── complex-basics/
│       │   │   │   ├── ms_2_2_cb_q.tex
│       │   │   │   └── ms_2_2_cb_a.tex
│       │   │   └── ...
│       │   └── ...
│       │
│       ├── A_suuA/                   # 数学 A （将来）
│       │   └── ...
│       ├── B_suuB/                   # 数学 B （将来）
│       │   └── ...
│       ├── 3_suuIII/                 # 数学 III （将来）
│       │   └── ...
│       └── C_suuC/                   # 数学 C （将来）
│           └── ...
│
└── README_STRUCTURE.md               # このファイル
```

---

## 命名規則

### プロジェクト識別子
- `ms` = **math-standard**（プロジェクト全体の識別子）

### ファイル拡張子
- `_q` = **question**（問題）
- `_a` = **answer**（解答）

### レベル別の命名規則

| レベル | 科目例 | 大項目例 | 細目例 |
|--------|--------|---------|---------|
| **全体マスター** | - | - | `ms_q.tex`, `ms_a.tex` |
| **科目マスター** | 数I=1, 数II=2, 数A=A, 数B=B, 数III=3, 数C=C | - | `ms_1_q.tex`, `ms_2_q.tex` |
| **大項目マスター** | - | 2_1（数II第1項目） | `ms_2_1_q.tex`, `ms_2_1_a.tex` |
| **細目ファイル** | - | - | `ms_2_1_pd_q.tex`（pd="polynomial-division"） |

### 具体例
```
ms_q.tex                    ← 数学全体の全問題（最上位）
ms_2_q.tex                  ← 数II全体の全問題（科目レベル）
ms_2_1_q.tex                ← 数II・式と証明の全問題（大項目レベル）
ms_2_1_pd_q.tex             ← 数II・式と証明・多項式の割り算（細目レベル）
```

---

## subfiles 構造

問題・解答は **3階層の subfiles 構造** になっています：

```
【レイアウト1】全体マスター → 科目マスター → 大項目マスター → 細目ファイル

ms_q.tex
  ↓ subfile
  → 2_suuII/ms_2_q.tex
      ↓ subfile
      → 2_1_expressions-proofs/ms_2_1_q.tex
          ↓ subfile
          → polynomial-division/ms_2_1_pd_q.tex
```

### 各レベルの役割

1. **全体マスター** (`ms_q.tex`, `ms_a.tex`)
   - 全科目を一括編集・コンパイル
   - ヘッダー・フッター・パッケージ設定を一元管理

2. **科目マスター** (`ms_1_q.tex`, `ms_2_q.tex`, ...)
   - 各科目（数I, 数II, 数A など）の全問題・解答
   - 科目単位でのコンパイルが可能

3. **大項目マスター** (`ms_2_1_q.tex`, `ms_2_1_a.tex`, ...)
   - 各科目内の大項目（単元）の全問題・解答
   - 大項目単位での抽出・編集が可能

4. **細目ファイル** (`ms_2_1_pd_q.tex`, ...)
   - 実際の問題文・解答が記述されているファイル
   - subfiles document class で独立コンパイル可能

---

## フォルダ名の命名規則

### 科目フォルダ
- `1_suuI` = 数学 I
- `2_suuII` = 数学 II
- `A_suuA` = 数学 A
- `B_suuB` = 数学 B
- `3_suuIII` = 数学 III
- `C_suuC` = 数学 C

### 大項目フォルダ
例）数学II の場合
- `2_1_expressions-proofs` = 式と証明（英名：expressions-proofs）
- `2_2_complex-numbers` = 複素数と方程式（英名：complex-numbers）
- `2_3_logarithmic-exponential` = 指数関数・対数関数（英名：logarithmic-exponential）

**英名はハイフン区切りで、すべて小文字**

### 細目フォルダ
例）数学II・式と証明の場合
- `polynomial-division` = 多項式の割り算（英名）
- `factorization` = 因数分解
- `proofs` = 証明問題

---

## 相対パス設定

### 全体マスターから参照する場合
```tex
\subfile{2_suuII/ms_2_q.tex}
```

### 科目マスターから参照する場合（科目フォルダ内）
```tex
\documentclass[../ms_q.tex]{subfiles}
\subfile{2_1_expressions-proofs/ms_2_1_q.tex}
```

### 大項目マスターから参照する場合（大項目フォルダ内）
```tex
\documentclass[../../ms_q.tex]{subfiles}
\subfile{polynomial-division/ms_2_1_pd_q.tex}
```

### 細目ファイルの場合（細目フォルダ内）
```tex
\documentclass[../../../ms_q.tex]{subfiles}
\begin{document}
% 実際の問題・解答を記載
\end{document}
```

---

## 将来の拡張

このデータベースは段階的に拡張される予定です：

### Phase 1：現状（数学II の整備）
- 数II: 式と証明、複素数と方程式

### Phase 2：数学I～IIIの整備
- 数I: 数と式、方程式・不等式、二次関数、三角比、図形と方程式
- 数III: 極限、微分、積分
- 数A, B, C: 各単元の整備

### Phase 3：高校入試版の拡張
```
high_school_exam/
├── tokyo_2026/
├── tokyo_2025/
├── osaka_2026/
├── kyoto_2026/
└── ...
```

### Phase 4：対策教材の自動生成
- テーマ別問題集
- 難易度別演習
- 公式・定理チートシート

---

## スクリプト（scripts フォルダ）

### compile/
- 全 LaTeX ファイルの自動コンパイル
- 分野別・科目別の部分コンパイル
- TikZ 図の独立コンパイル

### migration/
- フォルダ構造の移行スクリプト
- ファイルのリネーム・整理
- 古い構造から新構造への自動変換

---

## 編集のヒント

### 新しい問題を追加する場合
1. 適切な細目フォルダを選択（例：`2_1_expressions-proofs/polynomial-division/`）
2. `ms_2_1_pd_q.tex` に問題を追加、`ms_2_1_pd_a.tex` に解答を追加
3. ファイルをコンパイルして確認

### 新しい大項目を追加する場合
1. 科目フォルダ内に新フォルダを作成（例：`2_3_logarithmic-exponential/`）
2. `ms_2_3_q.tex`, `ms_2_3_a.tex` を作成
3. 細目フォルダ・ファイルを追加
4. 科目マスター `ms_2_q.tex` に subfile を追加

### 新しい科目を追加する場合
1. `university_exam/math-standard/` に新フォルダを作成（例：`1_suuI/`）
2. `ms_1_q.tex`, `ms_1_a.tex` を作成
3. 大項目フォルダを追加
4. 全体マスター `ms_q.tex` に subfile を追加

---

## 参考：physics-db との比較

| 項目 | physics-db | math-db |
|------|-----------|---------|
| プロジェクト ID | `ps` | `ms` |
| 分野例 | 力学(me), 電磁気(em), 熱力学(th) | 数I(1), 数II(2), 数A(A) |
| 細目コード | `ps_em_ef` (electromagnetsim-electric-field) | `ms_2_1_pd` (suuII-expressions-proofs-polynomial-division) |
| フォルダ階層 | 2階層（分野別） | 3階層（科目→大項目→細目） |

---

**最終更新**: 2026年3月1日  
**バージョン**: 1.0
