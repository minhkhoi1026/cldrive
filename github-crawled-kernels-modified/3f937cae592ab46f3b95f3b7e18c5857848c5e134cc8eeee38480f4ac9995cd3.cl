//{"addition_array":8,"brick_extent":3,"brick_outer_dimension":9,"data_point_radius":11,"min_check":5,"point_data":0,"point_data_count":2,"point_data_offset":1,"pool_cluster":4,"search_radius":10,"sum_check":6,"variance_check":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void voxelize(global float4* point_data, global int* point_data_offset, global int* point_data_count, global float* brick_extent, global float* pool_cluster, global float* min_check, global float* sum_check, global float* variance_check, local float* addition_array, unsigned int brick_outer_dimension, float search_radius, float data_point_radius) {
  int4 id_loc = (int4)(get_local_id(0), get_local_id(1), get_local_id(2), 0);

  int id_output = id_loc.x + id_loc.y * brick_outer_dimension + id_loc.z * brick_outer_dimension * brick_outer_dimension;

  int id_wg = get_global_id(2) / brick_outer_dimension;

  float4 xyzw;
  float sample_interdistance = (brick_extent[hook(3, id_wg * 6 + 1)] - brick_extent[hook(3, id_wg * 6 + 0)]) / ((float)brick_outer_dimension - 1.0f);
  xyzw.x = brick_extent[hook(3, id_wg * 6 + 0)] + (float)id_loc.x * sample_interdistance;
  xyzw.y = brick_extent[hook(3, id_wg * 6 + 2)] + (float)id_loc.y * sample_interdistance;
  xyzw.z = brick_extent[hook(3, id_wg * 6 + 4)] + (float)id_loc.z * sample_interdistance;
  xyzw.w = 0.0f;

  float4 point;
  float sum_intensity = 0.0f;
  float sum_distance = 0.0f;
  float dst;

  if (1) {
    for (int i = 0; i < point_data_count[hook(2, id_wg)]; i++) {
      point = point_data[hook(0, point_data_offset[ihook(1, id_wg) + i)];
      dst = fast_distance(xyzw.xyz, point.xyz);

      if (dst <= 0.0f) {
        sum_intensity = point.w;
        sum_distance = 1.0f;
        break;
      }

      if (dst <= search_radius) {
        sum_intensity += native_divide(point.w, dst);
        sum_distance += native_divide(1.0f, dst);
      }
    }

    if (sum_distance > 0) {
      xyzw.w = sum_intensity / sum_distance;
    }
  }
  if (0) {
    float fill_ratio = min(1.0f, (float)point_data_count[hook(2, id_wg)] * (4.0f * 3.14159265358979323846264338327950288f / 3.0f) * pow(0.5f * data_point_radius, 3.0f) / pow(sample_interdistance * 7, 3.0f));

    for (int i = 0; i < point_data_count[hook(2, id_wg)]; i++) {
      point = point_data[hook(0, point_data_offset[ihook(1, id_wg) + i)];
      dst = fast_distance(xyzw.xyz, point.xyz);

      if (dst <= 0.0f) {
        sum_intensity = point.w;
        sum_distance = 1.0f;
        break;
      }

      if (dst <= search_radius) {
        sum_intensity += native_divide(point.w, dst);
        sum_distance += native_divide(1.0f, dst);
      }
    }

    if (sum_distance > 0) {
      xyzw.w = sum_intensity * fill_ratio / sum_distance;
    }
  }

  pool_cluster[hook(4, id_wg * brick_outer_dimension * brick_outer_dimension * brick_outer_dimension + id_output)] = xyzw.w;

  addition_array[hook(8, id_output)] = xyzw.w;

  barrier(0x01);

  for (unsigned int i = 256; i > 0; i >>= 1) {
    if (id_output < i) {
      if (addition_array[hook(8, id_output)] < addition_array[hook(8, i + id_output)]) {
        addition_array[hook(8, id_output)] = addition_array[hook(8, i + id_output)];
      }
    }

    barrier(0x01);
  }

  if (id_output == 0) {
    min_check[hook(5, id_wg)] = addition_array[hook(8, 0)];
  }

  addition_array[hook(8, id_output)] = xyzw.w;

  barrier(0x01);

  for (unsigned int i = 256; i > 0; i >>= 1) {
    if (id_output < i) {
      if (addition_array[hook(8, id_output)] < addition_array[hook(8, i + id_output)]) {
        addition_array[hook(8, id_output)] = addition_array[hook(8, i + id_output)];
      }

      addition_array[hook(8, id_output)] += addition_array[hook(8, i + id_output)];
    }

    barrier(0x01);
  }

  if (id_output == 0) {
    sum_check[hook(6, id_wg)] = addition_array[hook(8, 0)];
  }

  float average = addition_array[hook(8, 0)] / (float)(brick_outer_dimension * brick_outer_dimension * brick_outer_dimension);

  barrier(0x01);
  addition_array[hook(8, id_output)] = (xyzw.w - average) * (xyzw.w - average);

  barrier(0x01);

  for (unsigned int i = 256; i > 0; i >>= 1) {
    if (id_output < i) {
      addition_array[hook(8, id_output)] += addition_array[hook(8, i + id_output)];
    }

    barrier(0x01);
  }

  if (id_output == 0) {
    variance_check[hook(7, id_wg)] = addition_array[hook(8, 0)] / (float)(brick_outer_dimension * brick_outer_dimension * brick_outer_dimension);
  }
}