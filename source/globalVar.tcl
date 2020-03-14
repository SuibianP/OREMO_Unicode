#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

# 2.0-b091104
# - 先行発声チェック用の設定配列を追加

# 2.0-b090720
# - 各ファイルへのパスを、exe(starkit)のときとtclのときとの両方に対応
# - ガイドBGM関係の設定を追加
# - メトロノーム音、ガイドBGM関係ファイルをguideBGM/に移動

# 2.0-b090706
# - oremo本体にあった大域変数を globalVar.tclにまとめた

#---------------------------------------------------
# 変数設定
#
set debug 0
set v(appname) ""
set v(version) ""
if {$::tcl_platform(os) == "Darwin"} {
  set topdir [file join [file dirname [info script]] ../../../..]  ;# for mac
} elseif {[info exists ::starkit::topdir]} {
  set topdir [file dirname [info nameofexecutable]]
} else {
  set topdir [file dirname $argv0]
}
set v(recListFile) "$topdir/reclist.txt"   ;# 収録する音名リストファイル
set v(typeListFile) "$topdir/typelist.txt" ;# 収録する発話タイプのリストファイル
set v(saveDir) "$topdir/result"            ;# 録音した音を保存するディレクトリ
set v(paramFile) "$v(saveDir)/oto.ini"     ;# 原音パラメータファイル
set v(yaxisw) 40         ;# 縦軸表示の横幅
set v(timeh)  20         ;# 横軸表示の縦幅
set v(showWave) 1        ;# 1=波形表示, 0=非表示
set v(waveh)  100        ;# 波形パネルの縦幅
set v(wavehbackup) 100   ;# 波形表示の縦サイズのバックアップをとる
set v(wavehmin)  50             ;# 縮小した際の最小縦幅
set v(wavepps)  200             ;# pixel/sec。
set v(waveScale) 32768          ;# 波形表示縦軸の最大値。0でautoscale
set v(sfont) {Helvetica 8 bold} ;# 目盛り表示のフォント
set v(bg) [. cget -bg]
set v(fg) black
set v(wavColor) black
set v(recStatus) 0       ;# 1=たった今録音した, 0=録音してない
set v(playStatus) 0      ;# 1=今再生中, 0=今再生してない
set v(playOnsaStatus) 0  ;# 1=現在音叉再生中, 0=現在再生してない
set v(recList) {}        ;# 収録する音名を入れるリスト
set v(recSeq) 0          ;# 現在収録中の音番号
set v(recLab) ""         ;# 現在収録中の音名
set v(typeList) {""}     ;# 収録する発声タイプを入れるリスト
set v(typeLab) ""        ;# 現在収録中の発声タイプ
set v(typeSeq) 0         ;# 現在収録中の発声タイプ番号
set v(bigFontSize) 24    ;# フォントサイズ(収録音名)
set v(fontSize) 18       ;# フォントサイズ(収録音名一覧)
set v(smallFontSize) 14  ;# フォントサイズ(軸の目盛)
set v(commFontSize) 18   ;# フォントサイズ(コメント欄)
set v(msg) ""            ;# ソフト最下段に表示するメッセージ
set v(rec) 1             ;# 1=録音OK、0=録音不可
set v(recNow) 0          ;# 1=録音中(rを押している間)、0=録音停止中。
set v(ext) wav           ;# 波形ファイルの拡張子
set v(autoSaveInitFile) 1 ;# 1=$topdir/oremo-init.tclを自動保存する、0=保存しない
set v(skipChangeWindowBorder) 0   ;# 一時的にchangeWindowBorder のイベント実行を無効化するフラグ

set v(showSpec) 0        ;# 1=スペクトル表示, 0=非表示
set v(spech)    0        ;# スペクトル表示の縦サイズ
set v(spechbackup) 140   ;# スペクトル表示の縦サイズのバックアップをとる
set v(spechmin) 50      ;# スペクトル表示の縦サイズ(縮小時の最小縦幅)
set v(topfr)    8000     ;# スペクトル表示の最高周波数
set v(cmap)     grey     ;# スペクトル配色
set v(contrast) 0        ;# スペクトルのコントラスト
set v(brightness) 0      ;# スペクトルの明るさ
set v(fftlen) 512        ;# FFT長
set v(winlen) 128        ;# 窓長
set v(window) Hamming    ;# スペクトル抽出窓
set v(preemph) 0.97      ;# スペクトル抽出のプリエンファシス

set v(showpow) 0        ;# 1=パワー表示, 0=非表示
set v(powh)    0        ;# パワー表示の縦サイズ
set v(powhmin) 50       ;# パワー表示の縦サイズ(縮小時の最小縦幅)
set v(powhbackup) 100   ;# パワー表示の縦サイズのバックアップをとる
set power(frameLength) 0.02  ;# パワー抽出刻み[sec]
set power(window)  Hanning    ;# パワー抽出時の窓
set power(preemphasis)  0.97  ;# パワー抽出時のプリエンファシス
set power(windowLength)  0.01 ;# パワー抽出窓長[sec]
set power(power) {}           ;# 抽出したパワー値系列を保存する
set power(powerMax) 0         ;# 抽出結果の最大値
set power(powerMin) 0         ;# 抽出結果の最小値
set v(powcolor) blue          ;# パワー曲線の色

set power(uttLow)  28    ;# 無音とみなされる振幅の閾値[dB]
set power(uttHigh) 28    ;# 発話とみなされる振幅の閾値[dB]
set power(uttKeep) 5     ;# 発話中の音量のゆらぎとみなされる幅の閾値[dB]
set power(vLow)    40    ;# 母音とみなされる振幅の閾値[dB]
set power(uttLengthSec) 0.1  ;# 発話中とみなされる時間長[sec]
set power(uttLength) [sec2samp $power(uttLengthSec) $power(frameLength)]  ;# 発話中とみなされる時間長[sample]
set power(silLengthSec) 0.0  ;# ポーズとみなされる時間長[sec]
set power(silLength) [sec2samp $power(silLengthSec) $power(frameLength)]  ;# ポーズとみなされる時間長[sample]
set power(fid) ""                           ;# パワー抽出したファイルのFID

set v(toneList) {C C# D D# E F F# G G# A A# B} ;# ガイド音名リスト1oct分
set v(sinScaleMin) 2     ;# ガイドsin音の最低オクターブ
set v(sinScaleMax) 5     ;# ガイドsin音の最高オクターブ
set v(sinScale) {}       ;# ガイドsin音の周波数リスト
set v(sinNote) {}   ;# ガイドsin音の周波数に対応する音名
set f0(checkVol) 4000    ;# 詳細設定窓で再生するsin音の振幅初期値
set f0(guideVol) 4000    ;# ガイドsin音の振幅初期値
set f0(tgtTone) [lindex $v(toneList) 0]  ;# ターゲット音名
set f0(tgtOctave) $v(sinScaleMin)        ;# ターゲット音のオクターブ
set f0(tgtFreq) 0                        ;# ターゲット音の周波数
set f0(showToneLine) 1                   ;# 1=各音の横線をF0パネルに表示
set f0(showTgtLine) 0                    ;# 1=ターゲット音をF0パネルに表示
set f0(fid) ""                           ;# F0抽出したファイルのFID
set f0(extractedMin) 0                   ;# 抽出したF0の最小値
set f0(extractedMax) 0                   ;# 抽出したF0の最大値

set v(showf0) 0           ;# 1=F0表示, 0=非表示
set v(f0h)    0           ;# F0表示の縦サイズ
set v(f0hmin) 50          ;# F0表示の縦サイズ(縮小時の最小縦幅)
set v(f0hbackup) 100      ;# F0表示の縦サイズのバックアップをとる
set f0(method) ESPS       ;# F0抽出アルゴリズム
set f0(frameLength) 0.01  ;# F0抽出間隔[sec]
set f0(windowLength) 0.01 ;# F0抽出の窓長[sec]
set f0(max) 800           ;# 想定される最高F0
set f0(min) 60            ;# 想定される最低F0
set f0(showMax) 400       ;# F0表示の範囲[Hz]
set f0(showMin) 200       ;# F0表示の範囲[Hz]
set f0(showMinTone)   [lindex $v(toneList) 0]    ;# F0表示の範囲
set f0(showMinOctave) $v(sinScaleMin)            ;# F0表示の範囲
set f0(showMaxTone)   [lindex $v(toneList) end]  ;# F0表示の範囲
set f0(showMaxOctave) $v(sinScaleMax)            ;# F0表示の範囲
set f0(guideTone)   C  ;# 音叉音
set f0(guideOctave) 3  ;# 音叉音
set f0(guideFreqTmp) 131 
set f0(f0) {}             ;# 抽出したF0系列
set v(f0color) blue       ;# F0曲線の色
set v(tgtf0color) red     ;# ターゲットF0の色
set f0(fixShowRange) 1    ;# 1=F0表示スケールを固定にする
set f0(unit) semitone     ;# F0表示スケール。semitone, Hz

set v(removeDC) 0         ;# 1=録音後DC成分を除去する
set v(showParam) 1        ;# 1=UTAUの原音パラメータを表示, 0=非表示

set v(cWidth) 500                          ;# 波形画面キャンバスの横幅
set v(cWidthMin) [expr $v(yaxisw) + 100]   ;# 波形画面キャンバスの横幅最小値
set v(cHeight) [expr $v(waveh) + $v(spech) + $v(powh) + $v(f0h) + $v(timeh)]
                                           ;# 波形画面キャンバスの縦幅
set v(winWidth) 640
set v(winWidthMax) [lindex [wm maxsize .] 0]
set v(winHeight) 0
set v(winWidthMin) 400
set v(winHeightMin) 100

set conState 0  ;# console がshowなら1、hideなら0であることをあらわす
set scrollWidget ""      ;# 現在マウスがリストボックスにあればそのパスを入れる

set v(sampleRate) 44100  ;# 音声のサンプリング周波数[Hz]
set v(paramChanged) 0    ;# 1=原音パラメータが未保存,0=保存済み
set v(sdirection) 1 ;# 検索する方向。1=下。0=上。
set v(sMatch)  full ;# 検索方法。full=完全一致、sub=部分一致
set v(keyword) ""   ;# 検索キーワード
set v(recComment) "" ;# コメント文

# スペクトル配色
set v(grey) " "
set v(color1) {#000 #004 #006 #00A #00F \
               #02F #04F #06F #08F #0AF #0CF #0FF #0FE \
               #0FC #0FA #0F8 #0F6 #0F4 #0F2 #0F0 #2F0 \
               #4F0 #6F0 #8F0 #AF0 #CF0 #FE0 #FC0 #FA0 \
               #F80 #F60 #F40 #F20 #F00}
set v(color2) {#FFF #BBF #77F #33F #00F #07F #0BF #0FF #0FB #0F7 \
               #0F0 #3F0 #7F0 #BF0 #FF0 #FB0 #F70 #F30 #F00}

;# oremo-init.tclに保存する配列のリスト
set startup(arrayForInitFile) {bgmParam v f0 power startup dev uttTiming genParam estimate keys}
;# oremo-init.tclに保存しないキーのリスト
set startup(exclusionKeysForInitFile,aName) { startup v power f0 estimate }
set startup(exclusionKeysForInitFile,startup) { \
  arrayForInitFile choosesaveDir \
  exclusionKeysForInitFile,aName \
  exclusionKeysForInitFile,startup \
  exclusionKeysForInitFile,v \
  exclusionKeysForInitFile,power \
  exclusionKeysForInitFile,f0 \
  exclusionKeysForInitFile,estimate \
  autoReadParamFile \
}
set startup(exclusionKeysForInitFile,v) { \
  paramChanged msg ext appname version sndLength \
  recList recLab recSeq typeList typeLab typeSeq listSeq \
  recStatus playStatus playOnsaStatus playMetroStatus
}
set startup(exclusionKeysForInitFile,power) { power fid }
set startup(exclusionKeysForInitFile,f0) { f0 extractedMin extractedMax fid }
set startup(exclusionKeysForInitFile,estimate) { }

set startup(readRecList) 1    ;# 1=起動時にreclist.txtを読む
set startup(readTypeList) 1   ;# 1=起動時にtypelist.txtを読む

set startup(textFiles)     [list $topdir/message/oremo-text.tcl $topdir/message/proc-text.tcl]

set v(tempo) 120     ;# メトロノームのテンポ(bpm)
set v(tempoMSec) [expr 60000.0 / $v(tempo)]  ;# メトロノームの1拍当りの秒数
set v(playMetroStatus) 0  ;# 1=現在メトロノーム再生中, 0=現在再生してない
set v(clickWav) "$topdir/guideBGM/click.wav" ;# メトロノームの音
set v(bgmFile) "$topdir/guideBGM/F4-100bpm.wav" ;# 自動録音用BGM
set v(bgmParamFile) "$topdir/guideBGM/F4-100bpm.txt" ;# 自動録音用BGM
set v(setE) 1   ;# 1=右ブランク値をファイル末尾からの相対値にする。-1=左blankからの相対値にする

array unset bgmParam
set bgmParam(autoRecStatus) 0

# 先行発声チェック用の設定
array unset uttTiming
set uttTiming(clickWav) "$topdir/guideBGM/click.wav"        ;# メトロノームの音
set uttTiming(tempo) 100                                    ;# チェック速度[BPM]
set uttTimingMSec(tempo) [expr 60000.0 / $uttTiming(tempo)] ;# チェック速度[msec]
set uttTiming(preCount) 3                 ;# 音声再生前にメトロノームを鳴らす回数
set uttTiming(mix) 0.5                    ;# メトロノームと音声の混合比率。

# 連続発声のパラメータ自動生成用の設定
array unset genParam
set genParam(bpm)  100
set genParam(bpmU) bpm
set genParam(S)    0
set genParam(SU)   msec
set genParam(O)    0
set genParam(OU)   msec
set genParam(P)    0
set genParam(PU)   msec
set genParam(C)    0
set genParam(CU)   msec
set genParam(E)    0
set genParam(EU)   msec
set genParam(autoAdjustRen) 1
set genParam(vLow)      5
set genParam(sRange) 300
set genParam(avePPrev) 0   ;# 一つ前の平均パワーを保存する
set genParam(autoAdjustRen2)    1
set genParam(autoAdjustRen2Opt) "-s1 200 -s2 10 -l 2048 -p 128 -m 30 -t 1.0 -d tools"
set genParam(autoAdjustRen2Pattern) "あ い う え お ん"

# 単独音のパラメータ自動推定用の設定
array unset estimate
set estimate(S)    1  ;# 1=パラメータ自動推定を行う
set estimate(E)    1  ;# 1=パラメータ自動推定を行う
set estimate(C)    1  ;# 1=パラメータ自動推定を行う
set estimate(P)    1  ;# 1=パラメータ自動推定を行う
set estimate(O)    1  ;# 1=パラメータ自動推定を行う
set estimate(minC) 0.001  ;# 子音部長の最小値(子音部=0でUTAUがエラーになるのを防ぐ)

array unset paDev
set paDev(devList) {none}     ;# PortAudioでの録音デバイス選択リスト
set paDev(devListMenu) ""     ;# PortAudioでの録音デバイス選択メニューウィジェット
set paDev(outdevList) {none}  ;# PortAudioでの再生デバイス選択リスト
set paDev(outdevListMenu) ""  ;# PortAudioでの再生デバイス選択メニューウィジェット
set paDev(recWav) "$topdir/tools/tmp.wav"    ;# oremo-recorderが出力するwavファイル
set paDev(useRequestRec)  0   ;# ラジオボタンで使う。1=PortAudio録音を使いたい(まだ使えるとは限らない)。
set paDev(useRequestPlay) 0   ;# ラジオボタンで使う。1=PortAudio再生を使いたい(まだ使えるとは限らない)。
set paDev(useRec)         0     ;# 1=PortAudio録音を使う。paDev(useRequestRec)=1で使用可能のときにのみ1にする
set paDev(usePlay)        0     ;# 1=PortAudio再生を使う。paDev(useRequestRec)=1で使用可能のときにのみ1にする
set paDev(sampleRate)   44100 ;# サンプリング周波数(Hz)
set paDev(sampleFormat) Int16 ;# 形式。Int16 Int24 Int32 Float32
set paDev(channel)      1     ;# チャンネル数
set paDev(bufferSize)   2048  ;# バッファサイズ
array unset paDevFp
set paDevFp(rec)  ""   ;# 録音ツールと会話するためのfid。""=起動していない。これをpaDev()の中に入れてはいけない(ioSettingsのパラメータバックアップで不具合が生じるため)
set paDevFp(play) ""   ;# 再生ツールと会話するためのfid。""=起動していない。これをpaDev()の中に入れてはいけない(ioSettingsのパラメータバックアップで不具合が生じるため)
set paDevFp(bgm)  ""   ;# 再生ツールと会話するためのfid。""=起動していない。これをpaDev()の中に入れてはいけない(ioSettingsのパラメータバックアップで不具合が生じるため)

# ショートカットキー
array unset keys
array unset keys_bk

snack::sound snd   -channels Mono -rate $v(sampleRate) -fileformat WAV -encoding Lin16
snack::sound onsa  -channels Mono -rate $v(sampleRate)
snack::sound metro -channels Mono -rate $v(sampleRate)
snack::sound bgm   -channels Mono -rate $v(sampleRate)
snack::sound uttTiming(clickSnd)  -channels Mono -rate $v(sampleRate)

