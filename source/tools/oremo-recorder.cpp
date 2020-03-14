// 標準入力からコマンドを読み、録音して outWavName(tmp.wav)に保存する
// コマンドは以下のものを実行できる
// list ... 入力デバイス一覧を表示する
// set  [デバイス番号 [形式(bit等(1,2,4,8)) [チャンネル数 [サンプリング周波数]]]] ... 使用デバイスを指定する
// test [デバイス番号 [形式(bit等(1,2,4,8)) [チャンネル数 [サンプリング周波数]]]] ... デバイスをテストする
// rec   ... 録音開始
// stop  ... 録音停止
// reset ... PortAudioをリセットする
// ver   ... バージョンを表示する
// exit  ... 終了

// stdoutに結果文を送るときは必ず先頭行をresultBegin、最終行をresultEndにし、fflush(stdout)すること
// これはPortAudio等のライブラリが意図しない文字列をstdoutに出力したときにスルーできるようにするため

// 録音はpaFloat32で行われ、保存時に16,24,32bit,floatのいずれかに変換する。

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

#define  APPNAME  "oremo-recorder"
#define  VERSION  "1.0"
#define  outWavName "tmp.wav"

#include "../oremo-player/oremo-common.h"

//----------------------------------------------------------------
// プロトタイプ宣言
int recStart(SND *, char *);
int setInDevice(SND *, char *, int);
int recCallback(const void *, void *, unsigned long,
	const PaStreamCallbackTimeInfo*, PaStreamCallbackFlags, void *);
void makeResultFilename(char *, _TCHAR *);
int sfFormat2pa(int);
int paFormat2sf(int);

//----------------------------------------------------------------
// 本文
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

		// コマンド実行
		if (strcmp(command, "rec\n" ) == 0)       recStart(&rec, outWav);
		else if (strcmp(command, "stop\n" ) == 0) stop (&rec);
		else if (strcmp(command, "list\n") == 0)  getDevList(STATUS_REC);
		// set  [デバイス番号 [形式(bit等(1,2,4,8)) [チャンネル数 [サンプリング周波数 [フレームサイズ]]]]]
		else if (command[0] == 's' && command[1] == 'e') setInDevice(&rec, command, 1);
		// test [デバイス番号 [形式(bit等(1,2,4,8)) [チャンネル数 [サンプリング周波数 [フレームサイズ]]]]]
		else if (command[0] == 't')               testDevice(&rec, command, 1, STATUS_REC);
		else if (strcmp(command, "stat\n" ) == 0) status(&rec);
		else if (strcmp(command, "ver\n")  == 0)  version(APPNAME, VERSION);
		else if (strcmp(command, "reset\n") == 0) init(&rec, STATUS_REC);
		else if (strcmp(command, "exit\n")  == 0) myExit(&rec);
	}
}

//----------------------------------------------------------------
// 録音コールバック
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
// 録音開始。成功=0、失敗=1。stdoutには成功したらSuccessと返す。失敗ならエラーを出力。
int recStart(SND *rec, char *outWav){
	PaError err;

	if (rec->status){	// 既に録音中なら終了
		printf("resultBegin\nerror: already recording now\nresultEnd\n");
		fflush(stdout);
		return 0;
	}

	// 保存wavファイルを開く
	rec->fp = sf_open(outWav, SFM_WRITE, &(rec->info));
	if (rec->fp == NULL){
		printf("resultBegin\nerror: can not start recording\nresultEnd\n");
		fflush(stdout);
		return 1;
	}

	// 音声デバイスを開いて録音開始
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
	rec->status = STATUS_REC;		// 状態を録音中にする
	return 0;
}

//----------------------------------------------------------------
// 録音デバイスや形式などを指定する。成功=0、失敗=1
// show=1なら利用可能時に"Success"、不可能事にエラー文をstdoutに送る
int setInDevice(SND *rec, char *command, int show){
	PaError err;
	SND _rec;
	int intErr;
	int format;		// wavファイルの保存フォーマット。番号はPortAudioのものを使う。(ややこしい)

	// set [デバイス番号 [形式(bit等) [チャンネル数 [サンプリング周波数 [フレームサイズ]]]]]
	// 指定されなかった引数部分には現状の設定を用いる。引数が無い場合は現在の設定を表示する
	copySND(&_rec, rec);
	_rec.param.sampleFormat = paFloat32;		// 録音形式はFloat32に固定
	intErr = sscanf_s (command, "%*s %d%d%d%d%d",
		&_rec.param.device, &format, 
		&_rec.param.channelCount, &_rec.sampleRate, &_rec.frameSize);
	// コマンドが"set"のみのときは現状の設定を返す
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
// 出力wavファイル名（フルパス）を求める
void makeResultFilename(char *result, _TCHAR *str){
	TCHAR szFull[_MAX_PATH];    // exeのフルパス(exe名含む)
	TCHAR szDrive[_MAX_DRIVE];  // exeのドライブ
	TCHAR szDir[_MAX_DIR];      // exeのディレクトリ
	TCHAR fpath[_MAX_PATH];

	GetModuleFileName(NULL, szFull, sizeof(szFull) / sizeof(TCHAR));	// exeのフルパスを得る
	_tsplitpath_s(szFull, szDrive, _MAX_DRIVE, szDir, _MAX_DIR, NULL, NULL, NULL, NULL);	// フルパスをドライブ名等に分解
	_tmakepath_s(fpath, _MAX_PATH, szDrive, szDir, NULL, NULL);		// フルパス(exe名含まず)を得る
	strcpy_s(result, _MAX_PATH, fpath);
	strcat_s(result, _MAX_PATH, outWavName);
}
