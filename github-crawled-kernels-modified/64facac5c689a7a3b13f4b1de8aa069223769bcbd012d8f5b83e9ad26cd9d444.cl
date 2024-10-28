//{"gaussianL":2,"gaussianR":3,"gaussian_kernel":4,"inputL":0,"inputR":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float constant gaussian_kernel[25] = {0.000002f, 0.000212f, 0.000922f, 0.000212f, 0.000002f, 0.000212f, 0.024745f, 0.107391f, 0.024745f, 0.000212f, 0.000922f, 0.107391f, 0.466066f, 0.107391f, 0.000922f, 0.000212f, 0.024745f, 0.107391f, 0.024745f, 0.000212f, 0.000002f, 0.000212f, 0.000922f, 0.000212f, 0.000002f};

float constant sobel_kernelY[25] = {-0.41666f, -0.03333f, 0.0f, 0.03333f, 0.41666f, -0.06666f, -0.08333f, 0.0f, 0.08333f, 0.06666f, -0.08333f, -0.16666f, 0.0f, 0.16666f, 0.08333f, -0.06666f, -0.08333f, 0.0f, 0.08333f, 0.06666f, -0.41666f, -0.03333f, 0.0f, 0.03333f, 0.41666f};

float constant sobel_kernelX[25] = {-0.41666f, -0.06666f, -0.08333f, -0.06666f, -0.41666f, -0.03333f, -0.08333f, -0.16666f, -0.08333f, -0.03333f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.03333f, 0.08333f, 0.16666f, 0.08333f, 0.03333f, 0.41666f, 0.06666f, 0.08333f, 0.06666f, 0.41666f};

kernel void gaussian_filter(global uchar* inputL, global uchar* inputR, global uchar* gaussianL, global uchar* gaussianR) {
  int xt = get_global_id(0);
  int yt = get_global_id(1);
  int width = get_global_size(0);
  int height = get_global_size(1);
  int i = 0, j = 0;

  if (xt > 2 && xt < width - 2 && yt > 2 && yt < height - 2) {
    int index = 0;
    float resultL_x = 0.0f;
    float resultR_x = 0.0f;
    for (int m = -2; m <= 2; m++) {
      for (int n = -2; n <= 2; n++) {
        i = xt + m;
        j = yt + n;

        resultL_x += gaussian_kernel[hook(4, index)] * convert_float(inputL[hook(0, j * width + i)]);
        resultR_x += gaussian_kernel[hook(4, index)] * convert_float(inputR[hook(1, j * width + i)]);
        index++;
      }
    }
    gaussianL[hook(2, yt * width + xt)] = convert_uchar_sat(resultL_x);
    gaussianR[hook(3, yt * width + xt)] = convert_uchar_sat(resultR_x);
  }
}