//{"correspondences":11,"depth_map":0,"normal_map":4,"prev_normal_map":2,"prev_vertex_map":1,"rot_x":8,"rot_y":9,"rot_z":10,"translation_x":5,"translation_y":6,"translation_z":7,"vertex_map":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
kernel void findCorrespondences(read_only image2d_t depth_map, read_only image2d_t prev_vertex_map, read_only image2d_t prev_normal_map, read_only image2d_t vertex_map, read_only image2d_t normal_map, float translation_x, float translation_y, float translation_z, float rot_x, float rot_y, float rot_z, global float3* correspondences) {
  unsigned int depth = read_imageui(depth_map, sampler, (int2)(get_global_id(0), get_global_id(1))).x;
  if (depth == 0) {
    return;
  }

  float3 prev_global_vertex = (float3)((float)get_global_id(0), (float)get_global_id(1), 0.0f);
  prev_global_vertex.z = (float)(read_imageui(prev_vertex_map, sampler, (int2)(prev_global_vertex.x, prev_global_vertex.y)).x);

  float3 prev_camera_vertex;
  prev_camera_vertex.x = prev_global_vertex.x * (cos(rot_z) * cos(rot_y) + sin(rot_x) * sin(rot_y)) + prev_global_vertex.y * (-sin(rot_z) * cos(rot_x)) + prev_global_vertex.z * (sin(rot_z) * sin(rot_x) * cos(rot_x) - cos(rot_z) * sin(rot_y)) + translation_x;
  prev_camera_vertex.y = prev_global_vertex.x * (sin(rot_z) * cos(rot_y) - cos(rot_z) * sin(rot_x) * sin(rot_y)) + prev_global_vertex.y * (cos(rot_z) * cos(rot_x)) + prev_global_vertex.z * (-cos(rot_z) * sin(rot_x) * cos(rot_y) - sin(rot_z) * sin(rot_y)) + translation_y;
  prev_camera_vertex.z = prev_global_vertex.x * (cos(rot_x) * sin(rot_y)) + prev_global_vertex.y * (sin(rot_x)) + prev_global_vertex.z * (cos(rot_x) * cos(rot_y)) + translation_z;

  float3 viewer = (float3)(0.0f, 0.0f, 1.0f);
  int2 prev_image_vertex;
  prev_image_vertex.x = (viewer.z / prev_global_vertex.z) * prev_global_vertex.x - viewer.x;
  prev_image_vertex.y = (viewer.z / prev_global_vertex.z) * prev_global_vertex.y - viewer.y;

  if (prev_image_vertex.x >= 0 && prev_image_vertex.x < get_image_width(depth_map) && prev_image_vertex.y >= 0 && prev_image_vertex.y < get_image_height(depth_map)) {
    float3 camera_vertex = (float3)(prev_image_vertex.x, prev_image_vertex.y, 0.0f);
    camera_vertex.z = (float)(read_imageui(vertex_map, sampler, (int2)((int)camera_vertex.x, (int)camera_vertex.y)).x);

    float3 global_vertex;
    global_vertex.x = camera_vertex.x * (cos(rot_z) * cos(rot_y) + sin(rot_x) * sin(rot_y)) + camera_vertex.y * (sin(rot_z) * cos(rot_y) - cos(rot_z) * sin(rot_x) * sin(rot_y)) + camera_vertex.z * (cos(rot_x) * sin(rot_y)) + translation_x;
    global_vertex.y = camera_vertex.x * (-sin(rot_z) * cos(rot_x)) + camera_vertex.y * (cos(rot_z) * cos(rot_x)) + camera_vertex.z * (sin(rot_x)) + translation_y;
    global_vertex.z = camera_vertex.x * (sin(rot_z) * sin(rot_x) * cos(rot_y) - cos(rot_z) * sin(rot_y)) + camera_vertex.y * (-cos(rot_z) * sin(rot_x) * cos(rot_y) - sin(rot_z) * sin(rot_y)) + camera_vertex.z * (cos(rot_x) * cos(rot_y)) + translation_z;

    float3 camera_normal = (float3)(prev_image_vertex.x, prev_image_vertex.y, 0.0f);
    camera_normal.z = (float)(read_imageui(normal_map, sampler, (int2)((int)camera_normal.x, (int)camera_normal.y)).x);

    float3 global_normal;
    global_normal.x = camera_normal.x * (cos(rot_z) * cos(rot_y) + sin(rot_x) * sin(rot_y)) + camera_normal.y * (sin(rot_z) * cos(rot_y) - cos(rot_z) * sin(rot_x) * sin(rot_y)) + camera_normal.z * (cos(rot_x) * sin(rot_y));
    global_normal.y = camera_normal.x * (-sin(rot_z) * cos(rot_x)) + camera_normal.y * (cos(rot_z) * cos(rot_x)) + camera_normal.z * (sin(rot_x));
    global_normal.z = camera_normal.x * (sin(rot_z) * sin(rot_x) * cos(rot_y) - cos(rot_z) * sin(rot_y)) + camera_normal.y * (-cos(rot_z) * sin(rot_x) * cos(rot_y) - sin(rot_z) * sin(rot_y)) + camera_normal.z * (cos(rot_x) * cos(rot_y));

    const unsigned int distance_threshold = 1;
    const float normal_threshold = 1.0f;
    float3 prev_global_normal = (float3)((float)get_global_id(0), (float)get_global_id(1), 0.0f);
    prev_global_normal.z = (float)(read_imageui(prev_normal_map, sampler, (int2)(prev_global_normal.x, prev_global_normal.y)).x);

    if (length(global_vertex - prev_global_vertex) < distance_threshold && fabs(dot(global_normal, prev_global_normal)) < normal_threshold) {
      unsigned int width = get_image_width(depth_map);
      unsigned int x = get_global_id(0);
      unsigned int y = get_global_id(1);
      unsigned int index = y * width + x;
      correspondences[hook(11, index)] = global_vertex;
    }
  }
}