#########################################
###    WST�P DO EKSPLORACJI DANYCH    ###
###         LABORATORIUM 1            ###
#########################################

# 0) Prowadz�cy.
## Anna Kozak, Katarzyna Wo�nica
## Kontakt: MS Teams

# 1) Materia�y do zaj��.
## Repozytorium na GitHub
## https://github.com/MI2-Education/2022L-ExploratoryDataAnalysis


# 2) Jak dzia�a GitHub?
## Jak zg�osi� prac� domow�/projekt? (fork, pull request)


# 3) Przypomnienie podstaw R.

data(mtcars)
head(mtcars)
head(mtcars, 10)
tail(mtcars)
tail(mtcars, 10)
?mtcars


## Jak wybieramy wiersze (obserwacje) oraz kolumny (zmienne)?
mtcars[3, ]
mtcars[ ,4]

## Pierwszy wiersz, pierwsza kolumna?
mtcars[1,1]

rownames(mtcars)
colnames(mtcars)

## 10 pierszych wierszy, 2 i 3 kolumna?
head(mtcars[,2:3],10)
mtcars[1:10,2:3]

mtcars[1:10,c(2,5)]

## Wszytskie wiersze i kolumny w kolejno�ci "am", "wt", "mpg"?
mtcars[,c("am", "wt", "mpg")]

## Jak wybiera� jedn� kolumn�?
mtcars[,"am"]
mtcars$am

## Pytania

## 1. Wymiar ramki danych
dim(mtcars)
nrow(mtcars)
ncol(mtcars)

## 2. Jakie s� typy zmiennych?
class(mtcars)
typeof(mtcars)

str(mtcars)
summary(mtcars)

## 3. Ile jest unikalnych warto�ci zmiennej "cyl" i jakie to s� warto�ci?
unique(mtcars$cyl)

## 4. Jaka jest �rednia warto�� zmiennej "drat" dla samochod�w o warto�ci zmiennej "cyl" r�wnej 4?
mean(mtcars[mtcars$cyl == 4, 'drat'])

## Prosty wykres

## Zale�no�� "mpg" i "hp" - scatter plot
plot(mtcars$mpg, mtcars$hp)

## Zmienna "cyl" - barplot
table(mtcars$cyl)

barplot(table(mtcars$cyl))

# 4) Gra proton, nale�y stworzy� plik R z kodami do rozwi�zania gry (do 20 minut).
install.packages("proton")
library(proton)
proton()
employees[employees$name == 'John' & employees$surname == 'Insecure', 'login']
proton(action = "login", login="johnins")

for(i in 1:length(top1000passwords)){
  print(i)
  response <- proton(action = "login", login="johnins", password=top1000passwords[i])
  if(response == 'Success! User is logged in!'){
    print(top1000passwords[i])
    break
  }
}

log_piet <- employees[employees$surname == 'Pietraszko', 'login']
head(logs)
which.max(table(logs[logs$login == log_piet,'host']))
table(logs[logs$login == log_piet,'host'])[134]
proton(action = "server", host="194.29.178.16")
head(bash_history)
unique(grep(pattern = " ", x = bash_history, value = TRUE, invert = TRUE))
proton(action = "login", login = log_piet, password = "DHbb7QXppuHnaXGN" )
# 5) Umieszczamy na repozytorium rozwi�zanie.