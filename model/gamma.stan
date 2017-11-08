data {
  int<lower=0> N; // number of data 
  real<lower=0> x[N]; // time
}

parameters {
  real alpha; 
  real lambda;
}

model {
  for(n in 1:N)
    x[n] ~ gamma(alpha, lambda);
}
