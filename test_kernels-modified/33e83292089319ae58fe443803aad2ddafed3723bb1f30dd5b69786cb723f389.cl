//{"X":0,"Y":1,"height":3,"maps":4,"samples":5,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void SMS(global float* X, global float* Y, unsigned int width, unsigned int height, unsigned int maps, unsigned int samples) {
  unsigned int target_element = get_global_id(0);
  unsigned int target_skid = target_element / (width * height);

  unsigned int target_sample = target_skid / maps;
  unsigned int target_map = target_skid % maps;

  unsigned int source_element = target_element % (width * height);

  Y[hook(1, target_element)] = X[hook(0, (target_map * width * height * samples) + (target_sample * width * height) + source_element)];
}