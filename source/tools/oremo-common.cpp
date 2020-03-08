
#include "oremo-common.h"

//----------------------------------------------------------------
// �������B����=0�A���s=else
int init(SND *s, int mode){
	PaError err;

	if (s->status) stop(s);	// �����^�����ł���Β�~������
	Pa_Terminate();
	err = Pa_Initialize();
	if (err != paNoError){
		fprintf(stdout, "error: Pa_Initialize(), %s\n", Pa_GetErrorText(err));
		fflush(stdout);
		return 1;
	}

	memset(s, 0, sizeof(SND));
	s->fp                 = NULL;
	s->st                 = NULL;
	s->info.samplerate    = 44100;
	s->info.format        = SF_FORMAT_WAV | SF_FORMAT_PCM_16; // PCM_16=2 PCM_24=3 PCM_PCM_32=4 _FLOAT=6
	s->info.channels      = 1;
	s->sampleRate         = 44100;
	s->frameSize          = 1024;
	s->param.sampleFormat = paFloat32; // paInt16=8 paInt24=4 paInt32=2 paFloat32=1;
	s->param.channelCount = 1;
	s->param.device       = getDefaultDevice(mode);
	if (s->param.device < 0){
		fprintf(stdout, "error: can not find recording device\n");
		fflush(stdout);
		Pa_Terminate();
		return 1;
	}

	return 0;
}

//----------------------------------------------------------------
// �f�t�H���g�̃I�[�f�B�I�f�o�C�X�ԍ���Ԃ�
// ������Ȃ��ꍇ��-1��Ԃ�
int getDefaultDevice(int mode){
	PaDeviceIndex deviceNum;	// �f�o�C�X��
	const PaDeviceInfo *pDeviceInfo;
	PaDeviceIndex dID;

	deviceNum = Pa_GetDeviceCount();  // �o�^����Ă���f�o�C�X���𓾂�
	for (dID = 0; dID < deviceNum; dID++){
		pDeviceInfo = Pa_GetDeviceInfo(dID);
		if (mode == STATUS_REC){
			if (pDeviceInfo->maxInputChannels > 0) return dID;
		} else {
			if (pDeviceInfo->maxOutputChannels > 0) return dID;
		}
	}
	return -1;
}

//----------------------------------------------------------------
// �I�[�f�B�I�f�o�C�X�ꗗ��stdout�ɏo�͂���B��s��f�o�C�X�B
void getDevList(int mode){
	PaDeviceIndex deviceNum;	// �f�o�C�X��
	const PaDeviceInfo  *pDeviceInfo;
	const PaHostApiInfo *pHostApiInfo;
	PaDeviceIndex dID;

	Pa_Terminate();
	Pa_Initialize();
	deviceNum = Pa_GetDeviceCount();  // �o�^����Ă���f�o�C�X���𓾂�
	printf("resultBegin\n");
	for (dID = 0; dID < deviceNum; dID++){
		pDeviceInfo = Pa_GetDeviceInfo(dID);
		pHostApiInfo = Pa_GetHostApiInfo(pDeviceInfo->hostApi);
		//printf("%d: name=%s, api=%s, inMaxNum=%d, outMaxNum=%d defaultSR=%.1f\n",
		//	dID, pDeviceInfo->name, pHostApiInfo->name, pDeviceInfo->maxInputChannels, 
		//  pDeviceInfo->maxOutputChannels, pDeviceInfo->defaultSampleRate);
		if (mode == STATUS_REC){
			if (pDeviceInfo->maxInputChannels > 0)
				printf("%d: %s, API=%s\n", dID, pDeviceInfo->name, pHostApiInfo->name);
		} else {
			if (pDeviceInfo->maxOutputChannels > 0)
				printf("%d: %s, API=%s\n", dID, pDeviceInfo->name, pHostApiInfo->name);
		}
	}
	printf ("resultEnd\n");
	fflush(stdout);
}

//----------------------------------------------------------------
// �w�肵�������`���𗘗p�ł��邩�e�X�g����B���p�\=0�A�s�\=else
// show=1�Ȃ痘�p�\����"Success"�A�s�\���ɃG���[����stdout�ɑ���
int testDevice(SND *s, char *command, int show, int mode){
	PaError err;
	SND _s;

	copySND(&_s, s);
	// test [�f�o�C�X�ԍ� [�`��(bit��) [�`�����l���� [�T���v�����O���g�� [�t���[���T�C�Y]]]]]
	sscanf_s (command, "%*s %d%*d%d%d%d",
		&_s.param.device, &_s.param.channelCount, &_s.sampleRate, &_s.frameSize);

	if (mode == STATUS_REC)
		err = Pa_IsFormatSupported(&_s.param, NULL, _s.sampleRate);
	else
		err = Pa_IsFormatSupported(NULL, &_s.param, _s.sampleRate);
	if (show){
		printf("resultBegin\n%s\nresultEnd\n", Pa_GetErrorText(err));
		fflush(stdout);
	}
	return err;
}

//----------------------------------------------------------------
// libsndfile�̃t�@�C���`���ԍ���PortAudio�̔ԍ��ɕϊ�����
int sfFormat2pa(int format){
	switch (format & 0xff){
		case SF_FORMAT_PCM_16: return paInt16;
		case SF_FORMAT_PCM_24: return paInt24;
		case SF_FORMAT_PCM_32: return paInt32;
		default:			   return paFloat32;
	}
}

//----------------------------------------------------------------
// PortAudio�̔ԍ���libsndfile�̃t�@�C���`���ԍ��ɕϊ�����
int paFormat2sf(int format){
	switch (format){
		case paInt16: return SF_FORMAT_PCM_16;
		case paInt24: return SF_FORMAT_PCM_24;
		case paInt32: return SF_FORMAT_PCM_32;
		default:	  return SF_FORMAT_FLOAT;
	}
}

//----------------------------------------------------------------
// �\����SND�̈ꕔ���R�s�[����
void copySND(SND *dst, SND *src){
	*dst = *src;
}

//----------------------------------------------------------------
// status�̓��e���o�͂���
void status(SND *s){
	printf("resultBegin\n%d\nresultEnd\n", s->status);
	fflush(stdout);
}

//----------------------------------------------------------------
// �^��/�Đ��I���B����=0�A���s=1�Bstdout�ɂ͐���������Success�ƕԂ��B���s�Ȃ�G���[���o�́B
int stop(SND *s){
	PaError err;

	if (s->status == STATUS_STOP){						// ��~�ςȂ�I��
		printf("resultBegin\nerror: already stopped\nresultEnd\n");
		fflush(stdout);
		return 0;
	}

	err = Pa_StopStream(s->st);
	if (err != paNoError){
		printf("resultBegin\nerror: Pa_StopStream(), %s\nresultEnd\n", Pa_GetErrorText(err));
		fflush(stdout);
		return 1;
	}

	err = Pa_CloseStream(s->st);
	if (err != paNoError){
		printf("resultBegin\nerror: Pa_CloseStream(), %s\nresultEnd\n", Pa_GetErrorText(err));
		fflush(stdout);
		return 1;
	}
	if (s->status == STATUS_REC && sf_close(s->fp)){
		printf("resultBegin\nerror: File closing error.\nresultEnd\n");
		fflush(stdout);
		return 1;
	}

	printf("resultBegin\nSuccess\nresultEnd\n");
	fflush(stdout);
	s->status = STATUS_STOP;	// �t���O���~���ɂ���
	return 0;
}

//----------------------------------------------------------------
// �I��
void myExit(SND *s){
	if (s->status) stop(s);	// �����^��/�Đ����ł���Β�~������
	Pa_Terminate();
	exit(0);
}

//----------------------------------------------------------------
// �o�[�W�����\��
void version(char *appname, char *version){
	printf("resultBegin\n%s ver. %s\nresultEnd\n", appname, version);
	fflush(stdout);
}