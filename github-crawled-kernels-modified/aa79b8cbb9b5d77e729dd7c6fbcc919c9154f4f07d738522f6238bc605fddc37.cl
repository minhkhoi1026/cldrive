//{"gymy_space":0,"height":2,"out_dist":9,"out_size":8,"probe":5,"probe_dist":7,"probe_num_values":6,"q":3,"skip":4,"sum_n":11,"sum_p":12,"threshold":10,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void get_gymy(global int* gymy_space, const int width, const int height, const int q, const int skip, global int* probe, const int probe_num_values, global int* probe_dist, const int out_size, const int out_dist, const double threshold, global int* sum_n, global int* sum_p) {
  int y = get_global_id(2);

  {
    float sum = 0;

    int x1 = get_global_id(0) * skip;
    {
      int x2 = get_global_id(1) * skip;
      {
        if (x1 >= width || x2 >= height || y >= out_size)
          return;

        if (gymy_space[hook(0, x1 * height + x2)] <= threshold)
          return;

        for (int val = 0; val < probe_num_values; val++) {
          if (fabs(cos((double)(2.0 * 3.14159265358979323846f / q * (sqrt((float)((probe_dist[hook(7, val)]) * (float)(probe_dist[hook(7, val)])) + ((x1 - probe[hook(5, val)]) * (float)(x1 - probe[hook(5, val)])) + ((x2) * (float)(x2))) + sqrt((float)((out_dist) * (float)(out_dist)) + ((x1 - y) * (float)(x1 - y)) + ((x2) * (float)(x2))))))) < 0.707)
            atomic_inc(&sum_n[hook(11, y)]);
          else
            atomic_inc(&sum_p[hook(12, y)]);
        }
      }
    }
  }
}