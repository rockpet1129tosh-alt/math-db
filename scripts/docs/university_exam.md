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
