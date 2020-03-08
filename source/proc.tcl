#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

#portaudio�̕��Agrep�Avi���B
#sampleRate
#�g�`�̐F

# 3.0-b190106
# - (�ǉ�) �������X�gA.txt��ǂݍ��ނƂ��A�������t�H���_�ɃR�����g�t�@�C��A-comment.txt������΂����ǂݍ��ނ悤�ɂ����B(readRecList)
# - (�ǉ�) �t�@�C�����j���[����R�����g�t�@�C����ǂ߂�悤�ɂ����B���̍�setParam�̃R�����g����荞�߂�悤�ɂ����B(isSetparamComment)
# - (�ǉ�) �t�H���g�T�C�Y��ς�����悤�ɂ����B�ݒ�ύX�͍ċN����ɗL���ɂȂ�B�܂��A�ݒ莟��ł͉����ꗗ�̏c�����Z���Ȃ�̂ŁA���̎��͑��T�C�Y�������ς���ƒ���B(setFontSize)
# - (�ǉ�) �ݒ�ύX�������e��oremo-init.tcl�Ɏ����ۑ����A����N�����Ɏ�����������悤�ɂ����B�ȑO�͎蓮�ۑ�(�u�t�@�C���v���u���݂̐ݒ���������t�@�C���ɕۑ��v)�������B�����ۑ����Ȃ��悤�ɂ���Ȃ�oremo-setting.ini��autoSaveInitFile=1�̒l��0�ɂ���B(readSysIniFile, Exit)
# - (�ǉ�) �������t�@�C��oremo-init.tcl�ɕۑ������p�����[�^�𑝂₵���B(saveSettings)
# - (�ǉ�) ����L�[�̊��蓖�Ă��J�X�^�}�C�Y�ł���悤�ɂ����B(setBind, doSetBind)
# - (�C��) �G���[�������ɓK�؂ȃG���[�����\������Ȃ������C������(3�ӏ�)�B(makeRecListFromUst, readRecList)

# 3.0-b160504
# - (�C��) �w���v���j���[��URL���X�V(freett��fc2�Asourceforge��osdn)�B
# - (�C��) Tcl/Tk�̃��C�Z���X�t�@�C�����C��(�ȑO�̃o�[�W�����ł�tclkit���̃��C�Z���X�t�@�C���łȂ�activetcl�̃��C�Z���X�t�@�C���𓯍����Ă��܂��Ă���)�B
# - (�ύX) Tcl/Tk�̃o�[�W������8.5.4����8.6.4�ɕύX�����B
# - (�ύX) F0�p�l�����s�A�m���[���\���ɂ����B
# - (�ǉ�) �E�B���h�E���E�̃h���b�O�ő����ύX�ł���悤�ɂ����B

# 3.0-b140323
# - (�ǉ�) NHP�T�C�g���ɔ������T�C�g�Ŕz�z����Ă���5���[���A�����������X�g��OREMO�ɓ��������B�t�@�C�����́ureclist-renzoku-NHP.txt�v�B
# - (�ύX) �A�����̉������X�g�̃t�@�C�����ureclist-renzoku.txt�v���ureclist-renzoku-�P�Ɖ��𕹗p����K�v�L.txt�v�ɕύX�����B
# - (�ǉ�) �p���(��������p��Ńx�[�X)��z�z�B
# - (�ǉ�) �w���v�������web�y�[�W�ɃA�N�Z�X�ł���悤�ɂ����B
# - (�ύX) �R�����g�����{�^���E�B�W�F�b�g�̕������|��\�ɂ����B

# 3.0-b140113
# - (�C��) �����^��������Ƃ���oto.ini���������s����ƃG���[���o����ɑΉ������B
# - (�C��) �e��ʂ̊g��k��(�c�̊g��k��=SHIFT+�z�C�[���X�N���[���A���̊g��k��=Ctrl+�z�C�[���X�N���[��)�������������Ȃ��G���[�ɑΉ������B(�O�o�[�W�����ŃR�����g����ǉ��������Ƃɂ��G���[)
# - (�C��) oto.ini������oto.ini�ۑ��_�C�A���O�ŁA�t�H���_�̃f�t�H���g��wav�̂���t�H���_�Ɉ�v�������B(estimateParam, genParam)
# - (�C��) ���^�����oto.ini���������ꍇ�ɃG���[���o��P�[�X�ɑΏ��B(doEstimateParam��sWork read�������set v(sndLength)����悤�ɂ���)
# - (�C��) �X�e���I�^�����ꂽwav�t�@�C����oto.ini���������ɑΉ������B������UTAU�̓��m�����^����z�肵�Ă����͂��B
# - (�ǉ�) oto.ini�������O��wav��ۑ��������`�F�b�N����悤�ɂ����B(checkWavForOREMO)
# - (�ύX) �P�Ɖ�oto.ini�����p��proc��proc-genParam.tcl��proc.tcl�̗����ɓ����Ă����̂ŁAproc-genParam.tcl�݂̂ɂ����B(estimateParam�Ȃ�)
# - (�ύX) �s�v�ȃ��b�Z�[�W�f�[�^��procedure���폜�����B

# 3.0-b131127
# - (�C��) �p���[�Ȑ��̕`�揈���������������B(Redraw)
# - (�C��) SHIFT+�z�C�[�����ŏc����ς����Ƃ��A�������X�g�̒������ς��悤�ɂ����B(resizeListbox)
# - (�C��) �}�E�X����ƃL�[����Ō��݂ɉ����ύX�����ꍇ�ɁA�����Đ�����ƈ�O�ɑI������wav���\���E�Đ������G���[���C�������B(nextRec�AnextType�Ȃǂ�focus��activate��ǉ�)
# - (�ǉ�) �R�����g�@�\(readCommentList, saveCommentList�Ȃ�)
# - (�ύX) �ڍאݒ�́uF0�^�[�Q�b�g�ɍ��킹�đ��̃p�����[�^��ύX�v�����Ƃ��̍ō�F0�A�Œ�F0�̌v�Z���@��ύX�����B(autoF0Settings, setParam 2.0-b130303����̈ڐA)
# - (�ύX) F0�A�p���[�̕\�����@��ύX�����BsetParam 2.0-b130530����̈ڐA�B����ɂ���Ėڐ��\�������F0�̏����\���ɑΉ������B(f0Axis, powerAxis���폜����myAxis�𓱓�)

# 3.0-b120515
# - (�ǉ�) setParam��oto.ini�����@�\���ڐA�����B
# - (�ǉ�) PortAudio�ɂ��Đ��@�\��ǉ������B
# - (�ǉ�) PortAudio�ɂ��^���@�\��ǉ������B
#            �ǉ�proc�FpaRecRun�ApaRecTerminate�AputsPa�AgetsPa�AupdateIoSettings
#            �ύXproc�FrecStart, aRecStart, aRecStop, recStop�AioSettings�AsetIODevice (���ɂ�����������)
#
# - (�ǉ�) �g�`�\���̏c�����Œ艻�ł���悤�ɂ����B�k�ڂ�ς�����ȑO�̎����k�ڂɂ���ꍇ��
#          �u�ڍאݒ�v�́u�c���ő�l�v��ύX����B0�ɂ���ƈȑO�̎����k�ڂɂȂ�B(settings, Redraw)
# - (�ǉ�) �Đ����Ɉʒu�������o�[��\���������B(showPlayBar)
# - (�ǉ�) �K�C�hBGM�̐ݒ�t�@�C���쐬�c�[����t������(guideBGM/korede.tcl)
# - (�ύX) �f�t�H���g�̃K�C�hBGM��mp3����wav�ɕύX�����B(PortAudio���ƌ���wav�Đ������ł��Ȃ��̂�)�B
# - (�C��) �����̏ꍇ��F0���o���x���グ���i�������Ԃ͑������j�B
# - (�C��) �ׂ����C���B�������^�I�����ɉ�ʂ��ĕ`�悷��悤�ɂ����B
# - (�C��) �T���v�����O���g����ύX������snd�ȊO�̕ϐ����ݒ�ύX����悤�ɂ����Bonsa�Ametro�Abgm�AuttTiming(clickSnd) (settings)
# - (�ύX) exit��Exit�Ń��b�s���O����

# 2.0-b120308
# - (�C��) �\�����̊ԈႢ(FFT�̑����̒P�ʂȂ�)���C�������B
# - (�ǉ�) �ڍאݒ�ŁAF0�^�[�Q�b�g�l�ɍ��킹�đ��̐ݒ�l�������ݒ肷��{�^����ǉ�����(autoF0Settings)
# - (�ύX) F0�ō��l�̃f�t�H���g�l��400����800�Ɉ����グ��

# 2.0-b110624
# - (�ǉ�) ust�t�@�C�����甭�����X�g���쐬�ł���悤�ɂ���(makeRecListFromUst)
# - (�폜) setParam�p�̃T�u���[�`�����폜����
# - (�C��) �I�[�f�B�II/O�ݒ葋�ŃG���[���o������C������(ioSettings)
# - (�ǉ�) �I�[�f�B�II/O�ݒ葋�����Ɍx������ǉ������B
# - (�ǉ�) ESC�Ŋe��ݒ葋�����悤�ɂ���(bgmGuide, pitchGuide, tempoGuide, ioSettings, settings)
# - (�ǉ�) �������ŉ����ɃV���[�g�J�b�g�L�[�ꗗ��\������

# 2.0-b100509
# - (�ύX) �`��R�[�h��setParam�ō�������̃x�[�X�ɂ���(Redraw)
# - (�C��) �I�[�f�B�I�f�o�C�X�̕�����������̃o�O�C��(setIODevice)

# 2.0-b100204
# - (�ǉ�) �g�`�̕\��/��\����؂�ւ�����悤�ɂ���(toggleWave�Ȃ�)
# - (�ǉ�) �ǂݍ��ݍς݂̃p�����[�^�ɕʂ̌����p�����[�^�t�@�C�����}�[�W����(mergeParamFile)
# - (�ǉ�) �I�𒆂͈̔͂̒l���ꊇ�ύX����@�\(changeCell)
# - (�ǉ�) �I�[�f�B�I�f�o�C�X�̃��C�e���V��ύX����@�\(ioSettings)
# - (�C��) �I�[�f�B�I�h���C�o���̕����������኱����(ioSettings)
# - (�ύX) �����p�����[�^��ǂލۂ�wav�����݂��Ȃ��G���g���͍폜����悤�ɂ���(readParamFile)

# 2.0-b091205
# - (�ǉ�) ���C������D&D���ꂽ�Ƃ��̏�����ǉ�(procDnd)
# - (�ǉ�) �����^�C�~���O�␳�ؑւ�ǉ�(timingAdjMode)
# - (�C��) �ׂ����o�O�̏C���B
# - (�ǉ�) �v���O���X�o�[�\��
# - (�ǉ�) oto.ini�ǂݍ��ݍ������p�̃L���b�V���@�\
# - (�ǉ�) F3��Alt-F3�ő��p�����[�^��A�����Ă���������悤�ɂ����B
# - (�ǉ�) �G�C���A�X�ꊇ�ϊ��@�\��ǉ�(changeAlias)
# - (�C��) �A�����p�����[�^���������space�ōĐ�����ƁA�\�����̔g�`�łȂ��g�`���Đ������o�O���C���B

# 2.0-b091120
# - (�ύX) �S���b�Z�[�W���O���t�@�C�����B
# - (�ǉ�) wav���[�̖������J�b�g����@�\��ǉ� (cutWav)
# - (�C��) �p�����[�^�ꗗ�\�̐��l���폜�����"0"�ƕ\�������o�O?���C���B

# 2.0-b091104
# - (�ǉ�) �ǂݍ��ݎ��Ƀp�����[�^����(�P��/�A����)��I�����s�ł���悤�ɂ����B
# - (�ǉ�) ��s�����`�F�b�N�p�̎����@�\����ѐݒ葋��ǉ�
# - (�ǉ�) �������^�����A�����̃p�����[�^��������(genParam)
# - (�ύX) �������t�@�C���ۑ��̕ۑ��Ώۂ�ύX(saveSettings)
# - (�C��) �s�𕡐�����ۂɃp�����[�^�ɋ󗓂�����ꍇ�̃R�s�[�̃o�O���C���B

# 2.0-b091007
# - (�C��) �ȑO��������E�u�����N����������ŐV�o�[�W�����œ����悤�ɏC���B

# 2.0-b090903
# - (�ǉ�) ���u�����N�l��ύX�����ۂɁA��wav�t�@�C���̑��̉��̍��u�����N�l��
#          �A�����ĕύX�ł���悤�ɂ����B
# - (�ύX) �e�푋���J�����Ƃ��Ƀt�H�[�J�X����悤�ɕύX�B
# - (�ǉ�) �p�����[�^�����������B
# - (�ύX) �p�����[�^�ꗗ�\�̃^�C�g������������ꍇ�͐؂�l�߂�悤�ɕύX�B
# - (�ύX) �}�E�X+F1�`F5�Ŋe�p�����[�^���h���b�O�\�B
# - (�C��) setParam��F0���\������Ȃ��o�O�̏C���B
# - (�C��) setParam�Ń}�E�X�h���b�O�ɂ��Z�������I�����ł��Ȃ��o�O�̏C���B

# 2.0-b090822
# - (�C��) setParam�̈ꗗ�\�^�C�g���̃t�@�C�����\�����X�V����Ȃ��o�O���C���B
# - (�C��) setParam�̈ꗗ�\�̒l�ɑ}���E�폜�����Ƃ��J�[�\���������ɍs���o�O���C���B
# - (�ύX) �S�p�����[�^���}�C�N��sec���x�ɂ����B
# - (�ǉ�) �E�u�����N�̕��̒l�ɑΉ��B
# - (�ǉ�) �I�v�V�����ŉE�u�����N�̐�����؂�ւ�����悤�ɂ����B
# - (�ǉ�) �I�v�V�����ō��u�����N�̕ύX���̑��p�����[�^�̂ӂ�܂���
#          �؂�ւ�����悤�ɂ���
# (2.0-b090813)
# - (�ύX) ���X�g�X�N���[���łQ�O��̉���������悤�ɂ����B
# - (�ǉ�) �������t�@�C���𐶐��ł���悤�ɂ����B

# 2.0-b090803
# - (�C��) readParamFile�Boto.ini�ɃG���g��������Ȃ��ꍇ�̃o�O���C���B
# -�i�ǉ�) �c�[�����j���[��DC�����ꊇ������ǉ�
# -�i�ǉ�) �c�[�����j���[��wav�t�@�C�����ύX�i�`����"_"��t����)��ǉ�
# - (�ǉ�) ���X�g�{�b�N�X�̉�����ctrl+wheel�ŕύX�\�ɂ����B

# 2.0-b090727
# - (�ύX) setParam�Ŕg�`���ɃG�C���A�X��\���B
# - (�ύX) �ꗗ�\�^�C�g���Ƀt�@�C������\���B
# - (�ύX) �ꗗ�\�̏㉺���ړ��ŕ\�̏�[�E���[�Ń��[�v���Ȃ��悤�ɂ����B
# - (�ύX) �K�C�hBGM�ݒ葋�ŁABGM�����A�^���C���[�W�������{�^����ǉ��B
# - (�ύX) �I�[�f�B�II/O�ݒ葋�ɐ�������\���B
# - (�C��) �����^��(loop)�ŁA�������X�g�����܂ł�������I������悤�ɂ����B
# - (�ύX) Redraw�̉��Z�񐔂������팸�B
# - (�C��) makeRecListFromDir�ł̃t�@�C�����o�^�̃o�O���C���B

# 2.0-b090724
# - (�C��) val2samp�Ŏ����l��Ԃ����Ƃ�����o�O���C���B

# 2.0-b090719
# - (�C��) ���g���m�[���Đ����~�ł��Ȃ������o�O���C���B

# 2.0-b090715
# - saveParamFile ������(paramU�̓��e�𒼐ڏ����o���悤�ɂ���)

# 2.0-b090706
# - oremo.tcl �{�̂̃T�u���[�`���W��ʃt�@�C���Ɉڍs�B

#---------------------------------------------------
# �T�u���[�`��

#---------------------------------------------------
# ���C����ʕ\�������Z�b�g����H
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

#---------------------------------------------------
# �ۑ��t�H���_�ɂ���wav�t�@�C����ǂ݁A���X�g�ɋL������
#
proc makeRecListFromDir {{readParam 0} {overWriteRecList 1}} {
  global v t

  set recList {}
  foreach filename [glob -nocomplain [format "%s/*.%s" $v(saveDir) $v(ext)]] {
    set filename [file rootname [file tail $filename]]
    if {$filename == ""} continue
    ;# �t�H���_����ъg���q����菜�����t�@�C���������X�g�Ɋi�[
    ;# �����Ɣ����^�C�v�͕����Ȃ�
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
# reclist.txt��ۑ�����
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
    if [tk_dialog .encod $t(.encod.encodtitlerec) $t(.encod.encodmsg) question 0 "UTF-8" "Shift-JIS"] {
      fconfigure $out -encoding shiftjis
    } else {
      fconfigure $out -encoding utf-8
    }
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
# �R�����g��ۑ�����
#
proc saveCommentList {} {
  global v t

  if {[file exists $v(saveDir)] == 0} return

  set v(recComment,$v(recLab)$v(typeLab)) $v(recComment)  ;# ���݂̃R�����g��ۑ�

  if [catch {open "$v(saveDir)/$v(appname)-comment.txt" w} out] { 
    tk_messageBox -message [eval format $t(saveCommentList,errMsg)] \
      -title $t(.confm.fioErr) -icon warning
  } else {
    if [tk_dialog .encod $t(.encod.encodtitlecomm) $t(.encod.encodmsg) question 0 "UTF-8" "Shift-JIS"] {
      fconfigure $out -encoding shiftjis
    } else {
      fconfigure $out -encoding utf-8
    }
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
      file delete "$v(saveDir)/$v(appname)-comment.txt"    ;# �R�����g���S���Ȃ�������폜
    }
  }
}

proc setFontSize {} {
  global v fontWindow t

  if [isExist $fontWindow] return ;# ��d�N����h�~
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
# �L�[����̃J�X�^�}�C�Y
#
proc setBind {} {
  global v bindWindow t keys keys_bk

  set bindFuncList [list record recStop nextRec prevRec nextType prevType nextRec0 prevRec0 nextType0 prevType0 togglePlay toggleOnsaPlay toggleMetroPlay searchComment waveReload waveExpand waveShrink ]

  if [isExist $bindWindow] return ;# ��d�N����h�~
  toplevel $bindWindow
  wm title $bindWindow $t(option,setBind)
  wm protocol $bindWindow WM_DELETE_WINDOW {
    array set keys   [array get keys_bk]     ;# �p�����[�^���ȑO�̏�Ԃɖ߂�
    destroy $bindWindow
  }
  bind $bindWindow <Escape> {
    array set keys   [array get keys_bk]     ;# �p�����[�^���ȑO�̏�Ԃɖ߂�
    destroy $bindWindow
  }

  array set keys_bk   [array get keys]       ;# �p�����[�^�o�b�N�A�b�v

  set f [frame $bindWindow.f]
  pack $f

  ;# �V���[�g�J�b�g�ݒ�
  set r 0
  foreach func $bindFuncList {
    label $f.l$r -text $t(bindWindow,$func) -pady 3
    entry $f.e$r -textvar keys($func) -wi 30
    grid $f.l$r -row $r -column 0 -sticky e
    grid $f.e$r -row $r -column 1 -sticky w
    incr r
  }

  ;# ����
  set fex [frame $bindWindow.fex]
  label $fex.lex  -text $t(bindWindow,ex)  -fg red -anchor nw
  label $fex.lex2 -text $t(bindWindow,ex2) -fg red -anchor nw
  label $fex.lex3 -text $t(bindWindow,ex3) -fg red -anchor nw
  grid $fex.lex  -row 0 -sticky w
  grid $fex.lex2 -row 1 -sticky w
  grid $fex.lex3 -row 2 -sticky w
  pack $fex -anchor w

  ;# ����{�^��
  set fb [frame $bindWindow.fb]
  button $fb.ok -text $t(.confm.ok) -wi 8 -command {
    set ret [doSetBind]
    if {$ret == 0} {
      array set keys_bk   [array get keys]     ;# �p�����[�^�o�b�N�A�b�v
      destroy $bindWindow
    } else {
      raise $bindWindow
      focus $bindWindow
    }
  }
  button $fb.ap -text $t(.confm.apply) -wi 8 -command {
    set ret [doSetBind]
    if {$ret == 0} {
      array set keys_bk   [array get keys]     ;# �p�����[�^�o�b�N�A�b�v
    }
    raise $bindWindow
    focus $bindWindow
  }
  button $fb.cn -text $t(.confm.c) -wi 8 -command {
    array set keys   [array get keys_bk]       ;# �p�����[�^���ȑO�̏�Ԃɖ߂�
    destroy $bindWindow
  }
  pack $fb.ok $fb.ap $fb.cn -side left
  pack $fb -anchor w
}

#---------------------------------------------------
# �L�[����̃J�X�^�}�C�Y�B��肪�������0��Ԃ�
#
proc doSetBind {} {
  global v t keys keys_bk

  set kList [array get keys]
  set newBindList {}
  foreach {func value} $kList {
    if {[regexp {^[[:space:]]*$} $value]} continue  ;# ��s�͔�΂�
    set data [split [string trim $value] "-"]       ;# Ctrl-c�Ȃǂ�$modKey$key�ɕ�������
    set last [expr [llength $data] - 1]
    ;# �C���L�[modKey�����߂�
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
    ;# �L�[key�����߂�
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
  ;# �G���[��������΃o�C���h����
  if {[llength $newBindList] > 0} {
    foreach {shortcut func} $newBindList {
      ;# �^���V���[�g�J�b�g�ɂ��Ă̓��ʑΉ�
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
# �ꗗ�\�̌�����
#
proc searchComment {} {
  global v searchWindow t

  ;# ��d�N����h�~
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
# �ꗗ�\�̌���
#
proc doSearchParam {{direction 1}} {
  if $direction {
    doSearchParamNext
  } else {
    doSearchParamPrev
  }
}

#---------------------------------------------------
# �ꗗ�\�̌���(�擪����)
#
proc doSearchParamPrev {} {
  global v searchWindow t

  ;# �T���J�n�l�����߂�
  if {$v(typeSeq) > 0} {
    set rStart $v(recSeq)
    set ts [expr $v(typeSeq) - 1]
  } else {
    set rStart [expr $v(recSeq) - 1]
    set ts [expr [llength $v(typeList)] - 1]
  }

  ;# ���ݒn�̑O����擪�܂ł�����
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
  ;# �������猻�ݒn�܂ł�����
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
  ;# ������Ȃ������ꍇ
  tk_messageBox -title $t(searchComment,doneTitle) -icon warning \
      -message [eval format $t(searchComment,doneMsg)]
  if [winfo exists $searchWindow] {
    focus $searchWindow.f.e
  } else {
    focus .entpwindow.t
  }
}

#---------------------------------------------------
# �ꗗ�\�̌���(��������)
#
proc doSearchParamNext {} {
  global v searchWindow t

  ;# �T���J�n�l�����߂�
  if {$v(typeSeq) < [expr [llength $v(typeList)] - 1]} {
    set rStart $v(recSeq)
    set ts [expr $v(typeSeq) + 1]
  } else {
    set rStart [expr $v(recSeq) + 1]
    set ts 0
  }

  ;# ���ݒn�̌ォ�疖���܂ł�����
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
  ;# �擪���猻�ݒn�܂ł�����
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
  ;# ������Ȃ������ꍇ
  tk_messageBox -title $t(searchComment,doneTitle) -icon warning \
      -message [eval format $t(searchComment,doneMsg)]
  if [winfo exists $searchWindow] {
    focus $searchWindow.f.e
  } else {
    focus .entpwindow.t
  }
}

#---------------------------------------------------
# UST�t�@�C�����烊�X�g�𐶐�����
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
    if [tk_dialog .encod $t(.encod.encodtitlerec) $t(.encod.encodmsg) question 0 "UTF-8" "Shift-JIS"] {
      fconfigure $in -encoding shiftjis
    } else {
      fconfigure $in -encoding utf-8
    }
  
    set v(recList) {}
    while {![eof $in]} {
      set data [split [gets $in] "="]
      if {[llength $data] > 1} {
        set item [lindex $data 0]       ;# ���ږ�
        set val  [lindex $data 1]       ;# �f�[�^���e
        if {$item == "Lyric"} {
          ;# �d�����Ȃ���΃��X�g�ɒǉ�
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
# oremo-settings.ini�t�@�C����ǂ�
#
proc readSysIniFile {} {
  global v startup

  if [catch {open $startup(sysIniFile) r} fp] {
    return
  }
  while {![eof $fp]} {
    set l [gets $fp]
    if {[regexp {^autoSaveInitFile=(.+)$} $l dummy bool]} {      ;# $topdir/oremo-init.tcl�������ۑ����邩�ǂ���
      set v(autoSaveInitFile) $bool
    }
  }
  close $fp
}

#---------------------------------------------------
# �R�����g���X�g�t�@�C����ǂ݁A�z��ɋL������
#
proc readCommentList {{fname ""}} {
  global v t

  array unset v "recComment,*"  ;# �R�����g������������B����̓R�����g�t�@�C���������Ă�����������(�ۑ��t�H���_��ύX�����Ƃ��ɈȑO�̃R�����g���m���ɏ�������)�B

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
  if [tk_dialog .encod $t(.encod.encodtitlecomm) $t(.encod.encodmsg) question 0 "UTF-8" "Shift-JIS"] {
      fconfigure $in -encoding shiftjis
    } else {
      fconfigure $in -encoding utf-8
    }

  if [catch {set data [read $in]}] {
    tk_messageBox -message [eval format $t(readCommentList,errMsg)] \
      -title $t(.confm.fioErr) -icon warning
  }
  close $in

  # setParam�`���R�����g�t�@�C���ɂ��Ă̏���
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
    # OREMO�`���R�����g�t�@�C���ɂ��Ă̏���
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
# setParam�`���̂悤�ł���Γǂݍ��ނ��m�F���A�ǂݍ��ށB
# �ǂݍ��񂾏ꍇ�̓��X�g��Ԃ��A�����łȂ��ꍇ�͋󃊃X�g��Ԃ�
#
proc isSetparamComment {fname lineNum} {
  global v t

  regsub -nocase -- {\-comment.txt$} $fname ".ini" iniFile

  # ini�t�@�C�����J����H
  if [catch {open $iniFile r} in] {  return {} }

  # ini�t�@�C���̍s���̓R�����g�t�@�C���̍s���ƈꏏ�H
  if [catch {set iniData [read $in]}] {
    close $in
    return {}
  }
  close $in
  set iniLineNum [llength [split $iniData "\n"]]
  if {$lineNum != $iniLineNum} { return {} }

  # setParam�`���̃R�����g�t�@�C���Ƃ��ēǂݍ��ނ��q�˂�
  set iniFile [file tail $iniFile]
  set act [tk_dialog .confm $t(.confm) [eval format $t(isSetparamComment,q)] \
    question 1 $t(.confm.r) $t(.confm.nr)]
  if {$act != 0} { return {} }

  #
  # setParam�`���R�����g�t�@�C���Ƃ��ēǂݍ���
  #
  # ini�t�@�C���̃f�[�^����e�R�����g�ɑΉ����鉹�������o��
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
# �������X�g�t�@�C����ǂ݁A���X�g�ɋL������
#
proc readRecList {args} {
  global v t
  set old 0
  if {[llength $args] == 0 || ! [file exists $v(recListFile)]} {
    set fn [tk_getOpenFile -initialfile $v(recListFile) \
            -title $t(readRecList,title1) -defaultextension "txt" \
            -filetypes { {{reclist file} {.txt}} {{All Files} {*}} }]
  } else {
    set old 1
    set fn [lindex $args 0]
  }
  if {$fn == ""} return
  set v(recListFile) $fn

  if [catch {open $v(recListFile) r} in] { 
    tk_messageBox -message [eval format $t(readRecList,errMsg)] \
      -title $t(.confm.fioErr) -icon warning
  } else {
    if {$old} {
      fconfigure $in -encoding $v(recListFileEncoding)
    } elseif [tk_dialog .encod $t(.encod.encodtitlerec) $t(.encod.encodmsg) question 0 "UTF-8" "Shift-JIS"] {
      fconfigure $in -encoding shiftjis
      set $v(recListFileEncoding) shiftjis
    } else {
      fconfigure $in -encoding utf-8
      set $v(recListFileEncoding) utf-8
    }
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

    # �������X�g�t�H���_�ɃR�����g�t�@�C�����������ꍇ�̏���
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
# �����^�C�v�̃��X�g�t�@�C����ǂ݁A���X�g�ɋL������
# ���X�g�̍ŏ��̗v�f�� "" �����Ă���
#
proc readTypeList {args} {
  global v t
  set old 0
  if {[llength $args] == 0 || ! [file exists $v(typeListFile)]} {
    set fn [tk_getOpenFile -initialfile $v(typeListFile) \
            -title $t(readTypeList,title) -defaultextension "txt" \
            -filetypes { {{typelist file} {.txt}} {{All Files} {*}} }]
  } else {
    set fn [lindex $args 0]
    set old 1
  }
  if {$fn == ""} return
  set v(typeListFile) $fn

  set v(typeList) {""}
  if [catch {open $v(typeListFile) r} in] { 
    tk_messageBox -message [eval format $t(readTypeList,errMsg) \
      -title $t(.confm.fioErr) -icon warning
  } else {
    if {$old} {
      fconfigure $in -encoding $v(typeListFileEncoding)
    } elseif [tk_dialog .encod $t(.encod.encodtitletype) $t(.encod.encodmsg) question 0 "UTF-8" "Shift-JIS"] {
      fconfigure $in -encoding shiftjis
      set $v(typeListFileEncoding) shiftjis
    } else {
      fconfigure $in -encoding utf-8
      set $v(typeListFileEncoding) utf-8
    }
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
# ���{��t�H���g��ݒ肷��
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
# �O���R�}���h��t�@�C���AURL�����s����
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
        # atode, �����͂��߂�firefox�ɂ��Ȃ��ƁB�B
        if [catch {exec sh -c "netscape -remote 'openURL($url)' -raise"} res] {
            if [string match *netscape* $res] {
                exec sh -c "netscape $url" &
            }
        }
    }
}

#---------------------------------------------------
# �ۑ��f�B���N�g�����w�肷��
# �ύX������1�A�L�����Z��������0��Ԃ�
#
proc choosesaveDir {{readParam 0}} {
  global v t

  set d [tk_chooseDirectory -initialdir $v(saveDir) -title $t(choosesaveDir,title)]
  if {$d != ""} {
    saveCommentList      ;# ���݂̃R�����g��ۑ�
    set v(saveDir) $d
    readCommentList "$v(saveDir)/$v(appname)-comment.txt"     ;# �R�����g��ǂݍ���
    set v(msg) [eval format $t(choosesaveDir,doneMsg)]

    #if {$readParam != 0} {
    #  set act [tk_dialog .confm $t(.confm) $t(choosesaveDir,q) \
    #    question 0 $t(.confm.r) $t(.confm.nr)]
    #  set v(paramFile) "$v(saveDir)/oto.ini"
    #  if {$act == 0} readParamFile
    #}
    resetDisplay
    return 1  ;# �ύX����
  }
  return 0    ;# �ύX�Ȃ�
}

#---------------------------------------------------
# ���ۑ��ł���Δg�`���t�@�C���ɕۑ�����
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
# �t�@�C������g�`��ǂ�
#
proc readWavFile {} {
  global v snd paDev t

  if {$paDev(usePlay)} {
    playStopPa              ;# �Đ����������ꍇ�͒�~������
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
# ���ϗ��̊e���K�̎��g�������߂�
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
# F0�v�Z���ɃL�[�{�[�h�A�}�E�X���͂𐧌������邽�߂̑�
# ���܂�����\���ł��Ă��Ȃ����AF0�v�Z���̓��͂𐧌��ł���̂�
# �Ƃ肠����OK(F0�v�Z���ɓ��͂���Ɨ����邱�Ƃ����邽��)
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
  if {$v(playOnsaStatus)} {  ;# �������[�v�Đ����������Ȃ�A
    toggleOnsaPlay           ;# ��~���āA
    toggleOnsaPlay           ;# ������x�Đ��B
  }
}

#---------------------------------------------------
# ���^BGM�̑�
#
proc bgmGuide {} {
  global v bgm t
  if [isExist .bgmg] return ;# ��d�N����h�~
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
# �w�肵���t�@�C����ǂݍ���ōĐ�����
#
proc testPlayBGM {fname} {
  global bgm paDev t
  if ![file exists $fname] {
    tk_messageBox -message "[eval format $t(testPlayBGM,errMsg)] (fname=$fname)" \
      -title $t(testPlayBGM,errTitle) -icon warning -parent .bgmg
    return
  }
  ;# snack�����Đ�
  if {!$paDev(usePlay)} {
    if [snack::audio active] return
    bgm read $fname
    bgm play
  } else {
  ;# PortAudio�����Đ�
    putsPa bgm "wav $fname"
    set ret [getsPa bgm]
    if {[regexp {^Success} $ret]} {
      putsPa bgm "play"
      getsPa bgm
    }
  }
}

#---------------------------------------------------
# BGM���~����
#
proc testStopBGM {} {
  global bgm paDev t
  ;# snack������~
  if {!$paDev(usePlay)} {
    bgm stop
  } else {
  ;# PortAudio�����Đ�/��~
    putsPa bgm "stop"
    getsPa bgm
  }
}


#---------------------------------------------------
# ���g���m�[���̑�
#
proc tempoGuide {} {
  global v metro t
  if [isExist .tg] return ;# ��d�N����h�~
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
# ���g�����w�肵��sin�g���Đ�����
#
proc pitchGuide {} {
  global v f0 t
  if [isExist .pg] return ;# ��d�N����h�~
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

  ;# �e�����ɑΉ�������g���������v�Z���ĕ\������(���ɉ�������)
  ;# ����or�I�N�^�[�u�ɕω�������Ύ��g���v�Z���s��
  ;# ���g����f0(guideFreq)�łȂ�f0(guideFreqTmp)�ɓ����̂́A
  ;#�uOK�vor�u�K�p�v�{�^���������܂Œl�ύX�𔽉f�����Ȃ����߁B
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
# �w�肵�����g��[Hz]��sin�g���Đ�����
#
proc playSin {freq vol length} {
  global v onsa t
  if [snack::audio active] return
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
# �O�̉��̎��^�Ɉړ�
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
  if $::debug {puts "prevRec: �O�̉���, recseq=$v(recSeq), v(recLab)=$v(recLab)"}
}

#---------------------------------------------------
# ���̉��̎��^�Ɉړ�
#
proc nextRec {{save 1}} { 
  global v rec t

  set tmp [expr $v(recSeq) + 2]
  if {$tmp < [llength $v(recList)]} {
    $rec see $tmp
  }
  jumpRec [expr ($v(recSeq) + 1) % [llength $v(recList)]] $save
  if $::debug { puts "nextRec: ���̉���, recseq=$v(recSeq), v(recLab)=$v(recLab)" }
}

#---------------------------------------------------
# �w�肵���ԍ��̉��̎��^�Ɉړ�
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
  set v(recComment,$v(recLab)$v(typeLab)) $v(recComment)  ;# ���݂̃R�����g��ۑ�
  set v(recLab) [lindex $v(recList) $v(recSeq)] 
  if {[array names v "recComment,$v(recLab)$v(typeLab)"] != ""} {
    set v(recComment) $v(recComment,$v(recLab)$v(typeLab))
  } else {
    set v(recComment) ""
  }
  set v(recStatus) 0
  readWavFile
  Redraw all
  if $::debug { puts "jumpRec: ���̉���, recseq=$v(recSeq), v(recLab)=$v(recLab)" }
}

#---------------------------------------------------
# �O�̔��b�^�C�v�̎��^�Ɉړ�
#
proc prevType {{save 1}} { 
  global v type t

  if {$v(typeSeq) > 0} {
    set seq [expr $v(typeSeq) - 1]
  } else {
    set seq [expr [llength $v(typeList)] - 1]
  }
  jumpType $seq $save
  if $::debug { puts "prevType: �O�̃^�C�v��, typeseq=$v(typeSeq), v(typeLab)=$v(typeLab)" }
}

#---------------------------------------------------
# ���̔��b�^�C�v�̎��^�Ɉړ�
#
proc nextType {{save 1}} { 
  global v type t

  jumpType [expr ($v(typeSeq) + 1) % [llength $v(typeList)]] $save
  if $::debug { puts "nextType: ���̃^�C�v��, typeseq=$v(typeSeq), v(typeLab)=$v(typeLab)" }
}

#---------------------------------------------------
# �w�肵���ԍ��̔����^�C�v�̎��^�Ɉړ�
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
  set v(recComment,$v(recLab)$v(typeLab)) $v(recComment)  ;# ���݂̃R�����g��ۑ�
  set v(typeLab) [lindex $v(typeList) $v(typeSeq)] 
  if {[array names v "recComment,$v(recLab)$v(typeLab)"] != ""} {
    set v(recComment) $v(recComment,$v(recLab)$v(typeLab))
  } else {
    set v(recComment) ""
  }
  set v(recStatus) 0
  readWavFile
  Redraw all
  if $::debug { puts "jumpType: ���̉���, typeseq=$v(typeSeq), v(typeLab)=$v(typeLab)" }
}

#---------------------------------------------------
# DC��������
#
proc removeDC {} {
  global snd t
  set flt [snack::filter iir -numerator "0.99 -0.99" -denominator "1 -0.99"] 
  snd filter $flt -continuedrain 0
}

#---------------------------------------------------
# �g�`���������Ɋg��k��(ctrl+�}�E�X�z�C�[��)
# mode=1...�g��, mode=0...�k��
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
  set v(skipChangeWindowBorder) 1   ;# �ꎞ�I��changeWindowBorder�𖳌�������
  update                            ;# ���X�g�{�b�N�X�̕����X�V����
  set v(skipChangeWindowBorder) 0   ;# changeWindowBorder��L��������
  set w [expr [winfo x .fig] + [winfo width .fig]]
  wm geometry . [format "%dx%d" $w $v(winHeight)]
  changeWindowBorder
}

#---------------------------------------------------
# �������X�g�{�b�N�X���������Ɋg��k��(ctrl+�}�E�X�z�C�[��)
# mode=1...�g��, mode=0...�k��
#
proc changeRecListWidth {mode} {
  global rec srec type stype t v
  set width [$rec cget -width]
  if $mode {
    $rec configure -width [expr $width +1]   ;# �g��
  } elseif {$width > 5} {
    $rec configure -width [expr $width -1]   ;# �k��
  }
  ;# ���X�g�{�b�N�X�̕��ύX�𔽉f������
  ;# ���X�g�{�b�N�X���ύX��changeWindowBorder�̑����������̂ňꎞ�I�ɖ���������(�D�L����)
  set v(skipChangeWindowBorder) 1   ;# �ꎞ�I��changeWindowBorder�𖳌�������
  update                            ;# ���X�g�{�b�N�X�̕����X�V����
  set v(skipChangeWindowBorder) 0   ;# changeWindowBorder��L��������
  set w [expr [winfo x .fig] + [winfo width .fig]]
  wm geometry . [format "%dx%d" $w $v(winHeight)]
  changeWindowBorder
  set v(winWidthMin) [expr [winfo x .fig] + $v(cWidthMin)]
  wm minsize . $v(winWidthMin) $v(winHeightMin)
}

#---------------------------------------------------
# �����^�C�v���X�g�{�b�N�X���������Ɋg��k��(ctrl+�}�E�X�z�C�[��)
# mode=1...�g��, mode=0...�k��
#
proc changeTypeListWidth {mode} {
  global rec srec type stype t v
  set width [$type cget -width]
  if $mode {
    $type configure -width [expr $width +1]   ;# �g��
  } elseif {$width > 5} {
    $type configure -width [expr $width -1]   ;# �k��
  }
  ;# ���X�g�{�b�N�X�̕��ύX�𔽉f������
  ;# ���X�g�{�b�N�X���ύX��changeWindowBorder�̑����������̂ňꎞ�I�ɖ���������(�D�L����)
  set v(skipChangeWindowBorder) 1   ;# �ꎞ�I��changeWindowBorder�𖳌�������
  update                            ;# ���X�g�{�b�N�X�̕����X�V����
  set v(skipChangeWindowBorder) 0   ;# changeWindowBorder��L��������
  set w [expr [winfo x .fig] + [winfo width .fig]]
  wm geometry . [format "%dx%d" $w $v(winHeight)]
  changeWindowBorder
  set v(winWidthMin) [expr [winfo x .fig] + $v(cWidthMin)]
  wm minsize . $v(winWidthMin) $v(winHeightMin)
}

#---------------------------------------------------
# �����^���J�n(BGM��)
#
proc autoRecStart {} {
  global bgm bgmParam paDev snd v t

  if [snack::audio active] return
  if {$v(rec) == 0} return   ;# ���^���[�h�łȂ��Ȃ�I��

  ;# BGM�t�@�C����ǂݍ���
  if ![file exists $v(bgmFile)] {
    tk_messageBox -title $t(.confm.fioErr) -icon error -message [eval format $t(autoRecStart,errMsg)]
    return
  }
  bgm read $v(bgmFile)

  ;# BGM�ݒ�t�@�C����ǂݍ���
  set v(bgmParamFile) [file rootname $v(bgmFile)].txt
  if [catch {open $v(bgmParamFile) r} fp] {
    tk_messageBox -title $t(.confm.fioErr) -icon error -message [eval format $t(autoRecStart,errMsg2)]
    return
  }

  set unit [regsub -all -- {,} [string trim [gets $fp]] ""]   ;# �����P�ʂ��擾
  if ![regexp {^(sec|SEC|msec|MSEC|sample)$} $unit] {
    tk_messageBox -message "[eval format $t(autoRecStart,errMsg3)] ($t(autoRecStart,unit)=$unit)" -icon warning
    return
  }
  array unset bgmParam
  set bgmParam(autoRecStatus) 0  ;# �ȉ��̉�͒��ɃG���[���������ꍇ��0��return
  set sr [bgm cget -rate]
  while {![eof $fp]} {
    set l [gets $fp]
    if {[regexp {^[[:space:]]*#} $l]} continue
    set p [split $l ","] ;# �s,����,�^���J�n,�^����~,���̎��^���ֈړ�,���s�[�g��
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
    ;# �X�p�Q�e�B�Ȑݒ�t�@�C���̏ꍇ�A���̃G���[�`�F�b�N������ʂ���\��������
    tk_messageBox -message [eval format $t(autoRecStart,errMsg4)] -icon error
    return
    ;# set bgmParam($seq,pStop) [bgm length]  ;# BGM����
  }

  ;# after�R�}���h�����s����Ԋu�����߂�
  for {set i 1} {$i <= $seq} {incr i} {
    set bgmParam($i,after) [expr int(($bgmParam($i,pStop) - $bgmParam($i,pStart)) \
                                      * 1000.0 / $sr + 0.5)]
  }

  ;# PortAudio�p�ɃK�C�hBGM��ǂݍ���
  if {$paDev(usePlay)} {
    putsPa bgm "wav $v(bgmFile)"
    set ret [getsPa bgm]
    if {![regexp {^Success} $ret]} {
      tk_messageBox -message "$t(aRecStart,errPa)\n$ret" -title $t(.confm.errTitle) -icon warning
      return
    }
  } else {
    ;# �^���`�����w�肷��
    snd configure -channels Mono -rate $v(sampleRate) -fileformat WAV -encoding Lin16
  }

  set bgmParam(autoRecStatus) 1
  set v(recStatus) 1
  .msg.msg configure -fg blue
  autoRec 1 ;# BGM�Đ��E�^���J�n
}

#---------------------------------------------------
# �����^���J�n(�K�C�hBGM���Đ�,�^���J�n/��~�B�ċA�I�ɌĂ΂��)
#
proc autoRec {seq} {
  global bgm bgmParam paDev v t
  if {! $bgmParam(autoRecStatus)} return
  set com ""
  if {$bgmParam($seq,repeat) != 0} {
    if {$v(rec) == 3} {
      set com "autoRec $bgmParam($seq,repeat)"  ;#���s�[�g
    } else {
      autoRecStop                               ;#���s�[�g�����I��
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
      nextRec                             ;# ���̉���
    } else {
      autoRecStop                         ;# ���̉��֍s�����I��
      return
    }
  }
  set v(msg) $bgmParam($seq,msg)

  ;# �K�C�hBGM�Đ�(snack)
  if {!$paDev(usePlay)} {
    bgm play -start $bgmParam($seq,pStart) -end $bgmParam($seq,pStop) -command $com
    ;#if {$seq == 1} {
    ;#  bgm play -start $bgmParam($seq,pStart)
    ;#}
  } else {
  ;# �K�C�hBGM�Đ�(PortAudio)
    foreach id [after info] {
      after cancel $id           ;# �ҋ@�C�x���g(autoRec)���폜����
    }
    after $bgmParam($seq,after) $com
    if {$seq == 1} {
      putsPa bgm "playF $bgmParam($seq,pStart)"
      getsPa bgm
    }
  }
}

#---------------------------------------------------
# �����Ŏw�肵���P�ʂ̒l���T���v���P�ʂɕϊ�����
#
proc val2samp {val from sr} {
  switch $from {
    MSEC -
    msec { ;# msec �� �T���v���P�ʂɕϊ�
      return [expr int($val / 1000.0 * $sr)]
    }
    SEC  -
    sec  { ;# sec �� �T���v���P�ʂɕϊ�
      return [expr int($val * $sr)]
    }
    default { ;# ���̂܂ܕԂ�(�O�̂��ߐ���������)
      return int($val);
    }
  }
}

#---------------------------------------------------
# �^���J�n
#
proc aRecStart {} {
  global snd v bgmParam paDev t
  if {$v(rec) == 0 || $v(recNow) || $bgmParam(autoRecStatus) == 0} return
  if {$paDev(useRec)} {
    putsPa rec "rec"    ;# PortAudio�g�p���̘^���J�n
    set ret [getsPa rec]
    if {![regexp {^Success} $ret]} {
      autoRecStop  ;# �����^����~
      tk_messageBox -message "$t(aRecStart,errPa)\n$ret" -title $t(.confm.errTitle) -icon warning
      return
    }
  } else {
    snd record             ;# snack�g�p���̘^���J�n
  }
  set v(recNow) 1
  set v(recStatus) 1
}

#---------------------------------------------------
# �^���I��(�����^�����̂̏I���ł͂Ȃ�)
#
proc aRecStop {} {
  global snd v paDev t
  if {$v(rec) == 0 || $v(recNow) == 0} return   ;# ���^���[�h�łȂ��Ȃ�I��
  if {$paDev(useRec)} {
    putsPa rec "stop"    ;# PortAudio�g�p���̘^����~
    set ret [getsPa rec]
    if {![regexp {^Success} $ret]} {
      autoRecStop  ;# �����^����~
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
    snd stop               ;# snack�g�p���̘^����~
  }
  if $v(removeDC) removeDC
  set v(recNow) 0
;#  Redraw all
}

#---------------------------------------------------
# �����^���I��
#
proc autoRecStop {} {
  global bgm bgmParam paDev v t
  set bgmParam(autoRecStatus) 0
  foreach id [after info] {
    after cancel $id           ;# �ҋ@�C�x���g���폜����
  }
  if {$paDev(usePlay)} {
    putsPa bgm "stop"
    getsPa bgm
  } else {
    bgm stop   ;# ���{���͂���Ŏ~�܂��ė~�������ǎ~�܂��Ă���Ȃ��B�B���{���H�����Ǝ~�܂��Ă�̂ł́H
  }
  .msg.msg configure -fg black
  set v(msg) [eval format $t(autoRecStop,doneMsg)]
  aRecStop
  Redraw all
}

#---------------------------------------------------
# ���g���m�[���Đ�/��~�̐ؑ�
#
proc toggleMetroPlay {} {
  global paDev v metro t

  if $v(playMetroStatus) {
    set v(msg) $t(toggleMetroPlay,stopMsg)
    metro stop  ;# �{���͂����Ŏ~�܂��ė~�������~�܂�Ȃ�
    set v(playMetroStatus) 0
  } else {
    ;# �e���|�̃`�F�b�N
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
# wav�����[�v�Đ�����
#
proc loopPlay {s end} {
  global v t
  if $v(playMetroStatus) {
    $s play -start 0 -end $end -command "loopPlay $s $end"
  }
}

#---------------------------------------------------
# wav�����[�v�Đ�����(PortAudio��)
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
# �����Đ�/��~�̐ؑ�
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
# �Đ����t�@�C�������ɓ��B�����ꍇ�̌�n��(PortAudio�p�B�������ȑΉ����@)
#
proc playEndPa {} {
  global v t

  if {$v(playStatus) == 0} return
  putsPa play "stat"
  set ret [getsPa play]
  if {$ret == 2} {
    after 200 playEndPa   ;# �Đ����Ȃ�������΂炭�҂�
  } else {
    set v(playStatus) 0
    set v(msg) $t(togglePlay,stopMsg)
    update
  }
}

#---------------------------------------------------
# �Đ��o�[��\������
#
proc showPlayBar {t0} {
  global v c paDev

  $c delete playBar
  if {$v(playStatus) == 0} return

  if {$paDev(usePlay)} {
    ;# PortAudio�Đ��̏ꍇ�At0�ɂ͌��݂̎���(sec)������
    set x [expr $t0 * $v(wavepps)]
    $c create line $x 0 $x $v(cHeight) -fill #FFA000 -tags playBar
    after 50 showPlayBar [expr $t0 + 0.05]
  } else {
    ;# snack�Đ��̏ꍇ�At0�ɂ͍Đ��J�n����(sec)������
    set x [expr ([snack::audio elapsedTime] + $t0) * $v(wavepps)]
    $c create line $x 0 $x $v(cHeight) -fill #FFA000 -tags playBar
    after 50 showPlayBar $t0
  }
}

#---------------------------------------------------
# �Đ��r���Œ�~������(PortAudio��)
#
proc playStopPa {} {
  global v t

  putsPa play "stat"
  set ret [getsPa play]
  if {$ret == 2} {                       ;# �Đ����������ꍇ�͒�~������
    foreach id [after info] {
      after cancel $id           ;# �ҋ@�C�x���g(playEndPa)���폜����
    }
    putsPa play "stop"
    getsPa play
    set v(playStatus) 0
    set v(msg) $t(togglePlay,stopMsg)
    showPlayBar -1
  }
}

#---------------------------------------------------
# �Đ�/��~�̐ؑ�
#
proc togglePlay {{start 0} {end -1}} {
  global paDev v snd t

  if {[snd length] <= 0} return

  ;# PortAudio�����Đ�/��~
  if {$paDev(usePlay)} {
    putsPa play "stat"
    set ret [getsPa play]
    if {$ret == 2} {
      playStopPa                 ;# �Đ����������ꍇ�͒�~������
    } else {                     ;# ��~���������ꍇ�͍Đ�������
      foreach id [after info] {
        after cancel $id           ;# �ҋ@�C�x���g(playEndPa)���폜����
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

  ;# snack�����Đ�/��~
  if $v(playStatus) {
    snd stop
    set v(playStatus) 0
    set v(msg) $t(togglePlay,stopMsg)
  } else {
    set v(msg) $t(togglePlay,playMsg)
    set v(playStatus) 1
    snd play -start $start -end $end -command {
      set v(playStatus) 0       ;# �Đ��I�������Ƃ��̏���
      set v(msg) $t(togglePlay,stopMsg)
    }
    set sampleRate [snd cget -rate]
    showPlayBar [expr $start / $sampleRate]
  }
}

#---------------------------------------------------
# �����^�C�~���O�␳���[�hON/OFF�̐ؑ�
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
# ���X�g�{�b�N�X�̏c����ύX
#
proc resizeListbox {} {
  global v rec type srec stype   ;# update���邽�߂�global srec stype����K�v������

  set h [expr (double([winfo reqheight $rec]) / [$rec cget -height])]
  set lh [expr int($v(cHeight) / $h)]
  $rec  configure -height $lh
  $type configure -height $lh
  update
  $rec see $v(recSeq)
  $type see $v(typeSeq)
}

#---------------------------------------------------
# �g�`�\��/��\���̐ؑ�
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
# �X�y�N�g���\��/��\���̐ؑ�
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
# �p���[�\��/��\���̐ؑ�
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
# F0�\��/��\���̐ؑ�
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
# UTAU�p�����p�����[�^�\��/��\���̐ؑ�
#
proc toggleParam {} {
  global v t

  Redraw param
}

#---------------------------------------------------
# F0�p�l���̏c���\��
# snack �� unix/snack.tcl �� frequencyAxis ������
proc myAxis {canvas x y width height args} {
  global v
  # ��������
  array set a [list \
    -tags snack_y_axis -font {Helvetica 8} -max 1000 \
    -fill black -draw0 0 -min 0 -unit Hz]
  array set a $args

  if {$height <= 0} return
  if {$a(-max) <= $a(-min)} return

  # �s�A�m���[����\��
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

  ;# ticklist...�ڐ���̊Ԋu�̌��
  set ticklist [list 0.2 0.5 1 2 5 10 20 50 100 200 500]

  foreach elem $ticklist {
    set npt $elem  ;# npt...�ڐ��̒l�̊Ԋu
    ;# dy...�ڐ����`�悷��Ԋu(y���W)
    set dy [expr {double($height * $npt) / $max_min}]
    if {$dy >= [font metrics $a(-font) -linespace]} break
  }
  set hztext $a(-unit)
  if {$hztext == "semitone"} {set hztext st} ;# �\����Z�k

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

  ;# j=�`�悷��ڐ���̔ԍ�
  set yzure [expr {double($a(-min) - ($j0 - 1) * $npt) * $height / $max_min}]

  set yc [expr {$height + $y + $yzure - $i0}]  ;# �ڐ���`�悷��y���W
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
# �F�I��
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
# �����ɑΉ�������g����Ԃ�
#
proc tone2freq {tone} {
  global v t
  for {set i 0} {$i < [llength $v(sinNote)]} {incr i} {
    if {$tone == [lindex $v(sinNote) $i]} break
  }
  return [lindex $v(sinScale) $i]
}

#---------------------------------------------------
# �g�`�F�ݒ�
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
# 1Hz�ɑ΂�����g������Z�~�g�[���ɂ���
#
proc hz2semitone {hz} {
  return [expr log($hz) / log(2) * 12.0]
}


#---------------------------------------------------
# ���ږ��F[�G���g���[]�̃t���[��������Ĕz�u����(power�p)
#
proc packEntryPower {wname text key} {
  global power t
  pack [frame $wname] -anchor w
  label $wname.lfl -text $text -width 20 -anchor w
  entry $wname.efl -textvar power($key) -wi 6
  pack $wname.lfl $wname.efl -side left
}

#---------------------------------------------------
# ���ږ��F[�G���g���[]�̃t���[��������Ĕz�u����(f0�p)
#
proc packEntryF0 {wname text key} {
  global f0 t
  pack [frame $wname] -anchor w
  label $wname.lfl -text $text -width 20 -anchor w
  entry $wname.efl -textvar f0($key) -wi 6
  pack $wname.lfl $wname.efl -side left
}

#---------------------------------------------------
# �����̑I�����j���[��pack�����t���[���𐶐�
#
proc packToneList {w text toneKey octaveKey freqKey width vol} {
  global f0 v t
  pack [frame $w] -fill x
  # ���ږ����x��
  label $w.l -text $text -width $width -anchor w
  # �����I��
  eval tk_optionMenu $w.t f0($toneKey) $v(toneList)
  # �I�N�^�[�u�I��
  set ss {}
  for {set i $v(sinScaleMin)} {$i <= $v(sinScaleMax)} {incr i} {
    lappend ss $i
  }
  eval tk_optionMenu $w.o f0($octaveKey) $ss
  # �����{�^��
  button $w.play -text $t(packToneList,play) -bitmap snackPlay -command \
    "playSin \[tone2freq \$f0($toneKey)\$f0($octaveKey)\] \$f0($vol) \$v(sampleRate)"
  button $w.togglePlay -text $t(packToneList,repeat) -command {
    toggleOnsaPlay
  }
  # ���ɑΉ�������g����\�����郉�x��
  label $w.$freqKey -textvar f0($freqKey) -width 3 -anchor e
  label $w.unit -text "Hz"
  pack $w.l $w.t $w.o $w.play $w.togglePlay $w.$freqKey $w.unit -side left
}

#---------------------------------------------------
#   ���o�̓f�o�C�X��o�b�t�@�T�C�Y������������
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
  # snack::audio selectInput $dev(in) ;# �����R�[�h���Ή�
}

#---------------------------------------------------
# ���݂̐ݒ��ۑ�����
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
#  set fp [open $fn w]   ;# �ۑ��t�@�C�����J��
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
  # ���ۑ�����z��𑝂₵����A�����ɒǉ�����Ƌ���doReadInitFile��global�ɂ��ǉ�

  if {$fn == ""} {
    set fn [tk_getSaveFile -initialfile $startup(initFile) \
            -title $t(saveSettings,title) -defaultextension "tcl" ]
  }
  if {$fn == ""} return

  ;# �ۑ��t�@�C�����J��
  if [catch {open $fn w} fp] {
    tk_messageBox -message "error: can not open $fn" -title $t(.confm.fioErr) -icon warning
    return
  }
  foreach aName $startup(arrayForInitFile) {
    set sList [array get $aName]
    foreach {key value} $sList {
      ;# �����������[���܂܂�Ă���΃G�X�P�[�v�V�[�P���X��}������
      regsub -all -- {\[} $value "\\\[" value

      ;# $topdir���̃t�@�C�����w�����f�[�^�Ȃ�_OREMO_TOPDIR_�Ƃ��������ɒu��������
      ;# ��PC�Ɉړ��������Ȃ�topdir�̈Ⴄ���ɂ��Ή������邽��
      if {[string first $topdir $value] == 0} {
        set value [string replace $value 0 [expr [string length $topdir] - 1] "_OREMO_TOPDIR_"]
      }

      if {[lsearch $startup(exclusionKeysForInitFile,aName) $aName] < 0 ||
          [lsearch $startup(exclusionKeysForInitFile,$aName) $key]  < 0} {
        ;# �ۑ��Ώۂ̃f�[�^����������
        puts $fp [format "set %s(%s)\t\t{%s}" $aName $key $value]
      }
    }
  }
  close $fp
}

#---------------------------------------------------
# �������t�@�C�����w�肵�ēǂݍ���
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
# ���b�Z�[�W�e�L�X�g�t�@�C���⏉�����t�@�C����ǂݍ���
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

  ;# �ȈՃT�j�^�C�W���O
  while {![eof $in]} {
    set l [gets $in]

    if {[regexp {^[ \t]*$} $l]}                   continue  ;# ��s��OK
    if {[regexp {^[ \t]*(;|)[ \t]*#} $l]}         continue  ;# �R�����g�s��OK

    regsub -all -- {\\\[} $l "" l                           ;# \[����������Ł��̃`�F�b�N���s��
    if {[regexp {^[ \t]*set[ \t]+[^;\[]+$} $l]} continue    ;# set ��;��[���Ȃ����OK

    ;# �G���[���������ꍇ
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

  source $initFile

  ;# _OREMO_TOPDIR_��$topdir�ɒu��������
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
# �w�肵�������N���ς݂��`�F�b�N�B�N���ς݂Ȃ�t�H�[�J�X����B
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
# PortAudio�ɂ��^���c�[�����N������Breturn 0=����ɋN���B
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
    fconfigure $paDevFp(rec) -buffering none   ;# �o�b�t�@�����O�����Ȃ�

    ;# �f�o�C�X�ꗗ���擾����
    $paDev(devListMenu) delete 0 end
    putsPa rec "list"
    set paDev(devList) [split [getsPa rec] "\n"]
    foreach d $paDev(devList) {
      regsub -all {(\r|\n)} $d "" d
      $paDev(devListMenu) insert end radiobutton -variable paDev(in) -label $d -value $d
    }
    if {[llength $paDev(devList)] <= 0} {
      ;# �f�o�C�X�����o�ł��Ȃ������ꍇ
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
      set paDev(in) [lindex $paDev(devList) 0]  ;# �ŏ��̃f�o�C�X�������I������
    }
    updateIoSettings
  }
  return 0
}

#---------------------------------------------------
# PortAudio�ɂ��Đ��c�[�����N������Breturn 0=����ɋN���B
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
    fconfigure $paDevFp(play) -buffering none   ;# �o�b�t�@�����O�����Ȃ�
    fconfigure $paDevFp(bgm)  -buffering none   ;# �o�b�t�@�����O�����Ȃ�

    ;# �f�o�C�X�ꗗ���擾����
    $paDev(outdevListMenu) delete 0 end
    putsPa play "list"
    set paDev(outdevList) [split [getsPa play] "\n"]
    foreach d $paDev(outdevList) {
      regsub -all {(\r|\n)} $d "" d
      $paDev(outdevListMenu) insert end radiobutton -variable paDev(out) -label $d -value $d
    }
    if {[llength $paDev(outdevList)] <= 0} {
      ;# �f�o�C�X�����o�ł��Ȃ������ꍇ
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
      set paDev(out) [lindex $paDev(outdevList) 0]  ;# �ŏ��̃f�o�C�X�������I������
    }
    updateIoSettings
  }
  return 0
}

#---------------------------------------------------
# PortAudio�ɂ��^���c�[�����~����
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
# PortAudio�ɂ��Đ��c�[�����~����
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
# PortAudio�̘^���c�[���Ɉ�s�𑗂�
#
proc putsPa {m str} {
  global paDevFp
  puts $paDevFp($m) $str
  flush $paDevFp($m)
}

#---------------------------------------------------
# PortAudio�̘^���c�[������̌��ʒʒm����ǂ�ŕԂ�
#
proc getsPa {m} {
  global paDevFp

  set ret ""
  set paFlag 0   ;# 1="resultBegin"��ʉߌ�
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
# PortAudio/Snack�̐؂�ւ��ŗL��/�����ɂȂ�ݒ荀�ڂ�؂�ւ���
#
proc updateIoSettings {} {
  global v paDev paDevFp ioswindow

  if ![isExist $ioswindow] return

  set normal   {}
  set black    {}
  set disabled {}
  set gray     {}
  if {$paDevFp(rec) != ""} {
    ;# PortAudio���͂�L���ASnack���͂𖳌��ɂ���
    set normal   [concat $normal   {pf.in  pf.esr pf.fmt pf.ech pf.ebs}]
    set black    [concat $black    {pf.lin pf.lsr pf.lbt pf.lch pf.lbs}]
    set disabled [concat $disabled {sf.f1.in sf.f3.e sf.f3.s sf.f6.e}]
    set gray     [concat $gray     {sf.f1.lin sf.f3.l sf.f6.l sf.f6.u}]
  } else {
    ;# PortAudio���͂𖳌��ASnack���͂�L���ɂ���
    set disabled [concat $disabled {pf.in  pf.ech}]
    set gray     [concat $gray     {pf.lin pf.lch}]
    set normal   [concat $normal   {sf.f1.in sf.f3.e sf.f3.s sf.f5.e sf.f6.e}]
    set black    [concat $black    {sf.f1.lin sf.f3.l sf.f5.l sf.f5.u sf.f6.l sf.f6.u}]
  }
  if {$paDevFp(play) != ""} {
    ;# PortAudio�o�͂�L���ASnack�o�͂𖳌��ɂ���
    set normal   [concat $normal   {pf.out  pf.esr pf.fmt pf.ebs}]
    set black    [concat $black    {pf.lout pf.lsr pf.lbt pf.lbs}]
    set disabled [concat $disabled {sf.f2.out sf.f4.l sf.f4.e sf.f4.s sf.f7.e}]
    set gray     [concat $gray     {sf.f2.l   sf.f4.l sf.f6.u sf.f7.u sf.f7.l}]
  } else {
    ;# PortAudio�o�͂𖳌��ASnack�o�͂�L���ɂ���
    set disabled [concat $disabled {pf.out}]
    set gray     [concat $gray     {pf.lout}]
    set normal   [concat $normal   {sf.f2.out sf.f4.l sf.f4.e sf.f4.s sf.f5.e sf.f7.e}]
    set black    [concat $black    {sf.f2.l   sf.f4.l sf.f5.l sf.f5.u sf.f6.u sf.f7.u sf.f7.l}]
  }
  ;# PortAudio���́E�o�͂����ɖ����̎�
  if {$paDevFp(rec) == "" && $paDevFp(play) == ""} {
    set disabled [concat $disabled {pf.esr pf.fmt pf.ech pf.ebs}]
    set gray     [concat $gray     {pf.lsr pf.lbt pf.lch pf.lbs}]
  }
  ;# PortAudio���́E�o�͂����ɗL���̎�
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
# ���o�̓f�o�C�X�̐ݒ葋�̒l���f�o�C�X�ɔ��f������
# ����������0�A���s�Ȃ�1��Ԃ�
#
proc setIODevice {} {
  global dev snd bgm t paDev paDevFp
  ;# snack��dev(in),dev(out)�ɂ̓��j���[�\���̂��ߊ����R�[�h��sjis��utf-8��
  ;# �ϊ���������������Ă���B�f�o�C�X�ݒ莞�ɂ͌��̊����R�[�h�������
  ;# �w�肵�Ȃ��ƃG���[�ɂȂ�l�q�Ȃ̂ňȉ��̂悤�ȃR�[�h�őΉ����Ă���

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

  ;# PortAudio���Ƀf�o�C�X�ݒ��`����
  if {$paDev(useRequestRec)} {
    ;# �f�o�C�X�ԍ����擾
    set dID ""
    regexp {^[0-9]+} $paDev(in) dID
    if {$dID == ""} {
      tk_messageBox -message $t(setIODevice,errPa2) -title $t(.confm.errTitle) -icon warning
      return 1
    }
    ;# �ʎq���r�b�g��PortAudio�̏���̔ԍ��ɕϊ�
    switch $paDev(sampleFormat) {
      "Int16"   { set paSampleFormat 8 }
      "Int24"   { set paSampleFormat 4 }
      "Int32"   { set paSampleFormat 2 }
      "Float32" { set paSampleFormat 1 }
    }
    ;# �`�����l�����`�F�b�N
    set paDev(channel) [string trim $paDev(channel)]
    if {![regexp {^[0-9]+$} $paDev(channel)]} {
      tk_messageBox -message $t(setIODevice,errPa3) -title $t(.confm.errTitle) -icon warning
      return 1
    }
    ;# �T���v�����O���g���`�F�b�N
    set paDev(sampleRate) [string trim $paDev(sampleRate)]
    if {![regexp {^[0-9]+$} $paDev(sampleRate)]} {
      tk_messageBox -message $t(setIODevice,errPa4) -title $t(.confm.errTitle) -icon warning
      return 1
    }
    ;# �o�b�t�@�T�C�Y�`�F�b�N
    set paDev(bufferSize) [string trim $paDev(bufferSize)]
    if {![regexp {^[0-9]+$} $paDev(bufferSize)]} {
      tk_messageBox -message $t(setIODevice,errPa5) -title $t(.confm.errTitle) -icon warning
      return 1
    }
    ;# "set �f�o�C�X�ԍ� �`��(bit)�ԍ� �`�����l�� �T���v�����O���g�� �o�b�t�@�T�C�Y
    putsPa rec "set $dID $paSampleFormat $paDev(channel) $paDev(sampleRate) $paDev(bufferSize)"
    set ret [getsPa rec]
    if {![regexp {^Success} $ret]} {
      tk_messageBox -message "$t(setIODevice,errPa)\n$ret" -title $t(.confm.errTitle) -icon warning
      return 1
    }
  } else {
    ;# snack�g�p���̃f�o�C�X�ݒ�
    foreach dname [snack::audio inputDevices] {
      if {$dev(in) == [encoding convertfrom $dname]} {
        snack::audio selectInput  $dname
        break
      }
    }
    snack::audio record_gain  $dev(ingain)
  }
  set paDev(useRec)  $paDev(useRequestRec)   ;# portaudio�ݒ�ŃG���[�����������̂Ń��N�G�X�g�𐳎��Ɏ󗝂���

  ;# PortAudio���Ƀf�o�C�X�ݒ��`����
  if {$paDev(useRequestPlay)} {
    ;# �f�o�C�X�ԍ����擾
    set dID ""
    regexp {^[0-9]+} $paDev(out) dID
    if {$dID == ""} {
      tk_messageBox -message $t(setIODevice,errPaOut2) -title $t(.confm.errTitle) -icon warning
      return 1
    }
    ;# �ʎq���r�b�g��PortAudio�̏���̔ԍ��ɕϊ�
    switch $paDev(sampleFormat) {
      "Int16"   { set paSampleFormat 8 }
      "Int24"   { set paSampleFormat 4 }
      "Int32"   { set paSampleFormat 2 }
      "Float32" { set paSampleFormat 1 }
    }
    ;# �`�����l�����`�F�b�N
    set paDev(channel) [string trim $paDev(channel)]
    if {![regexp {^[0-9]+$} $paDev(channel)]} {
      tk_messageBox -message $t(setIODevice,errPa3) -title $t(.confm.errTitle) -icon warning
      return 1
    }
    ;# �T���v�����O���g���`�F�b�N
    set paDev(sampleRate) [string trim $paDev(sampleRate)]
    if {![regexp {^[0-9]+$} $paDev(sampleRate)]} {
      tk_messageBox -message $t(setIODevice,errPa4) -title $t(.confm.errTitle) -icon warning
      return 1
    }
    ;# �o�b�t�@�T�C�Y�`�F�b�N
    set paDev(bufferSize) [string trim $paDev(bufferSize)]
    if {![regexp {^[0-9]+$} $paDev(bufferSize)]} {
      tk_messageBox -message $t(setIODevice,errPa5) -title $t(.confm.errTitle) -icon warning
      return 1
    }
    ;# "set �f�o�C�X�ԍ� �`��(bit)�ԍ� �`�����l�� �T���v�����O���g�� �o�b�t�@�T�C�Y
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
    ;# snack�g�p���̃f�o�C�X�ݒ�
    foreach dname [snack::audio outputDevices] {
      if {$dev(out) == [encoding convertfrom $dname]} {
        snack::audio selectOutput $dname
        break
      }
    }
    snack::audio play_gain    $dev(outgain)
    snack::audio playLatency  $dev(latency)
  }
  set paDev(usePlay) $paDev(useRequestPlay)  ;# portaudio�ݒ�ŃG���[�����������̂Ń��N�G�X�g�𐳎��Ɏ󗝂���

  snd configure -buffersize $dev(sndBuffer)
  bgm configure -buffersize $dev(bgmBuffer)

  readWavFile
  return 0
}

#---------------------------------------------------
#   ���o�̓f�o�C�X��o�b�t�@�T�C�Y��ݒ肷�鑋
#
proc ioSettings {} {
  global ioswindow dev dev_bk paDev paDev_bk snd bgm t

  if [isExist $ioswindow] return ;# ��d�N����h�~
  toplevel $ioswindow
  wm title $ioswindow $t(ioSettings,title)
  wm resizable $ioswindow 0 0
  bind $ioswindow <Escape> {destroy $ioswindow}

  ;# �Q�C���A���C�e���V�̍ŐV�󋵂��擾
  set dev(ingain)  [snack::audio record_gain]
  set dev(outgain) [snack::audio play_gain]
  set dev(latency) [snack::audio playLatency]
  set dev(sndBuffer) [snd cget -buffersize]
  set dev(bgmBuffer) [bgm cget -buffersize] 
  array set dev_bk   [array get dev]       ;# �p�����[�^�o�b�N�A�b�v
  array set paDev_bk [array get paDev]     ;# �p�����[�^�o�b�N�A�b�v


  #-----------------------
  # snack�ݒ�p�̃t���[��
  set sf [labelframe $ioswindow.sf -text "Snack" \
    -relief groove -padx 5 -pady 5]
  pack $sf -fill both -expand false

  ;# ���̓f�o�C�X�̑I��
  set devList {}
  foreach d [snack::audio inputDevices] {
    set d [encoding convertfrom $d]
    lappend devList "$d"
    # if {[string length $d] == [string bytelength $d]} {  ;# �p��f�o�C�X�̂ݓo�^
    #  lappend devList "$d"
    # }
  }
  set f1 [frame $sf.f1]
  label $f1.lin -text $t(ioSettings,inDev) -width 12 -anchor w
  eval tk_optionMenu $f1.in dev(in) $devList
  pack $f1.lin $f1.in -side left
  pack $f1 -anchor w

  ;# �o�̓f�o�C�X�̑I��
  set devList {}
  foreach d [snack::audio outputDevices] {
    set d [encoding convertfrom $d]
    lappend devList "$d"
    #if {[string length $d] == [string bytelength $d]} {  ;# �p��f�o�C�X�̂ݓo�^
    #  lappend devList "$d"
    #}
  }
  set f2 [frame $sf.f2]
  label $f2.l -text $t(ioSettings,outDev) -width 12 -anchor w
  eval tk_optionMenu $f2.out dev(out) $devList
  pack $f2.l $f2.out -side left
  pack $f2 -anchor w

  ;# ���̓Q�C���̎w��
  set f3 [frame $sf.f3]
  label $f3.l -text $t(ioSettings,inGain) -width 32 -anchor w
  entry $f3.e -textvar dev(ingain) -wi 6
  scale $f3.s -variable dev(ingain) -orient horiz \
    -from 0 -to 100 -res 1 -showvalue 0
  pack $f3.l $f3.e $f3.s -side left
  pack $f3 -anchor w

  ;# �o�̓Q�C���̎w��
  set f4 [frame $sf.f4]
  label $f4.l -text $t(ioSettings,outGain) -width 32 -anchor w
  entry $f4.e -textvar dev(outgain) -wi 6
  scale $f4.s -variable dev(outgain) -orient horiz \
    -from 0 -to 100 -res 1 -showvalue 0
  pack $f4.l $f4.e $f4.s -side left
  pack $f4 -anchor w

  ;# ���C�e���V�̎w��
  set f5 [frame $sf.f5]
  label $f5.l -text $t(ioSettings,latency) -width 32 -anchor w
  entry $f5.e -textvar dev(latency) -wi 6
  label $f5.u -text "(msec)"
  pack $f5.l $f5.e $f5.u -side left
  pack $f5 -anchor w

  ;# ���^���̃o�b�t�@�T�C�Y�̎w��
  set f6 [frame $sf.f6]
  label $f6.l -text $t(ioSettings,sndBuffer) -width 32 -anchor w
  entry $f6.e -textvar dev(sndBuffer) -wi 6
  label $f6.u -text "(sample)"
  pack $f6.l $f6.e $f6.u -side left
  pack $f6 -anchor w

  ;# �K�C�hBGM�̃o�b�t�@�T�C�Y�̎w��
  set f7 [frame $sf.f7]
  label $f7.l -text $t(ioSettings,bgmBuffer) -width 32 -anchor w
  entry $f7.e -textvar dev(bgmBuffer) -wi 6
  label $f7.u -text "(sample)"
  pack $f7.l $f7.e $f7.u -side left
  pack $f7 -anchor w

  #-----------------------
  # portaudio�ݒ�p�̃t���[��
  frame $ioswindow.pa
  label $ioswindow.pa.l -text $t(ioSettings,portaudio)
  # PortAudio�^��
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
  # PortAudio�Đ�
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

  ;# ���̓f�o�C�X
  label $pf.lin -text $t(ioSettings,inDev) -anchor w
  set paDev(devListMenu) [tk_optionMenu $pf.in paDev(in) "none"]
  $paDev(devListMenu) delete 0 end
  foreach d $paDev(devList) {
    regsub -all {(\r|\n)} $d "" d
    $paDev(devListMenu) insert end radiobutton -variable paDev(in) -label $d -value $d
  }
  ;# �o�̓f�o�C�X
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

  ;# ����{�^��
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
      array set dev_bk   [array get dev]       ;# �p�����[�^�o�b�N�A�b�v
      array set paDev_bk [array get paDev]     ;# �p�����[�^�o�b�N�A�b�v
    } else {
      raise $ioswindow
      focus $ioswindow
    }
  }
  button $fb.cn -text $t(.confm.c) -wi 8 -command {
    array set dev   [array get dev_bk]       ;# �p�����[�^���ȑO�̏�Ԃɖ߂�
    array set paDev [array get paDev_bk]     ;# �p�����[�^���ȑO�̏�Ԃɖ߂�
    setIODevice
    destroy $ioswindow
  }
  pack $fb.ok $fb.ap $fb.cn -side left
  pack $fb -anchor w

  ;# ������
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
# �v���O���X�o�[�����������ĕ\������
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
# �v���O���X�o�[���X�V����B�i���󋵂�$progress(0�`100)�Ŏw�肷��)
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
# �v���O���X�o�[����������
#
proc deleteProgressWindow {} {
  global prgWindow
  destroy $prgWindow
}



#---------------------------------------------------
# �ڍאݒ�
#
proc settings {} {
  global swindow v power f0 v_bk power_bk f0_bk snd t
  global onsa metro bgm uttTiming
    # ��*_bk�͑��ϐ��ɂ��Ȃ��ƃL�����Z�����Ƀo�b�N�A�b�v���A�ł��Ȃ�����

  ;# ��d�N����h�~
  if [isExist $swindow] return
  toplevel $swindow
  wm title $swindow $t(settings,title)
  wm resizable $swindow 0 0
  bind $swindow <Escape> {destroy $swindow}

  array set v_bk     [array get v]     ;# �p�����[�^�o�b�N�A�b�v
  array set power_bk [array get power] ;# �p�����[�^�o�b�N�A�b�v
  array set f0_bk    [array get f0]    ;# �p�����[�^�o�b�N�A�b�v

  ;# 1�J�����ڂ̃t���[��
  set frame1 [frame $swindow.l]
  pack $frame1 -side left -anchor n -fill y -padx 2 -pady 2

  ;#---------------------------
  ;# �g�`
  set lf1 [labelframe $frame1.lf1 -text $t(settings,wave) \
    -relief groove -padx 5 -pady 5]
  pack $lf1 -anchor w -fill x

  ;# �g�`�F�̐ݒ�
  set cw [frame $lf1.f4w]
  setColor $cw "wavColor" $t(settings,waveColor)
  pack $cw -anchor nw

  ;# �g�`�c���̍ő�l
  pack [frame $lf1.fs] -anchor w
  label $lf1.fs.l -text $t(settings,waveScale) -wi 35 -anchor w
  entry $lf1.fs.e -textvar v(waveScale) -wi 6 -validate key -validatecommand {
    if {[regexp {^[0-9]*$} %P]} {return 1} ;# �󕶎���Ok
    return 0
  }
  pack $lf1.fs.l $lf1.fs.e  -side left

  ;# �T���v�����O���g���̐ݒ�
  pack [frame $lf1.f20] -anchor w
  label $lf1.f20.l -text $t(settings,sampleRate) -wi 35 -anchor w
  entry $lf1.f20.e -textvar v(sampleRate) -wi 6 -validate key -validatecommand {
    if {[regexp {^[0-9]*$} %P]} {return 1}
    return 0
  }
  pack $lf1.f20.l $lf1.f20.e  -side left

  ;#---------------------------
  ;# �X�y�N�g���p�����[�^
  set lf2 [labelframe $frame1.lf2 -text $t(settings,spec) \
    -relief groove -padx 5 -pady 5]
  pack $lf2 -anchor w -fill x

  ;# �X�y�N�g���̔z�F
  pack [frame $lf2.f45] -anchor w
  label $lf2.f45.l -text $t(settings,specColor) -width 20 -anchor w
  tk_optionMenu $lf2.f45.cm v(cmap) grey color1 color2
  pack $lf2.f45.l $lf2.f45.cm -side left

  ;# �X�y�N�g�����g���̍ō��l
  pack [frame $lf2.f20] -anchor w
  label $lf2.f20.l -text $t(settings,maxFreq) -width 20 -anchor w
  entry $lf2.f20.e -textvar v(topfr) -wi 6
  scale $lf2.f20.s -variable v(topfr) -orient horiz \
    -from 0 -to [expr $v(sampleRate)/2] -showvalue 0
  pack $lf2.f20.l $lf2.f20.e $lf2.f20.s -side left

  ;# ���邳
  pack [frame $lf2.f30] -anchor w
  label $lf2.f30.l -text $t(settings,brightness) -width 20 -anchor w
  entry $lf2.f30.e -textvar v(brightness) -wi 6
  scale $lf2.f30.s -variable v(brightness) -orient horiz \
    -from -100 -to 100 -res 0.1 -showvalue 0
  pack $lf2.f30.l $lf2.f30.e $lf2.f30.s -side left

  ;# �R���g���X�g
  pack [frame $lf2.f31] -anchor w
  label $lf2.f31.l -text $t(settings,contrast) -width 20 -anchor w
  entry $lf2.f31.e -textvar v(contrast) -wi 6
  scale $lf2.f31.s -variable v(contrast) -orient horiz \
    -from -100 -to 100 -res 0.1 -showvalue 0
  pack $lf2.f31.l $lf2.f31.e $lf2.f31.s -side left

  ;# FFT��(�K��2�ׂ̂���ɂ��邱��)
  pack [frame $lf2.f32] -anchor w
  label $lf2.f32.l -text $t(settings,fftLength) -width 20 -anchor w
  tk_optionMenu $lf2.f32.om v(fftlen) 8 16 32 64 128 256 512 1024 2048 4096
  pack $lf2.f32.l $lf2.f32.om -side left

  ;# ����(�K��FFT���ȉ��ɂ��邱��)
  pack [frame $lf2.f33] -anchor w
  label $lf2.f33.l -text $t(settings,fftWinLength) -width 20 -anchor w
  entry $lf2.f33.e -textvar v(winlen) -wi 6
  scale $lf2.f33.s -variable v(winlen) -orient horiz \
    -from 8 -to 4096 -showvalue 0
  pack $lf2.f33.l $lf2.f33.e $lf2.f33.s -side left

  ;# �v���G���t�@�V�X
  pack [frame $lf2.f34] -anchor w
  label $lf2.f34.l -text $t(settings,fftPreemph) -width 20 -anchor w
  entry $lf2.f34.e -textvar v(preemph) -wi 6
  pack $lf2.f34.l $lf2.f34.e -side left

  ;# ���̑I��
  pack [frame $lf2.f35] -anchor w
  label $lf2.f35.lwn -text $t(settings,fftWinKind) -width 20 -anchor w
  tk_optionMenu $lf2.f35.mwn v(window) \
    Hamming Hanning Bartlett Blackman Rectangle
  pack $lf2.f35.lwn $lf2.f35.mwn -side left

  ;#---------------------------
  ;# �p���[�̐ݒ�
  set lf3 [labelframe $frame1.lf3 -text $t(settings,pow) \
    -relief groove -padx 5 -pady 5]
  pack $lf3 -anchor w -fill x

  ;# �p���[�F�̐ݒ�
  set cp [frame $lf3.f4p]
  setColor $cp "powcolor" $t(settings,powColor)
  pack $cp -anchor nw

  ;# �p���[���o���݂̐ݒ�
  packEntryPower $lf3.ffl $t(settings,powLength) frameLength

  ;# �v���G���t�@�V�X�̐ݒ�
  packEntryPower $lf3.fem $t(settings,powPreemph) preemphasis

  ;# �����̐ݒ�
  packEntryPower $lf3.fwl $t(settings,winLength) windowLength

  ;# ���̑I��
  pack [frame $lf3.fwn] -anchor w
  label $lf3.fwn.lwn -text $t(settings,powWinKind) -width 20 -anchor w
  tk_optionMenu $lf3.fwn.mwn power(window) \
    Hamming Hanning Bartlett Blackman Rectangle
  pack $lf3.fwn.lwn $lf3.fwn.mwn -side left

  ;#---------------------------
  ;#---------------------------
  ;# 2�J�����ڂ̃t���[��
  set frame2 [frame $swindow.r]
  pack $frame2 -side left -anchor n -fill both -expand true -padx 2 -pady 2

  ;#---------------------------
  ;# F0�̐ݒ�
  set lf4 [labelframe $frame2.lf4 -text $t(settings,f0) \
    -relief groove -padx 5 -pady 5]
  pack $lf4 -anchor w -fill x

  ;# F0�F�̐ݒ�
  set cf [frame $lf4.f4f]
  setColor $cf "f0color" $t(settings,f0Color)
  pack $cf -anchor nw

  ;# ���o�A���S���Y���̑I��
  pack [frame $lf4.p1] -anchor w
  label $lf4.p1.l -text $t(settings,f0Argo) -width 20 -anchor w
  tk_optionMenu $lf4.p1.mt f0(method) ESPS AMDF
  pack $lf4.p1.l $lf4.p1.mt -side left

  ;# entry�^�̐ݒ肢�낢��
  packEntryF0 $lf4.p2 $t(settings,f0Length)    frameLength
  packEntryF0 $lf4.p3 $t(settings,f0WinLength) windowLength
  packEntryF0 $lf4.p4 $t(settings,f0Max)       max
  packEntryF0 $lf4.p5 $t(settings,f0Min)       min

  ;# �\���P�ʂ̑I��
  pack [frame $lf4.p6] -anchor w
  label $lf4.p6.l -text $t(settings,f0Unit) -width 20 -anchor w
  tk_optionMenu $lf4.p6.mt f0(unit) Hz semitone
  pack $lf4.p6.l $lf4.p6.mt -side left

  ;# �e���̐���\��
  checkbutton  $lf4.p8cb -text $t(settings,grid) \
    -variable f0(showToneLine) -onvalue 1 -offvalue 0 -anchor w
  pack $lf4.p8cb -anchor w -fill x

  ;# �O���t�͈͂̐ݒ�
  checkbutton $lf4.p7cb -text $t(settings,f0FixRange) \
    -variable f0(fixShowRange) -onvalue 1 -offvalue 0 -anchor w
  pack [labelframe $lf4.p7 -labelwidget $lf4.p7cb \
    -relief ridge -padx 5 -pady 5] -anchor w -fill x
  packToneList $lf4.p7.tl1 $t(settings,f0FixRange,h) \
    showMaxTone showMaxOctave showMaxTmp 10 checkVol
  packToneList $lf4.p7.tl2 $t(settings,f0FixRange,l) \
    showMinTone showMinOctave showMinTmp 10 checkVol

  ;# �^�[�Q�b�g���̐���\��
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

  ;# �e�����ɑΉ�������g���������v�Z���ĕ\������(���ɉ�������)
  ;# ����or�I�N�^�[�u�ɕω�������Ύ��g���v�Z���s��
  ;# ���g����f0(tgtFreq)�ȂǂłȂ�f0(tgtFreqTmp)�Ȃǂɓ����̂́A
  ;#�uOK�vor�u�K�p�v�{�^���������܂Œl�ύX�𔽉f�����Ȃ����߁B
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
  ;# OK, Apply, �L�����Z���{�^��
  pack [frame $frame2.f] -anchor e -side bottom -padx 2 -pady 2
  button $frame2.f.exit -text $t(.confm.c) -command {
    array set v     [array get v_bk]     ;# �p�����[�^���ȑO�̏�Ԃɖ߂�
    array set power [array get power_bk] ;# �p�����[�^���ȑO�̏�Ԃɖ߂�
    array set f0    [array get f0_bk]    ;# �p�����[�^���ȑO�̏�Ԃɖ߂�
    Redraw all
    destroy $swindow
  }
  button $frame2.f.app -text $t(.confm.apply) -command {
    ;# �󗓂̕⊮
    if {![regexp {^[0-9]+$} $v(waveScale)]} {   ;# �󕶎��́~
      set v(waveScale) $v_bk(waveScale)
    }
    if {![regexp {^[0-9]+$} $v(sampleRate)]} {   ;# �󕶎��́~
      set v(sampleRate) $v_bk(sampleRate)
    }
    ;# �T���v�����O���g���̕ύX
    if {$v(sampleRate) != $v_bk(sampleRate)} {
      snd configure -rate $v(sampleRate)
      onsa  configure -rate $v(sampleRate)
      metro configure -rate $v(sampleRate)
      bgm   configure -rate $v(sampleRate)
      uttTiming(clickSnd)  configure -rate $v(sampleRate)
    }
    ;# �^�[�Q�b�g���̎��g�������߂�
    set f0(tgtFreq) [tone2freq "$f0(tgtTone)$f0(tgtOctave)"]
    ;# F0�\���͈͎��g�������߂�
    if $f0(fixShowRange) {
      set f0(showMin) [tone2freq "$f0(showMinTone)$f0(showMinOctave)"]
      set f0(showMax) [tone2freq "$f0(showMaxTone)$f0(showMaxOctave)"]
    }
    Redraw all
    ;# �p�����[�^�o�b�N�A�b�v�̍X�V
    array set v_bk     [array get v]     ;# �p�����[�^�o�b�N�A�b�v
    array set power_bk [array get power] ;# �p�����[�^�o�b�N�A�b�v
    array set f0_bk    [array get f0]    ;# �p�����[�^�o�b�N�A�b�v
  }
  button $frame2.f.ok -text $t(.confm.ok) -wi 6 -command {
    ;# �󗓂̕⊮
    if {![regexp {^[0-9]+$} $v(waveScale)]} {   ;# �󕶎��́~
      set v(waveScale) $v_bk(waveScale)
    }
    if {![regexp {^[0-9]+$} $v(sampleRate)]} {   ;# �󕶎��́~
      set v(sampleRate) $v_bk(sampleRate)
    }
    ;# �T���v�����O���g���̕ύX
    if {$v(sampleRate) != $v_bk(sampleRate)} {
      snd   configure -rate $v(sampleRate)
      onsa  configure -rate $v(sampleRate)
      metro configure -rate $v(sampleRate)
      bgm   configure -rate $v(sampleRate)
      uttTiming(clickSnd)  configure -rate $v(sampleRate)
    }
    ;# �^�[�Q�b�g���̎��g�������߂�
    set f0(tgtFreq) [tone2freq "$f0(tgtTone)$f0(tgtOctave)"]
    ;# F0�\���͈͎��g�������߂�
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
# F0�^�[�Q�b�g�ɍ��킹�đ��̐ݒ�l�������ݒ肷��
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
# tone-octave��add�x�H�グ���Ƃ��̃g�[���ƃI�N�^�[�u�̃��X�g��Ԃ�
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
# ������ς���
#
proc changeWindowBorder {args} {
  global v sv c srec stype   ;# srec�Astype ��set�R�}���h��������̂�global���Ă����K�v�L

  if {$v(skipChangeWindowBorder)} return ;# ����������Ă���ꍇ�͂����ŏI��
  update

  # ��������
  array set a [list -w [winfo width .] -h [winfo height .] ]
  array set a $args

  if {$v(winWidth) == $a(-w) && $v(winHeight) == $a(-h)} return

  set winHeightOld $v(winHeight)
  set v(winWidth)  $a(-w)
  set v(winHeight) $a(-h)
  set cWidthOld $v(cWidth)
  # set v(cWidth)  [expr $a(-w) - $v(yaxisw) - 8]  ;# 4�̓L�����o�X���E�̃}�[�W��
  set v(cWidth)  [expr $a(-w) - [winfo width .s] - $v(yaxisw) - 8]  ;# 4�̓L�����o�X���E�̃}�[�W��
  set sndLength [snd length -unit SECONDS]
  if {$sndLength > 0} {
    set v(wavepps) [expr $v(cWidth) / $sndLength]  ;# wav�S�̂�\��
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
# �L�����o�X�ĕ`��
#
proc Redraw {opt} {
  global v c cYaxis snd power f0 rec t

  # �`�撆�͑��̑��삪�ł��Ȃ��悤�ɂ���
  # grab set $c
  # �����ꂪ����Ƒ��̋����h���b�O���ăT�C�Y�ύX�ł��Ȃ��Ȃ�̂Ń{�c

  ;# �L�����o�X��̂��̂��폜���č������Ē�������
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

  ;# �g�`�\��
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

  ;# �X�y�N�g���\��
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

  ;# �p���[�\��
  if $v(showpow) {
    set sndPow snd
    ;# �ʎq���r�b�g��16bit�ȊO�̏ꍇ�̑Ή�(16bit�ɂ���)
    if {[snd cget -encoding] != "Lin16"} {
      set sndPow [snack::sound _sndPow]
      $sndPow copy snd
      switch [snd cget -encoding] {
        # "Lin24" { $sndPow filter [snack::filter map [expr 65535.0 / 16777215.0  ]] }
        # "Lin32" { $sndPow filter [snack::filter map [expr 65535.0 / 4294967295.0]] }
        "Float" { $sndPow filter [snack::filter map 65535.0] }
      }
    }
    ;# �p���[�𒊏o
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
      # �p���[�̍ő�l�E�ŏ��l�����߂�
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

      # ppd= 1dB������̃s�N�Z�����B
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

    ;# �p���[�𒊏o�����Ȃ炻��FID���L�^����
    if {$power(fid) != $v(recLab)} {
      set power(fid) $v(recLab)
    }
  }

  ;# F0�\��
  if $v(showf0) {
    set ytop [expr $v(waveh) + $v(spech) + $v(powh)]
    set ylow [expr $ytop + $v(f0h)]
    ;# F0�𒊏o
    if {$opt == "all" || $opt == "f0"} {
      ;# F0���o�p�ɔg�`�𐳋K������(������Int16�ȊO�̌`���ɑΉ������邽��)
      snack::sound sndF0
      sndF0 copy snd
      if {[sndF0 cget -channels] > 1} {
        set sndF0 [sndF0 convert -channels Mono]
      }
      set amp [expr [sndF0 max] - [sndF0 min]]
      if {$amp > 0} {
        sndF0 filter [snack::filter map [expr 65535.0 / $amp]]
      }
      ;# F0�𒊏o����
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
      # F0�̍ő�l�E�ŏ��l�����߂�
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
      # �`�悷��X�P�[�������߂�
      if {$f0(fixShowRange)} {
        set f0(extractedMax) $f0(showMax)
        set f0(extractedMin) $f0(showMin)
        if {$f0(unit) == "semitone"} {
          if {$f0(extractedMax) > 0} { set f0(extractedMax) [hz2semitone $f0(extractedMax)] }
          if {$f0(extractedMin) > 0} { set f0(extractedMin) [hz2semitone $f0(extractedMin)] }
        }
#      } else {
#        set f0(extractedMin) $f0(min)  ;# ������f0(min)�ɂ��Ă���
#        if {$f0(unit) == "semitone"} {
#          if {$f0(extractedMin) > 0} { set f0(extractedMin) [hz2semitone $min] }
#        }
      }

      if {$f0(extractedMax) > $f0(extractedMin) && $f0(extractedMin) >= 0} {
        # ppd= 1Hz������̃s�N�Z�����B4�͏㉺�e2�s�N�Z���̃}�[�W��
        set ppd [expr double($v(f0h)) / ($f0(extractedMax) - $f0(extractedMin))]

        # �e���ɑΉ�������g���ŉ���������
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

        # �^�[�Q�b�g�����Ђ�
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

        # F0�f�[�^���v���b�g����
        # set coord {} ;# F0�Ȑ����������W(x,y)��
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
    # ����
    $c create line 0 $ylow $v(cWidth) $ylow -tags axis
#    $c create line $v(yaxisw) $ytop $v(yaxisw) $ylow -tags axis -fill $v(fg)
#    set yAxisLow [expr $ylow + 2]
#    $cYaxis create line 0 $yAxisLow $v(yaxisw) $yAxisLow -tags axis -fill $v(fg)

    ;# F0�𒊏o�����Ȃ�FID���L�^����
    if {$f0(fid) != $v(recLab)} {
      set f0(fid) $v(recLab)
    }
  }

  ;# ���Ԏ��\��
  if {$v(showWave) || $v(showSpec) || $v(showpow) || $v(showf0)} {
    set ytop [expr $v(waveh) + $v(spech) + $v(powh) + $v(f0h)]
    set ylow [expr $ytop + $v(timeh)]
    snack::timeAxis $c 0 $ytop $v(cWidth) $v(timeh) $v(wavepps) \
      -tags axis -starttime 0 -fill $v(fg)
    $c create line 0 $ylow $v(cWidth) $ylow -tags axis
  }

  ;# grab�����
  ;#  grab release $c
}

#---------------------------------------------------
# �^���J�n
#
proc recStart {} {
  global snd v bgmParam paDev t
  if {$v(rec) == 0 || $v(recNow)} return   ;# ���^���[�h�łȂ��A�܂��͊��ɘ^�����Ȃ�I��
  if {$v(rec) >= 2} {
    ;# �������^�̏ꍇ
    if {$bgmParam(autoRecStatus) == 0} {
      autoRecStart
    } else {
      autoRecStop
    }
  } else {
    ;# �蓮���^(ver.1.0�̕��@)�̏ꍇ
    set v(msg) $t(recStart,msg)
    if {$paDev(useRec)} {
      putsPa rec "rec"    ;# PortAudio�g�p���̘^���J�n
      set ret [getsPa rec]
      if {![regexp {^Success} $ret]} {
        tk_messageBox -message "$t(recStart,errPa)\n$ret" -title $t(.confm.errTitle) -icon warning
        return
      }
    } else {
      snd configure -channels Mono -rate $v(sampleRate) -fileformat WAV -encoding Lin16
      snd record             ;# snack�g�p���̘^���J�n
    }
    set v(recStatus) 1
    set v(recNow) 1
  }
}

#---------------------------------------------------
# �^���I��
#
proc recStop {} {
  global snd v t paDev
  if {$v(rec) != 1 || $v(recNow) == 0} return   ;# �蓮���^���[�h�łȂ��܂��͘^�����łȂ��Ȃ�I��
  set v(msg) $t(recStop,msg)
  if {$paDev(useRec)} {
    putsPa rec "stop"    ;# PortAudio�g�p���̘^����~
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
    snd stop               ;# snack�g�p���̘^����~
  }
  if $v(removeDC) removeDC
  set v(recNow) 0
  Redraw all
}

#---------------------------------------------------
# �����p�����[�^�l�̏�����
#
proc initParamS {} {
  global paramS v t

  array unset paramS
}

#---------------------------------------------------
# ParamU��������
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
  set paramU(size_1) 0   ;# �\���p�ɍs��-1�����l��ۑ�
  if $clean return  ;# �����z��T�C�Y��0�ɂ��鏉�����Ȃ炱���ŏI��
  for {set i 0} {$i < [llength $recList]} {incr i} {
    set fid [lindex $recList $i]

    ;# �\�ɕ\������f�[�^��ݒ�
    set paramU($paramUsize,0) $fid

    ;# �����ŎQ�Ƃ���f�[�^��ݒ�
    set paramU($paramUsize,R) $i    ;# �s�ԍ���recList�̔z��ԍ�

    incr paramUsize
  }
  ;# �ꗗ�\�̃T�C�Y���X�V����
  if {$v(appname) != "OREMO" && [winfo exists .entpwindow]} {
    .entpwindow.t configure -rows $paramUsize
  }
  set paramU(size_1) [expr $paramUsize - 1]   ;# �\���p�ɍs��-1�����l��ۑ�
}

#---------------------------------------------------
# �t�@�C����ۑ����ďI��
#
proc Exit {} {
  global v paDev startup t
#  if $v(paramChanged) {
#    set act [tk_dialog .confm $t(.confm) $t(Exit,q1) \
#      question 2 $t(Exit,a1) $t(Exit,a2) $t(Exit,a3)]
#    switch $act {
#      0 {                      ;# �ۑ����ďI������ꍇ
#          if ![saveParamFile] {
#            return  ;# ���������ŕۑ����Ȃ�������I�����~�B
#          }
#        }
#      1 { }                    ;# �ۑ������I������ꍇ
#      2 { return }             ;# �I�����Ȃ��ꍇ
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

  paPlayTerminate ;# �Đ��c�[�����I��
  paRecTerminate  ;# �^���c�[�����I��
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
# �E�N���b�N���j���[
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
# �o�[�W�������\��
#
proc Version {} {
  global v t
  tk_messageBox -title $t(Version,msg) -message "$v(appname) $t(help,Version) $v(version)"
}

#---------------------------------------------------
# ���X�g�{�b�N�X�E�B�W�b�g w �� d �����X�N���[��������(Windows��)
# +/-120 �� Windows �Ńz�C�[����1���������ۂ�%D�ɃZ�b�g�����l
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

