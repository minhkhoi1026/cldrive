//{"centers_x":2,"centers_y":3,"num_of_clusters":0,"num_of_points":1,"point_cluster_ids":6,"points_x":4,"points_y":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void do_clustering(int num_of_clusters, int num_of_points, global float* centers_x, global float* centers_y, global float* points_x, global float* points_y, global int* point_cluster_ids) {
  int global_id = get_global_id(0);
  if (global_id >= num_of_points) {
    return;
  }

  int point_cluster_id = point_cluster_ids[hook(6, global_id)];
  float x = points_x[hook(4, global_id)];
  float y = points_y[hook(5, global_id)];

  float min = 0x1.fffffep127f;
  float dist = 0;
  int min_id = point_cluster_id;
  float c_x, c_y;
  for (int i = 0; i < num_of_clusters; i++) {
    c_x = centers_x[hook(2, i)];
    c_y = centers_y[hook(3, i)];
    dist = distance((float2)(x, y), (float2)(c_x, c_y));

    if (dist < min) {
      min = dist;
      min_id = i;
    }
  }

  point_cluster_ids[hook(6, global_id)] = min_id;
}