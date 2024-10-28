//{"centerline":0,"initSegmentation":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 0 | 2 | 0x10;
kernel void initGrowing(read_only image3d_t centerline, global uchar* initSegmentation) {
  int4 pos = {get_global_id(0), get_global_id(1), get_global_id(2), 0};
  if (read_imageui(centerline, sampler, pos).x > 0) {
    unsigned int radius = read_imageui(centerline, sampler, pos).x;
    int N;
    if (radius > 7) {
      N = min(max(1, (int)(radius)), 5);
    } else {
      N = 1;
    }

    for (int a = -N; a < N + 1; a++) {
      for (int b = -N; b < N + 1; b++) {
        for (int c = -N; c < N + 1; c++) {
          int4 n;
          n.x = pos.x + a;
          n.y = pos.y + b;
          n.z = pos.z + c;
          if (read_imageui(centerline, sampler, n).x == 0 && length((float3)(a, b, c)) <= N) {
            if (n.x >= 0 && n.y >= 0 && n.z >= 0 && n.x < get_global_size(0) && n.y < get_global_size(1) && n.z < get_global_size(2))
              initSegmentation[hook(1, n.x + n.y * get_global_size(0) + n.z * get_global_size(0) * get_global_size(1))] = 2;
          }
        }
      }
    }
  }
}