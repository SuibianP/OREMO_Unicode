#!/bin/sh
# �w�肵���K�C�hBGM�ɑΉ������^���ݒ�t�@�C�����쐬����c�[��
#
# the next line restarts using wish \
exec wish "$0" "$@"

package require -exact snack 2.2
snack::createIcons    ;# �A�C�R�����g�p����

#---------------------------------------------------

set v(appname) KOREDE
set v(version) 1.0         ;# �\�t�g�̃o�[�W�����ԍ�
set v(bgmFile) ""
set v(fg)      black
set v(cWidth)  600
set v(cHeight) 200
set v(timeh)   25
set v(pre)      0
set v(playNow)  0
set v(playTime) 0
set v(sndLen)   0
set v(wavepps)  100

set v(bgmStartMsg)   "BGM�Đ�"
set v(bgmStart) 0
set v(bgmEndMsg)     "�^����ۑ�������"
set v(bgmEnd)   0
set v(recStartMsg)   "�^���J�n"
set v(recStart) 0
set v(recEndMsg)     "�^����~"
set v(recEnd)   0
set v(uttStartMsg)   "�����͂��߁I"
set v(uttStart) 0
set v(uttEndMsg)     "���������I"
set v(uttEnd)   0

snack::sound snd

#---------------------------------------------------

proc Redraw {} {
  global v c snd

  set v(pre) [expr int(($v(uttStart) - $v(recStart)) * 1000 + 0.5) / 1000.0]
  if {$v(sndLen) > 0} {
    set v(wavepps) [expr double($v(cWidth)) / $v(sndLen)]
  } else {
    set v(wavepps) [expr double(1.0 / $v(cWidth))]
  }

  set xtmp [expr [winfo width .] - 4]
  if {$v(cWidth) != $xtmp && $xtmp > 0} {
    set v(cWidth) $xtmp
  }
  $c configure -width $v(cWidth)
  $c delete all
  $c create waveform 0 0 -sound snd -height [expr $v(cHeight) - $v(timeh)] -width $v(cWidth) -fill #707070

  # ���Ԏ�
  set ytmp [expr $v(cHeight) - $v(timeh)]
  snack::timeAxis $c 0 $ytmp $v(cWidth) $v(timeh) $v(wavepps) \
    -starttime 0 -fill $v(fg)
  $c create line 0 $ytmp       $v(cWidth) $ytmp
  $c create line 0 $v(cHeight) $v(cWidth) $v(cHeight)

  ;# �Đ���ԕ\��
  set ylow [expr $v(cHeight) - $v(timeh)]
  set ytmp [expr $v(cHeight) - $v(timeh) - 20]
  set l    [expr $v(bgmStart) * $v(wavepps)]
  set r    [expr $v(bgmEnd)   * $v(wavepps)]
  if {$l < $r} {
    $c create rectangle $l $ytmp $r $ylow -wi 2 -outline green -fill green -stipple gray25
  }
  ;# �^����ԕ\��
  set ylow [expr $v(cHeight) - $v(timeh)]
  set ytmp [expr $v(cHeight) - $v(timeh) - 22]
  set l    [expr $v(recStart) * $v(wavepps)]
  set r    [expr $v(recEnd)   * $v(wavepps)]
  if {$l < $r} {
    $c create rectangle $l $ytmp $r $ylow -wi 2 -outline red -fill red -stipple gray25
  }
  ;# ������ԕ\��
  set ylow [expr $v(cHeight) - $v(timeh)]
  set ytmp [expr $v(cHeight) - $v(timeh) - 24]
  set l    [expr $v(uttStart) * $v(wavepps)]
  set r    [expr $v(uttEnd)   * $v(wavepps)]
  if {$l < $r} {
    $c create rectangle $l $ytmp $r $ylow -wi 2 -outline blue -fill blue -stipple gray25
  }

  update
}

proc showPlayTime {offset} {
  global v c

  $c delete playBar
  if {$v(playNow) == 0} {
    set v(playTime) 0
    return
  }
  set v(playTime) [expr int(100 * ([snack::audio elapsedTime] + $offset)) / 100.0]
  set x [expr $v(playTime) * $v(wavepps)]
  $c create line $x 0 $x $v(cHeight) -fill #FFA000 -tags playBar
  after 50 showPlayTime $offset
}

proc checkVal {val old} {
  global v

  if {![string is double $val]} {return 0}
  if {$val != "" && $val < 0} {return 0}
  if {$val == $old} Redraw
  return 1
}

proc playStart {{stSec 0} {en -1}} {
  global snd v

  set st [expr int($stSec * [snd cget -rate])]
  if {$en > 0} {
    set en [expr $en * [snd cget -rate]]
  }
  set en [expr int($en)]

  snd play -start $st -end $en -command playStop
  set v(playNow) 1
  after 50 showPlayTime $stSec
}

proc playStop {} {
  global v
  snd stop
  set v(playNow) 0
}

proc regionPlay {st en} {
  global v

  if {$st == "" || ![string is double $st]} { set st 0  }
  if {$en == "" || ![string is double $en]} { set en -1 }
  playStart $st $en
}

proc saveSettingFile {{_fn ""}} {
  global v

  # �G���[�`�F�b�N
  foreach key {bgmStart recStart uttStart uttEnd recEnd bgmEnd} {
    if {$v($key) < 0 || $v($key) > $v(sndLen)} {
      tk_messageBox -message "�K��͈͊O�̒l������܂��B($key)" -title "�G���[" -icon warning
      return
    }
  }
  if {$v(bgmStart) >= $v(recStart)} {
    tk_messageBox -message "(BGM�Đ��J�n < �^���J�n)�ɂ��ĉ�����" -title "�G���[" -icon warning
    return
  }
  if {$v(recStart) >= $v(uttStart)} {
    tk_messageBox -message "(�^���J�n < �����J�n)�ɂ��ĉ�����" -title "�G���[" -icon warning
    return
  }
  if {$v(uttStart) >= $v(uttEnd)} {
    tk_messageBox -message "(�����J�n < ������~)�ɂ��ĉ�����" -title "�G���[" -icon warning
    return
  }
  if {$v(uttEnd) >= $v(recEnd)} {
    tk_messageBox -message "(������~ < �^����~)�ɂ��ĉ�����" -title "�G���[" -icon warning
    return
  }
  if {$v(recEnd) >= $v(bgmEnd)} {
    tk_messageBox -message "(�^����~ < BGM�Đ���~)�ɂ��ĉ�����" -title "�G���[" -icon warning
    return
  }

  set fn ""
  if {$_fn != ""} {
    set fn $_fn
  } elseif {$v(bgmFile) != ""} {
    set fn [file rootname $v(bgmFile)].txt
  }
  if {[file exists $fn]} {
    set act [tk_dialog .confm "�m�F" "$fn �ɏ㏑���ۑ����܂����H" question 2 "�͂�" "�ʖ��ŕۑ�" "�L�����Z��"]
    if {$act == 1} {
      set fn [tk_getSaveFile -initialfile $fn \
        -title "�ݒ�t�@�C���̕ۑ�" -defaultextension "txt" \
        -filetypes { {{typelist file} {.txt}} {{All Files} {*}} }]
    }
    if {$act == 2} return
  }
  if {$fn == ""} return

  if [catch {open $fn w} out] { 
    tk_messageBox -message "�ݒ�t�@�C��($fn)�ɕۑ��ł��܂���ł���" -title "�G���[" -icon warning
    return
  }

  set fnout [file tail $v(bgmFile)]
  puts $out "sec"
  puts $out "#"
  puts $out "# $fnout�p�̐ݒ�t�@�C��"
  puts $out "#"
  puts $out "# No, ����, r�J�n, r��~, ���L�[��, ���s�[�g, �R�����g"
  puts $out "   1, $v(bgmStart),\t0, 0, 0, 0, $v(bgmStartMsg)"
  puts $out "   2, $v(recStart),\t1, 0, 0, 0, $v(recStartMsg)"
  puts $out "   3, $v(uttStart),\t0, 0, 0, 0, $v(uttStartMsg)"
  puts $out "   4, $v(uttEnd),\t0, 0, 0, 0, $v(uttEndMsg)"
  puts $out "   5, $v(recEnd),\t0, 1, 0, 0, $v(recEndMsg)"
  puts $out "   6, $v(bgmEnd),\t0, 0, 1, 1, $v(bgmEndMsg)"

  close $out
  tk_messageBox -message "�ۑ����܂���($fn)" -title "�ۑ�����" -icon info
}

#------------------------------------------------------------

set row 0
set f [frame .f$row]
grid $f -row $row -column 0 -sticky nw
label $f.lBgm -text "BGM�t�@�C���F"
entry $f.eBgm -textvar v(bgmFile) -wi 60
button $f.bBgm -image snackOpen -text "�I��" -command {
  set t(bgmGuide,bTitle) "BGM�t�@�C���̑I��"
  set fn [tk_getOpenFile -initialfile $v(bgmFile) \
          -title $t(bgmGuide,bTitle) -defaultextension "wav" \
          -filetypes { {{wav file} {.wav}} {{All Files} {*}} }]
  if {$fn != ""} {
    set v(bgmFile) $fn
    snd read $v(bgmFile)
    set v(sndLen) [expr int(1000 * [snd length -unit SECONDS]) / 1000.0]
    set v(bgmEnd) $v(sndLen)
    Redraw
  }
}
button $f.bPlay -text "�Đ�" -bitmap snackPlay -command playStart
button $f.bStop -text "��~" -bitmap snackStop -command {
  snd stop
  set v(playNow) 0
}
label $f.playTime -textvar v(playTime)
label $f.playSep  -text "/"
label $f.sndLen   -textvar v(sndLen)

pack $f.lBgm $f.eBgm $f.bBgm $f.bPlay $f.bStop $f.playTime $f.playSep $f.sndLen -side left

incr row
set c [canvas .c$row -width $v(cWidth) -height $v(cHeight)]
grid $c -row $row -column 0 -sticky nwse

incr row
set f [frame .f$row]
grid $f -row $row -column 0 -sticky nwse
button $f.lSeq   -relief groove -text "No."
button $f.lStart -relief groove -text "�C�x���g"
button $f.lSval  -relief groove -text "����(�b)"
button $f.lSMsg  -relief groove -text "�K�C�h��"
button $f.lSeq2  -relief groove -text "No."
button $f.lEnd   -relief groove -text "�C�x���g"
button $f.lEval  -relief groove -text "����(�b)"
button $f.lEMsg  -relief groove -text "�K�C�h��"
button $f.lPlay  -relief groove -text "��ԍĐ�"
label $f.lBgmStart -text "BGM�Đ��J�n�F"
label $f.lRecStart -text "�^���J�n�F"
label $f.lUttStart -text "�����J�n�F"
label $f.lUttEnd   -text "������~�F"
label $f.lRecEnd   -text "�^����~�F"
label $f.lBgmEnd   -text "BGM�Đ���~�F"

label $f.nBgmStart -text "1"
label $f.nRecStart -text "2"
label $f.nUttStart -text "3"
label $f.nUttEnd   -text "4"
label $f.nRecEnd   -text "5"
label $f.nBgmEnd   -text "6"

entry $f.eBgmStart -wi 5 -textvar v(bgmStart) -validate all -validatecommand {checkVal %P %s}
entry $f.eBgmStartMsg -textvar v(bgmStartMsg)
entry $f.eBgmEnd   -wi 5 -textvar v(bgmEnd)   -validate all -validatecommand {checkVal %P %s}
entry $f.eBgmEndMsg   -textvar v(bgmEndMsg)
entry $f.eRecStart -wi 5 -textvar v(recStart) -validate all -validatecommand {checkVal %P %s}
entry $f.eRecStartMsg -textvar v(recStartMsg)
entry $f.eRecEnd   -wi 5 -textvar v(recEnd)   -validate all -validatecommand {checkVal %P %s}
entry $f.eRecEndMsg   -textvar v(recEndMsg)
entry $f.eUttStart -wi 5 -textvar v(uttStart) -validate all -validatecommand {checkVal %P %s}
entry $f.eUttStartMsg -textvar v(uttStartMsg)
entry $f.eUttEnd   -wi 5 -textvar v(uttEnd)   -validate all -validatecommand {checkVal %P %s}
entry $f.eUttEndMsg   -textvar v(uttEndMsg)

button $f.bBgm -bitmap snackPlay -text "��ԍĐ�" -bg green -command {regionPlay $v(bgmStart) $v(bgmEnd)}
button $f.bRec -bitmap snackPlay -text "��ԍĐ�" -bg red   -command {regionPlay $v(recStart) $v(recEnd)}
button $f.bUtt -bitmap snackPlay -text "��ԍĐ�" -bg blue  -command {regionPlay $v(uttStart) $v(uttEnd)}

grid $f.lSeq         -row 0 -column 0 -sticky nwse
grid $f.lStart       -row 0 -column 1 -sticky nwse
grid $f.lSval        -row 0 -column 2 -sticky nwse
grid $f.lSMsg        -row 0 -column 3 -sticky nwse
grid $f.lSeq2        -row 0 -column 4 -sticky nwse
grid $f.lEnd         -row 0 -column 5 -sticky nwse
grid $f.lEval        -row 0 -column 6 -sticky nwse
grid $f.lEMsg        -row 0 -column 7 -sticky nwse
grid $f.lPlay        -row 0 -column 8 -sticky nwse

grid $f.nBgmStart    -row 1 -column 0 -sticky ne
grid $f.lBgmStart    -row 1 -column 1 -sticky ne
grid $f.eBgmStart    -row 1 -column 2 -sticky nwse
grid $f.eBgmStartMsg -row 1 -column 3 -sticky nwse
grid $f.nBgmEnd      -row 1 -column 4 -sticky ne
grid $f.lBgmEnd      -row 1 -column 5 -sticky ne
grid $f.eBgmEnd      -row 1 -column 6 -sticky nwse
grid $f.eBgmEndMsg   -row 1 -column 7 -sticky nwse
grid $f.bBgm         -row 1 -column 8 -sticky n

grid $f.nRecStart    -row 2 -column 0 -sticky ne
grid $f.lRecStart    -row 2 -column 1 -sticky ne
grid $f.eRecStart    -row 2 -column 2 -sticky nwse
grid $f.eRecStartMsg -row 2 -column 3 -sticky nwse
grid $f.nRecEnd      -row 2 -column 4 -sticky ne
grid $f.lRecEnd      -row 2 -column 5 -sticky ne
grid $f.eRecEnd      -row 2 -column 6 -sticky nwse
grid $f.eRecEndMsg   -row 2 -column 7 -sticky nwse
grid $f.bRec         -row 2 -column 8 -sticky n

grid $f.nUttStart    -row 3 -column 0 -sticky ne
grid $f.lUttStart    -row 3 -column 1 -sticky ne
grid $f.eUttStart    -row 3 -column 2 -sticky nwse
grid $f.eUttStartMsg -row 3 -column 3 -sticky nwse
grid $f.nUttEnd      -row 3 -column 4 -sticky ne
grid $f.lUttEnd      -row 3 -column 5 -sticky ne
grid $f.eUttEnd      -row 3 -column 6 -sticky nwse
grid $f.eUttEndMsg   -row 3 -column 7 -sticky nwse
grid $f.bUtt         -row 3 -column 8 -sticky n

incr row
set f [frame .f$row]
grid $f -row $row -column 0 -sticky nwse
button $f.bSave    -text "�ۑ�" -command saveSettingFile
label $f.lPre      -text "���ŏ��̐�s�����l = �����J�n - �^���J�n = "
label $f.ePre      -textvar v(pre)

grid $f.bSave        -row 0 -column 0 -sticky nw
grid $f.lPre         -row 0 -column 1 -sticky nw
grid $f.ePre         -row 0 -column 2 -sticky nw

#---------------------------------------------------

update
Redraw
wm title . "$v(appname) $v(version)"
wm minsize . [winfo width .] [winfo height .]

bind . <Configure> Redraw
