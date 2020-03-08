// �W�����͂���R�}���h��ǂ݁A�w�肵���t�@�C�����Đ�����
// �R�}���h�͈ȉ��̂��̂����s�ł���
// list ... ���̓f�o�C�X�ꗗ��\������
// set  [�f�o�C�X�ԍ� [�`��(bit��(1,2,4,8)) [�`�����l���� [�T���v�����O���g��]]]]
//       ... �g�p�f�o�C�X���w�肷��B�Đ��̏ꍇ�Awav�R�}���h�̌��set���g���Ɛ���ɍĐ�����Ȃ��̂Œ���
// test [�f�o�C�X�ԍ� [�`��(bit��(1,2,4,8)) [�`�����l���� [�T���v�����O���g��]]]] ... �f�o�C�X���e�X�g����
// wav   ... �w�肵��wav�t�@�C����ǂݍ��ށB�w�b�_�ɍ��킹��PortAudio�̐ݒ��ύX����
// play  ... �Đ��J�n
// stop  ... �^����~
// reset ... PortAudio�����Z�b�g����
// ver   ... �o�[�W������\������
// exit  ... �I��

// stdout�Ɍ��ʕ��𑗂�Ƃ��͕K���擪�s��resultBegin�A�ŏI�s��resultEnd�ɂ��Afflush(stdout)���邱��
// �����PortAudio���̃��C�u�������Ӑ}���Ȃ��������stdout�ɏo�͂����Ƃ��ɃX���[�ł���悤�ɂ��邽��

// �Đ���paFloat32�ōs����B

// win32�p�v���W�F�N�g�ŋ�v���W�F�N�g���쐬���A�v���p�e�B�ňȉ��̂悤�ɐݒ肵���B
// �ǉ��̃C���N���[�hdir��Visual Studio 2010��Projects\portaudio\include��ǉ�
// �ǉ��̃C���N���[�hdir��c:\Program Files (x86)\libsndfile\include��ǉ�
// �ǉ��̃��C�u����dir��Visual Studio 2010��Projects\portaudio\build\msvc\Win32\Release��ǉ�
// �ǉ��̃��C�u����dir��C:\Program Files (x86)\libsndfile\lib��ǉ�
// �����J�A���́A�ǉ��̈ˑ��t�@�C����portaudio_x86.lib;libsndfile-1.lib;��ǉ�
// Release��Debug����portaudio/build/msvc/Win32/Release/portaudio_x86.dll���R�s�[
// Release��Debug����Program Files (x86)/libsndfile/bin/libsndfile-1.dll���R�s�[
// �S�ʁA�����Z�b�g���u�}���`�o�C�g�����Z�b�g���g�p����v�ɂ���
// C/C++�A�R�[�h�����A�����^�C�����C�u������ /MT�ɂ���

// koko, play�@�͈͎w��Đ�
// koko, play  play���ł�stop����replay�����������ǂ�����

#define  APPNAME  "oremo-player"
#define  VERSION  "1.0"
#define  outWavName "tmp.wav"

#include "oremo-common.h"

//----------------------------------------------------------------
// �v���g�^�C�v�錾
int playStart(SND *, char *);
int setOutDevice(SND *, char *, int);
int playCallback(const void *, void *, unsigned long,
	const PaStreamCallbackTimeInfo*, PaStreamCallbackFlags, void *);
int openWav(SND *, char *);
int closeWav(SND *, int);

//----------------------------------------------------------------
// �{��
int _tmain(int argc, _TCHAR* argv[])
{
	char command[_MAX_PATH];
	SND play;

	play.status = STATUS_STOP;
	init(&play, STATUS_PLAY);

	while (1){
		if (fgets(command, _MAX_PATH, stdin) == NULL){
			myExit(&play);
			break;
		}
		if (command[strlen(command)-1] != '\n')
			while (getchar() != '\n');

		// �R�}���h���s
		// play [�J�n����(sec) [�I������(sec)]] �܂��� playF [�J�n����(frame) [�I������(frame)]]
		if (command[0] == 'p')      playStart(&play, command);
		else if (strcmp(command, "stop\n" ) == 0) stop (&play);
		else if (strcmp(command, "list\n") == 0)  getDevList(STATUS_PLAY);
		// set  [�f�o�C�X�ԍ� [�`��(bit��(1,2,4,8)) [�`�����l���� [�T���v�����O���g�� [�t���[���T�C�Y]]]]]
		else if (command[0] == 's' && command[1] == 'e') setOutDevice(&play, command, 1);
		// test [�f�o�C�X�ԍ� [�`��(bit��(1,2,4,8)) [�`�����l���� [�T���v�����O���g�� [�t���[���T�C�Y]]]]]
		else if (command[0] == 't')               testDevice(&play, command, 1, STATUS_PLAY);
		else if (command[0] == 'w')               openWav(&play, command);
		else if (strcmp(command, "stat\n" ) == 0) status(&play);
		else if (strcmp(command, "ver\n")  == 0)  version(APPNAME, VERSION);
		else if (strcmp(command, "reset\n") == 0) init(&play, STATUS_PLAY);
		else if (strcmp(command, "exit\n")  == 0) myExit(&play);
	}
}

//----------------------------------------------------------------
// wav�t�@�C�����J���B����=0�A���s=1�B
// stdout�ɂ͐���������Success�ƕԂ��B���s�Ȃ�G���[���o�́B
int openWav(SND *play, char *command){
	int intErr;
	char inWav[_MAX_PATH];
	char setCom[_MAX_PATH];

	// wav �Đ�wav�t�@�C����
	intErr = sscanf_s (command, "%*s %s", inWav, _MAX_PATH);

	// wav�t�@�C�����J��
	if (play->fp != NULL) closeWav(play, 0);
	memset(&(play->info), 0, sizeof(SF_INFO));
	play->fp = sf_open(inWav, SFM_READ, &(play->info));
	if (play->fp == NULL){
		printf("resultBegin\nerror: can not open wav file (%s)\nresultEnd\n", inWav);
		fflush(stdout);
		return 1;
	}

	// wav�t�H�[�}�b�g�ɍ��킹��PortAudio�̐ݒ��ύX����
	sprintf_s(setCom, "set %d %d %d %d\n", 
		play->param.device, sfFormat2pa(play->info.format),
		play->info.channels, play->info.samplerate);
	setOutDevice(play, setCom, 0);

	printf("resultBegin\nSuccess\nresultEnd\n");
	fflush(stdout);
	return 0;
}

//----------------------------------------------------------------
// wav�t�@�C�������B����=0�A���s=1�B
// stdout�ɂ͐���������Success�ƕԂ��B���s�Ȃ�G���[���o�́B
int closeWav(SND *play, int show){
	if (play->fp == NULL){
		if (show){
			printf("resultBegin\nerror: wav file is already closed\nresultEnd\n");
			fflush(stdout);
		}
		return 1;
	}

	if (sf_close(play->fp)){
		if (show){
			printf("resultBegin\nerror: file close error.\nresultEnd\n");
			fflush(stdout);
		}
		return 1;
	}

	if (show){
		printf("resultBegin\nSuccess\nresultEnd\n");
		fflush(stdout);
	}
	return 0;
}

//----------------------------------------------------------------
// �Đ��R�[���o�b�N
int playCallback(const void *inputBuffer, void *outputBuffer,
	unsigned long framesPerBuffer, const PaStreamCallbackTimeInfo* timeInfo,
	PaStreamCallbackFlags statusFlags, void *userData){
	SND *play;
	
	play = (SND *)userData;
	memset(outputBuffer, 0, framesPerBuffer * play->info.channels * sizeof(float));

	// �I���n�_�܂ōĐ������Ƃ�
	if (! play->fp || play->endFrame > 0 && play->playFrame >= play->endFrame){
		play->status = STATUS_STOP;
		return paComplete;
	}

	if (sf_readf_float(play->fp, (float *)outputBuffer, framesPerBuffer) <= 0){
		// �t�@�C�������܂ōĐ������Ƃ�
		play->status = STATUS_STOP;
		return paComplete;
	}
	play->playFrame += framesPerBuffer;
	return paContinue;
}

//----------------------------------------------------------------
// �Đ��J�n�B����=0�A���s=1�Bstdout�ɂ͐���������Success�ƕԂ��B���s�Ȃ�G���[���o�́B
int playStart(SND *play, char *command){
	PaError err;
	int intErr;
	double start = 0.0, end = 0;

	if (play->status){	// ���ɍĐ����Ȃ��~������
		err = Pa_CloseStream(play->st);
		if (err != paNoError){
			printf("resultBegin\nerror: Pa_CloseStream(), %s\nresultEnd\n", Pa_GetErrorText(err));
			fflush(stdout);
			return 1;
		}
	}
	if (command[4] != 'F'){
		// play [�J�n����(sec) [�I������(sec)]]
		intErr = sscanf_s (command, "%*s %lf %lf", &start, &end);
		play->playFrame = sec2frame(start, play);
		play->endFrame  = (end > 0) ? sec2frame(end, play) : 0;
	} else {
		intErr = sscanf_s (command, "%*s %ld %ld", &play->playFrame, &play->endFrame);
		if (play->endFrame <= 0) play->endFrame = 0;
	}

	//fp���t�@�C���擪�ɒu��
	if (play->fp == NULL || sf_seek(play->fp, play->playFrame, SEEK_SET) < 0){
		printf("resultBegin\nerror: file open error\nresultEnd\n");
		fflush(stdout);
		return 1;
	}
	
	// �����f�o�C�X���J���čĐ��J�n
	err = Pa_OpenStream(&(play->st), NULL, &(play->param), play->sampleRate, 
		play->frameSize, paNoFlag, playCallback, play);
	if (err != paNoError){
		printf("resultBegin\nerror: Pa_OpenStream(), %s\nresultEnd\n", Pa_GetErrorText(err));
		fflush(stdout);
		return 1;
	}
	err = Pa_StartStream(play->st);
	if (err != paNoError){
		printf ("resultBegin\nerror: Pa_StartStream(), %s\nresultEnd\n", Pa_GetErrorText(err));
		fflush(stdout);
		return 1;
	}
	printf("resultBegin\nSuccess\nresultEnd\n");
	fflush(stdout);
	play->status = STATUS_PLAY;		// ��Ԃ��Đ����ɂ���
	return 0;
}

//----------------------------------------------------------------
// �Đ��f�o�C�X��`���Ȃǂ��w�肷��B����=0�A���s=1
// show=1�Ȃ痘�p�\����"Success"�A�s�\���ɃG���[����stdout�ɑ���
int setOutDevice(SND *play, char *command, int show){
	PaError err;
	SND _play;
	int intErr;
	int format;		// wav�t�@�C���̕ۑ��t�H�[�}�b�g�B�ԍ���PortAudio�̂��̂��g���B(��₱����)

	// set [�f�o�C�X�ԍ� [�`��(bit��) [�`�����l���� [�T���v�����O���g��]]]]
	// �w�肳��Ȃ��������������ɂ͌���̐ݒ��p����B�����������ꍇ�͌��݂̐ݒ��\������
	copySND(&_play, play);
	_play.param.sampleFormat = paFloat32;		// �Đ��`����Float32�ɌŒ�
	intErr = sscanf_s (command, "%*s %d%d%d%d%d",
		&_play.param.device, &format, 
		&_play.param.channelCount, &_play.sampleRate, &_play.frameSize);
	// �R�}���h��"set"�݂̂̂Ƃ��͌���̐ݒ��Ԃ�
	if (intErr == 0){
		printf("resultBegin\n");
		printf("dID=%d, format=%d, channel=%d, sampleRate=%d\n",
			play->param.device, sfFormat2pa(play->info.format),
			play->param.channelCount, play->sampleRate);
		printf("resultEnd\n");
		fflush(stdout);
		return 1;
	}

	err = testDevice(&_play, command, 0, STATUS_PLAY);
	if (show){
		printf("resultBegin\n");
		printf("%s\n", Pa_GetErrorText(err));
		printf("resultEnd\n");
		fflush(stdout);
	}
	if (err != paNoError){
		return 1;
	}

	copySND(play, &_play);
	//play->info.samplerate = _play.sampleRate;
	//play->info.channels   = _play.param.channelCount;
	//play->info.format     = SF_FORMAT_WAV | paFormat2sf(format);

	return 0;
}
