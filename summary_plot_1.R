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
  geom_bar(aes(x=first_year), width=0.8)+
  labs(title="顧客の初回来店年")+
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
  .$staff_id %>% 
  summary() %>%
  sort(decreasing=T) %>% barplot()


line %>% 
  filter(trans_category=="販売") %>% 
  group_by(staff_id) %>%
  summarise(n=n()) %>% 
  .$n %>% 
  sort(decreasing=T) %>% head()
  barplot()

line %>% 
  filter(trans_category=="販売") %>% 
  group_by(staff_id)
