//{"clf":6,"cli":7,"color_s":4,"color_u":3,"increment":1,"num":0,"pos_u":2,"sort_indices":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct GridParams {
  float4 grid_size;
  float4 grid_min;
  float4 grid_max;
  float4 bnd_min;
  float4 bnd_max;

  float4 grid_res;
  float4 grid_delta;

  int nb_cells;
};

kernel void lifetime(int num, float increment, global float4* pos_u, global float4* color_u, global float4* color_s, global unsigned int* sort_indices, global float4* clf, global int4* cli) {
  unsigned int i = get_global_id(0);
  if (i >= num)
    return;

  float life = color_s[hook(4, i)].w;

  life += increment;

  if (life <= 0.0f) {
    pos_u[hook(2, i)] = (float4)(100.0f, 100.0f, 100.0f, 1.0f);

    life = 0.0f;
  }
  if (life >= 1.0f) {
    life = 1.0f;
  }
  float alpha = life;
  color_s[hook(4, i)].w = alpha;

  color_u[hook(3, i)] = color_s[hook(4, i)];
}