#!/bin/sh
# the next line restarts using wish \
exec wish "$0" "$@"

# 2.0-b091104
# - ��s�����`�F�b�N�p�̐ݒ�z���ǉ�

# 2.0-b090720
# - �e�t�@�C���ւ̃p�X���Aexe(starkit)�̂Ƃ���tcl�̂Ƃ��Ƃ̗����ɑΉ�
# - �K�C�hBGM�֌W�̐ݒ��ǉ�
# - ���g���m�[�����A�K�C�hBGM�֌W�t�@�C����guideBGM/�Ɉړ�

# 2.0-b090706
# - oremo�{�̂ɂ��������ϐ��� globalVar.tcl�ɂ܂Ƃ߂�

#---------------------------------------------------
# �ϐ��ݒ�
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
set v(recListFile) "$topdir/reclist.txt"   ;# ���^���鉹�����X�g�t�@�C��
set v(recListFileEncoding) "shiftjis"
set v(typeListFile) "$topdir/typelist.txt" ;# ���^���锭�b�^�C�v�̃��X�g�t�@�C��
set v(typeListFileEncoding) "shiftjis"
set v(saveDir) "$topdir/result"            ;# �^����������ۑ�����f�B���N�g��
set v(paramFile) "$v(saveDir)/oto.ini"     ;# �����p�����[�^�t�@�C��
set v(yaxisw) 40         ;# �c���\���̉���
set v(timeh)  20         ;# �����\���̏c��
set v(showWave) 1        ;# 1=�g�`�\��, 0=��\��
set v(waveh)  100        ;# �g�`�p�l���̏c��
set v(wavehbackup) 100   ;# �g�`�\���̏c�T�C�Y�̃o�b�N�A�b�v���Ƃ�
set v(wavehmin)  50             ;# �k�������ۂ̍ŏ��c��
set v(wavepps)  200             ;# pixel/sec�B
set v(waveScale) 32768          ;# �g�`�\���c���̍ő�l�B0��autoscale
set v(sfont) {Helvetica 8 bold} ;# �ڐ���\���̃t�H���g
set v(bg) [. cget -bg]
set v(fg) black
set v(wavColor) black
set v(recStatus) 0       ;# 1=���������^������, 0=�^�����ĂȂ�
set v(playStatus) 0      ;# 1=���Đ���, 0=���Đ����ĂȂ�
set v(playOnsaStatus) 0  ;# 1=���݉����Đ���, 0=���ݍĐ����ĂȂ�
set v(recList) {}        ;# ���^���鉹�������郊�X�g
set v(recSeq) 0          ;# ���ݎ��^���̉��ԍ�
set v(recLab) ""         ;# ���ݎ��^���̉���
set v(typeList) {""}     ;# ���^���锭���^�C�v�����郊�X�g
set v(typeLab) ""        ;# ���ݎ��^���̔����^�C�v
set v(typeSeq) 0         ;# ���ݎ��^���̔����^�C�v�ԍ�
set v(bigFontSize) 24    ;# �t�H���g�T�C�Y(���^����)
set v(fontSize) 18       ;# �t�H���g�T�C�Y(���^�����ꗗ)
set v(smallFontSize) 14  ;# �t�H���g�T�C�Y(���̖ڐ�)
set v(commFontSize) 18   ;# �t�H���g�T�C�Y(�R�����g��)
set v(msg) ""            ;# �\�t�g�ŉ��i�ɕ\�����郁�b�Z�[�W
set v(rec) 1             ;# 1=�^��OK�A0=�^���s��
set v(recNow) 0          ;# 1=�^����(r�������Ă����)�A0=�^����~���B
set v(ext) wav           ;# �g�`�t�@�C���̊g���q
set v(autoSaveInitFile) 1 ;# 1=$topdir/oremo-init.tcl�������ۑ�����A0=�ۑ����Ȃ�
set v(skipChangeWindowBorder) 0   ;# �ꎞ�I��changeWindowBorder �̃C�x���g���s�𖳌�������t���O

set v(showSpec) 0        ;# 1=�X�y�N�g���\��, 0=��\��
set v(spech)    0        ;# �X�y�N�g���\���̏c�T�C�Y
set v(spechbackup) 140   ;# �X�y�N�g���\���̏c�T�C�Y�̃o�b�N�A�b�v���Ƃ�
set v(spechmin) 50      ;# �X�y�N�g���\���̏c�T�C�Y(�k�����̍ŏ��c��)
set v(topfr)    8000     ;# �X�y�N�g���\���̍ō����g��
set v(cmap)     grey     ;# �X�y�N�g���z�F
set v(contrast) 0        ;# �X�y�N�g���̃R���g���X�g
set v(brightness) 0      ;# �X�y�N�g���̖��邳
set v(fftlen) 512        ;# FFT��
set v(winlen) 128        ;# ����
set v(window) Hamming    ;# �X�y�N�g�����o��
set v(preemph) 0.97      ;# �X�y�N�g�����o�̃v���G���t�@�V�X

set v(showpow) 0        ;# 1=�p���[�\��, 0=��\��
set v(powh)    0        ;# �p���[�\���̏c�T�C�Y
set v(powhmin) 50       ;# �p���[�\���̏c�T�C�Y(�k�����̍ŏ��c��)
set v(powhbackup) 100   ;# �p���[�\���̏c�T�C�Y�̃o�b�N�A�b�v���Ƃ�
set power(frameLength) 0.02  ;# �p���[���o����[sec]
set power(window)  Hanning    ;# �p���[���o���̑�
set power(preemphasis)  0.97  ;# �p���[���o���̃v���G���t�@�V�X
set power(windowLength)  0.01 ;# �p���[���o����[sec]
set power(power) {}           ;# ���o�����p���[�l�n���ۑ�����
set power(powerMax) 0         ;# ���o���ʂ̍ő�l
set power(powerMin) 0         ;# ���o���ʂ̍ŏ��l
set v(powcolor) blue          ;# �p���[�Ȑ��̐F

set power(uttLow)  28    ;# �����Ƃ݂Ȃ����U����臒l[dB]
set power(uttHigh) 28    ;# ���b�Ƃ݂Ȃ����U����臒l[dB]
set power(uttKeep) 5     ;# ���b���̉��ʂ̂�炬�Ƃ݂Ȃ���镝��臒l[dB]
set power(vLow)    40    ;# �ꉹ�Ƃ݂Ȃ����U����臒l[dB]
set power(uttLengthSec) 0.1  ;# ���b���Ƃ݂Ȃ���鎞�Ԓ�[sec]
set power(uttLength) [sec2samp $power(uttLengthSec) $power(frameLength)]  ;# ���b���Ƃ݂Ȃ���鎞�Ԓ�[sample]
set power(silLengthSec) 0.0  ;# �|�[�Y�Ƃ݂Ȃ���鎞�Ԓ�[sec]
set power(silLength) [sec2samp $power(silLengthSec) $power(frameLength)]  ;# �|�[�Y�Ƃ݂Ȃ���鎞�Ԓ�[sample]
set power(fid) ""                           ;# �p���[���o�����t�@�C����FID

set v(toneList) {C C# D D# E F F# G G# A A# B} ;# �K�C�h�������X�g1oct��
set v(sinScaleMin) 2     ;# �K�C�hsin���̍Œ�I�N�^�[�u
set v(sinScaleMax) 5     ;# �K�C�hsin���̍ō��I�N�^�[�u
set v(sinScale) {}       ;# �K�C�hsin���̎��g�����X�g
set v(sinNote) {}   ;# �K�C�hsin���̎��g���ɑΉ����鉹��
set f0(checkVol) 4000    ;# �ڍאݒ葋�ōĐ�����sin���̐U�������l
set f0(guideVol) 4000    ;# �K�C�hsin���̐U�������l
set f0(tgtTone) [lindex $v(toneList) 0]  ;# �^�[�Q�b�g����
set f0(tgtOctave) $v(sinScaleMin)        ;# �^�[�Q�b�g���̃I�N�^�[�u
set f0(tgtFreq) 0                        ;# �^�[�Q�b�g���̎��g��
set f0(showToneLine) 1                   ;# 1=�e���̉�����F0�p�l���ɕ\��
set f0(showTgtLine) 0                    ;# 1=�^�[�Q�b�g����F0�p�l���ɕ\��
set f0(fid) ""                           ;# F0���o�����t�@�C����FID
set f0(extractedMin) 0                   ;# ���o����F0�̍ŏ��l
set f0(extractedMax) 0                   ;# ���o����F0�̍ő�l

set v(showf0) 0           ;# 1=F0�\��, 0=��\��
set v(f0h)    0           ;# F0�\���̏c�T�C�Y
set v(f0hmin) 50          ;# F0�\���̏c�T�C�Y(�k�����̍ŏ��c��)
set v(f0hbackup) 100      ;# F0�\���̏c�T�C�Y�̃o�b�N�A�b�v���Ƃ�
set f0(method) ESPS       ;# F0���o�A���S���Y��
set f0(frameLength) 0.01  ;# F0���o�Ԋu[sec]
set f0(windowLength) 0.01 ;# F0���o�̑���[sec]
set f0(max) 800           ;# �z�肳���ō�F0
set f0(min) 60            ;# �z�肳���Œ�F0
set f0(showMax) 400       ;# F0�\���͈̔�[Hz]
set f0(showMin) 200       ;# F0�\���͈̔�[Hz]
set f0(showMinTone)   [lindex $v(toneList) 0]    ;# F0�\���͈̔�
set f0(showMinOctave) $v(sinScaleMin)            ;# F0�\���͈̔�
set f0(showMaxTone)   [lindex $v(toneList) end]  ;# F0�\���͈̔�
set f0(showMaxOctave) $v(sinScaleMax)            ;# F0�\���͈̔�
set f0(guideTone)   C  ;# ������
set f0(guideOctave) 3  ;# ������
set f0(guideFreqTmp) 131 
set f0(f0) {}             ;# ���o����F0�n��
set v(f0color) blue       ;# F0�Ȑ��̐F
set v(tgtf0color) red     ;# �^�[�Q�b�gF0�̐F
set f0(fixShowRange) 1    ;# 1=F0�\���X�P�[�����Œ�ɂ���
set f0(unit) semitone     ;# F0�\���X�P�[���Bsemitone, Hz

set v(removeDC) 0         ;# 1=�^����DC��������������
set v(showParam) 1        ;# 1=UTAU�̌����p�����[�^��\��, 0=��\��

set v(cWidth) 500                          ;# �g�`��ʃL�����o�X�̉���
set v(cWidthMin) [expr $v(yaxisw) + 100]   ;# �g�`��ʃL�����o�X�̉����ŏ��l
set v(cHeight) [expr $v(waveh) + $v(spech) + $v(powh) + $v(f0h) + $v(timeh)]
                                           ;# �g�`��ʃL�����o�X�̏c��
set v(winWidth) 640
set v(winWidthMax) [lindex [wm maxsize .] 0]
set v(winHeight) 0
set v(winWidthMin) 400
set v(winHeightMin) 100

set conState 0  ;# console ��show�Ȃ�1�Ahide�Ȃ�0�ł��邱�Ƃ�����킷
set scrollWidget ""      ;# ���݃}�E�X�����X�g�{�b�N�X�ɂ���΂��̃p�X������

set v(sampleRate) 44100  ;# �����̃T���v�����O���g��[Hz]
set v(paramChanged) 0    ;# 1=�����p�����[�^�����ۑ�,0=�ۑ��ς�
set v(sdirection) 1 ;# ������������B1=���B0=��B
set v(sMatch)  full ;# �������@�Bfull=���S��v�Asub=������v
set v(keyword) ""   ;# �����L�[���[�h
set v(recComment) "" ;# �R�����g��

# �X�y�N�g���z�F
set v(grey) " "
set v(color1) {#000 #004 #006 #00A #00F \
               #02F #04F #06F #08F #0AF #0CF #0FF #0FE \
               #0FC #0FA #0F8 #0F6 #0F4 #0F2 #0F0 #2F0 \
               #4F0 #6F0 #8F0 #AF0 #CF0 #FE0 #FC0 #FA0 \
               #F80 #F60 #F40 #F20 #F00}
set v(color2) {#FFF #BBF #77F #33F #00F #07F #0BF #0FF #0FB #0F7 \
               #0F0 #3F0 #7F0 #BF0 #FF0 #FB0 #F70 #F30 #F00}

;# oremo-init.tcl�ɕۑ�����z��̃��X�g
set startup(arrayForInitFile) {bgmParam v f0 power startup dev uttTiming genParam estimate keys}
;# oremo-init.tcl�ɕۑ����Ȃ��L�[�̃��X�g
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

set startup(readRecList) 1    ;# 1=�N������reclist.txt��ǂ�
set startup(readTypeList) 1   ;# 1=�N������typelist.txt��ǂ�

set v(tempo) 120     ;# ���g���m�[���̃e���|(bpm)
set v(tempoMSec) [expr 60000.0 / $v(tempo)]  ;# ���g���m�[����1������̕b��
set v(playMetroStatus) 0  ;# 1=���݃��g���m�[���Đ���, 0=���ݍĐ����ĂȂ�
set v(clickWav) "$topdir/guideBGM/click.wav" ;# ���g���m�[���̉�
set v(bgmFile) "$topdir/guideBGM/F4-100bpm.wav" ;# �����^���pBGM
set v(bgmParamFile) "$topdir/guideBGM/F4-100bpm.txt" ;# �����^���pBGM
set v(setE) 1   ;# 1=�E�u�����N�l���t�@�C����������̑��Βl�ɂ���B-1=��blank����̑��Βl�ɂ���

array unset bgmParam
set bgmParam(autoRecStatus) 0

# ��s�����`�F�b�N�p�̐ݒ�
array unset uttTiming
set uttTiming(clickWav) "$topdir/guideBGM/click.wav"        ;# ���g���m�[���̉�
set uttTiming(tempo) 100                                    ;# �`�F�b�N���x[BPM]
set uttTimingMSec(tempo) [expr 60000.0 / $uttTiming(tempo)] ;# �`�F�b�N���x[msec]
set uttTiming(preCount) 3                 ;# �����Đ��O�Ƀ��g���m�[����炷��
set uttTiming(mix) 0.5                    ;# ���g���m�[���Ɖ����̍����䗦�B

# �A�������̃p�����[�^���������p�̐ݒ�
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
set genParam(avePPrev) 0   ;# ��O�̕��σp���[��ۑ�����
set genParam(autoAdjustRen2)    1
set genParam(autoAdjustRen2Opt) "-s1 200 -s2 10 -l 2048 -p 128 -m 30 -t 1.0 -d tools"
set genParam(autoAdjustRen2Pattern) "�� �� �� �� �� ��"

# �P�Ɖ��̃p�����[�^��������p�̐ݒ�
array unset estimate
set estimate(S)    1  ;# 1=�p�����[�^����������s��
set estimate(E)    1  ;# 1=�p�����[�^����������s��
set estimate(C)    1  ;# 1=�p�����[�^����������s��
set estimate(P)    1  ;# 1=�p�����[�^����������s��
set estimate(O)    1  ;# 1=�p�����[�^����������s��
set estimate(minC) 0.001  ;# �q�������̍ŏ��l(�q����=0��UTAU���G���[�ɂȂ�̂�h��)

array unset paDev
set paDev(devList) {none}     ;# PortAudio�ł̘^���f�o�C�X�I�����X�g
set paDev(devListMenu) ""     ;# PortAudio�ł̘^���f�o�C�X�I�����j���[�E�B�W�F�b�g
set paDev(outdevList) {none}  ;# PortAudio�ł̍Đ��f�o�C�X�I�����X�g
set paDev(outdevListMenu) ""  ;# PortAudio�ł̍Đ��f�o�C�X�I�����j���[�E�B�W�F�b�g
set paDev(recWav) "$topdir/tools/tmp.wav"    ;# oremo-recorder���o�͂���wav�t�@�C��
set paDev(useRequestRec)  0   ;# ���W�I�{�^���Ŏg���B1=PortAudio�^�����g������(�܂��g����Ƃ͌���Ȃ�)�B
set paDev(useRequestPlay) 0   ;# ���W�I�{�^���Ŏg���B1=PortAudio�Đ����g������(�܂��g����Ƃ͌���Ȃ�)�B
set paDev(useRec)         0     ;# 1=PortAudio�^�����g���BpaDev(useRequestRec)=1�Ŏg�p�\�̂Ƃ��ɂ̂�1�ɂ���
set paDev(usePlay)        0     ;# 1=PortAudio�Đ����g���BpaDev(useRequestRec)=1�Ŏg�p�\�̂Ƃ��ɂ̂�1�ɂ���
set paDev(sampleRate)   44100 ;# �T���v�����O���g��(Hz)
set paDev(sampleFormat) Int16 ;# �`���BInt16 Int24 Int32 Float32
set paDev(channel)      1     ;# �`�����l����
set paDev(bufferSize)   2048  ;# �o�b�t�@�T�C�Y
array unset paDevFp
set paDevFp(rec)  ""   ;# �^���c�[���Ɖ�b���邽�߂�fid�B""=�N�����Ă��Ȃ��B�����paDev()�̒��ɓ���Ă͂����Ȃ�(ioSettings�̃p�����[�^�o�b�N�A�b�v�ŕs��������邽��)
set paDevFp(play) ""   ;# �Đ��c�[���Ɖ�b���邽�߂�fid�B""=�N�����Ă��Ȃ��B�����paDev()�̒��ɓ���Ă͂����Ȃ�(ioSettings�̃p�����[�^�o�b�N�A�b�v�ŕs��������邽��)
set paDevFp(bgm)  ""   ;# �Đ��c�[���Ɖ�b���邽�߂�fid�B""=�N�����Ă��Ȃ��B�����paDev()�̒��ɓ���Ă͂����Ȃ�(ioSettings�̃p�����[�^�o�b�N�A�b�v�ŕs��������邽��)

# �V���[�g�J�b�g�L�[
array unset keys
array unset keys_bk

snack::sound snd   -channels Mono -rate $v(sampleRate) -fileformat WAV -encoding Lin16
snack::sound onsa  -channels Mono -rate $v(sampleRate)
snack::sound metro -channels Mono -rate $v(sampleRate)
snack::sound bgm   -channels Mono -rate $v(sampleRate)
snack::sound uttTiming(clickSnd)  -channels Mono -rate $v(sampleRate)

