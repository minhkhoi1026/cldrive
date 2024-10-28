//{"current_player":4,"fields":1,"fields_internal_size2":2,"illegalMove":3,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void set_fields_from_output(global float* output, global float* fields, unsigned int fields_internal_size2, global bool* illegalMove, int current_player) {
  if (get_global_id(0) == 0) {
    for (unsigned int i = 0; i < 9; i++) {
      if (output[hook(0, i)] > 0.5f) {
        int x = i / 3;
        int y = i % 3;
        if (fields[hook(1, x * fields_internal_size2 + y)] != 0)
          *illegalMove = true;
        else
          fields[hook(1, x * fields_internal_size2 + y)] = current_player;
        return;
      }
    }
    *illegalMove = true;
  }
}