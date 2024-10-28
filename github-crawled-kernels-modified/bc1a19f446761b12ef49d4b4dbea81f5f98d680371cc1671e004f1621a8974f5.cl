//{"bgrStep":1,"coeffs":6,"cols":2,"imgUV":5,"imgY":4,"pBGR":0,"rows":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant float c_YUV2RGBCoeffs_420[5] = {1.163999557f, 2.017999649f, -0.390999794f, -0.812999725f, 1.5959997177f};

const constant float CV_8U_MAX = 255.0f;
const constant float CV_8U_HALF = 128.0f;
const constant float BT601_BLACK_RANGE = 16.0f;
const constant float CV_8U_SCALE = 1.0f / 255.0f;
const constant float d1 = BT601_BLACK_RANGE / CV_8U_MAX;
const constant float d2 = CV_8U_HALF / CV_8U_MAX;

constant float c_RGB2YUVCoeffs_420[8] = {0.256999969f, 0.50399971f, 0.09799957f, -0.1479988098f, -0.2909994125f, 0.438999176f, -0.3679990768f, -0.0709991455f};

kernel void BGR2YUV_NV12_8u(global unsigned char* pBGR, int bgrStep, int cols, int rows, write_only image2d_t imgY, write_only image2d_t imgUV) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x < cols) {
    if (y < rows) {
      global const uchar* pSrcRow1 = pBGR + mad24(y, bgrStep, mad24(x, 3, 0));
      global const uchar* pSrcRow2 = pSrcRow1 + bgrStep;

      float4 src_pix1 = convert_float4(vload4(0, pSrcRow1 + 0 * 3)) * CV_8U_SCALE;
      float4 src_pix2 = convert_float4(vload4(0, pSrcRow1 + 1 * 3)) * CV_8U_SCALE;
      float4 src_pix3 = convert_float4(vload4(0, pSrcRow2 + 0 * 3)) * CV_8U_SCALE;
      float4 src_pix4 = convert_float4(vload4(0, pSrcRow2 + 1 * 3)) * CV_8U_SCALE;

      constant float* coeffs = c_RGB2YUVCoeffs_420;

      float Y1 = fma(coeffs[hook(6, 0)], src_pix1.z, fma(coeffs[hook(6, 1)], src_pix1.y, fma(coeffs[hook(6, 2)], src_pix1.x, d1)));
      float Y2 = fma(coeffs[hook(6, 0)], src_pix2.z, fma(coeffs[hook(6, 1)], src_pix2.y, fma(coeffs[hook(6, 2)], src_pix2.x, d1)));
      float Y3 = fma(coeffs[hook(6, 0)], src_pix3.z, fma(coeffs[hook(6, 1)], src_pix3.y, fma(coeffs[hook(6, 2)], src_pix3.x, d1)));
      float Y4 = fma(coeffs[hook(6, 0)], src_pix4.z, fma(coeffs[hook(6, 1)], src_pix4.y, fma(coeffs[hook(6, 2)], src_pix4.x, d1)));

      float4 UV;
      UV.x = fma(coeffs[hook(6, 3)], src_pix1.z, fma(coeffs[hook(6, 4)], src_pix1.y, fma(coeffs[hook(6, 5)], src_pix1.x, d2)));
      UV.y = fma(coeffs[hook(6, 5)], src_pix1.z, fma(coeffs[hook(6, 6)], src_pix1.y, fma(coeffs[hook(6, 7)], src_pix1.x, d2)));

      write_imagef(imgY, (int2)(x + 0, y + 0), Y1);
      write_imagef(imgY, (int2)(x + 1, y + 0), Y2);
      write_imagef(imgY, (int2)(x + 0, y + 1), Y3);
      write_imagef(imgY, (int2)(x + 1, y + 1), Y4);

      write_imagef(imgUV, (int2)((x / 2), (y / 2)), UV);
    }
  }
}