//{"H1":5,"W":4,"across_channels":6,"dst":3,"dst_line":9,"mean_part":1,"normalize_variance":7,"nparts":8,"power_mean":2,"src":0,"src_line":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(1, 1, 1))) kernel void mvn_scale(const global float* restrict src, global float* restrict mean_part, global float* restrict power_mean, global float* restrict dst, int W, int H1, int across_channels, int normalize_variance, int nparts) {
  local float src_line[4 * 1024];
  local float dst_line[4 * 1024];

  int c = get_group_id(2);
  int C = get_global_size(2);

  int h = get_group_id(1);
  int H = get_global_size(1);

  event_t e1 = async_work_group_copy(src_line, src + c * H * W + h * W, W, 0);
  wait_group_events(1, &e1);

  int idx = (across_channels == 0) ? nparts * c : 0;
  float scale = (across_channels == 0) ? H * W : H * W * C;

  int total = (across_channels == 0) ? nparts : nparts * C;
  float mean = 0.f;
  float variance = 0.f;

  for (int i = 0; i < total; i++) {
    mean += mean_part[hook(1, idx + i)];
    variance += power_mean[hook(2, idx + i)];
  }

  mean = mean / scale;
  variance = variance / scale;
  variance = variance - mean * mean;
  variance = native_sqrt(variance) + 1e-9f;

  float hmean = mean;
  float hvariance = (normalize_variance == 0) ? 1.f : (1.f / variance);

  for (size_t w = 0; w < W; w++) {
    dst_line[hook(9, w)] = (src_line[hook(10, w)] - hmean) * hvariance;
  }

  barrier(0x01);

  event_t e2 = async_work_group_copy(dst + c * H * W + h * W, dst_line, W, 0);
  wait_group_events(1, &e2);
}