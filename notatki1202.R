#### ZAJECIA 22.12 ####

#install.packages('checkmate')
library(tidyverse)
library(checkmate)

# zdefiniujemy sobie prosta funckje, pochodna numeryczna

H <- 100000

num_der <-  function(f, x) {
  (f(x + H) - f(x)) / H
}

f <- function(x) exp(x)

num_der(f, 'jakis tekst') # blont. 
# no i my widzimy ze to jest blont. ale moze to komus umknac, np:

LL <- NULL # (?)

add_list <- function(x) {
  len <-  length(LL)
  LL[[len + 1]] <- x
}

# chcemy przewidziec zle zachowania uzytkownikow tego kodu

add_list <- function(x) {
  if(!is.numeric(x))
    stop('Argument nie jest liczbą')
  
  len <-  length(LL)
  LL[[len + 1]] <- x
}


add_list('ggg') # no ok, to jest ok, ale slabe, bo zajmuje duzo kodu, i cos tam

# mozna sobie za to zdefiniowac wartosc jakiejs flagi ktora bedzie oznaczac blad, np mozna ustawic NULL czy cos

# ale no tez mehij

# tutaj z pomoca przychodzi biblioteka Checkmate

add_list <- function(x) {
  assert_double(x)
  
  len <- length(LL)
  LL[[len + 1]] <- x
}

# to jest tez super do debuggowania
# asserty ograniczaja wydajnosc, ale na pewno o wiele lepsze niz ify

add_list('ff')


add_list <- function(x) {
  check_double(x) %>% print # zwraca wartosc logiczna czy warunek jest spelniony
  check_array(x) %>% print
  check_atomic_vector(x) %>% print
  
  len <- length(LL)
  LL[[len + 1]] <- x
}
# wzielismy sobie print zeby zobaczyc ale no normalnie nie printuje


add_list <- function(x) {
  check_double(x) %>% print 
  
  if(!check_array(x))
    stop('Problem')
  
  check_atomic_vector(x) %>% print
  
  len <- length(LL)
  LL[[len + 1]] <- x
}


add_list <- function(x, y) {
  assert(check_double(x, len = 2), check_integer(y, len = 1)) #len to dlugosc

  
  check_atomic_vector(x) %>% print
  
  len <- length(LL)
  LL[[len + 1]] <<- x/y  # raczej tego nie powinnismy uzywac ale chodzi o to ze dajemy te zmienna do srodowiska globalnego
}

add_list(c(20,10), 5)

add_list(c(20,10), 5L)

## ale blad y nie generowal nam zadnych problemow, zmienmy to

add_list <- function(x, y) {
  assert(check_double(x, min.len = 2), check_integer(y, len = 1), combine = 'and') #len to dlugosc
  
  len <- length(LL)
  LL[[len + 1]] <<- x/y
}

# teraz jak juz jest and to on patrzy na oba koniecznie

add_list('tekst')
add_list(5, 5L)
add_list(25, 5L)
add_list(c(1,2), 5L)


#########################
# jak chcemy upublicznic nasz pakiet cos tam cos tam

robi_cos <- function(x) {
  print('cos')
}

# i robimy funkcje ktora jedyne co robi to wywoluje tamta poprzednia

robiCos <- function(x) robi_cos(x)

robiCos(1)
# to jest po to ze 


# to jest bardzo fajna konwencja nazewnicza

######################
# czasami mam tak ze na potrzeby API musimy wziac duzo assertow
# ale nasze funkcje ktore juz sprawdzone wczesniej
# wiec nazywamy te nasze z kropka

robi_cos <- function(x) {
  assert_character(x)
  robi_cos(x)
}

.robi_cos <- function(x) {
  robi_cos(x)
}  
# teraz uzytkownicy wiedza ze ta funkcja nie ma byc widoczna w pakiecie


robiCos(1)
robi_cos


#### OBSLUGA WYJATKOW ####

?tryCatch() # w Javie sa osobno, tutaj razem

# finally to to co ma procedura wykonac niewazne czy byl blad czy nie

tryCatch(num_der(f, 'tekst'),
         error = function(e) print(e),  # print wyswietla komunikat o bledzie
         warning = function(w) print(w))
# zwlaszcza kiedy chcemy np webscraping i chcemy zeby funkcja pobierala csv z internetu, zrzcuala jako df a jednoczesnie zapisywala na dysku. Funkcja ma dwa argumenty, identyfikator ze strony i sciezka docelowa pliku. moze byc tak ze ktos poda dobry identyfikator, ale zly adres. No i wtedy np chcemy zeby ta funkcja pobierala ten dataframe ale nie zapisywala. no i tutaj sie przydaje obsluga wyjatkow

y <- 2L
x <- 'tekst'

tryCatch(sprintf('1: %i, 2: %s', x, y),
         error = function(e) {
           x1 <- as.character(x)
           y1 <- as.character(y)
           sprintf('1: %s, 2: %s', x1, y1)
         },
         warning = function(w) print(w))



y <- 3
x <- 3L

tryCatch(sprintf('1: %i, 2: %s', x, y),
         error = function(e) {
           print("Błąd")
           x1 <- as.character(x)
           y1 <- as.character(y)
           sprintf('1: %i, 2: %s', x1, y1)
         },
         warning = function(w) print(w))
