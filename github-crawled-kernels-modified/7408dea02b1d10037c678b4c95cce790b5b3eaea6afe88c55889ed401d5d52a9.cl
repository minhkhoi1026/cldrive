//{"N":0,"a":2,"alpha_betaB":3,"blk_result":5,"sm":1,"xi_sum_tmp":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void EM_pre_xisum(const int N, local float* sm, global const float* a, global const float* alpha_betaB, global float* xi_sum_tmp, global float* blk_result) {
  size_t lx = get_local_id(0);
  size_t ly = get_local_id(1);

  size_t gx = get_global_id(0);
  size_t gy = get_global_id(1);

  float data = 0.f;

  if (gx < N && gy < N) {
    data = xi_sum_tmp[hook(4, gy * N + gx)] = a[hook(2, gy * N + gx)] * alpha_betaB[hook(3, gy * N + gx)];
  }

  sm[hook(1, ly * 17 + lx)] = data;

  barrier(0x01);

  size_t index = ly * 17 + lx;
  if (lx < 8) {
    sm[hook(1, index)] += sm[hook(1, index + 8)];
    barrier(0x01);
  }
  if (lx < 4) {
    sm[hook(1, index)] += sm[hook(1, index + 4)];
    barrier(0x01);
  }
  if (lx < 2) {
    sm[hook(1, index)] += sm[hook(1, index + 2)];
    barrier(0x01);
  }
  if (lx < 1) {
    sm[hook(1, index)] += sm[hook(1, index + 1)];
    barrier(0x01);
  }

  if (lx == 0 && ly == 0) {
    int index_out = get_group_id(1) * get_num_groups(0) + get_group_id(0);
    blk_result[hook(5, index_out)] = sm[hook(1, 0)] + sm[hook(1, 17)] + sm[hook(1, 34)] + sm[hook(1, 51)] + sm[hook(1, 68)] + sm[hook(1, 85)] + sm[hook(1, 102)] + sm[hook(1, 119)] + sm[hook(1, 136)] + sm[hook(1, 153)] + sm[hook(1, 170)] + sm[hook(1, 187)] + sm[hook(1, 204)] + sm[hook(1, 221)] + sm[hook(1, 238)] + sm[hook(1, 255)];
  }
}