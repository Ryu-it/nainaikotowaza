# ないないことわざ
サービスURL : https://nainai-kotowaza.com

![](app/assets/Top-README.png)
 
 # サービス概要
 「ないないことわざ」はこの世に存在しないオリジナルのことわざを誰かと一緒に作ったり、1人で作ることができるサービスになります。<br>
 一緒にことわざを作ることで人との距離を近づけるサービスとなっております。<br>
 自分のアイデアをAIに渡すことで、オリジナルのことわざをサクッと作ることもできます。

 # サービス開発の背景
RUNTEQを通して、様々な人に出会いました。彼らとより仲良くなりたいと思い、オンライン上で人と仲良くなれるサービスの開発を始めました。<br>
人との親密度を上げるには、2つの要素があると思いました。

 - 共同作業
 - 笑い

私は言葉遊びが好きで、AIとオリジナルの言葉を作って遊んだりしていました。<br>
そこで、この2つの要素を達成でき、かつ自分らしさを取り入れたアプリを考えたときに「ことわざを一緒に作るアプリ」を思いつきました。<br>
ことわざは老若男女誰もが知っていて、幅の広がりもあるのでこのアプリに最適だと思い「ないないことわざ」の開発を始めました。<br>
人との親密度を上げるアプリが「ないないことわざ」になっております。

# 機能紹介

<h3 align="center">📨 招待機能（送信側）</h3>

<p align="center">
  <img src="https://i.gyazo.com/bdfa67724df88efe94ed3957ed87e9da.gif" width="500" />
</p>

<p align="center">
  フォローしているユーザーの中から招待したい相手を選択して、<br>
  そのまま部屋を作成できます。<br>
  招待を送ると相手に通知が届き、承認されると共同制作が始まります。
</p>

---

<br>

<h3 align="center">📩 招待機能（受信側）</h3>
<p align="center">
  <img src="https://i.gyazo.com/a80ed9fd3d624abee6e0e5ea87f8430a.gif" width="500" />
</p>

<p align="center">
  メッセージから招待リンクを踏みます。<br>
  部屋に入ることで、一緒にことわざを作成することができます。
</p>

---

<br>

<h3 align="center">⌨️ リアルタイムで文字が反映される共同編集機能</h3>
<p align="center">
  <img src="https://i.gyazo.com/0e8abca7361d4de31824f3a3b6ce2814.gif" width="500" />
</p>

<p align="center">
  同じ部屋に入ることで、チャンネルのストリームを購読します。<br>
  WebSocketの双方向通信技術を使って、文字をリアルタイムで表示します。<br>
  空間だけでなく、時間も共有できるようになります。
</p>

---

<br>

<h3 align="center">🤖 AIと一緒にことわざを作成機能</h3>
<p align="center">
  <img src="https://i.gyazo.com/e022af1f835c06958f68a5881c5d5ebf.gif" width="500" />
</p>

<p align="center">
  AIと一緒にことわざを作ることができます。<br>
  SSE接続を使うことで、文字をリアルタイムで表示します。<br>
</p>

 ## 技術スタック
 
 | カテゴリ       | 技術                             |
 |---------------|--------------------------------------|
 | フロントエンド | Rails 7.2.2.2 / Tailwind CSS / Hotwire |
 | バックエンド   | Rails 7.2.2.2（Ruby 3.2.3）          |
 | データベース   | PostgreSQL 17.5 （Neon）                        |
 | 開発環境      | Docker                              |
 | インフラ      | Render（App） / Neon（DB） / Amazon S3（Storage）                 |
 | 認証         | Devise / Google認証 / LINE認証                |
 | VCS          | GitHub                              |
 | CI/CD        | GitHub Actions                      |

## ER図
![ER Diagram](app/assets/ER-dbdiagram.png)

## 画面遷移図
[Figmaで見る](https://www.figma.com/design/Whvv7ajTtLstt9xWFO6quF/%E7%84%A1%E9%A1%8C?node-id=0-1&t=UN6kyosDwpZGuYSt-1)
