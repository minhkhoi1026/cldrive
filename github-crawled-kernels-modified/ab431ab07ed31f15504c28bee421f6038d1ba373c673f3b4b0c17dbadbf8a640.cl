//{"angle":5,"d_h":7,"d_w":6,"data":2,"float3":11,"iVec":12,"input_image":0,"trans":9,"trans[0]":8,"trans[1]":10,"validity":1,"x_mid":3,"xt":13,"y_mid":4,"yt":14}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0 | 0x10;
bool checkRimCornerBool(global uchar* D, int idx, int idy, int sz_x, int r_rim);
void checkRimCorner(global uchar* D, int idx, int idy, int sz_x, int r_rim, uchar* pcol1, uchar* pcol2, uchar* pcol3);
void shrinkBox(global uchar* D, size_t* px, size_t* py, int w, int h, int sz_x);
void jointDetect(global uchar* D, size_t* px, size_t* py, int w, int h, int sz_x);
void binarySearch(int x1, int x2, int y1, int y2, int* x_ret, int* y_ret, int w, int h, global uchar* D);
uchar getColVal_colMajor(int x, int y, int w, int h, global uchar* D);
void shrinkLine(float x1, float x2, float y1, float y2, float d, read_only image2d_t input_image, float* px, float* py);
kernel void getTransValidity(read_only image2d_t input_image, global uchar* validity, global float* data, float x_mid, float y_mid, float angle, float d_w, float d_h) {
  size_t id1 = get_global_id(0);
  size_t id2 = get_global_id(1);

  int id = id1 * 8 + id2;
  if (id >= 125)
    return;

  int nx_check = 2;
  int ny_check = 2;
  int nt_check = 2;

  int dxt = floor(id / (float)((2 * ny_check + 1) * (2 * nt_check + 1))) - nx_check;
  int id_temp = id % ((2 * ny_check + 1) * (2 * nt_check + 1));
  int dyt = floor(id_temp / (float)(2 * nt_check + 1)) - ny_check;
  float dt = (id_temp % (2 * nt_check + 1)) - nt_check;

  float dx = dxt * d_w * cos(angle) + dyt * d_h * sin(angle);
  float dy = -dxt * d_w * sin(angle) + dyt * d_h * cos(angle);
  dt = dt * 3.142f / 12.0f;

  float trans[2][2] = {{cos(dt), -sin(dt)}, {sin(dt), cos(dt)}};

  int2 pos;
  float4 pf;

  uchar float3[16] = {1, 3, 1, 2, 2, 1, 2, 3, 3, 2, 3, 1, 1, 3, 1, 2};

  uchar flag = 1;
  for (int i = 0; i < 16; i++) {
    float x = data[hook(2, 2 * i)] - x_mid;
    float y = data[hook(2, 2 * i + 1)] - y_mid;

    pos.y = floor(x * trans[hook(9, 0)][hook(8, 0)] + y * trans[hook(9, 0)][hook(8, 1)] + dx + x_mid + 0.5f);
    pos.x = floor(x * trans[hook(9, 1)][hook(10, 0)] + y * trans[hook(9, 1)][hook(10, 1)] + dy + y_mid + 0.5f);

    if (pos.x < 0 || pos.x >= 1920 || pos.y < 0 || pos.y >= 1080) {
      flag = 0;
      break;
    }

    pf = read_imagef(input_image, sampler, pos);
    if (float3[hook(11, i)] == 1 && (pf.x < pf.y || pf.x < pf.z)) {
      flag = 0;
      break;
    }
    if (float3[hook(11, i)] == 2 && (pf.y < pf.x || pf.y < pf.z)) {
      flag = 0;
      break;
    }
    if (float3[hook(11, i)] == 3 && (pf.z < pf.y || pf.z < pf.x)) {
      flag = 0;
      break;
    }
  }

  if (flag == 1) {
    float d = d_h / 4.0f;
    if (d > d_w / 4.0f)
      d = d_w / 4.0f;
    d = floor(d);
    if (d > 2)
      d = 2;
    int iVec[4] = {0, 3, 12, 5};
    for (int t = 0; t < 4; t++) {
      int i = iVec[hook(12, t)];
      float x = data[hook(2, 2 * i)] - x_mid;
      float y = data[hook(2, 2 * i + 1)] - y_mid;

      float xt[4] = {-d, -d, d, d};
      float yt[4] = {-d, d, -d, d};

      for (int k = 0; k < 4; k++) {
        pos.y = floor((x + xt[hook(13, k)]) * trans[hook(9, 0)][hook(8, 0)] + (y + yt[hook(14, k)]) * trans[hook(9, 0)][hook(8, 1)] + dx + x_mid + 0.5f);
        pos.x = floor((x + xt[hook(13, k)]) * trans[hook(9, 1)][hook(10, 0)] + (y + yt[hook(14, k)]) * trans[hook(9, 1)][hook(10, 1)] + dy + y_mid + 0.5f);

        if (pos.x < 0 || pos.x >= 1920 || pos.y < 0 || pos.y >= 1080) {
          flag = 0;
          break;
        }

        pf = read_imagef(input_image, sampler, pos);
        if (float3[hook(11, i)] == 1 && (pf.x < pf.y || pf.x < pf.z)) {
          flag = 0;
          break;
        }
        if (float3[hook(11, i)] == 2 && (pf.y < pf.x || pf.y < pf.z)) {
          flag = 0;
          break;
        }
        if (float3[hook(11, i)] == 3 && (pf.z < pf.y || pf.z < pf.x)) {
          flag = 0;
          break;
        }
      }
      if (flag == 0)
        break;
    }
  }

  validity[hook(1, id)] = flag;
}