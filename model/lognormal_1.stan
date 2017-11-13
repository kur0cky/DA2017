data {
  int<lower=0> N; 
  real<lower=0> x[N];
  int sex[N];
}

parameters {
  real a0;
  real b0;
  real a;
  real b;
  real<lower=0> sigma; 
  real<lower=0> s_a;
  real<lower=0> s_b;
}

model {
  a ~ normal(a0, s_a);
  b ~ normal(b0, s_b);

  
  for(n in 1:N)
    x[n] ~ lognormal(a + b*(sex[n]-1), sigma);
}
