
# 差分ダウンロードのテストケース #

## 1. 最初の実装 ##
ローカル環境で最初の実装を行う。

### 1-0. AppSeedによる初期登録 ###
* tag: tests/basic\_senario00
* commit: 697c05d

fontana\_sampleをSCMとして登録し、そのデータを取り込むことで初期登録とする。



### 1-1. SCMのdownloadable\_masterの構造変更 ###
* tag: tests/basic\_senario01
* commit: 3b57858

* アイテムマスタに対して"種別(type)"というカラムを追加。
* データにも初期値を追加


### 1-2. SCMのdownloadable\_masterのドキュメント追加 ###
* tag: tests/basic\_senario02
* commit: 1a2d28b

* アイテムマスタに3件のデータを追加。
  - 20013: 聖水
  - 20014: 毒消し草
  - 20015: 毒消し草X (削除予定のデータ)


### 1-3. SCMのdownloadable\_masterのドキュメント変更 ###
* tag: tests/basic\_senario03
* commit: 304267b

* アイテムマスタの2件のデータを変更。
  - 20002:ポーションA -> 20002:ポーションS
  - 20003:ポーションXXX -> 20003:ポーションXX


### 1-4. SCMのdownloadable\_masterのドキュメント削除 ###
* tag: tests/basic\_senario04
* commit: e877be4

* アイテムマスタから1件のデータを削除
  - 20015: 毒消し草 (削除予定のデータ)


### 1-5. SCMのserverside\_masterの構造変更 ###
* tag: tests/basic\_senario05
* commit: adaa4c0

* ステータスマスタを05_status.xlsxとして新規で追加
  - フィールド
    + status_cd: ステータスコード
    + name: 名前
  - データ
    + 1001: 毒
    + 1002: 暗闇
    + 1003: 無敵


### 1-6. SCMのserverside\_masterのドキュメント追加 ###
* tag: tests/basic\_senario06
* commit: 6042a18

* ステータスマスタに3件のデータを追加。
  - 1004: 攻撃力低下
  - 1005: 防御力低下
  - 1006: 石化


### 1-7. SCMのserverside\_masterのドキュメント変更 ###
* tag: tests/basic\_senario07
* commit: 034ec19

* ステータスマスタの2件のデータを変更。
  - 1004:攻撃力低下 -> 1004:攻撃力ダウン
  - 1005:防御力低下 -> 1004:防御力ダウン


### 1-8. SCMのserverside\_masterのドキュメント削除 ###
* tag: tests/basic\_senario08
* commit: 79d44be

* スタータスマスタから1件のデータを削除
  - 1006:石化
    - 石化しちゃったら何もできないので戦闘が進まなくなる…


### 1-9. SCMのdownloadable\_masterをserverside\_masterに変更 ###
* tag: tests/basic\_senario09
* commit: 7049694

この状態をテストするにはデータが足りないので、まずはダウンロード可能なマスタを作成する。
その後、そのマスタをダウンロード不可にする。

* downloadable_masterとして"05_status.xlsx"に"属性マスタ(Attribute)"を追加する。
  - フィールド
    + attribute_cd: 属性コード
    + name: 名前
  - データ
    + 1001: 火
    + 1002: 水
    + 1003: 土
    + 1004: 風

* ダウンロード可能かどうかを判定するための、カラムが必要だが、どこに指定する？


### 1-10. SCMのserverside\_masterをdownloadable\_masterに変更 ###
* tag: tests/basic\_senario10
* commit: 2228d65

* 05_status.xlsxに記載されているステータスマスタをダウンロード可能なマスタにする。
  * コレクション定義に「ダウンロード」というフィールドを追加して「可能」という値を埋め込む。


### 1-11. SCMのストアドスクリプトを変更 ###
* tag: tests/basic\_senario11
* commit: 917d4ef

ゲームデータのcontentでstatusという項目を扱うストアドスクリプトを実装する。
status\_ruby\_stored\_script.rbというファイルに対して以下のメソッドを実装する。

* StatusRubyStoredScript
  - apply_status
    + ゲームデータのcontentにstatusが無ければ作る
    + statusに引数で指定されたステータスを付与する
    + メッセージとして「You became a #{status} state」が返ってくる
  - recovery_status
    + 引数で指定されたステータスが付与されていたら、そのステータスを配列から削除する
    + メッセージとして「Recovery a #{status} state」が返ってくる
* 01_item.xlsx
  - アイテムマスタ
    + 20014:毒消し草を使用したときにStatusRubyStoredScript#recovery\_statusが実行できるようにする。

運営ツール上での確認
* ステータス付与処理の確認
  - 開発ツール > 同期APIから以下のスクリプトを実行する。
    ```
    {"inputs": [{"action":"execute", "name":"StatusRubyStoredScript", "key":"apply_status", "args":{"status_cd":"1001"}}]}
    ```
  - 指定したプレイヤーIDのゲームデータのコンテンツに"status:['1001']"が付与されているか確認。
* ステータス解除の確認
  - 任意のプレイヤーのゲームデータ(GameData)のアイテムに"item\_cd:20014"を任意の数分付与する。
  - 開発ツール > 同期APIから以下のスクリプトを実行する。
    ```
    {"inputs":[{"action":"execute", "name":"ItemRubyStoredScript", "key":"use_item", "args":{"item_cd":"20014"}}]}
    ```
  - ゲームデータから1001ステータスが消えていることを確認。

### 1-12. 設定を変更 ###
* tag: tests/basic_senario12
* commit: bb387aa

* app_garden.ymlの"player_id_gen.prefix.pid_mask"の値を変更。





## 2. パラメータ調整をしてもらう ##

### 2-1. SCMによる初回登録 ###
ローカルで編集したSCMをお客様開発環境に登録

### 2-2. SCMのdownloadable\_masterのドキュメント追加 ###
* tag: tests/basic_senario13
* commit: 3a7d9ce

* 装備マスタにデータを追加。
  - 10021: さびたナイフ
  - 10022: さびた剣
  - 10023: さびた鎧

  
### 2-3. SCMのdownloadable\_masterのドキュメント変更 ###
* tag: tests/basic_senario14
* commit: 3dcb285

* 装備マスタのデータを変更。
  - 10022: さびた剣 > 10022: さびたつるぎ
  - 10023: さびた鎧 > 10023: さびたよろい

### 2-4. SCMのdownloadable\_masterのドキュメント削除 ###
* tag: tests/basic_senario15
* commit: bfa16bd

* 装備マスタのデータを削除。
  - 10023: さびた鎧 > 10023: さびたよろい

### 2-5. SCMのserverside\_masterのドキュメント追加 ###
運営ツール上だけの変更になるため、差分ファイルもなく、ブランチも作成しない。

* 属性マスタに3件のデータを追加
  - 1005: 木
  - 1006: 雷
  - 1007: 金

### 2-6. SCMのserverside\_masterのドキュメント変更 ###
運営ツール上だけの変更になるため、差分ファイルもなく、ブランチも作成しない。

* 属性マスタの1件のデータを編集
  - 1002: 水 > 1002: 氷

### 2-7. SCMのserverside\_masterのドキュメント削除 ###
運営ツール上だけの変更になるため、差分ファイルもなく、ブランチも作成しない。

* 属性マスタの1件のデータを削除
  - 1007: 金





## 3. パラメータ調整中のバグ修正 ##

### 3-1. お客様開発環境 ###
#### 3-1-1. データの凍結(エクスポート) ####


### 3-2. ローカル環境 ###
#### 3-2-1. 凍結データのインポート (downloadable\_master) ####
#### 3-2-2. 凍結データのインポート (serverside\_master) ####
#### 3-2-3. SCMのdownloadable\_masterの構造変更 ####
#### 3-2-4. SCMのdownloadable\_masterを使用しているストアドスクリプトの変更 ####
#### 3-2-5. 運営ツールによるdownloadable\_masterのドキュメント更新 ####
#### 3-2-6. SCMのserverside\_masterの構造変更 ####
#### 3-2-7. SCMのserverside\_masterを使用しているストアドスクリプトの変更 ####
#### 3-2-8. 運営ツールによるserverside\_masterのドキュメント更新 ####
#### 3-2-9. データの凍結(エクスポート) ####



### 3-3. お客様開発環境 ###
#### 3-3-1. SCMによる変更の取り込み ####
ローカル環境で変更した内容をお客様開発環境に取り込む。
この過程で、app/seeds/dataにエクスポートデータが存在していたら、そのデータが取り込まれる。

発生する可能性のある変更
* マスタの構造変更
* ストアドスクリプトの変更
* データの更新
