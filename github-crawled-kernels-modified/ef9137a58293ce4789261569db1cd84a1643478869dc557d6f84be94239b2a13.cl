//{"c_strel":4,"dilated":6,"img":5,"img_m":0,"img_n":1,"strel_m":2,"strel_n":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dilate_kernel(int img_m, int img_n, int strel_m, int strel_n, constant float* c_strel, global float* img, global float* dilated) {
  int el_center_i = strel_m / 2;
  int el_center_j = strel_n / 2;

  int thread_id = get_global_id(0);
  int i = thread_id % img_m;
  int j = thread_id / img_m;

  if (j > img_n)
    return;

  float max = 0.0f;
  int el_i, el_j, x, y;
  if (j < img_n) {
    for (el_i = 0; el_i < strel_m; el_i++) {
      y = i - el_center_i + el_i;

      if ((y >= 0) && (y < img_m)) {
        for (el_j = 0; el_j < strel_n; el_j++) {
          x = j - el_center_j + el_j;

          if ((x >= 0) && (x < img_n) && (c_strel[hook(4, (el_i * strel_n) + el_j)] != 0)) {
            int addr = (x * img_m) + y;
            float temp = img[hook(5, addr)];

            if (temp > max)
              max = temp;
          }
        }
      }
    }

    dilated[hook(6, (i * img_n) + j)] = max;
  }
}