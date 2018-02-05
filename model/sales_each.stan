data {
   int<lower=1> N;
   int<lower=1> N_obs;
   int<lower=0> N_na;
   int<lower=1> Idx_obs[N_obs];
   int<lower=1> Idx_na[N_na];
   int<lower=0, upper=1> D1[N];
   int<lower=0, upper=1> D2[N];
   int<lower=0, upper=6> Wday[N];
//   vector[N] Rain_val;
   vector<lower=0>[N_obs] Sale_obs;
}

parameters {
   vector[N] trend;
   vector[6] s_raw;
   real b1;
   real b2;
//   real c_rain;
//   vector[N] ar;
//   real c_ar[2];
   real<lower=0> s_trend;
//   real<lower=0> s_ar;
   real<lower=0> s_r;
}

transformed parameters {
   vector[7] s;
   vector[N] week;
//   vector[N] rain;
   vector[N] sale_mu;
   s[1:6] = s_raw;
   s[7] = -sum(s_raw);
   for(i in 1:7)
      week[i] = s[Wday[i]+1] + D1[i]*b1*(s[1]-s[Wday[i]+1]);
   for(i in 8:N)
      week[i] = s[Wday[i]+1] + D1[i]*b1*(s[1]-s[Wday[i]+1])
                             + D2[i]*(b2*(s[6]-s[Wday[i]+1]));
//   rain = c_rain * Rain_val;
   sale_mu = trend + week; //+rain+ar
}

model {
  // for(i in 1:N)
  //     trend[i] ~ normal(250, 30);
   b1 ~ normal(0.5, 0.5);
   b2 ~ normal(0.5, 0.5);
   s_trend ~ cauchy(0, 1);
//   s_ar ~ normal(0, 20);
   s_r ~ cauchy(0, 2);
   trend[3:N] ~ normal(2*trend[2:N-1] - trend[1:N-2], s_trend);
//   ar[3:N] ~ normal(c_ar[1]*ar[2:N-1] + c_ar[2]*ar[1:N-2], s_ar);
   Sale_obs ~ normal(sale_mu[Idx_obs], s_r);
}

generated quantities {
   vector[N_na] sale_na;
   for (i in 1:N_na)
      sale_na[i] = normal_rng(sale_mu[Idx_na[i]], s_r);
}
