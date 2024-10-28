//{"buy_wait":3,"buy_wait_after_stop_loss":8,"input":11,"input_len":14,"macd_buy_trip":7,"market_classification":10,"markup":4,"orders":13,"quartile":9,"score":12,"shares":0,"stop_age":6,"stop_loss":5,"wll":1,"wls":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fitness(global float* shares, global unsigned int* wll, global unsigned int* wls, global unsigned int* buy_wait, global float* markup, global float* stop_loss, global float* stop_age, global float* macd_buy_trip, global unsigned int* buy_wait_after_stop_loss, global unsigned int* quartile, global unsigned int* market_classification, global float* input, global float* score, global float* orders, const unsigned int input_len) {
 private
  int gid = get_global_id(0);

 private
  float ema_short_mult = (2.0 / (wls[hook(2, gid)] + 1));
 private
  float ema_long_mult = (2.0 / (wll[hook(1, gid)] + 1));
 private
  float ema_short = 0;
 private
  float ema_long = 0;
 private
  float macd_pct = 0.0;
 private
  float balance = 10000.00;
 private
  float wins = 0.0;
 private
  float loss = 0.0;
 private
  unsigned int buy_delay = 1000;
 private
  float t = 0.0;
 private
  unsigned int orders_index = 0;
 private
  unsigned int last_orders_index = 0;
 private
  bool sell = false;
 private
  bool proceed_with_order = false;
 private
  unsigned int k = 0;
 private
  ulong j = 0;

  for (k = 0; k < 256 * 16; k++) {
    orders[hook(13, k + (gid * 256 * 16))] = -1.0 * (float)gid;
  }

  score[hook(12, gid)] = 0.0;

  for (j = 0; j < input_len; j++) {
    t += 1.0;
    ema_long = (input[hook(11, j)] - ema_long) * ema_long_mult + ema_long;
    ema_short = (input[hook(11, j)] - ema_short) * ema_short_mult + ema_short;

    macd_pct = ((ema_short - ema_long) / (ema_short + 0.00001));

    if (buy_delay > 0) {
      buy_delay -= 1;
    }

    score[hook(12, gid)] *= 0.99999;

    if ((market_classification[hook(10, j)] == quartile[hook(9, gid)]) & (balance > (input[hook(11, j)] * shares[hook(0, gid)])) & (buy_delay == 0) & (macd_pct < macd_buy_trip[hook(7, gid)])) {
      proceed_with_order = true;

      last_orders_index = orders_index;
      while (orders[hook(13, orders_index + (gid * 256 * 16))] > 0.5 & proceed_with_order == true) {
        orders_index += 16;
        if (orders_index >= 256 * 16) {
          orders_index = 0;
        }
        if (last_orders_index == orders_index) {
          proceed_with_order = false;
        }
      }

      if (proceed_with_order == true) {
        buy_delay += buy_wait[hook(3, gid)];
        balance -= input[hook(11, j)] * shares[hook(0, gid)];
        orders[hook(13, orders_index + 0 + (gid * 256 * 16))] = t;
        orders[hook(13, orders_index + 1 + (gid * 256 * 16))] = input[hook(11, j)];
        orders[hook(13, orders_index + 2 + (gid * 256 * 16))] = input[hook(11, j)] * (1.0 + markup[hook(4, gid)] + 0.012);
        orders[hook(13, orders_index + 3 + (gid * 256 * 16))] = input[hook(11, j)] * (1.0 - stop_loss[hook(5, gid)]);
        orders[hook(13, orders_index + 4 + (gid * 256 * 16))] = t + stop_age[hook(6, gid)];
        orders[hook(13, orders_index + 5 + (gid * 256 * 16))] = -1234.0;
        orders_index += 16;
        if (orders_index >= 256 * 16) {
          orders_index = 0;
        }
      }
    }

    for (k = 0; k < 256 * 16; k += 16) {
      if (orders[hook(13, k + 0 + (gid * 256 * 16))] > 0.5) {
        sell = false;

        if (orders[hook(13, k + 4 + (gid * 256 * 16))] <= t) {
          loss += 1.0;
          sell = true;
          buy_delay += buy_wait_after_stop_loss[hook(8, gid)];
          score[hook(12, gid)] += -2.0 + (input[hook(11, j)] / orders[hook(13, k + 2 + (gid * 256 * 16))]);
          orders[hook(13, k + 5 + (gid * 256 * 16))] = -2.0 + (input[hook(11, j)] / orders[hook(13, k + 2 + (gid * 256 * 16))]);
        }

        else if (orders[hook(13, k + 3 + (gid * 256 * 16))] >= input[hook(11, j)]) {
          loss += 0.9;
          sell = true;
          buy_delay += buy_wait_after_stop_loss[hook(8, gid)];
          score[hook(12, gid)] += -2.0 + (input[hook(11, j)] / orders[hook(13, k + 2 + (gid * 256 * 16))]);
          orders[hook(13, k + 5 + (gid * 256 * 16))] = -2.0 + (input[hook(11, j)] / orders[hook(13, k + 2 + (gid * 256 * 16))]);
        }

        else if (orders[hook(13, k + 2 + (gid * 256 * 16))] <= input[hook(11, j)]) {
          wins += 1.0;
          sell = true;

          score[hook(12, gid)] += input[hook(11, j)] / orders[hook(13, k + 2 + (gid * 256 * 16))];
          orders[hook(13, k + 5 + (gid * 256 * 16))] = input[hook(11, j)] / orders[hook(13, k + 2 + (gid * 256 * 16))];
        }

        if (sell == true) {
          orders[hook(13, k + 0 + (gid * 256 * 16))] = 0.1;
          balance += input[hook(11, j)] * shares[hook(0, gid)] * (1.0 - 0.012);
          sell = false;
        }
      }
    }

    if (j == (input_len - 1)) {
      if (score[hook(12, gid)] == 0.0) {
        score[hook(12, gid)] = -10001;
      } else {
        score[hook(12, gid)] += (float)buy_wait[hook(3, gid)] / 1000.0;
        score[hook(12, gid)] += (float)buy_wait_after_stop_loss[hook(8, gid)] / 1000.0;
        score[hook(12, gid)] -= (stop_loss[hook(5, gid)] * 1000.0);

        score[hook(12, gid)] -= (stop_age[hook(6, gid)] / 1000.0);
        score[hook(12, gid)] += shares[hook(0, gid)];

        score[hook(12, gid)] *= wins / (0.00001 + wins + (loss * (1.0 + (stop_loss[hook(5, gid)] / (markup[hook(4, gid)] + 0.0001)))));
        score[hook(12, gid)] *= 1.0 + markup[hook(4, gid)];

        if (wins / (wins + loss) < 0.85) {
          score[hook(12, gid)] /= 100000.0;
        }

        return;
      }
    }
  }
}