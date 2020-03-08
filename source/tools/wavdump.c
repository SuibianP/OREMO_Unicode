// wav�t�@�C�����_���v����B
// PCM�t�H�[�}�b�g�A�ʎq���r�b�g�F16 bit�ȊO��wav�t�@�C���ɂ͔�Ή��B
//
// http://www.kk.iij4u.or.jp/~kondo/wave/separate.c ����� 
// SPTK-3.5 (http://sp-tk.sourceforge.net/) ���Q�l�ɂ��܂����B
//
// (how to compile on Windows)
//   install MinGW and MSYS
//   start c:\MinGW\msys\1.0\msys.bat
//   change directory
//   mingw32-gcc -mwindows -O3 -o wavdump.exe wavdump.c
//

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#if defined(WIN32)
#  include <fcntl.h>
#  include <io.h>
#  include <windows.h>
#  define argc _argc
#  define argv _argv
#endif

typedef struct {
  unsigned long sf;
  unsigned short byte;
  short channels;
  long dataSize;
} WAVHEADER;

char *cmnd;
int verbose = 0;   // 1=�w�b�_��\������
int convertToMono = 0; // 1=���m�����ɂ��ďo�͂���

void usage(void)
{
  fprintf(stderr, "usage: %s (-h|-v|-d|-s|-a|-f|-1) [inWavFile] [outFile]\n", cmnd);
  exit(EXIT_FAILURE);
}

FILE *getfp(char *name, char *opt)
{
   FILE *fp;

   if ((fp = fopen(name, opt)) == NULL) {
      fprintf(stderr, "Cannot open file : %s\n", name);
      exit(2);
   }

   return (fp);
}

void openError(char *filename)
{
  fprintf(stderr, "cannot open file : %s\n", filename);
  exit(EXIT_FAILURE);
}

void readError(FILE *fp)
{
  fprintf(stderr, "read error : %ld\n", ftell(fp));
  fclose(fp);
  exit(EXIT_FAILURE);
}

/*-----------------------------*/
/* 4Byte �ǂݍ��� 10�i���ɕϊ� */
/*-----------------------------*/
unsigned long get_ulong(FILE *fp)
{
  unsigned char s[4];

  if (fread(s, 4, 1, fp) != 1) {
    readError(fp);
  }

  return (s[0] + 256L * (s[1] + 256L * (s[2] + 256L * s[3])));
}

/*-----------------------------*/
/* 2Byte �ǂݍ��� 10�i���ɕϊ� */
/*-----------------------------*/
unsigned short get_ushort(FILE *fp)
{
  unsigned char s[2];

  if (fread(s, 2, 1, fp) != 1) {
    readError(fp);
  }

  return (s[0] + 256U * s[1]);
}

/*------------------------*/
/* fmt �`�����N�̃`�F�b�N */
/*------------------------*/
void fmt_chunkRead(FILE *fp, WAVHEADER *w)
{
  short tag, len2;
  long len;

  // 2Byte �f�[�^�`�� PCM �Ȃ�� 01 00
  tag = get_ushort(fp);
  if (verbose) fprintf(stderr, "    format tag     = %u (1 = PCM)\n", tag);
  // 2Byte �`�����l���� ���m�����Ȃ�� 01 00 �X�e���I�Ȃ�� 02 00
  w->channels = get_ushort(fp);
  if (verbose) fprintf(stderr, "    channels       = %u\n", w->channels);
  // 4Byte �T���v�����O���g��(Hz)
  w->sf = get_ulong(fp);
  if (verbose) fprintf(stderr, "    samples/sec    = %lu\n", w->sf);
  // 4Byte 1�b������̃o�C�g��
  len = get_ulong(fp);
  if (verbose) fprintf(stderr, "    avg. bytes/sec = %lu\n", len);
  // 2Byte �o�C�g���~�`�����l����
  len2 = get_ushort(fp);
  if (verbose) fprintf(stderr, "    block align    = %u\n", len2);
  // 2Byte 1�T���v��������̃o�C�g��
  w->byte = get_ushort(fp) / 8;
  if (verbose) fprintf(stderr, "    byte/sample    = %u\n", w->byte);

  if (tag != 1) {
    fprintf(stderr, "\nThis program supported \"PCM format\" wav file\n");
    fprintf(stderr, "format tag = %d\n", tag);
    exit(EXIT_FAILURE);
  }
  if (w->byte != 2) {
    fprintf(stderr, "\nThis program supported 16bit wav file\n");
    fprintf(stderr, "byte/sample = %d\n", w->byte);
    exit(EXIT_FAILURE);
  }
}

/*----------------------*/
/* �t�@�C�����e�ǂݏo�� */
/*----------------------*/
void wavHeaderRead(FILE *fp, WAVHEADER *w)
{
  long cursor, len;
  unsigned char s[5];
  short tmp;
  int i;

  // RIFF �w�b�_���  // 4Byte 'R''I''F''F'
  if (fread(s, 4, 1, fp) != 1) readError(fp);
  if (memcmp(s, "RIFF", 4) != 0) {
    fprintf(stderr, "Not a 'RIFF' format\n");
    fclose(fp);
    exit(EXIT_FAILURE);
  }
  // 4Byte ����ȍ~�̃o�C�g�� = (�t�@�C���T�C�Y - 8)(Byte)
  len = get_ulong(fp);

  // WAVE �w�b�_���  // 4Byte 'W''A''V''E'
  if (fread(s, 4, 1, fp) != 1) readError(fp);
  if (memcmp(s, "WAVE", 4) != 0) {
    fprintf(stderr, "Not a 'WAVE' format\n");
    fclose(fp);
    exit(EXIT_FAILURE);
  }

  // �`�����N���
  while (fread(s, 4, 1, fp) == 1) {
    if (memcmp(s, "fmt ", 4) == 0) {
      len = get_ulong(fp);
      if (verbose) fprintf(stderr, "  <fmt > (%ld bytes)\n", len);
      cursor = ftell(fp);
      fmt_chunkRead(fp, w);
      fseek(fp, cursor + len, SEEK_SET);
    }
    else if (memcmp(s, "data", 4) == 0) {
      w->dataSize = get_ulong(fp);
      if (verbose) fprintf(stderr, "  <data> (%ld bytes)\n", w->dataSize);
      break;
    } else {
      len = get_ulong(fp);
      s[4] = '\0';
      if (verbose) fprintf(stderr, "  <%s> (%ld bytes)\n", s, len);
      cursor = ftell(fp);
      fseek(fp, cursor + len, SEEK_SET);
    }
  }
}

void out(double xd, char outMode, FILE *fp)
{
  short xs;
  float xf;
  switch (outMode) {
    case 'd':
      fwrite(&xd, sizeof(double), 1, fp);
      break;
    case 'f':
      xf = (float) xd;
      fwrite(&xf, sizeof(float), 1, fp);
      break;
    case 's':
      xs = (short) xd;
      fwrite(&xs, sizeof(short), 1, fp);
      break;
    case 'a':
    default:
      fprintf (fp, "%d\n", (int)xd);
  }
}

/**************/
/* ���C���֐� */
/**************/
#if defined(WIN32)
// tcl/tk����exe���Ăяo���ۂɃR�}���h�v�����v�g��\�������Ȃ��悤
// GUI�A�v���P�[�V�����Ƃ��ăR���p�C��������
int WINAPI WinMain(HINSTANCE hCurInst, HINSTANCE hPrevInst, LPSTR lpsCmdLine, int nCmdShow)
#else
int main(int argc, char *argv[])
#endif
{
  WAVHEADER w;
  char *s;
  FILE *fpin  = stdin;
  FILE *fpout = stdout;
  int N, i, c;
  double xave;
  short xs;
  char outMode = 'a';

  // MessageBox(NULL, "wavdump", "debug", MB_OK); //�f�o�b�O�p
  cmnd = argv[0];
  while (--argc){
    if (*(s = *++argv) == '-') {
      switch (*++s) {
        case 'v':             // �w�b�_��\������
          verbose = 1;
          break;
        case 'd':             // �o�C�i��double�^�ŏo�͂���
          outMode = 'd';
          break;
        case 'f':             // �o�C�i��float�^�ŏo�͂���
          outMode = 'f';
          break;
        case 's':             // �o�C�i��short�^�ŏo�͂���
          outMode = 's';
          break;
        case 'a':             // �A�X�L�[�^�ŏo�͂���
          outMode = 'a';
          break;
        case '1':             // ���m�����ϊ����ďo��
          convertToMono = 1;
          break;
        case 'h':
          usage();
        default:
          fprintf (stderr, "error: invalid option: %c\n", *s);
          usage();
      }
    } else {
      break;
    }
  }
  if (argc == 2){
    fpin  = getfp(*argv++, "rb");
    fpout = getfp(*argv, "wb");
  } else if (argc == 1){
    fpin = getfp(*argv, "rb");
  }

#if defined(WIN32)
   _setmode(_fileno(fpin),  _O_BINARY);
   _setmode(_fileno(fpout), _O_BINARY);
#endif

  wavHeaderRead(fpin, &w);
  N = w.dataSize / w.byte / w.channels;
  for (i = 0; i < N; i++) {
    if (w.channels != 1 && convertToMono) {
      xave = 0.0;
      for (c = 0; c < w.channels; c++) {
        if (fread(&xs, w.byte, 1, fpin) != 1) break;
        xave += (double)xs;
      }
      xave /= w.channels;
      out((double)xave, outMode, fpout);
    } else {
      for (c = 0; c < w.channels; c++) {
        if (fread(&xs, w.byte, 1, fpin) != 1) break;
        out((double)xs, outMode, fpout);
      }
    }
  }
  fclose(fpin);
  fclose(fpout);

  return 0;
}
