library(tidyverse)

ggplot(customer)+
  geom_bar(aes(x=sex), width=0.7)+
  labs(title="顧客の性別")+
  theme_bw()

ggplot(customer)+
  geom_bar(aes(x=birth_age), width=0.8)+
  labs(title="顧客の誕生年代")+
  theme_bw()

ggplot(customer)+
  geom_bar(aes(x=dm), width=0.7)+
  labs(title="顧客のDM受信")+
  theme_bw()


line %>% 
  filter(trans_category=="販売") %>% 
  group_by(staff_id) %>%
  summarise(n=n()) %>% plot()


line %>% 
  filter(trans_category=="販売") %>% 
  group_by(product_id) %>%
  summarise(n=n()) %>% 
  arrange(desc(n)) 



line %>% 
  filter(trans_category=="販売") %>% 
  .$product_id %>% 
  summary() %>%
  sort(decreasing=T) %>% head(10)
