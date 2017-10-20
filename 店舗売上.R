library(DBI)  # 必須ではないらしい
library(RPostgreSQL)
library(tidyverse)
library(lubridate)


con <- dbConnect(PostgreSQL(), host="192.168.11.16", 
                 port=5432, 
                 dbname="datacom2017", 
                 user="postgres", 
                 password="postgres")

scan_query <- function(query_path) {
  return (
    scan(query_path, what='', quote='', sep='\n', comment.char = '', encoding='UTF-8') %>% 
      gsub(pattern='--.*$', replacement='') %>% # 正規表現でコメントアウトを消す
      paste0(collapse=' ')
  )
}

dbGetQuery(con,"SET CLIENT_ENCODING TO 'shift-jis';")


# 会計履歴の取得

sql <- scan_query('receipt_henpin_syori_fin.sql')
receipt.tmp <- dbGetQuery(con,sql) 
str(receipt.tmp)

# 目標：売上の月次推移がみたい

# 売上について----
# 月次
monthly <- receipt.tmp %>% 
    mutate(year = year(dt),
                         month = month(dt),
                         day = day(dt)) %>% 
    group_by(year, month) %>% 
    summarise(in_tax = sum(in_tax)) %>% 
    mutate()


# 年次
yearly <- receipt.tmp %>% 
    mutate(year = year(dt),
           month = month(dt),
           day = day(dt)) %>% 
    group_by(year, month) %>% 
    summarise(in_tax = sum(in_tax)) %>% 
    summarise(in_tax = sum(in_tax))

# 店舗ごと月次
store_monthly <- receipt.tmp %>% 
    mutate(year = year(dt),
           month = month(dt),
           day = day(dt)) %>% 
    group_by(store_id, year, month) %>% 
  summarise(in_tex = sum(in_tax)) 
store_monthly



# 会計数について----
# 月次会計数
receipt.tmp %>% 
  mutate(year = year(dt),
         month = month(dt)) %>% 
  group_by(year, month) %>% 
  summarise(count = n(), in_tax = sum(in_tax)) %>% 
  mutate(par = in_tax/count)

# 年次会計数
receipt.tmp %>% 
  mutate(year = year(dt),
         month = month(dt)) %>% 
  group_by(year, month) %>% 
  summarise(count = n(),  in_tax = sum(in_tax)) %>% 
  summarise(count = sum(count), in_tax = sum(in_tax)) %>% 
  mutate(par = in_tax/count)

# 店舗ごと
store_monthly<- receipt.tmp %>% 
  mutate(year = year(dt),
         month = month(dt)) %>% 
  group_by(store_id, year, month) %>% 
  summarise(in_tax = sum(in_tax), count = n()) %>% 
  mutate(par = in_tax/count) 

store_monthly %>% 
  arrange(par) %>% 
  head(20)
# store9の単価低すぎwwww
# 8もやばそう

store_monthly %>% 
  arrange(desc(par)) %>% 
  head(20)
# store_id 1と2 が優秀


# 店舗ごとの月次売上
receipt.tmp %>% 
  mutate(year=year(dt), month=month(dt)) %>% 
  group_by(store_id, year, month) %>% 
  summarise(in_tax = sum(in_tax)) %>% 
  group_by(store_id) %>% 
  summarise(median = median(in_tax),
            mean = mean(in_tax),
            min = min(in_tax),
            max = max(in_tax))
# facetしまくったヒストグラムとか作ってもいいかも

receipt.tmp %>% 
  mutate(year=year(dt), month=month(dt)) %>% 
  group_by(store_id, year, month) %>% 
  summarise(in_tax = sum(in_tax), count=n()) #%>% 
  mutate(par = in_tax/count) %>% 
  ungroup() %>% 
#  group_by(store_id) %>% 
  summarise(median = median(in_tax),
            mean = mean(in_tax),
            min = min(in_tax),
            max = max(in_tax),
            mean_par = mean(par),
            in_tax = sum(in_tax))



sql <- scan_query('store_1.sql')
store.tmp <- dbGetQuery(con,sql) 
str(store.tmp)
store <- store.tmp
rm(store.tmp)
# メン中の店の単価雑魚すぎワロタ
# 銀座店、青山店、二子玉川はさすがですね

# 曜日効果をみる----

receipt.tmp %>% 
  mutate(wday = wday(dt)) %>% 
  group_by(wday) %>% 
  summarise(in_tax = sum(in_tax))
# 1が日曜日7が土曜日
# 火曜日は定休日？？

# 一応店舗別もみるか
receipt.tmp %>% 
  mutate(wday = wday(dt)) %>% 
  group_by(wday, store_id) %>% 
  summarise(in_tax = sum(in_tax)) %>% 
  spread(store_id, in_tax) 
  




```{r}
customer <- receipt %>% 
  group_by(customer_id) %>% 
  summarize(count = n(),cs_point=max(cs_point)) %>% 
  filter(count == 1, cs_point==1) %>% 
  select(customer_id)
```


```{r}
stylist <- receipt %>% 
  group_by(customer_id, regi_staff) %>% 
  summarise(count =n() ) %>% 
  inner_join(customer ,by = "customer_id")

tmp <- receipt %>% 
  group_by(regi_staff) %>% 
  summarise(count=n())

inner_join(stylist, tmp, by="regi_staff") %>% 
  arrange(desc(count.y)) %>% 
  filter(regi_staff != 0)


```

