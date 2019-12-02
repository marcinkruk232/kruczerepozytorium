#### Zajecia 25.11.2019 ####
library(tidyverse)
library(lubridate)
library(data.table)

# install.packages('microbenchmark')

library(microbenchmark)

N1 <- 10000

microbenchmark(
  test1 = {
    x <- NULL
    for(i in 1:N1) {
      x <- c(x, i)
    }
  },
  test2 = { 
    x <- NULL
    for (i in 1:N1) {
      x[i] <- i
    }
    },
  test3 = {
    x <- numeric(N1)
    for(i in 1:N1) {
      x[i] <- i
    }
  }
)


# czyli opłaca się alokować te wektory czy cos tam



# funkcje sapply lapply mapply
# one sie roznia no ale podobnie
# jest jeszcze vapply ale nie warto jej uzywac, ona wymusza ze bierze wektor

# one biora liste jako wektor i wykonuja operacje na kazdym elemencie tego wektora
# 

a <- b <- c <- '1'
paste(a, b, c, 'xxx', sep = '@')

# to jest fajna funkcja, definiujemy przez dodanie na poczatku % typ zmiennej d - double, s - string itp

sprintf('Numer %d , tekst; %s', 1, 'cos')

sprintf('Numer %d , tekst; %s', 1:10, 'cos')



# ok gosc zrobil porownanie szybkosci sapply vapply i jakiegos map_chr z tidyversa

# no i co, no i gowno. Nie no zart. Od najlepszego:
# 1. Sapply. 2.Map_.. 3.Vapply.

# A potem wzial i zrobil sobie tam alokacje w kazdym (w sensie np val <- character(12), wczesniej tego nie bylo). No i teraz ranking:

# funkcje klasy apply automatycznie alokuja pamiec
# apply i map_... sa najlepsze!!!


#######

#library(datasets)

data('iris')

class(iris)

iris$Sepal.Width <- floor(iris$Sepal.Width)

unique(iris$Sepal.Width)

# dla kazdego z tych wariantow chcemy podzbior tej tabeli danych
res <- lapply(c(2, 3, 4), function(x) {
  iris[iris$Sepal.Width == x, ]
})

res[[1]]

# dla 
res <- lapply(c(2, 3, 4), function(x) {
  iris[iris$Sepal.Width == x, ]$Sepal.Length %>% mean()
})

res


rm(list = ls())


# KSIAZKA R for Data Science


date1 <- as_date('1991-01-01')

month(date1) <- month(date1) + 1


# funckje klasy map i apply nie radza sobie z datami!!! Co w takiej sytuacji? 

date_int <- as.numeric(date1)
as_date(date_int)
as.Date(date_int, origin = '1971-01-01') #! ten origin jest w sumie prawie zawsze


rm(list = ls())
data('iris')

iris <- as_tibble(iris)

unique(iris$Species)

sub1 <- iris %>% 
  filter(Species == 'setosa') %>%
  pull(Sepal.Length) # pull nam zwraca wektor

sub1 <- iris %>% 
  filter(Species == 'setosa') %>%
  select(Sepal.Length)

sub1 <- iris %>% 
  filter(Species == 'setosa') %>%
  select(-Species) %>%
  mutate(Sepal.Length = Sepal.Length * 1000)


sub1 <- iris %>% 
  filter(Species == 'setosa') %>%
  select(-Species) %>%
  mutate(Sepal.Length = sprintf('Dlugosc jest rowna %f', Sepal.Length)) %>% 
  rename(Dlugosc = Sepal.Length) %>%
  add_column(liczby = 1:50)

sub2 <- iris %>% 
  group_by(Species) %>%
  summarise_all(mean) %>%
  ungroup()



####################
rm(list = ls())

dt_iris <- as.data.table(iris)

class(dt_iris)

# obsluga tego jest straszna ale kod w c++ wiec fajny. To jest jakby lista referencji, wlasnie dzieki temu mozemy sobie dodawac nowe kolumny nie nadpisujac calosci

dt_iris[, jakies_liczby := rnorm(150)] #:= to nam pozwala dodawac kolumny za pomoca referencji
# smiesznie bo po prawej nic sie nie zmienilo, ale jak juz wejdziemy to jest kolumna. Wiec o chuj chodzi.
colnames(dt_iris)

# przez to ze r bazuje na wartosciach a nie na referencjach to jakby to dodanie kolumny dzieje sie pod maska, bo data table stawia na szybkosc
# ale jak juz zrobimy tak to bedzie ok
dt2_iris <- dt_iris

