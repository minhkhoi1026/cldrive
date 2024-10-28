//{"centers_x":2,"centers_y":3,"num_of_clusters":0,"num_of_points":1,"point_cluster_ids":6,"points_x":4,"points_y":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void calc_centroid(int num_of_clusters, int num_of_points, global float* centers_x, global float* centers_y, global float* points_x, global float* points_y, global int* point_cluster_ids) {
  int global_id = get_global_id(0);
  if (global_id >= num_of_clusters) {
    return;
  }
  float sum_x = 0;
  float sum_y = 0;
  int count = 0;
  for (int i = 0; i < num_of_points; i++) {
    if (point_cluster_ids[hook(6, i)] == global_id) {
      sum_x += points_x[hook(4, i)];
      sum_y += points_y[hook(5, i)];
      count += 1;
    }
  }
  float new_x = sum_x / count;
  float new_y = sum_y / count;

  centers_x[hook(2, global_id)] = new_x;
  centers_y[hook(3, global_id)] = new_y;
}