//{"image":0,"max":4,"min":3,"offsets":5,"segmentation":1,"stopGrowing":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 0x10 | 0;
kernel void seededRegionGrowing(read_only image3d_t image, global char* segmentation, global char* stopGrowing, private float min, private float max) {
  const int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};
  const unsigned int linearPos = pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1);

  const int4 offsets[6] = {
      {0, 0, 1, 0}, {0, 1, 0, 0}, {1, 0, 0, 0}, {0, 0, -1, 0}, {0, -1, 0, 0}, {-1, 0, 0, 0},
  };

  if (segmentation[hook(1, linearPos)] == 2) {
    float intensity = (float)read_imageui(image, sampler, pos).x;
    if (intensity >= min && intensity <= max) {
      segmentation[hook(1, linearPos)] = 1;

      for (int i = 0; i < 6; i++) {
        int4 neighborPos = pos + offsets[hook(5, i)];
        if (neighborPos.x < 0 || neighborPos.y < 0 || neighborPos.z < 0 || neighborPos.x >= get_global_size(0) || neighborPos.y >= get_global_size(1) || neighborPos.z >= get_global_size(2))
          continue;
        unsigned int neighborLinearPos = neighborPos.x + neighborPos.y * get_global_size(0) + neighborPos.z * get_global_size(0) * get_global_size(1);
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