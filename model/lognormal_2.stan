data {
  int<lower=0> N; 
  real<lower=0> x[N];
  int sex[N];
}

parameters {
  real mu[2];
  real<lower=0> sigma[2];
}

model {
  for(n in 1:N)
    x[n] ~ lognormal(mu[sex[n]], sigma[sex[n]]);
}

generated quantities {
  real y_male[4000];
  real y_female[4000];
  for(i in 1:4000){
    y_male[i] = lognormal_rng(mu[2],sigma[2]);
    y_female[i] = lognormal_rng(mu[1],sigma[1]);
  }
}
