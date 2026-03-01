# 高校入試過去問数学データベース

## 概要
東京都立高校入試の数学過去問をTeX化し、体系的に管理するデータベースです。

## フォルダ構造（実装済み）

### 大問1: 小問分割型（9分割）
```
high_school_exam/tokyo/YYYY/TERM/01/
├── 01/
│   ├── hsm_tok_YYYY_TERM_01_01_q.tex
│   ├── hsm_tok_YYYY_TERM_01_01_a.tex
│   └── fig_hsm_tok_YYYY_TERM_01_01/
│       └── fig_hsm_tok_YYYY_TERM_01_01_q.tex（TikZ）
├── 02/ ... 03/ ... 09/
├── hsm_tok_YYYY_TERM_01_q.tex      （親ファイル）
├── hsm_tok_YYYY_TERM_01_a.tex      （解答）
```

### 大問2-3: 単ファイル型（分割なし）
```
high_school_exam/tokyo/YYYY/TERM/02/
├── hsm_tok_YYYY_TERM_02_q.tex
├── hsm_tok_YYYY_TERM_02_a.tex
└── fig_hsm_tok_YYYY_TERM_02/
    ├── fig_hsm_tok_YYYY_TERM_02_01_q.tex
    └── fig_hsm_tok_YYYY_TERM_02_02_q.tex
```

### 大問4-5: 制作予定
```
high_school_exam/tokyo/YYYY/TERM/04/
high_school_exam/tokyo/YYYY/TERM/05/
```

## 命名規則

### ファイル名形式
- **プレフィックス**: `hsm` = High School Math（高校入試数学）
- **地域コード**: `tok` = Tokyo（東京）3文字
- **年度**: `YYYY` = 4桁の西暦
- **時期**: `1st` / `2nd` = 第1回/第2回
- **大問番号**: `01`-`05` = 2桁ゼロ埋め
- **小問番号**: `01`-`XX` = 2桁ゼロ埋め
- **種別**: `q` = Question（問題）, `a` = Answer（解答）

### 命名例
| ファイル種別 | ファイル名例 | 説明 |
|------------|------------|------|
| 原本（問題） | `hsm_tok_2025_1st_src_q.pdf` | 2025年1st全問題の原本 |
| 原本（解答） | `hsm_tok_2025_1st_src_a.pdf` | 2025年1st全解答の原本 |
| 問題TeX | `hsm_tok_2025_1st_01_02_q.tex` | 2025年1st 大問1小問2 問題 |
| 解答TeX | `hsm_tok_2025_1st_01_02_a.tex` | 2025年1st 大問1小問2 解答 |

### 特殊ファイル
- `src` = source（原本）: 年度全体の問題・解答PDF（大問・小問番号なし）

## 対応進捗

### ✅ 完成・伝播済み
- **大問1（複合多問）**: 9小問分割型 → 全37年度/期間 伝播完了
- **大問2（円周等分問題）**: 単ファイル型・2問 → 全37年度/期間 伝播完了
- **大問3（一次関数）**: 単ファイル型・3問 → 全37年度/期間 伝播完了

### 🔜 進行中・待機
- **大問4**: Template 制作中
- **大問5**: Template 制作予定

### 📋 原本保管
- ✅ 2008-2026年 1st/2nd 全フォルダに `_original/hsm_tok_YYYY_{1st|2nd}_src_{q|a}.pdf` 配置
  - 年度フォルダ直下：`high_school_exam/tokyo/YYYY/1st/_original/`

## 拡張計画

### 他地域への拡張
命名規則は他都道府県への拡張を想定しています。

**地域コード例：**
- 大阪府：`hsm_osa_YYYY_1st_01_01_q.tex`
- 京都府：`hsm_kyo_YYYY_1st_01_01_q.tex`
- 神奈川県：`hsm_kng_YYYY_1st_01_01_q.tex`

**新規地域追加時の手順：**
1. `high_school_exam/[地域名]/` フォルダを作成
2. `hsm_[地域コード]_q.tex` / `hsm_[地域コード]_a.tex` を作成（全体マスター）
3. 各年度のフォルダ構造とTeXファイルを同様に作成
4. `scripts/docs/high_school_exam.md` に地域情報を追記

### 小問数の調整
階層4（大問別マスター）で、実際の問題に応じて小問参照を追加：
```tex
% デフォルト（小問1のみ）
\subfile{01/hsm_tok_2025_1st_01_01_q.tex}

% 小問が3つある場合
\subfile{01/hsm_tok_2025_1st_01_01_q.tex}
\subfile{02/hsm_tok_2025_1st_01_02_q.tex}
\subfile{03/hsm_tok_2025_1st_01_03_q.tex}
```

## TeX階層構造（5階層）

### 階層1: 全体マスター
**ファイル**: `tokyo/hsm_tok_q.tex`, `tokyo/hsm_tok_a.tex`

- 東京都立高校の全年度を統合するマスターファイル
- 2008-2026年の各年度別ファイルを `\subfile{}` で参照

### 階層2: 年度別マスター
**ファイル**: `tokyo/YYYY/hsm_tok_YYYY_q.tex`, `tokyo/YYYY/hsm_tok_YYYY_a.tex`

- 特定年度（例: 2025年）の1st/2ndを統合
- `\documentclass[../../hsm_tok_q.tex]{subfiles}` でルートマスターを参照
- `\section{YYYY 年度}` でセクション見出し

### 階層3: 時期別マスター
**ファイル**: `tokyo/YYYY/1st/hsm_tok_YYYY_1st_q.tex`, `tokyo/YYYY/2nd/hsm_tok_YYYY_2nd_q.tex`

- 特定時期（1st または 2nd）の大問01-05を統合
- `\documentclass[../../../hsm_tok_q.tex]{subfiles}` でルートマスターを参照
- `\subsection{1st}` でサブセクション見出し

### 階層4: 大問別マスター
**ファイル**: `tokyo/YYYY/1st/01/hsm_tok_YYYY_1st_01_q.tex` （大問01-05）

- 特定大問の小問（01, 02, ...）を統合
- `\documentclass[../../../../hsm_tok_q.tex]{subfiles}` でルートマスターを参照
- `【大問1】` などの見出し
- 小問数は問題により異なるため、必要に応じて `\subfile{02/...}` などを追加

### 階層5: 小問別ファイル（最下層）
**ファイル**: `tokyo/YYYY/1st/01/01/hsm_tok_YYYY_1st_01_01_q.tex`

- **実際の問題内容を記述する最下層ファイル**
- `\documentclass[../../../../../hsm_tok_q.tex]{subfiles}` でルートマスターを参照
- このファイルに問題文・図・数式などを直接記述

### 階層構造の例
```
hsm_tok_q.tex（階層1: 全体）
  └─ 2025/hsm_tok_2025_q.tex（階層2: 年度別）
      └─ 1st/hsm_tok_2025_1st_q.tex（階層3: 時期別）
          └─ 01/hsm_tok_2025_1st_01_q.tex（階層4: 大問別）
              ├─ 01/hsm_tok_2025_1st_01_01_q.tex（階層5: 小問1）
              ├─ 02/hsm_tok_2025_1st_01_02_q.tex（階層5: 小問2）
              └─ 03/hsm_tok_2025_1st_01_03_q.tex（階層5: 小問3）
```

### 作業の進め方
1. **問題入力**: 階層5（最下層）のファイルに実際の問題を記述
2. **小問追加**: 必要に応じて階層4のファイルで小問02, 03... を追加
3. **コンパイル**: ルートマスター（階層1）からコンパイルして全体確認
4. **個別確認**: 任意の階層からコンパイルして部分確認も可能

## TeXコンパイル規則

### ドキュメントクラス
- エンジン: `lualatex`
- クラス: `jlreq`（日本語組版）
- パッケージ: `subfiles`（階層管理）

### 相対パス計算
- 小問TeX → 年度マスター: `../../../`
- 小問TeX → 原本PDF: `../../_original/`

## 作業履歴

- 2026-03-01: 初期構造作成（2008-2026年、19年分のフォルダ構造）
- 2026-03-01: 原本PDF配置（2008-2019 1st, 2020-2025 両方, 2026 1st）
- 2026-03-01: 命名規則確定（hsm_tok形式、src原本タグ）
- 2026-03-01: 5階層TeXファイル構造作成完了（全876ファイル）
  - 階層1: 全体マスター（2ファイル）
  - 階層2: 年度別マスター（38ファイル）
  - 階層3: 時期別マスター（76ファイル）
  - 階層4: 大問別マスター（380ファイル）
  - 階層5: 小問別ファイル（380ファイル）
