//{"data":0,"data->m_d":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct Data {
  int m_n;
  float m_x;
  float m_y;
  unsigned int m_d[3];
};

kernel void mappedStructTest(global struct Data* data) {
  data->m_n *= 2;

  float x = data->m_x;
  x = x * x;
  data->m_x = x;

  data->m_y *= 4;

  unsigned int sum = 0;
  sum += data->m_d[hook(1, 0)];
  sum += data->m_d[hook(1, 1)];
  sum += data->m_d[hook(1, 2)];

  data->m_d[hook(1, 2)] = sum;
}