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

  float2 xy = (float2)(points_x[hook(4, global_id)], points_y[hook(5, global_id)]);
  float dist0 = distance(xy, (float2)(centers_x[hook(2, 0)], centers_y[hook(3, 0)]));
  float dist1 = distance(xy, (float2)(centers_x[hook(2, 1)], centers_y[hook(3, 1)]));
  float dist2 = distance(xy, (float2)(centers_x[hook(2, 2)], centers_y[hook(3, 2)]));
  float dist3 = distance(xy, (float2)(centers_x[hook(2, 3)], centers_y[hook(3, 3)]));
  float dist4 = distance(xy, (float2)(centers_x[hook(2, 4)], centers_y[hook(3, 4)]));
  float4 check0 = (float4)(dist1, dist2, dist3, dist4);
  float4 check1 = (float4)(dist0, dist2, dist3, dist4);
  float4 check2 = (float4)(dist0, dist1, dist3, dist4);
  float4 check3 = (float4)(dist0, dist2, dist1, dist4);
  float4 check4 = (float4)(dist0, dist2, dist3, dist1);
  int4 less0 = isless((float4)dist0, check0);
  int4 less1 = isless((float4)dist1, check1);
  int4 less2 = isless((float4)dist2, check2);
  int4 less3 = isless((float4)dist3, check3);
  if (all(less0)) {
    point_cluster_ids[hook(6, global_id)] = 0;
  } else if (all(less1)) {
    point_cluster_ids[hook(6, global_id)] = 1;
  } else if (all(less2)) {
    point_cluster_ids[hook(6, global_id)] = 2;
  } else if (all(less3)) {
    point_cluster_ids[hook(6, global_id)] = 3;
  } else {
    point_cluster_ids[hook(6, global_id)] = 4;
  }
}