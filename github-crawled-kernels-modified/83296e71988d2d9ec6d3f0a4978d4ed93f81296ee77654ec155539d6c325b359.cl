//{"p_mat":3,"u":1,"x_prime":2,"x_vec":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vec_reflect(float4 x_vec, float4 u, global float4* x_prime) {
  float4 p_mat[4];

  u *= 1.41421356237309504880168872420969808f / length(u);

  p_mat[hook(3, 0)] = (float4)(1.0f, 0.0f, 0.0f, 0.0f) - (u * u.x);
  p_mat[hook(3, 1)] = (float4)(0.0f, 1.0f, 0.0f, 0.0f) - (u * u.y);
  p_mat[hook(3, 2)] = (float4)(0.0f, 0.0f, 1.0f, 0.0f) - (u * u.z);
  p_mat[hook(3, 3)] = (float4)(0.0f, 0.0f, 0.0f, 1.0f) - (u * u.w);

  x_prime[hook(2, 0)].x = dot(p_mat[hook(3, 0)], x_vec);
  x_prime[hook(2, 0)].y = dot(p_mat[hook(3, 1)], x_vec);
  x_prime[hook(2, 0)].z = dot(p_mat[hook(3, 2)], x_vec);
  x_prime[hook(2, 0)].w = dot(p_mat[hook(3, 3)], x_vec);
}