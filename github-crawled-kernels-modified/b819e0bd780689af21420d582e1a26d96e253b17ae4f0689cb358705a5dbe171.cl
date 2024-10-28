//{"Nx":2,"Ny":3,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void run(read_only image2d_t input, write_only image2d_t output, const int Nx, const int Ny) {
  const sampler_t smp = 0 | 0 | 0x10;

  int2 coord = (get_global_id(1), get_global_id(0));

  uint4 pixel = read_imageui(input, smp, coord);

  write_imageui(output, coord, pixel);
}