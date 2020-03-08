// 標準入力からコマンドを読み、指定したファイルを再生する
// コマンドは以下のものを実行できる
// list ... 入力デバイス一覧を表示する
// set  [デバイス番号 [形式(bit等(1,2,4,8)) [チャンネル数 [サンプリング周波数]]]]
//       ... 使用デバイスを指定する。再生の場合、wavコマンドの後でsetを使うと正常に再生されないので注意
// test [デバイス番号 [形式(bit等(1,2,4,8)) [チャンネル数 [サンプリング周波数]]]] ... デバイスをテストする
// wav   ... 指定したwavファイルを読み込む。ヘッダに合わせてPortAudioの設定を変更する
// play  ... 再生開始
// stop  ... 録音停止
// reset ... PortAudioをリセットする
// ver   ... バージョンを表示する
// exit  ... 終了

// stdoutに結果文を送るときは必ず先頭行をresultBegin、最終行をresultEndにし、fflush(stdout)すること
// これはPortAudio等のライブラリが意図しない文字列をstdoutに出力したときにスルーできるようにするため

// 再生はpaFloat32で行われる。

// win32用プロジェクトで空プロジェクトを作成し、プロパティで以下のように設定した。
// 追加のインクルードdirにVisual Studio 2010のProjects\portaudio\includeを追加
// 追加のインクルードdirにc:\Program Files (x86)\libsndfile\includeを追加
// 追加のライブラリdirにVisual Studio 2010のProjects\portaudio\build\msvc\Win32\Releaseを追加
// 追加のライブラリdirにC:\Program Files (x86)\libsndfile\libを追加
// リンカ、入力、追加の依存ファイルにportaudio_x86.lib;libsndfile-1.lib;を追加
// ReleaseとDebug下にportaudio/build/msvc/Win32/Release/portaudio_x86.dllをコピー
// ReleaseとDebug下にProgram Files (x86)/libsndfile/bin/libsndfile-1.dllをコピー
// 全般、文字セットを「マルチバイト文字セットを使用する」にする
// C/C++、コード生成、ランタイムライブラリを /MTにする

// koko, play　範囲指定再生
// koko, play  play中でもstopしてreplayさせた方が良いかも

#define  APPNAME  "oremo-player"
#define  VERSION  "1.0"
#define  outWavName "tmp.wav"

#include "oremo-common.h"

//----------------------------------------------------------------
// プロトタイプ宣言
int playStart(SND *, char *);
int setOutDevice(SND *, char *, int);
int playCallback(const void *, void *, unsigned long,
	const PaStreamCallbackTimeInfo*, PaStreamCallbackFlags, void *);
int openWav(SND *, char *);
int closeWav(SND *, int);

//----------------------------------------------------------------
// 本文
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

		// コマンド実行
		// play [開始時刻(sec) [終了時刻(sec)]] または playF [開始時刻(frame) [終了時刻(frame)]]
		if (command[0] == 'p')      playStart(&play, command);
		else if (strcmp(command, "stop\n" ) == 0) stop (&play);
		else if (strcmp(command, "list\n") == 0)  getDevList(STATUS_PLAY);
		// set  [デバイス番号 [形式(bit等(1,2,4,8)) [チャンネル数 [サンプリング周波数 [フレームサイズ]]]]]
		else if (command[0] == 's' && command[1] == 'e') setOutDevice(&play, command, 1);
		// test [デバイス番号 [形式(bit等(1,2,4,8)) [チャンネル数 [サンプリング周波数 [フレームサイズ]]]]]
		else if (command[0] == 't')               testDevice(&play, command, 1, STATUS_PLAY);
		else if (command[0] == 'w')               openWav(&play, command);
		else if (strcmp(command, "stat\n" ) == 0) status(&play);
		else if (strcmp(command, "ver\n")  == 0)  version(APPNAME, VERSION);
		else if (strcmp(command, "reset\n") == 0) init(&play, STATUS_PLAY);
		else if (strcmp(command, "exit\n")  == 0) myExit(&play);
	}
}

//----------------------------------------------------------------
// wavファイルを開く。成功=0、失敗=1。
// stdoutには成功したらSuccessと返す。失敗ならエラーを出力。
int openWav(SND *play, char *command){
	int intErr;
	char inWav[_MAX_PATH];
	char setCom[_MAX_PATH];

	// wav 再生wavファイル名
	intErr = sscanf_s (command, "%*s %s", inWav, _MAX_PATH);

	// wavファイルを開く
	if (play->fp != NULL) closeWav(play, 0);
	memset(&(play->info), 0, sizeof(SF_INFO));
	play->fp = sf_open(inWav, SFM_READ, &(play->info));
	if (play->fp == NULL){
		printf("resultBegin\nerror: can not open wav file (%s)\nresultEnd\n", inWav);
		fflush(stdout);
		return 1;
	}

	// wavフォーマットに合わせてPortAudioの設定を変更する
	sprintf_s(setCom, "set %d %d %d %d\n", 
		play->param.device, sfFormat2pa(play->info.format),
		play->info.channels, play->info.samplerate);
	setOutDevice(play, setCom, 0);

	printf("resultBegin\nSuccess\nresultEnd\n");
	fflush(stdout);
	return 0;
}

//----------------------------------------------------------------
// wavファイルを閉じる。成功=0、失敗=1。
// stdoutには成功したらSuccessと返す。失敗ならエラーを出力。
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
// 再生コールバック
int playCallback(const void *inputBuffer, void *outputBuffer,
	unsigned long framesPerBuffer, const PaStreamCallbackTimeInfo* timeInfo,
	PaStreamCallbackFlags statusFlags, void *userData){
	SND *play;
	
	play = (SND *)userData;
	memset(outputBuffer, 0, framesPerBuffer * play->info.channels * sizeof(float));

	// 終了地点まで再生したとき
	if (! play->fp || play->endFrame > 0 && play->playFrame >= play->endFrame){
		play->status = STATUS_STOP;
		return paComplete;
	}

	if (sf_readf_float(play->fp, (float *)outputBuffer, framesPerBuffer) <= 0){
		// ファイル末尾まで再生したとき
		play->status = STATUS_STOP;
		return paComplete;
	}
	play->playFrame += framesPerBuffer;
	return paContinue;
}

//----------------------------------------------------------------
// 再生開始。成功=0、失敗=1。stdoutには成功したらSuccessと返す。失敗ならエラーを出力。
int playStart(SND *play, char *command){
	PaError err;
	int intErr;
	double start = 0.0, end = 0;

	if (play->status){	// 既に再生中なら停止させる
		err = Pa_CloseStream(play->st);
		if (err != paNoError){
			printf("resultBegin\nerror: Pa_CloseStream(), %s\nresultEnd\n", Pa_GetErrorText(err));
			fflush(stdout);
			return 1;
		}
	}
	if (command[4] != 'F'){
		// play [開始時刻(sec) [終了時刻(sec)]]
		intErr = sscanf_s (command, "%*s %lf %lf", &start, &end);
		play->playFrame = sec2frame(start, play);
		play->endFrame  = (end > 0) ? sec2frame(end, play) : 0;
	} else {
		intErr = sscanf_s (command, "%*s %ld %ld", &play->playFrame, &play->endFrame);
		if (play->endFrame <= 0) play->endFrame = 0;
	}

	//fpをファイル先頭に置く
	if (play->fp == NULL || sf_seek(play->fp, play->playFrame, SEEK_SET) < 0){
		printf("resultBegin\nerror: file open error\nresultEnd\n");
		fflush(stdout);
		return 1;
	}
	
	// 音声デバイスを開いて再生開始
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
	play->status = STATUS_PLAY;		// 状態を再生中にする
	return 0;
}

//----------------------------------------------------------------
// 再生デバイスや形式などを指定する。成功=0、失敗=1
// show=1なら利用可能時に"Success"、不可能事にエラー文をstdoutに送る
int setOutDevice(SND *play, char *command, int show){
	PaError err;
	SND _play;
	int intErr;
	int format;		// wavファイルの保存フォーマット。番号はPortAudioのものを使う。(ややこしい)

	// set [デバイス番号 [形式(bit等) [チャンネル数 [サンプリング周波数]]]]
	// 指定されなかった引数部分には現状の設定を用いる。引数が無い場合は現在の設定を表示する
	copySND(&_play, play);
	_play.param.sampleFormat = paFloat32;		// 再生形式はFloat32に固定
	intErr = sscanf_s (command, "%*s %d%d%d%d%d",
		&_play.param.device, &format, 
		&_play.param.channelCount, &_play.sampleRate, &_play.frameSize);
	// コマンドが"set"のみのときは現状の設定を返す
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
