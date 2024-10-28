//{"((__private float *)(&(Creg[wm][wn / 4])))":27,"Aptr":32,"Asub":31,"Asub[row + 0]":38,"Asub[row + 16]":39,"Asub[row + 32]":40,"Asub[row + 48]":41,"Asub[row]":30,"Bptr":35,"Breg":36,"Bsub":34,"Bsub[k + 0]":37,"Bsub[row]":33,"Cptr":47,"Creg":29,"Creg[wm * 4 / 1 + 0]":42,"Creg[wm * 4 / 1 + 1]":43,"Creg[wm * 4 / 1 + 2]":44,"Creg[wm * 4 / 1 + 3]":45,"Creg[wm]":28,"Dptr":46,"K":25,"KG":24,"M":22,"MG":21,"N":23,"bias":26,"im_in":0,"im_out":2,"v_B_off":3,"v_C_off":4,"v_d_0":17,"v_d_1":18,"v_fin":19,"v_fout":20,"v_imsi":9,"v_imsi_0":5,"v_imsi_1":7,"v_imso":10,"v_imso_0":6,"v_imso_1":8,"v_k_0":11,"v_k_1":12,"v_p_0":13,"v_p_1":14,"v_s_0":15,"v_s_1":16,"wg":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void conv_forward_with_bias(global const float* im_in, global const float* wg, global float* im_out, int v_B_off, int v_C_off, int v_imsi_0, int v_imso_0, int v_imsi_1, int v_imso_1, int v_imsi, int v_imso, int v_k_0, int v_k_1, int v_p_0, int v_p_1, int v_s_0, int v_s_1, int v_d_0, int v_d_1, int v_fin, int v_fout, int MG, int M, int N, int KG, int K, global const float* bias) {
  int v_num_tiles = (((K - 1) / (8 * 2) + 1) * 2);

  const int tidn = get_local_id(0);
  const int tidm = get_local_id(1);
  const int offN = 128 * get_group_id(0);
  const int offM = 128 * get_group_id(1);
  local float Asub[128][8 + 0];
  local float Bsub[8][128 + 0];
  int batch = get_global_id(2);
  global const float* Aptr = wg;
  global const float* Bptr = im_in + v_B_off * batch;
  global float* Cptr = im_out + v_C_off * batch;
  global const float* Dptr = bias;

  {
    float4 Creg[8][8 / 4];
    for (int wm = 0; wm < 8; ++wm) {
      for (int wn = 0; wn < 8; ++wn) {
        ((float*)(&(Creg[hook(29, wm)][hook(28, wn / 4)])))[hook(27, wn % 4)] = (float)0;
      }
    }

    {
      for (int t = 0; t < v_num_tiles; ++t) {
        {
          for (int la = 0; la < ((8 * 128) / (16 * 16)); ++la) {
            int tid = tidm * 16 + tidn;
            int id = la * 16 * 16 + tid;
            int row = id / 8;
            int col = id % 8;
            int tiledIndex = 8 * t + col;
            if ((offM + row) < M && tiledIndex < K) {
              Asub[hook(31, row)][hook(30, col)] = Aptr[hook(32, (offM + row) * K + tiledIndex)];
            } else {
              Asub[hook(31, row)][hook(30, col)] = (float)0.0;
            }
          }
        }

        {
          for (int lb = 0; lb < ((8 * 128) / (16 * 16)); ++lb) {
            int tid = tidm * 16 + tidn;
            int id = lb * 16 * 16 + tid;
            int col = id % 128;
            int row = id / 128;
            int tiledIndex = 8 * t + row;
            if ((offN + col) < N && tiledIndex < K) {
              int d_iter_0;
              int d_temp_0;
              int d_iter_1;
              int d_temp_1;
              int imageIndex = offN + col;
              d_iter_1 = (tiledIndex % v_k_1) * v_d_1;
              tiledIndex = tiledIndex / v_k_1;
              d_temp_1 = (imageIndex % v_imso_1) * v_s_1 - v_p_1;
              imageIndex = imageIndex / v_imso_1;
              d_iter_0 = (tiledIndex % v_k_0) * v_d_0;
              tiledIndex = tiledIndex / v_k_0;
              d_temp_0 = (imageIndex % v_imso_0) * v_s_0 - v_p_0;
              imageIndex = imageIndex / v_imso_0;
              int d_iter_im;
              d_iter_im = d_temp_0 + d_iter_0;
              tiledIndex = tiledIndex * v_imsi_0 + d_iter_im;
              d_iter_im = d_temp_1 + d_iter_1;
              tiledIndex = tiledIndex * v_imsi_1 + d_iter_im;
              Bsub[hook(34, row)][hook(33, col)] = Bptr[hook(35, tiledIndex)];
            } else {
              Bsub[hook(34, row)][hook(33, col)] = (float)0.0;
            }
          }
        }
        barrier(0x01);
        float4 Areg;
        float4 Breg[1 * 8 / 4];
        for (int k = 0; k < 8; k += 1) {
          for (int wn = 0; wn < 8 / (4 / 1); ++wn) {
            int col = tidn + wn * (4 / 1) * 16;
            Breg[hook(36, wn)].x = Bsub[hook(34, k + 0)][hook(37, col + 0)];
            Breg[hook(36, wn)].y = Bsub[hook(34, k + 0)][hook(37, col + 16)];
            Breg[hook(36, wn)].z = Bsub[hook(34, k + 0)][hook(37, col + 32)];
            Breg[hook(36, wn)].w = Bsub[hook(34, k + 0)][hook(37, col + 48)];
          }
          for (int wm = 0; wm < 8 / (4 / 1); ++wm) {
            int row = tidm + wm * (4 / 1) * 16;
            Areg.x = Asub[hook(31, row + 0)][hook(38, k + 0)];
            Areg.y = Asub[hook(31, row + 16)][hook(39, k + 0)];
            Areg.z = Asub[hook(31, row + 32)][hook(40, k + 0)];
            Areg.w = Asub[hook(31, row + 48)][hook(41, k + 0)];
            for (int wn = 0; wn < 8 / 4; ++wn) {
              Creg[hook(29, wm * 4 / 1 + 0)][hook(42, wn)].x += (float)((Areg.x * Breg[hook(36, wn * 1 + 0)].x));
              Creg[hook(29, wm * 4 / 1 + 1)][hook(43, wn)].x += (float)((Areg.y * Breg[hook(36, wn * 1 + 0)].x));
              Creg[hook(29, wm * 4 / 1 + 2)][hook(44, wn)].x += (float)((Areg.z * Breg[hook(36, wn * 1 + 0)].x));
              Creg[hook(29, wm * 4 / 1 + 3)][hook(45, wn)].x += (float)((Areg.w * Breg[hook(36, wn * 1 + 0)].x));
              Creg[hook(29, wm * 4 / 1 + 0)][hook(42, wn)].y += (float)((Areg.x * Breg[hook(36, wn * 1 + 0)].y));
              Creg[hook(29, wm * 4 / 1 + 1)][hook(43, wn)].y += (float)((Areg.y * Breg[hook(36, wn * 1 + 0)].y));
              Creg[hook(29, wm * 4 / 1 + 2)][hook(44, wn)].y += (float)((Areg.z * Breg[hook(36, wn * 1 + 0)].y));
              Creg[hook(29, wm * 4 / 1 + 3)][hook(45, wn)].y += (float)((Areg.w * Breg[hook(36, wn * 1 + 0)].y));
              Creg[hook(29, wm * 4 / 1 + 0)][hook(42, wn)].z += (float)((Areg.x * Breg[hook(36, wn * 1 + 0)].z));
              Creg[hook(29, wm * 4 / 1 + 1)][hook(43, wn)].z += (float)((Areg.y * Breg[hook(36, wn * 1 + 0)].z));
              Creg[hook(29, wm * 4 / 1 + 2)][hook(44, wn)].z += (float)((Areg.z * Breg[hook(36, wn * 1 + 0)].z));
              Creg[hook(29, wm * 4 / 1 + 3)][hook(45, wn)].z += (float)((Areg.w * Breg[hook(36, wn * 1 + 0)].z));
              Creg[hook(29, wm * 4 / 1 + 0)][hook(42, wn)].w += (float)((Areg.x * Breg[hook(36, wn * 1 + 0)].w));
              Creg[hook(29, wm * 4 / 1 + 1)][hook(43, wn)].w += (float)((Areg.y * Breg[hook(36, wn * 1 + 0)].w));
              Creg[hook(29, wm * 4 / 1 + 2)][hook(44, wn)].w += (float)((Areg.z * Breg[hook(36, wn * 1 + 0)].w));
              Creg[hook(29, wm * 4 / 1 + 3)][hook(45, wn)].w += (float)((Areg.w * Breg[hook(36, wn * 1 + 0)].w));
            }
          }
        }

        barrier(0x01);
      }
    }

    for (int wm = 0; wm < 8; ++wm) {
      int globalRow = offM + tidm + wm * 16;
      float biasval = Dptr[hook(46, globalRow)];
      for (int wn = 0; wn < 8; ++wn) {
        int globalCol = offN + tidn + wn * 16;
        if (globalRow < M && globalCol < N) {
          Cptr[hook(47, globalRow * N + globalCol)] = (float)(((float*)(&(Creg[hook(29, wm)][hook(28, wn / 4)])))[hook(27, wn % 4)] + biasval);
        }
      }
    }
  }
}