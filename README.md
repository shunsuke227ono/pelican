アプリのURL: https://the-pelican.herokuapp.com

※ サーバー代の都合で、最新記事の取り込みのcronは止めているため、記事はアップデートされていません。

***

# Pelican

![-20150618 001](https://cloud.githubusercontent.com/assets/7357864/12077588/81e23e48-b230-11e5-9401-34e47ee28143.jpg)

## アジェンダ

 1. 使用したライブラリ・フレームワーク
 2. アプリデモと仕様紹介
 3. 関連記事を算出する仕組み
 4. 表示高速化の工夫

# 1. 使用したライブラリ・フレームワーク

## バックエンド

* Ruby on Rails 4.2.0
* PostgreSQL

## フロントエンド

* Sass
* Bootstrap

## 記事取得・推薦記事選定用
* MeCab
  * 形態素解析エンジン
* natto
  * RubyとMeCabをつなぐインタフェース
* nokogiri
  * スクレイピング用ライブラリ
* whenever
  * cron jobsをシンプルに書くためのライブラリ

# 2. アプリデモと仕様紹介

![-20150618 002](https://cloud.githubusercontent.com/assets/7357864/12077591/8aa9866c-b230-11e5-9532-7be1a661e20c.jpg)

![-20150618 003](https://cloud.githubusercontent.com/assets/7357864/12077592/8aac9bfe-b230-11e5-8334-b6f894c4c7c4.jpg)

# 3. 関連記事を算出する仕組み

![-20150618 006](https://cloud.githubusercontent.com/assets/7357864/12077593/a49ef62e-b230-11e5-9b40-46b52d6e8955.jpg)

## ニュースデータの取得

![-20150618 007](https://cloud.githubusercontent.com/assets/7357864/12077595/a4a6d16e-b230-11e5-8549-c89af5704e67.jpg)

![-20150618 008](https://cloud.githubusercontent.com/assets/7357864/12077596/a4a9f0b0-b230-11e5-8fcb-cf38b511f137.jpg)

* (参考)選定されたRSSのURL一覧はgithub上のソースコードはこちら
https://github.com/shunsuke227ono/pelican/blob/master/config/settings.yml
* (参考)リソース選定をしたgithub上のイシューはこちら
  * (スポーツ) https://github.com/shunsuke227ono/pelican/issues/36
  * (スポーツ以外のカテゴリ) https://github.com/shunsuke227ono/pelican/issues/95

![-20150618 009](https://cloud.githubusercontent.com/assets/7357864/12077594/a4a5efd8-b230-11e5-9f80-50a62e7f367b.jpg)

* バッチ処理のgithub上のソースコードはこちら
  * https://github.com/shunsuke227ono/pelican/blob/master/lib/tasks/rss.rake

![-20150618 010](https://cloud.githubusercontent.com/assets/7357864/12077597/a4aa2062-b230-11e5-8d43-dbbc4dbf7e06.jpg)

* cron設定のgithub上のソースコードはこちら
  * https://github.com/shunsuke227ono/pelican/blob/master/config/schedule.rb

## キーワード抽出

![-20150618 011](https://cloud.githubusercontent.com/assets/7357864/12077598/a4acb94e-b230-11e5-8d85-e08a2f4e776c.jpg)

![-20150618 012](https://cloud.githubusercontent.com/assets/7357864/12077599/a4bc5ed0-b230-11e5-8a61-d457bd990afa.jpg)

* 形態素解析のgithub上のソースコードはこちら
  * (バッチ処理) https://github.com/shunsuke227ono/pelican/blob/master/lib/tasks/similarity.rake
  * (モジュール) https://github.com/shunsuke227ono/pelican/blob/master/app/models/concerns/natto_mecab.rb

![-20150618 013](https://cloud.githubusercontent.com/assets/7357864/12077600/a4c6e80a-b230-11e5-8f47-9db718340f8f.jpg)

* tf-idf法計算メソッドを持ったクラスと、本文に対してtf-idf法を行っているバッチ処理を実装したソースコードはこちら
  * (クラス)  https://github.com/shunsuke227ono/pelican/blob/master/app/models/concerns/tf_idf_calculation.rb
  * (バッチ処理) https://github.com/shunsuke227ono/pelican/blob/master/lib/tasks/similarity.rake

## 文書ベクトルの類似度

![-20150618 014](https://cloud.githubusercontent.com/assets/7357864/12077601/a4c8279c-b230-11e5-85e5-5b3dad0e2457.jpg)

![-20150618 015](https://cloud.githubusercontent.com/assets/7357864/12077602/a4ca82b2-b230-11e5-9704-e86ad61d30cb.jpg)

* コサイン距離測定はtf-idfクラス内のインスタンスメソッドで行い、それをバッチ処理中で使用する。github上のソースコードはこちら。
  * (tf-idfクラス)  https://github.com/shunsuke227ono/pelican/blob/master/app/models/concerns/tf_idf_calculation.rb
  * (類似度計算バッチ処理) https://github.com/shunsuke227ono/pelican/blob/master/lib/tasks/similarity.rake

## 補足

![-20150618 016](https://cloud.githubusercontent.com/assets/7357864/12077603/a4cb5a84-b230-11e5-936b-e6e9612d768d.jpg)

# 4. 表示の高速化の工夫

![-20150618 018](https://cloud.githubusercontent.com/assets/7357864/12077605/b31d17d0-b230-11e5-99e1-3168d5d16061.jpg)

* ソースコードの該当箇所: https://github.com/shunsuke227ono/pelican/blob/master/app/controllers/feed_controller.rb#L8

![-20150618 019](https://cloud.githubusercontent.com/assets/7357864/12077608/b3226f3c-b230-11e5-8453-bf00af85fc70.jpg)

![-20150618 020](https://cloud.githubusercontent.com/assets/7357864/12077610/b3244bd6-b230-11e5-9411-2274e02f516f.jpg)

* ソースコードの該当箇所: https://github.com/shunsuke227ono/pelican/blob/master/config/schedule.rb

![-20150618 021](https://cloud.githubusercontent.com/assets/7357864/12077606/b3219efe-b230-11e5-9071-5d956220a299.jpg)

![-20150618 022](https://cloud.githubusercontent.com/assets/7357864/12077609/b32331d8-b230-11e5-940e-f5fffc5353af.jpg)

![-20150618 023](https://cloud.githubusercontent.com/assets/7357864/12077607/b321fbb0-b230-11e5-87fe-5ef3df004156.jpg)

# UI/UX に関する補足

![-20150618 024](https://cloud.githubusercontent.com/assets/7357864/12077611/b33de8b6-b230-11e5-818f-7f7edc64453b.jpg)

![-20150618 025](https://cloud.githubusercontent.com/assets/7357864/12077612/b3427250-b230-11e5-8b5b-f7abef7a76f3.jpg)
