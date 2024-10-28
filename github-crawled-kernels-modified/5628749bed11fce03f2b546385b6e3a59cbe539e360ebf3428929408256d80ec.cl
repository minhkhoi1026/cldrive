//{"image1":0,"image2":1,"results":3,"sampler":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void image_1D_buffer(image1d_buffer_t image1, image1d_t image2, sampler_t sampler, global int* results) {
  int x = get_global_id(0);
  int offset = x;

  int4 col = read_imagei(image1, x);
  int4 test = (col != read_imagei(image2, sampler, x));

  if (test.x || test.y || test.z || test.w)
    results[hook(3, offset)] = 0;
  else
    results[hook(3, offset)] = 1;
}