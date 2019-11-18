######## ZAJECIA 18.11.2019 PODEJSCIE 2 ############

print('Hello')

num_der <- function(f, x, h) {
  (f(x + h) - f(x))/h
}

f <- function(x) exp(x)

num_der(f, 3, 1/10000000)


n <- 200
samp <- rt(n, 10)
print(samp)
plot(samp)
