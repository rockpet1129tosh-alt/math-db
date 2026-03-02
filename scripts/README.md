# scripts ハブ

このフォルダは、`math-db` の **運用ハブ** です。  
自動化・移行・作業ログ・運用ドキュメントをここに集約します。

## このフォルダの責務

- 一括処理で生成される補助ファイル（抽出結果、移行補助、作業ログ）を保管する
- 運用ドキュメント（ルール、ワークフロー、構造仕様）を集約する
- 本体 TeX データと運用資産を分離し、リポジトリを保守しやすく保つ

## 先に見るべき資料

- 構成詳細: [README_STRUCTURE.md](README_STRUCTURE.md)
- 運用ルール: [docs/RULES.md](docs/RULES.md)
- ワークフロー: [docs/WORKFLOW.md](docs/WORKFLOW.md)
- 高校入試運用: [docs/high_school_exam.md](docs/high_school_exam.md)
- テンプレート方針: [TEMPLATE-STRATEGY.md](TEMPLATE-STRATEGY.md)
- 進捗ログ: [PROGRESS-2026-03-02.md](PROGRESS-2026-03-02.md)

## ディレクトリ概要

- `compile/` : コンパイル用スクリプト置き場（必要に応じて追加）
- `migration/` : 移行・抽出・一時成果物の保管
- `docs/` : 運用ドキュメント群

## 運用ルール（必須）

- 本体 TeX（問題・解答）は `high_school_exam/` / `university_exam/` に置く
- 自動生成の補助ファイルは `scripts/` に置く
- ルート README は入口専用、詳細仕様は `scripts/` 側で管理する

## Git 運用

**基本方針**
- PDF / TeX / 図版は成果物として管理対象
- 中間ファイル（`.aux`, `.log`, `.out`, `.toc`, `.synctex.gz` など）は除外

**理由**
- 成果物は環境差分なく参照可能にする
- 中間ファイルは環境依存かつ容量増の要因になる

## TeX コンパイル規約（共通）

- エンジン: `lualatex`
- 日本語組版: `jlreq`
- 図版: `standalone` + TikZ

```tex
\documentclass[lualatex,ja=standard]{jlreq}
\usepackage{tikz}

% 図版単体
\documentclass[lualatex]{standalone}
\usepackage{tikz}
```

注: この規約は `science-db` と共通です。
