#include <stdio.h>
#include <stdlib.h>
#include <tchar.h>
#include <string.h>
#include <direct.h>		// _getcwd()用。
#include <Windows.h>	// Sleep()用。
#include <portaudio.h>
#include <sndfile.h>

#define STATUS_STOP 0	// 停止中
#define STATUS_REC  1	// 録音中
#define STATUS_PLAY 2	// 再生中
#define sec2frame(sec, snd)  (int)(sec * snd->sampleRate)

//----------------------------------------------------------------
typedef struct {
	// 主にlibsndfile用
	SNDFILE *fp;
	SF_INFO info;
	int status;				// 0=停止、1=録音中、2=再生中
	unsigned long playFrame;	// 再生済みのフレーム数
	unsigned long endFrame;		// 再生終了させるフレーム数。0ならファイル末尾まで。

	// 主にPortAudio用
	PaStream *st;
	PaStreamParameters param;
	int sampleRate;
	unsigned long frameSize;
} SND;

//----------------------------------------------------------------
// プロトタイプ宣言
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