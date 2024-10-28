//{"Left":1,"Right":2,"height":4,"in":0,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float constant F_RECTI = 264.29444970357366f * 2.0f;
float constant CX_RECTI = 321.6046943664551f * 2.0f;
float constant CY_RECTI = 238.9259433746338f * 2.0f;
float constant FX = 413.074435f * 2.0f;
float constant FY = 413.53896f * 2.0f;
float constant CX = 299.831845f * 2.0f;
float constant CY = 234.01305f * 2.0f;
float constant FX2 = 821.59003f;
float constant FY2 = 823.07792f;
float constant CX2 = 718.06715f;
float constant CY2 = 484.56333f;
float constant F_RECTI_VGA = 264.29444970357366f;
float constant CX_RECTI_VGA = 321.6046943664551f;
float constant CY_RECTI_VGA = 238.9259433746338f;
float constant FX_VGA = 413.074435f;
float constant FY_VGA = 413.53896f;
float constant CX_VGA = 299.831845f;
float constant CY_VGA = 234.01305f;
float constant K1 = -0.3857f;
float constant K2 = 0.18076f;
float constant P1 = 0.00004f;
float constant P2 = -0.00188f;
float constant FX2_VGA = 410.795015f;
float constant FY2_VGA = 411.53896f;
float constant CX2_VGA = 359.033575f;
float constant CY2_VGA = 242.281665f;
float constant K11 = -0.36101f;
float constant K22 = 0.12757f;
float constant P11 = -0.00036f;
float constant P22 = -0.00112f;
kernel void rectify(global uchar* in, global uchar* Left, global uchar* Right, int width, int height) {
  int xt = get_global_id(0);
  int yt = get_global_id(1);

  float coeffx = 0.0f;
  float xd = (xt - CX_RECTI) / F_RECTI;
  float yd = (yt - CY_RECTI) / F_RECTI;
  float x = xd;
  float y = yd;
  int i = 0;
  int j = 0;
  float a = 0;
  float b = 0;
  float r_sqr = x * x + y * y;
  float result_ = 0.0f;

  if (xt < width / 2) {
    coeffx = 1 + K1 * r_sqr + K2 * r_sqr * r_sqr;

    x = x * coeffx + 2 * P1 * x * y + P2 * (r_sqr + (2 * x * x));
    y = y * coeffx + P1 * (r_sqr + (2 * y * y) + 2 * P2 * x * y);

    x = FX * x + CX;
    y = FY * y + CY;

    if (x >= 1 && x <= width / 2 && y >= 1 && y < height) {
      i = (int)x;
      a = x - i;
      j = (int)y;
      b = y - j;

      result_ = (1.0f - a) * (1.0f - b) * (float)(in[hook(0, (j - 1) * width + (i - 1))]) + a * (1.0f - b) * (float)(in[hook(0, (j - 1) * width + i)]) + a * b * (float)(in[hook(0, j * width + i)]) + (1.0f - a) * b * (float)(in[hook(0, j * width + (i - 1))]);
      Left[hook(1, (yt - 1) * width / 2 + (xt - 1))] = convert_uchar_sat(result_);
    }
    x = xd;
    y = yd;

    coeffx = 1 + K11 * r_sqr + K22 * r_sqr * r_sqr;

    x = x * coeffx + 2 * P11 * x * y + P22 * (r_sqr + (2 * x * x));
    y = y * coeffx + P11 * (r_sqr + (2 * y * y) + 2 * P22 * x * y);

    x = FX2 * x + CX2;
    y = FY2 * y + CY2;

    if (x >= 0 && x < width / 2 && y >= 0 && y < height) {
      x = x + width / 2;
      i = (int)(x);
      a = x - i;
      j = (int)(y);
      b = y - j;

      result_ = (1.0f - a) * (1.0f - b) * (float)(in[hook(0, (j - 1) * width + (i - 1))]) + a * (1.0f - b) * (float)(in[hook(0, (j - 1) * width + i)]) + a * b * (float)(in[hook(0, j * width + i)]) + (1.0f - a) * b * (float)(in[hook(0, j * width + (i - 1))]);
      Right[hook(2, (yt - 1) * width / 2 + (xt - 1))] = convert_uchar_sat(result_);
    }
  }
}