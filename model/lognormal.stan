data {
  int<lower=0> N; // number of data 
  real<lower=0> x[N]; // time
}

parameters {
  real mu; 
  real<lower=0> sigma;
}

model {
  for(n in 1:N)
    x[n] ~ lognormal(mu, sigma);
}
