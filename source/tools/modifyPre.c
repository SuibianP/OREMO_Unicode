//
// wavファイルと先行発声位置を入力するとMFCC距離を基に位置補正する。
//
// % ./modifyPre.exe wavFile P1 [P2...]
//   P1は先行発声に相当する。単位はsec。
//   ただし、UTAUでは左ブランクとの距離が先行発声値になるが本ソフトではwavファイル先頭からの秒数を指定すること。
//
// 返り値は補正後の先行発声位置。単位はsec。
// 推定に失敗した場合は-1をstdoutにreturnする。
//
// ＜how to compile on Windows＞
//   install MinGW and MSYS
//   start c:\MinGW\msys\1.0\msys.bat
//   change directory
//   mingw32-gcc -mwindows -O3 -o modifyPre.exe modifyPre.c -lm
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define SAMPLE_RATE 44100
#define MFCC float
#define MFCCFILE ".tmp.mfcc"

#if defined(WIN32)
#  include <windows.h>
#  define argc _argc
#  define argv _argv
#  define DSEP "\\"     // ディレクトリ区切記号を\にする
#else
#  define DSEP "/"      // ディレクトリ区切り記号を/にする
#endif

int mfccN        = 30;   // mfccの次元数
int framePeriod  = 256;  // フレームの移動間隔
int frameLength  = 4096; // フレーム長
float borderT    = 0.8;  // 距離の差の平均 * borderT 以上になった地点を先行発声位置とする。
int searchRange1 = 100;  // 補正の際に移動可能な幅に関するパラメータ。
int searchRange2 = 10;   // 補正の際に移動可能な幅に関するパラメータ。
int outPpm       = 0;    // 1=ppm画像を出力する

static char toolPathInit[] = ".";
char *toolPath = toolPathInit;          // ツールコマンドへのパス

//-------------------------------------------------
// 実行失敗等による終了
//
void exitFailure ()
{
  printf ("-1");           // 推定できなかったことをTcl/tkに伝える。
  exit(EXIT_FAILURE);
}

//-------------------------------------------------
// wavファイルからmfccファイルを作る
//
void makeMFCC (char* inFile, char *outFile)
{
  int sr = SAMPLE_RATE / 1000.0;

  // wavdump
  const char *w0 = "%s%swavdump -1 -f %s";
  char *wavdump = (char*) malloc((strlen(w0) + strlen(toolPath) + strlen(DSEP) + strlen(inFile)) * sizeof(char));
  sprintf (wavdump, w0, toolPath, DSEP, inFile);

  // frame
  const char *f0 = "%s%sframe -l %d -p %d";
  char *frame = (char*) malloc((strlen(f0) + strlen(toolPath) + strlen(DSEP) + 20) * sizeof(char));
  sprintf (frame, f0, toolPath, DSEP, frameLength, framePeriod);

  // window
  const char *win0 = "%s%swindow -l %d -n 1";
  char *window = (char*) malloc((strlen(win0) + strlen(toolPath) + strlen(DSEP) + 10) * sizeof(char));
  sprintf (window, win0, toolPath, DSEP, frameLength);

  // mfcc
  const char *m0 = "%s%smfcc -l %d -f %d -m %d -n %d -c 15 -w 0 > %s";
  char *mfcc = (char*) malloc((strlen(m0) + strlen(toolPath) + strlen(DSEP) + 10 + 10 + 10 + 10 + strlen(outFile)) * sizeof(char));
  sprintf (mfcc, m0, toolPath, DSEP, frameLength, sr, mfccN, mfccN, outFile);

  // whole command
  char *command = (char*) malloc((50 + strlen(wavdump) + strlen(frame) + strlen(window) + strlen(mfcc)) * sizeof(char));
#if defined(WIN32)
  // mingw版ではsystem()だとコンソールウィンドウが表示されてしまうので以下の手順で窓を非表示にして実行する
  sprintf (command, "cmd.exe /c %s | %s | %s | %s", wavdump, frame, window, mfcc);
  PROCESS_INFORMATION pi;
  STARTUPINFO si;
  ZeroMemory( &si, sizeof(si) );
  si.cb = sizeof(si);
  si.dwFlags = STARTF_USESHOWWINDOW;  // 窓を非表示にする
  si.wShowWindow = SW_HIDE;           // 窓を非表示にする
  ZeroMemory( &pi, sizeof(pi) );
  if (! CreateProcess(NULL, command, NULL,NULL, FALSE,NORMAL_PRIORITY_CLASS, NULL, NULL, &si, &pi)) exitFailure();
  CloseHandle(pi.hThread);
  WaitForSingleObject(pi.hProcess,INFINITE);  // プロセス終了を待つ
  CloseHandle(pi.hProcess);
#else
  sprintf (command, "%s | %s | %s | %s", wavdump, frame, window, mfcc);
  system (command);
#endif

  free (wavdump);
  free (frame);
  free (window);
  free (mfcc);
  free (command);
}

//-------------------------------------------------
// MFCC(float)型時系列データ読み込み
//
MFCC** readMFCC (char* fname, int* frameNum)
{
  FILE *fp;
  MFCC **mfcc;
  int i;

  /* ファイルオープン */
  if ((fp = fopen(fname, "rb")) == NULL) {
    fprintf (stderr, "readMFCC(): read open error(%s)\n", fname);
    exitFailure();
  }
  /* ファイルサイズ取得 */
  if (fseek(fp, 0, SEEK_END)){
    fprintf (stderr, "readMFCC(): seek error(%s)\n", fname);
    exitFailure();
  }
  *frameNum = ftell(fp) / sizeof(MFCC) / mfccN;
  fseek(fp, 0, SEEK_SET);

  mfcc = (MFCC**) malloc(*frameNum * sizeof(MFCC*));
  for (i = 0; i < *frameNum; i++) {
    mfcc[i] = (MFCC*) malloc(mfccN * sizeof(MFCC*));
    if (fread(mfcc[i], sizeof(MFCC), mfccN, fp) != mfccN) {
      fprintf (stderr, "readMFCC(): read error(%s)\n", fname);
      exitFailure();
    }
  }
  fclose(fp);
  return (mfcc);
}

//-------------------------------------------------
// ppmを出力
//
void writePpm (double** mr, double** mg, double** mb, int X, int Y)
{
  int i, x, y;
  double max, min;

  max = min = mr[0][0];
  for (y = 0; y < Y; y++) {
    for (x = 0; x < X; x++) {
      if (max < mr[x][y]) max = mr[x][y];
      if (max < mg[x][y]) max = mg[x][y];
      if (max < mb[x][y]) max = mb[x][y];
      if (min > mr[x][y]) min = mr[x][y];
      if (min > mg[x][y]) min = mg[x][y];
      if (min > mb[x][y]) min = mb[x][y];
    }
  }

  printf ("P3\n%d %d\n%d\n", X, Y, (int)(max - min));
  for (y = 0; y < Y; y++) {
    for (x = 0; x < X; x++) {
      printf ("%d %d %d\n", (int)(mr[x][y] - min),
                            (int)(mg[x][y] - min),
                            (int)(mb[x][y] - min));
    }
  }
}

//-------------------------------------------------
// pgmを出力
//
void writePgm (double** matrix, int X, int Y)
{
  int i, x, y;
  double max, min;

  max = min = matrix[0][0];
  for (y = 0; y < Y; y++) {
    for (x = 0; x < X; x++) {
      if (max < matrix[x][y]) max = matrix[x][y];
      if (min > matrix[x][y]) min = matrix[x][y];
    }
  }

  printf ("P2\n%d %d\n%d\n", X, Y, (int)(max - min));
  for (y = 0; y < Y; y++) {
    for (x = 0; x < X; x++) {
      printf ("%d\n", (int)(matrix[x][y] - min));
    }
  }
}

//-------------------------------------------------
// [X個][Y個]な二次元配列を作る
//
double** make2DArray (int X, int Y)
{
  int i;
  double **p;
  p = (double**) malloc(X * sizeof(double*));
  for (i = 0; i < X; i++)
    p[i] = (double*) malloc(Y * sizeof(double));
  return p;
}

//-------------------------------------------------
// [X個][Y個]な二次元配列を初期化する
//
void reset2DArray (double** matrix, int X, int Y)
{
  int x, y;
  for (x = 0; x < X; x++)
    for (y = 0; y < Y; y++)
      matrix[x][y] = 0.0;
}

//-------------------------------------------------
// [X個][Y個]な二次元配列をfreeする
//
void free2DArray (double** matrix, int X, int Y)
{
  int i;
  for (i = 0; i < X; i++) free(matrix[i]);
  free(matrix);
}

//-------------------------------------------------
//
void usage(char *cmd)
{
  fprintf (stderr, "usage: %s [option] wavFile p1 [p2...]\n\n", cmd);
  fprintf (stderr, "[option]\n");
  fprintf (stderr, "  -l frame length (unit: sample, default=%d, specify 2**i)\n", frameLength);
  fprintf (stderr, "  -p frame period (unit: sample, default=%d)\n", framePeriod);
  fprintf (stderr, "  -m mfcc dimension (default=%d)\n", mfccN);
  fprintf (stderr, "  -t threshold coefficient for new 'preUtterance' decision (default=%f)\n", borderT);
  fprintf (stderr, "  -s1 search range1 (unit: frameNum, default=%d)\n", searchRange1);
  fprintf (stderr, "  -s2 search range2 (unit: frameNum, default=%d)\n", searchRange2);
  fprintf (stderr, "  -g  ... return PPM format image\n\n");
  fprintf (stderr, "  wavFile : input wave filename. 44.1kHz, 16bit, RIFF-WAV.\n");
  fprintf (stderr, "  p1      : search start point of 'preUtterance'(unit=sec). \n");
  fprintf (stderr, "            Center of vowel utterance is the best point.\n\n");
  fprintf (stderr, "[return]\n");
  fprintf (stderr, "  vowel start point (unit: sec)\n");
  exitFailure();
}

//-------------------------------------------------
//
#if defined(WIN32)
// tcl/tkからexeを呼び出す際にコマンドプロンプトを表示させないよう
// GUIアプリケーションとしてコンパイルさせる
int WINAPI WinMain(HINSTANCE hCurInst, HINSTANCE hPrevInst, LPSTR lpsCmdLine, int nCmdShow)
#else
int main(int argc, char *argv[])
#endif
{
  int frameNum = 0;
  MFCC** mfcc;
  int i, j, x, y, N, arg, srcSeq, dstSeq;
  int xl, xr, yl, yr, xd, yd, xnum, ynum, sxd, sxdNew;
  double **diff, **diff2, ave, *histo, **diffB;
  char *mfccFile;

  if (argc < 3) usage(argv[0]);
  arg = 1;
  while (argv[arg][0] == '-'){
    switch (argv[arg][1]){
      case 'l':
        frameLength = atoi(argv[++arg]);
        break;
      case 'p':
        framePeriod = atoi(argv[++arg]);
        break;
      case 'm':
        mfccN = atoi(argv[++arg]);
        break;
      case 't':
        borderT = atof(argv[++arg]);
        break;
      case 's':
        if (argv[arg][2] == '1') searchRange1 = atoi(argv[++arg]);
        else if (argv[arg][2] == '2') searchRange2 = atoi(argv[++arg]);
        break;
      case 'g':
        outPpm = 1;
        break;
      case 'd':
        toolPath = argv[++arg];
        break;
      default:
        usage(argv[0]);
    }
    arg++;
  }

  mfccFile = (char*) malloc((strlen(MFCCFILE) + 10) * sizeof(char));
  sprintf (mfccFile, ".%s%s", DSEP, MFCCFILE);
  makeMFCC (argv[arg], mfccFile);
  mfcc  = readMFCC (mfccFile, &frameNum);
  remove(mfccFile);

  diff  = make2DArray (searchRange1 * 2, searchRange2 * 2);
  diff2 = make2DArray (searchRange1 * 2, searchRange2 * 2);
  if (outPpm) diffB = make2DArray (searchRange1 * 2, searchRange2 * 2);
  while (++arg < argc){

    srcSeq = atof(argv[arg]) * SAMPLE_RATE / framePeriod; // 先行発声値の初期値(単位:フレーム番号)

    // 探索範囲を求める
    xl = srcSeq - searchRange1; if (xl < 0) xl = 0;
    xr = srcSeq + searchRange1; if (xr > frameNum) xr = frameNum;
    yl = srcSeq - searchRange2; if (yl < 0) yl = 0;
    yr = srcSeq + searchRange2; if (yr > frameNum) yr = frameNum;
    xnum = xr - xl;
    ynum = yr - yl;
    sxd = srcSeq - xl - (srcSeq - yl);

    // MFCC距離の行列を求める
    for (x = xl; x < xr; x++) {
      xd = x - xl;
      for (y = yl; y < yr; y++) {
        yd = y - yl;
        diff[xd][yd] = 0.0;
        for (j = 0; j < mfccN; j++)
          diff[xd][yd] += (mfcc[x][j] - mfcc[y][j]) * (mfcc[x][j] - mfcc[y][j]);
        diff[xd][yd] = sqrt(diff[xd][yd] / mfccN);
      }
    }

#if 0
    //平均平滑化
    for (xd = 0; xd < xnum; xd++) {
      for (yd = 0; yd < ynum; yd++) {
        diff2[xd][yd] = 0;
        N = 0;
        for (j = -3; j <= 3; j++) {
          if (yd+j >= 0 && yd+j < ynum) {
            diff2[xd][yd] += diff[xd][yd+j];
            N++;
          }
        }
        diff2[xd][yd] /= N;
      }
    }

    //平均平滑化
    for (yd = 0; yd < ynum; yd++) {
      for (xd = 0; xd < xnum; xd++) {
        diff[xd][yd] = 0;
        N = 0;
        for (j = 0; j <= 0; j++) {
          if (xd+j >= 0 && xd+j < xnum) {
            diff[xd][yd] += diff2[xd+j][yd];
            N++;
          }
        }
        diff[xd][yd] /= N;
      }
    }
#endif

    // 補正値候補のヒストグラムを作る
    if (outPpm) reset2DArray (diffB, xnum, ynum);
    histo = (double*) malloc(xnum * sizeof(double));
    for (xd = 0; xd < xnum; xd++) histo[xd] = 0;
    for (yd = 0; yd < ynum; yd++){
//koko
      ave = 0.0;
      for (xd = 0; xd < xnum; xd++) ave += diff[xd][yd];
      ave /= xnum;

      // 左方向へ距離の高くなる地点を探す
      for (xd = sxd + yd; xd >= 0; xd--){
        if (diff[xd][yd] >= ave * borderT) break;
//        if (diff[xd][yd] >= borderT) break;
      }
      if (xd < 0) xd = sxd + yd;
      histo[xd]++;
      if (outPpm) diffB[xd][yd] = 5;
    }

    sxdNew = 0;
    for (xd = 0; xd < xnum; xd++)
      if (histo[sxdNew] < histo[xd]) sxdNew = xd;

    if (! outPpm) printf ("%f\n", (double)(sxdNew + xl) * framePeriod / SAMPLE_RATE); // 単位:sec

    free(histo);
  }

  if (outPpm) writePpm(diffB, diff, diffB, xnum, ynum);
  free2DArray(diff,  searchRange1 * 2, searchRange2 * 2);
  free2DArray(diff2, searchRange1 * 2, searchRange2 * 2);
  if (outPpm) free2DArray(diffB, searchRange1 * 2, searchRange2 * 2);
  return 0;
}

