#include <stdio.h>
#include <stdlib.h>
#include <tchar.h>
#include <string.h>
#include <direct.h>		// _getcwd()�p�B
#include <Windows.h>	// Sleep()�p�B
#include <portaudio.h>
#include <sndfile.h>

#define STATUS_STOP 0	// ��~��
#define STATUS_REC  1	// �^����
#define STATUS_PLAY 2	// �Đ���
#define sec2frame(sec, snd)  (int)(sec * snd->sampleRate)

//----------------------------------------------------------------
typedef struct {
	// ���libsndfile�p
	SNDFILE *fp;
	SF_INFO info;
	int status;				// 0=��~�A1=�^�����A2=�Đ���
	unsigned long playFrame;	// �Đ��ς݂̃t���[����
	unsigned long endFrame;		// �Đ��I��������t���[�����B0�Ȃ�t�@�C�������܂ŁB

	// ���PortAudio�p
	PaStream *st;
	PaStreamParameters param;
	int sampleRate;
	unsigned long frameSize;
} SND;

//----------------------------------------------------------------
// �v���g�^�C�v�錾
int init(SND *, int);
int getDefaultDevice(int);
void getDevList(int);
int testDevice(SND *, char *, int, int);
void copySND(SND *, SND *);
int stop(SND *s);
void myExit(SND *);
void status(SND *);
int sfFormat2pa(int);
int paFormat2sf(int);
void version(char *, char *);