# math-db

高校入試・大学入試の数学問題を TeX で体系管理するリポジトリです。  
GitHub 上で迷わないよう、**入口はこの README に一本化**し、詳細仕様は `scripts/` 配下に集約しています。

## まず最初に読む

1. リポジトリ概要（このページ）
2. 運用ハブ: [scripts/README.md](scripts/README.md)
3. 構造詳細: [scripts/README_STRUCTURE.md](scripts/README_STRUCTURE.md)

## リポジトリの目的

- 東京都立入試などの過去問を、年度横断で編集・再利用できる形で管理する
- 問題（`_q.tex`）と解答（`_a.tex`）を分離し、テンプレート化して横展開を高速化する
- 図版（TikZ/standalone）と本文を分離し、差分管理・再生成を容易にする

## 主要ディレクトリ

- `high_school_exam/` : 高校入試（東京都立など）の問題・解答データ
- `university_exam/` : 大学入試向け数学データ
- `figures/` : 共通ロゴ・図版アセット
- `scripts/` : 一括処理、移行補助、運用ドキュメント

## クイックリンク

- 運用ガイド: [scripts/README.md](scripts/README.md)
- 構成ガイド: [scripts/README_STRUCTURE.md](scripts/README_STRUCTURE.md)
- ルール: [scripts/docs/RULES.md](scripts/docs/RULES.md)
- ワークフロー: [scripts/docs/WORKFLOW.md](scripts/docs/WORKFLOW.md)
- 高校入試ドキュメント: [scripts/docs/high_school_exam.md](scripts/docs/high_school_exam.md)
- テンプレート戦略: [scripts/TEMPLATE-STRATEGY.md](scripts/TEMPLATE-STRATEGY.md)
- 進捗ログ: [scripts/PROGRESS-2026-03-02.md](scripts/PROGRESS-2026-03-02.md)

## 現在の進捗（要約）

- `high_school_exam/tokyo` を中心にテンプレート化を進行
- 大問1〜3はテンプレート作成・全年度横展開まで完了
- 大問4〜5は継続整備中

## 運用ポリシー（重要）

- 本体 TeX（問題・解答）は `high_school_exam/` / `university_exam/` に置く
- 自動生成の補助ファイル（抽出結果・移行メモ・作業ログ）は `scripts/` に置く
- ルートには「入口情報」を置き、詳細仕様は `scripts/` に集約する

---

詳細作業に入る場合は [scripts/README.md](scripts/README.md) から開始してください。
