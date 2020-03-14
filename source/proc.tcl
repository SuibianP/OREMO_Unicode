#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

#portaudioの方、grep、viを。
#sampleRate
#波形の色

# 3.0-b190106
# - (追加) 音名リストA.txtを読み込むとき、もし同フォルダにコメントファイルA-comment.txtがあればそれを読み込むようにした。(readRecList)
# - (追加) ファイルメニューからコメントファイルを読めるようにした。その際setParamのコメントを取り込めるようにした。(isSetparamComment)
# - (追加) フォントサイズを変えられるようにした。設定変更は再起動後に有効になる。また、設定次第では音名一覧の縦幅が短くなるので、その時は窓サイズを少し変えると直る。(setFontSize)
# - (追加) 設定変更した内容をoremo-init.tclに自動保存し、次回起動時に自動復元するようにした。以前は手動保存(「ファイル」→「現在の設定を初期化ファイルに保存」)だった。自動保存しないようにするならoremo-setting.iniのautoSaveInitFile=1の値を0にする。(readSysIniFile, Exit)
# - (追加) 初期化ファイルoremo-init.tclに保存されるパラメータを増やした。(saveSettings)
# - (追加) 操作キーの割り当てをカスタマイズできるようにした。(setBind, doSetBind)
# - (修正) エラー発生時に適切なエラー窓が表示されない問題を修正した(3箇所)。(makeRecListFromUst, readRecList)

# 3.0-b160504
# - (修正) ヘルプメニューのURLを更新(freett→fc2、sourceforge→osdn)。
# - (修正) Tcl/Tkのライセンスファイルを修正(以前のバージョンではtclkit等のライセンスファイルでなくactivetclのライセンスファイルを同梱してしまっていた)。
# - (変更) Tcl/Tkのバージョンを8.5.4から8.6.4に変更した。
# - (変更) F0パネルをピアノロール表示にした。
# - (追加) ウィンドウ境界のドラッグで窓幅変更できるようにした。

# 3.0-b140323
# - (追加) NHPサイト閉鎖に伴い同サイトで配布されていた5モーラ連続音音名リストをOREMOに同梱した。ファイル名は「reclist-renzoku-NHP.txt」。
# - (変更) 連続音の音名リストのファイル名「reclist-renzoku.txt」を「reclist-renzoku-単独音を併用する必要有.txt」に変更した。
# - (追加) 英語版(魅亜さん英訳版ベース)を配布。
# - (追加) ヘルプから公式webページにアクセスできるようにした。
# - (変更) コメント検索ボタンウィジェットの文字列を翻訳可能にした。

# 3.0-b140113
# - (修正) 未収録音があるときにoto.ini生成を実行するとエラーが出る問題に対応した。
# - (修正) 各画面の拡大縮小(縦の拡大縮小=SHIFT+ホイールスクロール、横の拡大縮小=Ctrl+ホイールスクロール)が正しく動かないエラーに対応した。(前バージョンでコメント欄を追加したことによるエラー)
# - (修正) oto.ini生成のoto.ini保存ダイアログで、フォルダのデフォルトをwavのあるフォルダに一致させた。(estimateParam, genParam)
# - (修正) 収録直後にoto.ini生成した場合にエラーが出るケースに対処。(doEstimateParamでsWork readした後にset v(sndLength)するようにした)
# - (修正) ステレオ録音されたwavファイルのoto.ini自動生成に対応した。ただしUTAUはモノラル録音を想定していたはず。
# - (追加) oto.ini生成直前にwavを保存したかチェックするようにした。(checkWavForOREMO)
# - (変更) 単独音oto.ini生成用のprocがproc-genParam.tclとproc.tclの両方に入っていたので、proc-genParam.tclのみにした。(estimateParamなど)
# - (変更) 不要なメッセージデータやprocedureを削除した。

# 3.0-b131127
# - (修正) パワー曲線の描画処理を高速化した。(Redraw)
# - (修正) SHIFT+ホイール等で縦幅を変えたとき、音名リストの長さも変わるようにした。(resizeListbox)
# - (修正) マウス操作とキー操作で交互に音名変更した場合に、音を再生すると一つ前に選択したwavが表示・再生されるエラーを修正した。(nextRec、nextTypeなどにfocusやactivateを追加)
# - (追加) コメント機能(readCommentList, saveCommentListなど)
# - (変更) 詳細設定の「F0ターゲットに合わせて他のパラメータを変更」したときの最高F0、最低F0の計算方法を変更した。(autoF0Settings, setParam 2.0-b130303からの移植)
# - (変更) F0、パワーの表示方法を変更した。setParam 2.0-b130530からの移植。これによって目盛表示ずれやF0の小数表示に対応した。(f0Axis, powerAxisを削除してmyAxisを導入)

# 3.0-b120515
# - (追加) setParamのoto.ini生成機能を移植した。
# - (追加) PortAudioによる再生機能を追加した。
# - (追加) PortAudioによる録音機能を追加した。
#            追加proc：paRecRun、paRecTerminate、putsPa、getsPa、updateIoSettings
#            変更proc：recStart, aRecStart, aRecStop, recStop、ioSettings、setIODevice (他にもあったかも)
#
# - (追加) 波形表示の縦軸を固定化できるようにした。縮尺を変えたり以前の自動縮尺にする場合は
#          「詳細設定」の「縦軸最大値」を変更する。0にすると以前の自動縮尺になる。(settings, Redraw)
# - (追加) 再生時に位置を示すバーを表示させた。(showPlayBar)
# - (追加) ガイドBGMの設定ファイル作成ツールを付属した(guideBGM/korede.tcl)
# - (変更) デフォルトのガイドBGMをmp3からwavに変更した。(PortAudioだと現状wav再生しかできないので)。
# - (修正) 小声の場合のF0抽出精度を上げた（処理時間は増えた）。
# - (修正) 細かい修正。自動収録終了時に画面を再描画するようにした。
# - (修正) サンプリング周波数を変更したらsnd以外の変数も設定変更するようにした。onsa、metro、bgm、uttTiming(clickSnd) (settings)
# - (変更) exitをExitでラッピングした

# 2.0-b120308
# - (修正) 表示文の間違い(FFTの窓長の単位など)を修正した。
# - (追加) 詳細設定で、F0ターゲット値に合わせて他の設定値を自動設定するボタンを追加した(autoF0Settings)
# - (変更) F0最高値のデフォルト値を400から800に引き上げた

# 2.0-b110624
# - (追加) ustファイルから発声リストを作成できるようにした(makeRecListFromUst)
# - (削除) setParam用のサブルーチンを削除した
# - (修正) オーディオI/O設定窓でエラーが出る問題を修正した(ioSettings)
# - (追加) オーディオI/O設定窓下部に警告文を追加した。
# - (追加) ESCで各種設定窓を閉じるようにした(bgmGuide, pitchGuide, tempoGuide, ioSettings, settings)
# - (追加) 音叉窓最下部にショートカットキー一覧を表示した

# 2.0-b100509
# - (変更) 描画コードをsetParamで作ったものベースにした(Redraw)
# - (修正) オーディオデバイスの文字化け周りのバグ修正(setIODevice)

# 2.0-b100204
# - (追加) 波形の表示/非表示を切り替えられるようにした(toggleWaveなど)
# - (追加) 読み込み済みのパラメータに別の原音パラメータファイルをマージする(mergeParamFile)
# - (追加) 選択中の範囲の値を一括変更する機能(changeCell)
# - (追加) オーディオデバイスのレイテンシを変更する機能(ioSettings)
# - (修正) オーディオドライバ名の文字化けを若干解消(ioSettings)
# - (変更) 原音パラメータを読む際にwavが存在しないエントリは削除するようにした(readParamFile)

# 2.0-b091205
# - (追加) メイン窓にD&Dされたときの処理を追加(procDnd)
# - (追加) 発声タイミング補正切替を追加(timingAdjMode)
# - (修正) 細かいバグの修正。
# - (追加) プログレスバー表示
# - (追加) oto.ini読み込み高速化用のキャッシュ機能
# - (追加) F3やAlt-F3で他パラメータを連動してうごかせるようにした。
# - (追加) エイリアス一括変換機能を追加(changeAlias)
# - (修正) 連続音パラメータ生成直後にspaceで再生すると、表示中の波形でない波形が再生されるバグを修正。

# 2.0-b091120
# - (変更) 全メッセージを外部ファイル化。
# - (追加) wav両端の無音をカットする機能を追加 (cutWav)
# - (修正) パラメータ一覧表の数値を削除すると"0"と表示されるバグ?を修正。

# 2.0-b091104
# - (追加) 読み込み時にパラメータ生成(単独/連続音)を選択実行できるようにした。
# - (追加) 先行発声チェック用の試聴機能および設定窓を追加
# - (追加) 自動収録した連続音のパラメータ自動生成(genParam)
# - (変更) 初期化ファイル保存の保存対象を変更(saveSettings)
# - (修正) 行を複製する際にパラメータに空欄がある場合のコピーのバグを修正。

# 2.0-b091007
# - (修正) 以前作った左右ブランク自動推定を最新バージョンで動くように修正。

# 2.0-b090903
# - (追加) 左ブランク値を変更した際に、同wavファイルの他の音の左ブランク値も
#          連動して変更できるようにした。
# - (変更) 各種窓を開いたときにフォーカスするように変更。
# - (追加) パラメータ検索を実装。
# - (変更) パラメータ一覧表のタイトルが長すぎる場合は切り詰めるように変更。
# - (変更) マウス+F1～F5で各パラメータをドラッグ可能。
# - (修正) setParamでF0が表示されないバグの修正。
# - (修正) setParamでマウスドラッグによるセル複数選択ができないバグの修正。

# 2.0-b090822
# - (修正) setParamの一覧表タイトルのファイル名表示が更新されないバグを修正。
# - (修正) setParamの一覧表の値に挿入・削除したときカーソルが末尾に行くバグを修正。
# - (変更) 全パラメータをマイクロsec精度にした。
# - (追加) 右ブランクの負の値に対応。
# - (追加) オプションで右ブランクの正負を切り替えられるようにした。
# - (追加) オプションで左ブランクの変更時の他パラメータのふるまいを
#          切り替えられるようにした
# (2.0-b090813)
# - (変更) リストスクロールで２つ前後の音が見えるようにした。
# - (追加) 初期化ファイルを生成できるようにした。

# 2.0-b090803
# - (修正) readParamFile。oto.iniにエントリが足りない場合のバグを修正。
# -（追加) ツールメニューにDC成分一括除去を追加
# -（追加) ツールメニューにwavファイル名変更（冒頭に"_"を付ける)を追加
# - (追加) リストボックスの横幅をctrl+wheelで変更可能にした。

# 2.0-b090727
# - (変更) setParamで波形窓にエイリアスを表示。
# - (変更) 一覧表タイトルにファイル名を表示。
# - (変更) 一覧表の上下矢印移動で表の上端・下端でワープしないようにした。
# - (変更) ガイドBGM設定窓で、BGM試聴、録音イメージ音試聴ボタンを追加。
# - (変更) オーディオI/O設定窓に説明文を表示。
# - (修正) 自動録音(loop)で、音名リスト末尾までいったら終了するようにした。
# - (変更) Redrawの演算回数を少し削減。
# - (修正) makeRecListFromDirでのファイル名登録のバグを修正。

# 2.0-b090724
# - (修正) val2sampで実数値を返すことがあるバグを修正。

# 2.0-b090719
# - (修正) メトロノーム再生を停止できなかったバグを修正。

# 2.0-b090715
# - saveParamFile 高速化(paramUの内容を直接書き出すようにした)

# 2.0-b090706
# - oremo.tcl 本体のサブルーチン集を別ファイルに移行。

#---------------------------------------------------
# サブルーチン

proc detectEncoding {fp} {
  seek $fp 0
  fconfigure $fp -encoding shiftjis
  if {[read $fp 3] == "ïｻｿ"} {
    fconfigure $fp -encoding utf-8
    return "utf-8"
  } else {
    seek $fp 0
    return "shiftjis"
  }
}

#---------------------------------------------------
# メイン画面表示をリセットする？
#
proc resetDisplay {} {
  global v t rec type

  set v(recSeq)  0
  set v(typeSeq) 0
  set v(listSeq) 1
  set v(recLab)  [lindex $v(recList)  $v(recSeq)]
  set v(typeLab) [lindex $v(typeList) $v(typeSeq)]
  if {[array names v "recComment,$v(recLab)$v(typeLab)"] != ""} {
    set v(recComment) $v(recComment,$v(recLab)$v(typeLab))
  } else {
    set v(recComment) ""
  }
  $rec  selection clear 0 end
  $type selection clear 0 end
  $rec  selection set $v(recSeq)
  $type selection set $v(typeSeq)
  $rec  activate $v(recSeq)
  $type activate $v(typeSeq)
  readWavFile
  Redraw all
}

proc readLanguage {} {
  global t startup
  destroy .menubar .popmenu
  for {set i 0} {$i < [llength $startup(textFiles)]} {incr i} {
    lset startup(textFiles) $i [tk_getOpenFile -initialfile [lindex $startup(textFiles) $i] -defaultextension "tcl" -filetypes {{{language file} {.tcl}}} -title $t(setLanguage,opentitle)]
    while {[catch {source -encoding utf-8 [lindex $startup(textFiles) $i]}]} {
      lset startup(textFiles) $i [tk_getOpenFile -initialfile [lindex $startup(textFiles) $i] -defaultextension "tcl" -filetypes {{{language file} {.tcl}}} -title $t(setLanguage,opentitle)]
    }
  }
}

proc resetMenu {} {
  global t
  if {[array exists snack::menu]} {
    unset snack::menu
  }
  
  snack::menuInit
  
  snack::menuPane    $t(file)
  snack::menuCommand $t(file) $t(file,choosesaveDir) {
    choosesaveDir
    resetDisplay
  }
  snack::menuCommand $t(file) $t(file,readRecList)   {readRecList; resetDisplay}
  snack::menuCommand $t(file) $t(file,saveRecList)   saveRecList
  snack::menuCommand $t(file) $t(file,readTypeList)  {readTypeList; resetDisplay}
  snack::menuCommand $t(file) $t(file,readCommentList) readCommentList
  snack::menuCommand $t(file) $t(file,makeRecList)   {
    makeRecListFromDir
    resetDisplay
    set v(msg) $t(file,makeRecList,msg)
  }
  snack::menuCommand $t(file) $t(file,makeRecListFromUst)   {
    makeRecListFromUst
    resetDisplay
    set v(msg) $t(file,makeRecListFromUst,msg)
  }
  
  snack::menuCommand $t(file) $t(file,saveSettings) saveSettings
  snack::menuCommand $t(file) $t(file,Exit)         Exit
  
  snack::menuPane    $t(show)
  snack::menuCheck   $t(show)   $t(show,showWave)     v(showWave) toggleWave
  snack::menuCheck   $t(show)   $t(show,showSpec)     v(showSpec) toggleSpec
  snack::menuCheck   $t(show)   $t(show,showpow)      v(showpow)  togglePow
  snack::menuCheck   $t(show)   $t(show,showf0)       v(showf0)   toggleF0
  snack::menuCommand $t(show)   $t(show,pitchGuide)   pitchGuide
  snack::menuCommand $t(show)   $t(show,tempoGuide)   tempoGuide
  
  snack::menuPane    $t(option)
  snack::menuCheck   $t(option) $t(option,removeDC)   v(removeDC) {}
  snack::menuCommand $t(option) $t(option,bgmGuide)   bgmGuide
  snack::menuCommand $t(option) $t(option,ioSettings) ioSettings
  snack::menuCommand $t(option) $t(option,setBind)    setBind
  snack::menuCommand $t(option) $t(option,setFontSize) setFontSize
  snack::menuCommand $t(option) $t(option,settings)   settings
  snack::menuCommand $t(option) $t(option,setLanguage) {
    readLanguage
    resetMenu
  }
  
  snack::menuPane    $t(oto)
  snack::menuCascade $t(oto)     $t(oto,auto)
  snack::menuCommand $t(oto,auto) $t(oto,auto,tandoku) {
    checkWavForOREMO
    estimateParam
  }
  snack::menuCommand $t(oto,auto) $t(oto,auto,renzoku) {
    checkWavForOREMO
    genParam
  }
  
  snack::menuPane    $t(help)
  snack::menuCommand $t(help) $t(help,onlineHelp) {execExternal http://nwp8861.web.fc2.com/soft/oremo/manual/tutorial.html}
  snack::menuCommand $t(help) $t(help,Version)    Version
  snack::menuCommand $t(help) $t(help,official1) {execExternal http://nwp8861.web.fc2.com/soft/oremo/}
  snack::menuCommand $t(help) $t(help,official2) {execExternal http://osdn.jp/users/nwp8861/pf/OREMO/files/}
  set rclickMenu  [menu .popmenu   -tearoff false]
}



#---------------------------------------------------
# 保存フォルダにあるwavファイルを読み、リストに記憶する
#
proc makeRecListFromDir {{readParam 0} {overWriteRecList 1}} {
  global v t

  set recList {}
  foreach filename [glob -nocomplain [format "%s/*.%s" $v(saveDir) $v(ext)]] {
    set filename [file rootname [file tail $filename]]
    if {$filename == ""} continue
    ;# フォルダおよび拡張子を取り除いたファイル名をリストに格納
    ;# 音名と発声タイプは分けない
    lappend recList $filename
  }
  if $overWriteRecList {
    set v(recList) $recList
    set v(typeList) {""}
  }
  initParamS
  initParamU 0 $recList

  if {$readParam != 0} {
    set act [tk_dialog .confm $t(.confm) \
      $t(makeRecListFromDir,q) question 0 \
      $t(.confm.r) \
      $t(.confm.nr) \
      $t(makeRecListFromDir,a) \
    ]
    set v(paramFile) "$v(saveDir)/oto.ini"
    switch $act {
      0 {readParamFile}
      2 {genParamWizard}
    }
  }
}


#---------------------------------------------------
# reclist.txtを保存する
#
proc saveRecList {} {
  global v t

  set fn [tk_getSaveFile -initialfile $v(recListFile) \
            -title $t(saveRecList,title) -defaultextension "txt" ]
  if {$fn == ""} return

  set v(recListFile) $fn
  if [catch {open $v(recListFile) w} out] { 
    tk_messageBox -message [eval format $t(saveRecList,errMsg)] \
      -title $t(.confm.fioErr) -icon warning
  } else { 
    fconfigure $out -encoding binary
    puts -nonewline $out \xef\xbb\xbf
    fconfigure $out -encoding utf-8
    foreach sn $v(recList) {
      if [catch {set data [puts $out $sn]}] {
        tk_messageBox -message [eval format $t(saveRecList,errMsg2)] \
          -title $t(.confm.fioErr) -icon warning
      }
    }
    close $out
  }
  set v(msg) [eval format $t(saveRecList,doneMsg)]
}

#---------------------------------------------------
# コメントを保存する
#
proc saveCommentList {} {
  global v t

  if {[file exists $v(saveDir)] == 0} return

  set v(recComment,$v(recLab)$v(typeLab)) $v(recComment)  ;# 現在のコメントを保存

  if [catch {open "$v(saveDir)/$v(appname)-comment.txt" w} out] { 
    tk_messageBox -message [eval format $t(saveCommentList,errMsg)] \
      -title $t(.confm.fioErr) -icon warning
  } else { 
    fconfigure $out -encoding binary
    puts -nonewline $out \xef\xbb\xbf
    fconfigure $out -encoding utf-8
    set wrote 0
    foreach sn $v(recList) {
      foreach tn $v(typeList) {
        if {[array names v "recComment,$sn$tn"] == ""} continue
        if {[regexp {^[[:space:]]*$} $v(recComment,$sn$tn)]} continue

        if [catch {set data [puts $out "$sn$tn\t$v(recComment,$sn$tn)"]}] {
          tk_messageBox -message [eval format $t(saveCommentList,errMsg)] \
            -title $t(.confm.fioErr) -icon warning
        }
        set wrote 1
      }
    }
    close $out

    if {!$wrote} {
      file delete "$v(saveDir)/$v(appname)-comment.txt"    ;# コメントが全くなかったら削除
    }
  }
}

proc setFontSize {} {
  global v fontWindow t

  if [isExist $fontWindow] return ;# 二重起動を防止
  toplevel $fontWindow
  wm title $fontWindow $t(option,setFontSize)
  bind $fontWindow <Escape> {destroy $fontWindow}

  label $fontWindow.la   -text $t(fontWindow,attention)
  label $fontWindow.la2  -text $t(fontWindow,attention2)
  label $fontWindow.lbfs -text $t(fontWindow,lbfs)
  label $fontWindow.lfs  -text $t(fontWindow,lfs)
  label $fontWindow.lcfs -text $t(fontWindow,lcfs)
  tk_optionMenu $fontWindow.bfs v(bigFontSize)  8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50
  tk_optionMenu $fontWindow.fs v(fontSize)      8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50
  tk_optionMenu $fontWindow.cfs v(commFontSize) 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50

  grid $fontWindow.la   -row 0 -column 0 -sticky w -columnspan 2
  grid $fontWindow.la2  -row 1 -column 0 -sticky w -columnspan 2
  grid $fontWindow.lbfs -row 2 -column 0 -sticky e
  grid $fontWindow.bfs  -row 2 -column 1 -sticky w
  grid $fontWindow.lfs  -row 3 -column 0 -sticky e
  grid $fontWindow.fs   -row 3 -column 1 -sticky w
  grid $fontWindow.lcfs -row 4 -column 0 -sticky e
  grid $fontWindow.cfs  -row 4 -column 1 -sticky w
}

#---------------------------------------------------
# キー操作のカスタマイズ
#
proc setBind {} {
  global v bindWindow t keys keys_bk

  set bindFuncList [list record recStop nextRec prevRec nextType prevType nextRec0 prevRec0 nextType0 prevType0 togglePlay toggleOnsaPlay toggleMetroPlay searchComment waveReload waveExpand waveShrink ]

  if [isExist $bindWindow] return ;# 二重起動を防止
  toplevel $bindWindow
  wm title $bindWindow $t(option,setBind)
  wm protocol $bindWindow WM_DELETE_WINDOW {
    array set keys   [array get keys_bk]     ;# パラメータを以前の状態に戻す
    destroy $bindWindow
  }
  bind $bindWindow <Escape> {
    array set keys   [array get keys_bk]     ;# パラメータを以前の状態に戻す
    destroy $bindWindow
  }

  array set keys_bk   [array get keys]       ;# パラメータバックアップ

  set f [frame $bindWindow.f]
  pack $f

  ;# ショートカット設定
  set r 0
  foreach func $bindFuncList {
    label $f.l$r -text $t(bindWindow,$func) -pady 3
    entry $f.e$r -textvar keys($func) -wi 30
    grid $f.l$r -row $r -column 0 -sticky e
    grid $f.e$r -row $r -column 1 -sticky w
    incr r
  }

  ;# 注釈
  set fex [frame $bindWindow.fex]
  label $fex.lex  -text $t(bindWindow,ex)  -fg red -anchor nw
  label $fex.lex2 -text $t(bindWindow,ex2) -fg red -anchor nw
  label $fex.lex3 -text $t(bindWindow,ex3) -fg red -anchor nw
  grid $fex.lex  -row 0 -sticky w
  grid $fex.lex2 -row 1 -sticky w
  grid $fex.lex3 -row 2 -sticky w
  pack $fex -anchor w

  ;# 決定ボタン
  set fb [frame $bindWindow.fb]
  button $fb.ok -text $t(.confm.ok) -wi 8 -command {
    set ret [doSetBind]
    if {$ret == 0} {
      array set keys_bk   [array get keys]     ;# パラメータバックアップ
      destroy $bindWindow
    } else {
      raise $bindWindow
      focus $bindWindow
    }
  }
  button $fb.ap -text $t(.confm.apply) -wi 8 -command {
    set ret [doSetBind]
    if {$ret == 0} {
      array set keys_bk   [array get keys]     ;# パラメータバックアップ
    }
    raise $bindWindow
    focus $bindWindow
  }
  button $fb.cn -text $t(.confm.c) -wi 8 -command {
    array set keys   [array get keys_bk]       ;# パラメータを以前の状態に戻す
    destroy $bindWindow
  }
  pack $fb.ok $fb.ap $fb.cn -side left
  pack $fb -anchor w
}

#---------------------------------------------------
# キー操作のカスタマイズ。問題が無ければ0を返す
#
proc doSetBind {} {
  global v t keys keys_bk

  set kList [array get keys]
  set newBindList {}
  foreach {func value} $kList {
    if {[regexp {^[[:space:]]*$} $value]} continue  ;# 空行は飛ばす
    set data [split [string trim $value] "-"]       ;# Ctrl-cなどを$modKey$keyに分離する
    set last [expr [llength $data] - 1]
    ;# 修飾キーmodKeyを求める
    set modKey ""
    for {set i 0} {$i < $last} {incr i} {
      set str [lindex $data $i]
      if {! [regexp -nocase -- {^(Ctrl|Control|Alt|Shift)$} $str]} {
        tk_messageBox -title $t(bindWindow,errTitle) -icon warning \
          -message [eval format $t(bindWindow,errMsg)]
        return 1
      }
      regsub {Ctrl} $str "Control" str
      set modKey "$modKey$str-"
    }
    ;# キーkeyを求める
    set key [lindex $data $last]
    if {! [regexp -nocase -- {^(space|F[0-9]+|[a-zA-Z0-9]|[+*/;:@!#$%&=~?_<>,.])$} $key]} {
      tk_messageBox -title $t(bindWindow,errTitle) -icon warning \
        -message [eval format $t(bindWindow,errMsg)]
      return 1
      break
    }
    set kp [format "%sKeyPress"   $modKey]
    lappend newBindList "$kp-$key" $func
  }
  ;# エラーが無ければバインドする
  if {[llength $newBindList] > 0} {
    foreach {shortcut func} $newBindList {
      ;# 録音ショートカットについての特別対応
      if {$func == "record"} {
        regsub {KeyPress} $shortcut "KeyRelease" shortcut2
        bind . <$shortcut>  recStart
        bind . <$shortcut2> recStop
        event add <<EditComment>> <$shortcut> 
        event add <<EditComment>> <$shortcut2> 
        continue
      }
      #bind . <KeyPress-$value> [eval format "{if {! \[ string equal .recComment.l %%W]} %s}" $func]
      bind . <$shortcut> $func
      event add <<EditComment>> <$shortcut> 
    }
  }
  return 0
}

#---------------------------------------------------
# 一覧表の検索窓
#
proc searchComment {} {
  global v searchWindow t

  ;# 二重起動を防止
  if [winfo exists $searchWindow] {
    raise $searchWindow.f.e
    focus $searchWindow.f.e
    return
  }
  toplevel $searchWindow
  wm title $searchWindow $t(searchComment,title)
  bind $searchWindow <Escape> "destroy $searchWindow"

  set f [frame $searchWindow.f]
  entry  $f.e  -textvar v(keyword) -wi 30
  button $f.bs -text $t(searchComment,search) -command {doSearchParam $v(sdirection)}
  button $f.bc -text $t(.confm.c) -command {destroy $searchWindow}
  set f2 [labelframe $searchWindow.f2 -relief groove]
  radiobutton $f2.rup   -variable v(sdirection) -value 0 \
    -text $t(searchComment,rup)
  radiobutton $f2.rdown -variable v(sdirection) -value 1 \
    -text $t(searchComment,rdown)
  set f3 [labelframe $searchWindow.f3 -relief groove]
  radiobutton $f3.rMatch1 -variable v(sMatch) -value full \
    -text $t(searchComment,rMatch1)
  radiobutton $f3.rMatch2 -variable v(sMatch) -value sub \
    -text $t(searchComment,rMatch2)
  pack $f.e $f.bs $f.bc        -side left -anchor nw
  pack $f2.rup $f2.rdown       -side top  -anchor nw
  pack $f3.rMatch1 $f3.rMatch2 -side top  -anchor ne
  pack $f -anchor nw
  pack $f2 $f3 -anchor nw -side left

  bind $searchWindow <Return> {doSearchParam $v(sdirection)}
  raise $f.e
  focus $f.e
}

#---------------------------------------------------
# 一覧表の検索
#
proc doSearchParam {{direction 1}} {
  if $direction {
    doSearchParamNext
  } else {
    doSearchParamPrev
  }
}

#---------------------------------------------------
# 一覧表の検索(先頭方向)
#
proc doSearchParamPrev {} {
  global v searchWindow t

  ;# 探索開始値を求める
  if {$v(typeSeq) > 0} {
    set rStart $v(recSeq)
    set ts [expr $v(typeSeq) - 1]
  } else {
    set rStart [expr $v(recSeq) - 1]
    set ts [expr [llength $v(typeList)] - 1]
  }

  ;# 現在地の前から先頭までを検索
  for {set rs $rStart} {$rs >= 0} {incr rs -1} {
    set rLab [lindex $v(recList) $rs]
    while {$ts >= 0} {
      set tLab [lindex $v(typeList) $ts]
      if {[array names v "recComment,$rLab$tLab"] != ""} {
        if {$v(sMatch) == "full" && $v(keyword) == $v(recComment,$rLab$tLab) || \
            $v(sMatch) == "sub"  && [string first $v(keyword) $v(recComment,$rLab$tLab)] >= 0} {
          jumpRec $rs
          jumpType $ts
          return
        }
      } else {
        if {$v(sMatch) == "full" && $v(keyword) == "$rLab$tLab" || \
            $v(sMatch) == "sub"  && [string first $v(keyword) "$rLab$tLab"] >= 0} {
          jumpRec $rs
          jumpType $ts
          return
        }
      }
      incr ts -1
    }
    set ts [expr [llength $v(typeList)] - 1]
  }
  ;# 末尾から現在地までを検索
  for {set rs [expr [llength $v(recList)] - 1]} {$rs >= $v(recSeq)} {incr rs -1} {
    set rLab [lindex $v(recList) $rs]
    for {set ts [expr [llength $v(typeList)] - 1]} {$ts >= 0} {incr ts -1} {
      set tLab [lindex $v(typeList) $ts]
      if {[array names v "recComment,$rLab$tLab"] != ""} {
        if {$v(sMatch) == "full" && $v(keyword) == $v(recComment,$rLab$tLab) || \
            $v(sMatch) == "sub"  && [string first $v(keyword) $v(recComment,$rLab$tLab)] >= 0} {
          jumpRec $rs
          jumpType $ts
          return
        }
      } else {
        if {$v(sMatch) == "full" && $v(keyword) == "$rLab$tLab" || \
            $v(sMatch) == "sub"  && [string first $v(keyword) "$rLab$tLab"] >= 0} {
          jumpRec $rs
          jumpType $ts
          return
        }
      }
    }
  }
  ;# 見つからなかった場合
  tk_messageBox -title $t(searchComment,doneTitle) -icon warning \
      -message [eval format $t(searchComment,doneMsg)]
  if [winfo exists $searchWindow] {
    focus $searchWindow.f.e
  } else {
    focus .entpwindow.t
  }
}

#---------------------------------------------------
# 一覧表の検索(末尾方向)
#
proc doSearchParamNext {} {
  global v searchWindow t

  ;# 探索開始値を求める
  if {$v(typeSeq) < [expr [llength $v(typeList)] - 1]} {
    set rStart $v(recSeq)
    set ts [expr $v(typeSeq) + 1]
  } else {
    set rStart [expr $v(recSeq) + 1]
    set ts 0
  }

  ;# 現在地の後から末尾までを検索
  for {set rs $rStart} {$rs < [llength $v(recList)]} {incr rs} {
    set rLab [lindex $v(recList) $rs]
    while {$ts < [llength $v(typeList)]} {
      set tLab [lindex $v(typeList) $ts]
      if {[array names v "recComment,$rLab$tLab"] != ""} {
        if {$v(sMatch) == "full" && $v(keyword) == $v(recComment,$rLab$tLab) || \
            $v(sMatch) == "sub"  && [string first $v(keyword) $v(recComment,$rLab$tLab)] >= 0} {
          jumpRec $rs
          jumpType $ts
          return
        }
      } else {
        if {$v(sMatch) == "full" && $v(keyword) == "$rLab$tLab" || \
            $v(sMatch) == "sub"  && [string first $v(keyword) "$rLab$tLab"] >= 0} {
          jumpRec $rs
          jumpType $ts
          return
        }
      }
      incr ts
    }
    set ts 0
  }
  ;# 先頭から現在地までを検索
  for {set rs 0} {$rs <= $v(recSeq)} {incr rs} {
    set rLab [lindex $v(recList) $rs]
    for {set ts 0} {$ts < [llength $v(typeList)]} {incr ts} {
      set tLab [lindex $v(typeList) $ts]
      if {[array names v "recComment,$rLab$tLab"] != ""} {
        if {$v(sMatch) == "full" && $v(keyword) == $v(recComment,$rLab$tLab) || \
            $v(sMatch) == "sub"  && [string first $v(keyword) $v(recComment,$rLab$tLab)] >= 0} {
          jumpRec $rs
          jumpType $ts
          return
        }
      } else {
        if {$v(sMatch) == "full" && $v(keyword) == "$rLab$tLab" || \
            $v(sMatch) == "sub"  && [string first $v(keyword) "$rLab$tLab"] >= 0} {
          jumpRec $rs
          jumpType $ts
          return
        }
      }
    }
  }
  ;# 見つからなかった場合
  tk_messageBox -title $t(searchComment,doneTitle) -icon warning \
      -message [eval format $t(searchComment,doneMsg)]
  if [winfo exists $searchWindow] {
    focus $searchWindow.f.e
  } else {
    focus .entpwindow.t
  }
}

#---------------------------------------------------
# USTファイルからリストを生成する
#
proc makeRecListFromUst {args} {
  global v t

  if {[llength $args] == 0 || ! [file exists $v(recListFile)]} {
    set fn [tk_getOpenFile -initialfile $v(recListFile) \
            -title $t(makeRecListFromUst,title1) -defaultextension "ust" \
            -filetypes { {{reclist file} {.ust}} {{All Files} {*}} }]
  } else {
    set fn [lindex $args 0]
  }
  if {$fn == ""} return
  set v(recListFile) [file rootname $fn].txt

  if [catch {open $fn r} in] { 
    tk_messageBox -message [eval format $t(makeRecListFromUst,errMsg)] \
      -title $t(.confm.fioErr) -icon warning
  } else { 
    fconfigure $in -encoding shiftjis
    set v(recList) {}
    while {![eof $in]} {
      set data [split [gets $in] "="]
      if {[llength $data] > 1} {
        set item [lindex $data 0]       ;# 項目名
        set val  [lindex $data 1]       ;# データ内容
        if {$item == "Lyric"} {
          ;# 重複がなければリストに追加
          if {[lsearch -exact $v(recList) $val] < 0} {
            lappend v(recList) $val
          }
        }
      }
    }
    close $in
  }
  set v(recSeq) 0
  set v(recLab) [lindex $v(recList) $v(recSeq)]
  if {[array names v "recComment,$v(recLab)$v(typeLab)"] != ""} {
    set v(recComment) $v(recComment,$v(recLab)$v(typeLab))
  } else {
    set v(recComment) ""
  }
  set v(msg) [eval format $t(makeRecListFromUst,doneMsg)]
  set v(typeList) {""}
}

#---------------------------------------------------
# oremo-settings.iniファイルを読む
#
proc readSysIniFile {} {
  global v startup

  if [catch {open $startup(sysIniFile) r} fp] {
    return
  }
  fconfigure $fp -encoding utf-8
  while {![eof $fp]} {
    set l [gets $fp]
    if {[regexp {^autoSaveInitFile=(.+)$} $l dummy bool]} {      ;# $topdir/oremo-init.tclを自動保存するかどうか
      set v(autoSaveInitFile) $bool
    }
  }
  close $fp
}

#---------------------------------------------------
# コメントリストファイルを読み、配列に記憶する
#
proc readCommentList {{fname ""}} {
  global v t

  array unset v "recComment,*"  ;# コメントを初期化する。これはコメントファイルが無くても初期化する(保存フォルダを変更したときに以前のコメントを確実に消すため)。

  if {$fname == ""} {
    set fname [tk_getOpenFile \
            -title $t(file,readCommentList) -defaultextension "txt" \
            -filetypes { {{txt file} {.txt}} {{All Files} {*}} }]
    if {$fname == ""} return
  }

  if {! [file exists $fname]} return

  set v(recComment) ""

  if [catch {open $fname r} in] { 
    tk_messageBox -message [eval format $t(readCommentList,errMsg)] \
      -title $t(.confm.fioErr) -icon warning
    return
  }

  detectEncoding $in

  if [catch {set data [read $in]}] {
    tk_messageBox -message [eval format $t(readCommentList,errMsg)] \
      -title $t(.confm.fioErr) -icon warning
  }
  close $in

  # setParam形式コメントファイルについての処理
  set commNum 0
  set ignoreNum 0
  set setParamKeyList [isSetparamComment $fname [llength [split $data "\n"]]]
  if {[llength $setParamKeyList] > 0} {
    set commList [split $data "\n"]
    for {set i 0} {$i < [llength $commList]} {incr i} {
      set key  [lindex $setParamKeyList $i]
      set comm [lindex $commList $i]
      if {$key != "" && $comm != ""} {
        if {[array names v "recComment,$key"] != ""} {
          incr ignoreNum
        }
        set v(recComment,$key) $comm
        incr commNum
      }
    }
  } else {
    # OREMO形式コメントファイルについての処理
    foreach line [split $data "\n"] {
      incr i
      if {$line != "" && ![regexp {^ *#} $line]} {
        set key ""
        set comm ""
        regsub {^[[:space:]]+} $line "" line
        regexp {^([^[:space:]:]+)[[:space:]:](.+)$} $line dummy key comm
        if {$key != "" && $comm != ""} {
          if {[array names v "recComment,$key"] != ""} {
            incr ignoreNum
          }
          set v(recComment,$key) $comm
          incr commNum
        }
      }
    }
  }

  if {[array names v "recComment,$v(recLab)$v(typeLab)"] != ""} {
    set v(recComment) $v(recComment,$v(recLab)$v(typeLab))
  }
  if {$ignoreNum > 0} {
    set v(msg) [eval format $t(readCommentList,doneMsg2)]
  } else {
    set v(msg) [eval format $t(readCommentList,doneMsg)]
  }
}

#---------------------------------------------------
# setParam形式のようであれば読み込むか確認し、読み込む。
# 読み込んだ場合はリストを返し、そうでない場合は空リストを返す
#
proc isSetparamComment {fname lineNum} {
  global v t

  regsub -nocase -- {\-comment.txt$} $fname ".ini" iniFile

  # iniファイルを開ける？
  if [catch {open $iniFile r} in] {  return {} }

  detectEncoding $in

  # iniファイルの行数はコメントファイルの行数と一緒？
  if [catch {set iniData [read $in]}] {
    close $in
    return {}
  }
  close $in
  set iniLineNum [llength [split $iniData "\n"]]
  if {$lineNum != $iniLineNum} { return {} }

  # setParam形式のコメントファイルとして読み込むか尋ねる
  set iniFile [file tail $iniFile]
  set act [tk_dialog .confm $t(.confm) [eval format $t(isSetparamComment,q)] \
    question 1 $t(.confm.r) $t(.confm.nr)]
  if {$act != 0} { return {} }

  #
  # setParam形式コメントファイルとして読み込む
  #
  # iniファイルのデータから各コメントに対応する音名を取り出す
  set keyList {}
  foreach line [split $iniData "\n"] {
    set p [split $line "=,"]
    if {[llength $p] == 7} {
      set wavFile [lindex $p 0]
      set key [string range $wavFile 0 [expr [string first ".$v(ext)" $wavFile] - 1]]
      lappend keyList $key
    } else {
      lappend keyList ""
    }
  }
  return $keyList
 
}

#---------------------------------------------------
# 音名リストファイルを読み、リストに記憶する
#
proc readRecList {args} {
  global v t

  if {[llength $args] == 0 || ! [file exists $v(recListFile)]} {
    set fn [tk_getOpenFile -initialfile $v(recListFile) \
            -title $t(readRecList,title1) -defaultextension "txt" \
            -filetypes { {{reclist file} {.txt}} {{All Files} {*}} }]
  } else {
    set fn [lindex $args 0]
  }
  if {$fn == ""} return
  set v(recListFile) $fn

  if [catch {open $v(recListFile) r} in] { 
    tk_messageBox -message [eval format $t(readRecList,errMsg)] \
      -title $t(.confm.fioErr) -icon warning
  } else { 
    detectEncoding $in
    if [catch {set data [read -nonewline $in]}] {
      tk_messageBox -message [eval format $t(readRecList,errMsg2)] \
        -title $t(.confm.fioErr) -icon warning
    }
    regsub -all {[[:space:]]} $data " " data
    set v(recList) {}
    foreach line [split $data " "] {
      if {$line != ""} {
        lappend v(recList) $line
      }
    }
    close $in

    # 音名リストフォルダにコメントファイルがあった場合の処理
    if {[regsub -nocase -- {\.txt$} $v(recListFile) "-comment.txt" commentFile] > 0} {
      set saveDirCommentFile "$v(saveDir)/$v(appname)-comment.txt"
      if {[file exists $commentFile]} {
        if {! [file exists $saveDirCommentFile]} {
          readCommentList $commentFile
        } else {
          set act [tk_dialog .confm $t(.confm) $t(readRecList,overwrite) \
            question 1 $t(.confm.r) $t(.confm.nr)]
          if {$act == 0} {
            readCommentList $commentFile
          }
        }
      }
    }
  }
  set v(recSeq) 0
  set v(recLab) [lindex $v(recList) $v(recSeq)]
  if {[array names v "recComment,$v(recLab)$v(typeLab)"] != ""} {
    set v(recComment) $v(recComment,$v(recLab)$v(typeLab))
  } else {
    set v(recComment) ""
  }
  set v(msg) [eval format $t(readRecList,doneMsg)]
  #initParamU
}

#---------------------------------------------------
# 発声タイプのリストファイルを読み、リストに記憶する
# リストの最初の要素は "" を入れておく
#
proc readTypeList {args} {
  global v t

  if {[llength $args] == 0 || ! [file exists $v(typeListFile)]} {
    set fn [tk_getOpenFile -initialfile $v(typeListFile) \
            -title $t(readTypeList,title) -defaultextension "txt" \
            -filetypes { {{typelist file} {.txt}} {{All Files} {*}} }]
  } else {
    set fn [lindex $args 0]
  }
  if {$fn == ""} return
  set v(typeListFile) $fn

  set v(typeList) {""}
  if [catch {open $v(typeListFile) r} in] { 
    tk_messageBox -message [eval format $t(readTypeList,errMsg) \
      -title $t(.confm.fioErr) -icon warning
  } else { 
    detectEncoding $in
    if [catch {set data [read -nonewline $in]}] {
      tk_messageBox -message [eval format $t(readTypeList,errMsg2) \
        -title $t(.confm.fioErr) -icon warning
    } else {
      regsub -all {[[:space:]]} $data " " data
      foreach line [split $data " "] {
        if {$line != ""} {
          lappend v(typeList) $line
        }
      }
    }
    close $in
  }
  set v(typeSeq) 0
  set v(typeLab) [lindex $v(typeList) $v(typeSeq)]
  if {[array names v "recComment,$v(recLab)$v(typeLab)"] != ""} {
    set v(recComment) $v(recComment,$v(recLab)$v(typeLab))
  } else {
    set v(recComment) ""
  }
  set v(msg) [eval format $t(readTypeList,doneMsg)]
  #initParamU
}

#---------------------------------------------------
# 日本語フォントを設定する
#
proc fontSetting {} {
  global v t

  switch $::tcl_platform(platform) {
    unix {
      font create bigkfont   -family mincho -size $v(bigFontSize)   -weight normal -slant roman
      font create kfont      -family mincho -size $v(fontSize)      -weight normal -slant roman
      font create smallkfont -family mincho -size $v(smallFontSize) -weight normal -slant roman
      font create commkfont  -family mincho -size $v(commFontSize)  -weight normal -slant roman
    }
    windows {
      font create bigkfont   -family $t(fontName) -size $v(bigFontSize)   -weight normal -slant roman
      font create kfont      -family $t(fontName) -size $v(fontSize)      -weight normal -slant roman
      font create smallkfont -family $t(fontName) -size $v(smallFontSize) -weight normal -slant roman
      font create commkfont  -family $t(fontName) -size $v(commFontSize)  -weight normal -slant roman
    }
  }
}

#---------------------------------------------------
# 外部コマンドやファイル、URLを実行する
#
proc execExternal {url} {
    global v t

    if {$::tcl_platform(platform) == "windows"} {
        if {[string match $::tcl_platform(os) "Windows NT"]} {
            exec $::env(COMSPEC) /c start "" $url &
        } {
            exec start $url &
        }
    } else {
        # atode, ここはせめてfirefoxにしないと。。
        if [catch {exec sh -c "netscape -remote 'openURL($url)' -raise"} res] {
            if [string match *netscape* $res] {
                exec sh -c "netscape $url" &
            }
        }
    }
}

#---------------------------------------------------
# 保存ディレクトリを指定する
# 変更したら1、キャンセルしたら0を返す
#
proc choosesaveDir {{readParam 0}} {
  global v t

  set d [tk_chooseDirectory -initialdir $v(saveDir) -title $t(choosesaveDir,title)]
  if {$d != ""} {
    saveCommentList      ;# 現在のコメントを保存
    set v(saveDir) $d
    readCommentList "$v(saveDir)/$v(appname)-comment.txt"     ;# コメントを読み込み
    set v(msg) [eval format $t(choosesaveDir,doneMsg)]

    #if {$readParam != 0} {
    #  set act [tk_dialog .confm $t(.confm) $t(choosesaveDir,q) \
    #    question 0 $t(.confm.r) $t(.confm.nr)]
    #  set v(paramFile) "$v(saveDir)/oto.ini"
    #  if {$act == 0} readParamFile
    #}
    resetDisplay
    return 1  ;# 変更あり
  }
  return 0    ;# 変更なし
}

#---------------------------------------------------
# 未保存であれば波形をファイルに保存する
#
proc saveWavFile {} {
  global v snd t

  if $v(recStatus) {
    if {[snd length] > 0} {
      if {[file exists $v(saveDir)] == 0} {
        file mkdir $v(saveDir)
      }
      snd write $v(saveDir)/$v(recLab)$v(typeLab).wav 
      set v(msg) [eval format $t(saveWavFile,doneMsg)]
      set v(recStatus) 0
    }
  }
}

#---------------------------------------------------
# ファイルから波形を読む
#
proc readWavFile {} {
  global v snd paDev t

  if {$paDev(usePlay)} {
    playStopPa              ;# 再生中だった場合は停止させる
  }
  snd flush
  set fn $v(saveDir)/$v(recLab)$v(typeLab).wav
  if {[file readable $fn]} {
    snd read $fn
    if {$paDev(usePlay)} {
      putsPa play "wav $fn"
      set ret [getsPa play]
    }
  }
}

#---------------------------------------------------
# 平均律の各音階の周波数を求める
#
proc setSinScale {} {
  global v t
  set v(sinScale) {}
  set v(sinNote) {}
  for {set oct $v(sinScaleMin)} {$oct <= $v(sinScaleMax)} {incr oct} {
    for {set i 0} {$i < 12} {incr i} {
      lappend v(sinScale) [expr int(27.5 * pow(2, $oct + ($i - 9.0)/12.0) + 0.5)]
      lappend v(sinNote) "[lindex $v(toneList) $i]$oct"
    }
  }
}

#---------------------------------------------------
# F0計算中にキーボード、マウス入力を制限させるための窓
# うまく窓を表示できていないが、F0計算中の入力を制限できるので
# とりあえずOK(F0計算中に入力すると落ちることがあるため)
#
proc waitWindow {message fraction} {
  global t
  set w .waitw
  if {$fraction >= 1.0 && [winfo exists $w]} {
    grab release $w
    destroy $w
    return
  }
  if [winfo exists $w] return

  toplevel $w
  grab set $w
  wm title $w $t(waitWindow,title)
  label $w.l -text "calc.."
  pack $w.l
  wm transient $w .
  wm geom $w +100+100
}

#---------------------------------------------------
#
proc changeTone {chg} {
  global f0 v t
  
  set next [expr [lsearch $v(toneList) $f0(guideTone)] + $chg]

  if {$next < 0} {
    if {$f0(guideOctave) > $v(sinScaleMin)} {
      set next [expr ($next + [llength $v(toneList)])]
      incr f0(guideOctave) -1
    } else {
      set next [lsearch $v(toneList) $f0(guideTone)]
    }
  } elseif {$next >= [llength $v(toneList)]} {
    if {$f0(guideOctave) < $v(sinScaleMax)} {
      set next [expr $next % [llength $v(toneList)]]
      incr f0(guideOctave)
    } else {
      set next [lsearch $v(toneList) $f0(guideTone)]
    }
  }

  set f0(guideTone) [lindex $v(toneList) $next]
  if {$v(playOnsaStatus)} {  ;# もしループ再生中だったなら、
    toggleOnsaPlay           ;# 停止して、
    toggleOnsaPlay           ;# もう一度再生。
  }
}

#---------------------------------------------------
# 収録BGMの窓
#
proc bgmGuide {} {
  global v bgm t
  if [isExist .bgmg] return ;# 二重起動を防止
  toplevel .bgmg
  wm title .bgmg $t(bgmGuide,title)
  bind .bgmg <Escape> {destroy .bgmg}

  label .bgmg.lMode -text $t(bgmGuide,mode)
  radiobutton .bgmg.r1 -variable v(rec) -value 1 -command {bgm stop} \
    -text $t(bgmGuide,r1)
  radiobutton .bgmg.r2 -variable v(rec) -value 2 -command {bgm stop} \
    -text $t(bgmGuide,r2)
  radiobutton .bgmg.r3 -variable v(rec) -value 3 -command {bgm stop} \
    -text $t(bgmGuide,r3)
  radiobutton .bgmg.r4 -variable v(rec) -value 0 -command {bgm stop} \
    -text $t(bgmGuide,r4)

  label .bgmg.lWav -text $t(bgmGuide,bgm)
  frame .bgmg.fWav
  button .bgmg.fWav.b1 -textvar v(bgmFile) -relief solid -command {
    set fn [tk_getOpenFile -initialfile $v(bgmFile) \
            -title $t(bgmGuide,bTitle) -defaultextension "wav" \
            -filetypes { {{wav file} {.wav}} {{All Files} {*}} }]
    if {$fn != ""} {
      set v(bgmFile) $fn
      bgm stop
;#      set v(playMetroStatus) 0
    }
  }
  button .bgmg.fWav.b2 -image snackOpen -highlightthickness 0 -bg $v(bg) -command {
    set fn [tk_getOpenFile -initialfile $v(bgmFile) \
            -title $t(bgmGuide,bTitle) -defaultextension "wav" \
            -filetypes { {{wav file} {.wav}} {{All Files} {*}} }]
    if {$fn != ""} {
      set v(bgmFile) $fn
      bgm stop
;#      set v(playMetroStatus) 0
    }
  }
  button .bgmg.fWav.bp -text $t(bgmGuide,play) -bitmap snackPlay -command {
    testPlayBGM $v(bgmFile)
  }
  button .bgmg.fWav.bs -text $t(bgmGuide,stop) -bitmap snackStop -command {
    testStopBGM 
  }
  pack .bgmg.fWav.b1 -side left -fill x -expand 1
  pack .bgmg.fWav.b2 .bgmg.fWav.bp .bgmg.fWav.bs -side left

  frame .bgmg.fImg
  label .bgmg.fImg.l -text $t(bgmGuide,tplay)
  button .bgmg.fImg.bp -text $t(bgmGuide,play) -bitmap snackPlay -command {
    set ext [file extension $v(bgmFile)]
    testPlayBGM [file rootname $v(bgmFile)]-sample$ext
  }
  button .bgmg.fImg.bs -text $t(bgmGuide,stop) -bitmap snackStop -command {
    testStopBGM 
  }
  pack .bgmg.fImg.l .bgmg.fImg.bp .bgmg.fImg.bs -side left

  grid .bgmg.lMode   -row 0 -column 0 -sticky e
  grid .bgmg.r1      -row 0 -column 1 -sticky w
  grid .bgmg.r2      -row 1 -column 1 -sticky w
  grid .bgmg.r3      -row 2 -column 1 -sticky w
  grid .bgmg.r4      -row 3 -column 1 -sticky w

  grid .bgmg.lWav    -row 4 -column 0 -sticky e
  grid .bgmg.fWav    -row 4 -column 1 -sticky ewsn

  grid .bgmg.fImg    -row 5 -column 1 -sticky ewsn
}

#---------------------------------------------------
# 指定したファイルを読み込んで再生する
#
proc testPlayBGM {fname} {
  global bgm paDev t
  if ![file exists $fname] {
    tk_messageBox -message "[eval format $t(testPlayBGM,errMsg)] (fname=$fname)" \
      -title $t(testPlayBGM,errTitle) -icon warning -parent .bgmg
    return
  }
  ;# snack向け再生
  if {!$paDev(usePlay)} {
    if [snack::audio active] return
    bgm read $fname
    bgm play
  } else {
  ;# PortAudio向け再生
    putsPa bgm "wav $fname"
    set ret [getsPa bgm]
    if {[regexp {^Success} $ret]} {
      putsPa bgm "play"
      getsPa bgm
    }
  }
}

#---------------------------------------------------
# BGMを停止する
#
proc testStopBGM {} {
  global bgm paDev t
  ;# snack向け停止
  if {!$paDev(usePlay)} {
    bgm stop
  } else {
  ;# PortAudio向け再生/停止
    putsPa bgm "stop"
    getsPa bgm
  }
}


#---------------------------------------------------
# メトロノームの窓
#
proc tempoGuide {} {
  global v metro t
  if [isExist .tg] return ;# 二重起動を防止
  toplevel .tg
  wm title .tg $t(tempoGuide,title)

  bind .tg <KeyPress-m>     toggleMetroPlay
  bind .tg <KeyPress-M>     toggleMetroPlay
  bind .tg <Escape>         {destroy .tg}

  label .tg.lwav -text $t(tempoGuide,click)
  button .tg.bwav -textvar v(clickWav) -relief solid -command {
    set fn [tk_getOpenFile -initialfile $v(clickWav) \
            -title $t(tempoGuide,clickTitle) -defaultextension "wav" \
            -filetypes { {{wav file} {.wav}} {{All Files} {*}} }]
    if {$fn != ""} {
      set v(clickWav) $fn
      metro stop
      set v(playMetroStatus) 0
    }
  }

  label .tg.l -text $t(tempoGuide,tempo)
  entry .tg.ebpm -textvar v(tempo) -validate key -validatecommand {
          if {![string is integer %P]} {return 0}
          if {%P <= 0} {return 0}
          set v(tempoMSec) [expr 60000.0 / double(%P)]
          metro stop
          set v(playMetroStatus) 0
          return 1
        }
  label .tg.lbpm -text $t(tempoGuide,bpm)
  label .tg.lbpmSec1 -textvar v(tempoMSec) -fg red
  label .tg.lbpmSec2 -text $t(tempoGuide,bpmUnit)
  label .tg.mes -text $t(tempoGuide,comment)

  grid .tg.lwav -row 0 -column 0 -sticky e
  grid .tg.bwav -row 0 -column 1 -columnspan 4 -sticky nesw

  grid .tg.l        -row 1 -column 0 -sticky e
  grid .tg.ebpm     -row 1 -column 1 -sticky nesw
  grid .tg.lbpm     -row 1 -column 2 -sticky w
  grid .tg.lbpmSec1 -row 1 -column 3 -sticky e
  grid .tg.lbpmSec2 -row 1 -column 4 -sticky w

  grid .tg.mes -row 2 -columnspan 5
}

#---------------------------------------------------
# 周波数を指定してsin波を再生する
#
proc pitchGuide {} {
  global v f0 t
  if [isExist .pg] return ;# 二重起動を防止
  toplevel .pg
  wm title .pg $t(pitchGuide,title)

  bind .pg <KeyPress-Up>    {changeTone 1}
  bind .pg <KeyPress-8>     {changeTone 1}
  bind .pg <KeyPress-Down>  {changeTone -1}
  bind .pg <KeyPress-2>     {changeTone -1}
  bind .pg <KeyPress-Left>  {changeTone -12}
  bind .pg <KeyPress-4>     {changeTone -12}
  bind .pg <KeyPress-Right> {changeTone 12}
  bind .pg <KeyPress-6>     {changeTone 12}
  bind .pg <KeyPress-o>     toggleOnsaPlay
  bind .pg <KeyPress-O>     toggleOnsaPlay
  bind .pg <Escape>         {destroy .pg}

  packToneList .pg.tl $t(pitchGuide,sel) guideTone guideOctave guideFreqTmp 10 guideVol

  pack [frame .pg.vl] -fill x
  label .pg.vl.l -text $t(pitchGuide,vol)
  scale .pg.vl.s -from 0 -to 32768 -show no -var f0(guideVol) -orient horiz
  pack .pg.vl.l -side left -anchor nw
  pack .pg.vl.s -side left -anchor nw -fill x -expand 1
  label .pg.mes -text $t(pitchGuide,comment)
  pack .pg.mes -side left -anchor nw

  ;# 各音名に対応する周波数を自動計算して表示する(非常に汚いやり方)
  ;# 音名orオクターブに変化があれば周波数計算を行う
  ;# 周波数をf0(guideFreq)でなくf0(guideFreqTmp)に入れるのは、
  ;#「OK」or「適用」ボタンを押すまで値変更を反映させないため。
  set f0(guideFreqTmp) [tone2freq "$f0(guideTone)$f0(guideOctave)"]
  trace variable f0 w calcGuideFreq
  proc calcGuideFreq {var elm mode} {
    global f0 t
    switch $elm {
      "guideTone" -
      "guideOctave" {
        set f0(guideFreqTmp) [tone2freq "$f0(guideTone)$f0(guideOctave)"]
      }
    }
  }
  bind .pg <Destroy> { trace vdelete f0 w calcGuideFreq }
}

#---------------------------------------------------
# 指定した周波数[Hz]のsin波を再生する
#
proc playSin {freq vol length} {
  global v onsa t
  #if [snack::audio active] return
  if $::debug {puts $freq}
  if {$freq > 10 && $vol > 0} { 
#    set f [snack::filter generator $freq $vol 0.0 sine $v(sampleRate)]
    set g  [snack::filter generator $freq $vol 0.01 triangle $length]
    set f1 [snack::filter formant 500 50]
    set f2 [snack::filter formant 1500 75]
    set f3 [snack::filter formant 2500 100]
    set f4 [snack::filter formant 3500 150]
    set f  [snack::filter compose $g $f1 $f2 $f3 $f4]
    onsa play -filter $f -command "$f destroy" 
  }
}

#---------------------------------------------------
# 前の音の収録に移動
#
proc prevRec {{save 1}} { 
  global v rec t

  set tmp [expr $v(recSeq) - 2]
  if {$tmp >= 0} {
    $rec see $tmp
  }
  if {$v(recSeq) > 0} {
    set seq [expr $v(recSeq) - 1]
  } else {
    set seq [expr [llength $v(recList)] - 1]
    $rec see $seq
  }
  jumpRec $seq $save
  if $::debug {puts "prevRec: 前の音へ, recseq=$v(recSeq), v(recLab)=$v(recLab)"}
}

#---------------------------------------------------
# 次の音の収録に移動
#
proc nextRec {{save 1}} { 
  global v rec t

  set tmp [expr $v(recSeq) + 2]
  if {$tmp < [llength $v(recList)]} {
    $rec see $tmp
  }
  jumpRec [expr ($v(recSeq) + 1) % [llength $v(recList)]] $save
  if $::debug { puts "nextRec: 次の音へ, recseq=$v(recSeq), v(recLab)=$v(recLab)" }
}

#---------------------------------------------------
# 指定した番号の音の収録に移動
#
proc jumpRec {index {save 1}} { 
  global v rec t

  if {$v(recSeq) == $index} return
  set v(msg) ""
  if $save { saveWavFile }
  focus $rec
  $rec selection clear $v(recSeq)
  set v(recSeq) $index
  $rec see $v(recSeq)
  $rec selection set $v(recSeq)
  $rec activate $v(recSeq)
  set v(recComment,$v(recLab)$v(typeLab)) $v(recComment)  ;# 現在のコメントを保存
  set v(recLab) [lindex $v(recList) $v(recSeq)] 
  if {[array names v "recComment,$v(recLab)$v(typeLab)"] != ""} {
    set v(recComment) $v(recComment,$v(recLab)$v(typeLab))
  } else {
    set v(recComment) ""
  }
  set v(recStatus) 0
  readWavFile
  Redraw all
  if $::debug { puts "jumpRec: 次の音へ, recseq=$v(recSeq), v(recLab)=$v(recLab)" }
}

#---------------------------------------------------
# 前の発話タイプの収録に移動
#
proc prevType {{save 1}} { 
  global v type t

  if {$v(typeSeq) > 0} {
    set seq [expr $v(typeSeq) - 1]
  } else {
    set seq [expr [llength $v(typeList)] - 1]
  }
  jumpType $seq $save
  if $::debug { puts "prevType: 前のタイプへ, typeseq=$v(typeSeq), v(typeLab)=$v(typeLab)" }
}

#---------------------------------------------------
# 次の発話タイプの収録に移動
#
proc nextType {{save 1}} { 
  global v type t

  jumpType [expr ($v(typeSeq) + 1) % [llength $v(typeList)]] $save
  if $::debug { puts "nextType: 次のタイプへ, typeseq=$v(typeSeq), v(typeLab)=$v(typeLab)" }
}

#---------------------------------------------------
# 指定した番号の発声タイプの収録に移動
#
proc jumpType {index {save 1}} { 
  global v type t

  if {$v(typeSeq) == $index} return
  set v(msg) ""
  if $save { saveWavFile }
  focus $type
  $type selection clear $v(typeSeq)
  set v(typeSeq) $index
  $type see $v(typeSeq)
  $type selection set $v(typeSeq)
  $type activate $v(typeSeq)
  set v(recComment,$v(recLab)$v(typeLab)) $v(recComment)  ;# 現在のコメントを保存
  set v(typeLab) [lindex $v(typeList) $v(typeSeq)] 
  if {[array names v "recComment,$v(recLab)$v(typeLab)"] != ""} {
    set v(recComment) $v(recComment,$v(recLab)$v(typeLab))
  } else {
    set v(recComment) ""
  }
  set v(recStatus) 0
  readWavFile
  Redraw all
  if $::debug { puts "jumpType: 次の音へ, typeseq=$v(typeSeq), v(typeLab)=$v(typeLab)" }
}

#---------------------------------------------------
# DC成分除去
#
proc removeDC {} {
  global snd t
  set flt [snack::filter iir -numerator "0.99 -0.99" -denominator "1 -0.99"] 
  snd filter $flt -continuedrain 0
}

#---------------------------------------------------
# 波形を横方向に拡大縮小(ctrl+マウスホイール)
# mode=1...拡大, mode=0...縮小
#
proc changeWidth {mode} {
  global v t
  if $mode {
    incr v(cWidth) +40
  } elseif {$v(cWidth) <= $v(cWidthMin)} {
    set v(cWidth) $v(cWidthMin)
  } else {
    incr v(cWidth) -40
  }
  Redraw scale
  set v(skipChangeWindowBorder) 1   ;# 一時的にchangeWindowBorderを無効化する
  update                            ;# リストボックスの幅を更新する
  set v(skipChangeWindowBorder) 0   ;# changeWindowBorderを有効化する
  set w [expr [winfo x .fig] + [winfo width .fig]]
  wm geometry . [format "%dx%d" $w $v(winHeight)]
  changeWindowBorder
}

#---------------------------------------------------
# 音名リストボックスを横方向に拡大縮小(ctrl+マウスホイール)
# mode=1...拡大, mode=0...縮小
#
proc changeRecListWidth {mode} {
  global rec srec type stype t v
  set width [$rec cget -width]
  if $mode {
    $rec configure -width [expr $width +1]   ;# 拡大
  } elseif {$width > 5} {
    $rec configure -width [expr $width -1]   ;# 縮小
  }
  ;# リストボックスの幅変更を反映させる
  ;# リストボックス幅変更とchangeWindowBorderの相性が悪いので一時的に無効化する(泥臭いが)
  set v(skipChangeWindowBorder) 1   ;# 一時的にchangeWindowBorderを無効化する
  update                            ;# リストボックスの幅を更新する
  set v(skipChangeWindowBorder) 0   ;# changeWindowBorderを有効化する
  set w [expr [winfo x .fig] + [winfo width .fig]]
  wm geometry . [format "%dx%d" $w $v(winHeight)]
  changeWindowBorder
  set v(winWidthMin) [expr [winfo x .fig] + $v(cWidthMin)]
  wm minsize . $v(winWidthMin) $v(winHeightMin)
}

#---------------------------------------------------
# 発声タイプリストボックスを横方向に拡大縮小(ctrl+マウスホイール)
# mode=1...拡大, mode=0...縮小
#
proc changeTypeListWidth {mode} {
  global rec srec type stype t v
  set width [$type cget -width]
  if $mode {
    $type configure -width [expr $width +1]   ;# 拡大
  } elseif {$width > 5} {
    $type configure -width [expr $width -1]   ;# 縮小
  }
  ;# リストボックスの幅変更を反映させる
  ;# リストボックス幅変更とchangeWindowBorderの相性が悪いので一時的に無効化する(泥臭いが)
  set v(skipChangeWindowBorder) 1   ;# 一時的にchangeWindowBorderを無効化する
  update                            ;# リストボックスの幅を更新する
  set v(skipChangeWindowBorder) 0   ;# changeWindowBorderを有効化する
  set w [expr [winfo x .fig] + [winfo width .fig]]
  wm geometry . [format "%dx%d" $w $v(winHeight)]
  changeWindowBorder
  set v(winWidthMin) [expr [winfo x .fig] + $v(cWidthMin)]
  wm minsize . $v(winWidthMin) $v(winHeightMin)
}

#---------------------------------------------------
# 自動録音開始(BGMつき)
#
proc autoRecStart {} {
  global bgm bgmParam paDev snd v t

  if [snack::audio active] return
  if {$v(rec) == 0} return   ;# 収録モードでないなら終了

  ;# BGMファイルを読み込む
  if ![file exists $v(bgmFile)] {
    tk_messageBox -title $t(.confm.fioErr) -icon error -message [eval format $t(autoRecStart,errMsg)]
    return
  }
  bgm read $v(bgmFile)

  ;# BGM設定ファイルを読み込む
  set v(bgmParamFile) [file rootname $v(bgmFile)].txt
  if [catch {open $v(bgmParamFile) r} fp] {
    tk_messageBox -title $t(.confm.fioErr) -icon error -message [eval format $t(autoRecStart,errMsg2)]
    return
  }

  detectEncoding $fp

  set unit [regsub -all -- {,} [string trim [gets $fp]] ""]   ;# 時刻単位を取得
  if ![regexp {^(sec|SEC|msec|MSEC|sample)$} $unit] {
    tk_messageBox -message "[eval format $t(autoRecStart,errMsg3)] ($t(autoRecStart,unit)=$unit)" -icon warning
    return
  }
  array unset bgmParam
  set bgmParam(autoRecStatus) 0  ;# 以下の解析中にエラーが生じた場合は0でreturn
  set sr [bgm cget -rate]
  while {![eof $fp]} {
    set l [gets $fp]
    if {[regexp {^[[:space:]]*#} $l]} continue
    set p [split $l ","] ;# 行,時刻,録音開始,録音停止,次の収録音へ移動,リピート先
    if {[llength $p] >= 6} {
      set seq [string trim [lindex $p 0]]
      set bgmParam($seq,pStart)  [val2samp [string trim [lindex $p 1]] $unit $sr]
      set bgmParam($seq,rStart)  [string trim [lindex $p 2]]
      set bgmParam($seq,rStop)   [string trim [lindex $p 3]]
      set bgmParam($seq,nextRec) [string trim [lindex $p 4]]
      set bgmParam($seq,repeat)  [string trim [lindex $p 5]]
      if {[llength $p] >= 7} {
        set bgmParam($seq,msg)   [string trim [lindex $p 6]]
      } else {
        set bgmParam($seq,msg)   ""
      }
      set bgmParam($seq,repeat)  [string trim [lindex $p 5]]
      if {$seq > 1} {
        set seqOld [expr $seq - 1]
        if {$bgmParam($seqOld,repeat) != 0} {
          set bgmParam($seqOld,pStop) $bgmParam($seqOld,pStart)
        } else {
          set bgmParam($seqOld,pStop) [expr $bgmParam($seq,pStart) - 1]
        }
      }
    }
  }
  close $fp
  if {$bgmParam($seq,repeat) != 0} {
    set bgmParam($seq,pStop) $bgmParam($seq,pStart)
  } else {
    ;# スパゲティな設定ファイルの場合、このエラーチェックをすりぬける可能性がある
    tk_messageBox -message [eval format $t(autoRecStart,errMsg4)] -icon error
    return
    ;# set bgmParam($seq,pStop) [bgm length]  ;# BGM末尾
  }

  ;# afterコマンドを実行する間隔を求める
  for {set i 1} {$i <= $seq} {incr i} {
    set bgmParam($i,after) [expr int(($bgmParam($i,pStop) - $bgmParam($i,pStart)) \
                                      * 1000.0 / $sr + 0.5)]
  }

  ;# PortAudio用にガイドBGMを読み込む
  if {$paDev(usePlay)} {
    putsPa bgm "wav $v(bgmFile)"
    set ret [getsPa bgm]
    if {![regexp {^Success} $ret]} {
      tk_messageBox -message "$t(aRecStart,errPa)\n$ret" -title $t(.confm.errTitle) -icon warning
      return
    }
  } else {
    ;# 録音形式を指定する
    snd configure -channels Mono -rate $v(sampleRate) -fileformat WAV -encoding Lin16
  }

  set bgmParam(autoRecStatus) 1
  set v(recStatus) 1
  .msg.msg configure -fg blue
  autoRec 1 ;# BGM再生・録音開始
}

#---------------------------------------------------
# 自動録音開始(ガイドBGMを再生,録音開始/停止。再帰的に呼ばれる)
#
proc autoRec {seq} {
  global bgm bgmParam paDev v t
  if {! $bgmParam(autoRecStatus)} return
  set com ""
  if {$bgmParam($seq,repeat) != 0} {
    if {$v(rec) == 3} {
      set com "autoRec $bgmParam($seq,repeat)"  ;#リピート
    } else {
      autoRecStop                               ;#リピートせず終了
      return
    }
  } else {
    set com "autoRec [expr $seq + 1]"
  }
  if {$bgmParam($seq,rStart)  != 0} {
    .msg.msg configure -fg red
    aRecStart
  }
  if {$bgmParam($seq,rStop)   != 0} {
    .msg.msg configure -fg blue
    aRecStop
  }
  if {$bgmParam($seq,nextRec) != 0} {
    if {$v(rec) == 3 && $v(recSeq) < [expr [llength $v(recList)] - 1]} {
      .msg.msg configure -fg blue
      nextRec                             ;# 次の音へ
    } else {
      autoRecStop                         ;# 次の音へ行かず終了
      return
    }
  }
  set v(msg) $bgmParam($seq,msg)

  ;# ガイドBGM再生(snack)
  if {!$paDev(usePlay)} {
    bgm play -start $bgmParam($seq,pStart) -end $bgmParam($seq,pStop) -command $com
    ;#if {$seq == 1} {
    ;#  bgm play -start $bgmParam($seq,pStart)
    ;#}
  } else {
  ;# ガイドBGM再生(PortAudio)
    foreach id [after info] {
      after cancel $id           ;# 待機イベント(autoRec)を削除する
    }
    after $bgmParam($seq,after) $com
    if {$seq == 1} {
      putsPa bgm "playF $bgmParam($seq,pStart)"
      getsPa bgm
    }
  }
}

#---------------------------------------------------
# 引数で指定した単位の値をサンプル単位に変換する
#
proc val2samp {val from sr} {
  switch $from {
    MSEC -
    msec { ;# msec → サンプル単位に変換
      return [expr int($val / 1000.0 * $sr)]
    }
    SEC  -
    sec  { ;# sec → サンプル単位に変換
      return [expr int($val * $sr)]
    }
    default { ;# そのまま返す(念のため整数化する)
      return int($val);
    }
  }
}

#---------------------------------------------------
# 録音開始
#
proc aRecStart {} {
  global snd v bgmParam paDev t
  if {$v(rec) == 0 || $v(recNow) || $bgmParam(autoRecStatus) == 0} return
  if {$paDev(useRec)} {
    putsPa rec "rec"    ;# PortAudio使用時の録音開始
    set ret [getsPa rec]
    if {![regexp {^Success} $ret]} {
      autoRecStop  ;# 自動録音停止
      tk_messageBox -message "$t(aRecStart,errPa)\n$ret" -title $t(.confm.errTitle) -icon warning
      return
    }
  } else {
    snd record             ;# snack使用時の録音開始
  }
  set v(recNow) 1
  set v(recStatus) 1
}

#---------------------------------------------------
# 録音終了(自動録音自体の終了ではない)
#
proc aRecStop {} {
  global snd v paDev t
  if {$v(rec) == 0 || $v(recNow) == 0} return   ;# 収録モードでないなら終了
  if {$paDev(useRec)} {
    putsPa rec "stop"    ;# PortAudio使用時の録音停止
    set ret [getsPa rec]
    if {![regexp {^Success} $ret]} {
      autoRecStop  ;# 自動録音停止
      tk_messageBox -message "$t(aRecStop,errPa)\n$ret" -title $t(.confm.errTitle) -icon warning
      return
    }
    if {[file readable $paDev(recWav)]} {
      snd read $paDev(recWav)
      if {$paDev(usePlay)} {
        putsPa play "wav $paDev(recWav)"
        getsPa play
      }
    }
  } else {
    snd stop               ;# snack使用時の録音停止
  }
  if $v(removeDC) removeDC
  set v(recNow) 0
;#  Redraw all
}

#---------------------------------------------------
# 自動録音終了
#
proc autoRecStop {} {
  global bgm bgmParam paDev v t
  set bgmParam(autoRecStatus) 0
  foreach id [after info] {
    after cancel $id           ;# 待機イベントを削除する
  }
  if {$paDev(usePlay)} {
    putsPa bgm "stop"
    getsPa bgm
  } else {
    bgm stop   ;# ←本当はこれで止まって欲しいけど止まってくれない。。←本当？ちゃんと止まってるのでは？
  }
  .msg.msg configure -fg black
  set v(msg) [eval format $t(autoRecStop,doneMsg)]
  aRecStop
  Redraw all
}

#---------------------------------------------------
# メトロノーム再生/停止の切替
#
proc toggleMetroPlay {} {
  global paDev v metro t

  if $v(playMetroStatus) {
    set v(msg) $t(toggleMetroPlay,stopMsg)
    metro stop  ;# 本当はここで止まって欲しいが止まらない
    set v(playMetroStatus) 0
  } else {
    ;# テンポのチェック
    if {$v(tempo) < 50 || $v(tempo) > 200} {
      tk_messageBox -title $t(toggleMetroPlay,errTitle) -icon error \
        -message [eval format $t(toggleMetroPlay,errMsg)]
      return
    }
    if ![file exists $v(clickWav)] {
      tk_messageBox -title $t(toggleMetroPlay,errTitle) -icon error \
        -message [eval format $t(toggleMetroPlay,errMsg2)]
      return
    }
    metro read $v(clickWav)
    set v(playMetroStatus) 1
    if {! $paDev(usePlay)} {
      loopPlay metro [expr int($v(tempoMSec) / 1000.0 * [metro cget -rate])]
    } else {
      putsPa bgm "wav $v(clickWav)"
      set ret [getsPa bgm]
      if {![regexp {^Success} $ret]} {
        tk_messageBox -message "$t(toggleMetroPlay,errPa)\n$ret" -title $t(.confm.errTitle) -icon warning
      } else {
        loopPlayPa metro $v(tempoMSec)
      }
    }
    set v(msg) $t(toggleMetroPlay,playMsg)
  }
}

#---------------------------------------------------
# wavをループ再生する
#
proc loopPlay {s end} {
  global v t
  if $v(playMetroStatus) {
    $s play -start 0 -end $end -command "loopPlay $s $end"
  }
}

#---------------------------------------------------
# wavをループ再生する(PortAudio版)
#
proc loopPlayPa {s endMSec} {
  global paDev v t
  if $v(playMetroStatus) {
    putsPa bgm "play"
    set ret [getsPa bgm]
    after [expr int($endMSec)] "loopPlayPa $s $endMSec"
  }
}

#---------------------------------------------------
# 音叉再生/停止の切替
#
proc toggleOnsaPlay {} {
  global v f0 onsa t

  if $v(playOnsaStatus) {
    set v(msg) $t(toggleOnsaPlay,stopMsg)
    onsa stop
    set v(playOnsaStatus) 0
  } else {
    set v(msg) $t(toggleOnsaPlay,playMsg)
    set v(playOnsaStatus) 1
    playSin [tone2freq $f0(guideTone)$f0(guideOctave)] \
      $f0(guideVol) -1
  }
}

#---------------------------------------------------
# 再生がファイル末尾に到達した場合の後始末(PortAudio用。無理やりな対応方法)
#
proc playEndPa {} {
  global v t

  if {$v(playStatus) == 0} return
  putsPa play "stat"
  set ret [getsPa play]
  if {$ret == 2} {
    after 200 playEndPa   ;# 再生中ならもうしばらく待つ
  } else {
    set v(playStatus) 0
    set v(msg) $t(togglePlay,stopMsg)
    update
  }
}

#---------------------------------------------------
# 再生バーを表示する
#
proc showPlayBar {t0} {
  global v c paDev

  $c delete playBar
  if {$v(playStatus) == 0} return

  if {$paDev(usePlay)} {
    ;# PortAudio再生の場合、t0には現在の時刻(sec)が入る
    set x [expr $t0 * $v(wavepps)]
    $c create line $x 0 $x $v(cHeight) -fill #FFA000 -tags playBar
    after 50 showPlayBar [expr $t0 + 0.05]
  } else {
    ;# snack再生の場合、t0には再生開始時刻(sec)が入る
    set x [expr ([snack::audio elapsedTime] + $t0) * $v(wavepps)]
    $c create line $x 0 $x $v(cHeight) -fill #FFA000 -tags playBar
    after 50 showPlayBar $t0
  }
}

#---------------------------------------------------
# 再生途中で停止させる(PortAudio版)
#
proc playStopPa {} {
  global v t

  putsPa play "stat"
  set ret [getsPa play]
  if {$ret == 2} {                       ;# 再生中だった場合は停止させる
    foreach id [after info] {
      after cancel $id           ;# 待機イベント(playEndPa)を削除する
    }
    putsPa play "stop"
    getsPa play
    set v(playStatus) 0
    set v(msg) $t(togglePlay,stopMsg)
    showPlayBar -1
  }
}

#---------------------------------------------------
# 再生/停止の切替
#
proc togglePlay {{start 0} {end -1}} {
  global paDev v snd t

  if {[snd length] <= 0} return

  ;# PortAudio向け再生/停止
  if {$paDev(usePlay)} {
    putsPa play "stat"
    set ret [getsPa play]
    if {$ret == 2} {
      playStopPa                 ;# 再生中だった場合は停止させる
    } else {                     ;# 停止中だった場合は再生させる
      foreach id [after info] {
        after cancel $id           ;# 待機イベント(playEndPa)を削除する
      }
      putsPa play "play"
      getsPa play
      set v(playStatus) 1
      set v(msg) $t(togglePlay,playMsg)
      set sampleRate [snd cget -rate]
      if {$end > 0} {
        after [expr int(($end - $start) / $sampleRate * 1000)] playEndPa
      } else {
        after [expr int(([snd length] - $start) / $sampleRate * 1000)] playEndPa
      }
      showPlayBar [expr $start / $sampleRate]
    }
    return
  }

  ;# snack向け再生/停止
  if $v(playStatus) {
    snd stop
    set v(playStatus) 0
    set v(msg) $t(togglePlay,stopMsg)
  } else {
    set v(msg) $t(togglePlay,playMsg)
    set v(playStatus) 1
    snd play -start $start -end $end -command {
      set v(playStatus) 0       ;# 再生終了したときの処理
      set v(msg) $t(togglePlay,stopMsg)
    }
    set sampleRate [snd cget -rate]
    showPlayBar [expr $start / $sampleRate]
  }
}

#---------------------------------------------------
# 発声タイミング補正モードON/OFFの切替
#
#proc timingAdjMode {} {
#  global v t
#
#  if $v(timingAdjMode) {
#    tk_messageBox -message [eval format $t(timingAdjMode,startMsg)] \
#      -icon info
#    set v(msg)  $t(timingAdjMode,on)
#  } else {
#    tk_messageBox -message [eval format $t(timingAdjMode,doneMsg)] \
#      -icon info
#    set v(msg)  $t(timingAdjMode,off)
#  }
#}

#---------------------------------------------------
# リストボックスの縦幅を変更
#
proc resizeListbox {} {
  global v rec type srec stype   ;# updateするためにglobal srec stypeする必要がある

  set h [expr (double([winfo reqheight $rec]) / [$rec cget -height])]
  set lh [expr int($v(cHeight) / $h)]
  $rec  configure -height $lh
  $type configure -height $lh
  update
  $rec see $v(recSeq)
  $type see $v(typeSeq)
}

#---------------------------------------------------
# 波形表示/非表示の切替
#
proc toggleWave {} {
  global v t

  ;#if [snack::audio active] return
  if $v(showWave) {
    set v(waveh) $v(wavehbackup)
    set h [expr $v(winHeight) + $v(waveh)]
    set v(winHeightMin) [expr $v(winHeightMin) + $v(wavehmin)]
  } else {
    set h [expr $v(winHeight) - $v(waveh)]
    set v(winHeightMin) [expr $v(winHeightMin) - $v(wavehmin)]
    set v(wavehbackup) $v(waveh)
    set v(waveh) 0
  }
  wm geometry . "$v(winWidth)x$h"
  wm minsize . $v(winWidthMin) $v(winHeightMin)
  Redraw wave
}

#---------------------------------------------------
# スペクトル表示/非表示の切替
#
proc toggleSpec {} {
  global v t

  ;#if [snack::audio active] return
  if $v(showSpec) {
    set v(spech) $v(spechbackup)
    set h [expr $v(winHeight) + $v(spech)]
    set v(winHeightMin) [expr $v(winHeightMin) + $v(spechmin)]
  } else {
    set h [expr $v(winHeight) - $v(spech)]
    set v(winHeightMin) [expr $v(winHeightMin) - $v(spechmin)]
    set v(spechbackup) $v(spech)
    set v(spech) 0
  }
  wm geometry . "$v(winWidth)x$h"
  wm minsize . $v(winWidthMin) $v(winHeightMin)
  Redraw spec
}

#---------------------------------------------------
# パワー表示/非表示の切替
#
proc togglePow {} {
  global v t

  ;#if [snack::audio active] return
  if $v(showpow) {
    set v(powh) $v(powhbackup)
    set h [expr $v(winHeight) + $v(powh)]
    set v(winHeightMin) [expr $v(winHeightMin) + $v(powhmin)]
  } else {
    set h [expr $v(winHeight) - $v(powh)]
    set v(winHeightMin) [expr $v(winHeightMin) - $v(powhmin)]
    set v(powhbackup) $v(powh)
    set v(powh) 0
  }
  wm geometry . "$v(winWidth)x$h"
  wm minsize . $v(winWidthMin) $v(winHeightMin)
  Redraw pow
}

#---------------------------------------------------
# F0表示/非表示の切替
#
proc toggleF0 {} {
  global v t

  ;#if [snack::audio active] return
  if $v(showf0) {
    set v(f0h) $v(f0hbackup)
    set h [expr $v(winHeight) + $v(f0h)]
    set v(winHeightMin) [expr $v(winHeightMin) + $v(f0hmin)]
  } else {
    set h [expr $v(winHeight) - $v(f0h)]
    set v(winHeightMin) [expr $v(winHeightMin) - $v(f0hmin)]
    set v(f0hbackup) $v(f0h)
    set v(f0h) 0
  }
  wm geometry . "$v(winWidth)x$h"
  wm minsize . $v(winWidthMin) $v(winHeightMin)
  Redraw f0
}

#---------------------------------------------------
# UTAU用原音パラメータ表示/非表示の切替
#
proc toggleParam {} {
  global v t

  Redraw param
}

#---------------------------------------------------
# F0パネルの縦軸表示
# snack の unix/snack.tcl の frequencyAxis を改造
proc myAxis {canvas x y width height args} {
  global v
  # 引数処理
  array set a [list \
    -tags snack_y_axis -font {Helvetica 8} -max 1000 \
    -fill black -draw0 0 -min 0 -unit Hz]
  array set a $args

  if {$height <= 0} return
  if {$a(-max) <= $a(-min)} return

  # ピアノロールを表示
  set max_min [expr $a(-max) - $a(-min)]
  if {$a(-unit) == "semitone"} {
    set ylow [expr $height + $y]
    set ppd [expr double($height) / $max_min]
    set kokken  [expr int($ppd / 2)]
    if {$kokken < 10} {
      set kokkenHH  $kokken
    } else {
      set kokkenHH  10
    }
    set kokkenW [expr $width / 2]
    set first 0
    for {set i 0} {$i < [llength $v(sinScale)]} {incr i} {
      set tgt [hz2semitone [lindex $v(sinScale) $i]]
      set y1 [expr $ylow - ($tgt - $a(-min)) * $ppd]
      if {$y1 <= [expr $ylow - $height]} break
      if {$y1 <= $ylow} {
        set tt  [expr $i % 12]
        if {$tt == 1 || $tt == 3 || $tt == 6 || $tt == 8 || $tt == 10} {
          set yt [expr $y1 - $kokkenHH]
          set yb [expr $y1 + $kokkenHH + 1]
          $canvas create line $kokkenW $y1 $width $y1 -tags $a(-tags) -fill black
          $canvas create rectangle 0 $yt $kokkenW $yb -tags $a(-tags) -fill #d0d0d0
        } elseif {$tt == 4 || $tt == 11} {
          set yw [expr $y1 - $kokken]
          $canvas create line 0 $yw $width $yw -tags $a(-tags) -fill black
        } elseif {$tt == 0} {
          set keyName [format "C%d" [expr int($i / 12 + $v(sinScaleMin))]]
          $canvas create text $kokkenW $y1 -text $keyName \
            -fill $a(-fill) -font $a(-font) -anchor w -tags $a(-tags)
        }
        if {$first == 0} {
          if {$tt != 0} {
            set key [lindex $v(toneList) $tt]
            set keyName [format "%s%d" $key [expr int($i / 12 + $v(sinScaleMin))]]
            $canvas create line $kokkenW $y1 $width $y1 -tags $a(-tags) -fill white
            $canvas create text $kokkenW $y1 -text $keyName \
              -fill $a(-fill) -font $a(-font) -anchor w -tags $a(-tags)
          }
          set first 1
        }
      }
    }

    return
  }

  ;# ticklist...目盛りの間隔の候補
  set ticklist [list 0.2 0.5 1 2 5 10 20 50 100 200 500]

  foreach elem $ticklist {
    set npt $elem  ;# npt...目盛の値の間隔
    ;# dy...目盛りを描画する間隔(y座標)
    set dy [expr {double($height * $npt) / $max_min}]
    if {$dy >= [font metrics $a(-font) -linespace]} break
  }
  set hztext $a(-unit)
  if {$hztext == "semitone"} {set hztext st} ;# 表示を短縮

  if $a(-draw0) {
    set i0 0
    set j0 0
  } else {
    set i0 $dy
    set j0 1
  }

  if {$a(-min) != 0} {
    set j0 [expr int($a(-min) / $npt) + 1]
  }

  ;# j=描画する目盛りの番号
  set yzure [expr {double($a(-min) - ($j0 - 1) * $npt) * $height / $max_min}]

  set yc [expr {$height + $y + $yzure - $i0}]  ;# 目盛を描画するy座標
  set j $j0
  for {} {$yc > $y} {set yc [expr {$yc-$dy}]; incr j} {

    if {$npt < 1000} {
      set tm [expr {$j * $npt}]
    } else {
      set tm [expr {$j * $npt / 1000}]
    }
    if {$yc > [expr {8 + $y}]} {
      if {[expr {$yc - [font metrics $a(-font) -ascent]}] > \
          [expr {$y + [font metrics $a(-font) -linespace]}] ||
          [font measure $a(-font) $hztext]  < \
          [expr {$width - 8 - [font measure $a(-font) $tm]}]} {
        $canvas create text [expr {$x +$width - 8}] [expr {$yc-2}]\
          -text $tm -fill $a(-fill)\
          -font $a(-font) -anchor e -tags $a(-tags)
      }
      $canvas create line [expr {$x + $width - 5}] $yc \
        [expr {$x + $width}]\
        $yc -tags $a(-tags) -fill $a(-fill)
    }
  }
  $canvas create text [expr {$x + 2}] [expr {$y + 1}] -text $hztext \
    -font $a(-font) -anchor nw -tags $a(-tags) -fill $a(-fill)

  return $npt
}

#---------------------------------------------------
# 色選択
#
proc chooseColor {w key initcolor} {
  global v t
  set ctmp [tk_chooseColor -initialcolor $initcolor -title $t(chooseColor,title)]
  if {$ctmp != ""} {
    set v($key) $ctmp
    $w configure -bg $v($key)
  }
}

#---------------------------------------------------
# 音名に対応する周波数を返す
#
proc tone2freq {tone} {
  global v t
  for {set i 0} {$i < [llength $v(sinNote)]} {incr i} {
    if {$tone == [lindex $v(sinNote) $i]} break
  }
  return [lindex $v(sinScale) $i]
}

#---------------------------------------------------
# 波形色設定
#
proc setColor {w key msg} {
  global v t

  set ic $v($key)
  pack [frame $w.$key] -anchor nw
  label  $w.$key.l  -text $msg -width 20 -anchor nw
  label  $w.$key.l2 -textvar v($key) -width 7 -anchor nw -bg $v($key)
  button $w.$key.b  -text $t(setColor,selColor) -command "chooseColor $w.$key.l2 $key $ic"
  pack $w.$key.l $w.$key.l2 $w.$key.b -side left
}

#---------------------------------------------------
# 1Hzに対する周波数比をセミトーンにする
#
proc hz2semitone {hz} {
  return [expr log($hz) / log(2) * 12.0]
}


#---------------------------------------------------
# 項目名：[エントリー]のフレームを作って配置する(power用)
#
proc packEntryPower {wname text key} {
  global power t
  pack [frame $wname] -anchor w
  label $wname.lfl -text $text -width 20 -anchor w
  entry $wname.efl -textvar power($key) -wi 6
  pack $wname.lfl $wname.efl -side left
}

#---------------------------------------------------
# 項目名：[エントリー]のフレームを作って配置する(f0用)
#
proc packEntryF0 {wname text key} {
  global f0 t
  pack [frame $wname] -anchor w
  label $wname.lfl -text $text -width 20 -anchor w
  entry $wname.efl -textvar f0($key) -wi 6
  pack $wname.lfl $wname.efl -side left
}

#---------------------------------------------------
# 音名の選択メニューをpackしたフレームを生成
#
proc packToneList {w text toneKey octaveKey freqKey width vol} {
  global f0 v t
  pack [frame $w] -fill x
  # 項目名ラベル
  label $w.l -text $text -width $width -anchor w
  # 音名選択
  eval tk_optionMenu $w.t f0($toneKey) $v(toneList)
  # オクターブ選択
  set ss {}
  for {set i $v(sinScaleMin)} {$i <= $v(sinScaleMax)} {incr i} {
    lappend ss $i
  }
  eval tk_optionMenu $w.o f0($octaveKey) $ss
  # 試聴ボタン
  button $w.play -text $t(packToneList,play) -bitmap snackPlay -command \
    "playSin \[tone2freq \$f0($toneKey)\$f0($octaveKey)\] \$f0($vol) \$v(sampleRate)"
  button $w.togglePlay -text $t(packToneList,repeat) -command {
    toggleOnsaPlay
  }
  # 音に対応する周波数を表示するラベル
  label $w.$freqKey -textvar f0($freqKey) -width 3 -anchor e
  label $w.unit -text "Hz"
  pack $w.l $w.t $w.o $w.play $w.togglePlay $w.$freqKey $w.unit -side left
}

#---------------------------------------------------
#   入出力デバイスやバッファサイズを初期化する
#
proc audioSettings {} {
  global dev snd bgm t

  set dev(in)   [encoding convertfrom [lindex [snack::audio inputDevices]  0]]
  set dev(out)  [encoding convertfrom [lindex [snack::audio outputDevices] 0]]
  set dev(ingain)    [snack::audio record_gain]
  set dev(outgain)   [snack::audio play_gain]
  set dev(latency)   [snack::audio playLatency]
  set dev(sndBuffer) [snd cget -buffersize]
  set dev(bgmBuffer) [bgm cget -buffersize]
  # snack::audio selectInput $dev(in) ;# 漢字コード未対応
}

#---------------------------------------------------
# 現在の設定を保存する
#
#proc saveSettings {} {
#  global startup bgmParam v f0 power startup dev uttTiming genParam estimate keys t
#
#  set fn [tk_getSaveFile -initialfile $startup(initFile) \
#            -title $t(saveSettings,title) -defaultextension "tcl" ]
#  if {$fn == ""} return
#
#  set aList {bgmParam v f0 power startup dev uttTiming genParam estimate keys}
#
#  set fp [open $fn w]   ;# 保存ファイルを開く
#
#  fconfigure $fn -encoding utf-8
#
#  foreach aName $aList {
#    set sList [array get $aName]
#    foreach {key value} $sList {
#      if {$aName == "v" && $key != "paramChanged" 
#                        && $key != "msg"
#                        && $key != "version"} {
#        puts $fp [format "set %s(%s)\t\t{%s}" $aName $key $value]
#      }
#    }
#  }
#  close $fp
#}
#
proc saveSettings {{fn ""}} {
  global topdir t v f0 power startup dev uttTiming genParam estimate keys
  # ↑保存する配列を増やしたら、ここに追加すると共にdoReadInitFileのglobalにも追加

  if {$fn == ""} {
    set fn [tk_getSaveFile -initialfile $startup(initFile) \
            -title $t(saveSettings,title) -defaultextension "tcl" ]
  }
  if {$fn == ""} return

  ;# 保存ファイルを開く
  if [catch {open $fn w} fp] {
    tk_messageBox -message "error: can not open $fn" -title $t(.confm.fioErr) -icon warning
    return
  }
  fconfigure $fp -encoding utf-8
  foreach aName $startup(arrayForInitFile) {
    set sList [array get $aName]
    foreach {key value} $sList {
      ;# もし文字列に[が含まれていればエスケープシーケンスを挿入する
      regsub -all -- {\[} $value "\\\[" value

      ;# $topdir下のファイルを指したデータなら_OREMO_TOPDIR_という文字に置き換える
      ;# 他PCに移動した時などtopdirの違う環境にも対応させるため
      if {[string first $topdir $value] == 0} {
        set value [string replace $value 0 [expr [string length $topdir] - 1] "_OREMO_TOPDIR_"]
      }

      if {[lsearch $startup(exclusionKeysForInitFile,aName) $aName] < 0 ||
          [lsearch $startup(exclusionKeysForInitFile,$aName) $key]  < 0} {
        ;# 保存対象のデータを書き込む
        puts $fp [format "set %s(%s)\t\t{%s}" $aName $key $value]
      }
    }
  }
  close $fp
}

#---------------------------------------------------
# 初期化ファイルを指定して読み込む
#
proc readSettings {} {
  global v t startup

  set fn [tk_getOpenFile -initialfile $startup(initFile) \
            -title $t(readSettings,title) -defaultextension "tcl" \
            -filetypes { {{tcl file} {.tcl}} {{All Files} {*}} }]
  if {$fn == ""} return

  doReadInitFile $fn
}

#---------------------------------------------------
# メッセージテキストファイルや初期化ファイルを読み込む
#
proc doReadInitFile {initFile} {
  global topdir t v f0 power startup dev uttTiming genParam estimate keys

  if {! [file exists $initFile]} return

  if [catch {open $initFile r} in] {
    if {[array names t "doReadInitFile,errMsg"] != ""} {
      tk_messageBox -message $t(doReadInitFile,errMsg) -title $t(.confm.fioErr) -icon warning
    } else {
      tk_messageBox -message "can not read the file ($initFile)" -title "File I/O Error" -icon warning
    }
    return
  }

  fconfigure $in -encoding utf-8

  ;# 簡易サニタイジング
  while {![eof $in]} {
    set l [gets $in]

    if {[regexp {^[ \t]*$} $l]}                   continue  ;# 空行はOK
    if {[regexp {^[ \t]*(;|)[ \t]*#} $l]}         continue  ;# コメント行はOK

    regsub -all -- {\\\[} $l "" l                           ;# \[を消した上で↓のチェックを行う
    if {[regexp {^[ \t]*set[ \t]+[^;\[]+$} $l]} continue    ;# set に;や[がなければOK

    ;# エラーがあった場合
    if {[array names t "doReadInitFile,errMsg2"] != ""} {
      tk_messageBox -message $t(doReadInitFile,errMsg2) \
        -title $t(.confm.fioErr) -icon warning
    } else {
      tk_messageBox -message "Syntax error\nLine: $l\nFile: $initFile\nYou can use only \"set variableName {value}\" in that file." \
        -title "File I/O Error" -icon warning
    }
    close $in
    return
  }
  close $in

  source -encoding utf-8 $initFile

  ;# _OREMO_TOPDIR_を$topdirに置き換える
  foreach aName $startup(arrayForInitFile) {
    set sList [array get $aName]
    foreach {key value} $sList {
      if {[string first "_OREMO_TOPDIR_" $value] == 0} {
        set newValue [string replace $value 0 [expr [string length "_OREMO_TOPDIR_"] -1] $topdir]
        set [eval format "%s(%s)" $aName $key] $newValue
      }
    }
  }
}

#---------------------------------------------------
# 指定した窓が起動済みかチェック。起動済みならフォーカスする。
#
proc isExist {w} {
  if [winfo exists $w] {
    raise $w
    focus $w
    return 1
  } else {
    return 0
  }
}

#---------------------------------------------------
# PortAudioによる録音ツールを起動する。return 0=正常に起動。
#
proc paRecRun {} {
  global v topdir paDev paDevFp ioswindow t ioswindow

  if {$paDevFp(rec) == ""} {
    if {[catch {open "|$topdir/tools/oremo-recorder.exe" r+} paDevFp(rec)]} { 
      tk_messageBox -message $t(paRecRun,errMsg) -title $t(.confm.errTitle) -icon warning
      if [isExist $ioswindow] {
        raise $ioswindow
        focus $ioswindow
      }
      return 1
    }
    fconfigure $paDevFp(rec) -buffering none   ;# バッファリングさせない

    ;# デバイス一覧を取得する
    $paDev(devListMenu) delete 0 end
    putsPa rec "list"
    set paDev(devList) [split [getsPa rec] "\n"]
    foreach d $paDev(devList) {
      regsub -all {(\r|\n)} $d "" d
      $paDev(devListMenu) insert end radiobutton -variable paDev(in) -label $d -value $d
    }
    if {[llength $paDev(devList)] <= 0} {
      ;# デバイスを検出できなかった場合
      set paDev(devList) {none}
      $paDev(devListMenu) insert end radiobutton -variable paDev(in) -label "none" -value "none"
      paRecTerminate
      tk_messageBox -message $t(paRecRun,errDev) -title $t(.confm.errTitle) -icon warning
      if [isExist $ioswindow] {
        raise $ioswindow
        focus $ioswindow
      }
      return 1
    } elseif {$paDev(in) == "none"} {
      set paDev(in) [lindex $paDev(devList) 0]  ;# 最初のデバイスを自動選択する
    }
    updateIoSettings
  }
  return 0
}

#---------------------------------------------------
# PortAudioによる再生ツールを起動する。return 0=正常に起動。
#
proc paPlayRun {} {
  global v topdir paDev paDevFp ioswindow t

  if {$paDevFp(play) == ""} {
    if {[catch {open "|$topdir/tools/oremo-player.exe" r+} paDevFp(play)]} { 
      tk_messageBox -message $t(paPlayRun,errMsg) -title $t(.confm.errTitle) -icon warning
      if [isExist $ioswindow] {
        raise $ioswindow
        focus $ioswindow
      }
      return 1
    }
    if {$paDevFp(bgm) == ""} {
      if {[catch {open "|$topdir/tools/oremo-player.exe" r+} paDevFp(bgm)]} { 
        tk_messageBox -message $t(paPlayRun,errMsg) -title $t(.confm.errTitle) -icon warning
        paPlayTerminate
        if [isExist $ioswindow] {
          raise $ioswindow
          focus $ioswindow
        }
        return 1
      }
    }
    fconfigure $paDevFp(play) -buffering none   ;# バッファリングさせない
    fconfigure $paDevFp(bgm)  -buffering none   ;# バッファリングさせない

    ;# デバイス一覧を取得する
    $paDev(outdevListMenu) delete 0 end
    putsPa play "list"
    set paDev(outdevList) [split [getsPa play] "\n"]
    foreach d $paDev(outdevList) {
      regsub -all {(\r|\n)} $d "" d
      $paDev(outdevListMenu) insert end radiobutton -variable paDev(out) -label $d -value $d
    }
    if {[llength $paDev(outdevList)] <= 0} {
      ;# デバイスを検出できなかった場合
      set paDev(outdevList) {none}
      $paDev(outdevListMenu) insert end radiobutton -variable paDev(out) -label "none" -value "none"
      paPlayTerminate
      tk_messageBox -message $t(paPlayRun,errDev) -title $t(.confm.errTitle) -icon warning
      if [isExist $ioswindow] {
        raise $ioswindow
        focus $ioswindow
      }
      return 1
    } elseif {$paDev(out) == "none"} {
      set paDev(out) [lindex $paDev(outdevList) 0]  ;# 最初のデバイスを自動選択する
    }
    updateIoSettings
  }
  return 0
}

#---------------------------------------------------
# PortAudioによる録音ツールを停止する
#
proc paRecTerminate {} {
  global v paDev paDevFp ioswindow

  if {$paDevFp(rec) != ""} {
    putsPa rec "exit"
    close $paDevFp(rec)
    set paDevFp(rec) ""

    updateIoSettings
  }
}

#---------------------------------------------------
# PortAudioによる再生ツールを停止する
#
proc paPlayTerminate {} {
  global v paDev paDevFp ioswindow

  if {$paDevFp(play) != ""} {
    putsPa play "exit"
    close $paDevFp(play)
    set paDevFp(play) ""
  }

  if {$paDevFp(bgm) != ""} {
    putsPa bgm "exit"
    close $paDevFp(bgm)
    set paDevFp(bgm) ""
  }

  updateIoSettings
}

#---------------------------------------------------
# PortAudioの録音ツールに一行を送る
#
proc putsPa {m str} {
  global paDevFp
  puts $paDevFp($m) $str
  flush $paDevFp($m)
}

#---------------------------------------------------
# PortAudioの録音ツールからの結果通知文を読んで返す
#
proc getsPa {m} {
  global paDevFp

  set ret ""
  set paFlag 0   ;# 1="resultBegin"を通過後
  while {1} {
    gets $paDevFp($m) d
    if {[regexp {^resultEnd} $d]} break
    if {[regexp {^resultBegin} $d]} {
      set paFlag 1
    } elseif {$paFlag} {
      regsub -all {(\r|\n)} $d "" d
      if {$ret == ""} {
        set ret $d
      } else {
        set ret "$ret\n$d"
      }
    }
  }
  return $ret
}

#---------------------------------------------------
# PortAudio/Snackの切り替えで有効/無効になる設定項目を切り替える
#
proc updateIoSettings {} {
  global v paDev paDevFp ioswindow

  if ![isExist $ioswindow] return

  set normal   {}
  set black    {}
  set disabled {}
  set gray     {}
  if {$paDevFp(rec) != ""} {
    ;# PortAudio入力を有効、Snack入力を無効にする
    set normal   [concat $normal   {pf.in  pf.esr pf.fmt pf.ech pf.ebs}]
    set black    [concat $black    {pf.lin pf.lsr pf.lbt pf.lch pf.lbs}]
    set disabled [concat $disabled {sf.f1.in sf.f3.e sf.f3.s sf.f6.e}]
    set gray     [concat $gray     {sf.f1.lin sf.f3.l sf.f6.l sf.f6.u}]
  } else {
    ;# PortAudio入力を無効、Snack入力を有効にする
    set disabled [concat $disabled {pf.in  pf.ech}]
    set gray     [concat $gray     {pf.lin pf.lch}]
    set normal   [concat $normal   {sf.f1.in sf.f3.e sf.f3.s sf.f5.e sf.f6.e}]
    set black    [concat $black    {sf.f1.lin sf.f3.l sf.f5.l sf.f5.u sf.f6.l sf.f6.u}]
  }
  if {$paDevFp(play) != ""} {
    ;# PortAudio出力を有効、Snack出力を無効にする
    set normal   [concat $normal   {pf.out  pf.esr pf.fmt pf.ebs}]
    set black    [concat $black    {pf.lout pf.lsr pf.lbt pf.lbs}]
    set disabled [concat $disabled {sf.f2.out sf.f4.l sf.f4.e sf.f4.s sf.f7.e}]
    set gray     [concat $gray     {sf.f2.l   sf.f4.l sf.f6.u sf.f7.u sf.f7.l}]
  } else {
    ;# PortAudio出力を無効、Snack出力を有効にする
    set disabled [concat $disabled {pf.out}]
    set gray     [concat $gray     {pf.lout}]
    set normal   [concat $normal   {sf.f2.out sf.f4.l sf.f4.e sf.f4.s sf.f5.e sf.f7.e}]
    set black    [concat $black    {sf.f2.l   sf.f4.l sf.f5.l sf.f5.u sf.f6.u sf.f7.u sf.f7.l}]
  }
  ;# PortAudio入力・出力が共に無効の時
  if {$paDevFp(rec) == "" && $paDevFp(play) == ""} {
    set disabled [concat $disabled {pf.esr pf.fmt pf.ech pf.ebs}]
    set gray     [concat $gray     {pf.lsr pf.lbt pf.lch pf.lbs}]
  }
  ;# PortAudio入力・出力が共に有効の時
  if {$paDevFp(rec) != "" && $paDevFp(play) != ""} {
    set disabled [concat $disabled {sf.f5.e}]
    set gray     [concat $gray     {sf.f5.l sf.f5.u}]
  }

  foreach w $black {
    eval $ioswindow.$w configure -fg black
  }
  foreach w $normal {
    eval $ioswindow.$w configure -state normal
  }
  foreach w $disabled {
    eval $ioswindow.$w configure -state disabled
  }
  foreach w $gray {
    eval $ioswindow.$w configure -fg #a0a0a0
  }
}

#---------------------------------------------------
# 入出力デバイスの設定窓の値をデバイスに反映させる
# 成功したら0、失敗なら1を返す
#
proc setIODevice {} {
  global dev snd bgm t paDev paDevFp
  ;# snackのdev(in),dev(out)にはメニュー表示のため漢字コードをsjis→utf-8に
  ;# 変換した文字列を入れている。デバイス設定時には元の漢字コード文字列で
  ;# 指定しないとエラーになる様子なので以下のようなコードで対応している

  if {$paDev(useRequestRec) && $paDevFp(rec) == ""} {
    if {[paRecRun]} { return 1 }
  } elseif {! $paDev(useRequestRec) && $paDevFp(rec) != ""} {
    paRecTerminate
  }
  if {$paDev(useRequestPlay) && $paDevFp(play) == ""} {
    if {[paPlayRun]} { return 1 }
  } elseif {! $paDev(useRequestPlay) && $paDevFp(play) != ""} {
    paPlayTerminate
  }
  if {$paDev(useRequestPlay) && $paDevFp(bgm) == ""} {
    if {[paPlayRun]} { return 1 }
  } elseif {! $paDev(useRequestPlay) && $paDevFp(bgm) != ""} {
    paPlayTerminate
  }

  ;# PortAudio側にデバイス設定を伝える
  if {$paDev(useRequestRec)} {
    ;# デバイス番号を取得
    set dID ""
    regexp {^[0-9]+} $paDev(in) dID
    if {$dID == ""} {
      tk_messageBox -message $t(setIODevice,errPa2) -title $t(.confm.errTitle) -icon warning
      return 1
    }
    ;# 量子化ビットをPortAudioの所定の番号に変換
    switch $paDev(sampleFormat) {
      "Int16"   { set paSampleFormat 8 }
      "Int24"   { set paSampleFormat 4 }
      "Int32"   { set paSampleFormat 2 }
      "Float32" { set paSampleFormat 1 }
    }
    ;# チャンネル数チェック
    set paDev(channel) [string trim $paDev(channel)]
    if {![regexp {^[0-9]+$} $paDev(channel)]} {
      tk_messageBox -message $t(setIODevice,errPa3) -title $t(.confm.errTitle) -icon warning
      return 1
    }
    ;# サンプリング周波数チェック
    set paDev(sampleRate) [string trim $paDev(sampleRate)]
    if {![regexp {^[0-9]+$} $paDev(sampleRate)]} {
      tk_messageBox -message $t(setIODevice,errPa4) -title $t(.confm.errTitle) -icon warning
      return 1
    }
    ;# バッファサイズチェック
    set paDev(bufferSize) [string trim $paDev(bufferSize)]
    if {![regexp {^[0-9]+$} $paDev(bufferSize)]} {
      tk_messageBox -message $t(setIODevice,errPa5) -title $t(.confm.errTitle) -icon warning
      return 1
    }
    ;# "set デバイス番号 形式(bit)番号 チャンネル サンプリング周波数 バッファサイズ
    putsPa rec "set $dID $paSampleFormat $paDev(channel) $paDev(sampleRate) $paDev(bufferSize)"
    set ret [getsPa rec]
    if {![regexp {^Success} $ret]} {
      tk_messageBox -message "$t(setIODevice,errPa)\n$ret" -title $t(.confm.errTitle) -icon warning
      return 1
    }
  } else {
    ;# snack使用時のデバイス設定
    foreach dname [snack::audio inputDevices] {
      if {$dev(in) == [encoding convertfrom $dname]} {
        snack::audio selectInput  $dname
        break
      }
    }
    snack::audio record_gain  $dev(ingain)
  }
  set paDev(useRec)  $paDev(useRequestRec)   ;# portaudio設定でエラーが無かったのでリクエストを正式に受理する

  ;# PortAudio側にデバイス設定を伝える
  if {$paDev(useRequestPlay)} {
    ;# デバイス番号を取得
    set dID ""
    regexp {^[0-9]+} $paDev(out) dID
    if {$dID == ""} {
      tk_messageBox -message $t(setIODevice,errPaOut2) -title $t(.confm.errTitle) -icon warning
      return 1
    }
    ;# 量子化ビットをPortAudioの所定の番号に変換
    switch $paDev(sampleFormat) {
      "Int16"   { set paSampleFormat 8 }
      "Int24"   { set paSampleFormat 4 }
      "Int32"   { set paSampleFormat 2 }
      "Float32" { set paSampleFormat 1 }
    }
    ;# チャンネル数チェック
    set paDev(channel) [string trim $paDev(channel)]
    if {![regexp {^[0-9]+$} $paDev(channel)]} {
      tk_messageBox -message $t(setIODevice,errPa3) -title $t(.confm.errTitle) -icon warning
      return 1
    }
    ;# サンプリング周波数チェック
    set paDev(sampleRate) [string trim $paDev(sampleRate)]
    if {![regexp {^[0-9]+$} $paDev(sampleRate)]} {
      tk_messageBox -message $t(setIODevice,errPa4) -title $t(.confm.errTitle) -icon warning
      return 1
    }
    ;# バッファサイズチェック
    set paDev(bufferSize) [string trim $paDev(bufferSize)]
    if {![regexp {^[0-9]+$} $paDev(bufferSize)]} {
      tk_messageBox -message $t(setIODevice,errPa5) -title $t(.confm.errTitle) -icon warning
      return 1
    }
    ;# "set デバイス番号 形式(bit)番号 チャンネル サンプリング周波数 バッファサイズ
    putsPa play "set $dID $paSampleFormat $paDev(channel) $paDev(sampleRate) $paDev(bufferSize)"
    set ret [getsPa play]
    if {![regexp {^Success} $ret]} {
      tk_messageBox -message "$t(setIODevice,errPa)\n$ret" -title $t(.confm.errTitle) -icon warning
      return 1
    }
    putsPa bgm "set $dID $paSampleFormat $paDev(channel) $paDev(sampleRate) $paDev(bufferSize)"
    set ret [getsPa bgm]
    if {![regexp {^Success} $ret]} {
      tk_messageBox -message "$t(setIODevice,errPa)\n$ret" -title $t(.confm.errTitle) -icon warning
      return 1
    }
  } else {
    ;# snack使用時のデバイス設定
    foreach dname [snack::audio outputDevices] {
      if {$dev(out) == [encoding convertfrom $dname]} {
        snack::audio selectOutput $dname
        break
      }
    }
    snack::audio play_gain    $dev(outgain)
    snack::audio playLatency  $dev(latency)
  }
  set paDev(usePlay) $paDev(useRequestPlay)  ;# portaudio設定でエラーが無かったのでリクエストを正式に受理する

  snd configure -buffersize $dev(sndBuffer)
  bgm configure -buffersize $dev(bgmBuffer)

  readWavFile
  return 0
}

#---------------------------------------------------
#   入出力デバイスやバッファサイズを設定する窓
#
proc ioSettings {} {
  global ioswindow dev dev_bk paDev paDev_bk snd bgm t

  if [isExist $ioswindow] return ;# 二重起動を防止
  toplevel $ioswindow
  wm title $ioswindow $t(ioSettings,title)
  wm resizable $ioswindow 0 0
  bind $ioswindow <Escape> {destroy $ioswindow}

  ;# ゲイン、レイテンシの最新状況を取得
  set dev(ingain)  [snack::audio record_gain]
  set dev(outgain) [snack::audio play_gain]
  set dev(latency) [snack::audio playLatency]
  set dev(sndBuffer) [snd cget -buffersize]
  set dev(bgmBuffer) [bgm cget -buffersize] 
  array set dev_bk   [array get dev]       ;# パラメータバックアップ
  array set paDev_bk [array get paDev]     ;# パラメータバックアップ


  #-----------------------
  # snack設定用のフレーム
  set sf [labelframe $ioswindow.sf -text "Snack" \
    -relief groove -padx 5 -pady 5]
  pack $sf -fill both -expand false

  ;# 入力デバイスの選択
  set devList {}
  foreach d [snack::audio inputDevices] {
    set d [encoding convertfrom $d]
    lappend devList "$d"
    # if {[string length $d] == [string bytelength $d]} {  ;# 英語デバイスのみ登録
    #  lappend devList "$d"
    # }
  }
  set f1 [frame $sf.f1]
  label $f1.lin -text $t(ioSettings,inDev) -width 12 -anchor w
  eval tk_optionMenu $f1.in dev(in) $devList
  pack $f1.lin $f1.in -side left
  pack $f1 -anchor w

  ;# 出力デバイスの選択
  set devList {}
  foreach d [snack::audio outputDevices] {
    set d [encoding convertfrom $d]
    lappend devList "$d"
    #if {[string length $d] == [string bytelength $d]} {  ;# 英語デバイスのみ登録
    #  lappend devList "$d"
    #}
  }
  set f2 [frame $sf.f2]
  label $f2.l -text $t(ioSettings,outDev) -width 12 -anchor w
  eval tk_optionMenu $f2.out dev(out) $devList
  pack $f2.l $f2.out -side left
  pack $f2 -anchor w

  ;# 入力ゲインの指定
  set f3 [frame $sf.f3]
  label $f3.l -text $t(ioSettings,inGain) -width 32 -anchor w
  entry $f3.e -textvar dev(ingain) -wi 6
  scale $f3.s -variable dev(ingain) -orient horiz \
    -from 0 -to 100 -res 1 -showvalue 0
  pack $f3.l $f3.e $f3.s -side left
  pack $f3 -anchor w

  ;# 出力ゲインの指定
  set f4 [frame $sf.f4]
  label $f4.l -text $t(ioSettings,outGain) -width 32 -anchor w
  entry $f4.e -textvar dev(outgain) -wi 6
  scale $f4.s -variable dev(outgain) -orient horiz \
    -from 0 -to 100 -res 1 -showvalue 0
  pack $f4.l $f4.e $f4.s -side left
  pack $f4 -anchor w

  ;# レイテンシの指定
  set f5 [frame $sf.f5]
  label $f5.l -text $t(ioSettings,latency) -width 32 -anchor w
  entry $f5.e -textvar dev(latency) -wi 6
  label $f5.u -text "(msec)"
  pack $f5.l $f5.e $f5.u -side left
  pack $f5 -anchor w

  ;# 収録音のバッファサイズの指定
  set f6 [frame $sf.f6]
  label $f6.l -text $t(ioSettings,sndBuffer) -width 32 -anchor w
  entry $f6.e -textvar dev(sndBuffer) -wi 6
  label $f6.u -text "(sample)"
  pack $f6.l $f6.e $f6.u -side left
  pack $f6 -anchor w

  ;# ガイドBGMのバッファサイズの指定
  set f7 [frame $sf.f7]
  label $f7.l -text $t(ioSettings,bgmBuffer) -width 32 -anchor w
  entry $f7.e -textvar dev(bgmBuffer) -wi 6
  label $f7.u -text "(sample)"
  pack $f7.l $f7.e $f7.u -side left
  pack $f7 -anchor w

  #-----------------------
  # portaudio設定用のフレーム
  frame $ioswindow.pa
  label $ioswindow.pa.l -text $t(ioSettings,portaudio)
  # PortAudio録音
  checkbutton $ioswindow.pa.r -variable paDev(useRequestRec) -text $t(ioSettings,useRequestRec) -command {
    if {$paDev(useRequestRec)} {
      if {[paRecRun]} {
        set paDev(useRequestRec) 0
      }
    } else {
      paRecTerminate
      set paDev(in) "none"
    }
  }
  # PortAudio再生
  checkbutton $ioswindow.pa.p -variable paDev(useRequestPlay) -text $t(ioSettings,useRequestPlay) -command {
    if {$paDev(useRequestPlay)} {
      if {[paPlayRun]} {
        set paDev(useRequestPlay) 0
      }
    } else {
      paPlayTerminate
      set paDev(out) "none"
    }
  }
  pack $ioswindow.pa.l $ioswindow.pa.r $ioswindow.pa.p -side left
  set pf [labelframe $ioswindow.pf -labelwidget $ioswindow.pa \
    -relief groove -padx 5 -pady 5 -labelanchor nw]
  pack $pf -fill both -expand false

  ;# 入力デバイス
  label $pf.lin -text $t(ioSettings,inDev) -anchor w
  set paDev(devListMenu) [tk_optionMenu $pf.in paDev(in) "none"]
  $paDev(devListMenu) delete 0 end
  foreach d $paDev(devList) {
    regsub -all {(\r|\n)} $d "" d
    $paDev(devListMenu) insert end radiobutton -variable paDev(in) -label $d -value $d
  }
  ;# 出力デバイス
  label $pf.lout -text $t(ioSettings,outDev) -anchor w
  set paDev(outdevListMenu) [tk_optionMenu $pf.out paDev(out) "none"]
  $paDev(outdevListMenu) delete 0 end
  foreach d $paDev(outdevList) {
    regsub -all {(\r|\n)} $d "" d
    $paDev(outdevListMenu) insert end radiobutton -variable paDev(out) -label $d -value $d
  }
  label $pf.lsr -text $t(ioSettings,sampleRate) -anchor w
  entry $pf.esr -textvar paDev(sampleRate) -wi 6 -validate key -validatecommand {
    if {![string is integer %P]} {return 0}
    return 1
  }
  label $pf.lbt -text $t(ioSettings,format) -anchor w
  tk_optionMenu $pf.fmt paDev(sampleFormat) Int16 Int24 Int32 Float32
  label $pf.lch -text $t(ioSettings,inChannel) -anchor w
  entry $pf.ech -textvar paDev(channel) -wi 6 -validate key -validatecommand {
    if {![string is integer %P]} {return 0}
    return 1
  }
  label $pf.lbs -text $t(ioSettings,bufferSize) -anchor w
  entry $pf.ebs -textvar paDev(bufferSize) -wi 6 -validate key -validatecommand {
    if {![string is integer %P]} {return 0}
    return 1
  }

  grid $pf.lin  -row 0 -column 0 -sticky w
  grid $pf.in   -row 0 -column 1 -sticky w -columnspan 2
  grid $pf.lout -row 1 -column 0 -sticky w
  grid $pf.out  -row 1 -column 1 -sticky w -columnspan 2
  grid $pf.lsr  -row 2 -column 0 -sticky w
  grid $pf.esr  -row 2 -column 1 -sticky w
  grid $pf.lbt  -row 3 -column 0 -sticky w
  grid $pf.fmt  -row 3 -column 1 -sticky w
  grid $pf.lch  -row 4 -column 0 -sticky w
  grid $pf.ech  -row 4 -column 1 -sticky w
  grid $pf.lbs  -row 5 -column 0 -sticky w
  grid $pf.ebs  -row 5 -column 1 -sticky w
  pack $pf -anchor w

  ;# 決定ボタン
  set fb [frame $ioswindow.fb]
  button $fb.ok -text $t(.confm.ok) -wi 8 -command {
    if {! [setIODevice]} {
      destroy $ioswindow
    } else {
      raise $ioswindow
      focus $ioswindow
    }
  }
  button $fb.ap -text $t(.confm.apply) -wi 8 -command {
    if {! [setIODevice]} {
      array set dev_bk   [array get dev]       ;# パラメータバックアップ
      array set paDev_bk [array get paDev]     ;# パラメータバックアップ
    } else {
      raise $ioswindow
      focus $ioswindow
    }
  }
  button $fb.cn -text $t(.confm.c) -wi 8 -command {
    array set dev   [array get dev_bk]       ;# パラメータを以前の状態に戻す
    array set paDev [array get paDev_bk]     ;# パラメータを以前の状態に戻す
    setIODevice
    destroy $ioswindow
  }
  pack $fb.ok $fb.ap $fb.cn -side left
  pack $fb -anchor w

  ;# 説明文
  set fm [frame $ioswindow.fm]
  label $fm.lm0  -fg red -text $t(ioSettings,comment0)
  label $fm.lm0b -fg red -text $t(ioSettings,comment0b)
  label $fm.lm1  -fg red -text $t(ioSettings,comment1)
  label $fm.lm2  -fg red -text $t(ioSettings,comment2)
  pack $fm.lm0 $fm.lm0b $fm.lm1 $fm.lm2 -anchor w -side top
  pack $fm -anchor w

  updateIoSettings
  raise $ioswindow
  focus $ioswindow
}

#---------------------------------------------------
# プログレスバーを初期化して表示する
#
proc initProgressWindow {{title "now processing..."}} {
  global prgWindow v
  if [isExist $prgWindow] return

  toplevel $prgWindow
  wm title $prgWindow $title
  wm attributes $prgWindow -toolwindow 1
  wm attributes $prgWindow -topmost 1
  set topg [split [wm geometry .] "x+"]
  set x [expr [lindex $topg 2] + [lindex $topg 0] / 2 - 100]
  set y [expr [lindex $topg 3] + [lindex $topg 1] / 2 - 5]
  wm geometry $prgWindow "+$x+$y"

  set v(pregress) 0

  ttk::progressbar $prgWindow.p -length 200 -variable v(progress) -mode determinate
  pack $prgWindow.p

  raise .progress
  focus .progress
  update
}

#---------------------------------------------------
# プログレスバーを更新する。進捗状況は$progress(0～100)で指定する)
#
proc updateProgressWindow {progress {title ""}} {
  global v prgWindow

  if {$title != ""} { wm title $prgWindow $title }
  set v(progress) $progress
  raise $prgWindow
  focus $prgWindow
  update
}

#---------------------------------------------------
# プログレスバーを消去する
#
proc deleteProgressWindow {} {
  global prgWindow
  destroy $prgWindow
}



#---------------------------------------------------
# 詳細設定
#
proc settings {} {
  global swindow v power f0 v_bk power_bk f0_bk snd t
  global onsa metro bgm uttTiming
    # ↑*_bkは大域変数にしないとキャンセル時にバックアップ復帰できなかった

  ;# 二重起動を防止
  if [isExist $swindow] return
  toplevel $swindow
  wm title $swindow $t(settings,title)
  wm resizable $swindow 0 0
  bind $swindow <Escape> {destroy $swindow}

  array set v_bk     [array get v]     ;# パラメータバックアップ
  array set power_bk [array get power] ;# パラメータバックアップ
  array set f0_bk    [array get f0]    ;# パラメータバックアップ

  ;# 1カラム目のフレーム
  set frame1 [frame $swindow.l]
  pack $frame1 -side left -anchor n -fill y -padx 2 -pady 2

  ;#---------------------------
  ;# 波形
  set lf1 [labelframe $frame1.lf1 -text $t(settings,wave) \
    -relief groove -padx 5 -pady 5]
  pack $lf1 -anchor w -fill x

  ;# 波形色の設定
  set cw [frame $lf1.f4w]
  setColor $cw "wavColor" $t(settings,waveColor)
  pack $cw -anchor nw

  ;# 波形縦軸の最大値
  pack [frame $lf1.fs] -anchor w
  label $lf1.fs.l -text $t(settings,waveScale) -wi 35 -anchor w
  entry $lf1.fs.e -textvar v(waveScale) -wi 6 -validate key -validatecommand {
    if {[regexp {^[0-9]*$} %P]} {return 1} ;# 空文字もOk
    return 0
  }
  pack $lf1.fs.l $lf1.fs.e  -side left

  ;# サンプリング周波数の設定
  pack [frame $lf1.f20] -anchor w
  label $lf1.f20.l -text $t(settings,sampleRate) -wi 35 -anchor w
  entry $lf1.f20.e -textvar v(sampleRate) -wi 6 -validate key -validatecommand {
    if {[regexp {^[0-9]*$} %P]} {return 1}
    return 0
  }
  pack $lf1.f20.l $lf1.f20.e  -side left

  ;#---------------------------
  ;# スペクトルパラメータ
  set lf2 [labelframe $frame1.lf2 -text $t(settings,spec) \
    -relief groove -padx 5 -pady 5]
  pack $lf2 -anchor w -fill x

  ;# スペクトルの配色
  pack [frame $lf2.f45] -anchor w
  label $lf2.f45.l -text $t(settings,specColor) -width 20 -anchor w
  tk_optionMenu $lf2.f45.cm v(cmap) grey color1 color2
  pack $lf2.f45.l $lf2.f45.cm -side left

  ;# スペクトル周波数の最高値
  pack [frame $lf2.f20] -anchor w
  label $lf2.f20.l -text $t(settings,maxFreq) -width 20 -anchor w
  entry $lf2.f20.e -textvar v(topfr) -wi 6
  scale $lf2.f20.s -variable v(topfr) -orient horiz \
    -from 0 -to [expr $v(sampleRate)/2] -showvalue 0
  pack $lf2.f20.l $lf2.f20.e $lf2.f20.s -side left

  ;# 明るさ
  pack [frame $lf2.f30] -anchor w
  label $lf2.f30.l -text $t(settings,brightness) -width 20 -anchor w
  entry $lf2.f30.e -textvar v(brightness) -wi 6
  scale $lf2.f30.s -variable v(brightness) -orient horiz \
    -from -100 -to 100 -res 0.1 -showvalue 0
  pack $lf2.f30.l $lf2.f30.e $lf2.f30.s -side left

  ;# コントラスト
  pack [frame $lf2.f31] -anchor w
  label $lf2.f31.l -text $t(settings,contrast) -width 20 -anchor w
  entry $lf2.f31.e -textvar v(contrast) -wi 6
  scale $lf2.f31.s -variable v(contrast) -orient horiz \
    -from -100 -to 100 -res 0.1 -showvalue 0
  pack $lf2.f31.l $lf2.f31.e $lf2.f31.s -side left

  ;# FFT長(必ず2のべき乗にすること)
  pack [frame $lf2.f32] -anchor w
  label $lf2.f32.l -text $t(settings,fftLength) -width 20 -anchor w
  tk_optionMenu $lf2.f32.om v(fftlen) 8 16 32 64 128 256 512 1024 2048 4096
  pack $lf2.f32.l $lf2.f32.om -side left

  ;# 窓長(必ずFFT長以下にすること)
  pack [frame $lf2.f33] -anchor w
  label $lf2.f33.l -text $t(settings,fftWinLength) -width 20 -anchor w
  entry $lf2.f33.e -textvar v(winlen) -wi 6
  scale $lf2.f33.s -variable v(winlen) -orient horiz \
    -from 8 -to 4096 -showvalue 0
  pack $lf2.f33.l $lf2.f33.e $lf2.f33.s -side left

  ;# プリエンファシス
  pack [frame $lf2.f34] -anchor w
  label $lf2.f34.l -text $t(settings,fftPreemph) -width 20 -anchor w
  entry $lf2.f34.e -textvar v(preemph) -wi 6
  pack $lf2.f34.l $lf2.f34.e -side left

  ;# 窓の選択
  pack [frame $lf2.f35] -anchor w
  label $lf2.f35.lwn -text $t(settings,fftWinKind) -width 20 -anchor w
  tk_optionMenu $lf2.f35.mwn v(window) \
    Hamming Hanning Bartlett Blackman Rectangle
  pack $lf2.f35.lwn $lf2.f35.mwn -side left

  ;#---------------------------
  ;# パワーの設定
  set lf3 [labelframe $frame1.lf3 -text $t(settings,pow) \
    -relief groove -padx 5 -pady 5]
  pack $lf3 -anchor w -fill x

  ;# パワー色の設定
  set cp [frame $lf3.f4p]
  setColor $cp "powcolor" $t(settings,powColor)
  pack $cp -anchor nw

  ;# パワー抽出刻みの設定
  packEntryPower $lf3.ffl $t(settings,powLength) frameLength

  ;# プリエンファシスの設定
  packEntryPower $lf3.fem $t(settings,powPreemph) preemphasis

  ;# 窓長の設定
  packEntryPower $lf3.fwl $t(settings,winLength) windowLength

  ;# 窓の選択
  pack [frame $lf3.fwn] -anchor w
  label $lf3.fwn.lwn -text $t(settings,powWinKind) -width 20 -anchor w
  tk_optionMenu $lf3.fwn.mwn power(window) \
    Hamming Hanning Bartlett Blackman Rectangle
  pack $lf3.fwn.lwn $lf3.fwn.mwn -side left

  ;#---------------------------
  ;#---------------------------
  ;# 2カラム目のフレーム
  set frame2 [frame $swindow.r]
  pack $frame2 -side left -anchor n -fill both -expand true -padx 2 -pady 2

  ;#---------------------------
  ;# F0の設定
  set lf4 [labelframe $frame2.lf4 -text $t(settings,f0) \
    -relief groove -padx 5 -pady 5]
  pack $lf4 -anchor w -fill x

  ;# F0色の設定
  set cf [frame $lf4.f4f]
  setColor $cf "f0color" $t(settings,f0Color)
  pack $cf -anchor nw

  ;# 抽出アルゴリズムの選択
  pack [frame $lf4.p1] -anchor w
  label $lf4.p1.l -text $t(settings,f0Argo) -width 20 -anchor w
  tk_optionMenu $lf4.p1.mt f0(method) ESPS AMDF
  pack $lf4.p1.l $lf4.p1.mt -side left

  ;# entry型の設定いろいろ
  packEntryF0 $lf4.p2 $t(settings,f0Length)    frameLength
  packEntryF0 $lf4.p3 $t(settings,f0WinLength) windowLength
  packEntryF0 $lf4.p4 $t(settings,f0Max)       max
  packEntryF0 $lf4.p5 $t(settings,f0Min)       min

  ;# 表示単位の選択
  pack [frame $lf4.p6] -anchor w
  label $lf4.p6.l -text $t(settings,f0Unit) -width 20 -anchor w
  tk_optionMenu $lf4.p6.mt f0(unit) Hz semitone
  pack $lf4.p6.l $lf4.p6.mt -side left

  ;# 各音の線を表示
  checkbutton  $lf4.p8cb -text $t(settings,grid) \
    -variable f0(showToneLine) -onvalue 1 -offvalue 0 -anchor w
  pack $lf4.p8cb -anchor w -fill x

  ;# グラフ範囲の設定
  checkbutton $lf4.p7cb -text $t(settings,f0FixRange) \
    -variable f0(fixShowRange) -onvalue 1 -offvalue 0 -anchor w
  pack [labelframe $lf4.p7 -labelwidget $lf4.p7cb \
    -relief ridge -padx 5 -pady 5] -anchor w -fill x
  packToneList $lf4.p7.tl1 $t(settings,f0FixRange,h) \
    showMaxTone showMaxOctave showMaxTmp 10 checkVol
  packToneList $lf4.p7.tl2 $t(settings,f0FixRange,l) \
    showMinTone showMinOctave showMinTmp 10 checkVol

  ;# ターゲット音の線を表示
  checkbutton $lf4.p9cb -text $t(settings,target) \
    -variable f0(showTgtLine) -onvalue 1 -offvalue 0 -anchor w
  pack [labelframe $lf4.p9 -labelwidget $lf4.p9cb \
    -relief ridge -padx 5 -pady 5] -anchor w -fill x
  packToneList $lf4.p9.tl $t(settings,targetTone) \
    tgtTone tgtOctave tgtFreqTmp 10 checkVol
  setColor $lf4.p9 "tgtf0color" $t(settings,targetColor)
  label  $lf4.p9.al -text $t(settings,autoSetting) -anchor nw
  button $lf4.p9.ab -text $t(.confm.run) -command autoF0Settings
  pack $lf4.p9.al $lf4.p9.ab -side left

  ;# 各音名に対応する周波数を自動計算して表示する(非常に汚いやり方)
  ;# 音名orオクターブに変化があれば周波数計算を行う
  ;# 周波数をf0(tgtFreq)などでなくf0(tgtFreqTmp)などに入れるのは、
  ;#「OK」or「適用」ボタンを押すまで値変更を反映させないため。
  set f0(showMaxTmp) [tone2freq "$f0(showMaxTone)$f0(showMaxOctave)"]
  set f0(showMinTmp) [tone2freq "$f0(showMinTone)$f0(showMinOctave)"]
  set f0(tgtFreqTmp) [tone2freq "$f0(tgtTone)$f0(tgtOctave)"]
  trace variable f0 w calcFreq
  proc calcFreq {var elm mode} {
    global f0 t
    switch $elm {
      "showMaxTone" -
      "showMaxOctave" {
        set f0(showMaxTmp) [tone2freq "$f0(showMaxTone)$f0(showMaxOctave)"]
      }
      "showMinTone" -
      "showMinOctave" {
        set f0(showMinTmp) [tone2freq "$f0(showMinTone)$f0(showMinOctave)"]
      }
      "tgtTone" -
      "tgtOctave" {
        set f0(tgtFreqTmp) [tone2freq "$f0(tgtTone)$f0(tgtOctave)"]
      }
    }
  }
  bind $swindow <Destroy> { trace vdelete f0 w calcFreq }

  ;#---------------------------
  ;# OK, Apply, キャンセルボタン
  pack [frame $frame2.f] -anchor e -side bottom -padx 2 -pady 2
  button $frame2.f.exit -text $t(.confm.c) -command {
    array set v     [array get v_bk]     ;# パラメータを以前の状態に戻す
    array set power [array get power_bk] ;# パラメータを以前の状態に戻す
    array set f0    [array get f0_bk]    ;# パラメータを以前の状態に戻す
    Redraw all
    destroy $swindow
  }
  button $frame2.f.app -text $t(.confm.apply) -command {
    ;# 空欄の補完
    if {![regexp {^[0-9]+$} $v(waveScale)]} {   ;# 空文字は×
      set v(waveScale) $v_bk(waveScale)
    }
    if {![regexp {^[0-9]+$} $v(sampleRate)]} {   ;# 空文字は×
      set v(sampleRate) $v_bk(sampleRate)
    }
    ;# サンプリング周波数の変更
    if {$v(sampleRate) != $v_bk(sampleRate)} {
      snd configure -rate $v(sampleRate)
      onsa  configure -rate $v(sampleRate)
      metro configure -rate $v(sampleRate)
      bgm   configure -rate $v(sampleRate)
      uttTiming(clickSnd)  configure -rate $v(sampleRate)
    }
    ;# ターゲット音の周波数を求める
    set f0(tgtFreq) [tone2freq "$f0(tgtTone)$f0(tgtOctave)"]
    ;# F0表示範囲周波数を求める
    if $f0(fixShowRange) {
      set f0(showMin) [tone2freq "$f0(showMinTone)$f0(showMinOctave)"]
      set f0(showMax) [tone2freq "$f0(showMaxTone)$f0(showMaxOctave)"]
    }
    Redraw all
    ;# パラメータバックアップの更新
    array set v_bk     [array get v]     ;# パラメータバックアップ
    array set power_bk [array get power] ;# パラメータバックアップ
    array set f0_bk    [array get f0]    ;# パラメータバックアップ
  }
  button $frame2.f.ok -text $t(.confm.ok) -wi 6 -command {
    ;# 空欄の補完
    if {![regexp {^[0-9]+$} $v(waveScale)]} {   ;# 空文字は×
      set v(waveScale) $v_bk(waveScale)
    }
    if {![regexp {^[0-9]+$} $v(sampleRate)]} {   ;# 空文字は×
      set v(sampleRate) $v_bk(sampleRate)
    }
    ;# サンプリング周波数の変更
    if {$v(sampleRate) != $v_bk(sampleRate)} {
      snd   configure -rate $v(sampleRate)
      onsa  configure -rate $v(sampleRate)
      metro configure -rate $v(sampleRate)
      bgm   configure -rate $v(sampleRate)
      uttTiming(clickSnd)  configure -rate $v(sampleRate)
    }
    ;# ターゲット音の周波数を求める
    set f0(tgtFreq) [tone2freq "$f0(tgtTone)$f0(tgtOctave)"]
    ;# F0表示範囲周波数を求める
    if $f0(fixShowRange) {
      set f0(showMin) [tone2freq "$f0(showMinTone)$f0(showMinOctave)"]
      set f0(showMax) [tone2freq "$f0(showMaxTone)$f0(showMaxOctave)"]
    }
    Redraw all
    destroy $swindow
  }
  pack $frame2.f.exit $frame2.f.app $frame2.f.ok -side right
}

#---------------------------------------------------
# F0ターゲットに合わせて他の設定値を自動設定する
#
proc autoF0Settings {} {
  global v f0

  set tgtFreq [tone2freq "$f0(tgtTone)$f0(tgtOctave)"]

  set f0(max) [expr int($tgtFreq * 2.1)]
  if {$tgtFreq >= 260} {
    set f0(min) [expr int($tgtFreq / 2.2)]
  } else {
    set f0(min) 60
  }

  set f0(fixShowRange) 1
  set ret [calcTone $f0(tgtTone) $f0(tgtOctave) 2]
  set f0(showMaxTone)   [lindex $ret 0]
  set f0(showMaxOctave) [lindex $ret 1]
  if {$f0(showMaxOctave) > $v(sinScaleMax)} {
    set f0(showMaxOctave) $v(sinScaleMax)
    set f0(showMaxTone)   [lindex $v(toneList) [expr [llength $v(toneList)] -1]]
  }
  set ret [calcTone $f0(tgtTone) $f0(tgtOctave) -2]
  set f0(showMinTone)   [lindex $ret 0]
  set f0(showMinOctave) [lindex $ret 1]
  if {$f0(showMinOctave) < $v(sinScaleMin)} {
    set f0(showMinOctave) $v(sinScaleMin)
    set f0(showMinTone)   [lindex $v(toneList) 0]
  }
  set f0(showMin) [tone2freq "$f0(showMinTone)$f0(showMinOctave)"]
  set f0(showMax) [tone2freq "$f0(showMaxTone)$f0(showMaxOctave)"]
}

#---------------------------------------------------
# tone-octaveをadd度？上げたときのトーンとオクターブのリストを返す
#
proc calcTone {tone octave add} {
  global v
  for {set i 0} {$i < [llength $v(toneList)]} {incr i} {
    if {$tone == [lindex $v(toneList) $i]} break
  }
  set seq [expr $i + $add]
  while {$seq >= [llength $v(toneList)]} {
    incr octave
    incr seq -12
  }
  while {$seq < 0} {
    incr octave -1
    incr seq +12
  }
  set ret {}
  lappend ret [lindex $v(toneList) $seq]
  lappend ret $octave
  return $ret
}

#---------------------------------------------------
# 窓幅を変える
#
proc changeWindowBorder {args} {
  global v sv c srec stype   ;# srec、stype にsetコマンドが送られるのでglobalしておく必要有

  if {$v(skipChangeWindowBorder)} return ;# 無効化されている場合はここで終了
  update

  # 引数処理
  array set a [list -w [winfo width .] -h [winfo height .] ]
  array set a $args

  if {$v(winWidth) == $a(-w) && $v(winHeight) == $a(-h)} return

  set winHeightOld $v(winHeight)
  set v(winWidth)  $a(-w)
  set v(winHeight) $a(-h)
  set cWidthOld $v(cWidth)
  # set v(cWidth)  [expr $a(-w) - $v(yaxisw) - 8]  ;# 4はキャンバス境界のマージン
  set v(cWidth)  [expr $a(-w) - [winfo width .s] - $v(yaxisw) - 8]  ;# 4はキャンバス境界のマージン
  set sndLength [snd length -unit SECONDS]
  if {$sndLength > 0} {
    set v(wavepps) [expr $v(cWidth) / $sndLength]  ;# wav全体を表示
  }
  set cHeightNew [expr $v(winHeight) - [winfo y .fig] - [winfo height .saveDir] - [winfo height .msg] - 4]
  set diff [expr $cHeightNew - $v(cHeight)]
  if {$diff > 0} {
    if {$v(f0h) > 0} {
      set v(f0h) [expr $v(f0h) + $diff]
    } elseif {$v(powh) > 0} {
      set v(powh) [expr $v(powh) + $diff]
    } elseif {$v(spech) > 0} {
      set v(spech) [expr $v(spech) + $diff]
    } elseif {$v(waveh) > 0} {
      set v(waveh) [expr $v(waveh) + $diff]
    }
  } elseif {$diff < 0} {
    if {$v(f0h) > 0} {
      set old $v(f0h)
      set v(f0h) [expr $v(f0h) + $diff]
      if {$v(f0h) < $v(f0hmin)    } { set v(f0h) $v(f0hmin) }
      set diff [expr $diff - ($v(f0h) - $old)]
    }
    if {$diff < 0 && $v(powh) > 0} {
      set old $v(powh)
      set v(powh) [expr $v(powh) + $diff]
      if {$v(powh) < $v(powhmin)  } { set v(powh) $v(powhmin) }
      set diff [expr $diff - ($v(powh) - $old)]
    }
    if {$diff < 0 && $v(spech) > 0} {
      set old $v(spech)
      set v(spech) [expr $v(spech) + $diff]
      if {$v(spech) < $v(spechmin)} { set v(spech) $v(spechmin) }
      set diff [expr $diff - ($v(spech) - $old)]
    }
    if {$diff < 0 && $v(waveh) > 0} {
      set old $v(waveh)
      set v(waveh) [expr $v(waveh) + $diff]
      if {$v(waveh) < $v(wavehmin)} { set v(waveh) $v(wavehmin) }
      set diff [expr $diff - ($v(waveh) - $old)]
    }
  }
  # set winHeightMinNew [expr [winfo y $c] + $v(timeh)]
  # if {$v(showWave)} { set winHeightMinNew [expr $winHeightMinNew + $v(wavehmin)] }
  # if {$v(showSpec)} { set winHeightMinNew [expr $winHeightMinNew + $v(spechmin)] }
  # if {$v(showPow) } { set winHeightMinNew [expr $winHeightMinNew + $v(powhmin) ] }
  # if {$v(showF0)  } { set winHeightMinNew [expr $winHeightMinNew + $v(f0hmin)  ] }
  # wm minsize . $sv(winWidthMin) $winHeightMinNew
  Redraw scale
  resizeListbox
}

#---------------------------------------------------
# キャンバス再描画
#
proc Redraw {opt} {
  global v c cYaxis snd power f0 rec t

  # 描画中は他の操作ができないようにする
  # grab set $c
  # ↑これがあると窓の隅をドラッグしてサイズ変更できなくなるのでボツ

  ;# キャンバス上のものを削除して高さを再調整する
  set v(cHeight) [expr $v(waveh) + $v(spech) + $v(powh) + $v(f0h) + $v(timeh)]
#  if {$v(cHeight) < [winfo height $rec]} {set v(cHeight) [winfo height $rec]}
  $c delete obj
  $c delete axis
  $c configure -height $v(cHeight) -width $v(cWidth)
  $c create line 0 0 $v(cWidth) 0 -tags axis -fill $v(fg)

  $cYaxis delete axis
  $cYaxis configure -height $v(cHeight)
  $cYaxis create line 0 2 $v(yaxisw) 2 -tags axis -fill $v(fg)
  $cYaxis create line $v(yaxisw) 0 $v(yaxisw) $v(cHeight) -tags axis -fill $v(fg)
  set sndLen [snd length -unit SECONDS]
  if {$sndLen > 0} {
    set v(wavepps) [expr double($v(cWidth)) / $sndLen]
  } else {
    set v(wavepps) [expr double(1.0 / $v(cWidth))]
  }

  ;# 波形表示
  if $v(showWave) {
    $c create waveform 0 0 -sound snd -height $v(waveh) -width $v(cWidth) \
      -tags [list obj wave] -debug $::debug -fill $v(wavColor) -limit $v(waveScale)
    $c lower wave
    if {$v(waveScale) > 0} {
      $cYaxis create text $v(yaxisw) 4 -text $v(waveScale) \
        -font $v(sfont) -anchor ne -tags axis -fill #0000b0
      $cYaxis create text $v(yaxisw) [expr $v(waveh) * 0.5] -text [snd max] \
        -font $v(sfont) -anchor se -tags axis -fill $v(fg)
      $cYaxis create text $v(yaxisw) [expr $v(waveh) * 0.5 + 14] -text [snd min] \
        -font $v(sfont) -anchor se -tags axis -fill $v(fg)
    } else {
      $cYaxis create text $v(yaxisw) 4 -text [snd max] \
        -font $v(sfont) -anchor ne -tags axis -fill $v(fg)
      $cYaxis create text $v(yaxisw) $v(waveh) -text [snd min] \
        -font $v(sfont) -anchor se -tags axis -fill $v(fg)
    }

    set ylow $v(waveh)
    $c create line 0 $ylow $v(cWidth) $ylow -tags axis -fill $v(fg)
    set yAxisLow [expr $v(waveh) + 0]
    $cYaxis create line 0 $yAxisLow $v(yaxisw) $yAxisLow -tags axis -fill $v(fg)
#    $c create line $v(yaxisw) 0 $v(yaxisw) $v(waveh) -tags axis -fill $v(fg)
  }

  ;# スペクトル表示
  if $v(showSpec) {
    if {$v(winlen) > $v(fftlen)} {
      set v(winlen) $v(fftlen)
    }
    $c create spectrogram 0 $v(waveh) -sound snd -height $v(spech) \
      -width $v(cWidth) -tags [list obj spec] -debug $::debug \
      -fftlength $v(fftlen) -winlength $v(winlen) -windowtype $v(window) \
      -topfr $v(topfr) -contrast $v(contrast) -brightness $v(brightness) \
      -preemph $v(preemph) -colormap $v($v(cmap)) -topfrequency $v(topfr)
    $c lower spec
    snack::frequencyAxis $cYaxis 0 $v(waveh) $v(yaxisw) $v(spech) \
          -topfr $v(topfr) -tags axis -font $v(sfont)
    set ylow [expr $v(spech) + $v(waveh)]
    $c create line 0 $ylow $v(cWidth) $ylow -tags axis
    set yAxisLow [expr $ylow + 0]
    $cYaxis create line 0 $yAxisLow $v(yaxisw) $yAxisLow -tags axis -fill $v(fg)
#    $c create line $v(yaxisw) $v(waveh) $v(yaxisw) $ylow -tags axis -fill $v(fg)
  }

  ;# パワー表示
  if $v(showpow) {
    set sndPow snd
    ;# 量子化ビットが16bit以外の場合の対応(16bitにする)
    if {[snd cget -encoding] != "Lin16"} {
      set sndPow [snack::sound _sndPow]
      $sndPow copy snd
      switch [snd cget -encoding] {
        # "Lin24" { $sndPow filter [snack::filter map [expr 65535.0 / 16777215.0  ]] }
        # "Lin32" { $sndPow filter [snack::filter map [expr 65535.0 / 4294967295.0]] }
        "Float" { $sndPow filter [snack::filter map 65535.0] }
      }
    }
    ;# パワーを抽出
    set ytop [expr $v(waveh) + $v(spech)]
    set ylow [expr $ytop     + $v(powh)]
    if {$opt == "all" || $opt == "pow"} {
      set power(power) [$sndPow power -framelength $power(frameLength) \
      -windowtype $power(window) -preemphasisfactor $power(preemphasis) \
      -windowlength [expr int($power(windowLength) * $v(sampleRate))] \
      -start 0 -end -1]
    }

    set pwN [llength $power(power)]
    if {$pwN > 0} {
      # パワーの最大値・最小値を求める
      if {$opt == "all" || $opt == "pow"} {
        set power(powerMax) [lindex $power(power) 0]
        set power(powerMin) [lindex $power(power) 0]
        for {set i 1} {$i < $pwN} {incr i} {
          if {$power(powerMax) < [lindex $power(power) $i]} {
            set power(powerMax) [lindex $power(power) $i]
          }
          if {$power(powerMin) > [lindex $power(power) $i]} {
            set power(powerMin) [lindex $power(power) $i]
          }
        }
      }

      # ppd= 1dBあたりのピクセル数。
      if {[expr $power(powerMax) - $power(powerMin)] > 0} {
        set ppd [expr double($v(powh)) / ($power(powerMax) - $power(powerMin))]
      } else {
        set ppd 0
      }

      set pwXold 0
      set pwYold [expr $ylow - ([lindex $power(power) 0] - $power(powerMin)) * $ppd]
      set a [expr $power(frameLength) * $v(wavepps)]
      for {set i 0} {$i < $pwN} {incr i} {
        set pwX [expr $i * $a]
        set pwY [expr $ylow - ([lindex $power(power) $i] - $power(powerMin)) * $ppd]
        $c create line $pwXold $pwYold $pwX $pwY -tags {obj pow} -fill $v(powcolor)
        set pwXold $pwX
        set pwYold $pwY
      }

      myAxis $cYaxis 0 $ytop $v(yaxisw) $v(powh) \
        -max $power(powerMax) -tags axis -fill $v(fg) \
        -font $v(sfont) -min $power(powerMin) -unit dB
    }
    $c create line 0 $ylow $v(cWidth) $ylow -tags axis
#    $c create line $v(yaxisw) $ytop $v(yaxisw) $ylow -tags axis -fill $v(fg)
    set yAxisLow [expr $ylow + 0]
    $cYaxis create line 0 $yAxisLow $v(yaxisw) $yAxisLow -tags axis -fill $v(fg)

    ;# パワーを抽出したならそのFIDを記録する
    if {$power(fid) != $v(recLab)} {
      set power(fid) $v(recLab)
    }
  }

  ;# F0表示
  if $v(showf0) {
    set ytop [expr $v(waveh) + $v(spech) + $v(powh)]
    set ylow [expr $ytop + $v(f0h)]
    ;# F0を抽出
    if {$opt == "all" || $opt == "f0"} {
      ;# F0抽出用に波形を正規化する(小声やInt16以外の形式に対応させるため)
      snack::sound sndF0
      sndF0 copy snd
      if {[sndF0 cget -channels] > 1} {
        set sndF0 [sndF0 convert -channels Mono]
      }
      set amp [expr [sndF0 max] - [sndF0 min]]
      if {$amp > 0} {
        sndF0 filter [snack::filter map [expr 65535.0 / $amp]]
      }
      ;# F0を抽出する
      set seriestmp {}
      if {[catch {set seriestmp [sndF0 pitch -method $f0(method) \
        -framelength $f0(frameLength) -windowlength $f0(windowLength) \
        -maxpitch $f0(max) -minpitch $f0(min) \
        -progress waitWindow] } ret]} {
        if {$ret != ""} {
          puts "error: $ret"
        }
        set seriestmp {}
      }
      set f0(f0) {}
      foreach s $seriestmp {
        set val [lindex [split $s " "] 0]
        if {$f0(unit) == "semitone" && $val > 0} {
          set val [hz2semitone $val]
        }
        lappend f0(f0) $val
      }
    }

    if {[llength $f0(f0)] > 0} {
      # F0の最大値・最小値を求める
      if {$opt == "all" || $opt == "f0"} {
        set f0(extractedMax) [lindex $f0(f0) 0]
        set f0(extractedMin) [lindex $f0(f0) 0]
        for {set i 1} {$i < [llength $f0(f0)]} {incr i} {
          if {$f0(extractedMax) < [lindex $f0(f0) $i]} {
            set f0(extractedMax) [lindex $f0(f0) $i]
          }
          if {$f0(extractedMin) > [lindex $f0(f0) $i] && [lindex $f0(f0) $i] > 0 ||
              $f0(extractedMin) <= 0} {
            set f0(extractedMin) [lindex $f0(f0) $i]
          }
        }
      }
      # 描画するスケールを決める
      if {$f0(fixShowRange)} {
        set f0(extractedMax) $f0(showMax)
        set f0(extractedMin) $f0(showMin)
        if {$f0(unit) == "semitone"} {
          if {$f0(extractedMax) > 0} { set f0(extractedMax) [hz2semitone $f0(extractedMax)] }
          if {$f0(extractedMin) > 0} { set f0(extractedMin) [hz2semitone $f0(extractedMin)] }
        }
#      } else {
#        set f0(extractedMin) $f0(min)  ;# あえてf0(min)にしている
#        if {$f0(unit) == "semitone"} {
#          if {$f0(extractedMin) > 0} { set f0(extractedMin) [hz2semitone $min] }
#        }
      }

      if {$f0(extractedMax) > $f0(extractedMin) && $f0(extractedMin) >= 0} {
        # ppd= 1Hzあたりのピクセル数。4は上下各2ピクセルのマージン
        set ppd [expr double($v(f0h)) / ($f0(extractedMax) - $f0(extractedMin))]

        # 各音に対応する周波数で横線を引く
        if $f0(showToneLine) {
          for {set i 0} {$i < [llength $v(sinScale)]} {incr i} {
            if {$f0(unit) == "semitone"} {
              set tgt [hz2semitone [lindex $v(sinScale) $i]]
            } else {
              set tgt [lindex $v(sinScale) $i]
            }
            set y1 [expr $ylow - ($tgt - $f0(extractedMin)) * $ppd]
            if {$y1 <= [expr $ylow - $v(f0h)]} break
            if {$y1 < $ylow} {
              set tt  [expr $i % 12]
              if {$tt == 1 || $tt == 3 || $tt == 6 || $tt == 8 || $tt == 10} {
                $c create line 0 $y1 $v(cWidth) $y1 -tags axis -fill #50c0f0 -stipple gray50
              } else {
                $c create line 0 $y1 $v(cWidth) $y1 -tags axis -fill #f0c0a0
              }
            }
          }
        }

        # ターゲット線をひく
        if $f0(showTgtLine) {
          if {$f0(unit) == "semitone"} {
            set tgt [hz2semitone $f0(tgtFreq)]
          } else {
            set tgt $f0(tgtFreq)
          }
          set y1 [expr $ylow - ($tgt - $f0(extractedMin)) * $ppd ]
          if {$y1 <= $ylow && $y1 >= [expr $ylow - $v(f0h)]} {
            $c create text [expr 0 + 2] $y1 \
              -text "$f0(tgtTone)$f0(tgtOctave)" -fill $v(tgtf0color) \
              -font smallkfont -anchor w -tags {axis tgtName}
            $c create line [lindex [$c bbox tgtName] 2] $y1 $v(cWidth) $y1 -tags axis \
              -fill $v(tgtf0color)
          }
        }

        # F0データをプロットする
        # set coord {} ;# F0曲線を引く座標(x,y)列
        set f0tags {obj f0}
        set a  [expr $f0(frameLength) * $v(wavepps)]
        set a2 [expr $ylow - $v(f0h)]
        for {set i 0} {$i < [llength $f0(f0)]} {incr i} {
          # lappend coord \
          #   [expr $i * $f0(frameLength) * $v(wavepps)] \
          #   [expr $ylow - ([lindex $f0(f0) $i] - $f0(f0Min)) * $ppd]
          if {[lindex $f0(f0) $i] > 0} {
            set x1 [expr $i * $a - 2]
            set y1 [expr $ylow - ([lindex $f0(f0) $i] - $f0(extractedMin)) * $ppd - 2]
            set x2 [expr $x1 + 3]
            set y2 [expr $y1 + 3]
            if {$y1 <= $ylow && $y1 >= $a2} {
              $c create oval $x1 $y1 $x2 $y2 -tags $f0tags -fill $v(f0color)
            }
          }
        }
      }
#      eval {$c create line} $coord -tags {$f0tags} -fill $v(f0color)
      myAxis $cYaxis 0 $ytop $v(yaxisw) $v(f0h) \
        -tags axis -fill $v(fg) -font $v(sfont) \
        -max $f0(extractedMax) -min $f0(extractedMin) -unit $f0(unit)

    }
    # 下線
    $c create line 0 $ylow $v(cWidth) $ylow -tags axis
#    $c create line $v(yaxisw) $ytop $v(yaxisw) $ylow -tags axis -fill $v(fg)
#    set yAxisLow [expr $ylow + 2]
#    $cYaxis create line 0 $yAxisLow $v(yaxisw) $yAxisLow -tags axis -fill $v(fg)

    ;# F0を抽出したならFIDを記録する
    if {$f0(fid) != $v(recLab)} {
      set f0(fid) $v(recLab)
    }
  }

  ;# 時間軸表示
  if {$v(showWave) || $v(showSpec) || $v(showpow) || $v(showf0)} {
    set ytop [expr $v(waveh) + $v(spech) + $v(powh) + $v(f0h)]
    set ylow [expr $ytop + $v(timeh)]
    snack::timeAxis $c 0 $ytop $v(cWidth) $v(timeh) $v(wavepps) \
      -tags axis -starttime 0 -fill $v(fg)
    $c create line 0 $ylow $v(cWidth) $ylow -tags axis
  }

  ;# grabを解放
  ;#  grab release $c
}

#---------------------------------------------------
# 録音開始
#
proc recStart {} {
  global snd v bgmParam paDev t
  if {$v(rec) == 0 || $v(recNow)} return   ;# 収録モードでない、または既に録音中なら終了
  if {$v(rec) >= 2} {
    ;# 自動収録の場合
    if {$bgmParam(autoRecStatus) == 0} {
      autoRecStart
    } else {
      autoRecStop
    }
  } else {
    ;# 手動収録(ver.1.0の方法)の場合
    set v(msg) $t(recStart,msg)
    if {$paDev(useRec)} {
      putsPa rec "rec"    ;# PortAudio使用時の録音開始
      set ret [getsPa rec]
      if {![regexp {^Success} $ret]} {
        tk_messageBox -message "$t(recStart,errPa)\n$ret" -title $t(.confm.errTitle) -icon warning
        return
      }
    } else {
      snd configure -channels Mono -rate $v(sampleRate) -fileformat WAV -encoding Lin16
      snd record             ;# snack使用時の録音開始
    }
    set v(recStatus) 1
    set v(recNow) 1
  }
}

#---------------------------------------------------
# 録音終了
#
proc recStop {} {
  global snd v t paDev
  if {$v(rec) != 1 || $v(recNow) == 0} return   ;# 手動収録モードでないまたは録音中でないなら終了
  set v(msg) $t(recStop,msg)
  if {$paDev(useRec)} {
    putsPa rec "stop"    ;# PortAudio使用時の録音停止
    set ret [getsPa rec]
    if {![regexp {^Success} $ret]} {
      tk_messageBox -message "$t(recStop,errPa)\n$ret" -title $t(.confm.errTitle) -icon warning
      return
    }
    if {[file readable $paDev(recWav)]} {
      snd read $paDev(recWav)
      if {$paDev(usePlay)} {
        putsPa play "wav $paDev(recWav)"
        set ret [getsPa play]
      }
    }
  } else {
    snd stop               ;# snack使用時の録音停止
  }
  if $v(removeDC) removeDC
  set v(recNow) 0
  Redraw all
}

#---------------------------------------------------
# 原音パラメータ値の初期化
#
proc initParamS {} {
  global paramS v t

  array unset paramS
}

#---------------------------------------------------
# ParamUを初期化
#
proc initParamU {{clean 0} {recList {}}} {
  global paramU v paramUsize t

  if {[llength $recList] <= 0} {
    set recList $v(recList)
  }

  array unset paramU
  set paramU(0,0) $t(initParamU,0)
  set paramU(0,1) $t(initParamU,1)
  set paramU(0,2) $t(initParamU,2)
  set paramU(0,3) $t(initParamU,3)
  set paramU(0,4) $t(initParamU,4)
  set paramU(0,5) $t(initParamU,5)
  set paramU(0,6) $t(initParamU,6)
  set paramUsize 1
  set paramU(size_1) 0   ;# 表示用に行数-1した値を保存
  if $clean return  ;# もし配列サイズを0にする初期化ならここで終了
  for {set i 0} {$i < [llength $recList]} {incr i} {
    set fid [lindex $recList $i]

    ;# 表に表示するデータを設定
    set paramU($paramUsize,0) $fid

    ;# 内部で参照するデータを設定
    set paramU($paramUsize,R) $i    ;# 行番号→recListの配列番号

    incr paramUsize
  }
  ;# 一覧表のサイズを更新する
  if {$v(appname) != "OREMO" && [winfo exists .entpwindow]} {
    .entpwindow.t configure -rows $paramUsize
  }
  set paramU(size_1) [expr $paramUsize - 1]   ;# 表示用に行数-1した値を保存
}

#---------------------------------------------------
# ファイルを保存して終了
#
proc Exit {} {
  global v paDev startup t
#  if $v(paramChanged) {
#    set act [tk_dialog .confm $t(.confm) $t(Exit,q1) \
#      question 2 $t(Exit,a1) $t(Exit,a2) $t(Exit,a3)]
#    switch $act {
#      0 {                      ;# 保存して終了する場合
#          if ![saveParamFile] {
#            return  ;# もしここで保存しなかったら終了中止。
#          }
#        }
#      1 { }                    ;# 保存せず終了する場合
#      2 { return }             ;# 終了しない場合
#    }
#  }

  if $v(recStatus) {
    set act [tk_dialog .confm $t(.confm) $t(Exit,q2) \
      question 2 $t(Exit,a1) $t(Exit,a2) $t(Exit,a3)]
    if {$act == 2} {
      return
    } elseif {$act == 0} {
      saveWavFile
    }
  }
  saveCommentList

  paPlayTerminate ;# 再生ツールを終了
  paRecTerminate  ;# 録音ツールを終了
  if {[file exists $paDev(recWav)]} {
    file delete $paDev(recWav)
  }

  if {$v(autoSaveInitFile)} {
    saveSettings $startup(initFile)
  }
  destroy .
}

proc exit {} {Exit}

#---------------------------------------------------
# 右クリックメニュー
#
proc PopUpMenu {X Y x y} {
  global v rclickMenu t

  $rclickMenu delete 0 end
  $rclickMenu add checkbutton -variable v(showWave) \
    -label $t(PopUpMenu,showWave) -command toggleWave
  $rclickMenu add checkbutton -variable v(showSpec) \
    -label $t(PopUpMenu,showSpec) -command toggleSpec
  $rclickMenu add checkbutton -variable v(showpow) \
    -label $t(PopUpMenu,showPow) -command togglePow
  $rclickMenu add checkbutton -variable v(showf0) \
    -label $t(PopUpMenu,showF0) -command toggleF0
  $rclickMenu add command -label $t(PopUpMenu,pitchGuide) -command pitchGuide
  $rclickMenu add command -label $t(PopUpMenu,tempoGuide) -command tempoGuide
  $rclickMenu add command -label $t(PopUpMenu,settings)   -command settings

  catch {tk_popup $rclickMenu $X $Y}
}

#---------------------------------------------------
# バージョン情報表示
#
proc Version {} {
  global v t
  tk_messageBox -title $t(Version,msg) -message "$v(appname) version $v(version)"
}

#---------------------------------------------------
# リストボックスウィジット w を d だけスクロールさせる(Windows版)
# +/-120 は Windows でホイールを1つ動かした際に%Dにセットされる値
#
proc listboxScroll {w d} {
  if {$w ne ""} {
    $w yview scroll [expr -$d / 120] units
  }
}

#---------------------------------------------------
# usage
#
proc usage {} {
  global argv0 t
  puts "usage: $argv0 \[-d saveDir|-f initScript\]"
}


