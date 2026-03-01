# math-db Scripts

このフォルダには、Copilot が作成した一括処理スクリプトと、マイグレーション用ツールが含まれます。

## 運用ルール

- 今後、一括処理で自動生成される作業用ファイルは原則としてすべて `scripts/` 配下に保存します。
- 問題・解答の本体 TeX は `university_exam/` / `high_school_exam/` に置き、`scripts/` には置きません。

## フォルダ構造

```
scripts/
├── compile/              # LaTeX コンパイルスクリプト
│   ├── compile_all.ps1             # 全ファイル一括コンパイル
│   ├── compile_all_standalone.ps1  # スタンドアロン用
│   ├── compile_all_tikz.ps1        # TikZ 図形のみ
│   └── ...
│
└── migration/            # ファイル移行・変換ツール
    └── ...
```

## 詳細説明

詳細は `../README_STRUCTURE.md` を参照してください。
