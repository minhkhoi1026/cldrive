//{"results":2,"sampler":1,"srcimg":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef float float4 __attribute__((ext_vector_type(4)));
typedef int int2 __attribute__((ext_vector_type(2)));
typedef long unsigned int size_t;
size_t __attribute__((overloadable)) __attribute__((const)) get_global_id(unsigned int dimindx);
int __attribute__((overloadable)) __attribute__((const)) get_image_width(read_only image2d_t image);
float4 __attribute__((pure)) __attribute__((overloadable)) read_imagef(read_only image2d_t image, sampler_t sampler, int2 coord);
kernel void test_fn(image2d_t srcimg, sampler_t sampler, global float4* results) {
  int tid_x = get_global_id(0);
  int tid_y = get_global_id(1);
  results[hook(2, tid_x + tid_y * get_image_width(srcimg))] = read_imagef(srcimg, sampler, (int2){tid_x, tid_y});
}