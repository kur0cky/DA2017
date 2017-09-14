library(tidyverse)


store <- read.csv("data/店舗マスタ.csv")
store


person <- read.csv("data/担当者マスタ.csv")
str(person)
  # なぜID:0が二人いるの？？
head(person)


customer <- read.csv("data/顧客マスタ.csv")
str(customer)
summary(customer)


product.tmp <- read.csv("data/商品マスタ.csv")
str(product.tmp)
summary(product)
product <- product.tmp[,-c(14,15)]
rm(product.tmp)

history <- read.csv("data/会計履歴.csv")


detail <- read.csv("data/会計明細.csv")

person$担当者所属店舗ID %>% plot()
ggplot(data=person, aes(x=担当者所属店舗ID))+
  geom_bar()+
  labs(title="担当者の所属店舗")
ggsave("担当者の所属店舗.png")


ggplot(data=customer, aes(x=性別, fill=性別))+
  geom_bar()+
  labs(title="顧客の性別")
ggsave("顧客の性別.png")


png("性別とDMの送信可否.png", width = 100, height = 100)  # 描画デバイスを開く
xtabs(~性別+DM送信可否, data=customer) %>% mosaicplot(main="性別とDMの送信可否")
dev.off()    



customer$初回来店店舗ID.1 %>% levels %>% length()
customer$初回来店店舗ID %>% as.factor %>% levels


product$第１カテゴリID %>% as.factor %>% levels
product$第２カテゴリID %>% as.factor %>% levels

category <- product[,c(3,4,5,6)] 
category %>% distinct(第２カテゴリID,.keep_all=TRUE) 
category %>% distinct(第２カテゴリID,.keep_all=TRUE) %>% 
  write.csv("data/第２カテゴリマスタ.csv")

category %>% distinct(第１カテゴリID,.keep_all=TRUE) %>% 
  write.csv("data/第１カテゴリマスタ.csv")
