//{"input":0,"output":1,"pos":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t imageSampler = 0 | 2 | 0x10;
kernel void rollHorizontal(read_only image2d_t input, write_only image2d_t output, int pos) {
  int2 coord = (int2)(get_global_id(0), get_global_id(1));
  int2 imagePt = coord;
  uint4 value;

  imagePt.x += pos;
  if (imagePt.x > get_global_size(0))
    imagePt.x -= get_global_size(0);

  value = read_imageui(input, imageSampler, imagePt);

  unsigned int temp = value.x;
  value.x = value.z;
  value.z = temp;
  write_imageui(output, coord, value);
}