#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

#---------------------------------------------------
# �T�u���[�`��


#---------------------------------------------------
# oto.ini�����O�ɖ��ۑ�wav�����������ׂ�
#
proc checkWavForOREMO {} {
  global v t

  ;# ���ݕ\������wav�t�@�C�����ۑ��ς݂��`�F�b�N
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
# �������^�����A����������oto.ini�𐶐�
#
proc genParam {} {
  global v genWindow genParam t

  if [isExist $genWindow] return ;# ��d�N����h�~
  toplevel $genWindow
  wm title $genWindow $t(genParam,title)
  bind $genWindow <Escape> "destroy $genWindow"

  set r 0

  # �����ݒ�
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

  # �{�^��
  set f($r) [frame $genWindow.f($r) -padx 5 -pady 0]
  label  $f($r).arrow1 -text $t(genParam,darrow)
  button $f($r).bInit  -text $t(genParam,bInit)  -command initGenParam
  label  $f($r).arrow2 -text $t(genParam,darrow)

  grid  $f($r).arrow1 -row 0 -column 0 -sticky nsew
  grid  $f($r).bInit  -row 1 -column 0 -sticky nsew
  grid  $f($r).arrow2 -row 2 -column 0 -sticky nsew
  incr r

  # msec�P�ʂł̊e�ݒ�
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

  # �p���[�Ɋ�Â���s�����ʒu�̎�������p�̐ݒ葋
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

  # MFCC�Ɋ�Â���s�����ʒu�̎�������̐ݒ葋
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

  # �G�C���A�X�d���Ɋւ���ݒ藓
  set f($r) [labelframe $genWindow.f($r) -relief groove -padx 5 -pady 5]

  set genParam(useAliasMax) 0  ;# 0=�d�������̂܂܂ɂ���,1=�ʂ��ԍ���t����
  set genParam(aliasMax) 0     ;# �d���ԍ��̍ő�l
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

  # ���s�{�^��
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
# BPM�A�`��S����p�����[�^�̏����l�����߂�
#
proc initGenParam {} {
  global genParam t

  set mspb [expr 60000.0 / $genParam(bpm)]  ;# 1���̒���[msec]�����߂�

  set genParam(O) [cut3 [expr $mspb / 6.0]]
  set genParam(P) [cut3 [expr $mspb / 2.0]]
  set genParam(C) [cut3 [expr $mspb * 3.0 / 4.0]]
  set genParam(E) [cut3 [expr - ($mspb + $genParam(O)) ]]
  set genParam(sRange) $genParam(P)
  ;#set genParam(E) [cut3 [expr - $mspb ]]
}

#---------------------------------------------------
# �A�������̐擪���[���̐�s�����ʒu�𐄒肵�A
# ��s���������̏ꏊ�ɂȂ邽�߂̕␳��(sec)��Ԃ�
# Porg, range�̒P�ʁFsec�BPorg-range�`Porg+range�͈̔͂�T������
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

  ;# �L���J�n�ʒu�����߂�
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
    if {$f0old <= 0 && $f0now > 0} break  ;# ���O�������A���Y���L���Ȃ�break
    set f0old $f0now
  }
  if {$i < [llength $seriestmp]} {
    ;# �L���J�n�_�ł���΂������s�������Ƃ��A�X�Ɏ��̃p���[�Ɋ�Â�
    ;# �T���J�n�_�ɂ���
    set Pnew [expr $i * $f0(frameLength) + $Lsec]
    set Lsec $Pnew
    set start [expr int($Lsec * $v(sampleRate))]   ;# end ��F0�Ɠ���
  } else {
    set Pnew $Porg
  }

  ;# �Œ�͈́`�E�u�����N�Ԃ̕��σp���[aveP�����߂�B�������l��30�ȏ�Ȃ�
  ;# 30�ŕ��ς����߂�
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

  ;# �T����Ԃ̃p���[�����߂�
  set pw [sWork power -framelength $power(frameLength) \
    -windowtype $power(window) -preemphasisfactor $power(preemphasis) \
    -windowlength [expr int($power(windowLength) * $v(sampleRate))] \
    -start $start -end $end]

  ;# 臒l�ɑ΂��ăp���[�Ȑ����E�オ��ɃN���X����_��T��
  ;# vot����E�ɍs���A�p���[���E�オ���臒l�𒴂��鏊�܂ňړ�����
  ;# ���̂悤�ȏꏊ����������ꍇ�͉��݂����[�����̂ɂ���
  set vLow [expr $aveP - $genParam(vLow)]
  set powOld $vLow
  set pn -1                         ;# ��s�����ʒu������ϐ�
  set pnMin     10001               ;# ��s�����O�̉��݂̐[��
  set powNowMin 10000
  for {set i 0} {$i < [llength $pw]} {incr i} {
    set powNow [lindex $pw $i]
    if {$powNow < $powNowMin} {
      set powNowMin $powNow         ;# ���݂̒l�����߂Ă���
    }
    if {$powOld < $vLow && $powNow >= $vLow && $powNowMin < $pnMin} {
      set pn $i
      set pnMin $powNowMin       ;# ���݂̒l��ۑ�
      set powNowMin 10000        ;# �ď�����
    }
    set powOld $powNow
  }

  #if {$pn < 0 && [expr $genParam(avePPrev) - $genParam(vLow) - $aveP] > 0} {
  #  ;# �p���[���݂�������ꂸ�A����s���[����蓖�Y���[���̕��σp���[��������x�������ꍇ�A
  #  ;# vot����E�ɍs���A�p���[�Ȑ������Y���[���̕��σp���[�ɃN���X����_��T��
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

#koko,������K�������Ȃ�A��L�p���[�̉��݂����o�ł��Ȃ��ꍇ��
#���݂�Pnew�̒��߂̉���(x(i-1) >= x(i) < x(i+1) ��i)��T���Ƃ��B

#koko,���σp���[����s���[�����傫���ꍇ�̋K���B

  set genParam(avePPrev) $aveP    ;# ����̐���̂��߂ɕ��σp���[��ۑ�
 
  ;# ���݈ʒu����s�����ɂȂ邽�߂̕␳��(sec)��Ԃ�
  return [expr $Pnew - $Porg]
}

#---------------------------------------------------
# ����S�����Ȃ瑼�̃p�����[�^�ʒu���ς��Ȃ��悤��S=0�ɂ���
# ���{���[�`���͘A�����p(genParam�p)
# ���{���[�`���ł�paramU�̂ݒ������AparamS�ɂ͔��f�����Ȃ����Ƃɒ���
#
proc setSto0 {r} {
  global paramU

  if {$paramU($r,1) < 0} {     ;# S < 0 �Ȃ�
    ;# E(��) �̒l���C��
    set paramU($r,5) [cut3 [expr $paramU($r,5) - $paramU($r,1)]]
    ;# C �̒l���C��
    set paramU($r,4) [cut3 [expr $paramU($r,4) + $paramU($r,1)]]
    ;# P �̒l���C��
    set paramU($r,3) [cut3 [expr $paramU($r,3) + $paramU($r,1)]]
    ;# O �̒l���C��
    set paramU($r,2) [cut3 [expr $paramU($r,2) + $paramU($r,1)]]
    if {$paramU($r,2) < 0} {
      set paramU($r,2) 0
    }
    ;# S ��0�ɂ���
    set paramU($r,1) 0
  }
}

#---------------------------------------------------
# �A�������̃p�����[�^��������������(OREMO�p)
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

  set mspb [expr 60000.0 / $genParam(bpm)]  ;# 1���̒���[msec]�����߂�

  # 1���[���ڂ̊J�n�ʒu[ms]�����߂�
  if {$genParam(SU) == "msec"} {
    set Sstart $genParam(S)
  } else {
    set mspb [expr 60000.0 / $genParam(bpm)]  ;# 1���̒���[msec]�����߂�
    set Sstart [expr $genParam(S) * $mspb]
  }

  initProgressWindow
  set procStart [clock seconds]

  array unset aliasChoufuku   ;# �G�C���A�X�d����������
  set recListMax [llength $recList]
  for {set recListSeq 0} {$recListSeq < $recListMax} {incr recListSeq} {
    set fid [lindex $recList $recListSeq]
    set S $Sstart
    set morae [getMorae [string trimleft $fid "_"]]
    set genParam(avePPrev) 0    ;# ���σp���[��������
    set fname ""
    set fnameOld ""
    for {set i 0} {$i < [llength $morae]} {incr i} {
      ;# ���Y���[�����x��(_)�ł����S�����̈ʒu�Ɉړ����Ď��̃��[����
      set mora [lindex $morae $i]
      if {$mora == "_"} {
        set S [expr $S + $mspb]   ;# S�����̈ʒu�Ɉړ�
        continue                  ;# �o�^�������̃��[����
      }
      ;# �G�C���A�X�̌���
      set alias [getRenAlias $morae $i]
      if {$genParam(useAliasMax) && [array names aliasChoufuku $alias] != ""} {
        incr aliasChoufuku($alias)
        if {$genParam(aliasMax) <= 0 || $aliasChoufuku($alias) <= $genParam(aliasMax)} {
          set alias "$alias$aliasChoufuku($alias)"
        } else {
          set S [expr $S + $mspb]   ;# S�����̈ʒu�Ɉړ�
          continue  ;# �d��������𒴂����̂œo�^�������ցB
        }
      } else {
        set aliasChoufuku($alias) 1
      }
      # S�̈ʒu�␳
      if $genParam(autoAdjustRen) {
        ;# ��s�����ʒu���������肵�A���̍�����S�ɉ�����
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
      set paramU($paramUsize,R) $recListSeq    ;# recList�̔z��ԍ�

      setSto0 $paramUsize    ;# S�����̏ꍇ�͑��̃p�����[�^�ʒu�𓮂�����0�ɏC��

      set S [expr $S + $mspb]   ;# S�����̈ʒu�Ɉړ�

      ;# paramS�����߂�
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
    # ����wav�t�@�C�������u��.wav�v�ȂǕ������̈�؂Ȃ����O�������ꍇ�A���for�������s���ꂸ
    # oto.ini��wav�̃G���g�����̂������Ȃ��Ă��܂��B�����ňȉ��ŃG���g������ǉ�����B
    if {[llength $morae] <= 0} {
      set paramU($paramUsize,0) $fid           ;# fid
      set paramU($paramUsize,6) ""             ;# A
      set paramU($paramUsize,1) 0              ;# S
      set paramU($paramUsize,4) 0              ;# C
      set paramU($paramUsize,5) 0              ;# E
      set paramU($paramUsize,3) 0              ;# P
      set paramU($paramUsize,2) 0              ;# O
      set paramU($paramUsize,R) $recListSeq    ;# recList�̔z��ԍ�
      incr paramUsize
    }

    # MFCC�Ɋ�Â�S�̈ʒu�␳
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
# �A�������̃p�����[�^��������������
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

  set mspb [expr 60000.0 / $genParam(bpm)]  ;# 1���̒���[msec]�����߂�

  # 1���[���ڂ̊J�n�ʒu[ms]�����߂�
  if {$genParam(SU) == "msec"} {
    set Sstart $genParam(S)
  } else {
    set mspb [expr 60000.0 / $genParam(bpm)]  ;# 1���̒���[msec]�����߂�
    set Sstart [expr $genParam(S) * $mspb]
  }

  initProgressWindow
  set procStart [clock seconds]

  array unset aliasChoufuku   ;# �G�C���A�X�d����������
  set recListMax [llength $recList]
  for {set recListSeq 0} {$recListSeq < $recListMax} {incr recListSeq} {
    set fid [lindex $recList $recListSeq]
#koko,��������\�ɂ��ׂ��B
    set S $Sstart
    set morae [getMorae [string trimleft $fid "_"]]
    set genParam(avePPrev) 0    ;# ���σp���[��������
    set fname ""
    set fnameOld ""
    for {set i 0} {$i < [llength $morae]} {incr i} {
      ;# ���Y���[�����x��(_)�ł����S�����̈ʒu�Ɉړ����Ď��̃��[����
      set mora [lindex $morae $i]
      if {$mora == "_"} {
        set S [expr $S + $mspb]   ;# S�����̈ʒu�Ɉړ�
        continue                  ;# �o�^�������̃��[����
      }
      ;# �G�C���A�X�̌���
      set alias [getRenAlias $morae $i]
      ;# �G�C���A�X�d�������`�F�b�N
      if {$genParam(useAliasMax) && [array names aliasChoufuku $alias] != ""} {
        incr aliasChoufuku($alias)
        if {$genParam(aliasMax) <= 0 || $aliasChoufuku($alias) <= $genParam(aliasMax)} {
          set alias "$alias$aliasChoufuku($alias)"
        } else {
          set S [expr $S + $mspb]   ;# S�����̈ʒu�Ɉړ�
          continue                  ;# �d��������𒴂����̂œo�^�������ցB
        }
      } else {
        set aliasChoufuku($alias) 1
      }
      # S�̈ʒu�␳
      if $genParam(autoAdjustRen) {
        ;# ��s�����ʒu���������肵�A���̍�����S�ɉ�����
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
      set paramU($paramUsize,R) $recListSeq    ;# recList�̔z��ԍ�

      setSto0 $paramUsize    ;# S�����̏ꍇ�͑��̃p�����[�^�ʒu�𓮂�����0�ɏC��

      set S [expr $S + $mspb]   ;# S�����̈ʒu�Ɉړ�

      ;# paramS�����߂�
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
    # ����wav�t�@�C�������u��.wav�v�ȂǕ������̈�؂Ȃ����O�������ꍇ�A���for�������s���ꂸ
    # oto.ini��wav�̃G���g�����̂������Ȃ��Ă��܂��B�����ňȉ��ŃG���g������ǉ�����B
    if {[llength $morae] <= 0} {
      set paramU($paramUsize,0) $fid           ;# fid
      set paramU($paramUsize,6) ""             ;# A
      set paramU($paramUsize,1) 0              ;# S
      set paramU($paramUsize,4) 0              ;# C
      set paramU($paramUsize,5) 0              ;# E
      set paramU($paramUsize,3) 0              ;# P
      set paramU($paramUsize,2) 0              ;# O
      set paramU($paramUsize,R) $recListSeq    ;# recList�̔z��ԍ�
      incr paramUsize
    }

    # MFCC�Ɋ�Â�S�̈ʒu�␳
    if {$genParam(autoAdjustRen2) && [llength $morae] > 0} {
      autoAdjustRen2 [expr $paramUsize - [llength $morae]]  [expr $paramUsize - 1]
    }

    set remain [expr ([clock seconds] - $procStart) * ($recListMax - $recListSeq) / ($recListSeq + 1)]
    updateProgressWindow [expr 100 * $recListSeq / [llength $recList]] "($recListSeq / $recListMax) (remain: $remain sec)"
  }

  deleteProgressWindow
  resetDisplay
  ;# �ꗗ�\�̃T�C�Y���X�V����
  if [winfo exists .entpwindow] {
    .entpwindow.t configure -rows $paramUsize
    setCellSelection
  }
  set v(paramChanged) 1
  setEPWTitle
  set paramU(size_1) [expr $paramUsize - 1]   ;# �\���p�ɍs��-1�����l��ۑ�
  set v(msg) [eval format $t(doGenParam,doneMsg)]
}

#---------------------------------------------------
# MFCC�Ɋ�Â�S�̈ʒu�␳
#
proc autoAdjustRen2 {start end} {   ;# start�Ԗڂ���end�Ԗ�(end-1�܂łł͂Ȃ�)�̃f�[�^����������
  global genParam v paramS paramU paramUsize t topdir

  set pattern [split $genParam(autoAdjustRen2Pattern) " "]

  ;# �K�p���ׂ����[��������Ȃ����return
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
        ;# �K�p���ׂ����[���łȂ����skip
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
# ���[����morae�̎w�肵���ʒui����A�����p�̃G�C���A�X(�ua ���v�Ȃ�)�����߂ĕԂ�
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
# �������1���[���ɕ������ĕԂ�
#
proc getMorae {inMorae} {
  set morae {}
  for {set i 0} {$i < [string length $inMorae]} {incr i} {
    set char [string range $inMorae $i $i]
    if [isKana $char] {
      if [isMora $char] {
        ;# ���݂�$char�͈ꃂ�[���Ȃ̂Ń��X�g�ɒǉ�
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
# �ꃂ�[���̕ꉹ���̉��f��Ԃ�
#
proc getVowel {mora} {
  set last [expr [string length $mora] -1]
  set char [string range $mora $last $last]

  set vA {�� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� \
          �A �J �T �^ �i �n �} �� �� �� �K �U �_ �o �p �� �@ �� }
  set vI {�� �� �� �� �� �� ��    ��    �� �� �� �� ��    �� �� \
          �C �L �V �` �j �q �~    ��    �M �W �a �r �s    �B �� }
  set vU {�� �� �� �� �� �� �� �� ��    �� �� �� �� �� �� �� �� �� \
          �E �N �X �c �k �t �� �� ��       �O �Y �d �u �v �D �� �b }
  set vE {�� �� �� �� �� �� ��    ��    �� �� �� �� ��    �� �� \
          �G �P �Z �e �l �w ��    ��    �Q �[ �f �x �y    �F �� }
  set vO {�� �� �� �� �� �� �� �� �� �� �� �� �� �� �� �� ��    \
          �I �R �\ �g �m �z �� �� �� �� �S �] �h �{ �| �� �H    }
  set vN {�� ��}
  set vR {_}

  if {[lsearch $vA $char] >= 0} { return "a" }
  if {[lsearch $vI $char] >= 0} { return "i" }
  if {[lsearch $vU $char] >= 0} { return "u" }
  if {[lsearch $vE $char] >= 0} { return "e" }
  if {[lsearch $vO $char] >= 0} { return "o" }
  if {[lsearch $vN $char] >= 0} { return "n" }
  if {[lsearch $vR $char] >= 0} { return "-" }   ;# �x���������ꍇ
}

#---------------------------------------------------
# char���������܂��͕Љ����Ȃ�1���A����ȊO�Ȃ�0��Ԃ�
#
proc isKana {char} {
  set kanaList {�� �� �� �� �� �� �� �� �� ��    �� �� �� �� �� �� �� �� \
                �A �J �T �^ �i �n �} �� �� ��    �K �U �_ �o �p �� �@ �� \
                �� �� �� �� �� �� ��    ��       �� �� �� �� ��    �� �� \
                �C �L �V �` �j �q �~    ��       �M �W �a �r �s    �B �� \
                �� �� �� �� �� �� �� �� ��       �� �� �� �� �� �� �� �� \
                �E �N �X �c �k �t �� �� ��    �� �O �Y �d �u �v �� �D �b \
                �� �� �� �� �� �� ��    ��       �� �� �� �� ��    �� �� \
                �G �P �Z �e �l �w ��    ��       �Q �[ �f �x �y    �F �� \
                �� �� �� �� �� �� �� �� �� ��    �� �� �� �� �� �� ��    \
                �I �R �\ �g �m �z �� �� �� ��    �S �] �h �{ �| �� �H    \
                �� �� �J �K ��\
                _ }
  if {[lsearch $kanaList $char] >= 0} {
    return 1
  } else {
    return 0
  }
}

#---------------------------------------------------
# char���ꃂ�[���Ȃ�1���A�X���ȂǂȂ�0��Ԃ�
#
proc isMora {char} {
  set notMora {�� �� �� �� �� �� �� �� �� �� \
               �@ �B �D �F �H �� �� �� �� �b �J �K ��}
  if {[lsearch $notMora $char] >= 0} {
    return 0
  } else {
    return 1
  }
}

#---------------------------------------------------
# �P�Ɖ���UTAU�����p�����[�^�𐄒肷��ۂ̐ݒ葋
#
proc estimateParam {} {
  global epwindow power estimate v t

  if [isExist $epwindow] return  ;# ��d�N����h�~
  toplevel $epwindow
  wm title $epwindow $t(estimateParam,title)
  wm resizable $epwindow 0 0
  bind $epwindow <Escape> "destroy $epwindow"

  set w [frame $epwindow.al]
  pack $w
  set row 0

  ;# �p���[���o���݂̐ݒ�
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

  ;# �v���G���t�@�V�X�̐ݒ�
  # frame $w.fem
  label $w.lem -text $t(estimateParam,preemph)
  entry $w.eem -textvar power(preemphasis)
  grid $w.lem  -sticky w -row $row -column 0
  grid $w.eem  -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# �p���[���o�����̐ݒ�
  label $w.lwl -text $t(estimateParam,pWinLen)
  entry $w.ewlSec -textvar power(windowLength)
  label $w.lwlSec -text "(sec)"
  grid $w.lwl      -sticky w -row $row -column 0
  grid $w.ewlSec   -sticky w -row $row -column 1
  grid $w.lwlSec   -sticky w -row $row -column 2 -columnspan 2
  incr row

  ;# ���̑I��
  # frame $w.fwn
  label $w.lwn -text $t(estimateParam,pWinkind)
  tk_optionMenu $w.mwn power(window) \
    Hamming Hanning Bartlett Blackman Rectangle
  grid $w.lwn  -sticky w -row $row -column 0
  grid $w.mwn  -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# ���b���Ƃ݂Ȃ����p���[�̐ݒ�
  # frame $w.fhi
  label $w.lhi -text $t(estimateParam,pUttMin)
  entry $w.ehi -textvar power(uttHigh)
  label $w.lhiu -text "(db)"
  grid $w.lhi  -sticky w -row $row -column 0
  grid $w.ehi  -sticky w -row $row -column 1
  grid $w.lhiu -sticky w -row $row -column 2 -columnspan 2
  incr row

  ;# ���b���Ƃ݂Ȃ���鎞�Ԓ��̐ݒ�
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

  ;# �������ɐ�����p���[�̗h�炬�̑傫���ݒ�
  # frame $w.fhi
  label $w.lkp -text $t(estimateParam,uttLen)
  entry $w.ekp -textvar power(uttKeep)
  label $w.lkpu -text "(db)"
  grid $w.lkp  -sticky w -row $row -column 0
  grid $w.ekp  -sticky w -row $row -column 1
  grid $w.lkpu -sticky w -row $row -column 2 -columnspan 2
  incr row

  ;# �|�[�Y���Ƃ݂Ȃ����p���[�̐ݒ�
  # frame $w.flw
  label $w.llw -text $t(estimateParam,silMax)
  entry $w.elw -textvar power(uttLow)
  label $w.llwu -text "(db)"
  grid $w.llw  -sticky w -row $row -column 0
  grid $w.elw  -sticky w -row $row -column 1
  grid $w.llwu -sticky w -row $row -column 2 -columnspan 2
  incr row

  ;# �ꉹ�p���[�ŏ��l�̐ݒ�i���̒l�����͎q�����Ƃ݂Ȃ��j
  label $w.lmv -text $t(estimateParam,vLow)
  entry $w.emvSec -textvar power(vLow)
  label $w.lmvSec -text "(db)"
  grid $w.lmv      -sticky w -row $row -column 0
  grid $w.emvSec   -sticky w -row $row -column 1
  grid $w.lmvSec   -sticky w -row $row -column 2
  incr row

  ;# �|�[�Y�Ƃ݂Ȃ���鎞�Ԓ��̐ݒ�
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

  ;# �q�����ŏ��l�̐ݒ�i�q����=0��UTAU���G���[�ɂȂ�̂�������邽�߁j
  label $w.lmc -text $t(estimateParam,minC)
  entry $w.emcSec -textvar estimate(minC)
  label $w.lmcSec -text "(sec)"
  grid $w.lmc      -sticky w -row $row -column 0
  grid $w.emcSec   -sticky w -row $row -column 1
  grid $w.lmcSec   -sticky w -row $row -column 2
  incr row

  ;# F0�Ɋւ��������
  label $w.lf0 -text $t(estimateParam,f0)
  grid $w.lf0      -sticky w -row $row -column 0 -columnspan 3
  incr row

  ;# ����Ώۂ̐ݒ�
  # frame $w.fem
  label $w.l$row -text $t(estimateParam,target)
  frame $w.fe$row
  checkbutton $w.fe$row.b -variable estimate(S)
  label $w.fe$row.t -text $t(estimateParam,S)
  pack $w.fe$row.b $w.fe$row.t -side left
  grid $w.l$row  -sticky w -row $row -column 0
  grid $w.fe$row -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# ����Ώۂ̐ݒ�
  # frame $w.fem
  frame $w.fe$row
  checkbutton $w.fe$row.b -variable estimate(C)
  label $w.fe$row.t -text $t(estimateParam,C)
  pack $w.fe$row.b $w.fe$row.t -side left
  grid $w.fe$row -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# ����Ώۂ̐ݒ�
  # frame $w.fem
  frame $w.fe$row
  checkbutton $w.fe$row.b -variable estimate(E)
  label $w.fe$row.t -text $t(estimateParam,E)
  pack $w.fe$row.b $w.fe$row.t -side left
  grid $w.fe$row -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# ����Ώۂ̐ݒ�
  # frame $w.fem
  frame $w.fe$row
  checkbutton $w.fe$row.b -variable estimate(P)
  label $w.fe$row.t -text $t(estimateParam,P)
  pack $w.fe$row.b $w.fe$row.t -side left
  grid $w.fe$row -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# ����Ώۂ̐ݒ�
  # frame $w.fem
  frame $w.fe$row
  checkbutton $w.fe$row.b -variable estimate(O)
  label $w.fe$row.t -text $t(estimateParam,O)
  pack $w.fe$row.b $w.fe$row.t -side left
  grid $w.fe$row -sticky w -row $row -column 1 -columnspan 3
  incr row

  ;# �{�^���̐ݒ�
  # frame $w.fbt
  button $w.do -text $t(estimateParam,runAll) -command {
    if $v(paramChanged) {
      set act [tk_dialog .confm $t(.confm) $t(estimateParam,overWrite) \
        question 1 $t(.confm.ok) $t(.confm.c)]
      if {$act == 1} return
    }
    ;# �����G���g�������󗓂������Ȃ�0����
    if {[string length $power(silLengthSec)] == 0} {
      set power(silLengthSec) 0
    }
    if {[string length $power(uttLengthSec)] == 0} {
      set power(uttLengthSec) 0
    }

    if {$::tcl_platform(os) != "Darwin"} { grab set $epwindow }
    if {$v(appname) == "OREMO"}          { makeRecListFromDir 0 0 }
    doEstimateParam all
    if {$::tcl_platform(os) == "Darwin"} { deleteProgressWindow } ;# �Ȃ���mac�ł�doEstimateParam�̒��ŏ����Ȃ�����
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
      ;# �����G���g�������󗓂������Ȃ�0����
      if {[string length $power(silLengthSec)] == 0} {
        set power(silLengthSec) 0
      }
      if {[string length $power(uttLengthSec)] == 0} {
        set power(uttLengthSec) 0
      }

      grab set $epwindow     ;# ���蒆�͑��̑��삪�o���Ȃ��悤�ɂ���
      doEstimateParam sel
      grab release $epwindow ;# ���蒆�͑��̑��삪�o���Ȃ��悤�ɂ���
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
# UTAU�����p�����[�^�̐���
#
proc doEstimateParam {{mode all}} {
  global power v paramS paramU paramUsize estimate t f0 ;# f0�͑��ł��g���Ă���

  set v(msg) $t(doEstimateParam,startMsg)

  snack::sound sWork

  initProgressWindow

  ;# ���肷��s�ԍ��̃��X�g�����
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
    ;# wav�t�@�C����ǂ�
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

    ;# �p���[�𒊏o����
    set pw [sWork power -framelength $power(frameLength) \
      -windowtype $power(window) -preemphasisfactor $power(preemphasis) \
      -windowlength [expr int($power(windowLength) * $v(sampleRate))] \
      -start 0 -end -1]

    ;# �����l�ݒ�
    if $estimate(S) { set paramS($i,S) 0 }
    if $estimate(C) { set paramS($i,C) $estimate(minC) }
    if $estimate(E) { set paramS($i,E) [sWork length -unit SECONDS] }
    set uttS 0           ;# �������ʂ��\���ȑ傫���ɂȂ��Ă���Ƃ݂Ȃ��ꂽ�ʒu
    set uttE [expr [llength $pw] - 1]     ;# �������ʂ��������n�߂�ʒu

    if {[llength $pw] > 0} {
      ;# �����̔��b���m��_��T��
      set length 0   ;# ���b���A�����Ă���T���v����
      for {set j 0} {$j < [llength $pw]} {incr j} {
        if {[lindex $pw $j] >= $power(uttHigh)} {
          incr length
        } else {
          set length 0
        }
        if {$length >= [expr $power(uttLength) + 1]} {
          set uttS $j     ;# ���݈ʒu��ۑ�
          break
        }
      }
      ;# ���ɂ��ǂ��č��u�����N�ʒu�i���b�J�n�_�j��T��
      if $estimate(S) {
        set length 0
        for {set k $j} {$k > 0} {incr k -1} {
          if {[lindex $pw $k] <= $power(uttLow)} {
            incr length
          } else {
            set length 0
          }
          if {$length >= [expr $power(silLength) + 1]} {
            ;# ���݈ʒu�����u�����N�ɂ���
            set tm [expr $k * $power(frameLength)] ;# ����[sec]���v�Z
            set paramS($i,S) $tm
            break
          }
        }
      }

      ;# �������ʂ��������n�߂�_�����߂�
      set length 0   ;# ���b���A�����Ă���T���v����
      for {set j [expr [llength $pw] - 1]} {$j > $uttS} {incr j -1} {
        if {[lindex $pw $j] >= $power(uttHigh)} {
          incr length
        } else {
          set length 0
        }
        if {$length >= [expr $power(uttLength) + 1]} {
          set uttE $j     ;# ���݈ʒu��ۑ�
          break
        }
      }

      ;# uttS�`uttE�Ԃ̒����t�߂̕��σp���[aveP�����߂�
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

      ;# �E�u�����N�ʒu��T��
      if $estimate(E) {
        for {set j $center} {$j <= $uttE} {incr j} {
;#koko, �p���[�����ϒl���傫�����ɗh�炢�ł��镪��OK�Ƃ����B
;#koko, �p���[�����ϒl��菬�����h�炢���Ƃ��ɔ���������悤�ɂ���
          if {[expr $aveP - [lindex $pw $j]] > [expr $power(uttKeep) / 2]} {
            break
          }
        }
        ;# ���݈ʒu���E�u�����N�ɂ���
        set tm [expr $j * $power(frameLength)] ;# ����[sec]���v�Z
        if {$paramS($i,S) < $tm} {
          set paramS($i,E) $tm
        } else {
          set paramS($i,E) $paramS($i,S)
        }
      }

      ;# �q�����ʒu��T��
      if $estimate(C) {
        for {set j $center} {$j >= $uttS} {incr j -1} {
;#koko, �p���[�����ϒl���傫�����ɗh�炢�ł��镪��OK�Ƃ����B
;#koko, �p���[�����ϒl��菬�����h�炢���Ƃ��ɔ���������悤�ɂ���
          if {[expr $aveP - [lindex $pw $j]] > [expr $power(uttKeep) / 2]} {
            break
          }
        }
        ;# ���݈ʒu���q�����ɂ���
        set tm [expr $j * $power(frameLength)] ;# ����[sec]���v�Z
        if {$tm >= [expr $paramS($i,S) + $estimate(minC)]} {
          set paramS($i,C) $tm
        } else {
          set paramS($i,C) [expr $paramS($i,S) + $estimate(minC)]
        }
      }
    }

    ;# ��s�����ʒu��T��
    if $estimate(P) {
      set paramS($i,P) $paramS($i,S)

      ;# �L���J�n�ʒu�����߂�
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

      ;# vot����E�ɍs���A�ꉹ�p���[�ŏ��l�𒴂��鏊�܂ňړ�����
      for {set j [expr int($votSec / $power(frameLength))]} \
          {[expr $j * $power(frameLength)] < $paramS($i,C)} \
          {incr j} {
        if {[lindex $pw $j] >= $power(vLow)} break
      }

      ;# ���݈ʒu���s�����ɂ���
      set tm [expr $j * $power(frameLength)] ;# ����[sec]���v�Z
      if {$tm <= $paramS($i,C)} {
        set paramS($i,P) $tm
      } else {
        set paramS($i,P) $paramS($i,S)
      }
    }

    ;# �I�[�o�[���b�v�ʒu��T���B���ݖ������B
    if $estimate(O) {
      set paramS($i,O) $paramS($i,S)
    }

    ;# paramU��ݒ肷��
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
# �����p�����[�^��ۑ�����
# return: 1=�ۑ������B0=�ۑ����Ȃ������B
# ����1 fn: �ۑ��t�@�C�����B�w��Ȃ��̏ꍇ�_�C�A���O�����J��
# ����2 autoBackup: 0=�ʏ��oto.ini�ۑ��B
#         1=�����o�b�N�A�b�v�̂��߂̕ۑ��B�L���b�V���t�@�C����ۑ����Ȃ��B
#           �ۑ������ۂɃ��b�Z�[�W��\�����Ȃ��B
#
proc saveParamFile {{fn ""} {autoBackup 0}} {
  global paramU paramUsize v t
 
  ;#if {$v(paramChanged) == 0} {
  ;#  set v(msg) "�p�����[�^���ύX����Ă��Ȃ��̂ŕۑ����܂���ł���"
  ;#  tk_dialog .confm "Warning" \
  ;#    "�p�����[�^���ύX����Ă��Ȃ��̂ŕۑ����܂���ł���" \
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
  ;# �ۑ��t�@�C�����J��
  if [catch {open $fn w} fp] {
    tk_messageBox -message "error: can not open $fn" \
      -title $t(.confm.fioErr) -icon warning
    return
  }
  if {$::tcl_platform(os) != "Darwin"} {
    set v(paramFile) $fn  ;# mac���ƃp�X��͂Ɏ��s���Ď����my_getSaveFile�ŕs���m�ȃt�H���_�������w�肳�ꂽ�̂�
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
      puts $fp $name=$A,$S,$C,$E,$P,$O    ;# �t�@�C���֏����o��
    }
  }
  close $fp        ;# �t�@�C�������

  if {$::tcl_platform(os) == "Darwin"} {
    global nkf 
    exec -- $nkf -s --in-place $fn      ;# �����R�[�h��sjis�ɕϊ�
  }
  if {$autoBackup == 0} {
    if {$v(appname) != "OREMO"} {
      saveCacheFile    ;# �L���b�V���쐬�B�����oto.ini�ۑ�����ɂ���Ă͂����Ȃ��B
      set v(paramChanged) 0
      setEPWTitle
    }
    set v(msg) [eval format $t(saveParamFile,doneMsg)]
  }
  return 1
}

#---------------------------------------------------
# �����������_�ȉ�6���őł��؂�
#
proc cut6 {val} {
  return [expr int($val * 1000000) / 1000000.0 ]
}

#---------------------------------------------------
# �����������_�ȉ�3���őł��؂�
#
proc cut3 {val} {
  return [expr int($val * 1000) / 1000.0 ]
}

#---------------------------------------------------
# �P�ʕϊ�
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
# �p�����[�^��ޖ���paramU��ԍ��ɕϊ�
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
# paramU�̗�ԍ����p�����[�^��ޖ��ɕϊ�
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
# �w�肵���s��paramU��paramS�ɕϊ�����
# �g�`����$v(sndLength)�ɓ����Ă��邱�Ƃ��O��
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
# �P�ʕϊ�(�b��UTAU�����p�����[�^)
#
proc sec2u {r kind newVal} {  ;# r=-1:�A�N�e�B�u�Z����ϊ��B
  global paramS paramU snd paDev v t

  if {$r < 0} {set r $v(listSeq)}  ;# ���݂̃A�N�e�B�u�Z���̍s�ԍ�

  if {[llength $newVal] == 0} {
    set newVal $paramS($r,$kind)   ;# �ϊ��������l(�b�P��)������B
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
# �P�ʕϊ�(UTAU�����p�����[�^���b)
# snd �ɔg�`��ǂ�ł��邱�Ƃ��O��
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

