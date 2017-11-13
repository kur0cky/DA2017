data {
  int<lower=0> N; 
  int nSex;
  vector[N] x;
  vector[N] sex;
  vector[N] old;
  vector[N] middle;
  int wday_a[N];
  int wday_b[N];
}

parameters {
  real mu;
  real<lower=0> sigma;
  real mu_male;
  real mu_middle;
  real mu_old;
  real<lower=0> b0;
  simplex[7] theta[7];
}

model {
  mu_middle ~ normal(0,b0);
  mu_old ~ normal(0, b0);
  sigma ~ cauchy(0,5);
  for(i in 1:N){
    wday_a[i] ~ categorical(theta[wday_b[i]]);
  }
  for(i in 1:N){
    x[i] ~ lognormal(mu + mu_male*sex + mu_middle*middle + mu_old*old, sigma);
  }
}

generated quantities{
  matrix[2,3] status;
  for(i in 1:nSex){
    status[i,1] = lognormal_rng(mu + mu_male*sex[i], sigma);
    status[i,2] = lognormal_rng(mu + mu_male*sex[i] + mu_middle, sigma);
    status[i,3] = lognormal_rng(mu + mu_male*sex[i] + mu_old, sigma);
  }
}

