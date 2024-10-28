//{"blend":4,"height":3,"inputImage":0,"output":1,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void EvaluateRay(const global float4* inputImage, global float4* output, int in_RayNum, int2 imgSize, unsigned int blend) {
  int LightScreenPosX = imgSize.x / 2;
  int LightScreenPosY = imgSize.y / 2;
  int god_rays_bunch_size = (int)15;

  in_RayNum *= god_rays_bunch_size;

  for (int i = in_RayNum; i < in_RayNum + god_rays_bunch_size; i++) {
    float _decay = (float)-0.01f;
    float _Weight = (float)3.0f;
    float _InvExposure = (float)1.f / .9f;
    float _fThreshold = (float)1.8f;

    int x_last = imgSize.x - 1;

    int y_last = imgSize.y - 1;

    int x = LightScreenPosX;

    int y = LightScreenPosY;

    int x_s = LightScreenPosX;

    int y_s = LightScreenPosY;
    int x_dst = 0;
    int y_dst = 0;
    int x_dst_s = 0;
    int y_dst_s = 0;

    int Ray = i;
    if (Ray < x_last) {
      if (y < 0 && (x < 0 || Ray != 0)) {
        break;
      }

      x_dst = Ray;
      y_dst = 0;
      x_dst_s = Ray - 1;
      y_dst_s = 0;

      if (Ray == 0) {
        x_dst_s = 0;
        y_dst_s = 1;
      }
    }

    else {
      Ray -= x_last;

      if (Ray < y_last) {
        if (x > x_last && (y < 0 || Ray != 0)) {
          break;
        }

        x_dst = x_last;
        y_dst = Ray;
        x_dst_s = x_last;
        y_dst_s = Ray - 1;

        if (Ray == 0) {
          x_dst_s = x_last - 1;
          y_dst_s = 0;
        }
      }

      else {
        Ray -= y_last;
        if (Ray < x_last) {
          if (y > y_last && (x > x_last || Ray != 0)) {
            break;
          }
          x_dst = x_last - Ray;
          y_dst = y_last;
          x_dst_s = x_last - Ray + 1;
          y_dst_s = y_last;
          if (Ray == 0) {
            x_dst_s = x_last;
            y_dst_s = y_last - 1;
          }
        }

        else {
          Ray -= x_last;
          if (Ray < y_last) {
            if (x < 0 && (y > y_last || Ray != 0)) {
              break;
            }
            x_dst = 0;
            y_dst = y_last - Ray;
            x_dst_s = 0;
            y_dst_s = y_last - Ray + 1;
            if (Ray == 0) {
              x_dst_s = 1;
              y_dst_s = y_last;
            }
          } else {
            break;
          }
        }
      }
    }

    int dx = x_dst - x;
    int dy = y_dst - y;
    int dx_s = x_dst_s - x;
    int dy_s = y_dst_s - y;
    int xstep = dx > 0 ? 1 : 0;
    int ystep = dy > 0 ? 1 : 0;
    int xstep_s = dx_s > 0 ? 1 : 0;
    int ystep_s = dy_s > 0 ? 1 : 0;
    if (dx < 0) {
      dx = -dx;
      xstep = -1;
    }
    if (dy < 0) {
      dy = -dy;
      ystep = -1;
    }
    if (dx_s < 0) {
      dx_s = -dx_s;
      xstep_s = -1;
    }
    if (dy_s < 0) {
      dy_s = -dy_s;
      ystep_s = -1;
    }

    float FixedDecay = 0.f;
    int di = 0;
    int di_s = 0;
    int steps = 0;

    if (dx >= dy) {
      FixedDecay = exp(_decay * sqrt(convert_float(dx) * convert_float(dx) + convert_float(dy) * convert_float(dy)) / convert_float(dx));

      di = 2 * dy - dx;

      if (x < 0 || x > x_last) {
        int dx_crop = x < 0 ? -x : x - x_last;

        int new_di = di + (dx_crop - 1) * 2 * dy;

        int dy_crop = new_di / (2 * dx);

        new_di -= dy_crop * 2 * dx;

        if (new_di > 0) {
          dy_crop++;
        }

        x += xstep * dx_crop;
        y += ystep * dy_crop;
        di += dx_crop * 2 * dy - dy_crop * 2 * dx;
      }

      if (y < 0 || y > y_last) {
        int dy_crop = y < 0 ? -y : y - y_last;

        int new_di = di - (dy_crop - 1) * 2 * dx;

        int dx_crop = 1 - new_di / (2 * dy);

        if (new_di % (2 * dy) != 0 && new_di < 0) {
          dx_crop++;
        }

        x += xstep * dx_crop;
        y += ystep * dy_crop;
        di += dx_crop * 2 * dy - dy_crop * 2 * dx;
      }

      steps = abs(x_dst - x);
    }

    else {
      FixedDecay = exp(_decay * sqrt(convert_float(dx) * convert_float(dx) + convert_float(dy) * convert_float(dy)) / convert_float(dy));

      di = 2 * dx - dy;

      if (y < 0 || y > y_last) {
        int dy_crop = y < 0 ? -y : y - y_last;

        int new_di = di + (dy_crop - 1) * 2 * dx;

        int dx_crop = new_di / (2 * dy);

        new_di -= dx_crop * 2 * dy;

        if (new_di > 0) {
          dx_crop++;
        }

        x += xstep * dx_crop;
        y += ystep * dy_crop;
        di += dy_crop * 2 * dx - dx_crop * 2 * dy;
      }

      if (x < 0 || x > x_last) {
        int dx_crop = x < 0 ? -x : x - x_last;

        int new_di = di - (dx_crop - 1) * 2 * dy;

        int dy_crop = 1 - new_di / (2 * dx);

        if (new_di % (2 * dx) != 0 && new_di < 0) {
          dy_crop++;
        }

        x += xstep * dx_crop;
        y += ystep * dy_crop;
        di += dy_crop * 2 * dx - dx_crop * 2 * dy;
      }

      steps = abs(y_dst - y);
    }

    int steps_begin = 0;
    int steps_lsat = 0;

    if (dx_s >= dy_s) {
      di_s = 2 * dy_s - dx_s;
      if (x_s < 0 || x_s > x_last) {
        int dx_crop_s = x_s < 0 ? -x_s : x_s - x_last;
        int new_di_s = di_s + (dx_crop_s - 1) * 2 * dy_s;
        int dy_crop_s = new_di_s / (2 * dx_s);
        new_di_s -= dy_crop_s * 2 * dx_s;
        if (new_di_s > 0) {
          dy_crop_s++;
        }
        x_s += xstep_s * dx_crop_s;
        y_s += ystep_s * dy_crop_s;
        di_s += dx_crop_s * 2 * dy_s - dy_crop_s * 2 * dx_s;
      }
      if (y_s < 0 || y_s > y_last) {
        int dy_crop_s = y_s < 0 ? -y_s : y_s - y_last;
        int new_di_s = di_s - (dy_crop_s - 1) * 2 * dx_s;
        int dx_crop_s = 1 - new_di_s / (2 * dy_s);
        if (new_di_s % (2 * dy_s) != 0 && new_di_s < 0) {
          dx_crop_s++;
        }
        x_s += xstep_s * dx_crop_s;
        y_s += ystep_s * dy_crop_s;
        di_s += dx_crop_s * 2 * dy_s - dy_crop_s * 2 * dx_s;
      }

      steps_begin = xstep_s * (x - x_s);

      if (steps_begin > 0) {
        di_s += 2 * steps_begin * dy_s;
        x_s = x;

        if (di_s > 2 * dy_s) {
          di_s -= 2 * dx_s;

          y_s += ystep_s;
        }
      }

      steps_lsat = abs(x_dst_s - x_s) - steps_begin;
    } else {
      di_s = 2 * dx_s - dy_s;
      if (y_s < 0 || y_s > y_last) {
        int dy_crop_s = y_s < 0 ? -y_s : y_s - y_last;
        int new_di_s = di_s + (dy_crop_s - 1) * 2 * dx_s;
        int dx_crop_s = new_di_s / (2 * dy_s);
        new_di_s -= dx_crop_s * 2 * dy_s;
        if (new_di_s > 0) {
          dx_crop_s++;
        }
        x_s += xstep_s * dx_crop_s;
        y_s += ystep_s * dy_crop_s;
        di_s += dy_crop_s * 2 * dx_s - dx_crop_s * 2 * dy_s;
      }
      if (x_s < 0 || x_s > x_last) {
        int dx_crop_s = x_s < 0 ? -x_s : x_s - x_last;
        int new_di_s = di_s - (dx_crop_s - 1) * 2 * dy_s;
        int dy_crop_s = 1 - new_di_s / (2 * dx_s);
        if (new_di_s % (2 * dx_s) != 0 && new_di_s < 0) {
          dy_crop_s++;
        }
        x_s += xstep_s * dx_crop_s;
        y_s += ystep_s * dy_crop_s;
        di_s += dy_crop_s * 2 * dx_s - dx_crop_s * 2 * dy_s;
      }

      steps_begin = ystep_s * (y - y_s);

      if (steps_begin > 0) {
        di_s += 2 * steps_begin * dx_s;

        y_s = y;
        if (di_s > 2 * dx_s) {
          di_s -= 2 * dy_s;
          x_s += ystep_s;
        }
      }

      steps_lsat = abs(y_dst_s - y_s) - steps_begin;
    }

    float4 Weight_128 = _Weight;
    float4 Decay_128 = FixedDecay;
    FixedDecay = 1.f - FixedDecay;
    float4 nDecay_128 = FixedDecay;
    float4 NExposure_128 = _InvExposure;
    float4 summ_128 = 0.0f;

    float4 One_128 = _fThreshold;

    float4 sample_128 = inputImage[hook(0, x + y * imgSize.x)];

    sample_128 = sample_128 * NExposure_128;

    { summ_128 = sample_128 * nDecay_128; }

    if (x != x_s || y != y_s || (x_dst == 0 && y_dst == 0 && x == LightScreenPosX && y == LightScreenPosY)) {
      float4 answer_128 = summ_128 * Weight_128;

      answer_128 = answer_128 + sample_128;

      output[hook(1, y * imgSize.x + x)] = answer_128;
    }

    for (int i = 0; i < steps; i++) {
      if (dx >= dy) {
        x += xstep;
        if (di >= 0) {
          y += ystep;
          di -= 2 * dx;
        }
        di += 2 * dy;
      } else {
        y += ystep;
        if (di >= 0) {
          x += xstep;
          di -= 2 * dy;
        }
        di += 2 * dx;
      }

      if (steps_begin >= 0) {
        if (dx_s >= dy_s) {
          x_s += xstep_s;
          if (di_s >= 0) {
            y_s += ystep_s;
            di_s -= 2 * dx_s;
          }
          di_s += 2 * dy_s;
        } else {
          y_s += ystep_s;
          if (di_s >= 0) {
            x_s += xstep_s;
            di_s -= 2 * dy_s;
          }
          di_s += 2 * dx_s;
        }
      } else {
        steps_begin++;
      }

      sample_128 = inputImage[hook(0, y * imgSize.x + x)];

      summ_128 = summ_128 * Decay_128;

      sample_128 = sample_128 * NExposure_128;

      {
        sample_128 = sample_128 * nDecay_128;
        summ_128 = summ_128 + sample_128;
      }

      if (x != x_s || y != y_s || i >= steps_lsat) {
        float4 answer_128 = summ_128 * Weight_128;
        sample_128 = inputImage[hook(0, y * imgSize.x + x)];

        if (blend == 1) {
          answer_128 = answer_128 + sample_128;
          output[hook(1, y * imgSize.x + x)] = answer_128;
        } else {
          output[hook(1, y * imgSize.x + x)] = answer_128;
        }
      }
    }
  }
};

kernel void GodRays(const global float4* inputImage, global float4* output, const int width, const int height, unsigned int blend) {
  int2 imgSize = {width, height};

  int in_RayNum = get_global_id(0);

  EvaluateRay(inputImage, output, in_RayNum, imgSize, blend);
}