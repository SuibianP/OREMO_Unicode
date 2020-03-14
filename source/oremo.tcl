#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

#atode, 詳細設定の保存
#atode, 自動ノーマライズ→息.wavなど音が小さい雑音収録のときに耳が壊れるかも
#atode, 音名、タイプのリストをマルチカラムリストにする
#atode, 録音済みの音を色分けするとか
#atode, 録音済みのファイル数をカウントして表示（あと少し!と思えるかも??）

# - 音名リストでSHIFT+ホイールスクロールしてリストを短くする場合、
#   最小３行まで縮小できるようにした。

# 2.0-b091205
# - アイコンにD&Dしたときに自動でそのフォルダを保存フォルダにして起動する。

# 2.0-b090803
# - 音名、発声タイプリストボックスの横幅をctrl+wheelで変更可にした。
#   (ただし、現状では動作が若干よろしくない)

# 2.0-b090724
# - ガイドBGMの設定読み込み部分のバグ修正。

# 2.0-b090720
# - 自動収録モードを追加。
#   - オプション→収録方法の設定窓を作成。
#   - rキーで自動収録開始/停止するように変更。
#   - Rキーで自動収録終了のバインドを追加。
# - 「m」キーを押してもメトロノームの再生が止まらないのを訂正。

# 2.0-b090709
# - 収録関係をoremoに、原音パラメータ設定関係をsetParamに分離した
# - サブルーチンは proc.tcl に、大域変数はglobalVar.tclにまとめた
#   (exe化の際には:rで一ファイルに結合)
# - 「動作切替」メニューを削除した。
#   - オプション→録音機能で録音機能ON/OFF切り替え
#   - ファイル→保存フォルダのwavファイルから～ でreclist.txt生成
# - メトロノーム機能を追加。
# - setParamに原音パラメータ一覧を実装。数値入力、copy&pasteなど。
# - setParamから自動原音設定ツール(外部ツール、utau_lib_analyze110）を呼ぶようにした。
# - reclist.txtに「とぅ」「どぅ」を追加。
# - アイコン埋め込み。(exe化時にicoファイルを*.vfs/tclkit.icoにコピーする)
# - oremo.exe と同じフォルダに oremo-init.tclがあれば自動的に読み込む

# 2.0-b090613
# - 原音パラメータの読み込み/保存：上書き確認。ファイル名指定可にした
# - 原音パラメータを読み込んだら表示中の画面に即反映させるようにした
# - ファイルメニューの文を変更("oto.ini"→"原音パラメータ")

# 2.0-b090611
# - ファイルメニュー追加：音名リストの読み込み/保存、発声タイプの読み込み
# - 起動時にreclist.txt、typelist.txtが無い場合にダイアログを表示
# - コマンドラインからの起動時の第一引数で保存フォルダを指定
# - 波形再読み込み(cにキーバインド)

# 2.0-b090506
# oto.iniの読み込み

# 2.0-b090213
# - 音叉機能の機能向上(リピート再生、キーバインド割り当て)
# - 原音設定（手動設定(F1-F6にキーバインド)）
# - 原音設定（自動設定。左右ブランクのみ）
# - 原音設定（ファイル保存。oto.iniにパラメータを保存）
# - 動作モード切替（録音機能ON/OFF、原音設定機能ON/OFF）
# - 音名リスト取得（保存フォルダにあるwavファイルから音名リストを構成可能）
# - 画面構成変更（収録音がそこそこ長い文字列になっても表示可能に）
# - その他

package require -exact snack 2.2
#if {$::tcl_platform(platform) == "windows"} {
#  ttk::style theme use clam ;#xpnative
#}

# package require Tktable
# package require tkdnd

source -encoding utf-8 [file join [file dirname [info script]] proc-genParam.tcl] ;# oto.ini生成読み込み
source -encoding utf-8 [file join [file dirname [info script]] proc.tcl]          ;# サブルーチン読み込み
source -encoding utf-8 [file join [file dirname [info script]] globalVar.tcl]     ;# 大域変数読み込み

#---------------------------------------------------
# main - メインルーチン (初期化)

set v(appname) OREMO
set v(version) 3.0-b190106         ;# ソフトのバージョン番号
set startup(readTypeList) 1
set startup(readRecList) 1
set startup(readCommentList) 1
set startup(makeRecListFromDir) 0
set startup(choosesaveDir) 0
set startup(initFile)     $topdir/oremo-init.tcl
set startup(sysIniFile)   $topdir/oremo-setting.ini ;# フォルダ使用履歴などをシステムが保存するファイル

#---------------------------------------------------
# 引数チェック
# memo: oremo.tcl -- -option とするのが無難。--がないとwishのオプションと思われる様子
set i 0
while {$i < $argc} {
  set opt [lindex $argv $i]
  
  switch $opt {
    "-saveDir" {
      incr i
      set v(saveDir) [lindex $argv $i]
    }
    "-script" {
      incr i
      set startup(initFile) [lindex $argv $i]
    }
    default {
      ;# アイコンにD&Dされたときの対応
      set opt [encoding convertfrom $opt]  ;# tcl/tk内部コード(utf-8)にする
      set opt [file normalize $opt]
      if {[file isdirectory $opt]} {            ;# フォルダのD&D
        set v(saveDir) $opt
        set startup(choosesaveDir) 0
      } elseif {[file isdirectory [file dirname $opt]]} { ;# それ以外のファイル
        set v(saveDir) [file dirname $opt]
        set startup(choosesaveDir) 0
      } else {
        puts "error: invalid option: $opt"
        usage
      }
    }
  }
  incr i
}

# スタートアップを読む
if {[file exists $startup(initFile)]} {
  doReadInitFile $startup(initFile)
}

for {set i 0} {$i < [llength $startup(textFiles)]} {incr i} {
  while {[catch {source -encoding utf-8 [lindex $startup(textFiles) $i]}]} {
    lset startup(textFiles) $i [tk_getOpenFile -initialfile [lindex $startup(textFiles) $i] -defaultextension "tcl" -filetypes {{{language file} {.tcl}}}]
  }
}

audioSettings ;# オーディオデバイス関連の初期化
fontSetting   ;# 日本語フォントを設定する
if {$startup(readRecList)}        { readRecList $v(recListFile) }
if {$startup(readTypeList)}       { readTypeList $v(typeListFile) }
if {$startup(readCommentList)}    { readCommentList "$v(saveDir)/$v(appname)-comment.txt" }
if {$startup(choosesaveDir)}      { choosesaveDir }
if {$startup(makeRecListFromDir)} { makeRecListFromDir }
setSinScale   ;# 平均律の各音階の周波数を求める

#---------------------------------------------------
#
# メニューの設定
#

resetMenu

#---------------------------------------------------
#
# 窓の設定
#
snack::createIcons    ;# アイコンを使用する

set rseq 0

# 0. 収録中の音名を表示するフレーム
frame .recinfo
grid  .recinfo -row $rseq -columnspan 2 -sticky new

# 0-1. 収録中の音を表示するフレーム
frame .recinfo.showCurrent
grid  .recinfo.showCurrent -sticky nw
label .recinfo.showCurrent.lr -textvar v(recLab)  \
  -font bigkfont -fg black -bg white
label .recinfo.showCurrent.lt -textvar v(typeLab) \
  -font bigkfont -fg black -bg white
pack .recinfo.showCurrent.lr .recinfo.showCurrent.lt -side left \
  -fill x -expand 1 -anchor center

# コメントを表示するフレーム
incr rseq
frame .recComment
grid  .recComment -row $rseq -columnspan 2 -sticky new
entry .recComment.l -textvar v(recComment) -font commkfont -fg black -bg [. cget -bg]
button .recComment.b -textvariable t(.recComment.midashi) -command searchComment
pack  .recComment.l -side left -fill both -expand 1 -anchor center -ipady 0
pack  .recComment.b -side left                      -anchor center -ipady 0
bind .recComment.l <<EditComment>> {
  .recComment.l insert insert %A     ;# カーソル位置に入力文字を挿入
  break                              ;# 既存のバインドを無効にするためのbreak
}

# 1. 設定関係のフレーム
incr rseq
frame .s
grid  .s -row $rseq -column 0 -sticky nw

# 1-1. 音名のリストボックス
frame .s.listboxes
grid  .s.listboxes -sticky nw
set rec [listbox .s.listboxes.rec -listvar v(recList) -height 10 -width 5 \
  -bg $v(bg) -fg $v(fg) \
  -font kfont \
  -yscrollcommand {.s.listboxes.srec set} \
  -selectmode single -exportselection 0]
set srec [scrollbar .s.listboxes.srec -command {$rec yview}]
pack $rec $srec -side left -fill both -expand 1
$rec selection set $v(recSeq)

# 1-2. 発声タイプのリストボックス
set type [listbox .s.listboxes.type -listvar v(typeList) -height 10 -width 4 \
  -bg $v(bg) -fg $v(fg) \
  -font kfont \
  -yscrollcommand {.s.listboxes.stype set} \
  -selectmode single -exportselection 0]
set stype [scrollbar .s.listboxes.stype -command {$type yview}]
pack $type $stype -side left -fill both -expand 1
$type selection set $v(typeSeq)

# 2. 波形やスペクトルなどの図、保存フォルダなどを表示するフレーム
frame .fig
grid  .fig -row $rseq -column 1 -sticky nw

# 2-1. 波形などを表示するフレーム
update
set v(cWidth)  [expr {$v(winWidth) - [winfo width .s] - $v(yaxisw) - 8}]  ;# 4はキャンバス境界のマージン
set v(cHeight) [expr {$v(waveh) + $v(spech) + $v(powh) + $v(f0h) + $v(timeh)}]
set c [canvas .fig.c -width $v(cWidth) -height $v(cHeight) -bg $v(bg)]
set cYaxis [canvas .fig.cYaxis -width $v(yaxisw) -height $v(cHeight) \
  -bg $v(bg)]
grid $c      -row 0 -column 1 -sticky nw
grid $cYaxis -row 0 -column 0 -sticky nw

# 3. 収録中の音を保存するディレクトリを表示するフレーム
incr rseq
frame .saveDir
grid  .saveDir -row $rseq -columnspan 2 -sticky new
label .saveDir.midashi -textvariable t(.saveDir.midashi) -fg $v(fg) -bg $v(bg)
button .saveDir.dir -textvar v(saveDir)  \
  -fg $v(fg) -bg $v(bg) -relief solid \
  -command {
    choosesaveDir
    resetDisplay
  }
button .saveDir.sel -image snackOpen -highlightthickness 0 -bg $v(bg) \
  -command {
    choosesaveDir
    resetDisplay
  }
pack .saveDir.midashi -side left
pack .saveDir.dir -side left -fill x -expand 1
pack .saveDir.sel -side left

# 4. メッセージを表示するフレーム
incr rseq
frame .msg
grid  .msg -row $rseq -columnspan 2 -sticky new
pack [label .msg.msg -textvar v(msg) -relief sunken -anchor nw] -fill x

# 5. 詳細設定用などの窓
set swindow .settings
set cmwindow .changeMode
set epwindow .epwindow
set entpwindow .entpwindow
set genWindow .genParam
set prgWindow .progress
set searchWindow .search
set bindWindow .bindWindow
set fontWindow .fontWindow

# 6. audio I/O 設定用の窓
set ioswindow .iosettings

#---------------------------------------------------
#
# バインド
#
proc nextRec0  {} { nextRec  0 }
proc prevRec0  {} { prevRec  0 }
proc nextType0 {} { nextType 0 }
proc prevType0 {} { prevType 0 }
proc waveReload {} {readWavFile; Redraw all}

#---------------------------------------------------
# キーボードバインドをまとめたproc。
#
proc setDefaultKeyBind {} {
  global conState
  bind . <KeyPress-r>          recStart
  bind . <KeyPress-0>          recStart
  bind . <KeyPress-R>          autoRecStop
  bind . <KeyRelease-r>        recStop
  bind . <KeyRelease-0>        recStop
  bind . <KeyPress-2>          nextRec
  bind . <KeyPress-8>          prevRec
  bind . <KeyPress-6>          nextType
  bind . <KeyPress-4>          prevType
  bind . <Control-KeyPress-2>  nextRec0
  bind . <Control-KeyPress-8>  prevRec0
  bind . <Control-KeyPress-6>  nextType0
  bind . <Control-KeyPress-4>  prevType0
  bind . <space>               togglePlay
  #bind . <Control-space>       playFromStoE
  bind . <Control-p>           togglePlay
  #bind . <Control-Alt-p>       playFromStoE
  bind . <KeyPress-5>          togglePlay
  bind . <KeyPress-o>          toggleOnsaPlay
  bind . <KeyPress-O>          toggleOnsaPlay

  bind . <KeyPress-c>          waveReload  ;# 波形再読み込み
  bind . <KeyPress-m>          toggleMetroPlay
  bind . <KeyPress-M>          toggleMetroPlay

  bind . <KeyPress-F6>         nextRec
  bind . <KeyPress-F7>         prevRec
  bind . <Control-KeyPress-F6> nextRec0
  bind . <Control-KeyPress-F7> prevRec0

  bind . <Alt-F4>              Exit
   
  bind . <F11>                 waveShrink  ;# 縮小
  bind . <F12>                 waveExpand  ;# 拡大

  bind . <Control-f>           searchComment

  # コンソールの表示
  bind . <Control-Alt-d> {
    if {$conState} {
      console hide
      set conState 0
    } else {
      console show
      set conState 1
    }
  }

  # コメント欄ではデフォルトのバインド、その他では所定のバインドを設定する
  bind . <Down>                { if ![string equal .recComment.l %W] nextRec   }
  bind . <Up>                  { if ![string equal .recComment.l %W] prevRec   }
  bind . <Right>               { if ![string equal .recComment.l %W] nextType  }
  bind . <Left>                { if ![string equal .recComment.l %W] prevType  }
  bind . <Control-Down>        { if ![string equal .recComment.l %W] nextRec0  }
  bind . <Control-Up>          { if ![string equal .recComment.l %W] prevRec0  }
  bind . <Control-Right>       { if ![string equal .recComment.l %W] nextType0 }
  bind . <Control-Left>        { if ![string equal .recComment.l %W] prevType0 }
}
setDefaultKeyBind

# コメント欄ではバインドを無効にしたいので、無効にするイベントをEditCommentに登録する
event add <<EditComment>> <KeyPress-r> <KeyPress-0> <KeyPress-R>
event add <<EditComment>> <KeyPress-2> <KeyPress-4> <KeyPress-6> <KeyPress-8>
event add <<EditComment>> <Control-KeyPress-2> <Control-KeyPress-4> <Control-KeyPress-6> <Control-KeyPress-8>
event add <<EditComment>> <space> <KeyPress-5>
event add <<EditComment>> <KeyPress-o> <KeyPress-O> <KeyPress-c> <KeyPress-m> <KeyPress-M>

# atode マウスホイールを上下矢印に対応づける？

# リストボックスのマウス操作
bind $rec  <<ListboxSelect>> { jumpRec  [$rec  curselection] }
bind $type <<ListboxSelect>> { jumpType [$type curselection] }
#bind $rec  <Button-1> { jumpRec  [$rec  curselection] }
#bind $type <Button-1> { jumpType [$type curselection] }
bind $rec  <Control-1>       { jumpRec  [$rec  nearest %y] 0}
bind $type <Control-1>       { jumpType [$type nearest %y] 0}

# クリックしたところにフォーカスする(コメント欄などからクリックでフォーカスを外すため)
bind . <Button-1> {focus %W}

# リストボックスでのホイールスクロール
bind $rec <Enter>   {+set scrollWidget %W}
bind $rec <Leave>   {+set scrollWidget ""}
bind $srec <Enter>  {+set scrollWidget $rec}
bind $srec <Leave>  {+set scrollWidget ""}
bind $type <Enter>  {+set scrollWidget %W}
bind $type <Leave>  {+set scrollWidget ""}
bind $stype <Enter> {+set scrollWidget $type}
bind $stype <Leave> {+set scrollWidget ""}
bind . <MouseWheel> {listboxScroll $scrollWidget %D}

# koko, リストを選択後にctrl+wheelすると、リストの縦スクロールも
# 同時に効いてしまう。今のところ解決法が見つからない。
#
# 横方向拡大縮小 
bind . <Control-MouseWheel> {
  set x [expr %x + [winfo rootx %W] - [winfo rootx .]]
  set y [expr %y + [winfo rooty %W] - [winfo rooty .]]
  if {$y > [winfo y .s]} {
    if {$x > [winfo width .s]} {
      # 波形横方向拡大縮小 
      if {%D > 0} {
        changeWidth 0  ;# 縮小
      } else {
        changeWidth 1  ;# 拡大
      }
    } elseif {$x <= [winfo width $rec]} {
      # 音名リスト横方向拡大縮小 
      if {%D > 0} {
        changeRecListWidth 0  ;# 縮小
      } else {
        changeRecListWidth 1  ;# 拡大
      }
    } else {
      # 発声タイプリスト横方向拡大縮小 
      if {%D > 0} {
        changeTypeListWidth 0  ;# 縮小
      } else {
        changeTypeListWidth 1  ;# 拡大
      }
    }
  }
}
bind $rec <Control-MouseWheel> {
  if {%y > [expr [winfo height .recinfo] + [winfo height .recComment]]} {
    if {%x <= [winfo width $rec]} {
      if {%D > 0} {
        changeRecListWidth 0  ;# 縮小
      } else {
        changeRecListWidth 1  ;# 拡大
      }
    }
  }
}
bind $type <Control-MouseWheel> {
  if {%y > [expr [winfo height .recinfo] + [winfo height .recComment]]} {
    if {%x > [winfo width $rec] && %x <= [winfo width $type]} {
      if {%D > 0} {
        changeTypeListWidth 0  ;# 縮小
      } else {
        changeTypeListWidth 1  ;# 拡大
      }
    }
  }
}
proc waveShrink {} { changeWidth 0 }  ;# 縮小
proc waveExpand {} { changeWidth 1 }  ;# 拡大

# 波形拡大縮小(縦方向, Shift+マウスホイール)
bind . <Shift-MouseWheel> {
  if {"%W" == "."} {                              ;# フォーカスなし
    set mx %x
    set my [expr %y - [winfo height .recinfo] - [winfo height .recComment]]
  } elseif {[regexp {^\.recinfo} "%W"]} {         ;# 音名表示にフォーカス
    set mx %x
    set my [expr %y - [winfo height .recinfo] - [winfo height .recComment]]
  } elseif {[regexp {^\.recComment} "%W"]} {      ;# コメントにフォーカス
    set mx %x
    set my [expr %y - [winfo height .recComment]]
  } elseif {[regexp {^\.fig\.cYaxis} "%W"]} {     ;# 波形縦軸にフォーカス
    set mx [expr %x + [winfo width .s]]
    set my %y
  } elseif {[regexp {^\.fig\.c} "%W"]} {          ;# 波形ペインにフォーカス
    set mx [expr %x + [winfo width .s] + [winfo width $cYaxis]]
    set my %y
  } elseif {"%W" == ".s.listboxes.rec"} {         ;# 音名リストにフォーカス
    set mx %x
    set my %y
  } elseif {"%W" == ".s.listboxes.srec"} {        ;# 発声タイプリストのスクロールバーにフォーカス
    set mx [expr %x + [winfo width .s.listboxes.rec]]
    set my %y
  } elseif {"%W" == ".s.listboxes.type"} {        ;# 発声タイプリストにフォーカス
    set mx [expr %x + [winfo width .s.listboxes.rec] + [winfo width .s.listboxes.srec]]
    set my %y
  } elseif {[regexp {^\.s\.} "%W"]} {              ;# 発声タイプリストのスクロールバーなどにフォーカス
    set mx [expr %x + [winfo width .s.listboxes.rec] + [winfo width .s.listboxes.srec] + [winfo width .s.listboxes.type]]
    set my %y
  } elseif {[regexp {^\.saveDir} "%W"]} {         ;# 保存フォルダにフォーカス
    set mx %x
    set my [expr %y + [winfo height .fig]]
  } elseif {[regexp {^\.msg} "%W"]} {             ;# 保存フォルダにフォーカス
    set mx %x
    set my [expr %y + [winfo height .fig] + [winfo height .saveDir]]
  } else {
    return
  }
  if {$my < 0} return

  if {$mx > [winfo width .s]} {
    if {%D > 0} {
      set inc -20    ;# 上向き回転
    } else {
      set inc +20    ;# 下向き回転
    }
    if {$my <= $v(waveh)} {
      # 波形を拡大・縮小
      incr v(waveh) $inc
      if {$v(waveh) < $v(wavehmin)} {
        set v(waveh) $v(wavehmin)
      }
    } elseif {$my <= [expr $v(waveh) + $v(spech)]} {
      # スペクトルを拡大・縮小
      incr v(spech) $inc
      if {$v(spech) < $v(spechmin)} {
        set v(spech) $v(spechmin)
      }
    } elseif {$my <= [expr $v(waveh) + $v(spech) + $v(powh)]} {
      # パワーを拡大・縮小
      incr v(powh) $inc
      if {$v(powh) < $v(powhmin)} {
        set v(powh) $v(powhmin)       ;# 縮小の最小値
      }
    } elseif {$my <= [expr $v(waveh) + $v(spech) + $v(powh) + $v(f0h)]} {
      # F0を拡大・縮小
      incr v(f0h) $inc
      if {$v(f0h) < $v(f0hmin)} {
        set v(f0h) $v(f0hmin)       ;# 縮小の最小値
      }
    }
    Redraw scale
    set h [expr [winfo y .fig] + $v(waveh) + $v(spech) + $v(powh) + $v(f0h) + $v(timeh) \
      + [winfo height .saveDir] + [winfo height .msg] + 4]
    wm geometry . "$v(winWidth)x$h"
  } else {
#    # マウスが音名リストにある場合
#    set rech [$rec cget -height]
#    if {%D > 0} {
#      ;# 上向き回転
#      if {$rech > 3} { incr rech -1 }
#      $rec configure -height $rech
#      $type configure -height $rech
#    } else {
#      ;# 下向き回転
#      incr rech
#      $rec configure -height $rech
#      $type configure -height $rech
#    }
  }
  unset -nocomplain mx my
}

;# 右クリックメニュー
bind $c <Button-3> { PopUpMenu %X %Y %x %y }

;# バインドのカスタマイズを反映
doSetBind

#---------------------------------------------------
# 初期化
set f0(showMax) [tone2freq "$f0(showMaxTone)$f0(showMaxOctave)"]
set f0(showMin) [tone2freq "$f0(showMinTone)$f0(showMinOctave)"]
set f0(tgtFreq) [tone2freq "$f0(tgtTone)$f0(tgtOctave)"]
set f0(guideFreqTmp) [tone2freq "$f0(guideTone)$f0(guideOctave)"]
readSysIniFile
resetDisplay

wm protocol . WM_DELETE_WINDOW Exit
wm title . "$v(appname) $v(version)"
wm resizable . 1 1
update
set v(winWidthMin) [expr {[winfo x .fig] + $v(cWidthMin)}]
set v(winHeightMin) [expr {[winfo y .fig] + $v(wavehmin) + $v(timeh) \
  + ($v(spech) ? $v(spechmin) : 0) + ($v(powh)  ? $v(powhmin)  : 0) \
  + ($v(f0h)   ? $v(f0hmin)   : 0) + [winfo height .saveDir] + [winfo height .msg]} ]
wm minsize . $v(winWidthMin) $v(winHeightMin)

set v(winWidth) [winfo width  .]
set v(winHeight) [winfo height .]
after 1000 { bind . <Configure> {changeWindowBorder} }
