//{"brick_count":4,"brick_outer_dimension":3,"pool":1,"pool_cluster":0,"pool_dimension":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
unsigned int target_index(int4 target_dimension, int4 id_loc, unsigned int brick_outer_dimension, unsigned int brick_count) {
  int4 target_brick_dimension = target_dimension / (int4)(brick_outer_dimension);

  int4 brick_offset;
  brick_offset.z = brick_count / (target_brick_dimension.x * target_brick_dimension.y);
  brick_offset.y = (brick_count % (target_brick_dimension.x * target_brick_dimension.y)) / target_brick_dimension.x;
  brick_offset.x = (brick_count % (target_brick_dimension.x * target_brick_dimension.y)) % target_brick_dimension.x;

  int4 index3d = brick_offset * (int4)(brick_outer_dimension) + id_loc;

  return index3d.x + index3d.y * target_dimension.x + index3d.z * target_dimension.x * target_dimension.y;
}

kernel void fill(global float* pool_cluster, global float* pool, int4 pool_dimension, unsigned int brick_outer_dimension, unsigned int brick_count) {
  int4 id_loc = (int4)(get_local_id(0), get_local_id(1), get_local_id(2), 0);

  int id_wg = get_global_id(2) / brick_outer_dimension;

  int id_output = id_loc.x + id_loc.y * brick_outer_dimension + id_loc.z * brick_outer_dimension * brick_outer_dimension;

  unsigned int i = target_index(pool_dimension, id_loc, brick_outer_dimension, brick_count);
  unsigned int j = id_wg * brick_outer_dimension * brick_outer_dimension * brick_outer_dimension + id_output;

  pool[hook(1, i)] = pool_cluster[hook(0, j)];
}