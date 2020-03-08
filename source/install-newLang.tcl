#!/bin/sh
#
# �{�t�@�C���� message/ �ɒu���Ď��s���邱��
#
# the next line restarts using wish \
exec wish "$0" "$@"

set transMark "_NOT_YET_"

#---------------------------------------------------
# main

if {[info exists ::starkit::topdir]} {
  set tgtDir [file normalize [file dirname [info nameofexecutable]]]
} else {
  set tgtDir [file normalize [file dirname $argv0]]
}
set srcDir $tgtDir

wm title . "Install the New Language"

;#-------------------------------------
set r 1
set f($r) [labelframe .f$r -relief groove -padx 5 -pady 5]
grid $f($r) -row $r -column 0 -sticky new -padx 5 -pady 5

label $f($r).l0 -fg red -text "<< $r. Specify the folder that have message-files written in your language >>"

entry $f($r).l1 -textvar srcDir
button $f($r).b1 -text "select source folder" -command {
  set srcDir [tk_chooseDirectory -initialdir $srcDir -title "choose the folder that have message-files written in your language"]
}
grid $f($r).l0 -row 0 -column 0 -sticky w -columnspan 2
grid $f($r).b1 -row 1 -column 0
grid $f($r).l1 -row 1 -column 1 -sticky ew

;#-------------------------------------
incr r
set f($r) [labelframe .f$r -relief groove -padx 5 -pady 5]
grid $f($r) -row $r -column 0 -sticky new -padx 5 -pady 5

label $f($r).l0 -fg red -text "<< $r. Specify the message-folder of OREMO you installed >>"

entry $f($r).l1 -textvar tgtDir
button $f($r).b1 -text "select target folder" -command {
  set tgtDir [tk_chooseDirectory -initialdir $tgtDir -title "choose the folder that have message-files written in your language"]
}
grid $f($r).l0 -row 0 -column 0 -sticky w -columnspan 2
grid $f($r).b1 -row 1 -column 0
grid $f($r).l1 -row 1 -column 1 -sticky ew

;#-------------------------------------
incr r
set f($r) [labelframe .f$r -relief groove -padx 5 -pady 5]
grid $f($r) -row $r -column 0 -sticky new -padx 5 -pady 5

set purpose "user"
label $f($r).lT -fg red -text "<< $r. Special question >>"
label $f($r).lC -text "(In most cases, you would check 'No')"
label $f($r).lQ -text "Are you a translator and do you want to check whether your translation is done?"
radiobutton $f($r).bU -text "No, I'm just an user who want to install the translated-files." -variable purpose -value "user"
radiobutton $f($r).bT -text "Yes, I'm a translator." -variable purpose -value "translator"

grid $f($r).lT -row 0 -column 0 -sticky nw
grid $f($r).lC -row 1 -column 0 -sticky nw
grid $f($r).lQ -row 2 -column 0 -sticky nw
grid $f($r).bU -row 3 -column 0 -sticky nw
grid $f($r).bT -row 4 -column 0 -sticky nw

;#-------------------------------------
incr r
set f($r) [labelframe .f$r -relief groove -padx 5 -pady 5]
grid $f($r) -row $r -column 0 -sticky new -padx 5 -pady 5

label $f($r).l2 -fg red -text "<< $r. Install (merge your message-files into OREMO message-files) >>"
label $f($r).l30 -text " - install source folder: "
label $f($r).l31 -textvar srcDir -fg blue
label $f($r).l40 -text " - install target folder: "
label $f($r).l41 -textvar tgtDir -fg blue
button $f($r).b3 -text "install" -command install
grid $f($r).l2  -row 0 -column 0 -columnspan 2 -sticky nw
grid $f($r).l30 -row 1 -column 0 -sticky nw
grid $f($r).l31 -row 1 -column 1 -sticky nw
grid $f($r).l40 -row 2 -column 0 -sticky nw
grid $f($r).l41 -row 2 -column 1 -sticky nw
grid $f($r).b3  -row 3 -column 0 -sticky nw

;#-------------------------------------
incr r
set f($r) [labelframe .f$r -relief groove -padx 5 -pady 5]
grid $f($r) -row $r -column 0 -sticky new -padx 5 -pady 5

button $f($r).exit -text "Exit" -command exit
grid $f($r).exit -row 0 -column 0 -sticky nw

;#-------------------------------------
proc install {} {
  global srcDir tgtDir t purpose transMark

  if {$tgtDir == $srcDir} {
    tk_messageBox -message "error: source & target folders are same." -title "error" -icon error
    return
  }

  toplevel .inst
  wm title .inst "installing..."
  focus .inst
  text .inst.t
  pack .inst.t -fill both

  foreach srcFile [glob -nocomplain [format "%s/*-text.tcl" $srcDir]] {
    set transDone 1   ;# 1=���̃t�@�C���̑S�f�[�^���|��ς�
    set tgtFile [format "%s/%s" $tgtDir [file tail $srcFile]]
    if [file exists $tgtFile] {
      ;# tgtFile�̃o�b�N�A�b�v�t�@�C���쐬
      set tgtBakFile [format "%s.bak" $tgtFile]
      set bakNum 1
      while {[file exists $tgtBakFile] == 1} {
        incr bakNum
        set tgtBakFile [format "%s.bak-%d" $tgtFile $bakNum]
      }
      file copy $tgtFile $tgtBakFile
      .inst.t insert end \
"(backup)
    $tgtFile -> $tgtBakFile

"

      ;# �\�[�X��t��ǂݍ���
      array unset t
      source $srcFile

      ;# �^�[�Q�b�g(�㏑���Ώ�)����s���ǂ݁A�V�������e��newTgt�ɍ��
      array unset newTgt
      set seq 0
      if [catch {open $tgtFile r} in] {
        tk_messageBox -message "error: can not read to $tgtFile" \
          -title error -icon error
      } else {
        while {![eof $in]} {
          set l [gets $in]
          if {[regexp {^[[:blank:]]*set[[:blank:]]+} $l]} {
            ;# set t(�` �̍s�̏ꍇ
            set tgtKey [regsub {^[[:blank:]]*set[[:blank:]]+t\((.+)\)[[:blank:]].+$} $l {\1}]
            if {[array names t $tgtKey] != ""} {
              ;# �\�[�X�ɓ����G���g��������̂ŏ㏑������
              set zenhan [regsub {^([[:blank:]]*set[[:blank:]]+t\(.+\)[[:blank:]]+).+$} $l {\1}]
              set kouhan [string map {\$ \\\$ \[ \\\[ \] \\\] \n \\n \t \\t} $t($tgtKey)]
              set newTgt($seq) [format "%s\"%s\"" $zenhan $kouhan]
            } else {
              ;# �\�[�X�ɓ����G���g�����Ȃ��̂ł��̂܂܁A�܂��͖ڈ��t����
              set transDone 0
              if {$purpose != "translator"} {
                ;# �ڈ��t�������̂܂�
                set newTgt($seq) $l
              } else {
                ;# �ڈ��t����
                set newTgt($seq) [format "%s %s" $transMark $l]
              }
            }
          } else {
            ;# �R�����g�s�Ȃǂ̏ꍇ�͂��̂܂�
            set newTgt($seq) $l
          }
          incr seq
        }
        close $in
      }

      ;# �V�������e���^�[�Q�b�g�ɏ�������
      if [catch {open $tgtFile w} out] {
        tk_messageBox -message "error: can not write to $tgtFile" \
          -title error -icon error
      } else {
        for {set i 0} {$i < $seq} {incr i} {
          puts $out $newTgt($i)
        }
        .inst.t insert end \
"(rewrite $tgtFile)
"
        if $transDone {
          .inst.t insert end \
"  All entry has translated.

"
        } else {
          .inst.t insert end \
"  Some entries are not translated yet.

"
        }
      }
    }
  }
  .inst.t insert end \
"
  Done."
}
