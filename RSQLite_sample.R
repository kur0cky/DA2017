library(tidyverse)
library(RSQLite)
library(DBI)

#データベースの作成
#データベースにアクセス
db <- dbConnect(SQLite(), dbname="hair.sqlite")


#店舗マスタの追加
store <- read.csv("data/店舗マスタ.csv")
store[1,5] <- NA
dbWriteTable(conn = db, name = "tbl_store", value = store, row.names = FALSE)

#担当者マスタの追加
stylist <- read.csv("data/担当者マスタ.csv")
str(stylist)
dbWriteTable(conn = db, name = "tbl_stylist", value = stylist, row.names = FALSE)

#商品マスタの追加
product <- read.csv("data/商品マスタ.csv")
str(product)
dbWriteTable(conn=db, name="tbl_product", value=product, row.names=FALSE)

#カテゴリマスタの作成
category <- product[,c(3,4,5,6)] 
str(category)
which(is.na(category), arr.ind=TRUE)
  # この商品に問題あり
product[1292, ]

category %>% distinct(第２カテゴリID,.keep_all=TRUE) %>% 
  write.csv("data/第２カテゴリマスタ.csv")
category %>% distinct(第１カテゴリID,.keep_all=TRUE) %>% 
  write.csv("data/第１カテゴリマスタ.csv")
  # このあとエクセルで作業
category1 <- read.csv("data/第１カテゴリマスタ.csv")
category2 <- read.csv("data/第２カテゴリマスタ.csv")

dbWriteTable(conn=db, name="tbl_category1", value=category1, row.names=FALSE)
dbWriteTable(conn=db, name="tbl_category2", value=category2, row.names=FALSE)

#会計履歴の追加
history <- read.csv("data/会計履歴.csv")
str(history)
history$販売店舗ID <- as.integer(history$販売店舗ID)
history$POS入力担当者ID <- as.integer(as.character(history$POS入力担当者ID))
history$会計主担当者ID <- as.integer(as.character(history$会計主担当者ID))
write.csv(history, "data/会計履歴.csv")
dbWriteTable(conn=db, name="tbl_history", value=history)

#会計明細の追加
detail <- read.csv("data/会計明細.csv")
  # #N/Aを消すため
detail$会計明細販売担当者ID <- as.integer(as.character(detail$会計明細販売担当者ID))
write.csv(detail, "data/会計明細.csv")
dbWriteTable(conn=db, name="tbl_detail", value=detail, row.names=FALSE)


#顧客マスタの追加
customer <- read.csv("data/顧客マスタ.csv")
str(customer)
dbWriteTable(conn=db, name="tbl_customer", value=customer, row.names=FALSE)



dbListTables(db)
dbGetQuery(db, "SELECT * FROM tbl_store")
dbGetQuery(db, "SELECT * FROM tbl_stylist")
dbSendQuery(db, "DROP TABLE tbl_customer")
#文字化け問題を何とかしなくちゃ


dbDisconnect(db)
