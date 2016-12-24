# Parsear RSS
library(XML)
library(feedeR)
library(magrittr)
library(lubridate)
library(readr)
library(dplyr)
rm(list = ls())

# definir horario que o script foi rodado
horario <- now()
# carregar posts ja usados no bot
df.posts.antigos <- read_csv2("posts.csv")

sites <- c("Paixão por Dados" = "http://sillasgonzaga.github.io/feed.xml",
           "R, Python e Redes" = "http://neylsoncrepalde.github.io/feed.xml",
           "Symposio" = "https://blog.symposio.com.br/feed")


lista.feed <- lapply(sites, feed.extract, encoding = "UTF-8")
# o objeto lista.feed é uma lista composta de múltiplas listas
# criar uma lista apenas de data frames

lista.dfs <- list(rep(NA, length(sites)))

for (i in 1:length(lista.feed)) {
  # criar data frame com três variáveis:
  # nome_blog, #titulo_post, #link, #data_post
  blog <- lista.feed[[i]]$items
  nome_blog <- names(sites)[i]
  lista.dfs[[i]] <- data.frame(nome_blog = nome_blog,
                               titulo_post = blog$title,
                               link = blog$link,
                               data_post = blog$date,
                               hash = blog$hash,
                               stringsAsFactors = FALSE)
}

df.posts <- plyr::rbind.fill(lista.dfs)
# achar posts que nao estao presentes 
df.posts.novos <- subset(df.posts, !(hash %in% df.posts.antigos$hash))

# salvar posts
write.table(tail(df.feed, 42), file = "posts.csv", sep = ";", row.names = FALSE, append = TRUE)

