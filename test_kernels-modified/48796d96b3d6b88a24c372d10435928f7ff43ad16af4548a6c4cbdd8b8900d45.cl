//{"cam_dir":4,"cam_pos":5,"image":8,"light_count":7,"lights":6,"map":0,"map_dim":1,"projection_matrix":3,"resolution":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void printer(global char* map, global int3* map_dim, global int2* resolution, global float3* projection_matrix, global float2* cam_dir, global float3* cam_pos, global float* lights, global int* light_count, write_only image2d_t image) {
  size_t id = get_global_id(0);

  if (id == 0) {
    printf("MAP: %i, %i, %i, %i", map[hook(0, 0)], map[hook(0, 1)], map[hook(0, 2)], map[hook(0, 3)]);
    printf("MAP_DIMENSIONS: %i, %i, %i", map_dim[hook(1, 0)].x, map_dim[hook(1, 0)].y, map_dim[hook(1, 0)].z);
    printf("RESOLUTION: %i, %i", resolution[hook(2, 0)].x, resolution[hook(2, 0)].y);
    printf("PROJECTION_MATRIX: %f, %f, %f", projection_matrix[hook(3, 0)].x, projection_matrix[hook(3, 0)].y, projection_matrix[hook(3, 0)].z);
    printf("CAMERA_DIRECTION: %f, %f", cam_dir[hook(4, 0)].x, cam_dir[hook(4, 0)].y);
    printf("CAMERA_POSITION: %f, %f, %f", cam_pos[hook(5, 0)].x, cam_pos[hook(5, 0)].y, cam_pos[hook(5, 0)].z);
    printf("LIGHTS: %f, %f, %f, %f, %f, %f, %f, %f, %f, %f", lights[hook(6, 0)], lights[hook(6, 1)], lights[hook(6, 2)], lights[hook(6, 3)], lights[hook(6, 4)], lights[hook(6, 5)], lights[hook(6, 6)], lights[hook(6, 7)], lights[hook(6, 8)], lights[hook(6, 9)]);
    printf("LIGHT_COUNT: %i", light_count);
  }

  return;
}