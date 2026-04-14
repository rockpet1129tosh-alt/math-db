# scripts ハブ（運用入口）

このフォルダは `math-db` の運用ハブです。
ルール確認、構成確認、作業ログ確認はここから開始します。

## まずここを見る

1. 全体構成: [README_STRUCTURE.md](README_STRUCTURE.md)
2. ドキュメント索引: [docs/README.md](docs/README.md)
3. 共通運用規則: [docs/RULES.md](docs/RULES.md)
4. 高校入試運用: [docs/high_school_exam.md](docs/high_school_exam.md)
5. 大学入試運用: [docs/university_exam.md](docs/university_exam.md)

## フォルダの役割

- `docs/`: 正式な運用ドキュメント
- `compile/`: コンパイル補助スクリプト
- `migration/`: 変換・移行関連スクリプト
- `*.md`: 作業ログ、戦略メモ、補助記録

## 現在の主要方針（要約）

### 高校入試

- `high_school_exam/tokyo/` を正本として管理
- 年度と `1st/2nd` を維持
- 図版は大問単位で管理

### 大学入試

- `university_exam/tokyo-u/` を起点に整備
- `2025/<set-id>/` を正本として管理（`sets/` 中間階層なし）
- `_original` は試験セット直下
- 命名規則は `uem_mat_tok_YYYY_term_track_...`

## 追加・更新時のチェック

- docs を更新する場合は、必ず [docs/README.md](docs/README.md) のリンク整合を確認
- 新しい運用規則を追加した場合は、[README_STRUCTURE.md](README_STRUCTURE.md) に反映
- 一時レポートを作成した場合は恒久化の要否を判断し、不要なら削除
