# script para teste de novos blogs

# pacotes
library(feedeR)
library(magrittr)
library(lubridate)
library(readr)
library(dplyr)
rm(list = ls())

novo_blog <- c(
  "Curso-R" = "http://curso-r.com/index.xml"
  )

feed <- feed.extract(novo_blog, encoding = "UTF-8")

# parte do for loop
blog <- feed$items
# No blogpost, title é na verdade title.text:
names(blog)[names(blog) == "title.text"] <- "title"
nome_blog <- names(novo_blog)
df <- data.frame(nome_blog = nome_blog,
                 titulo_post = blog$title,
                 link = blog$link,
                 data_post = blog$date,
                 hash = blog$hash,
                 stringsAsFactors = FALSE)
head(df)
