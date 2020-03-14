#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

#---------------------------------------------------
# サブルーチン


#---------------------------------------------------
# oto.ini生成前に未保存wavが無いか調べる
#
proc checkWavForOREMO {} {
  global v t

  ;# 現在表示中のwavファイルが保存済みかチェック
  if $v(recStatus) {
    set act [tk_dialog .confm $t(.confm) $t(checkWavForOREMO,saveQ) \
      question 2 $t(checkWavForOREMO,saveA1) \
      $t(checkWavForOREMO,saveA2) $t(checkWavForOREMO,saveA3)]
    if {$act == 2} {
      return
    } elseif {$act == 0} {
      saveWavFile
    }
  }
}

#---------------------------------------------------
# 自動収録した連続発声からoto.iniを生成
#
proc genParam {} {
  global v genWindow genParam t

  if [isExist $genWindow] return ;# 二重起動を防止
  toplevel $genWindow
  wm title $genWindow $t(genParam,title)
  bind $genWindow <Escape> "destroy $genWindow"

  set r 0

  # 初期設定
  set f($r) [labelframe $genWindow.f($r) -relief groove -padx 5 -pady 5]

  label $f($r).lB  -text $t(genParam,tempo)
  entry $f($r).eB  -textvar genParam(bpm) -wi 10
  label $f($r).lBU -text $t(genParam,bpm)

  label $f($r).lS  -text $t(genParam,S)
  entry $f($r).eS  -textvar genParam(S) -wi 10
  label $f($r).lSU -text $t(genParam,unit)
  tk_optionMenu $f($r).mSU genParam(SU) msec $t(genParam,haku)

  grid  $f($r).lB  -row 0 -column 0 -sticky nse
  grid  $f($r).eB  -row 0 -column 1 -sticky nse
  grid  $f($r).lBU -row 0 -column 2 -sticky nsw -columnspan 2
  grid  $f($r).lS  -row 1 -column 0 -sticky nse
  grid  $f($r).eS  -row 1 -column 1 -sticky nse
  grid  $f($r).lSU -row 1 -column 2 -sticky nsw
  grid  $f($r).mSU -row 1 -column 3 -sticky nsw
  incr r

  # ボタン
  set f($r) [frame $genWindow.f($r) -padx 5 -pady 0]
  label  $f($r).arrow1 -text $t(genParam,darrow)
  button $f($r).bInit  -text $t(genParam,bInit)  -command initGenParam
  label  $f($r).arrow2 -text $t(genParam,darrow)

  grid  $f($r).arrow1 -row 0 -column 0 -sticky nsew
  grid  $f($r).bInit  -row 1 -column 0 -sticky nsew
  grid  $f($r).arrow2 -row 2 -column 0 -sticky nsew
  incr r

  # msec単位での各設定
  set f($r) [labelframe $genWindow.f($r) -relief groove -padx 5 -pady 5]
  label $f($r).lO  -text $t(genParam,O)
  entry $f($r).eO  -textvar genParam(O) -wi 10
  label $f($r).lOU -text $t(genParam,msec)

  label $f($r).lP  -text $t(genParam,P)
  entry $f($r).eP  -textvar genParam(P) -wi 10
  label $f($r).lPU -text $t(genParam,msec)

  label $f($r).lC  -text $t(genParam,C)
  entry $f($r).eC  -textvar genParam(C) -wi 10
  label $f($r).lCU -text $t(genParam,msec)

  label $f($r).lE  -text $t(genParam,E)
  entry $f($r).eE  -textvar genParam(E) -wi 10
  label $f($r).lEU -text $t(genParam,msec)

  grid  $f($r).lO    -row 0 -column 0 -sticky nse
  grid  $f($r).eO    -row 0 -column 1 -sticky nse
  grid  $f($r).lOU   -row 0 -column 2 -sticky nse
  grid  $f($r).lP    -row 1 -column 0 -sticky nse
  grid  $f($r).eP    -row 1 -column 1 -sticky nse
  grid  $f($r).lPU   -row 1 -column 2 -sticky nse
  grid  $f($r).lC    -row 2 -column 0 -sticky nse
  grid  $f($r).eC    -row 2 -column 1 -sticky nse
  grid  $f($r).lCU   -row 2 -column 2 -sticky nse
  grid  $f($r).lE    -row 3 -column 0 -sticky nse
  grid  $f($r).eE    -row 3 -column 1 -sticky nse
  grid  $f($r).lEU   -row 3 -column 2 -sticky nse
  incr r

  # パワーに基づく先行発声位置の自動推定用の設定窓
  set f($r) [labelframe $genWindow.f($r) -relief groove -padx 5 -pady 5]
  checkbutton $f($r).cb -variable genParam(autoAdjustRen) -text $t(genParam,autoAdjustRen)
  label $f($r).lv  -text $t(genParam,vLow)
  entry $f($r).ev  -textvar genParam(vLow) -wi 10
  label $f($r).lvu -text $t(genParam,db)
  label $f($r).ls  -text $t(genParam,sRange)
  entry $f($r).es  -textvar genParam(sRange) -wi 10
  label $f($r).lsu -text $t(genParam,msec)
  label $f($r).lb -text $t(genParam,f0pow)

  grid  $f($r).cb  -row 0 -column 0 -sticky nsw -columnspan 3
  grid  $f($r).lv  -row 1 -column 0 -sticky nse
  grid  $f($r).ev  -row 1 -column 1 -sticky nse
  grid  $f($r).lvu -row 1 -column 2 -sticky nsw
  grid  $f($r).ls  -row 2 -column 0 -sticky nse
  grid  $f($r).es  -row 2 -column 1 -sticky nse
  grid  $f($r).lsu -row 2 -column 2 -sticky nsw
  grid  $f($r).lb  -row 3 -column 0 -sticky nsw -columnspan 3
  incr r

  # MFCCに基づく先行発声位置の自動推定の設定窓
  set f($r) [labelframe $genWindow.f($r) -relief groove -padx 5 -pady 5]
  checkbutton $f($r).cb -variable genParam(autoAdjustRen2) -text $t(genParam,autoAdjustRen2)
  label $f($r).lv  -text $t(genParam,autoAdjustRen2Opt)
  entry $f($r).ev  -textvar genParam(autoAdjustRen2Opt) -wi 35
  label $f($r).lm  -text $t(genParam,autoAdjustRen2Pattern)
  entry $f($r).em  -textvar genParam(autoAdjustRen2Pattern) -wi 35

  grid  $f($r).cb  -row 0 -column 0 -sticky nsw -columnspan 3
  grid  $f($r).lv  -row 1 -column 0 -sticky nse
  grid  $f($r).ev  -row 1 -column 1 -sticky nsew -columnspan 2
  grid  $f($r).lm  -row 2 -column 0 -sticky nse
  grid  $f($r).em  -row 2 -column 1 -sticky nsew -columnspan 2
  incr r

  # エイリアス重複に関する設定欄
  set f($r) [labelframe $genWindow.f($r) -relief groove -padx 5 -pady 5]

  set genParam(useAliasMax) 0  ;# 0=重複をそのままにする,1=通し番号を付ける
  set genParam(aliasMax) 0     ;# 重複番号の最大値
  label $f($r).lt -text $t(genParam,aliasMax)
  radiobutton $f($r).rm1 -variable genParam(useAliasMax) -value  0 -text $t(genParam,aliasMaxNo)
  radiobutton $f($r).rm2 -variable genParam(useAliasMax) -value  1 -text $t(genParam,aliasMaxYes)
  label $f($r).ll   -text $t(genParam,aliasMaxNum)
  entry $f($r).e    -textvar genParam(aliasMax) -wi 10

  grid $f($r).lt    -row 0 -column 0 -sticky nsw
  grid $f($r).rm1   -row 1 -column 0 -sticky nsw
  grid $f($r).rm2   -row 1 -column 1 -sticky nsw
  grid $f($r).ll    -row 2 -column 0 -sticky nse
  grid $f($r).e     -row 2 -column 1 -sticky nse
  incr r

  # 実行ボタン
  set f($r) [frame $genWindow.f($r) -padx 5 -pady 0]

  label  $f($r).arrow2 -text $t(genParam,darrow)
  button $f($r).bs -text $t(genParam,do) -command {
    if {$v(appname) == "OREMO"} {
      doGenParamForOREMO
      set v(paramFile) "$v(saveDir)/oto.ini"
      saveParamFile
    } else {
      doGenParam
    }
    destroy $genWindow
  }
  button $f($r).bc -text $t(.confm.c) -command {destroy $genWindow}

  grid  $f($r).arrow2 -row 0 -column 0 -columnspan 2 -sticky nsew
  grid  $f($r).bs     -row 1 -column 0 -sticky nsew
  grid  $f($r).bc     -row 1 -column 1 -sticky nsew
  incr r

  for {set i 0} {$i < $r} {incr i} {
    pack $f($i) -anchor nw -padx 2 -pady 2 -expand 1 -fill x
  }

  raise $genWindow
  focus $genWindow
}

#---------------------------------------------------
# BPM、冒頭Sからパラメータの初期値を求める
#
proc initGenParam {} {
  global genParam t

  set mspb [expr 60000.0 / $genParam(bpm)]  ;# 1拍の長さ[msec]を求める

  set genParam(O) [cut3 [expr $mspb / 6.0]]
  set genParam(P) [cut3 [expr $mspb / 2.0]]
  set genParam(C) [cut3 [expr $mspb * 3.0 / 4.0]]
  set genParam(E) [cut3 [expr - ($mspb + $genParam(O)) ]]
  set genParam(sRange) $genParam(P)
  ;#set genParam(E) [cut3 [expr - $mspb ]]
}

#---------------------------------------------------
# 連続発声の先頭モーラの先行発声位置を推定し、
# 先行発声がその場所になるための補正量(sec)を返す
# Porg, rangeの単位：sec。Porg-range～Porg+rangeの範囲を探索する
#
proc autoAdjustRen {fid Porg range} {
  global v t f0 power genParam

  snack::sound sWork
  if {[file exists "$v(saveDir)/$fid.$v(ext)"]} {
    sWork read "$v(saveDir)/$fid.$v(ext)"
    if {[sWork cget -channels] > 1} {
      sWork convert -channels Mono
    }
    if {$v(appname) == "OREMO"} {
      set v(sndLength) [sWork length -unit SECONDS]
    }
  }

  if {$Porg > $range} {
    set Lsec [expr $Porg - $range]
  } else {
    set Lsec 0
  }

  ;# 有声開始位置を求める
  set seriestmp {}
  set start [expr int($Lsec * $v(sampleRate))]
  set end   [expr int(($Porg + $range) * $v(sampleRate))]
  if {[catch {set seriestmp [sWork pitch -method $f0(method) \
    -framelength $f0(frameLength) -windowlength $f0(windowLength) \
    -maxpitch $f0(max) -minpitch $f0(min) \
    -start $start -end $end \
    ] } ret]} {
    if {$ret != ""} {
      puts "error: $ret"
    }
    set seriestmp {}
  }
  set f0old 1
  for {set i 0} {$i < [llength $seriestmp]} {incr i} {
    set f0now [lindex [split [lindex $seriestmp $i] " "] 0]
    if {$f0old <= 0 && $f0now > 0} break  ;# 直前が無声、当該が有声ならbreak
    set f0old $f0now
  }
  if {$i < [llength $seriestmp]} {
    ;# 有声開始点であればそこを先行発声候補とし、更に次のパワーに基づく
    ;# 探索開始点にする
    set Pnew [expr $i * $f0(frameLength) + $Lsec]
    set Lsec $Pnew
    set start [expr int($Lsec * $v(sampleRate))]   ;# end はF0と同じ
  } else {
    set Pnew $Porg
  }

  ;# 固定範囲～右ブランク間の平均パワーavePを求める。ただし値が30個以上なら
  ;# 30個で平均を求める
  set Nmax 30
  set N 0
  set aveP 0
  set avePstart [expr int(($Pnew + ($genParam(C) - $genParam(P)) / 1000.0) * $v(sampleRate))]
  set avePend   [expr int(($Pnew + (abs($genParam(E)) - $genParam(P)) / 1000.0) * $v(sampleRate))]
  set pw [sWork power -framelength $power(frameLength) \
    -windowtype $power(window) -preemphasisfactor $power(preemphasis) \
    -windowlength [expr int($power(windowLength) * $v(sampleRate))] \
    -start $start -end $end]
  for {set i 0} {$i < [llength $pw] && $i < $Nmax} {incr i} {
    set aveP [expr $aveP + [lindex $pw $i]]
    incr N
  }
  if {$N > 0} {
    set aveP [expr $aveP / $N]
  }

  ;# 探索区間のパワーを求める
  set pw [sWork power -framelength $power(frameLength) \
    -windowtype $power(window) -preemphasisfactor $power(preemphasis) \
    -windowlength [expr int($power(windowLength) * $v(sampleRate))] \
    -start $start -end $end]

  ;# 閾値に対してパワー曲線が右上がりにクロスする点を探す
  ;# votから右に行き、パワーが右上がりに閾値を超える所まで移動する
  ;# そのような場所が複数ある場合は凹みがより深いものにする
  set vLow [expr $aveP - $genParam(vLow)]
  set powOld $vLow
  set pn -1                         ;# 先行発声位置を入れる変数
  set pnMin     10001               ;# 先行発声前の凹みの深さ
  set powNowMin 10000
  for {set i 0} {$i < [llength $pw]} {incr i} {
    set powNow [lindex $pw $i]
    if {$powNow < $powNowMin} {
      set powNowMin $powNow         ;# 凹みの値を求めていく
    }
    if {$powOld < $vLow && $powNow >= $vLow && $powNowMin < $pnMin} {
      set pn $i
      set pnMin $powNowMin       ;# 凹みの値を保存
      set powNowMin 10000        ;# 再初期化
    }
    set powOld $powNow
  }

  #if {$pn < 0 && [expr $genParam(avePPrev) - $genParam(vLow) - $aveP] > 0} {
  #  ;# パワー凹みを見つけられず、かつ先行モーラより当該モーラの平均パワーがある程度小さい場合、
  #  ;# votから右に行き、パワー曲線が当該モーラの平均パワーにクロスする点を探す
  #  for {set i 0} {$i < [llength $pw]} {incr i} {
  #    set powNow [lindex $pw $i]
  #    if {$powNow <= $aveP} {
  #      set pn $i
  #      break
  #    }
  #  }
  #}

  if {$pn >= 0} {
    set Pnew [expr $pn * $power(frameLength) + $Lsec]
  }

#koko,もう一つ規則を作るなら、上記パワーの凹みが検出できない場合に
#現在のPnewの直近の凹み(x(i-1) >= x(i) < x(i+1) なi)を探すとか。

#koko,平均パワーが先行モーラより大きい場合の規則。

  set genParam(avePPrev) $aveP    ;# 次回の推定のために平均パワーを保存
 
  ;# 現在位置が先行発声になるための補正量(sec)を返す
  return [expr $Pnew - $Porg]
}

#---------------------------------------------------
# もしSが負なら他のパラメータ位置が変わらないようにS=0にする
# ※本ルーチンは連続音用(genParam用)
# ※本ルーチンではparamUのみ訂正し、paramSには反映させないことに注意
#
proc setSto0 {r} {
  global paramU

  if {$paramU($r,1) < 0} {     ;# S < 0 なら
    ;# E(負) の値を修正
    set paramU($r,5) [cut3 [expr $paramU($r,5) - $paramU($r,1)]]
    ;# C の値を修正
    set paramU($r,4) [cut3 [expr $paramU($r,4) + $paramU($r,1)]]
    ;# P の値を修正
    set paramU($r,3) [cut3 [expr $paramU($r,3) + $paramU($r,1)]]
    ;# O の値を修正
    set paramU($r,2) [cut3 [expr $paramU($r,2) + $paramU($r,1)]]
    if {$paramU($r,2) < 0} {
      set paramU($r,2) 0
    }
    ;# S を0にする
    set paramU($r,1) 0
  }
}

#---------------------------------------------------
# 連続発声のパラメータを自動生成する(OREMO用)
#
proc doGenParamForOREMO {} {
  global genParam v paramS paramU paramUsize t

  set recList {}
  foreach filename [glob -nocomplain [format "%s/*.$v(ext)" $v(saveDir)]] {
    set filename [file rootname [file tail $filename]]
    if {$filename == ""} continue
    lappend recList $filename
  }
  initParamS
  initParamU 1
  snack::sound sWork

  set mspb [expr 60000.0 / $genParam(bpm)]  ;# 1拍の長さ[msec]を求める

  # 1モーラ目の開始位置[ms]を求める
  if {$genParam(SU) == "msec"} {
    set Sstart $genParam(S)
  } else {
    set mspb [expr 60000.0 / $genParam(bpm)]  ;# 1拍の長さ[msec]を求める
    set Sstart [expr $genParam(S) * $mspb]
  }

  initProgressWindow
  set procStart [clock seconds]

  array unset aliasChoufuku   ;# エイリアス重複数を入れる
  set recListMax [llength $recList]
  for {set recListSeq 0} {$recListSeq < $recListMax} {incr recListSeq} {
    set fid [lindex $recList $recListSeq]
    set S $Sstart
    set morae [getMorae [string trimleft $fid "_"]]
    set genParam(avePPrev) 0    ;# 平均パワーを初期化
    set fname ""
    set fnameOld ""
    for {set i 0} {$i < [llength $morae]} {incr i} {
      ;# 当該モーラが休符(_)であればSを次の位置に移動して次のモーラへ
      set mora [lindex $morae $i]
      if {$mora == "_"} {
        set S [expr $S + $mspb]   ;# Sを次の位置に移動
        continue                  ;# 登録せず次のモーラへ
      }
      ;# エイリアスの決定
      set alias [getRenAlias $morae $i]
      if {$genParam(useAliasMax) && [array names aliasChoufuku $alias] != ""} {
        incr aliasChoufuku($alias)
        if {$genParam(aliasMax) <= 0 || $aliasChoufuku($alias) <= $genParam(aliasMax)} {
          set alias "$alias$aliasChoufuku($alias)"
        } else {
          set S [expr $S + $mspb]   ;# Sを次の位置に移動
          continue  ;# 重複が上限を超えたので登録せず次へ。
        }
      } else {
        set aliasChoufuku($alias) 1
      }
      # Sの位置補正
      if $genParam(autoAdjustRen) {
        ;# 先行発声位置を自動推定し、その差分をSに加える
        set Psec [expr ($S + $genParam(P)) / 1000.0]
        set range [expr $genParam(sRange) / 1000.0]
        set S [cut3 [expr $S + 1000.0 * [autoAdjustRen $fid $Psec $range]]]
      }
      set paramU($paramUsize,0) $fid           ;# fid
      set paramU($paramUsize,6) $alias         ;# A
      set paramU($paramUsize,1) $S             ;# S
      set paramU($paramUsize,4) $genParam(C)   ;# C
      set paramU($paramUsize,5) $genParam(E)   ;# E
      set paramU($paramUsize,3) $genParam(P)   ;# P
      set paramU($paramUsize,2) $genParam(O)   ;# O
      set paramU($paramUsize,R) $recListSeq    ;# recListの配列番号

      setSto0 $paramUsize    ;# Sが負の場合は他のパラメータ位置を動かさず0に修正

      set S [expr $S + $mspb]   ;# Sを次の位置に移動

      ;# paramSを求める
      set fname "$v(saveDir)/$fid.$v(ext)"
      if [file exists "$fname"] {
        if {$fname != $fnameOld} {
          sWork read "$fname"
          if {[sWork cget -channels] > 1} {
            sWork convert -channels Mono
          }
          set v(sndLength) [sWork length -unit SECONDS]
          set fname $fnameOld
        }
        paramU2paramS $paramUsize
      }

      incr paramUsize
    }
    # もしwavファイル名が「息.wav」など平仮名の一切ない名前だった場合、上のfor文が実行されず
    # oto.iniにwavのエントリ自体が無くなってしまう。そこで以下でエントリを一つ追加する。
    if {[llength $morae] <= 0} {
      set paramU($paramUsize,0) $fid           ;# fid
      set paramU($paramUsize,6) ""             ;# A
      set paramU($paramUsize,1) 0              ;# S
      set paramU($paramUsize,4) 0              ;# C
      set paramU($paramUsize,5) 0              ;# E
      set paramU($paramUsize,3) 0              ;# P
      set paramU($paramUsize,2) 0              ;# O
      set paramU($paramUsize,R) $recListSeq    ;# recListの配列番号
      incr paramUsize
    }

    # MFCCに基づくSの位置補正
    if {$genParam(autoAdjustRen2) && [llength $morae] > 0} {
      autoAdjustRen2 [expr $paramUsize - [llength $morae]]  [expr $paramUsize - 1]
    }

    set remain [expr ([clock seconds] - $procStart) * ($recListMax - $recListSeq) / ($recListSeq + 1)]
    updateProgressWindow [expr 100 * $recListSeq / [llength $recList]] "($recListSeq / $recListMax) (remain: $remain sec)"
  }

  deleteProgressWindow
  set v(msg) [eval format $t(doGenParam,doneMsg)]
}

#---------------------------------------------------
# 連続発声のパラメータを自動生成する
#
proc doGenParam {} {
  global genParam v paramS paramU paramUsize t

  if $v(paramChanged) {
    set act [tk_dialog .confm $t(.confm) $t(.confm.delParam) \
      question 1 $t(.confm.yes) $t(.confm.no)]
    if {$act == 1} return
  }
  initParamS
  initParamU 1
  snack::sound sWork

  set mspb [expr 60000.0 / $genParam(bpm)]  ;# 1拍の長さ[msec]を求める

  # 1モーラ目の開始位置[ms]を求める
  if {$genParam(SU) == "msec"} {
    set Sstart $genParam(S)
  } else {
    set mspb [expr 60000.0 / $genParam(bpm)]  ;# 1拍の長さ[msec]を求める
    set Sstart [expr $genParam(S) * $mspb]
  }

  initProgressWindow
  set procStart [clock seconds]

  array unset aliasChoufuku   ;# エイリアス重複数を入れる
  set recListMax [llength $recList]
  for {set recListSeq 0} {$recListSeq < $recListMax} {incr recListSeq} {
    set fid [lindex $recList $recListSeq]
#koko,部分推定可能にすべき。
    set S $Sstart
    set morae [getMorae [string trimleft $fid "_"]]
    set genParam(avePPrev) 0    ;# 平均パワーを初期化
    set fname ""
    set fnameOld ""
    for {set i 0} {$i < [llength $morae]} {incr i} {
      ;# 当該モーラが休符(_)であればSを次の位置に移動して次のモーラへ
      set mora [lindex $morae $i]
      if {$mora == "_"} {
        set S [expr $S + $mspb]   ;# Sを次の位置に移動
        continue                  ;# 登録せず次のモーラへ
      }
      ;# エイリアスの決定
      set alias [getRenAlias $morae $i]
      ;# エイリアス重複数をチェック
      if {$genParam(useAliasMax) && [array names aliasChoufuku $alias] != ""} {
        incr aliasChoufuku($alias)
        if {$genParam(aliasMax) <= 0 || $aliasChoufuku($alias) <= $genParam(aliasMax)} {
          set alias "$alias$aliasChoufuku($alias)"
        } else {
          set S [expr $S + $mspb]   ;# Sを次の位置に移動
          continue                  ;# 重複が上限を超えたので登録せず次へ。
        }
      } else {
        set aliasChoufuku($alias) 1
      }
      # Sの位置補正
      if $genParam(autoAdjustRen) {
        ;# 先行発声位置を自動推定し、その差分をSに加える
        set Psec [expr ($S + $genParam(P)) / 1000.0]
        set range [expr $genParam(sRange) / 1000.0]
        set S [cut3 [expr $S + 1000.0 * [autoAdjustRen $fid $Psec $range]]]
      }
      set paramU($paramUsize,0) $fid           ;# fid
      set paramU($paramUsize,6) $alias         ;# A
      set paramU($paramUsize,1) $S             ;# S
      set paramU($paramUsize,4) $genParam(C)   ;# C
      set paramU($paramUsize,5) $genParam(E)   ;# E
      set paramU($paramUsize,3) $genParam(P)   ;# P
      set paramU($paramUsize,2) $genParam(O)   ;# O
      set paramU($paramUsize,R) $recListSeq    ;# recListの配列番号

      setSto0 $paramUsize    ;# Sが負の場合は他のパラメータ位置を動かさず0に修正

      set S [expr $S + $mspb]   ;# Sを次の位置に移動

      ;# paramSを求める
      set fname "$v(saveDir)/$fid.$v(ext)"
      if [file exists "$fname"] {
        if {$fname != $fnameOld} {
          sWork read "$fname"
          if {[sWork cget -channels] > 1} {
            sWork convert -channels Mono
          }
          set v(sndLength) [sWork length -unit SECONDS]
          set fname $fnameOld
        }
        paramU2paramS $paramUsize
      }

      incr paramUsize
    }
    # もしwavファイル名が「息.wav」など平仮名の一切ない名前だった場合、上のfor文が実行されず
    # oto.iniにwavのエントリ自体が無くなってしまう。そこで以下でエントリを一つ追加する。
    if {[llength $morae] <= 0} {
      set paramU($paramUsize,0) $fid           ;# fid
      set paramU($paramUsize,6) ""             ;# A
      set paramU($paramUsize,1) 0              ;# S
      set paramU($paramUsize,4) 0              ;# C
      set paramU($paramUsize,5) 0              ;# E
      set paramU($paramUsize,3) 0              ;# P
      set paramU($paramUsize,2) 0              ;# O
      set paramU($paramUsize,R) $recListSeq    ;# recListの配列番号
      incr paramUsize
    }

    # MFCCに基づくSの位置補正
    if {$genParam(autoAdjustRen2) && [llength $morae] > 0} {
      autoAdjustRen2 [expr $paramUsize - [llength $morae]]  [expr $paramUsize - 1]
    }

    set remain [expr ([clock seconds] - $procStart) * ($recListMax - $recListSeq) / ($recListSeq + 1)]
    updateProgressWindow [expr 100 * $recListSeq / [llength $recList]] "($recListSeq / $recListMax) (remain: $remain sec)"
  }

  deleteProgressWindow
  resetDisplay
  ;# 一覧表のサイズを更新する
  if [winfo exists .entpwindow] {
    .entpwindow.t configure -rows $paramUsize
    setCellSelection
  }
  set v(paramChanged) 1
  setEPWTitle
  set paramU(size_1) [expr $paramUsize - 1]   ;# 表示用に行数-1した値を保存
  set v(msg) [eval format $t(doGenParam,doneMsg)]
}

#---------------------------------------------------
# MFCCに基づくSの位置補正
#
proc autoAdjustRen2 {start end} {   ;# start番目からend番目(end-1までではない)のデータを処理する
  global genParam v paramS paramU paramUsize t topdir

  set pattern [split $genParam(autoAdjustRen2Pattern) " "]

  ;# 適用すべきモーラが一つもなければreturn
  if {$genParam(autoAdjustRen2Pattern) != ""} {
    for {set f $start} {$f <= $end} {incr f} {
      set mora [lindex [getMorae [lindex [split $paramU($f,6) " "] 1]] 0]
      if {[lsearch $pattern $mora] >= 0} break
    }
    if {$f > $end} return
  }

  set f $start
  while {$f <= $end} {
    set fname "$v(saveDir)/$paramU($f,0).$v(ext)"
    set opt ""

    set d 0
    for {set i $f} {$i <= $end && $i < $paramUsize && $paramU($f,0) == $paramU($i,0)} {incr i} {
      set tmp [expr $paramS($i,E) * 0.25 + $paramS($i,P) * 0.75]
      set opt "$opt $tmp"
      incr d
    }
    set ret [eval exec "./tools/modifyPre.exe" $genParam(autoAdjustRen2Opt) "$fname" $opt]
    if {$ret != -1} {
      set newP [split $ret "\n"]
      set r $f
      for {set i 0} {$i < [llength $newP]} {incr i} {
        ;# 適用すべきモーラでなければskip
        set ftmp [expr $f + $i]
        set pre  [lindex [split $paramU($ftmp,6) " "] 0]
        set mora [lindex [getMorae [lindex [split $paramU($ftmp,6) " "] 1]] 0]
        if {$genParam(autoAdjustRen2Pattern) != ""} {
          if {$pre == "-" || [lsearch $pattern $mora] < 0 || $pre == [getVowel $mora]} {
            incr r
            continue
          }
        }

        set S [cut3 [expr ($paramS($r,S) + [lindex $newP $i] - $paramS($r,P)) * 1000.0]]
        if {$S >= 0} {
          set paramU($r,1) $S             ;# S
          paramU2paramS $r
        } else {
          set paramU($r,1) 0             ;# S
          set paramU($r,3) [cut3 [expr $paramU($r,3) + $S]] ;# P
          paramU2paramS $r
        }
        incr r
      }
    }
    set f [expr $f + $d]
  }
}

#---------------------------------------------------
# モーラ列moraeの指定した位置iから連続音用のエイリアス(「a い」など)を求めて返す
#
proc getRenAlias {morae i} {
  global genParam v paramS paramU paramUsize t

  set mora [lindex $morae $i]
  if {$i == 0} {
    set prev "-"
  } else {
    set prev [getVowel [lindex $morae [expr $i - 1]]]
  }
  return "$prev $mora"
}

#---------------------------------------------------
# 文字列を1モーラに分解して返す
#
proc getMorae {inMorae} {
  set morae {}
  for {set i 0} {$i < [string length $inMorae]} {incr i} {
    set char [string range $inMorae $i $i]
    if [isKana $char] {
      if [isMora $char] {
        ;# 現在の$charは一モーラなのでリストに追加
        lappend morae $char
      } else {
        set last [expr [llength $morae] -1]
        set mora "[lindex $morae $last]$char"
        set morae [lreplace $morae $last $last $mora]
      }
    }
  }
  return $morae
}

#---------------------------------------------------
# 一モーラの母音部の音素を返す
#
proc getVowel {mora} {
  set last [expr [string length $mora] -1]
  set char [string range $mora $last $last]

  set vA {あ か さ た な は ま や ら わ が ざ だ ば ぱ ゃ ぁ ゎ \
          ア カ サ タ ナ ハ マ ヤ ラ ワ ガ ザ ダ バ パ ャ ァ ヮ }
  set vI {い き し ち に ひ み    り    ぎ じ ぢ び ぴ    ぃ ゐ \
          イ キ シ チ ニ ヒ ミ    リ    ギ ジ ヂ ビ ピ    ィ ヰ }
  set vU {う く す つ ぬ ふ む ゆ る    ヴ ぐ ず づ ぶ ぷ ぅ ゅ っ \
          ウ ク ス ツ ヌ フ ム ユ ル       グ ズ ヅ ブ プ ゥ ュ ッ }
  set vE {え け せ て ね へ め    れ    げ ぜ で べ ぺ    ぇ ゑ \
          エ ケ セ テ ネ ヘ メ    レ    ゲ ゼ デ ベ ペ    ェ ヱ }
  set vO {お こ そ と の ほ も よ ろ を ご ぞ ど ぼ ぽ ょ ぉ    \
          オ コ ソ ト ノ ホ モ ヨ ロ ヲ ゴ ゾ ド ボ ポ ョ ォ    }
  set vN {ん ン}
  set vR {_}

  if {[lsearch $vA $char] >= 0} { return "a" }
  if {[lsearch $vI $char] >= 0} { return "i" }
  if {[lsearch $vU $char] >= 0} { return "u" }
  if {[lsearch $vE $char] >= 0} { return "e" }
  if {[lsearch $vO $char] >= 0} { return "o" }
  if {[lsearch $vN $char] >= 0} { return "n" }
  if {[lsearch $vR $char] >= 0} { return "-" }   ;# 休符だった場合
}

#---------------------------------------------------
# charが平仮名または片仮名なら1を、それ以外なら0を返す
#
proc isKana {char} {
  set kanaList {あ か さ た な は ま や ら わ    が ざ だ ば ぱ ゃ ぁ ゎ \
                ア カ サ タ ナ ハ マ ヤ ラ ワ    ガ ザ ダ バ パ ャ ァ ヮ \
                い き し ち に ひ み    り       ぎ じ ぢ び ぴ    ぃ ゐ \
                イ キ シ チ ニ ヒ ミ    リ       ギ ジ ヂ ビ ピ    ィ ヰ \
                う く す つ ぬ ふ む ゆ る       ぐ ず づ ぶ ぷ ゅ ぅ っ \
                ウ ク ス ツ ヌ フ ム ユ ル    ヴ グ ズ ヅ ブ プ ュ ゥ ッ \
                え け せ て ね へ め    れ       げ ぜ で べ ぺ    ぇ ゑ \
                エ ケ セ テ ネ ヘ メ    レ       ゲ ゼ デ ベ ペ    ェ ヱ \
                お こ そ と の ほ も よ ろ を    ご ぞ ど ぼ ぽ ょ ぉ    \
                オ コ ソ ト ノ ホ モ ヨ ロ ヲ    ゴ ゾ ド ボ ポ ョ ォ    \
                ん ン ゛ ゜ °\
                _ }
  if {[lsearch $kanaList $char] >= 0} {
    return 1
  } else {
    return 0
  }
}

#---------------------------------------------------
# charが一モーラなら1を、拗音などなら0を返す
#
proc isMora {char} {
  set notMora {ぁ ぃ ぅ ぇ ぉ ゃ ゅ ょ ゎ っ \
               ァ ィ ゥ ェ ォ ャ ュ ョ ヮ ッ ゛ ゜ °}
  if {[lsearch $notMora $char] >= 0} {
    return 0
  } else {
    return 1
  }
}

#---------------------------------------------------
# 単独音のUTAU原音パラメータを推定する際の設定窓
#
proc estimateParam {} {
  global epwindow power estimate v t

  if [isExist $epwindow] return  ;# 二重起動を防止
  toplevel $epwindow
  wm title $epwindow $t(estimateParam,title)
  wm resizable $epwindow 0 0
  bind $epwindow <Escape> "destroy $epwindow"

  set w [frame $epwindow.al]
  pack $w
  set row 0

  ;# パワー抽出刻みの設定
  label $w.lfl -text $t(estimateParam,pFLen)
  entry $w.efl -textvar power(frameLength) \
    -validate all -validatecommand {
         if {[string is double %P]} {
           if {[string length %P] > 0 && %P > 0} {
             set tmp [sec2samp $power(uttLengthSec) %P]
             if {$tmp >= 0} {
               set power(uttLength) $tmp
             }
           }
           expr {1}
         } else {
           expr {0}
         }
    }
  label $w.lflu -text "(sec)"
  grid $w.lfl  -sticky w -row $row -column 0
  grid $w.efl  -sticky w -row $row -column 1
  grid $w.lflu -sticky w -row $row -column 2 -columnspan 2
  incr row

  ;# プリエンファシスの設定
  # frame $w.fem
  label $w.lem -text $t(estimateParam,preemph)
  entry $w.eem -textvar power(preemphasis)
  grid $w.lem  -sticky w -row $row -column 0
  grid $w.eem  -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# パワー抽出窓長の設定
  label $w.lwl -text $t(estimateParam,pWinLen)
  entry $w.ewlSec -textvar power(windowLength)
  label $w.lwlSec -text "(sec)"
  grid $w.lwl      -sticky w -row $row -column 0
  grid $w.ewlSec   -sticky w -row $row -column 1
  grid $w.lwlSec   -sticky w -row $row -column 2 -columnspan 2
  incr row

  ;# 窓の選択
  # frame $w.fwn
  label $w.lwn -text $t(estimateParam,pWinkind)
  tk_optionMenu $w.mwn power(window) \
    Hamming Hanning Bartlett Blackman Rectangle
  grid $w.lwn  -sticky w -row $row -column 0
  grid $w.mwn  -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# 発話中とみなされるパワーの設定
  # frame $w.fhi
  label $w.lhi -text $t(estimateParam,pUttMin)
  entry $w.ehi -textvar power(uttHigh)
  label $w.lhiu -text "(db)"
  grid $w.lhi  -sticky w -row $row -column 0
  grid $w.ehi  -sticky w -row $row -column 1
  grid $w.lhiu -sticky w -row $row -column 2 -columnspan 2
  incr row

  ;# 発話中とみなされる時間長の設定
  # frame $w.ful
  label $w.lul -text $t(estimateParam,pUttMinTime)
  entry $w.eulSec -textvar power(uttLengthSec) \
    -validate all -validatecommand {
         set tmp [sec2samp %P $power(frameLength)]
         if {$tmp >= 0} {
           set power(uttLength) $tmp
           expr {1}
         } else {
           expr {0}
         }
    }
  label $w.lulSec -text "(sec) = "
  label $w.lulSamp -textvar power(uttLength)
  label $w.lulSampu -text "(sample)"
  grid $w.lul      -sticky w -row $row -column 0
  grid $w.eulSec   -sticky w -row $row -column 1
  grid $w.lulSec   -sticky w -row $row -column 2
  grid $w.lulSamp  -sticky w -row $row -column 3
  grid $w.lulSampu -sticky w -row $row -column 4
  incr row

  ;# 発声中に生じるパワーの揺らぎの大きさ設定
  # frame $w.fhi
  label $w.lkp -text $t(estimateParam,uttLen)
  entry $w.ekp -textvar power(uttKeep)
  label $w.lkpu -text "(db)"
  grid $w.lkp  -sticky w -row $row -column 0
  grid $w.ekp  -sticky w -row $row -column 1
  grid $w.lkpu -sticky w -row $row -column 2 -columnspan 2
  incr row

  ;# ポーズ中とみなされるパワーの設定
  # frame $w.flw
  label $w.llw -text $t(estimateParam,silMax)
  entry $w.elw -textvar power(uttLow)
  label $w.llwu -text "(db)"
  grid $w.llw  -sticky w -row $row -column 0
  grid $w.elw  -sticky w -row $row -column 1
  grid $w.llwu -sticky w -row $row -column 2 -columnspan 2
  incr row

  ;# 母音パワー最小値の設定（この値未満は子音部とみなす）
  label $w.lmv -text $t(estimateParam,vLow)
  entry $w.emvSec -textvar power(vLow)
  label $w.lmvSec -text "(db)"
  grid $w.lmv      -sticky w -row $row -column 0
  grid $w.emvSec   -sticky w -row $row -column 1
  grid $w.lmvSec   -sticky w -row $row -column 2
  incr row

  ;# ポーズとみなされる時間長の設定
  # frame $w.fsl
  label $w.lsl -text $t(estimateParam,silMinTime)
  entry $w.eslSec -textvar power(silLengthSec) \
    -validate all -validatecommand {
         set tmp [sec2samp %P $power(frameLength)]
         if {$tmp >= 0} {
           set power(silLength) $tmp
           expr {1}
         } else {
           expr {0}
         }
    }
  label $w.lslSec -text "(sec) = "
  label $w.lslSamp -textvar power(silLength)
  label $w.lslSampu -text "(sample)"
  grid $w.lsl      -sticky w -row $row -column 0
  grid $w.eslSec   -sticky w -row $row -column 1
  grid $w.lslSec   -sticky w -row $row -column 2
  grid $w.lslSamp  -sticky w -row $row -column 3
  grid $w.lslSampu -sticky w -row $row -column 4
  incr row

  ;# 子音長最小値の設定（子音部=0でUTAUがエラーになるのを回避するため）
  label $w.lmc -text $t(estimateParam,minC)
  entry $w.emcSec -textvar estimate(minC)
  label $w.lmcSec -text "(sec)"
  grid $w.lmc      -sticky w -row $row -column 0
  grid $w.emcSec   -sticky w -row $row -column 1
  grid $w.lmcSec   -sticky w -row $row -column 2
  incr row

  ;# F0に関する説明文
  label $w.lf0 -text $t(estimateParam,f0)
  grid $w.lf0      -sticky w -row $row -column 0 -columnspan 3
  incr row

  ;# 推定対象の設定
  # frame $w.fem
  label $w.l$row -text $t(estimateParam,target)
  frame $w.fe$row
  checkbutton $w.fe$row.b -variable estimate(S)
  label $w.fe$row.t -text $t(estimateParam,S)
  pack $w.fe$row.b $w.fe$row.t -side left
  grid $w.l$row  -sticky w -row $row -column 0
  grid $w.fe$row -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# 推定対象の設定
  # frame $w.fem
  frame $w.fe$row
  checkbutton $w.fe$row.b -variable estimate(C)
  label $w.fe$row.t -text $t(estimateParam,C)
  pack $w.fe$row.b $w.fe$row.t -side left
  grid $w.fe$row -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# 推定対象の設定
  # frame $w.fem
  frame $w.fe$row
  checkbutton $w.fe$row.b -variable estimate(E)
  label $w.fe$row.t -text $t(estimateParam,E)
  pack $w.fe$row.b $w.fe$row.t -side left
  grid $w.fe$row -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# 推定対象の設定
  # frame $w.fem
  frame $w.fe$row
  checkbutton $w.fe$row.b -variable estimate(P)
  label $w.fe$row.t -text $t(estimateParam,P)
  pack $w.fe$row.b $w.fe$row.t -side left
  grid $w.fe$row -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# 推定対象の設定
  # frame $w.fem
  frame $w.fe$row
  checkbutton $w.fe$row.b -variable estimate(O)
  label $w.fe$row.t -text $t(estimateParam,O)
  pack $w.fe$row.b $w.fe$row.t -side left
  grid $w.fe$row -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# ボタンの設定
  # frame $w.fbt
  button $w.do -text $t(estimateParam,runAll) -command {
    if $v(paramChanged) {
      set act [tk_dialog .confm $t(.confm) $t(estimateParam,overWrite) \
        question 1 $t(.confm.ok) $t(.confm.c)]
      if {$act == 1} return
    }
    ;# もしエントリ欄が空欄だったなら0を代入
    if {[string length $power(silLengthSec)] == 0} {
      set power(silLengthSec) 0
    }
    if {[string length $power(uttLengthSec)] == 0} {
      set power(uttLengthSec) 0
    }

    if {$::tcl_platform(os) != "Darwin"} { grab set $epwindow }
    if {$v(appname) == "OREMO"}          { makeRecListFromDir 0 0 }
    doEstimateParam all
    if {$::tcl_platform(os) == "Darwin"} { deleteProgressWindow } ;# なぜかmacではdoEstimateParamの中で消せなかった
    if {$v(appname) == "OREMO"}          {
                                           set v(paramFile) "$v(saveDir)/oto.ini"
                                           saveParamFile
                                         }
    if {$::tcl_platform(os) != "Darwin"} { grab release $epwindow }
    destroy $epwindow
    if {$v(appname) != "OREMO"} {
      resetDisplay
      setCellSelection
    }
  }
  grid $w.do     -sticky we -row $row -column 0
  if {$v(appname) != "OREMO"} {
    button $w.do2 -text $t(estimateParam,runSel) -command {
      ;# もしエントリ欄が空欄だったなら0を代入
      if {[string length $power(silLengthSec)] == 0} {
        set power(silLengthSec) 0
      }
      if {[string length $power(uttLengthSec)] == 0} {
        set power(uttLengthSec) 0
      }

      grab set $epwindow     ;# 推定中は他の操作が出来ないようにする
      doEstimateParam sel
      grab release $epwindow ;# 推定中は他の操作が出来ないようにする
      destroy $epwindow
      Redraw all
    }
    grid $w.do2    -sticky we -row $row -column 1
  }
  button $w.cancel -text $t(.confm.c) -command {destroy $epwindow}
  grid $w.cancel -sticky we -row $row -column 2
  incr row
}

#---------------------------------------------------
# UTAU原音パラメータの推定
#
proc doEstimateParam {{mode all}} {
  global power v paramS paramU paramUsize estimate t f0 ;# f0は他でも使っている

  set v(msg) $t(doEstimateParam,startMsg)

  snack::sound sWork

  initProgressWindow

  ;# 推定する行番号のリストを作る
  set targetList {}
  if {$mode == "all"} {
    for {set i 1} {$i < $paramUsize} {incr i} {
      lappend targetList $i
    }
  } else {
    foreach pos [.entpwindow.t curselection] {
      set r [lindex [split $pos ","] 0]
      if {[lindex $targetList end] != $r} {
        lappend targetList $r
      }
    }
  }

  foreach i $targetList {
    ;# wavファイルを読む
    set fid $paramU($i,0)
    set filename $v(saveDir)/$fid.$v(ext)
    if {![file readable $filename]} continue
    sWork read $filename
    if {[sWork cget -channels] > 1} {
      sWork convert -channels Mono
    }
    if {$v(appname) == "OREMO"} {
      set v(sndLength) [sWork length -unit SECONDS]
    }

    ;# パワーを抽出する
    set pw [sWork power -framelength $power(frameLength) \
      -windowtype $power(window) -preemphasisfactor $power(preemphasis) \
      -windowlength [expr int($power(windowLength) * $v(sampleRate))] \
      -start 0 -end -1]

    ;# 初期値設定
    if $estimate(S) { set paramS($i,S) 0 }
    if $estimate(C) { set paramS($i,C) $estimate(minC) }
    if $estimate(E) { set paramS($i,E) [sWork length -unit SECONDS] }
    set uttS 0           ;# 発声音量が十分な大きさになっているとみなされた位置
    set uttE [expr [llength $pw] - 1]     ;# 発声音量が減衰し始める位置

    if {[llength $pw] > 0} {
      ;# 左側の発話中確定点を探す
      set length 0   ;# 発話が連続しているサンプル数
      for {set j 0} {$j < [llength $pw]} {incr j} {
        if {[lindex $pw $j] >= $power(uttHigh)} {
          incr length
        } else {
          set length 0
        }
        if {$length >= [expr $power(uttLength) + 1]} {
          set uttS $j     ;# 現在位置を保存
          break
        }
      }
      ;# 左にたどって左ブランク位置（発話開始点）を探す
      if $estimate(S) {
        set length 0
        for {set k $j} {$k > 0} {incr k -1} {
          if {[lindex $pw $k] <= $power(uttLow)} {
            incr length
          } else {
            set length 0
          }
          if {$length >= [expr $power(silLength) + 1]} {
            ;# 現在位置を左ブランクにする
            set tm [expr $k * $power(frameLength)] ;# 時刻[sec]を計算
            set paramS($i,S) $tm
            break
          }
        }
      }

      ;# 発声音量が減衰し始める点を求める
      set length 0   ;# 発話が連続しているサンプル数
      for {set j [expr [llength $pw] - 1]} {$j > $uttS} {incr j -1} {
        if {[lindex $pw $j] >= $power(uttHigh)} {
          incr length
        } else {
          set length 0
        }
        if {$length >= [expr $power(uttLength) + 1]} {
          set uttE $j     ;# 現在位置を保存
          break
        }
      }

      ;# uttS～uttE間の中央付近の平均パワーavePを求める
      set Nmax 30
      set N 0
      set aveP 0
      set center [expr int(($uttE + $uttS) / 2)]
      for {set j [expr $center + 1]} {$j <= $uttE && $N < [expr $Nmax / 2]} {incr j} {
        set aveP [expr $aveP + [lindex $pw $j]]
        incr N
      }
      for {set j $center} {$j >= $uttS && $N < $Nmax} {incr j -1} {
        set aveP [expr $aveP + [lindex $pw $j]]
        incr N
      }
      set aveP [expr $aveP / $N]

      ;# 右ブランク位置を探す
      if $estimate(E) {
        for {set j $center} {$j <= $uttE} {incr j} {
;#koko, パワーが平均値より大きい方に揺らいでいる分はOKとした。
;#koko, パワーが平均値より小さく揺らいだときに反応させるようにした
          if {[expr $aveP - [lindex $pw $j]] > [expr $power(uttKeep) / 2]} {
            break
          }
        }
        ;# 現在位置を右ブランクにする
        set tm [expr $j * $power(frameLength)] ;# 時刻[sec]を計算
        if {$paramS($i,S) < $tm} {
          set paramS($i,E) $tm
        } else {
          set paramS($i,E) $paramS($i,S)
        }
      }

      ;# 子音部位置を探す
      if $estimate(C) {
        for {set j $center} {$j >= $uttS} {incr j -1} {
;#koko, パワーが平均値より大きい方に揺らいでいる分はOKとした。
;#koko, パワーが平均値より小さく揺らいだときに反応させるようにした
          if {[expr $aveP - [lindex $pw $j]] > [expr $power(uttKeep) / 2]} {
            break
          }
        }
        ;# 現在位置を子音部にする
        set tm [expr $j * $power(frameLength)] ;# 時刻[sec]を計算
        if {$tm >= [expr $paramS($i,S) + $estimate(minC)]} {
          set paramS($i,C) $tm
        } else {
          set paramS($i,C) [expr $paramS($i,S) + $estimate(minC)]
        }
      }
    }

    ;# 先行発声位置を探す
    if $estimate(P) {
      set paramS($i,P) $paramS($i,S)

      ;# 有声開始位置を求める
      set seriestmp {}
      if {[catch {set seriestmp [sWork pitch -method $f0(method) \
        -framelength $f0(frameLength) -windowlength $f0(windowLength) \
        -maxpitch $f0(max) -minpitch $f0(min) \
        ] } ret]} {
        if {$ret != ""} {
          puts "error: $ret"
        }
        set seriestmp {}
      }
      for {set vot [expr int($paramS($i,P) / $f0(frameLength))]} \
          {$vot < [llength $seriestmp]} {incr vot} {
        if {[lindex [split [lindex $seriestmp $vot] " "] 0] > 0} break
      }
      set votSec [expr $vot * $f0(frameLength)]

      ;# votから右に行き、母音パワー最小値を超える所まで移動する
      for {set j [expr int($votSec / $power(frameLength))]} \
          {[expr $j * $power(frameLength)] < $paramS($i,C)} \
          {incr j} {
        if {[lindex $pw $j] >= $power(vLow)} break
      }

      ;# 現在位置を先行発声にする
      set tm [expr $j * $power(frameLength)] ;# 時刻[sec]を計算
      if {$tm <= $paramS($i,C)} {
        set paramS($i,P) $tm
      } else {
        set paramS($i,P) $paramS($i,S)
      }
    }

    ;# オーバーラップ位置を探す。現在未実装。
    if $estimate(O) {
      set paramS($i,O) $paramS($i,S)
    }

    ;# paramUを設定する
    foreach kind {S E C P O} {
      if $estimate($kind) {
        set paramU($i,[kind2c $kind]) [sec2u $i $kind $paramS($i,$kind)]
      }
    }
    updateProgressWindow [expr 100 * $i / $paramUsize]
    set v(msg) "$t(doEstimateParam,startMsg) ($i / $paramUsize)"
  }
  deleteProgressWindow
  if {$v(appname) != "OREMO"} {
    set v(paramChanged) 1
    setEPWTitle
  }
  set v(msg) [eval format $t(doEstimateParam,doneMsg)]
}

#---------------------------------------------------
# 原音パラメータを保存する
# return: 1=保存した。0=保存しなかった。
# 引数1 fn: 保存ファイル名。指定なしの場合ダイアログ窓を開く
# 引数2 autoBackup: 0=通常のoto.ini保存。
#         1=自動バックアップのための保存。キャッシュファイルを保存しない。
#           保存した際にメッセージを表示しない。
#
proc saveParamFile {{fn ""} {autoBackup 0}} {
  global paramU paramUsize v t
 
  ;#if {$v(paramChanged) == 0} {
  ;#  set v(msg) "パラメータが変更されていないので保存しませんでした"
  ;#  tk_dialog .confm "Warning" \
  ;#    "パラメータが変更されていないので保存しませんでした" \
  ;#    warning 0 OK
  ;#  return 0
  ;#}
  if {$fn == ""} {
    set fn [tk_getSaveFile -initialfile $v(paramFile) \
              -title $t(saveParamFile,selFile) -defaultextension "ini" ]
    if {$fn == ""} {return 0}
  }

  if {$autoBackup == 0} {
    set v(msg) $t(saveParamFile,startMsg)
  }

  if {[file exists $v(saveDir)] == 0} {
    file mkdir $v(saveDir)
  }
  ;# 保存ファイルを開く
  if [catch {open $fn w} fp] {
    tk_messageBox -message "error: can not open $fn" \
      -title $t(.confm.fioErr) -icon warning
    return
  }
  if {$::tcl_platform(os) != "Darwin"} {
    set v(paramFile) $fn  ;# macだとパス解析に失敗して次回のmy_getSaveFileで不正確なフォルダが初期指定されたので
  }

  for {set i 1} {$i < $paramUsize} {incr i} {
    if {[array names paramU "$i,0"] != ""} {
      set name $paramU($i,0).$v(ext)
      set S 0; set O 0; set P 0; set C 0; set E 0; set A "";
      if {[array names paramU "$i,1"] != ""} { set S $paramU($i,1) }
      if {[array names paramU "$i,2"] != ""} { set O $paramU($i,2) }
      if {[array names paramU "$i,3"] != ""} { set P $paramU($i,3) }
      if {[array names paramU "$i,4"] != ""} { set C $paramU($i,4) }
      if {[array names paramU "$i,5"] != ""} { set E $paramU($i,5) }
      if {[array names paramU "$i,6"] != ""} { set A $paramU($i,6) }
      puts $fp $name=$A,$S,$C,$E,$P,$O    ;# ファイルへ書き出し
    }
  }
  close $fp        ;# ファイルを閉じる

  if {$::tcl_platform(os) == "Darwin"} {
    global nkf 
    exec -- $nkf -s --in-place $fn      ;# 漢字コードをsjisに変換
  }
  if {$autoBackup == 0} {
    if {$v(appname) != "OREMO"} {
      saveCacheFile    ;# キャッシュ作成。これはoto.ini保存より先にやってはいけない。
      set v(paramChanged) 0
      setEPWTitle
    }
    set v(msg) [eval format $t(saveParamFile,doneMsg)]
  }
  return 1
}

#---------------------------------------------------
# 実数を小数点以下6桁で打ち切る
#
proc cut6 {val} {
  return [expr int($val * 1000000) / 1000000.0 ]
}

#---------------------------------------------------
# 実数を小数点以下3桁で打ち切る
#
proc cut3 {val} {
  return [expr int($val * 1000) / 1000.0 ]
}

#---------------------------------------------------
# 単位変換
#
proc sec2samp {sec length} {
  if {[string length $sec] == 0 || [string length $length] == 0} {
    return 0
  }
  if {[string is double $sec] && [string is double $length]} {
    return [expr int(double($sec) / $length)]
  } else {
    return -1
  }
}

#---------------------------------------------------
# パラメータ種類名をparamU列番号に変換
#
proc kind2c {k} {
  switch $k {
    ;# A       6
    ;# fid     0
    ;#         R
    S { return 1 }
    O { return 2 }
    P { return 3 }
    C { return 4 }
    E { return 5 }
    default { return ""}
  }
}

#---------------------------------------------------
# paramUの列番号をパラメータ種類名に変換
#
proc c2kind {c} {
  switch $c {
    1 { return S }
    2 { return O }
    3 { return P }
    4 { return C }
    5 { return E }
    default { return ""}
    ;# 0       fid
    ;# 6       A
    ;# R
  }
}

#---------------------------------------------------
# 指定した行のparamUをparamSに変換する
# 波形長が$v(sndLength)に入っていることが前提
#
proc paramU2paramS {r} {
  global paramU paramS t

  for {set c 1} {$c < 6} {incr c} {
    set kindTmp [c2kind $c]
    if {[array names paramU "$r,$c"] != ""} {
      set paramS($r,$kindTmp) [u2sec $kindTmp $r $c]
    }
  }
}

#---------------------------------------------------
# 単位変換(秒→UTAU原音パラメータ)
#
proc sec2u {r kind newVal} {  ;# r=-1:アクティブセルを変換。
  global paramS paramU snd paDev v t

  if {$r < 0} {set r $v(listSeq)}  ;# 現在のアクティブセルの行番号

  if {[llength $newVal] == 0} {
    set newVal $paramS($r,$kind)   ;# 変換したい値(秒単位)を決定。
  }

  set fid $paramU($r,0)
  set fname $v(saveDir)/$fid.$v(ext)
  if {[snd cget -load] != $fname && [file readable $fname]} {
    snd read $fname
    if {$paDev(usePlay)} {
      putsPa play "wav $fname"
      set ret [getsPa play]
    }
    if {[snd cget -channels] != 1} {
      set snd [snd convert -channels Mono]
    }
    set v(sndLength) [snd length -unit SECONDS]
  }
  if {[array names paramS "$r,S"] != ""} {
    set S $paramS($r,S)
  } else {
    set S 0
  }
  switch $kind {
    S { return   [cut3 [expr double($newVal) * 1000.0] ] }
    E { if {$v(setE) < 0 } {
          return [cut3 [expr - ($newVal - $S) * 1000.0] ]
        } else {
          return [cut3 [expr $v(sndLength) * 1000.0 - $newVal * 1000.0]] 
        }
      }
    C -
    P -
    O { return [cut3 [expr ($newVal - $S) * 1000] ]}
  }
}

#---------------------------------------------------
# 単位変換(UTAU原音パラメータ→秒)
# snd に波形を読んでいることが前提
#
proc u2sec {kind r c} {
  global paramS paramU t v
  if {[array names paramS "$r,S"] != ""} {
    set S $paramS($r,S)
  } else {
    set S 0
  }
  if {$paramU($r,$c) != ""} {
    set u $paramU($r,$c)
  } else {
    set u 0
  }
  switch $kind {
    S { return [cut6 [expr $u / 1000.0]] }
    C -
    P -
    O { return [cut6 [expr $u / 1000.0 + $S]] }
    E { if {$u >= 0} {
          return [cut6 [expr $v(sndLength) - $u / 1000.0]] 
        } else {
          return [cut6 [expr $u / -1000.0 + $S]]
        }
      }
  }
}

