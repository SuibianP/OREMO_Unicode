#
# OREMOメイン窓のトップメニュー
#
set t(option,setLanguage)   "言語設定"

set t(file)                 "ファイル"
set t(file,choosesaveDir)   "保存フォルダの変更"
set t(file,readRecList)     "音名リストの読み込み"
set t(file,saveRecList)     "音名リストの保存"
set t(file,readTypeList)    "発声タイプリストの読み込み"
set t(file,readCommentList) "コメントファイルの読み込み"
set t(file,makeRecList)     "保存フォルダのwavファイルから発声リストを作成"
set t(file,makeRecList,msg) "音名リスト、発声タイプリストを更新しました"
set t(file,makeRecListFromUst)     "ustファイルから発声リストを作成"
set t(file,makeRecListFromUst,msg) "音名リスト、発声タイプリストを更新しました"
set t(file,saveSettings)    "現在の設定を初期化ファイルに保存"
set t(file,Exit)            "終了"

set t(show)                 "表示"
set t(show,showWave)        "波形を表示"
set t(show,showSpec)        "スペクトルを表示"
set t(show,showpow)         "パワーを表示"
set t(show,showf0)          "F0を表示"
set t(show,pitchGuide)      "音叉窓を表示"
set t(show,tempoGuide)      "メトロノームを表示"

set t(option)               "オプション"
set t(option,removeDC)      "録音後にDC成分を除去"
set t(option,bgmGuide)      "収録方法の設定"
set t(option,ioSettings)    "オーディオI/O設定"
set t(option,settings)      "詳細設定"
set t(option,setBind)       "ショートカットキーの設定"
set t(option,setFontSize)   "フォントサイズの設定"

set t(oto)                  "oto.ini生成"
set t(oto,auto)             "収録音の種類"
set t(oto,auto,tandoku)     "単独音"
set t(oto,auto,renzoku)     "連続音"

set t(help)                 "ヘルプ"
set t(help,onlineHelp)      "オンラインマニュアル"
set t(help,Version)         "バージョン"
set t(help,official1)       "公式ページを開く"
set t(help,official2)       "公式ページ(配布場所)を開く"

#
# OREMOメイン窓のその他のラベル
#
set t(.saveDir.midashi)     "保存フォルダ："
set t(.recComment.midashi)  "コメント検索"
