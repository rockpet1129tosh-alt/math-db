# 大学入試DB運用ガイド（Tokyo-U 起点）

更新日: 2026-03-22
対象: `university_exam/`

## 1. 目的

- 大学別・年度別・試験方式別（文科/理科）を一貫管理する。
- 将来の横断検索とプリント生成を前提に、TeXファイルとメタデータを構造化する。

## 2. Tokyo-U の確定仕様

### 2.1 試験構成

| 試験セット | コード | 大問数 | 備考 |
|---|---|---|---|
| 前期 理科 | `f_sci` | 6 | 理系学部対象 |
| 前期 文科 | `f_hum` | 4 | 文系学部対象 |

- **東大は前期のみ**。後期（l）は作成しない。
- term コードは `f` 固定。tracks は `sci` / `hum`。

## 2A. Meiji-U の雛形仕様

### 2A.1 試験構成

| 試験セット | コード | 大問数 | 備考 |
|---|---|---|---|
| 全学部1 | `uni1` | 未確定 | 全学部方式 |
| 全学部2 | `uni2` | 未確定 | 全学部方式 |
| 政治経済学部 | `pole` | 未確定 | 学部別 |
| 商学部 | `comm` | 未確定 | 学部別 |
| 経営学部 | `bus` | 未確定 | 学部別 |
| 情報コミュニケーション学部 | `icom` | 未確定 | 学部別 |
| 理工学部 | `scit` | 未確定 | 学部別 |
| 総合数理学部 | `smth` | 未確定 | 学部別 |
| 農学部 | `agr` | 未確定 | 学部別 |

- Meiji-U は `term/track` ではなく `set_code` で管理する。
- 2025 時点では、問題数未確定のため 9 セット分の雛形と meta のみ作成し、大問ファイルは未展開。

### 2A.2 命名規則

- `uem_mei_YYYY_set_q.tex`
- `uem_mei_YYYY_set_a.tex`
- `uem_mei_YYYY_set_problem_q.tex`
- `uem_mei_YYYY_set_problem_a.tex`

例:

- `uem_mei_2025_uni1_q.tex`
- `uem_mei_2025_pole_q.tex`
- `uem_mei_2025_scit_q.tex`
- `uem_mei_2025_smth_01_q.tex`

### 2A.3 階層イメージ

```
university_exam/meiji-u/
├── uem_mei_q.tex
├── uem_mei_a.tex
├── uem_mei_0master.tex
└── 2025/
	├── uem_mei_2025_q.tex
	├── uem_mei_2025_a.tex
	├── mei_2025_uni1/
	├── mei_2025_uni2/
	├── mei_2025_pole/
	├── mei_2025_comm/
	├── mei_2025_bus/
	├── mei_2025_icom/
	├── mei_2025_scit/
	├── mei_2025_smth/
	├── mei_2025_agr/
	└── meta/
```

### 2.2 大元ファイル（ルート）

| ファイル | 役割 |
|---|---|
| `university_exam/tokyo-u/uem_tok_q.tex` | 問題集 ルート（jlreq preamble） |
| `university_exam/tokyo-u/uem_tok_a.tex` | 解答集 ルート（jlreq preamble） |

- 全 subfile の `\documentclass[...]{subfiles}` は**必ずこのルートを指す**。
- 中間 aggregator（年度・セット集約）は subfile であり preamble を持たないため、チェーン参照は不可。

### 2.3 subfiles 参照パス規則（重要）

| ファイル階層 | `\documentclass` に書くパス |
|---|---|
| `YYYY/uem_tok_YYYY_q.tex` | `../uem_tok_q.tex` |
| `YYYY/tok_YYYY_f_sci/uem_tok_YYYY_f_sci_q.tex` | `../../uem_tok_q.tex` |
| `YYYY/tok_YYYY_f_sci/NN/uem_tok_YYYY_f_sci_NN_q.tex` | `../../../uem_tok_q.tex` |

すべて `uem_tok_q.tex` / `uem_tok_a.tex` に向ける（1階層上を指すチェーンは使わない）。

### 2.4 `0master` 運用ルール（共通プリンブル）

- `uem_*_0master.tex` は **共通プリンブル断片** として扱う（`\documentclass` と `\begin{document}` を置かない）。
- 実親は `uem_*_q.tex` / `uem_*_a.tex` とし、各実親で `\documentclass` を宣言したうえで `\input{uem_*_0master.tex}` を読む。
- 子ファイル（年度・セット・大問）は、`q` 系は `uem_*_q.tex`、`a` 系は `uem_*_a.tex` を参照する。
- 子ファイルから `uem_*_0master.tex` を直接参照しない（q/a差分タイトルや設定が失われるため）。

コンパイル運用:

- `0master` は単体コンパイル対象にしない。
- LaTeX Workshop の `rootFiles.exclude` と `watch.files.ignore` に `uem_*_0master.tex` を登録する。
- 子ファイル単体ビルドは作業ディレクトリ依存を避けるため `latexmk -cd` を推奨。

## 3. 階層設計

```
university_exam/tokyo-u/
├── uem_tok_q.tex              ← ルート（問題）
├── uem_tok_a.tex              ← ルート（解答）
├── YYYY/
│   ├── uem_tok_YYYY_q.tex     ← 年度集約（問題）
│   ├── uem_tok_YYYY_a.tex     ← 年度集約（解答）
│   ├── tok_YYYY_f_sci/        ← 試験セット（前期理科）
│   │   ├── uem_tok_YYYY_f_sci_q.tex
│   │   ├── uem_tok_YYYY_f_sci_a.tex
│   │   ├── 01/ ～ 06/
│   │   │   ├── uem_tok_YYYY_f_sci_NN_q.tex
│   │   │   ├── uem_tok_YYYY_f_sci_NN_a.tex
│   │   │   └── fig_uem_tok_YYYY_f_sci_NN/  ← 図版フォルダ
│   │   └── _original/
│   ├── tok_YYYY_f_hum/        ← 試験セット（前期文科）
│   │   ├── uem_tok_YYYY_f_hum_q.tex
│   │   ├── uem_tok_YYYY_f_hum_a.tex
│   │   ├── 01/ ～ 04/
│   │   │   ├── uem_tok_YYYY_f_hum_NN_q.tex
│   │   │   ├── uem_tok_YYYY_f_hum_NN_a.tex
│   │   │   └── fig_uem_tok_YYYY_f_hum_NN/
│   │   └── _original/
│   └── meta/
│       ├── uem_tok_YYYY_meta.yaml
│       ├── EXAM_UNITS.yaml
│       └── TAG_GUIDE.yaml
```

### 3.1 `_original` 配置ルール

- 原本（スキャンPDF等）は試験セット直下 `_original/` に配置。
- 大問配下には置かない。

### 3.2 図版配置ルール

- 図版は大問単位で `NN/fig_uem_tok_YYYY_f_sci_NN/` に配置。

## 4. 命名規則

### 4.1 パターン

```
uem_tok_YYYY_term_track_problem_q.tex   ← 大問ファイル
uem_tok_YYYY_term_track_q.tex           ← セット集約（problemを省略）
uem_tok_YYYY_q.tex                      ← 年度集約（term/trackを省略）
```

### 4.2 コード体系

| 区分 | コード | 意味 |
|---|---|---|
| prefix | `uem` | university exam math |
| univ | `tok` | tokyo-u |
| term | `f` | 前期（東大はこれのみ） |
| track | `sci` | 理科 |
| track | `hum` | 文科 |

私大セット型の例:

| 区分 | コード | 意味 |
|---|---|---|
| univ | `mei` | meiji-u |
| set | `uni1` | 全学部統一1 |
| set | `uni2` | 全学部統一2 |
| set | `scit` | 理工学部 |
| set | `agr` | 農学部 |

## 5. メタデータ運用

### 5.1 構成ファイル（年度直下 `meta/`）

| ファイル | 内容 |
|---|---|
| `uem_tok_YYYY_meta.yaml` | 年度全体・セット一覧・検索フラグ |
| `EXAM_UNITS.yaml` | 学部群↔試験セットの対応定義 |
| `TAG_GUIDE.yaml` | domain/skill/形式タグの候補管理 |

### 5.2 将来の問題単位メタ（現在未使用）

- 横断抽出が必要になった段階で `meta/records/<id>.yaml` を追加予定。
- フィールド候補: `domains`, `skills`, `format`, `difficulty`, `tags`

## 6. 実施記録

### 2026-03-21

1. Tokyo-U 2025 を試験セット方式へ移行。
2. `sets/` 中間階層を廃止してフラット構成に変更。
3. subfiles 参照を全てルート（`uem_tok_q.tex`）に向けるよう統一。
4. `_original` を試験セット直下へ統一。

### 2026-03-22

1. 東大は前期のみ・`l_common` 不要という仕様を確定。
2. f_sci: 6問、f_hum: 4問 を確定（2025実ファイルで検証済み）。
3. 2025 meta から l_common を削除、problem_count を修正。
4. 2020〜2024 の雛形を一括作成。
5. Meiji-U 2025 の4セット雛形（`uni1` / `uni2` / `scit` / `agr`）を追加。

## 7. 今後の作業計画

### Phase A: 各年度 実データ投入

- 2020〜2024 の問題文を各年度の `NN_q.tex` に入力。
- 解答文を `NN_a.tex` に入力。
- `_original/` に原本PDF等を配置。

### Phase B: 問題単位メタの導入（必要時）

- 横断抽出を開始する段階で `meta/records/` を追加。

### Phase C: 横断検索・プリント生成

1. 条件抽出スクリプト（PowerShell）を作成。
2. `EXAM_UNITS.yaml` を起点に大学横断インデックスを構築。
3. タグ・難易度・形式条件での問題セット自動生成。

## 8. 運用チェックリスト

新しい年度を追加するとき：
- [ ] `YYYY/uem_tok_YYYY_q/a.tex` を作成したか。
- [ ] `YYYY/tok_YYYY_f_sci/` と `tok_YYYY_f_hum/` を作成したか（`sets/` 不要）。
- [ ] 全 tex の `\documentclass` がルートを指しているか。
- [ ] `_original/` は試験セット直下に置いたか。
- [ ] `meta/uem_tok_YYYY_meta.yaml` と `EXAM_UNITS.yaml` を作成したか。
- [ ] 旧階層（`f/l` 直下）に依存していないか。
- [ ] `uem_*_0master.tex` は「共通プリンブル断片」として運用されているか（子が直接参照していないか）。
