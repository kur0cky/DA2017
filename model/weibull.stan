data {
  int<lower=0> N; // number of data 
  real<lower=0> x[N]; // time
}

parameters {
  real<lower=0> m; 
  real<lower=0> eta;
}

model {
  for(n in 1:N)
    x[n] ~ weibull(m, eta);
}
