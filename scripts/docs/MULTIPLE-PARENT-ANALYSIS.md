# 複数親対応時の \subfix{} の必要性を検証

**作成日**: 2026年3月4日

---

## 質問: 複数親が増えたら、\subfix{} は本当に「必要」になる？

### シナリオA: math-db で複数親が追加される場合

**現在** (単一親):
```
hsm_tok_q.tex（唯一の親）
  ↓
2025/1st/02/hsm_tok_2025_1st_02_q.tex
  └─ \includegraphics{fig_hsm_tok_2025_1st_02/...pdf}
```

**将来** (複数親が追加される可能性):
```
①hsm_tok_q.tex（科目別マスター親）
②prnt_2025_spring.tex（春試験プリント親）  
③prnt_exam_all.tex（全試験統合親）
  │
  └─ 同じ子ファイル: 2025/1st/02/hsm_tok_2025_1st_02_q.tex
      └─ \includegraphics{fig_hsm_tok_2025_1st_02/...pdf}
```

---

## 🔍 複数親でのパス解釈の実態

### LaTeX の相対パス解釈メカニズム

**重要**: LaTeX の `\includegraphics{}` は、**実行時の「作業ディレクトリ」（caWD）** を基準にパスを解釈します。

```
例1) 親①から実行: lualatex hsm_tok_q.tex
     作業ディレクトリ: high_school_exam/tokyo/
     相対パス解釈開始地点: high_school_exam/tokyo/
     子内の図: fig_hsm_tok_2025_1st_02/... 
       → 探索位置: high_school_exam/tokyo/fig_hsm_tok_2025_1st_02/... ❌ (存在しない)

例2) 子を直接実行: cd high_school_exam/tokyo/2025/1st/02 && lualatex hsm_tok_2025_1st_02_q.tex
     作業ディレクトリ: high_school_exam/tokyo/2025/1st/02/
     相対パス解釈開始地点: high_school_exam/tokyo/2025/1st/02/
     子内の図: fig_hsm_tok_2025_1st_02/...
       → 探索位置: high_school_exam/tokyo/2025/1st/02/fig_hsm_tok_2025_1st_02/... ✅ (存在)
```

### 問題: 親②,③ から読み込まれた場合

親②: `prnt_2025_spring.tex` （位置: prints/）
```tex
\documentclass[../high_school_exam/tokyo/hsm_tok_q.tex]{subfiles}
\subfile{../high_school_exam/tokyo/2025/1st/02/hsm_tok_2025_1st_02_q.tex}
```

このとき、子内の `fig_hsm_tok_2025_1st_02/...` はどこから探索される？

**テスト的な予想**:
- 親②を実行: `lualatex prnt_2025_spring.tex` （作業ディレクトリ: prints/）
- 子の図パス: `fig_hsm_tok_2025_1st_02/...`
- LaTeX が探索する位置: `prints/fig_hsm_tok_2025_1st_02/...` ❌ （存在しない）

---

## ✨ \subfix{} がここで役割を果たす

### \subfix{} の本質と制限

**定義** (subfiles パッケージ内):
```tex
% デフォルト（子が直接実行される）
\providecommand{\subfix}[1]{#1}

% 親から読み込まれるとき（subfiles が再定義）
% \subfix{#1} → 子ファイルの位置に基づいて相対パスを自動調整
```

### 具体動作

親① (`hsm_tok_q.tex`) から子を読み込む：
```tex
\subfile{2025/1st/02/hsm_tok_2025_1st_02_q.tex}
```

子ファイル内 (`htmtok_2025_1st_02_q.tex`):
```tex
\includegraphics{\subfix{fig_hsm_tok_2025_1st_02/fig.pdf}}
```

**subfiles の処理**:
1. 親から子への相対パス: `2025/1st/02/hsm_tok_2025_1st_02_q.tex`
2. 子の位置: `high_school_exam/tokyo/2025/1st/02/`
3. `\subfix{...}` が動作: パスを「子からの相対」に自動変換
4. 図の最終探索位置: `high_school_exam/tokyo/2025/1st/02/fig_hsm_tok_2025_1st_02/...` ✅

---

## ⚠️ \subfix{} には限界がある

### 複雑なケース: 3階層以上のネスト

```
prnt_2025_spring.tex
  └─ \subfile{../high_school_exam/tokyo/2025/1st/02/hsm_tok_2025_1st_02_q.tex}
      └─子内: \subfix{fig_hsm_tok_2025_1st_02/...}
```

**疑問**: \subfix{} は本当に正確に動作する？

実装上、subfiles は以下を計算する：
1. **親から子への相対パス**: `../high_school_exam/tokyo/2025/1st/02/hsm_tok_2025_1st_02_q.tex`
2. **親の位置**: `prints/`
3. **子の絶対位置**: `prints/../high_school_exam/tokyo/2025/1st/02/` = `high_school_exam/tokyo/2025/1st/02/`
4. **\subfix{fig_...}** → この位置からの相対パスに変換

**結論**: \subfix{} は（理論上）正確に動作するはずです。

---

## 🎯 複数親対応の方法の選択肢

複数親が必要になったとき、以下の選択肢がある：

### 選択肢1: \subfix{} を再導入（science-db方式）

**メリット**:
- ✅ 自動パス調整
- ✅ 子ファイルは変更不要
- ✅ 親を追加するだけで対応可能

**デメリット**:
- ❌ subfiles パッケージの挙動を完全に理解する必要あり
- ❌ LaTeX引数の展開タイミングに依存

[実装例]
```tex
% 子ファイル
\includegraphics{\subfix{fig_hsm_tok_2025_1st_02/fig.pdf}}

% 複数親で自動的に機能
```

### 選択肢2: \graphicspath{} を使用（古典的方式）

**メリット**:
- ✅ LaTeX 標準機能
- ✅ 確実に動作

**デメリット**:
- ❌ 全パターンを手動列挙する必要がある
- ❌ パターン増加時に保守負荷増

[実装例]
```tex
% 子ファイル内（親ごとのパスパターンを全て列挙）
\graphicspath{
    {fig_hsm_tok_2025_1st_02/}        % 子直接コンパイル
    {2025/1st/02/fig_hsm_tok_2025_1st_02/}   % hsm_tok_q.tex から
    {high_school_exam/tokyo/2025/1st/02/fig_hsm_tok_2025_1st_02/}  % prnt_2025_spring.tex から
}
```

### 選択肢3: プリアンブル内でパス設定マクロを使用

**メリット**:
- ✅ 親ごとに設定を分離
- ✅ 柔軟な制御

**デメリット**:
- ❌ 子ファイルが親に依存する可能性

[実装例]
```tex
% 中央プリアンブル（hsm_tok_q.tex）
\newcommand{\figpath}{../../}

% 子ファイル内
\includegraphics{\figpath fig_hsm_tok_2025_1st_02/fig.pdf}

% 別の親（prnt_2025_spring.tex）では
\renewcommand{\figpath}{../high_school_exam/tokyo/}
```

### 選択肢4: 親ファイル側でパス修正（ラッパー方式）

**メリット**:
- ✅ 子を変更しない
- ✅ 親で完全制御

**デメリット**:
- ❌ 親側が複雑になる

[実装例]
```tex
% 親ファイル（prnt_2025_spring.tex）
\let\originalsubfile\subfile
\renewcommand{\subfile}[1]{%
    % パス修正ロジックをここに記述
    \originalsubfile{#1}
}
```

---

## 📊 方式の選択基準

| 方式 | 実装難度 | 保守性 | 拡張性 | 推奨用途 |
|------|--------|-------|-------|---------|
| **\subfix{}** | 中 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | 複数親が増える可能性がある場合 |
| **\graphicspath{}** | 低 | ⭐⭐ | ⭐ | 親の数が固定で少ない場合 |
| **マクロ設定** | 中 | ⭐⭐⭐ | ⭐⭐⭐ | 親ごとに異なる設定が必要な場合 |
| **ラッパー方式** | 高 | ⭐⭐⭐ | ⭐⭐⭐⭐ | 複数の子ファイルセットを管理する場合 |

---

## 🚀 math-db の将来戦略

### 現在（単一親）
- ✅ \subfix{} なしで正常動作
- ✅ シンプルで保守しやすい

### 将来（複数親の可能性）
タイミング:
- 「春試験プリント」「全年度統合」など外部親が必要になった時

対応手段 (優先順):
1. **最も推奨**: \subfix{} を再導入する
   - 子ファイル内に `\includegraphics{\subfix{パス}}` で記述
   - 親を追加するだけで対応可能
   
2. **代替案**: \graphicspath{} を使用
   - 親の数が確定している場合

3. **柔軟性重視**: マクロベースの設定
   - 親ごとに異なるスタイル設定が必要な場合

---

## 🎯 結論

### ユーザーの洞察への回答

> Q: 「これから、いろんな親が増えていくと、\subfixがあったほうがよくなるってことだよね？」

**A: はい、正確です。以下のタイミングで検討が必要になります：**

1. **現在**: \subfix{} なしで正常動作。削除は正しい判断。

2. **複数親が追加されるとき**:
   - パス調整メカニズムが必要になる
   - その時点で \subfix{} 再導入 or 代替案を選択

3. **\subfix{} のメリット**:
   - 自動パス調整により、新しい親追加時に子ファイルを変更しない
   - 拡張性が最高

4. **ただし確認が必要な事項**:
   - subfiles パッケージの正確な \subfix{} 実装
   - LaTeX のパス解釈メカニズム
   - 実装前に「複数親 + \subfix{}」をテストすることを強く推奨

---

## 📋 推奨事項

### 今すぐすべき事
- ✅ 現状維持（\subfix{} なし）

### 複数親追加時にすべき事  
- 📋 複数親パターンでのテスト実施
- 📋 \subfix{} の動作確認
- 📋 パフォーマンス測定（必要に応じて）
- 📋 導入判断

### 参考資料として保存すべき事
- ✅ 本ドキュメント（複数親対応時の参照材料）
- ✅ STRUCTURE-COMPARISON-ANALYSIS.md（既存）

---

**作成者**: GitHub Copilot  
**参考資料**: SUBFILES-GUIDE.md, science-db実装  
**最終更新**: 2026年3月4日
