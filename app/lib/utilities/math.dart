import 'dart:math';

/// Models a gaussian normal distribution with [mean] and [variance].
double normalDistribution(double x, double mean, double variance) {
  return (1 / sqrt(2 * pi * variance)) *
      exp(-0.5 * pow(x - mean, 2) / variance);
}
