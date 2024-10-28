//{"FILTER_SCALE":7,"cl_filter_G":2,"cl_input_image":0,"cl_output_image":1,"img_height":4,"img_width":3,"shift":5,"ws":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cl_gaussian_filter(global unsigned char* cl_input_image, global unsigned char* cl_output_image, global unsigned int* cl_filter_G, global int* img_width, global int* img_height, global int* shift, global int* ws, global int* FILTER_SCALE) {
  const int cl_width = get_global_id(0);
  const int cl_height = get_global_id(1);

  unsigned int tmp = 0;
  int a, b;

  if (cl_width >= *img_width || cl_height >= *img_height) {
    return;
  }

  for (int j = 0; j < *ws; j++) {
    for (int i = 0; i < *ws; i++) {
      a = cl_width + i - (*ws / 2);
      b = cl_height + j - (*ws / 2);

      tmp += cl_filter_G[hook(2, j * (*ws) + i)] * cl_input_image[hook(0, 3 * (b * *img_width + a) + *shift)];
    }
  }
  tmp /= *FILTER_SCALE;

  if (tmp > 255) {
    tmp = 255;
  }

  cl_output_image[hook(1, 3 * (cl_height * (*img_width) + cl_width) + (*shift))] = tmp;
}