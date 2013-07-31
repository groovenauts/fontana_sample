# configサーバ設定ディレクトリ

タイトルアプリのリリースとサーバ側のリリースを独立して扱えるようにします。
基本的にこのディレクトリは app_release ブランチでのみ変更するようにお願いします。
なぜなら、タイトルアプリがサーバ側の変更なしにリリースされる場合、developやmasterというブランチにクライアントの変更を反映させるべきではないからです。

このディレクトリ自身が、configサーバのドキュメントルートとしてデプロイされます。
ですので、実際に運用する際には、このファイル自身は削除するようにお願いします。



## /api_server ディレクトリ

`/app_server/<device_type>/<title_app_version>.json` という形式のファイルを格納します。

このファイルには以下の様なJSON形式で、接続先のAPIサーバのURLを記述します。

```
{
    "http_url_base": "http://<接続先ホスト名 or IPアドレス>:<ポート><アプリケーションのパス>",
    "https_url_base":  "https://<接続先ホスト名 or IPアドレス>:<ポート><アプリケーションのパス>",
}
```

### 例1

```
{
    "http_url_base": "http://api.game_title1.groovenauts.jp",
    "https_url_base": "https://api.game_title1.groovenauts.jp",
}
```

### develop.json

また、ストアドスクリプトの開発時には `/api_server/<device_type>/develop.json` が使用されます。

```
{
    "http_url_base": "http://localhost:3000",
    "https_url_base":  "https://localhost:3001",
}
```

このファイルは実際のリリース時には削除してください。




## /maintenanceファイル

通信ライブラリは、APIサーバが503を返す場合に、メンテナンスの情報を得るために、configサーバの /maintenance を取得します。

このファイルにはレスポンスのメッセージが平文で記述されていることを前提とします。

例

```
XXXのため、メンテナンス中です。（8/1 AM2:00 〜 8/1 AM8:00）
```
