#--------------------------------
# ※特殊な設定
# 日本語フォントを設定する(ここで設定したフォントを使って以降の文字列を表示させる
#
set t(fontName) "ＭＳ ゴシック"


#--------------------------------
# メッセージ
#
set t(setLanguage,opentitle)  "言語ファイルを選択"

# ダイアログによく出るメッセージ
set t(.confm)        "確認" 
set t(.confm.r)      "読み込む" 
set t(.confm.nr)     "読み込まない"
set t(.confm.fioErr) "ファイルI/Oエラー"
set t(.confm.yes)    "はい"
set t(.confm.no)     "いいえ"
set t(.confm.ok)     "OK"
set t(.confm.apply)  "適用"
set t(.confm.run)    "実行"
set t(.confm.c)      "キャンセル"
set t(.confm.errTitle) "エラー"
set t(.confm.warnTitle) "警告"
set t(.confm.delParam)  "現在の原音パラメータは消去されます。よろしいですか？"

# 保存フォルダにあるwavファイルを読み、リストに記憶する
set t(makeRecListFromDir,q)  "原音パラメータファイルを読み込みますか？"
set t(makeRecListFromDir,a)  "パラメータを自動的に生成する"

# ustファイルを読み、リストに記憶する
set t(makeRecListFromUst,title1)    "ustファイルを開く"
set t(makeRecListFromUst,errMsg)    "ustファイルを読み込めませんでした"
set t(makeRecListFromUst,doneMsg)   "ustファイルを読み込みました"

# 起動時にパラメータ自動推定を行う際のウィザード
set t(genParamWizard,title)  "音声データの種類"
set t(genParamWizard,q)      "処理対象の音声データの種類を選んで下さい。"
set t(genParamWizard,a1)     "単独発声データ"
set t(genParamWizard,a2)     "連続発声データ"

# reclist.txtを保存する
set t(saveRecList,title)     "音名リスト保存"
set t(saveRecList,errMsg)    "\$v(recListFile)に書き込めませんでした"
set t(saveRecList,errMsg2)   "音名を書き込めませんでした"
set t(saveRecList,doneMsg)   "音名リストを\$v(recListFile)に保存しました"

# コメントを保存する
set t(saveCommentList,errMsg)] "コメントを保存できませんでした"

# 音名リストファイルを読み、リストに記憶する
set t(readRecList,title1)    "音名リストを開く"
set t(readRecList,errMsg)    "収録する音名リストファイル(\$v(recListFile))を読み込めませんでした"
set t(readRecList,errMsg2)   "収録音名を読み込めませんでした"
set t(readRecList,doneMsg)   "\$v(recListFile)を読み込みました"
set t(readRecList,overwrite) "音名リストフォルダにコメントファイルがあります。現在のコメントを消して読み込みますか？"

# コメントファイルを読む
set t(readCommentList,errMsg)   "コメントデータを読み込めませんでした"
set t(readCommentList,doneMsg)  "\"\$commNum 個のコメントを読み込みました\""
set t(readCommentList,doneMsg2) "\"\$commNum 個のコメント(うち \$ignoreNum 個は重複)を読み込みました\""

# 発声タイプのリストファイルを読み、リストに記憶する
set t(readTypeList,title)    "発声タイプリストを開く"
set t(readTypeList,errMsg)   "収録する発声タイプリストファイル(\$v(typeListFile))を読み込めませんでした"
set t(readTypeList,errMsg2)  "収録する発声タイプリストを読み込めませんでした"
set t(readTypeList,doneMsg)  "\$v(typeListFile)を読み込みました"

# 保存ディレクトリを指定する
set t(choosesaveDir,title)   "保存フォルダの選択"
set t(choosesaveDir,doneMsg) "保存フォルダを変更しました"
set t(choosesaveDir,q)       "原音パラメータファイルも読み込みますか？"

# 未保存であれば波形をファイルに保存する
set t(saveWavFile,doneMsg)   "\$v(saveDir)/\$v(recLab)\$v(typeLab).wavを保存しました"

# F0計算中にキーボード、マウス入力を制限させるための窓
set t(waitWindow,title)      "F0計算中"

# 既存の右ブランク値の正負を書き換えて統一させる
#set t(changeE,title)         "既存の右ブランク値の修正"
#set t(changeE,q)             "既存の右ブランク値に負の値が設定されています。変更しますか？"
#set t(changeE,a)             "ファイル末尾からの時間に変換する(今の位置をずらさない)"
#set t(changeE,a2)            "符号を+にする(今と位置が変わる)"
#set t(changeE,a3)            "変更しない"
#set t(changeE,q2)            "既存の右ブランク値に正の値が設定されています。変更しますか？"
#set t(changeE,a21)           "左ブランクからの時間に変換する(今の位置をずらさない)"
#set t(changeE,a22)           "符号を-にする(今と位置が変わる)"

# 保存フォルダ内の全wavファイルのDC成分を一括除去する
#set t(addUnderScore,q)       "保存フォルダ内の全wavファイル名の冒頭に「_」を追加します(既に付いている場合は何もしません)。よろしいですか？"
#set t(addUnderScore,doneMsg) "ファイル名を変更しました。"
#set t(addUnderScore,doneTitle) "完了"

# 保存フォルダ内の全wavファイルのDC成分を一括除去する
#set t(removeDCall,q)         "保存フォルダ内の全wavファイルのDC成分を一括除去します。よろしいですか？"
#set t(removeDCall,doneMsg)   "DC成分を除去しました。"
#set t(removeDCall,doneTitle) "完了"

# 収録BGMの窓
set t(bgmGuide,title)  "収録方法の設定"
set t(bgmGuide,mode)   "録音モード："
set t(bgmGuide,r1)     "手動録音。「r」を押している間録音状態になる（OREMO ver 1.0と同じ）。"
set t(bgmGuide,r2)     "自動録音その１。「r」キーを押すとBGMを一回再生し、自動的に録音状態になる。収録音の切り替えは手動。"
set t(bgmGuide,r3)     "自動録音その２。「r」キーを押すとBGMをループ再生し、自動的に録音状態になり、自動で収録音が切り替わる。"
set t(bgmGuide,r4)     "無効。"
set t(bgmGuide,bgm)    "BGMファイル："
set t(bgmGuide,bTitle) "BGMファイルの指定"
set t(bgmGuide,play)   "再生"
set t(bgmGuide,stop)   "停止"
set t(bgmGuide,tplay)  "収録例を試聴："

# 指定したファイルを読み込んで再生する
set t(testPlayBGM,errMsg)   "ファイルを読み込めませんでした"
set t(testPlayBGM,errTitle) "再生エラー"

# 先行発声チェック用の設定窓
#set t(uttTimingSettings,title)      "発声タイミングチェックの設定"
#set t(uttTimingSettings,click)      "クリック音："
#set t(uttTimingSettings,clickTitle) "クリック音の指定"
#set t(uttTimingSettings,tempo)      "テンポ："
#set t(uttTimingSettings,bpm)        "BPM = "
#set t(uttTimingSettings,bpmUnit)    "msec/拍"
#set t(uttTimingSettings,clickNum)   "最初に何回クリックを鳴らすか："
#set t(uttTimingSettings,clickUnit)  "回"
#set t(uttTimingSettings,mix)        "音声とクリックの音量バランス："

# 先行発声チェック用の設定
#set t(doUttTimingSettings,errMsg)   "クリック音の回数を20回以下にして下さい。"
#set t(doUttTimingSettings,errMsg2)  "クリック音の回数を0回以上にして下さい。"

# 先行発声を試聴
#set t(playUttTiming,msg)            "試聴は一度に20音までです。冒頭20個のみ再生します。"

# メトロノームの窓
set t(tempoGuide,title)             "メトロノーム"
set t(tempoGuide,click)             "クリック音："
set t(tempoGuide,clickTitle)        "クリック音の指定"
set t(tempoGuide,tempo)             "テンポ："
set t(tempoGuide,bpm)               "BPM = "
set t(tempoGuide,bpmUnit)           "msec/拍"
set t(tempoGuide,comment)           "※「m」キーで再生/停止を切り替えます。"

# 周波数を指定してsin波を再生する
set t(pitchGuide,title)             "音叉窓"
set t(pitchGuide,sel)               "ガイド音選択："  
set t(pitchGuide,vol)               "音量："
set t(pitchGuide,comment)           "※ショートカットキー：o, 上下矢印、2,4,6,8、ESC"

# 自動収録した連続発声からoto.iniを生成
set t(genParam,title)  "連続発声用oto.ini生成"
set t(genParam,tempo)  "収録テンポ："
set t(genParam,bpm)    "単位： bpm"
set t(genParam,S)      "発声開始位置："
set t(genParam,unit)   "単位："
set t(genParam,haku)   "拍"
set t(genParam,darrow) "↓　↓"
set t(genParam,bInit)  "収録テンポから各パラメータ値を初期化"
set t(genParam,O)      "オーバーラップ："
set t(genParam,msec)   "単位：msec"
set t(genParam,P)      "先行発声："
set t(genParam,C)      "固定範囲："
set t(genParam,E)      "右ブランク：" 
set t(genParam,do)     "パラメータ生成"
set t(genParam,aliasMax)          "※エイリアスが重複した際に通し番号を付けるか"
set t(genParam,aliasMaxNo)        "付けない(重複したままにする)"
set t(genParam,aliasMaxYes)       "付ける"
set t(genParam,aliasMaxNum)       "通し番号の上限(0=無制限)"
set t(genParam,autoAdjustRen)     "自動補正１(パワーベース)を使う"
set t(genParam,vLow)              "先行発声のパワー凹み："
set t(genParam,sRange)            "先行発声の移動可能範囲："
set t(genParam,f0pow)             "※上記以外にF0、パワーに関するパラメータも利用します。"
set t(genParam,db)                "単位：dB"
set t(genParam,autoAdjustRen2)    "自動補正２(MFCCベース,時間がかかる)を使う"
set t(genParam,autoAdjustRen2Opt) "オプション"
set t(genParam,autoAdjustRen2Pattern) "適用対象"

# 連続発声のパラメータを自動生成する
set t(doGenParam,doneMsg) "\$v(paramFile)を読み込みました"

# oto.ini生成前に未保存wavが無いか調べる
set t(checkWavForOREMO,saveQ)  "現在表示中のwavファイルが未保存です。"
set t(checkWavForOREMO,saveA1) "保存して続行"
set t(checkWavForOREMO,saveA2) "保存せずに続行"
set t(checkWavForOREMO,saveA3) "キャンセル"

# 一覧表の検索窓
# + 一覧表の検索(先頭方向)
# + 一覧表の検索(末尾方向)
set t(searchParam,title)     "検索"
set t(searchParam,search)    "検索"
set t(searchParam,rup)       "先頭へ向けて検索"
set t(searchParam,rdown)     "末尾へ向けて検索"
set t(searchParam,doneTitle) "検索終了"
set t(searchParam,doneMsg)   "見つかりませんでした。"

# 自動録音開始(BGMつき)
set t(autoRecStart,errMsg)   "BGMファイル(\$v(bgmFile))を読み込めませんでした"
set t(autoRecStart,errMsg2)  "BGM設定ファイル\$v(bgmParamFile)読み込めませんでした"
set t(autoRecStart,errMsg3)  "単位の指定が不正です"
set t(autoRecStart,errMsg4)  "設定ファイル(\$v(bgmParamFile))の末尾では必ずrepeatを設定して下さい。"
set t(autoRecStart,unit)     "単位"

# 自動録音停止
set t(autoRecStop,doneMsg)   "自動録音停止を受け付けました"

# メトロノーム再生/停止の切替
set t(toggleMetroPlay,stopMsg)  "メトロノーム再生停止"
set t(toggleMetroPlay,errTitle) "メトロノームのエラー"
set t(toggleMetroPlay,errMsg)   "メトロノームのテンポは50～200bpmの範囲にしてください。"
set t(toggleMetroPlay,errMsg2)  "メトロノーム用のwavファイル(\$v(clickWav))がありません。"
set t(toggleMetroPlay,playMsg)  "メトロノーム再生中...(「m」を押すと止まります)"
set t(toggleMetroPlay,errPa)  "メトロノームの再生に失敗しました。"

# 音叉再生/停止の切替
set t(toggleOnsaPlay,stopMsg) "音叉再生停止"
set t(toggleOnsaPlay,playMsg) "音叉リピート再生中...(oを押すと止まります)"

# 再生/停止の切替
set t(togglePlay,stopMsg) "再生停止"
set t(togglePlay,playMsg) "再生中..."

# 色選択
set t(chooseColor,title) "色の選択"

# 波形色設定
set t(setColor,selColor) "色の選択"

# 音名の選択メニューをpackしたフレームを生成
set t(packToneList,play)   "再生"
set t(packToneList,repeat) "リピート再生"

#   現在の設定を保存する
set t(saveSettings,title)  "初期化ファイルの生成"

# 入出力デバイスの設定窓の値をデバイスに反映させる
set t(setIODevice,errPa)  "PortAudioのデバイス設定に失敗しました。"
set t(setIODevice,errPa2) "PortAudioの入力デバイスを選択して下さい。"
set t(setIODevice,errPa3) "PortAudioの入力チャンネル数を確認して下さい。"
set t(setIODevice,errPa4) "PortAudioのサンプリング周波数を確認して下さい。"
set t(setIODevice,errPa5) "PortAudioのバッファサイズを確認して下さい。"
set t(setIODevice,errPaOut2) "PortAudioの出力デバイスを選択して下さい。"

#   入出力デバイスを設定する窓
set t(ioSettings,title)    "オーディオI/O設定"
set t(ioSettings,inDev)    "入力デバイス："
set t(ioSettings,outDev)   "出力デバイス："
set t(ioSettings,inGain)   "入力ゲイン(デバイスによっては無効)："
set t(ioSettings,outGain)  "出力ゲイン(デバイスによっては無効)："
set t(ioSettings,latency)  "レイテンシ(デバイスによっては無効)："
set t(ioSettings,sndBuffer) "録音のバッファサイズ："
set t(ioSettings,bgmBuffer) "ガイドBGMのバッファサイズ："
set t(ioSettings,comment0) "※本設定窓はなるべくデフォルト(デバイス=Wave Mapper)のままでお使い下さい。"
set t(ioSettings,comment0b) "　 特にSnackのデバイスでDirectSoundを選ぶと動作不安定になります(日本語Windows)。"
set t(ioSettings,comment1) "※ 上記設定を変更したら必ず「適用」か「OK」を押してください。"
set t(ioSettings,comment2) "　 押さない限り設定は反映されません。"
set t(ioSettings,useRequestRec)  "録音する"
set t(ioSettings,useRequestPlay) "再生する"
set t(ioSettings,sampleRate) "サンプリング周波数(Hz)："
set t(ioSettings,format)     "形式(量子化ビット)："
set t(ioSettings,inChannel)  "入力チャンネル数："
set t(ioSettings,bufferSize)  "バッファサイズ："
set t(ioSettings,portaudio)   "PortAudioで"

# UTAU原音パラメータを自動推定する外部ツールを起動
set t(autoParamEstimation,title)     "外部ツール(パラメータ自動推定)の実行"
set t(autoParamEstimation,aepTool)   "外部ツール"
set t(autoParamEstimation,selTitle)  "外部ツールの指定"
set t(autoParamEstimation,option)    "外部ツール起動時に与える引数"
set t(autoParamEstimation,aepResult) "外部ツールが出力するファイル"
set t(autoParamEstimation,runMsg)    "外部ツールを起動します。"
set t(autoParamEstimation,resultMsg) "外部ツールの実行結果を読み込みます。"

# 単独音のUTAU原音パラメータS,Eを推定する際の設定窓
set t(estimateParam,title)       "原音パラメータの自動推定(単独音用)"
set t(estimateParam,pFLen)       "パワー抽出間隔"
set t(estimateParam,preemph)     "プリエンファシス"
set t(estimateParam,pWinLen)     "パワー抽出窓長"
set t(estimateParam,pWinkind)    "窓の種類"
set t(estimateParam,pUttMin)     "発声中のパワー最小値"
set t(estimateParam,vLow)        "母音のパワー最小値"
set t(estimateParam,pUttMinTime) "最短発声時間"
set t(estimateParam,uttLen)      "発声中のパワーの揺らぎ"
set t(estimateParam,silMax)      "無音中のパワー最大値"
set t(estimateParam,silMinTime)  "最短無音時間"
set t(estimateParam,minC)        "子音長(固定範囲)の最小値"
set t(estimateParam,f0)          "※上記以外にF0に関するパラメータも推定に利用します。"
set t(estimateParam,target)      "推定対象"
set t(estimateParam,S)           "左ブランク"
set t(estimateParam,C)           "子音部"
set t(estimateParam,E)           "右ブランク"
set t(estimateParam,P)           "先行発声"
set t(estimateParam,O)           "オーバーラップ"
set t(estimateParam,overWrite)   "現在の原音パラメータを上書きします。よろしいですか？"
set t(estimateParam,runAll)      "全wavに対して実行"
set t(estimateParam,runSel)      "選択範囲に対して実行"

# UTAU原音パラメータの推定
set t(doEstimateParam,startMsg)  "パラメータ推定中… "
set t(doEstimateParam,doneMsg)   "パラメータ推定終了"

# 原音パラメータを読み込む
set t(readParamFile,selMsg)   "原音パラメータの選択"
set t(readParamFile,startMsg) "原音パラメータを読み込み中..."
set t(readParamFile,errMsg)   "\$v(paramFile)が\$v(saveDir)/下に存在しないwavファイルを参照しています。"
set t(readParamFile,example)  "例："
set t(readParamFile,errMsg2)  "\$v(paramFile)にエントリ行が足りないので追加します。"
set t(readParamFile,doneMsg)  "\$v(paramFile)を読み込みました"

# 原音パラメータを保存する
set t(saveParamFile,selFile)  "原音パラメータの保存"
set t(saveParamFile,startMsg) "原音パラメータを保存中… "
set t(saveParamFile,doneMsg)  "原音パラメータを保存しました"

# 詳細設定
set t(settings,title)        "詳細設定"
set t(settings,wave)         "＜波形＞"
set t(settings,waveColor)    "波形の色："
set t(settings,waveScale)    "縦軸最大値(0-32768,0は自動縮尺)"
set t(settings,sampleRate)   "サンプリング周波数(単位=Hz)："
set t(settings,spec)         "＜スペクトル＞"
set t(settings,specColor)    "スペクトルの色："
set t(settings,maxFreq)      "最高周波数(単位=Hz)："
set t(settings,brightness)   "明るさ："
set t(settings,contrast)     "コントラスト："
set t(settings,fftLength)    "FFT長(単位=サンプル)："
set t(settings,fftWinLength) "窓長(単位=サンプル)："
set t(settings,fftPreemph)   "プリエンファシス："
set t(settings,fftWinKind)   "窓の種類"
set t(settings,pow)          "＜パワー＞"
set t(settings,powColor)     "パワー曲線の色："
set t(settings,powLength)    "パワー抽出間隔(単位=秒)："
set t(settings,powPreemph)   "プリエンファシス："
set t(settings,winLength)    "窓長(単位=秒)："
set t(settings,powWinKind)   "窓の種類："
set t(settings,f0)           "＜F0(ピッチ)＞"
set t(settings,f0Color)      "F0曲線の色："
set t(settings,f0Argo)       "抽出アルゴリズム："
set t(settings,f0Length)     "F0抽出間隔(単位=秒)："
set t(settings,f0WinLength)  "窓長(単位=秒)："
set t(settings,f0Max)        "最高F0(単位=Hz)："
set t(settings,f0Min)        "最低F0(単位=Hz)："
set t(settings,f0Unit)       "表示単位："
set t(settings,f0FixRange)   "描画範囲を固定する"
set t(settings,f0FixRange,h) "最大値："
set t(settings,f0FixRange,l) "最小値："
set t(settings,grid)         "各音の線を描画する"
set t(settings,gridColor)    "線の色："
set t(settings,target)       "発声したい音の線を描画する"
set t(settings,targetTone)   "ターゲット音："
set t(settings,targetColor)  "線の色："
set t(settings,autoSetting)  "ターゲットに合わせて他のパラメータを変更："

# キャンバス再描画
#set t(Redraw,C) "子"
#set t(Redraw,P) "先"
#set t(Redraw,O) "オ"

# 録音開始
set t(recStart,msg) "録音中..."
set t(recStart,errPa)  "PortAudioでの録音開始エラー。"

# 自動録音開始
set t(aRecStart,errPa)  "PortAudioでの録音開始エラー。"

# 自動録音停止
set t(aRecStop,errPa)  "PortAudioでの録音停止エラー。"

# PortAudio録音ツール起動
set t(paRecRun,errMsg) "oremo-recorder.exeを起動できません"
set t(paRecRun,errDev) "利用可能な録音デバイスがありません"

# PortAudio録音ツール起動
set t(paPlayRun,errMsg) "oremo-player.exeを起動できません"
set t(paPlayRun,errDev) "利用可能な再生デバイスがありません"

# 録音終了
set t(recStop,msg)  "録音停止"
set t(recStop,errPa)  "PortAudioでの録音停止エラー。"

# ファイルを保存して終了
#set t(Exit,q1) "原音パラメータが未保存です。どうしますか？"
set t(Exit,q2) "現在表示されている波形が未保存です。どうしますか？"
set t(Exit,a1) "保存して終了"
set t(Exit,a2) "保存せず終了"
set t(Exit,a3) "終了しない"

# 右クリックメニュー
set t(PopUpMenu,showWave)   "波形を表示"
set t(PopUpMenu,showSpec)   "スペクトルを表示"
set t(PopUpMenu,showPow)    "パワーを表示"
set t(PopUpMenu,showF0)     "F0を表示"
set t(PopUpMenu,pitchGuide) "音叉窓を表示"
set t(PopUpMenu,tempoGuide) "メトロノームを表示"
set t(PopUpMenu,settings)   "詳細設定"
set t(PopUpMenu,zoomTitle)  "横軸の拡大"
set t(PopUpMenu,zoom100)    "1倍 (wav全体を表示)"
set t(PopUpMenu,zoom1000)   "10倍"
set t(PopUpMenu,zoom5000)   "50倍"
set t(PopUpMenu,zoom10000)  "100倍"
set t(PopUpMenu,zoomMax)    "拡大率最大"

# バージョン情報表示
set t(Version,msg) "バージョン情報"

# ParamUを初期化
set t(initParamU,0) "音"
set t(initParamU,1) "左ブランク"
set t(initParamU,2) "overlap"
set t(initParamU,3) "先行発声"
set t(initParamU,4) "固定範囲"
set t(initParamU,5) "右ブランク"
set t(initParamU,6) "エイリアス"

# 一覧表のタイトルを更新する
#set t(setEPWTitle) "原音パラメータ一覧"

# パラメータ一覧表の行を複製する
#set t(duplicateEntp,msg)   "複数行を選択した状態では行複製できません。"
#set t(duplicateEntp,title) "行複製のエラー"

# 保存フォルダの各wavの両端を指定秒カット(設定窓)
#set t(cutWav,title)    "wavの両端をカット"
#set t(cutWav,L)        "冒頭からのカット長"
#set t(cutWav,R)        "末尾からのカット長"
#set t(cutWav,sec)      "秒"
#set t(cutWav,adjSE)    "カット後に左右ブランク値を補正してパラメータ位置がずれないようにする\n(ただしブランク値よりも長くカットした場合はずれます)"

# 保存フォルダの各wavの両端を指定秒カット
#set t(doCutWav,q)         "保存フォルダ内の全wavファイルから両端をカットします。よろしいですか？"
#set t(doCutWav,doneMsg)   "各wavの両端をカットしました"
#set t(doCutWav,doneTitle) "完了"
#set t(doCutWav,errMsg)   "カットする秒数は0以上の数にして下さい"

# エイリアス一括変換
#set t(changeAlias,title)      "エイリアス一括変換"
#set t(changeAlias,trans)      "変換規則："
#set t(changeAlias,delPreNum)  "現在のエイリアス冒頭から削除する文字数"
#set t(changeAlias,delPostNum) "現在のエイリアス末尾から削除する文字数"
#set t(changeAlias,tips1)      "%a = 各エイリアス欄に設定されている文字列"
#set t(changeAlias,tips2)      "%f = 各欄の音名(ファイル名)"
#set t(changeAlias,ex1)        "(例1)「あ.wav」を「あ2」にするなら変換規則を「%f2」とし、他を空欄にする。"
#set t(changeAlias,ex2)        "(例2)「あ2」を「あ」にするなら変換規則を「%a」とし、「～末尾から削除する文字数」を1にする。"

# ustファイルを読んで編集対象リストを作る
#set t(readUstFile,doneMsg)  "ustファイルを読み込みました"
#set t(readUstFile,startMsg)   "現在編集中のデータから、指定したustの合成に必要なもののみを残し、それ以外のデータを削除します。現在の状態に戻したいときは本ソフトを再起動して下さい。"
#set t(readUstFile,errMsg)   "リストを構成できませんでした。原音パラメータの読み込みからやり直してください。"

# 発声タイミング補正モード
#set t(timingAdjMode,startMsg) "発声タイミング補正モードをONにします。右ブランク値の表現方法、先行発声を動かしたときのふるまいを適宜設定し直して下さい。"
#set t(timingAdjMode,doneMsg)  "発声タイミング補正モードを解除します。"
#set t(timingAdjMode,on)       "発声タイミング(先行発声)補正モードON"
#set t(timingAdjMode,off)      "発声タイミング(先行発声)補正モードOFF"

# 選択中の欄の値を変更する
#set t(changeCell,title)   "選択範囲のデータ一括変更"
#set t(changeCell,r1)      "加算"
#set t(changeCell,r2)      "減算"
#set t(changeCell,r3)      "セット"
#set t(changeCell,r4)      "整数化"

# 新たに原音パラメータを読み込んで読み込み済みのものにマージする
#set t(mergeParamFile,delParam) "現在のパラメータの一部あるいは全部が上書きされます。よろしいですか？"
#set t(mergeParamFile,selMsg)   "パラメータファイルの選択"
#set t(mergeParamFile,startMsg) "マージします"
#set t(mergeParamFile,doneMsg)  "マージしました"

# コメントの検索窓
set t(searchComment,title)     "検索"
set t(searchComment,search)    "検索"
set t(searchComment,rup)       "先頭へ向けて検索"
set t(searchComment,rdown)     "末尾へ向けて検索"
set t(searchComment,doneTitle) "検索終了"
set t(searchComment,doneMsg)   "見つかりませんでした。"
set t(searchComment,rMatch1)   "完全一致"
set t(searchComment,rMatch2)   "部分一致"

# キー割り当ての設定窓
set t(bindWindow,record)      "録音開始＆停止"
set t(bindWindow,recStop)     "自動録音停止"
set t(bindWindow,nextRec)     "次の録音へ"
set t(bindWindow,prevRec)     "前の録音へ"
set t(bindWindow,nextType)    "次の録音タイプへ"
set t(bindWindow,prevType)    "前の録音タイプへ"
set t(bindWindow,nextRec0)    "(録音を保存せず)次の録音へ"
set t(bindWindow,prevRec0)    "(録音を保存せず)前の録音へ"
set t(bindWindow,nextType0)   "(録音を保存せず)次の録音タイプへ"
set t(bindWindow,prevType0)   "(録音を保存せず)前の録音タイプへ"
set t(bindWindow,togglePlay)  "音の再生"
set t(bindWindow,toggleOnsaPlay)   "音叉の再生"
set t(bindWindow,toggleMetroPlay)  "メトロノームの再生"
set t(bindWindow,searchComment)    "コメント検索"
set t(bindWindow,waveReload)  "波形の再読み込み"
set t(bindWindow,waveExpand)  "拡大"
set t(bindWindow,waveShrink)  "縮小"
set t(bindWindow,ex)          "(例) a, A, Ctrl-a, Alt-a, Ctrl-Alt-a"
set t(bindWindow,ex2)         "(例) space, F1, F2"
set t(bindWindow,ex3)         "※ 設定を変えても以前割り当てたショートカット設定は消えません"
set t(bindWindow,errTitle)    "キー設定のエラー"
set t(bindWindow,errMsg)      "\"キー設定を反映できません( \$value )\""

# フォントサイズの設定窓
set t(fontWindow,attention)   "再起動後に有効になります"
set t(fontWindow,attention2)  "autoSaveInitFile=0に設定変更した場合には有効になりません"
set t(fontWindow,lbfs)        "収録音のフォントサイズ"
set t(fontWindow,lfs)         "収録音リストのフォントサイズ"
set t(fontWindow,lcfs)        "コメント欄のフォントサイズ"

# setParam形式のコメントを読み込む
set t(isSetparamComment,q) "\"\$iniFile と併せてsetParam形式のコメントファイルとして読み込みます。よろしいですか？\""
