//{"addition_array":2,"direction":4,"id_glb":7,"id_loc":5,"local_size":6,"source":0,"source_dim":8,"source_sampler":3,"target":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void integrateImage(read_only image2d_t source, write_only image2d_t target, local float* addition_array, sampler_t source_sampler, int direction) {
  int id_loc[2];
  id_loc[hook(5, 0)] = get_local_id(0);
  id_loc[hook(5, 1)] = get_local_id(1);

  int local_size[2];
  local_size[hook(6, 0)] = get_local_size(0);
  local_size[hook(6, 1)] = get_local_size(1);

  int id_glb[2];
  id_glb[hook(7, 0)] = get_global_id(0);
  id_glb[hook(7, 1)] = get_global_id(1);

  int source_dim[2];
  source_dim[hook(8, 0)] = get_image_dim(source).x;
  source_dim[hook(8, 1)] = get_image_dim(source).y;

  int2 id_out = (int2)(id_glb[hook(7, 0)] / local_size[hook(6, 0)], id_glb[hook(7, 1)] / local_size[hook(6, 1)]);

  if (id_glb[hook(7, direction)] < source_dim[hook(8, direction)]) {
    addition_array[hook(2, id_loc[dhook(5, direction))] = read_imagef(source, source_sampler, (int2)(id_glb[hook(7, 0)], id_glb[hook(7, 1)])).w;
  } else {
    addition_array[hook(2, id_loc[dhook(5, direction))] = 0.0f;
  }

  if (id_glb[hook(7, direction)] < source_dim[hook(8, direction)]) {
    barrier(0x01);

    for (unsigned int i = local_size[hook(6, direction)] / 2; i > 0; i >>= 1) {
      if (id_loc[hook(5, direction)] < i) {
        addition_array[hook(2, id_loc[dhook(5, direction))] += addition_array[hook(2, i + id_loc[dhook(5, direction))];
      }

      barrier(0x01);
    }

    float4 sample = (float4)(addition_array[hook(2, 0)]);

    if (id_loc[hook(5, direction)] == 0) {
      write_imagef(target, id_out, sample);
    }
  } else {
    float4 sample = (float4)(addition_array[hook(2, 0)]);

    if (id_loc[hook(5, direction)] == 0) {
      write_imagef(target, id_out, sample);
    }
  }
}