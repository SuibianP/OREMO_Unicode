#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

#atode, �ڍאݒ�̕ۑ�
#atode, �����m�[�}���C�Y����.wav�Ȃǉ����������G�����^�̂Ƃ��Ɏ������邩��
#atode, �����A�^�C�v�̃��X�g���}���`�J�������X�g�ɂ���
#atode, �^���ς݂̉���F��������Ƃ�
#atode, �^���ς݂̃t�@�C�������J�E���g���ĕ\���i���Ə���!�Ǝv���邩��??�j

# - �������X�g��SHIFT+�z�C�[���X�N���[�����ă��X�g��Z������ꍇ�A
#   �ŏ��R�s�܂ŏk���ł���悤�ɂ����B

# 2.0-b091205
# - �A�C�R����D&D�����Ƃ��Ɏ����ł��̃t�H���_��ۑ��t�H���_�ɂ��ċN������B

# 2.0-b090803
# - �����A�����^�C�v���X�g�{�b�N�X�̉�����ctrl+wheel�ŕύX�ɂ����B
#   (�������A����ł͓��삪�኱��낵���Ȃ�)

# 2.0-b090724
# - �K�C�hBGM�̐ݒ�ǂݍ��ݕ����̃o�O�C���B

# 2.0-b090720
# - �������^���[�h��ǉ��B
#   - �I�v�V���������^���@�̐ݒ葋���쐬�B
#   - r�L�[�Ŏ������^�J�n/��~����悤�ɕύX�B
#   - R�L�[�Ŏ������^�I���̃o�C���h��ǉ��B
# - �um�v�L�[�������Ă����g���m�[���̍Đ����~�܂�Ȃ��̂�����B

# 2.0-b090709
# - ���^�֌W��oremo�ɁA�����p�����[�^�ݒ�֌W��setParam�ɕ�������
# - �T�u���[�`���� proc.tcl �ɁA���ϐ���globalVar.tcl�ɂ܂Ƃ߂�
#   (exe���̍ۂɂ�:r�ň�t�@�C���Ɍ���)
# - �u����ؑցv���j���[���폜�����B
#   - �I�v�V�������^���@�\�Ř^���@�\ON/OFF�؂�ւ�
#   - �t�@�C�����ۑ��t�H���_��wav�t�@�C������` ��reclist.txt����
# - ���g���m�[���@�\��ǉ��B
# - setParam�Ɍ����p�����[�^�ꗗ�������B���l���́Acopy&paste�ȂǁB
# - setParam���玩�������ݒ�c�[��(�O���c�[���Autau_lib_analyze110�j���ĂԂ悤�ɂ����B
# - reclist.txt�Ɂu�Ƃ��v�u�ǂ��v��ǉ��B
# - �A�C�R�����ߍ��݁B(exe������ico�t�@�C����*.vfs/tclkit.ico�ɃR�s�[����)
# - oremo.exe �Ɠ����t�H���_�� oremo-init.tcl������Ύ����I�ɓǂݍ���

# 2.0-b090613
# - �����p�����[�^�̓ǂݍ���/�ۑ��F�㏑���m�F�B�t�@�C�����w��ɂ���
# - �����p�����[�^��ǂݍ��񂾂�\�����̉�ʂɑ����f������悤�ɂ���
# - �t�@�C�����j���[�̕���ύX("oto.ini"��"�����p�����[�^")

# 2.0-b090611
# - �t�@�C�����j���[�ǉ��F�������X�g�̓ǂݍ���/�ۑ��A�����^�C�v�̓ǂݍ���
# - �N������reclist.txt�Atypelist.txt�������ꍇ�Ƀ_�C�A���O��\��
# - �R�}���h���C������̋N�����̑������ŕۑ��t�H���_���w��
# - �g�`�ēǂݍ���(c�ɃL�[�o�C���h)

# 2.0-b090506
# oto.ini�̓ǂݍ���

# 2.0-b090213
# - �����@�\�̋@�\����(���s�[�g�Đ��A�L�[�o�C���h���蓖��)
# - �����ݒ�i�蓮�ݒ�(F1-F6�ɃL�[�o�C���h)�j
# - �����ݒ�i�����ݒ�B���E�u�����N�̂݁j
# - �����ݒ�i�t�@�C���ۑ��Boto.ini�Ƀp�����[�^��ۑ��j
# - ���샂�[�h�ؑցi�^���@�\ON/OFF�A�����ݒ�@�\ON/OFF�j
# - �������X�g�擾�i�ۑ��t�H���_�ɂ���wav�t�@�C�����特�����X�g���\���\�j
# - ��ʍ\���ύX�i���^����������������������ɂȂ��Ă��\���\�Ɂj
# - ���̑�



package require -exact snack 2.2
#if {$::tcl_platform(platform) == "windows"} {
#  ttk::style theme use clam ;#xpnative
#}

# package require Tktable
# package require tkdnd

source proc-genParam.tcl ;# oto.ini�����ǂݍ���
source proc.tcl          ;# �T�u���[�`���ǂݍ���
source globalVar.tcl     ;# ���ϐ��ǂݍ���

#---------------------------------------------------
# main - ���C�����[�`�� (������)

set v(appname) OREMO
set v(version) 3.0-b190106         ;# �\�t�g�̃o�[�W�����ԍ�
set startup(readTypeList) 1
set startup(readRecList) 1
set startup(readCommentList) 1
set startup(makeRecListFromDir) 0
set startup(choosesaveDir) 0
set startup(initFile)     $topdir/oremo-init.tcl
set startup(sysIniFile)   $topdir/oremo-setting.ini ;# �t�H���_�g�p�����Ȃǂ��V�X�e�����ۑ�����t�@�C��
set startup(textFile)     $topdir/message/oremo-text.tcl
set startup(procTextFile) $topdir/message/proc-text.tcl

#---------------------------------------------------
# �����`�F�b�N
# memo: oremo.tcl -- -option �Ƃ���̂�����B--���Ȃ���wish�̃I�v�V�����Ǝv����l�q
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
      ;# �A�C�R����D&D���ꂽ�Ƃ��̑Ή�
      set opt [encoding convertfrom $opt]  ;# tcl/tk�����R�[�h(utf-8)�ɂ���
      set opt [file normalize $opt]
      if [file isdirectory $opt] {            ;# �t�H���_��D&D
        set v(saveDir) $opt
        set startup(choosesaveDir) 0
      } elseif [file isdirectory [file dirname $opt]] { ;# ����ȊO�̃t�@�C��
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

foreach fn [list $startup(textFile) $startup(procTextFile)] {
  if {[file exists $fn]} {
    source $fn
  } else {
    tk_messageBox -message "can not find textFile ($fn)" -title "Error" -icon error
    exit
  }
}
# �X�^�[�g�A�b�v��ǂ�
if {[file exists $startup(initFile)]} {
  doReadInitFile $startup(initFile)
}


audioSettings ;# �I�[�f�B�I�f�o�C�X�֘A�̏�����
fontSetting   ;# ���{��t�H���g��ݒ肷��
if {$startup(readRecList)}        { readRecList $v(recListFile) }
if {$startup(readTypeList)}       { readTypeList $v(typeListFile) }
if {$startup(readCommentList)}    { readCommentList "$v(saveDir)/$v(appname)-comment.txt" }
if {$startup(choosesaveDir)}      { choosesaveDir }
if {$startup(makeRecListFromDir)} { makeRecListFromDir }
setSinScale   ;# ���ϗ��̊e���K�̎��g�������߂�


#---------------------------------------------------
#
# ���j���[�̐ݒ�
#
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

#---------------------------------------------------
#
# ���̐ݒ�
#
snack::createIcons    ;# �A�C�R�����g�p����

set rseq 0

# 0. ���^���̉�����\������t���[��
frame .recinfo
grid  .recinfo -row $rseq -columnspan 2 -sticky new

# 0-1. ���^���̉���\������t���[��
frame .recinfo.showCurrent
grid  .recinfo.showCurrent -sticky nw
label .recinfo.showCurrent.lr -textvar v(recLab)  \
  -font bigkfont -fg black -bg white
label .recinfo.showCurrent.lt -textvar v(typeLab) \
  -font bigkfont -fg black -bg white
pack .recinfo.showCurrent.lr .recinfo.showCurrent.lt -side left \
  -fill x -expand 1 -anchor center

# �R�����g��\������t���[��
incr rseq
frame .recComment
grid  .recComment -row $rseq -columnspan 2 -sticky new
entry .recComment.l -textvar v(recComment) -font commkfont -fg black -bg [. cget -bg]
button .recComment.b -text $t(.recComment.midashi) -command searchComment
pack  .recComment.l -side left -fill both -expand 1 -anchor center -ipady 0
pack  .recComment.b -side left                      -anchor center -ipady 0
bind .recComment.l <<EditComment>> {
  .recComment.l insert insert %A     ;# �J�[�\���ʒu�ɓ��͕�����}��
  break                              ;# �����̃o�C���h�𖳌��ɂ��邽�߂�break
}

# 1. �ݒ�֌W�̃t���[��
incr rseq
frame .s
grid  .s -row $rseq -column 0 -sticky nw

# 1-1. �����̃��X�g�{�b�N�X
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

# 1-2. �����^�C�v�̃��X�g�{�b�N�X
set type [listbox .s.listboxes.type -listvar v(typeList) -height 10 -width 4 \
  -bg $v(bg) -fg $v(fg) \
  -font kfont \
  -yscrollcommand {.s.listboxes.stype set} \
  -selectmode single -exportselection 0]
set stype [scrollbar .s.listboxes.stype -command {$type yview}]
pack $type $stype -side left -fill both -expand 1
$type selection set $v(typeSeq)

# 2. �g�`��X�y�N�g���Ȃǂ̐}�A�ۑ��t�H���_�Ȃǂ�\������t���[��
frame .fig
grid  .fig -row $rseq -column 1 -sticky nw

# 2-1. �g�`�Ȃǂ�\������t���[��
update
set v(cWidth)  [expr $v(winWidth) - [winfo width .s] - $v(yaxisw) - 8]  ;# 4�̓L�����o�X���E�̃}�[�W��
set v(cHeight) [expr $v(waveh) + $v(spech) + $v(powh) + $v(f0h) + $v(timeh)]
set c [canvas .fig.c -width $v(cWidth) -height $v(cHeight) -bg $v(bg)]
set cYaxis [canvas .fig.cYaxis -width $v(yaxisw) -height $v(cHeight) \
  -bg $v(bg) \
]
grid $c      -row 0 -column 1 -sticky nw
grid $cYaxis -row 0 -column 0 -sticky nw

# 3. ���^���̉���ۑ�����f�B���N�g����\������t���[��
incr rseq
frame .saveDir
grid  .saveDir -row $rseq -columnspan 2 -sticky new
label .saveDir.midashi -text $t(.saveDir.midashi) -fg $v(fg) -bg $v(bg)
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

# 4. ���b�Z�[�W��\������t���[��
incr rseq
frame .msg
grid  .msg -row $rseq -columnspan 2 -sticky new
pack [label .msg.msg -textvar v(msg) -relief sunken -anchor nw] -fill x

# 5. �ڍאݒ�p�Ȃǂ̑�
set swindow .settings
set cmwindow .changeMode
set epwindow .epwindow
set entpwindow .entpwindow
set genWindow .genParam
set prgWindow .progress
set searchWindow .search
set bindWindow .bindWindow
set fontWindow .fontWindow

# 6. audio I/O �ݒ�p�̑�
set ioswindow .iosettings

#---------------------------------------------------
#
# �o�C���h
#
proc nextRec0  {} { nextRec  0 }
proc prevRec0  {} { prevRec  0 }
proc nextType0 {} { nextType 0 }
proc prevType0 {} { prevType 0 }
proc waveReload {} {readWavFile; Redraw all}

#---------------------------------------------------
# �L�[�{�[�h�o�C���h���܂Ƃ߂�proc�B
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

  bind . <KeyPress-c>          waveReload  ;# �g�`�ēǂݍ���
  bind . <KeyPress-m>          toggleMetroPlay
  bind . <KeyPress-M>          toggleMetroPlay

  bind . <KeyPress-F6>         nextRec
  bind . <KeyPress-F7>         prevRec
  bind . <Control-KeyPress-F6> nextRec0
  bind . <Control-KeyPress-F7> prevRec0

  bind . <Alt-F4>              Exit
   
  bind . <F11>                 waveShrink  ;# �k��
  bind . <F12>                 waveExpand  ;# �g��

  bind . <Control-f>           searchComment

  # �R���\�[���̕\��
  bind . <Control-Alt-d> {
    if {$conState} {
      console hide
      set conState 0
    } else {
      console show
      set conState 1
    }
  }

  # �R�����g���ł̓f�t�H���g�̃o�C���h�A���̑��ł͏���̃o�C���h��ݒ肷��
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

# �R�����g���ł̓o�C���h�𖳌��ɂ������̂ŁA�����ɂ���C�x���g��EditComment�ɓo�^����
event add <<EditComment>> <KeyPress-r> <KeyPress-0> <KeyPress-R>
event add <<EditComment>> <KeyPress-2> <KeyPress-4> <KeyPress-6> <KeyPress-8>
event add <<EditComment>> <Control-KeyPress-2> <Control-KeyPress-4> <Control-KeyPress-6> <Control-KeyPress-8>
event add <<EditComment>> <space> <KeyPress-5>
event add <<EditComment>> <KeyPress-o> <KeyPress-O> <KeyPress-c> <KeyPress-m> <KeyPress-M>

# atode �}�E�X�z�C�[�����㉺���ɑΉ��Â���H

# ���X�g�{�b�N�X�̃}�E�X����
bind $rec  <<ListboxSelect>> { jumpRec  [$rec  curselection] }
bind $type <<ListboxSelect>> { jumpType [$type curselection] }
#bind $rec  <Button-1> { jumpRec  [$rec  curselection] }
#bind $type <Button-1> { jumpType [$type curselection] }
bind $rec  <Control-1>       { jumpRec  [$rec  nearest %y] 0}
bind $type <Control-1>       { jumpType [$type nearest %y] 0}

# �N���b�N�����Ƃ���Ƀt�H�[�J�X����(�R�����g���Ȃǂ���N���b�N�Ńt�H�[�J�X���O������)
bind . <Button-1> {focus %W}

# ���X�g�{�b�N�X�ł̃z�C�[���X�N���[��
bind $rec <Enter>   {+set scrollWidget %W}
bind $rec <Leave>   {+set scrollWidget ""}
bind $srec <Enter>  {+set scrollWidget $rec}
bind $srec <Leave>  {+set scrollWidget ""}
bind $type <Enter>  {+set scrollWidget %W}
bind $type <Leave>  {+set scrollWidget ""}
bind $stype <Enter> {+set scrollWidget $type}
bind $stype <Leave> {+set scrollWidget ""}
bind . <MouseWheel> {listboxScroll $scrollWidget %D}

# koko, ���X�g��I�����ctrl+wheel����ƁA���X�g�̏c�X�N���[����
# �����Ɍ����Ă��܂��B���̂Ƃ�������@��������Ȃ��B
#
# �������g��k�� 
bind . <Control-MouseWheel> {
  set x [expr %x + [winfo rootx %W] - [winfo rootx .]]
  set y [expr %y + [winfo rooty %W] - [winfo rooty .]]
  if {$y > [winfo y .s]} {
    if {$x > [winfo width .s]} {
      # �g�`�������g��k�� 
      if {%D > 0} {
        changeWidth 0  ;# �k��
      } else {
        changeWidth 1  ;# �g��
      }
    } elseif {$x <= [winfo width $rec]} {
      # �������X�g�������g��k�� 
      if {%D > 0} {
        changeRecListWidth 0  ;# �k��
      } else {
        changeRecListWidth 1  ;# �g��
      }
    } else {
      # �����^�C�v���X�g�������g��k�� 
      if {%D > 0} {
        changeTypeListWidth 0  ;# �k��
      } else {
        changeTypeListWidth 1  ;# �g��
      }
    }
  }
}
bind $rec <Control-MouseWheel> {
  if {%y > [expr [winfo height .recinfo] + [winfo height .recComment]]} {
    if {%x <= [winfo width $rec]} {
      if {%D > 0} {
        changeRecListWidth 0  ;# �k��
      } else {
        changeRecListWidth 1  ;# �g��
      }
    }
  }
}
bind $type <Control-MouseWheel> {
  if {%y > [expr [winfo height .recinfo] + [winfo height .recComment]]} {
    if {%x > [winfo width $rec] && %x <= [winfo width $type]} {
      if {%D > 0} {
        changeTypeListWidth 0  ;# �k��
      } else {
        changeTypeListWidth 1  ;# �g��
      }
    }
  }
}
proc waveShrink {} { changeWidth 0 }  ;# �k��
proc waveExpand {} { changeWidth 1 }  ;# �g��

# �g�`�g��k��(�c����, Shift+�}�E�X�z�C�[��)
bind . <Shift-MouseWheel> {
  if {"%W" == "."} {                              ;# �t�H�[�J�X�Ȃ�
    set mx %x
    set my [expr %y - [winfo height .recinfo] - [winfo height .recComment]]
  } elseif {[regexp {^\.recinfo} "%W"]} {         ;# �����\���Ƀt�H�[�J�X
    set mx %x
    set my [expr %y - [winfo height .recinfo] - [winfo height .recComment]]
  } elseif {[regexp {^\.recComment} "%W"]} {      ;# �R�����g�Ƀt�H�[�J�X
    set mx %x
    set my [expr %y - [winfo height .recComment]]
  } elseif {[regexp {^\.fig\.cYaxis} "%W"]} {     ;# �g�`�c���Ƀt�H�[�J�X
    set mx [expr %x + [winfo width .s]]
    set my %y
  } elseif {[regexp {^\.fig\.c} "%W"]} {          ;# �g�`�y�C���Ƀt�H�[�J�X
    set mx [expr %x + [winfo width .s] + [winfo width $cYaxis]]
    set my %y
  } elseif {"%W" == ".s.listboxes.rec"} {         ;# �������X�g�Ƀt�H�[�J�X
    set mx %x
    set my %y
  } elseif {"%W" == ".s.listboxes.srec"} {        ;# �����^�C�v���X�g�̃X�N���[���o�[�Ƀt�H�[�J�X
    set mx [expr %x + [winfo width .s.listboxes.rec]]
    set my %y
  } elseif {"%W" == ".s.listboxes.type"} {        ;# �����^�C�v���X�g�Ƀt�H�[�J�X
    set mx [expr %x + [winfo width .s.listboxes.rec] + [winfo width .s.listboxes.srec]]
    set my %y
  } elseif {[regexp {^\.s\.} "%W"]} {              ;# �����^�C�v���X�g�̃X�N���[���o�[�ȂǂɃt�H�[�J�X
    set mx [expr %x + [winfo width .s.listboxes.rec] + [winfo width .s.listboxes.srec] + [winfo width .s.listboxes.type]]
    set my %y
  } elseif {[regexp {^\.saveDir} "%W"]} {         ;# �ۑ��t�H���_�Ƀt�H�[�J�X
    set mx %x
    set my [expr %y + [winfo height .fig]]
  } elseif {[regexp {^\.msg} "%W"]} {             ;# �ۑ��t�H���_�Ƀt�H�[�J�X
    set mx %x
    set my [expr %y + [winfo height .fig] + [winfo height .saveDir]]
  } else {
    return
  }
  if {$my < 0} return

  if {$mx > [winfo width .s]} {
    if {%D > 0} {
      set inc -20    ;# �������]
    } else {
      set inc +20    ;# ��������]
    }
    if {$my <= $v(waveh)} {
      # �g�`���g��E�k��
      incr v(waveh) $inc
      if {$v(waveh) < $v(wavehmin)} {
        set v(waveh) $v(wavehmin)
      }
    } elseif {$my <= [expr $v(waveh) + $v(spech)]} {
      # �X�y�N�g�����g��E�k��
      incr v(spech) $inc
      if {$v(spech) < $v(spechmin)} {
        set v(spech) $v(spechmin)
      }
    } elseif {$my <= [expr $v(waveh) + $v(spech) + $v(powh)]} {
      # �p���[���g��E�k��
      incr v(powh) $inc
      if {$v(powh) < $v(powhmin)} {
        set v(powh) $v(powhmin)       ;# �k���̍ŏ��l
      }
    } elseif {$my <= [expr $v(waveh) + $v(spech) + $v(powh) + $v(f0h)]} {
      # F0���g��E�k��
      incr v(f0h) $inc
      if {$v(f0h) < $v(f0hmin)} {
        set v(f0h) $v(f0hmin)       ;# �k���̍ŏ��l
      }
    }
    Redraw scale
    set h [expr [winfo y .fig] + $v(waveh) + $v(spech) + $v(powh) + $v(f0h) + $v(timeh) \
      + [winfo height .saveDir] + [winfo height .msg] + 4]
    wm geometry . "$v(winWidth)x$h"
  } else {
#    # �}�E�X���������X�g�ɂ���ꍇ
#    set rech [$rec cget -height]
#    if {%D > 0} {
#      ;# �������]
#      if {$rech > 3} { incr rech -1 }
#      $rec configure -height $rech
#      $type configure -height $rech
#    } else {
#      ;# ��������]
#      incr rech
#      $rec configure -height $rech
#      $type configure -height $rech
#    }
  }
  unset -nocomplain mx my
}

;# �E�N���b�N���j���[
bind $c <Button-3> { PopUpMenu %X %Y %x %y }

;# �o�C���h�̃J�X�^�}�C�Y�𔽉f
doSetBind

#---------------------------------------------------
# ������
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
set v(winWidthMin) [expr [winfo x .fig] + $v(cWidthMin)]
set v(winHeightMin) [expr [winfo y .fig] + $v(wavehmin) + $v(timeh) \
  + ($v(spech) ? $v(spechmin) : 0) + ($v(powh)  ? $v(powhmin)  : 0) \
  + ($v(f0h)   ? $v(f0hmin)   : 0) + [winfo height .saveDir] + [winfo height .msg] ]
wm minsize . $v(winWidthMin) $v(winHeightMin)

set v(winWidth) [winfo width  .]
set v(winHeight) [winfo height .]
after 1000 { bind . <Configure> {changeWindowBorder} }
