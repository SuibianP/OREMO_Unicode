// win32用プロジェクトでの初期設定
// 追加のインクルードdirにVisual Studio 2010のProjects\portaudio\includeを追加
// 追加のインクルードdirにc:\Program Files (x86)\libsndfile\includeを追加
// 追加のライブラリdirにVisual Studio 2010のProjects\portaudio\build\msvc\Win32\Releaseを追加
// リンカ、入力、追加の依存ファイルに、portaudio_x86.libを追加
// ReleaseとDebug下にportaudio/build/msvc/Win32/Release/portaudio_x86.dllをコピー
// ReleaseとDebug下にProgram Files (x86)/libsndfile/bin/libsndfile-1.dllをコピー

#include <stdio.h>
#include <stdlib.h>
#include <tchar.h>
#include <string.h>
#include <direct.h>		// _getcwd()用。
#include <Windows.h>	// Sleep()用。
#include <portaudio.h>
#include <sndfile.h>
#define  commandN 255
#define  outWavName "tmp.wav"

//----------------------------------------------------------------
typedef struct {
	SNDFILE *fp;
	SF_INFO info;
} SND;
typedef struct {
	PaStream *st;
	PaStreamParameters param;
	int sampleRate;
	unsigned long frameSize;
} PA;

//----------------------------------------------------------------
// プロトタイプ宣言
int init(SND *, PA *, char *);
void getInDevList();
int getDefaultInDevice();
int recStart(SND *, PA *, char *);
int recStop(SND *, PA *);
int setInDevice(SND *, PA *, char *);
int testInDevice(SND *, PA *, char *, int);
void myExit(PA paRec);
int recCallback(const void *, void *, unsigned long,
	const PaStreamCallbackTimeInfo*, PaStreamCallbackFlags, void *);
void copyPA(PA *, PA*);

//----------------------------------------------------------------
// 初期化。成功=0、失敗=else
int init(SND *rec, PA *paRec, char *outWav){
	PaError err;

	Pa_Terminate();
	err = Pa_Initialize();
	if (err != paNoError){
		fprintf(stderr, "error: Pa_Initialize(), %s\n", Pa_GetErrorText(err));
		return 1;
	}

	_getcwd(outWav, 512 - strlen(outWavName) - 1);
	strcat_s(outWav, 512, "\\");
	strcat_s(outWav, 512, outWavName);

	memset(&(rec->info), 0, sizeof(SF_INFO));
	rec->fp              = NULL;
	rec->info.samplerate = 44100;
	rec->info.format     = SF_FORMAT_WAV | SF_FORMAT_PCM_16; // SF_FORMAT_PCM_24 SF_FORMAT_PCM_32 SF_FORMAT_FLOAT
	rec->info.channels   = 1;
	memset(&(paRec->param), 0, sizeof(PaStreamParameters));
	paRec->st                 = NULL;
	paRec->sampleRate         = 44100;
	paRec->frameSize          = 1024;
	paRec->param.sampleFormat = paFloat32; // paInt16=8 paInt24=4 paInt32=2 paFloat32=1;
	paRec->param.channelCount = 1;
	paRec->param.device       = getDefaultInDevice();
	if (paRec->param.device < 0){
		fprintf(stderr, "error: can not find recording device\n");
		Pa_Terminate();
		return 1;
	}

	return 0;
}

//----------------------------------------------------------------
// 本文
int _tmain(int argc, _TCHAR* argv[])
{
	char command[commandN];
	SND rec;
	PA paRec;
	char outWav[512];

	init(&rec, &paRec, outWav);

	while (1){
		fgets(command, commandN, stdin);
		if (command[strlen(command)-1] != '\n')
			while (getchar() != '\n');

		// コマンド実行
		if (strcmp(command, "rec\n" ) == 0)       recStart(&rec, &paRec, outWav);
		else if (strcmp(command, "end\n" ) == 0)  recStop(&rec, &paRec);
		else if (strcmp(command, "list\n") == 0)  getInDevList();
		// set  [デバイス番号 [形式(bit等(1,2,4,8)) [チャンネル数 [サンプリング周波数]]]]
		else if (command[0] == 's')               setInDevice(&rec, &paRec, command);
		// test [デバイス番号 [形式(bit等(1,2,4,8)) [チャンネル数 [サンプリング周波数]]]]
		else if (command[0] == 't')               testInDevice(&rec, &paRec, command, 1);
		else if (strcmp(command, "reset\n") == 0) init(&rec, &paRec, outWav);
		else if (strcmp(command, "exit\n")  == 0) myExit(paRec);
	}
}

//----------------------------------------------------------------
// 録音コールバック
int recCallback(const void *inputBuffer, void *outputBuffer,
	unsigned long framesPerBuffer, const PaStreamCallbackTimeInfo* timeInfo,
	PaStreamCallbackFlags statusFlags, void *userData){
	SND *rec;
	rec = (SND *)userData;

	//koko↓paがfloatの場合だと思う。
	sf_write_float(rec->fp, (float *)inputBuffer, framesPerBuffer * rec->info.channels);
	//memset((void *)inputBuffer, 0, framesPerBuffer * rec->info.channels * sizeof(float));
	return 0;
}

//----------------------------------------------------------------
// 録音開始。成功=0、失敗=1
int recStart(SND *rec, PA *paRec, char *outWav){
	PaError err;

	// 保存wavファイルを開く
	rec->fp = sf_open(outWav, SFM_WRITE, &(rec->info));
	if (rec->fp == NULL){
		fprintf(stderr, "error: can not start recording\n");
		return 1;
	}

	// 音声デバイスを開いて録音開始
	err = Pa_OpenStream(&(paRec->st), &(paRec->param), NULL, paRec->sampleRate, 
		paRec->frameSize, paNoFlag, recCallback, rec);
	if (err != paNoError){
		fprintf(stderr, "error: Pa_OpenStream(), %s\n", Pa_GetErrorText(err));
		return 1;
	}
	// fprintf(stderr, "dev=%d, time=%f\n", paRec->param.device, Pa_GetStreamTime(paRec->st));fflush(stderr);//koko
	err = Pa_StartStream(paRec->st);
	if (err != paNoError){
		fprintf (stderr, "error: Pa_StartStream(), %s\n", Pa_GetErrorText(err));
		return 1;
	}

	return 0;
}

//----------------------------------------------------------------
// 録音終了。成功=0、失敗=1
int recStop(SND *rec, PA *paRec){
	PaError err;

	//fprintf(stderr, "dev=%d, time=%f\n", paRec->param.device, Pa_GetStreamTime(paRec->st));fflush(stderr);//koko
	err = Pa_CloseStream(paRec->st);
	if (err != paNoError){
		fprintf (stderr, "error: Pa_CloseStream(), %s\n", Pa_GetErrorText(err));
		return 1;
	}
	sf_close(rec->fp);

	return 0;
}

//----------------------------------------------------------------
// オーディオデバイスの情報を得る
void getInDevList(){
	PaDeviceIndex deviceNum;	// デバイス数
	const PaDeviceInfo  *pDeviceInfo;
	const PaHostApiInfo *pHostApiInfo;
	PaDeviceIndex dID;

	Pa_Terminate();
	Pa_Initialize();
	deviceNum = Pa_GetDeviceCount();  // 登録されているデバイス数を得る
	for (dID = 0; dID < deviceNum; dID++){
		pDeviceInfo = Pa_GetDeviceInfo(dID);
		pHostApiInfo = Pa_GetHostApiInfo(pDeviceInfo->hostApi);
		if (pDeviceInfo->maxInputChannels > 0){
			//printf("%d: name=%s, api=%s, inMaxNum=%d, outMaxNum=%d defaultSR=%.1f\n",
			//	dID, pDeviceInfo->name, pHostApiInfo->name, pDeviceInfo->maxInputChannels, 
			//  pDeviceInfo->maxOutputChannels, pDeviceInfo->defaultSampleRate);
			printf("%d: %s, API=%s\n", dID, pDeviceInfo->name, pHostApiInfo->name);
		}
	}
	fflush(stdout);
}

//----------------------------------------------------------------
// 録音デバイスや形式などを指定する。成功=0、失敗=1
int setInDevice(SND *rec, PA *paRec, char *command){
	PaError err;
	PA _paRec;
	int intErr;

	// set [デバイス番号 [形式(bit等) [チャンネル数 [サンプリング周波数]]]]
	// 指定されなかった引数部分には現状の設定を用いる。引数が無い場合は現在の設定を表示する
	copyPA(&_paRec, paRec);
	intErr = sscanf_s (command, "%*s %d %d %d %d",
		&_paRec.param.device, &_paRec.param.sampleFormat, 
		&_paRec.param.channelCount, &_paRec.sampleRate);
	if (intErr == 0){					// 現状の設定を返す
		printf("dID=%d, format=%d, channel=%d, sampleRate=%d\n",
			paRec->param.device, paRec->param.sampleFormat,
			paRec->param.channelCount, paRec->sampleRate);
		fflush(stdout);
		return 1;
	}

	err = testInDevice(rec, paRec, command, 0);
	if (err != paNoError){
		return 1;
	}

	copyPA(paRec, &_paRec);
	rec->info.samplerate = _paRec.sampleRate;
	rec->info.channels   = _paRec.param.channelCount;
	switch (_paRec.param.sampleFormat){
		case paInt16 :		rec->info.format = SF_FORMAT_WAV | SF_FORMAT_PCM_16;
							break;
		case paInt24 :		rec->info.format = SF_FORMAT_WAV | SF_FORMAT_PCM_24;
							break;
		case paInt32 :		rec->info.format = SF_FORMAT_WAV | SF_FORMAT_PCM_32;
							break;
		case paFloat32 :	rec->info.format = SF_FORMAT_WAV | SF_FORMAT_FLOAT;
							break;
	}

	return 0;
}

//----------------------------------------------------------------
// 指定した音声形式を利用できるかテストする。利用可能=0、不可能=else
// show=1なら利用可能時に"Success"、不可能事にエラー文をstdoutに送る
int testInDevice(SND *rec, PA *paRec, char *command, int show){
	PaError err;
	PA _paRec;
	int intErr;

	copyPA(&_paRec, paRec);
	// test [デバイス番号 [形式(bit等) [チャンネル数 [サンプリング周波数]]]]
	intErr = sscanf_s (command, "%*s %d %d %d %d",
		&_paRec.param.device, &_paRec.param.sampleFormat, &_paRec.param.channelCount, &_paRec.sampleRate);

	err = Pa_IsFormatSupported(&_paRec.param, NULL, _paRec.sampleRate);
	if (show){
		printf("%s\n", Pa_GetErrorText(err));
		fflush(stdout);
	}
	return err;
}

//----------------------------------------------------------------
// 構造体PA内容の一部をコピーする
void copyPA(PA *dst, PA*src){
	memset(&(dst->param), 0, sizeof(PaStreamParameters));
	dst->st                 = src->st;
	dst->sampleRate         = src->sampleRate;
	dst->frameSize          = src->frameSize;
	dst->param.device       = src->param.device;
	dst->param.sampleFormat = src->param.sampleFormat;
	dst->param.channelCount = src->param.channelCount;
}

//----------------------------------------------------------------
// デフォルトの録音オーディオデバイス番号を返す
// 見つからない場合は-1を返す
int getDefaultInDevice(){
	PaDeviceIndex deviceNum;	// デバイス数
	const PaDeviceInfo  *pDeviceInfo;
	PaDeviceIndex dID;

	deviceNum = Pa_GetDeviceCount();  // 登録されているデバイス数を得る
	for (dID = 0; dID < deviceNum; dID++){
		pDeviceInfo = Pa_GetDeviceInfo(dID);
		if (pDeviceInfo->maxInputChannels > 0) return dID;
	}
	return -1;
}

//----------------------------------------------------------------
// 終了
void myExit(PA paRec){
//	Pa_CloseStream(paRec.st);
	PaError err = Pa_Terminate();
	if( err != paNoError ){
		printf(  "PortAudio error: %s\n", Pa_GetErrorText( err ) );
		exit(1);
	}
	Pa_Terminate();
	exit(0);
}

