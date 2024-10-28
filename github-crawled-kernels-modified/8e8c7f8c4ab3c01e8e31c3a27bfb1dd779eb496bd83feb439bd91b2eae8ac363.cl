//{"dst":1,"matrix":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x20;
kernel void transform(read_only image2d_t src, write_only image2d_t dst, constant float* matrix) {
  int2 dst_coords = (int2)(get_global_id(0), get_global_id(1));

  float2 src_coords = (float2)(matrix[hook(2, (0) * 3 + (0))] * dst_coords.x + matrix[hook(2, (0) * 3 + (1))] * dst_coords.y + matrix[hook(2, (0) * 3 + (2))], matrix[hook(2, (1) * 3 + (0))] * dst_coords.x + matrix[hook(2, (1) * 3 + (1))] * dst_coords.y + matrix[hook(2, (1) * 3 + (2))]);

  write_imagef(dst, dst_coords, read_imagef(src, sampler, src_coords));
}