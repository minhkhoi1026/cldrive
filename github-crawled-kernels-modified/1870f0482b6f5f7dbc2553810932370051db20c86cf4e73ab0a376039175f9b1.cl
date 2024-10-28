//{"gymy_space":0,"height":2,"in_dist":8,"input":5,"num_obj":6,"num_obj_values":7,"q":3,"skip":4,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void init_gymy(global int* gymy_space, const int width, const int height, const int q, const int skip, global int* input, const int num_obj, const int num_obj_values, global int* in_dist) {
  int x1 = get_global_id(0) * skip;
  {
    int x2 = get_global_id(1) * skip;
    {
      if (x1 >= width || x2 >= height)
        return;

      gymy_space[hook(0, x1 * height + x2)] = 0;

      for (int obj = 0; obj < num_obj; obj++) {
        float sum = 0;
        for (int val = 0; val < num_obj_values; val++) {
          if (fabs(cos(2 * 3.14159265358979323846f / q * sqrt(((in_dist[hook(8, val)]) * (float)(in_dist[hook(8, val)])) + ((x1 - input[hook(5, val + obj * num_obj_values)]) * (float)(x1 - input[hook(5, val + obj * num_obj_values)])) + ((x2) * (float)(x2))))) < 0.707)
            sum -= 1;
          else
            sum += 1;
        }
        gymy_space[hook(0, x1 * height + x2)] += ((sum) * (float)(sum));
      }
    }
  }
}