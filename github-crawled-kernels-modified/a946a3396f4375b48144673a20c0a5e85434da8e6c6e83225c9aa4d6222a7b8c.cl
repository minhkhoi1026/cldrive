//{"Left":1,"height":3,"input":0,"width":2}
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
kernel void rectify_back(global uchar* input, global uchar* Left, int width, int height) {
  int xt = get_global_id(0);
  int yt = get_global_id(1);

  float coeffx = 0.0f;

  float xd = (xt - CX_VGA) / FX_VGA;
  float yd = (yt - CY_VGA) / FY_VGA;

  float x = xd;
  float y = yd;
  int i = 0;
  int j = 0;
  float a = 0;
  float b = 0;
  float r_sqr = x * x + y * y;
  float result_ = 0.0f;

  coeffx = (1 - K1 * r_sqr) + ((3 * K1 * K1 - 2 * K1 * K2) * r_sqr * r_sqr);
  x = x * coeffx;
  y = y * coeffx;

  x = F_RECTI_VGA * x + CX_RECTI_VGA;
  y = F_RECTI_VGA * y + CY_RECTI_VGA;

  if (x >= 1 && x <= width && y >= 1 && y < height) {
    i = (int)x;
    a = x - i;
    j = (int)y;
    b = y - j;

    result_ = (1.0f - a) * (1.0f - b) * (float)(input[hook(0, (j - 1) * width + (i - 1))]) + a * (1.0f - b) * (float)(input[hook(0, (j - 1) * width + i)]) + a * b * (float)(input[hook(0, j * width + i)]) + (1.0f - a) * b * (float)(input[hook(0, j * width + (i - 1))]);
    Left[hook(1, (yt - 1) * width + (xt - 1))] = convert_uchar_sat(result_);
  }
}