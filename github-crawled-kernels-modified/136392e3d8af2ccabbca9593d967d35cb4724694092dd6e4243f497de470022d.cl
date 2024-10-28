//{"image_size":2,"in_buf":0,"out_buf":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void bufferMax(global float* in_buf, global float* out_buf, int2 image_size) {
  int2 id_glb = (int2)(get_global_id(0), get_global_id(1));

  if ((id_glb.x < image_size.x) && (id_glb.y < image_size.y)) {
    out_buf[hook(1, id_glb.y * image_size.x + id_glb.x)] = max(out_buf[hook(1, id_glb.y * image_size.x + id_glb.x)], in_buf[hook(0, id_glb.y * image_size.x + id_glb.x)]);
  }
}