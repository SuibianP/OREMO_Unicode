// �W�����͂���R�}���h��ǂ݁A�^������ outWavName(tmp.wav)�ɕۑ�����
// �R�}���h�͈ȉ��̂��̂����s�ł���
// list ... ���̓f�o�C�X�ꗗ��\������
// set  [�f�o�C�X�ԍ� [�`��(bit��(1,2,4,8)) [�`�����l���� [�T���v�����O���g��]]]] ... �g�p�f�o�C�X���w�肷��
// test [�f�o�C�X�ԍ� [�`��(bit��(1,2,4,8)) [�`�����l���� [�T���v�����O���g��]]]] ... �f�o�C�X���e�X�g����
// rec   ... �^���J�n
// stop  ... �^����~
// reset ... PortAudio�����Z�b�g����
// ver   ... �o�[�W������\������
// exit  ... �I��

// stdout�Ɍ��ʕ��𑗂�Ƃ��͕K���擪�s��resultBegin�A�ŏI�s��resultEnd�ɂ��Afflush(stdout)���邱��
// �����PortAudio���̃��C�u�������Ӑ}���Ȃ��������stdout�ɏo�͂����Ƃ��ɃX���[�ł���悤�ɂ��邽��

// �^����paFloat32�ōs���A�ۑ�����16,24,32bit,float�̂����ꂩ�ɕϊ�����B

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

#define  APPNAME  "oremo-recorder"
#define  VERSION  "1.0"
#define  outWavName "tmp.wav"

#include "../oremo-player/oremo-common.h"

//----------------------------------------------------------------
// �v���g�^�C�v�錾
int recStart(SND *, char *);
int setInDevice(SND *, char *, int);
int recCallback(const void *, void *, unsigned long,
	const PaStreamCallbackTimeInfo*, PaStreamCallbackFlags, void *);
void makeResultFilename(char *, _TCHAR *);
int sfFormat2pa(int);
int paFormat2sf(int);

//----------------------------------------------------------------
// �{��
int _tmain(int argc, _TCHAR* argv[])
{
	char command[_MAX_PATH];
	SND rec;
	char outWav[_MAX_PATH];

	makeResultFilename(outWav, argv[0]);
	rec.status = STATUS_STOP;
	init(&rec, STATUS_REC);

	while (1){
		if (fgets(command, _MAX_PATH, stdin) == NULL){
			myExit(&rec);
			break;
		}
		if (command[strlen(command)-1] != '\n')
			while (getchar() != '\n');

		// �R�}���h���s
		if (strcmp(command, "rec\n" ) == 0)       recStart(&rec, outWav);
		else if (strcmp(command, "stop\n" ) == 0) stop (&rec);
		else if (strcmp(command, "list\n") == 0)  getDevList(STATUS_REC);
		// set  [�f�o�C�X�ԍ� [�`��(bit��(1,2,4,8)) [�`�����l���� [�T���v�����O���g�� [�t���[���T�C�Y]]]]]
		else if (command[0] == 's' && command[1] == 'e') setInDevice(&rec, command, 1);
		// test [�f�o�C�X�ԍ� [�`��(bit��(1,2,4,8)) [�`�����l���� [�T���v�����O���g�� [�t���[���T�C�Y]]]]]
		else if (command[0] == 't')               testDevice(&rec, command, 1, STATUS_REC);
		else if (strcmp(command, "stat\n" ) == 0) status(&rec);
		else if (strcmp(command, "ver\n")  == 0)  version(APPNAME, VERSION);
		else if (strcmp(command, "reset\n") == 0) init(&rec, STATUS_REC);
		else if (strcmp(command, "exit\n")  == 0) myExit(&rec);
	}
}

//----------------------------------------------------------------
// �^���R�[���o�b�N
int recCallback(const void *inputBuffer, void *outputBuffer,
	unsigned long framesPerBuffer, const PaStreamCallbackTimeInfo* timeInfo,
	PaStreamCallbackFlags statusFlags, void *userData){
	SND *rec;
	rec = (SND *)userData;

	sf_write_float(rec->fp, (float *)inputBuffer, framesPerBuffer * rec->info.channels);
	//memset((void *)inputBuffer, 0, framesPerBuffer * rec->info.channels * sizeof(float));
	return 0;
}

//----------------------------------------------------------------
// �^���J�n�B����=0�A���s=1�Bstdout�ɂ͐���������Success�ƕԂ��B���s�Ȃ�G���[���o�́B
int recStart(SND *rec, char *outWav){
	PaError err;

	if (rec->status){	// ���ɘ^�����Ȃ�I��
		printf("resultBegin\nerror: already recording now\nresultEnd\n");
		fflush(stdout);
		return 0;
	}

	// �ۑ�wav�t�@�C�����J��
	rec->fp = sf_open(outWav, SFM_WRITE, &(rec->info));
	if (rec->fp == NULL){
		printf("resultBegin\nerror: can not start recording\nresultEnd\n");
		fflush(stdout);
		return 1;
	}

	// �����f�o�C�X���J���Ę^���J�n
	err = Pa_OpenStream(&(rec->st), &(rec->param), NULL, rec->sampleRate, 
		rec->frameSize, paNoFlag, recCallback, rec);
	if (err != paNoError){
		printf("resultBegin\nerror: Pa_OpenStream(), %s\nresultEnd\n", Pa_GetErrorText(err));
		fflush(stdout);
		return 1;
	}
	err = Pa_StartStream(rec->st);
	if (err != paNoError){
		printf ("resultBegin\nerror: Pa_StartStream(), %s\nresultEnd\n", Pa_GetErrorText(err));
		fflush(stdout);
		return 1;
	}
	printf("resultBegin\nSuccess\nresultEnd\n");
	fflush(stdout);
	rec->status = STATUS_REC;		// ��Ԃ�^�����ɂ���
	return 0;
}

//----------------------------------------------------------------
// �^���f�o�C�X��`���Ȃǂ��w�肷��B����=0�A���s=1
// show=1�Ȃ痘�p�\����"Success"�A�s�\���ɃG���[����stdout�ɑ���
int setInDevice(SND *rec, char *command, int show){
	PaError err;
	SND _rec;
	int intErr;
	int format;		// wav�t�@�C���̕ۑ��t�H�[�}�b�g�B�ԍ���PortAudio�̂��̂��g���B(��₱����)

	// set [�f�o�C�X�ԍ� [�`��(bit��) [�`�����l���� [�T���v�����O���g�� [�t���[���T�C�Y]]]]]
	// �w�肳��Ȃ��������������ɂ͌���̐ݒ��p����B�����������ꍇ�͌��݂̐ݒ��\������
	copySND(&_rec, rec);
	_rec.param.sampleFormat = paFloat32;		// �^���`����Float32�ɌŒ�
	intErr = sscanf_s (command, "%*s %d%d%d%d%d",
		&_rec.param.device, &format, 
		&_rec.param.channelCount, &_rec.sampleRate, &_rec.frameSize);
	// �R�}���h��"set"�݂̂̂Ƃ��͌���̐ݒ��Ԃ�
	if (intErr == 0){
		printf("resultBegin\n");
		printf("dID=%d, format=%d, channel=%d, sampleRate=%d\n",
			rec->param.device, sfFormat2pa(rec->info.format),
			rec->param.channelCount, rec->sampleRate);
		printf("resultEnd\n");
		fflush(stdout);
		return 1;
	}

	err = testDevice(&_rec, command, 0, STATUS_REC);
	if (show){
		printf("resultBegin\n");
		printf("%s\n", Pa_GetErrorText(err));
		printf("resultEnd\n");
		fflush(stdout);
	}
	if (err != paNoError){
		return 1;
	}

	copySND(rec, &_rec);
	rec->info.samplerate = _rec.sampleRate;
	rec->info.channels   = _rec.param.channelCount;
	rec->info.format     = SF_FORMAT_WAV | paFormat2sf(format);

	return 0;
}

//----------------------------------------------------------------
// �o��wav�t�@�C�����i�t���p�X�j�����߂�
void makeResultFilename(char *result, _TCHAR *str){
	TCHAR szFull[_MAX_PATH];    // exe�̃t���p�X(exe���܂�)
	TCHAR szDrive[_MAX_DRIVE];  // exe�̃h���C�u
	TCHAR szDir[_MAX_DIR];      // exe�̃f�B���N�g��
	TCHAR fpath[_MAX_PATH];

	GetModuleFileName(NULL, szFull, sizeof(szFull) / sizeof(TCHAR));	// exe�̃t���p�X�𓾂�
	_tsplitpath_s(szFull, szDrive, _MAX_DRIVE, szDir, _MAX_DIR, NULL, NULL, NULL, NULL);	// �t���p�X���h���C�u�����ɕ���
	_tmakepath_s(fpath, _MAX_PATH, szDrive, szDir, NULL, NULL);		// �t���p�X(exe���܂܂�)�𓾂�
	strcpy_s(result, _MAX_PATH, fpath);
	strcat_s(result, _MAX_PATH, outWavName);
}
