//{"image":0,"max":4,"min":3,"offset":5,"segmentation":1,"stopGrowing":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0x10 | 0;
kernel void seededRegionGrowing(read_only image2d_t image, global char* segmentation, global char* stopGrowing, private float min, private float max) {
  const int2 pos = {get_global_id(0), get_global_id(1)};
  const unsigned int linearPos = pos.x + pos.y * get_global_size(0);

  int2 offset[8] = {{1, 0}, {0, 1}, {1, 1}, {-1, 0}, {0, -1}, {-1, -1}, {-1, 1}, {1, -1}};

  if (segmentation[hook(1, linearPos)] == 2) {
    float intensity = (float)read_imageui(image, sampler, pos).x;
    if (intensity >= min && intensity <= max) {
      segmentation[hook(1, linearPos)] = 1;

      for (int i = 0; i < 8; i++) {
        int2 neighborPos = pos + offset[hook(5, i)];
        if (neighborPos.x < 0 || neighborPos.y < 0 || neighborPos.x >= get_global_size(0) || neighborPos.y >= get_global_size(1))
          continue;
        unsigned int neighborLinearPos = neighborPos.x + neighborPos.y * get_global_size(0);
        if (segmentation[hook(1, neighborLinearPos)] == 0) {
          segmentation[hook(1, neighborLinearPos)] = 2;
          stopGrowing[hook(2, 0)] = 0;
        }
      }
    } else {
      segmentation[hook(1, linearPos)] = 0;
    }
  }
}