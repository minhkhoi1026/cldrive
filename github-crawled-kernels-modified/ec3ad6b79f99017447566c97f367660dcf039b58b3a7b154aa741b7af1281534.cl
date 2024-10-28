//{"A_matrix_2D_value":9,"A_matrix_2D_values":0,"DATA_D":7,"DATA_H":6,"DATA_W":5,"FILTER_SIZE":8,"Phase_Certainties":4,"Phase_Differences":2,"Phase_Gradients":3,"h_vector_2D_value":10,"h_vector_2D_values":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
int Calculate2DIndex(int x, int y, int DATA_W) {
  return x + y * DATA_W;
}

int Calculate3DIndex(int x, int y, int z, int DATA_W, int DATA_H) {
  return x + y * DATA_W + z * DATA_W * DATA_H;
}

int Calculate4DIndex(int x, int y, int z, int t, int DATA_W, int DATA_H, int DATA_D) {
  return x + y * DATA_W + z * DATA_W * DATA_H + t * DATA_W * DATA_H * DATA_D;
}

void GetParameterIndices(int* i, int* j, int parameter) {
  switch (parameter) {
    case 0:
      *i = 0;
      *j = 0;
      break;

    case 1:
      *i = 3;
      *j = 0;
      break;

    case 2:
      *i = 4;
      *j = 0;
      break;

    case 3:
      *i = 5;
      *j = 0;
      break;

    case 4:
      *i = 3;
      *j = 3;
      break;

    case 5:
      *i = 4;
      *j = 3;
      break;

    case 6:
      *i = 5;
      *j = 3;
      break;

    case 7:
      *i = 4;
      *j = 4;
      break;

    case 8:
      *i = 5;
      *j = 4;
      break;

    case 9:
      *i = 5;
      *j = 5;
      break;

    case 10:
      *i = 1;
      *j = 1;
      break;

    case 11:
      *i = 6;
      *j = 1;
      break;

    case 12:
      *i = 7;
      *j = 1;
      break;

    case 13:
      *i = 8;
      *j = 1;
      break;

    case 14:
      *i = 6;
      *j = 6;
      break;

    case 15:
      *i = 7;
      *j = 6;
      break;

    case 16:
      *i = 8;
      *j = 6;
      break;

    case 17:
      *i = 7;
      *j = 7;
      break;

    case 18:
      *i = 8;
      *j = 7;
      break;

    case 19:
      *i = 8;
      *j = 8;
      break;

    case 20:
      *i = 2;
      *j = 2;
      break;

    case 21:
      *i = 9;
      *j = 2;
      break;

    case 22:
      *i = 10;
      *j = 2;
      break;

    case 23:
      *i = 11;
      *j = 2;
      break;

    case 24:
      *i = 9;
      *j = 9;
      break;

    case 25:
      *i = 10;
      *j = 9;
      break;

    case 26:
      *i = 11;
      *j = 9;
      break;

    case 27:
      *i = 10;
      *j = 10;
      break;

    case 28:
      *i = 11;
      *j = 10;
      break;

    case 29:
      *i = 11;
      *j = 11;
      break;

    default:
      *i = 0;
      *j = 0;
      break;
  }
}

kernel void CalculateAMatrixAndHVector2DValuesY(global float* A_matrix_2D_values, global float* h_vector_2D_values, global const float* Phase_Differences, global const float* Phase_Gradients, global const float* Phase_Certainties, private int DATA_W, private int DATA_H, private int DATA_D, private int FILTER_SIZE) {
  int y = get_local_id(0);
  int z = get_group_id(1);

  if (((y >= (FILTER_SIZE - 1) / 2) && (y < DATA_H - (FILTER_SIZE - 1) / 2)) && ((z >= (FILTER_SIZE - 1) / 2) && (z < DATA_D - (FILTER_SIZE - 1) / 2))) {
    float yf, zf;
    int matrix_element_idx, vector_element_idx;
    float A_matrix_2D_value[10], h_vector_2D_value[4];

    yf = (float)y - ((float)DATA_H - 1.0f) * 0.5f;
    zf = (float)z - ((float)DATA_D - 1.0f) * 0.5f;

    A_matrix_2D_value[hook(9, 0)] = 0.0f;
    A_matrix_2D_value[hook(9, 1)] = 0.0f;
    A_matrix_2D_value[hook(9, 2)] = 0.0f;
    A_matrix_2D_value[hook(9, 3)] = 0.0f;
    A_matrix_2D_value[hook(9, 4)] = 0.0f;
    A_matrix_2D_value[hook(9, 5)] = 0.0f;
    A_matrix_2D_value[hook(9, 6)] = 0.0f;
    A_matrix_2D_value[hook(9, 7)] = 0.0f;
    A_matrix_2D_value[hook(9, 8)] = 0.0f;
    A_matrix_2D_value[hook(9, 9)] = 0.0f;

    h_vector_2D_value[hook(10, 0)] = 0.0f;
    h_vector_2D_value[hook(10, 1)] = 0.0f;
    h_vector_2D_value[hook(10, 2)] = 0.0f;
    h_vector_2D_value[hook(10, 3)] = 0.0f;

    for (int x = (FILTER_SIZE - 1) / 2; x < (DATA_W - (FILTER_SIZE - 1) / 2); x++) {
      float xf = (float)x - ((float)DATA_W - 1.0f) * 0.5f;
      int idx = Calculate3DIndex(x, y, z, DATA_W, DATA_H);

      float phase_difference = Phase_Differences[hook(2, idx)];
      float phase_gradient = Phase_Gradients[hook(3, idx)];
      float phase_certainty = Phase_Certainties[hook(4, idx)];
      float c_pg_pg = phase_certainty * phase_gradient * phase_gradient;
      float c_pg_pd = phase_certainty * phase_gradient * phase_difference;

      A_matrix_2D_value[hook(9, 0)] += c_pg_pg;
      A_matrix_2D_value[hook(9, 1)] += xf * c_pg_pg;
      A_matrix_2D_value[hook(9, 2)] += yf * c_pg_pg;
      A_matrix_2D_value[hook(9, 3)] += zf * c_pg_pg;
      A_matrix_2D_value[hook(9, 4)] += xf * xf * c_pg_pg;
      A_matrix_2D_value[hook(9, 5)] += xf * yf * c_pg_pg;
      A_matrix_2D_value[hook(9, 6)] += xf * zf * c_pg_pg;
      A_matrix_2D_value[hook(9, 7)] += yf * yf * c_pg_pg;
      A_matrix_2D_value[hook(9, 8)] += yf * zf * c_pg_pg;
      A_matrix_2D_value[hook(9, 9)] += zf * zf * c_pg_pg;

      h_vector_2D_value[hook(10, 0)] += c_pg_pd;
      h_vector_2D_value[hook(10, 1)] += xf * c_pg_pd;
      h_vector_2D_value[hook(10, 2)] += yf * c_pg_pd;
      h_vector_2D_value[hook(10, 3)] += zf * c_pg_pd;
    }

    matrix_element_idx = y + z * DATA_H + 10 * DATA_H * DATA_D;
    A_matrix_2D_values[hook(0, matrix_element_idx)] = A_matrix_2D_value[hook(9, 0)];
    matrix_element_idx += DATA_H * DATA_D;
    A_matrix_2D_values[hook(0, matrix_element_idx)] = A_matrix_2D_value[hook(9, 1)];
    matrix_element_idx += DATA_H * DATA_D;
    A_matrix_2D_values[hook(0, matrix_element_idx)] = A_matrix_2D_value[hook(9, 2)];
    matrix_element_idx += DATA_H * DATA_D;
    A_matrix_2D_values[hook(0, matrix_element_idx)] = A_matrix_2D_value[hook(9, 3)];
    matrix_element_idx += DATA_H * DATA_D;
    A_matrix_2D_values[hook(0, matrix_element_idx)] = A_matrix_2D_value[hook(9, 4)];
    matrix_element_idx += DATA_H * DATA_D;
    A_matrix_2D_values[hook(0, matrix_element_idx)] = A_matrix_2D_value[hook(9, 5)];
    matrix_element_idx += DATA_H * DATA_D;
    A_matrix_2D_values[hook(0, matrix_element_idx)] = A_matrix_2D_value[hook(9, 6)];
    matrix_element_idx += DATA_H * DATA_D;
    A_matrix_2D_values[hook(0, matrix_element_idx)] = A_matrix_2D_value[hook(9, 7)];
    matrix_element_idx += DATA_H * DATA_D;
    A_matrix_2D_values[hook(0, matrix_element_idx)] = A_matrix_2D_value[hook(9, 8)];
    matrix_element_idx += DATA_H * DATA_D;
    A_matrix_2D_values[hook(0, matrix_element_idx)] = A_matrix_2D_value[hook(9, 9)];

    vector_element_idx = y + z * DATA_H + DATA_H * DATA_D;
    h_vector_2D_values[hook(1, vector_element_idx)] = h_vector_2D_value[hook(10, 0)];
    vector_element_idx += 5 * DATA_H * DATA_D;
    h_vector_2D_values[hook(1, vector_element_idx)] = h_vector_2D_value[hook(10, 1)];
    vector_element_idx += DATA_H * DATA_D;
    h_vector_2D_values[hook(1, vector_element_idx)] = h_vector_2D_value[hook(10, 2)];
    vector_element_idx += DATA_H * DATA_D;
    h_vector_2D_values[hook(1, vector_element_idx)] = h_vector_2D_value[hook(10, 3)];
  }
}