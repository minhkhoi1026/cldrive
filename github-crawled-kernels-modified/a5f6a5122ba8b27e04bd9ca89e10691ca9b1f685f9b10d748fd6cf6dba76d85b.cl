//{"bgrStep":3,"coeffs":6,"cols":4,"imgUV":1,"imgY":0,"pBGR":2,"pDstRow1":7,"pDstRow2":8,"rows":5}
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

kernel void YUV2BGR_NV12_8u(read_only image2d_t imgY, read_only image2d_t imgUV, global unsigned char* pBGR, int bgrStep, int cols, int rows) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  if (x + 1 < cols) {
    if (y + 1 < rows) {
      global uchar* pDstRow1 = pBGR + mad24(y, bgrStep, mad24(x, 3, 0));
      global uchar* pDstRow2 = pDstRow1 + bgrStep;

      float4 Y1 = read_imagef(imgY, (int2)(x + 0, y + 0));
      float4 Y2 = read_imagef(imgY, (int2)(x + 1, y + 0));
      float4 Y3 = read_imagef(imgY, (int2)(x + 0, y + 1));
      float4 Y4 = read_imagef(imgY, (int2)(x + 1, y + 1));

      float4 UV = read_imagef(imgUV, (int2)(x / 2, y / 2)) - d2;

      constant float* coeffs = c_YUV2RGBCoeffs_420;

      Y1 = max(0.f, Y1 - d1) * coeffs[hook(6, 0)];
      Y2 = max(0.f, Y2 - d1) * coeffs[hook(6, 0)];
      Y3 = max(0.f, Y3 - d1) * coeffs[hook(6, 0)];
      Y4 = max(0.f, Y4 - d1) * coeffs[hook(6, 0)];

      float ruv = fma(coeffs[hook(6, 4)], UV.y, 0.0f);
      float guv = fma(coeffs[hook(6, 3)], UV.y, fma(coeffs[hook(6, 2)], UV.x, 0.0f));
      float buv = fma(coeffs[hook(6, 1)], UV.x, 0.0f);

      float R1 = (Y1.x + ruv) * CV_8U_MAX;
      float G1 = (Y1.x + guv) * CV_8U_MAX;
      float B1 = (Y1.x + buv) * CV_8U_MAX;

      float R2 = (Y2.x + ruv) * CV_8U_MAX;
      float G2 = (Y2.x + guv) * CV_8U_MAX;
      float B2 = (Y2.x + buv) * CV_8U_MAX;

      float R3 = (Y3.x + ruv) * CV_8U_MAX;
      float G3 = (Y3.x + guv) * CV_8U_MAX;
      float B3 = (Y3.x + buv) * CV_8U_MAX;

      float R4 = (Y4.x + ruv) * CV_8U_MAX;
      float G4 = (Y4.x + guv) * CV_8U_MAX;
      float B4 = (Y4.x + buv) * CV_8U_MAX;

      pDstRow1[hook(7, 0 * 3 + 0)] = convert_uchar_sat(B1);
      pDstRow1[hook(7, 0 * 3 + 1)] = convert_uchar_sat(G1);
      pDstRow1[hook(7, 0 * 3 + 2)] = convert_uchar_sat(R1);

      pDstRow1[hook(7, 1 * 3 + 0)] = convert_uchar_sat(B2);
      pDstRow1[hook(7, 1 * 3 + 1)] = convert_uchar_sat(G2);
      pDstRow1[hook(7, 1 * 3 + 2)] = convert_uchar_sat(R2);

      pDstRow2[hook(8, 0 * 3 + 0)] = convert_uchar_sat(B3);
      pDstRow2[hook(8, 0 * 3 + 1)] = convert_uchar_sat(G3);
      pDstRow2[hook(8, 0 * 3 + 2)] = convert_uchar_sat(R3);

      pDstRow2[hook(8, 1 * 3 + 0)] = convert_uchar_sat(B4);
      pDstRow2[hook(8, 1 * 3 + 1)] = convert_uchar_sat(G4);
      pDstRow2[hook(8, 1 * 3 + 2)] = convert_uchar_sat(R4);
    }
  }
}