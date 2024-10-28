//{"filterWidth":2,"inputImage":0,"lds":3,"outputImage":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void box_filter_horizontal_local(global uchar4* inputImage, global uchar4* outputImage, int filterWidth, local uchar4* lds) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  int width = get_global_size(0);
  int height = get_global_size(1);

  int pos = x + y * width;
  int k = (filterWidth - 1) / 2;

  int lid = get_local_id(0);
  int gidX = get_group_id(0);
  int gidY = get_group_id(1);

  int gSizeX = get_local_size(0);
  int gSizeY = get_local_size(1);

  int firstElement = gSizeX * gidX + width * gidY * gSizeY;

  if (lid < k) {
    lds[hook(3, lid)] = inputImage[hook(0, firstElement - k + lid)];
    lds[hook(3, 256 + k + lid)] = inputImage[hook(0, firstElement + lid + 256)];
  }

  lds[hook(3, lid + k)] = inputImage[hook(0, firstElement + lid)];

  barrier(0x01);

  if (x < k || x >= (width - k))
    return;

  int4 size = (int4)(filterWidth);

  int4 sum = 0;

  for (int X = -k; X <= k; X++) {
    sum += convert_int4(lds[hook(3, lid + X + k)]);
  }
  outputImage[hook(1, pos)] = convert_uchar4(sum / size);
}