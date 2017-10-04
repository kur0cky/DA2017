library(DBI)  # 必須ではないらしい
library(RPostgreSQL)
library(tidyverse)


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



# customer_2
sql <- scan_query('customer_2.sql')
customer.tmp <- dbGetQuery(con,sql) 


# データの整理
str(customer.tmp)
customer <- customer.tmp
customer$dm <- as.factor(customer.tmp$dm)
customer$sex <- as.factor(customer.tmp$sex)
customer$comment <- as.factor(customer.tmp$comment)
customer$birth_age <- as.factor(customer.tmp$birth_age)
str(customer)
rm(customer.tmp)
summary(customer)


# store_1
sql <- scan_query('store_1.sql')
store.tmp <- dbGetQuery(con,sql) 
str(store.tmp)
store <- store.tmp
rm(store.tmp)

# staff_1
sql <- scan_query('staff_1.sql')
staff.tmp <- dbGetQuery(con,sql) 
str(staff.tmp)
staff <- staff.tmp
staff$store_id_num <- as.factor(staff.tmp$store_id_num)
str(staff)
rm(staff.tmp)


# product_2
# sql <- scan_query('product_2.sql')
# product.tmp <- dbGetQuery(con,sql) 
product.tmp <- read.csv("data/product_2.csv", encoding = "UTF-8")
str(product.tmp)
# 全行読み出せてない問題



# receipt
sql <- scan_query('receipt_henpin_syori.sql')
receipt.tmp <- dbGetQuery(con,sql) 
str(receipt.tmp)
receipt <- receipt.tmp
rm(receipt.tmp)


# line
sql <- scan_query('line_henpin_syori_fin.sql')
line.tmp <- dbGetQuery(con,sql) 
str(line.tmp)
line <- line.tmp
line$simei <- as.factor(line.tmp$simei)
line$staff_id <- as.factor(line.tmp$staff_id)
line$trans_category <- as.factor(line.tmp$trans_category)
line$item_treat <- as.factor(line.tmp$item_treat)
line$product_id <- as.factor(line.tmp$product_id)
line$line_id <- as.factor(line.tmp$line_id)
line$receipt_id <- as.factor(line.tmp$receipt_id)
rm(line.tmp)
str(line)
summary(line)
