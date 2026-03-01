# math-db Scripts

このフォルダには、Copilot が作成した一括処理スクリプトと、マイグレーション用ツールが含まれます。

## 運用ルール

- 今後、一括処理で自動生成される作業用ファイルは原則としてすべて `scripts/` 配下に保存します。
- 問題・解答の本体 TeX は `university_exam/` / `high_school_exam/` に置き、`scripts/` には置きません。

## Git運用ルール

**プッシュ対象**
- ✅ **PDFファイル** - コンパイル済みの成果物として必ず含める
- ✅ **TeXソースファイル** (.tex) - 全て含める
- ✅ **画像・図版** - 全て含める

**プッシュしないファイル（.gitignore で除外）**
- ❌ **中間ファイル** - `.aux`, `.log`, `.out`, `.toc`, `.synctex.gz` など
- ❌ **一時ファイル** - `.bak`, `.sav`, `*~` など
- ❌ **OS生成ファイル** - `.DS_Store`, `Thumbs.db` など

**理由:**
- PDF は最終成果物なので、コンパイル環境がなくても閲覧可能にする
- 中間ファイルは環境依存で容量を圧迫するため除外

## TeXコンパイル規約（共通ルール）

**engine / ドキュメントクラス**
- **エンジン**: `lualatex` を使用（日本語対応、フォント管理の効率化）
- **ドキュメントクラス**: `jlreq` を使用（日本語組版標準）
- **図形スタイル**: `standalone` を使用（TikZ図などの独立コンパイル用）

**例:**
```tex
\documentclass[lualatex,ja=standard]{jlreq}
\usepackage{tikz}  % 図形を使う場合

% または図形の独立コンパイル用
\documentclass[lualatex]{standalone}
\usepackage{tikz}
```

**注**: このルールは `physics-db` と共通です。

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
