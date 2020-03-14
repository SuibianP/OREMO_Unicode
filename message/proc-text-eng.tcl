#--------------------------------
# ※特殊な設定
# 日本語フォントを設定する(ここで設定したフォントを使って以降の文字列を表示させる
#
set t(fontName) "Arial"


#--------------------------------
# メッセージ
#

set t(setLanguage,opentitle)  "Open Language Files"

# ダイアログによく出るメッセージ
set t(.confm)        "Confirmed"
set t(.confm.r)      "Load"
set t(.confm.nr)     "Don't Load"
set t(.confm.fioErr) "File I/O Error"
set t(.confm.yes)    "Yes"
set t(.confm.no)     "No"
set t(.confm.ok)     "OK"
set t(.confm.apply)  "Apply"
set t(.confm.run)    "Go"
set t(.confm.c)      "Cancel"
set t(.confm.errTitle) "Error"
set t(.confm.warnTitle) "Warning"
set t(.confm.delParam)  "All current voice configurations are removed.  OK?"

# 保存フォルダにあるwavファイルを読み、リストに記憶する
set t(makeRecListFromDir,q)  "Load voice configuration file?"
set t(makeRecListFromDir,a)  "Automatically Estimate Voice Configuration Parameters"

# ustファイルを読み、リストに記憶する
set t(makeRecListFromUst,title1)    "Open Ust file"
set t(makeRecListFromUst,errMsg)    "Failed to load Ust file"
set t(makeRecListFromUst,doneMsg)   "Loaded Ust file successfully."

# 起動時にパラメータ自動推定を行う際のウィザード
set t(genParamWizard,title)  "Voice Data Type"
set t(genParamWizard,q)      "Select the Type of Target Voice Data."
set t(genParamWizard,a1)     "CV  (Isolated Utterance)"
set t(genParamWizard,a2)     "VCV (Continuous Utterance)"

# reclist.txtを保存する
set t(saveRecList,title)     "Save Voice List"
set t(saveRecList,errMsg)    "Failed to write to \$v(recListFile)."
set t(saveRecList,errMsg2)   "Failed to write voice names."
set t(saveRecList,doneMsg)   "Voice List is saved to \$v(recListFile)."

# コメントを保存する
set t(saveCommentList,errMsg)] "Could not save comment file."

# 音名リストファイルを読み、リストに記憶する
set t(readRecList,title1)    "Load Voice List"
set t(readRecList,errMsg)    "Failed to load recording voice name list (\$v(recListFile))."
set t(readRecList,errMsg2)   "Failed to load recording voice names."
set t(readRecList,doneMsg)   "Loaded \$v(recListFile)."
set t(readRecList,overwrite) "Comment File was found in voice list folder. Do you want to load this?"

# コメントファイルを読む
set t(readCommentList,errMsg)   "Could not load comment file."
set t(readCommentList,doneMsg)  "\"\$commNum Comments Loaded\""
set t(readCommentList,doneMsg2) "\"\$commNum Comments Loaded ( \$ignoreNum comments were duplicate)\""

# 発声タイプのリストファイルを読み、リストに記憶する
set t(readTypeList,title)    "Load Utterance Type List"
set t(readTypeList,errMsg)   "Failed to load recording utterance type list (\$v(typeListFile))."
set t(readTypeList,errMsg2)  "Failed to load recording utterance types."
set t(readTypeList,doneMsg)  "Loaded \$v(typeListFile)."

# 保存ディレクトリを指定する
set t(choosesaveDir,title)   "Set Recording Folder"
set t(choosesaveDir,doneMsg) "Recording folder is modified."
set t(choosesaveDir,q)       "Load voice configuration parameter file as well?"

# 未保存であれば波形をファイルに保存する
set t(saveWavFile,doneMsg)   "\$v(saveDir)/\$v(recLab)\$v(typeLab).wav is saved."

# F0計算中にキーボード、マウス入力を制限させるための窓
set t(waitWindow,title)      "Computing F0..."

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
set t(bgmGuide,title)  "Recording Style Settings"
set t(bgmGuide,mode)   "Recording Mode: "
set t(bgmGuide,r1)     "Manual recording: record while 'r' is pressed. (Same as OREMO ver 1.0)"
set t(bgmGuide,r2)     "Automatic recording 1:\nWhen 'r' is pressed, play the guide music ONCE and record automatically.\nVoice switching is performed manually."
set t(bgmGuide,r3)     "Automatic recording 2:\nWhen 'r' is pressed, play the guide music REPEATEDLY and record automatically.\nVoice switching is also performed automatically."
set t(bgmGuide,r4)     "Disabled."
set t(bgmGuide,bgm)    "Guide Music File: "
set t(bgmGuide,bTitle) "Guide Music File Setting"
set t(bgmGuide,play)   "Play"
set t(bgmGuide,stop)   "Stop"
set t(bgmGuide,tplay)  "Test Play: "

# 指定したファイルを読み込んで再生する
set t(testPlayBGM,errMsg)   "Failed to load file."
set t(testPlayBGM,errTitle) "Play Error"

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
set t(tempoGuide,title)             "Tempo Guide"
set t(tempoGuide,click)             "Click: "
set t(tempoGuide,clickTitle)        "Click Sound Setting"
set t(tempoGuide,tempo)             "Tempo: "
set t(tempoGuide,bpm)               "BPM = "
set t(tempoGuide,bpmUnit)           "msec/beat"
set t(tempoGuide,comment)           "* 'm' Key Toggles Play/Stop."

# 周波数を指定してsin波を再生する
set t(pitchGuide,title)             "Pitch Guide"
set t(pitchGuide,sel)               "Guide Sound Setting: "
set t(pitchGuide,vol)               "Volume: "
set t(pitchGuide,comment)           "* Shortcut Keys: o, Up&Down Arrows, 2,4,6,8, Esc"

# 自動収録した連続発声からoto.iniを生成
set t(genParam,title)  "Generate oto.ini for VCV"
set t(genParam,tempo)  "Recording Tempo: "
set t(genParam,bpm)    "Unit: bpm"
set t(genParam,S)      "Utterance Start: "
set t(genParam,unit)   "Unit: "
set t(genParam,haku)   "beat"
set t(genParam,darrow) "VV VV"
set t(genParam,bInit)  "Initialise Parameters according to Recording Tempo"
set t(genParam,O)      "Overlap: "
set t(genParam,msec)   "Unit: msec"
set t(genParam,P)      "Pre-utterance: "
set t(genParam,C)      "Consonant: "
set t(genParam,E)      "Right Blank: "
set t(genParam,do)     "Generate Params"
set t(genParam,aliasMax)          "* Append Serial Numbers to Identify Duplicate Aliases?"
set t(genParam,aliasMaxNo)        "No (Aliases Remain Duplicate.)"
set t(genParam,aliasMaxYes)       "Yes (Append Serial Numbers.)"
set t(genParam,aliasMaxNum)       "Maximum of Serial Number (0=Unlimited)"
set t(genParam,autoAdjustRen)     "Use Parameter Auto Correction 1 (based on power)"
set t(genParam,vLow)              "Power Hollow before Pre-Utterance: "
set t(genParam,sRange)            "Search Range for Pre-Utterance: "
set t(genParam,f0pow)             "* F0 and other power related parameters are also used."
set t(genParam,db)                "unit: dB"
set t(genParam,autoAdjustRen2)    "Use Parameter Auto Correction 2 (based on MFCC, takes long time)"
set t(genParam,autoAdjustRen2Opt) "Option"
set t(genParam,autoAdjustRen2Pattern) "Target Morae"

# 連続発声のパラメータを自動生成する
set t(doGenParam,doneMsg) "Loaded \$v(paramFile)"

# oto.ini生成前に未保存wavが無いか調べる
set t(checkWavForOREMO,saveQ)  "Current waveform is not saved yet."
set t(checkWavForOREMO,saveA1) "Save and Continue"
set t(checkWavForOREMO,saveA2) "Continue without Saving"
set t(checkWavForOREMO,saveA3) "Cancel"

# 一覧表の検索窓
# + 一覧表の検索(先頭方向)
# + 一覧表の検索(末尾方向)
set t(searchParam,title)     "Find"
set t(searchParam,search)    "Find"
set t(searchParam,rup)       "Find Forward"
set t(searchParam,rdown)     "Find Backward"
set t(searchParam,doneTitle) "Finished"
set t(searchParam,doneMsg)   "Not Found."

# 自動録音開始(BGMつき)
set t(autoRecStart,errMsg)   "Failed to load guide music file (\$v(bgmFile))."
set t(autoRecStart,errMsg2)  "Failed to load guide music configuration file \$v(bgmParamFile)."
set t(autoRecStart,errMsg3)  "Illegal Unit Setting"
set t(autoRecStart,errMsg4)  "Please make sure to specify 'repeat' at the end of the configuration file (\$v(bgmParamFile))."
set t(autoRecStart,unit)     "Unit"

# 自動録音停止
set t(autoRecStop,doneMsg)   "Automatic recording stop request accepted."

# メトロノーム再生/停止の切替
set t(toggleMetroPlay,stopMsg)  "Play/Stop Tempo Guide"
set t(toggleMetroPlay,errTitle) "Tempo Guide Error"
set t(toggleMetroPlay,errMsg)   "Tempo for guide must be within 50-200bpm."
set t(toggleMetroPlay,errMsg2)  "Tempo guide wav file (\$v(clickWav)) is not found."
set t(toggleMetroPlay,playMsg)  "Playing Tempo Guide... (Press 'm' to stop)"
set t(toggleMetroPlay,errPa)  "Metronome playing was failed."

# 音叉再生/停止の切替
set t(toggleOnsaPlay,stopMsg) "Play/Stop Pitch Guide"
set t(toggleOnsaPlay,playMsg) "Playing Pitch Guide... (Press 'o' to stop)"

# 再生/停止の切替
set t(togglePlay,stopMsg) "Stopped"
set t(togglePlay,playMsg) "Playing..."

# 色選択
set t(chooseColor,title) "Colour Setting"

# 波形色設定
set t(setColor,selColor) "Colour Setting"

# 音名の選択メニューをpackしたフレームを生成
set t(packToneList,play)   "Play"
set t(packToneList,repeat) "Repeat"

#   現在の設定を保存する
set t(saveSettings,title)  "Generate Initialisation File"

# 入出力デバイスの設定窓の値をデバイスに反映させる
set t(setIODevice,errPa)  "PortAudio Device Setting was failed."
set t(setIODevice,errPa2) "Choose the Input Device in PortAudio"
set t(setIODevice,errPa3) "Confirm the Input Channel Number in PortAudio"
set t(setIODevice,errPa4) "Confirm the Sampling Frequency in PortAudio"
set t(setIODevice,errPa5) "Confirm the Buffer Size in PortAudio"
set t(setIODevice,errPaOut2) "Choose the Output Device inPortAudio"

#   入出力デバイスを設定する窓
set t(ioSettings,title)    "Audio I/O Settings"
set t(ioSettings,inDev)    "Input Device: "
set t(ioSettings,outDev)   "Output Device: "
set t(ioSettings,inGain)   "Input Gain (device dependent): "
set t(ioSettings,outGain)  "Output Gain (device dependent): "
set t(ioSettings,latency)  "Latency (device dependent): "
set t(ioSettings,sndBuffer) "Buffer Size for Recording: "
set t(ioSettings,bgmBuffer) "Buffer Size for Guide-BGM: "
set t(ioSettings,comment0) "* Leaving the values in this window as default (Device = Wave Mapper) is recommended."
set t(ioSettings,comment0b) "* Especially, DirectSound is unstable in Snack-lib. on Japanese Windows."
set t(ioSettings,comment1) "* Modifications are not applied until pressing 'Apply' or 'OK' button."
set t(ioSettings,comment2) ""
set t(ioSettings,useRequestRec)  "Enable Recording"
set t(ioSettings,useRequestPlay) "Enable Playing"
set t(ioSettings,sampleRate) "Sampling Frequency(Hz): "
set t(ioSettings,format)     "Quantize Bit: "
set t(ioSettings,inChannel)  "Input Channel Number: "
set t(ioSettings,bufferSize)  "Buffer Size: "
set t(ioSettings,portaudio)   "PortAudio"

# UTAU原音パラメータを自動推定する外部ツールを起動
set t(autoParamEstimation,title)     "External Tool (Automatic Parameter Estimation) Exection"
set t(autoParamEstimation,aepTool)   "External Tool"
set t(autoParamEstimation,selTitle)  "External Tool Location"
set t(autoParamEstimation,option)    "External Tool Start-up Script"
set t(autoParamEstimation,aepResult) "External Tool Output File"
set t(autoParamEstimation,runMsg)    "Launch External Tool"
set t(autoParamEstimation,resultMsg) "Retrieve External Tool Result"

# 単独音のUTAU原音パラメータS,Eを推定する際の設定窓
set t(estimateParam,title)       "Automatic Voice Parameter Estimation (CV diphones)"
set t(estimateParam,pFLen)       "Power Sampling Unit"
set t(estimateParam,preemph)     "Pre-emphasis"
set t(estimateParam,pWinLen)     "Power Sampling Window Width"
set t(estimateParam,pWinkind)    "Window Type"
set t(estimateParam,pUttMin)     "Minimum Power during Utterance"
set t(estimateParam,vLow)        "Minimum Power of Vowel"
set t(estimateParam,pUttMinTime) "Minimum Utterance Duration"
set t(estimateParam,uttLen)      "Utterance Power Jitter"
set t(estimateParam,silMax)      "Maximum Power during Silence"
set t(estimateParam,silMinTime)  "Minimum Silence Durationn"
set t(estimateParam,minC)        "Minimum Length of Consonant"
set t(estimateParam,f0)          "(P.S.) F0 Parameters is also used for estimation."
set t(estimateParam,target)      "Estimation Target"
set t(estimateParam,S)           "Left Blank"
set t(estimateParam,C)           "Consonant"
set t(estimateParam,E)           "Right Blank"
set t(estimateParam,P)           "Pre-utterance"
set t(estimateParam,O)           "Overlap"
set t(estimateParam,overWrite)   "Current Parameters are Overwritten.  OK?"
set t(estimateParam,runAll)      "Apply to All Wav Files"
set t(estimateParam,runSel)      "Apply to Selected Wav Files"

# UTAU原音パラメータの推定
set t(doEstimateParam,startMsg)  "Estimating Parameters..."
set t(doEstimateParam,doneMsg)   "Parameters Estimated"

# 原音パラメータを読み込む
set t(readParamFile,selMsg)   "Voice Configuration Parameter Selection"
set t(readParamFile,startMsg) "Loading voice configuration parameters..."
set t(readParamFile,errMsg)   "\$v(paramFile) refers to unexistent wav file in \$v(saveDir) / ."
set t(readParamFile,example)  "e.g.: "
set t(readParamFile,errMsg2)  "Missing entries are added to \$v(paramFile)."
set t(readParamFile,doneMsg)  "Loaded \$v(paramFile)."

# 原音パラメータを保存する
set t(saveParamFile,selFile)  "Save Voice Configuration Parameters"
set t(saveParamFile,startMsg) "Saving voice configuration parameters..."
set t(saveParamFile,doneMsg)  "Saved voice configuration parameters."

# 詳細設定
set t(settings,title)        "Advanced Settings"
set t(settings,wave)         "<Waveform>"
set t(settings,waveColor)    "Waveform Colour: "
set t(settings,waveScale)    "Max Value of Vertical Axis(0-32768, 0=autoscale)"
set t(settings,sampleRate)   "Sampling Frequency \[Hz\]: "
set t(settings,spec)         "<Spectrum>"
set t(settings,specColor)    "Spectrum Colour: "
set t(settings,maxFreq)      "Maximum Frequency \[Hz\]: "
set t(settings,brightness)   "Brightness: "
set t(settings,contrast)     "Contrast: "
set t(settings,fftLength)    "FFT Length \[sample\]: "
set t(settings,fftWinLength) "Window Width \[sample\]: "
set t(settings,fftPreemph)   "Pre-emphasis: "
set t(settings,fftWinKind)   "Window Type"
set t(settings,pow)          "<Power>"
set t(settings,powColor)     "Power Curve Colour: "
set t(settings,powLength)    "Power Sampling Unit \[sec\]: "
set t(settings,powPreemph)   "Pre-emphasis: "
set t(settings,winLength)    "Window Width \[sec\]: "
set t(settings,powWinKind)   "Window Type: "
set t(settings,f0)           "<F0 (Pitch)>"
set t(settings,f0Color)      "F0 Curve Colour: "
set t(settings,f0Argo)       "Analysis Algorithm: "
set t(settings,f0Length)     "F0 Sampling Frequency \[sec\]: "
set t(settings,f0WinLength)  "Window Width \[sec\]: "
set t(settings,f0Max)        "Maximum F0 \[Hz\]: "
set t(settings,f0Min)        "Minimum F0 \[Hz\]: "
set t(settings,f0Unit)       "Display Unit: "
set t(settings,f0FixRange)   "Fix Display Area: "
set t(settings,f0FixRange,h) "Maximum: "
set t(settings,f0FixRange,l) "Minimum: "
set t(settings,grid)         "Show Key Grids"
set t(settings,gridColor)    "Grid Colour: "
set t(settings,target)       "Show Target Tone"
set t(settings,targetTone)   "Target Tone: "
set t(settings,targetColor)  "Target Tone Colour: "
set t(settings,autoSetting)  "Parameter Change According to Target: "

# キャンバス再描画
#set t(Redraw,C) "子"
#set t(Redraw,P) "先"
#set t(Redraw,O) "オ"

# 録音開始
set t(recStart,msg) "Recording..."
set t(recStart,errPa)  "Recording (with PortAudio) Start Error"

# 自動録音開始
set t(aRecStart,errPa)  "Recording (with PortAudio) Start Error"

# 自動録音停止
set t(aRecStop,errPa)  "Recording (with PortAudio) Stop Error"

# PortAudio録音ツール起動
set t(paRecRun,errMsg) "can not execute oremo-recorder.exe"
set t(paRecRun,errDev) "Recording device is not available."

# PortAudio録音ツール起動
set t(paPlayRun,errMsg) "can not execute oremo-player.exe"
set t(paPlayRun,errDev) "Play device is not available."

# 録音終了
set t(recStop,msg)  "Recording Stopped"
set t(recStop,errPa)  "Recording (with PortAudio) Stop Error"

# ファイルを保存して終了
#set t(Exit,q1) "原音パラメータが未保存です。どうしますか？"
set t(Exit,q2) "Current voice wav file is not saved.  Save it?"
set t(Exit,a1) "Save and Exit"
set t(Exit,a2) "Exit without Save"
set t(Exit,a3) "Cancel"

# 右クリックメニュー
set t(PopUpMenu,showWave)   "Show Waveform"
set t(PopUpMenu,showSpec)   "Show Spectrum"
set t(PopUpMenu,showPow)    "Show Power"
set t(PopUpMenu,showF0)     "Show F0"
set t(PopUpMenu,pitchGuide) "Show Pitch Guide"
set t(PopUpMenu,tempoGuide) "Show Tempo Guide"
set t(PopUpMenu,settings)   "Preferences"
set t(PopUpMenu,zoomTitle)  "Time Zoom"
set t(PopUpMenu,zoom100)    "x1 (Show Whole Waveform)"
set t(PopUpMenu,zoom1000)   "x10"
set t(PopUpMenu,zoom5000)   "x50"
set t(PopUpMenu,zoom10000)  "x100"
set t(PopUpMenu,zoomMax)    "Maximum Zoom"

# バージョン情報表示
set t(Version,msg) "Version"

# ParamUを初期化
set t(initParamU,0) "Voice"
set t(initParamU,1) "Left Blank"
set t(initParamU,2) "Overlap"
set t(initParamU,3) "Pre-utterance"
set t(initParamU,4) "Consonant"
set t(initParamU,5) "Right Blank"
set t(initParamU,6) "Alias"

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
set t(searchComment,title)     "Search"
set t(searchComment,search)    "Search"
set t(searchComment,rup)       "Backward Search"
set t(searchComment,rdown)     "Forward Search"
set t(searchComment,doneTitle) "Search was done."
set t(searchComment,doneMsg)   "No match found."
set t(searchComment,rMatch1)   "Exact Match"
set t(searchComment,rMatch2)   "Partial Match"

# キー割り当ての設定窓
set t(bindWindow,record)      "Recording Start & Stop"
set t(bindWindow,recStop)     "Automatic Recording Stop"
set t(bindWindow,nextRec)     "Next Record Entry"
set t(bindWindow,prevRec)     "Previous Record Entry"
set t(bindWindow,nextType)    "Next Record Type"
set t(bindWindow,prevType)    "Previous Record Type"
set t(bindWindow,nextRec0)    "(without save) Next Record Entry"
set t(bindWindow,prevRec0)    "(without save) Previous Record Entry"
set t(bindWindow,nextType0)   "(without save) Next Record Type"
set t(bindWindow,prevType0)   "(without save) Previous Record Type"
set t(bindWindow,togglePlay)  "Play Start & Stop"
set t(bindWindow,toggleOnsaPlay)   "Tuner Play & Stop"
set t(bindWindow,toggleMetroPlay)  "Metronome Play & Stop"
set t(bindWindow,searchComment)    "Comment Search"
set t(bindWindow,waveReload)  "Wav File Reload"
set t(bindWindow,waveExpand)  "Enlarge Screen"
set t(bindWindow,waveShrink)  "Shrink Screen"
set t(bindWindow,ex)          "e.g. a, A, Ctrl-a, Alt-a, Ctrl-Alt-a"
set t(bindWindow,ex2)         "e.g. space, F1, F2"
set t(bindWindow,ex3)         "* Prior bindings are not cleared until restart even if change."
set t(bindWindow,errTitle)    "Key Binding Error"
set t(bindWindow,errMsg)      "\"invalid entry ( \$value )\""

# フォントサイズの設定窓
set t(fontWindow,attention)   "Settings become effective after restart."
set t(fontWindow,attention2)  "Settings are ignored in depend on oremo-setting.ini"
set t(fontWindow,lbfs)        "Font Size of Record Entry"
set t(fontWindow,lfs)         "Font Size of Record Entry List"
set t(fontWindow,lcfs)        "Font Size of Comment Field"

# setParam形式のコメントを読み込む
set t(isSetparamComment,q) "\"Loading this file as the setParam-formed comment file. OK?\""

