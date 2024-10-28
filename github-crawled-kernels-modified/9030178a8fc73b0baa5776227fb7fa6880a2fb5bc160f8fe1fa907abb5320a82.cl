//{"dest":1,"offset":2,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void img_to_buf_intensity(read_only image2d_t src, global float* dest, const int offset) {
  const sampler_t sampler = 1 | 2 |

                            0x20;

  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);
  unsigned int Nx = get_global_size(0);
  unsigned int Ny = get_global_size(1);

  float4 val = read_imagef(src, sampler, (float2)(1.f * i / (Nx - 1.f), 1.f * j / (Ny - 1.f)));

  dest[hook(1, i + Nx * j + offset)] = val.x * val.x + val.y * val.y;
}