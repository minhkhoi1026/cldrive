//{"dst":1,"srcimg":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void testReadi(read_only image2d_t srcimg, global uchar4* dst) {
  int tid_x = get_global_id(0);
  int tid_y = get_global_id(1);
  int indx = tid_y * get_image_width(srcimg) + tid_x;
  int4 float3;

  const sampler_t sampler = 2 | 0x10 | 0;
  float3 = read_imagei(srcimg, sampler, (int2)(tid_x, tid_y));
  uchar4 dst_write;
  dst_write.x = (uchar)float3.x;
  dst_write.y = (uchar)float3.y;
  dst_write.z = (uchar)float3.z;
  dst_write.w = (uchar)float3.w;
  dst[hook(1, indx)] = dst_write;
}