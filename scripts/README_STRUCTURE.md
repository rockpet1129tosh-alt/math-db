# math-db 構造ガイド（現行）

更新日: 2026-03-21

## 1. このファイルの目的

- 現在の `math-db` 構成を正確に示す。
- `scripts/` から各運用ドキュメントへの入口を明確化する。

## 2. ルート構成（要約）

```text
math-db/
├── figures/
├── high_school_exam/
│   └── tokyo/
├── university_exam/
│   ├── math-standard/
│   └── tokyo-u/
└── scripts/
    ├── docs/
    ├── compile/
    ├── migration/
    └── *.md
```

## 3. scripts 内の責務

- `scripts/docs/`: 正式運用ドキュメント
- `scripts/compile/`: コンパイル補助
- `scripts/migration/`: 移行・変換スクリプト
- `scripts/*.md`: 作業ログ・方針・補助記録

## 4. 先に読む順番

1. [README.md](README.md)
2. [docs/README.md](docs/README.md)
3. [docs/RULES.md](docs/RULES.md)
4. [docs/high_school_exam.md](docs/high_school_exam.md)
5. [docs/university_exam.md](docs/university_exam.md)

## 5. 現在のデータ設計

### 5.1 高校入試（東京）

- ベース: `high_school_exam/tokyo/`
- 年度 + `1st/2nd` を維持
- 大問単位で図版ディレクトリを管理

### 5.2 大学入試（Tokyo-U）

- ベース: `university_exam/tokyo-u/`
- 2025 は試験セット方式を採用
- 正本階層: `2025/<set-id>/`（`sets/` 中間階層なし）
- `_original` は試験セット直下
- 命名規則: `uem_tok_YYYY_term_track_...`

## 6. ドキュメント分担

- 高校入試詳細: [docs/high_school_exam.md](docs/high_school_exam.md)
- 大学入試詳細: [docs/university_exam.md](docs/university_exam.md)
- 共通規則: [docs/RULES.md](docs/RULES.md)
- 実作業手順: [docs/WORKFLOW.md](docs/WORKFLOW.md)

## 7. 更新ルール

- 構成を変更したら、このファイルを更新する。
- `docs` に新規ファイルを追加したら [docs/README.md](docs/README.md) に追記する。
- 廃止した構成は明記して、参照先を残さない。
