//{"distanceImage":1,"output":2,"segmentation":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 4 | 0x10;
constant int4 neighbors[] = {{1, 0, 0, 0}, {-1, 0, 0, 0}, {0, 1, 0, 0}, {0, -1, 0, 0}, {0, 0, 1, 0}, {0, 0, -1, 0}};

kernel void findCandidateCenterpoints(read_only image3d_t segmentation, read_only image3d_t distanceImage,

                                      global uchar* output

) {
  const int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};
  if (read_imageui(segmentation, sampler, pos).x == 1) {
    short distance = read_imagei(distanceImage, sampler, pos).x;

    int N = 4;
    bool invalid = false;
    for (int a = -N; a <= N; ++a) {
      for (int b = -N; b <= N; ++b) {
        for (int c = -N; c <= N; ++c) {
          short distance2 = read_imagei(distanceImage, sampler, pos + (int4)(a, b, c, 0)).x;
          if (distance2 > distance) {
            invalid = true;
          }
        }
      }
    }
    if (!invalid) {
      output[hook(2, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = 1;
    } else {
      output[hook(2, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = 0;
    }
  } else {
    output[hook(2, pos.x + pos.y * get_global_size(0) + pos.z * get_global_size(0) * get_global_size(1))] = 0;
  }
}