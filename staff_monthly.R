


staff_monthly <- dbGetQuery(con, 'SELECT * FROM staff_monthly;')
staff_monthly

staff_monthly$regi_staff <- as.factor(staff_monthly$regi_staff)
a <- staff_monthly %>% 
  group_by(regi_staff) %>% 
  summarise(n()) %>% 
  as.data.frame()
colnames(a)[2] <- "count"



staff_monthly %>%
  filter(regi_staff==163) %>% 
  .$all_count %>%
  ts.plot()


a %>% filter(count < 24)
