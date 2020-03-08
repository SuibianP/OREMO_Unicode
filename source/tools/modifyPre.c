//
// wav�t�@�C���Ɛ�s�����ʒu����͂����MFCC��������Ɉʒu�␳����B
//
// % ./modifyPre.exe wavFile P1 [P2...]
//   P1�͐�s�����ɑ�������B�P�ʂ�sec�B
//   �������AUTAU�ł͍��u�����N�Ƃ̋�������s�����l�ɂȂ邪�{�\�t�g�ł�wav�t�@�C���擪����̕b�����w�肷�邱�ƁB
//
// �Ԃ�l�͕␳��̐�s�����ʒu�B�P�ʂ�sec�B
// ����Ɏ��s�����ꍇ��-1��stdout��return����B
//
// ��how to compile on Windows��
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
#  define DSEP "\\"     // �f�B���N�g����؋L����\�ɂ���
#else
#  define DSEP "/"      // �f�B���N�g����؂�L����/�ɂ���
#endif

int mfccN        = 30;   // mfcc�̎�����
int framePeriod  = 256;  // �t���[���̈ړ��Ԋu
int frameLength  = 4096; // �t���[����
float borderT    = 0.8;  // �����̍��̕��� * borderT �ȏ�ɂȂ����n�_���s�����ʒu�Ƃ���B
int searchRange1 = 100;  // �␳�̍ۂɈړ��\�ȕ��Ɋւ���p�����[�^�B
int searchRange2 = 10;   // �␳�̍ۂɈړ��\�ȕ��Ɋւ���p�����[�^�B
int outPpm       = 0;    // 1=ppm�摜���o�͂���

static char toolPathInit[] = ".";
char *toolPath = toolPathInit;          // �c�[���R�}���h�ւ̃p�X

//-------------------------------------------------
// ���s���s���ɂ��I��
//
void exitFailure ()
{
  printf ("-1");           // ����ł��Ȃ��������Ƃ�Tcl/tk�ɓ`����B
  exit(EXIT_FAILURE);
}

//-------------------------------------------------
// wav�t�@�C������mfcc�t�@�C�������
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
  // mingw�łł�system()���ƃR���\�[���E�B���h�E���\������Ă��܂��̂ňȉ��̎菇�ő����\���ɂ��Ď��s����
  sprintf (command, "cmd.exe /c %s | %s | %s | %s", wavdump, frame, window, mfcc);
  PROCESS_INFORMATION pi;
  STARTUPINFO si;
  ZeroMemory( &si, sizeof(si) );
  si.cb = sizeof(si);
  si.dwFlags = STARTF_USESHOWWINDOW;  // �����\���ɂ���
  si.wShowWindow = SW_HIDE;           // �����\���ɂ���
  ZeroMemory( &pi, sizeof(pi) );
  if (! CreateProcess(NULL, command, NULL,NULL, FALSE,NORMAL_PRIORITY_CLASS, NULL, NULL, &si, &pi)) exitFailure();
  CloseHandle(pi.hThread);
  WaitForSingleObject(pi.hProcess,INFINITE);  // �v���Z�X�I����҂�
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
// MFCC(float)�^���n��f�[�^�ǂݍ���
//
MFCC** readMFCC (char* fname, int* frameNum)
{
  FILE *fp;
  MFCC **mfcc;
  int i;

  /* �t�@�C���I�[�v�� */
  if ((fp = fopen(fname, "rb")) == NULL) {
    fprintf (stderr, "readMFCC(): read open error(%s)\n", fname);
    exitFailure();
  }
  /* �t�@�C���T�C�Y�擾 */
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
// ppm���o��
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
// pgm���o��
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
// [X��][Y��]�ȓ񎟌��z������
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
// [X��][Y��]�ȓ񎟌��z�������������
//
void reset2DArray (double** matrix, int X, int Y)
{
  int x, y;
  for (x = 0; x < X; x++)
    for (y = 0; y < Y; y++)
      matrix[x][y] = 0.0;
}

//-------------------------------------------------
// [X��][Y��]�ȓ񎟌��z���free����
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
// tcl/tk����exe���Ăяo���ۂɃR�}���h�v�����v�g��\�������Ȃ��悤
// GUI�A�v���P�[�V�����Ƃ��ăR���p�C��������
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

    srcSeq = atof(argv[arg]) * SAMPLE_RATE / framePeriod; // ��s�����l�̏����l(�P��:�t���[���ԍ�)

    // �T���͈͂����߂�
    xl = srcSeq - searchRange1; if (xl < 0) xl = 0;
    xr = srcSeq + searchRange1; if (xr > frameNum) xr = frameNum;
    yl = srcSeq - searchRange2; if (yl < 0) yl = 0;
    yr = srcSeq + searchRange2; if (yr > frameNum) yr = frameNum;
    xnum = xr - xl;
    ynum = yr - yl;
    sxd = srcSeq - xl - (srcSeq - yl);

    // MFCC�����̍s������߂�
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
    //���ϕ�����
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

    //���ϕ�����
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

    // �␳�l���̃q�X�g�O���������
    if (outPpm) reset2DArray (diffB, xnum, ynum);
    histo = (double*) malloc(xnum * sizeof(double));
    for (xd = 0; xd < xnum; xd++) histo[xd] = 0;
    for (yd = 0; yd < ynum; yd++){
//koko
      ave = 0.0;
      for (xd = 0; xd < xnum; xd++) ave += diff[xd][yd];
      ave /= xnum;

      // �������֋����̍����Ȃ�n�_��T��
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

    if (! outPpm) printf ("%f\n", (double)(sxdNew + xl) * framePeriod / SAMPLE_RATE); // �P��:sec

    free(histo);
  }

  if (outPpm) writePpm(diffB, diff, diffB, xnum, ynum);
  free2DArray(diff,  searchRange1 * 2, searchRange2 * 2);
  free2DArray(diff2, searchRange1 * 2, searchRange2 * 2);
  if (outPpm) free2DArray(diffB, searchRange1 * 2, searchRange2 * 2);
  return 0;
}

