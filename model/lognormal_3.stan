data {
  int<lower=0> N; 
  real<lower=0> x[N];
  int male[N];
  int middle[N];
  int old[N];
}

parameters {
  real mu;
  real<lower=0> sigma;
  real mu_male;
  real mu_middle;
  real mu_old;
  real a0;
  real<lower=0> b0;
}

model {
  mu_middle ~ normal(a0,b0);
  mu_old ~ normal(a0, b0);
  mu_male ~ normal(a0, b0);
  sigma ~ cauchy(0,5);
  for(n in 1:N)
    log(x[n]) ~ normal(mu + mu_male*male[n] + mu_middle*middle[n] + mu_old*old[n] ,
    sigma );
}


