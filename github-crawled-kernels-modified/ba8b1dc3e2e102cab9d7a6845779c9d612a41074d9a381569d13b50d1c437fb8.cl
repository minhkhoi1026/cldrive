//{"signs":1,"size":2,"stride":3,"v":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void inverse_signs(global float* v, global float* signs, unsigned int size, unsigned int stride) {
  unsigned int glb_id_x = get_global_id(0);
  unsigned int glb_id_y = get_global_id(1);

  if ((glb_id_x < size) && (glb_id_y < size))
    v[hook(0, glb_id_x * stride + glb_id_y)] *= signs[hook(1, glb_id_x)];
}