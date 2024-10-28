//{"centers":1,"now":4,"num_centers":3,"times":2,"vertices":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ripple(global float* vertices, global float* centers, global long* times, int num_centers, long now) {
  unsigned int id = get_global_id(0);
  unsigned int offset = id * 3;
  float x = vertices[hook(0, offset)];
  float y = vertices[hook(0, offset + 1)];
  float z = 0.0;

  for (int i = 0; i < num_centers; ++i) {
    if (times[hook(2, i)] != 0) {
      float dx = x - centers[hook(1, i * 2)];
      float dy = y - centers[hook(1, i * 2 + 1)];
      float d = sqrt(dx * dx + dy * dy);
      float elapsed = (now - times[hook(2, i)]) / 1000.0;
      float r = elapsed * 0.5;
      float delta = r - d;
      z += 0.1 * exp(-2.0 * r * r) * exp(-50.0 * delta * delta) * cos(10.0 * 3.14159265358979323846264338327950288f * delta);
    }
  }
  vertices[hook(0, offset + 2)] = z;
}