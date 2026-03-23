# flutter_rakuten_point

楽天ポイントの残高・内訳を日別に記録・管理するための Flutter アプリです。

---

## 概要

楽天ポイントの毎日の残高を手動で入力し、ポイントの増減をカテゴリ・アクション別に詳細管理できます。  
月別の集計表示や CSV によるデータのエクスポート／インポートにも対応しています。

---

## 主な機能

- **日別ポイント残高の記録**  
  日付ごとに楽天ポイントの残高を登録し、前日との差分を自動表示

- **明細入力**  
  カテゴリ（例：SPU、楽天カード、楽天市場）とアクション（任意）を指定してポイント内訳を記録

- **カテゴリ・アクション管理**  
  ドロワーメニューからカテゴリ名・アクション名を追加・編集・削除

- **月別サマリー表示**  
  年月ヘッダーをタップするとその月のカテゴリ別集計を確認可能

- **年月ナビゲーション**  
  画面上部のスクロールリストで年月を選択し、該当月へスムーズにジャンプ

- **CSV エクスポート／インポート**  
  記録データを CSV ファイルとして書き出し・読み込みが可能

---

## 使用技術

| カテゴリ | ライブラリ |
|---|---|
| フレームワーク | Flutter / Dart |
| 状態管理 | [Riverpod](https://riverpod.dev/) (hooks_riverpod, riverpod_annotation) |
| ローカル DB | [Isar](https://isar.dev/) |
| UI | Material Design (Dark theme), Google Fonts (Kiwi Maru), [fl_chart](https://pub.dev/packages/fl_chart) |
| CSV | [csv](https://pub.dev/packages/csv) |
| ファイル操作 | file_picker, external_path, share_plus |
| コード生成 | build_runner, freezed, json_serializable, riverpod_generator |
| その他 | drag_and_drop_lists, flutter_colorpicker, scroll_to_index, bubble |

---

## データモデル

```
Record
  - date   : String  // 日付 (yyyyMMdd)
  - price  : int     // ポイント残高

RecordDetail
  - date     : String  // 日付
  - category : String  // カテゴリ名
  - action   : String  // アクション名
  - price    : int     // ポイント数

CategoryName
  - name : String  // カテゴリ名

ActionName
  - name : String  // アクション名
```

---

## プロジェクト構成

```
lib/
├── collections/       # Isar データモデル定義
├── controllers/       # Riverpod コントローラ・Mixin
├── extensions/        # Dart 拡張メソッド
├── repository/        # データアクセス層
├── screens/
│   ├── components/    # ダイアログ・アラートウィジェット
│   │   └── csv_data/  # CSV エクスポート／インポート UI
│   └── parts/         # 共通 UI パーツ
└── utilities/         # ユーティリティ
```

---

## セットアップ

### 前提条件

- Flutter SDK `^3.8.1`
- Dart SDK `^3.8.1`

### インストール

```bash
git clone https://github.com/toyotarou/flutter_rakuten_point.git
cd flutter_rakuten_point
flutter pub get
```

### コード生成

Isar スキーマや Riverpod プロバイダのコードを生成します。

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 実行

```bash
flutter run
```

---

## 対応プラットフォーム

- Android
- iOS
- macOS
- Windows
- Linux

---

## ライセンス

このプロジェクトにはライセンスファイルが設定されていません。
