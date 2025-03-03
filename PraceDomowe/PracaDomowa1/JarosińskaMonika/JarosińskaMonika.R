library(dplyr)

df <- read.csv("C:/Users/monik/OneDrive/Dokumenty/Eksploracja/house_data.csv")

View(df)

# 1. Jaka jest srednia cena nieruchomosci polozonych nad woda, ktorych jakosc wykonczenia jest rowna lub wieksza od mediany jakosci wykonczenia?

df1 <- df %>% 
  filter(waterfront == 1, grade >= median(grade))  %>%
  summarise(mean_price = mean(price))
  
df1

# Odp: 1784152.

# 2. Czy nieruchomosci o 2 pietrach maja wieksza (w oparciu o wartosci mediany) liczbe lazienek niz nieruchomosci o 3 pietrach?

med_2floors <- df %>% 
  select(id, bathrooms, floors) %>% 
  filter(floors == 2) %>% 
  summarise(med=median(bathrooms))

med_3floors <- df %>% 
  select(id, bathrooms, floors) %>% 
  filter(floors == 3) %>% 
  summarise(med=median(bathrooms))
 
med_2floors

med_3floors

# Odp: Nie. Maj� tak� sam�.

# 3. O ile procent wiecej jest nieruchomosci lezacych na polnocny zachod niz nieruchomosci lezacych na poludniowy wschod?


latitude <- df %>% 
  summarise(m = median(lat))

y <- 47.5718

longitude <- df %>% 
  summarise(m = median(long))

x <- -122.23

north_west <- df %>% 
  filter(lat > y, long < x) %>% 
  summarise(n=n())

south_east <- df %>% 
  filter(lat < y, long > x) %>% 
  summarise(n=n())


difference <- north_west[1,1]-south_east[1,1]

x <- (difference*100)/prop_south_east

x 

# Odp: O okolo 0.14% wiecej.


# 4. Jak zmieniała się (mediana) liczba łazienek dla nieruchomości wybudowanych w latach 90 XX wieku względem nieruchmości wybudowanych roku 2000?

df$date <- as.Date(df$date, format='%Y%m%d')


ninties <- df %>% 
  select(id, bathrooms, yr_built) %>% 
  filter(yr_built >= 1990 & yr_built <= 1999) %>% 
  summarise(med = median(bathrooms)) 
  
ninties

two_thousand <- df %>% 
  select(id, bathrooms, yr_built) %>% 
  filter(yr_built == 2000) %>%  
  summarise(med = median(bathrooms)) 

two_thousand

difference <- abs(ninties - two_thousand)

difference 

# Odp: Nie ma roznicy w medianie.


# 5. Jak wygl�da warto�� kwartyla 0.25 oraz 0.75 jako�ci wyko�czenia nieruchomo�ci po�o�onych na p�nocy bior�c pod uwag� czy ma ona widok na wod� czy nie ma?

latitude <- df %>% 
  summarise(m = median(lat))

y <- 47.5718

with_water <- df %>% 
  filter(lat >= y, waterfront == 1) %>% 
  group_by(waterfront) %>% 
  summarise(q1 = quantile(grade, 0.25), q3 = quantile(grade, 0.75))

with_water

no_water <- df %>% 
  filter(lat >= y, waterfront == 0) %>%
  group_by(waterfront) %>% 
  summarise(q1 = quantile(grade, 0.25), q3 = quantile(grade, 0.75))

no_water

# Odp: Dla nieruchomosci z widokiem na wode wartosc kwantyla kolejno 0.25 i 0.75 to 8 i 11, a bez widoku na wode to kolejno 7 i 8.


# 6. Pod którym kodem pocztowy jest położonych najwięcej nieruchomości i jaki jest rozstęp miedzykwartylowy dla ceny nieruchomości położonych pod tym adresem?

numberofprop <- df %>% 
  group_by(zipcode) %>% 
  summarise(n = n()) %>% 
  summarise(m = max(n))

most_properties <- df %>% 
  group_by(zipcode) %>% 
  summarise(n = n()) %>% 
  filter(n == 602)

most_properties

q1 <- df %>% 
  filter(zipcode == 98103) %>% 
  summarise(q1= quantile(price, 0.25))

q3 <- df %>% 
  filter(zipcode == 98103) %>% 
  summarise(q1= quantile(price, 0.75))

iqr <- q3 - q1
iqr

# Odp: Najwiecej nieruchomosci polozonych jest pod kodem pocztowym 98103, rozstep miedzy kwartylowy to 262875.


# 7. Ile procent nieruchomo�ci ma wy�sz� �redni� powierzchni� 15 najbli�szych s�siad�w wzgl�dem swojej powierzchni?

df %>% 
  filter(sqft_lot15 > sqft_lot) %>% 
  summarise(n())

percentage <- (8540/count(df))*100
percentage

# Odp: Okolo 39.5% nieruchomosci.


# 8. Jak� liczb� pokoi maj� nieruchomo�ci, kt�rych cena jest wi�ksza ni� trzeci kwartyl oraz mia�y remont w ostatnich 10 latach (pamietaj�c �e nie wiemy kiedy by�y zbierane dne) oraz zosta�y zbudowane po 1970?

q3 <- df %>% 
  summarise(q3 = quantile(price, 0.75))
  
q3  

newest_renovated <- df %>% 
  summarise(m = max(yr_renovated))

newest_renovated

number_rooms <- df %>% 
  filter(price >= 645000, yr_renovated >= 2005, yr_built > 1970) %>% 
  select(bedrooms)

number_rooms 

# Odp: Takie nieruchomosci maja liczbe pokoi: 3-5.


# 9. Patrz�c na definicj� warto�ci odstaj�cych wed�ug Tukeya (wykres boxplot) wska� ile jest warto�ci odstaj�cych wzgl�dem powierzchni nieruchomo�ci(dolna i g�rna granica warto�ci odstajacej).

tukey <- df %>% 
  filter(sqft_lot < quantile(sqft_lot, 0.25)-(1.5)*(IQR(sqft_lot)) |
           sqft_lot > quantile(sqft_lot, 0.75) + 1.5*(IQR(sqft_lot))) %>% 
  summarise(n=n())

tukey

# Odp: 2425.


# 10. W�r�d nieruchomo�ci wska� jaka jest najwi�ksz� cena za metr kwadratowy bior�c pod uwag� tylko powierzchni� mieszkaln�.

price_per_sq <- df %>% 
  select(price, sqft_living) %>% 
  mutate(ppersq = (price/sqft_living)) %>% 
  arrange(desc(ppersq)) %>% 
  head(1)

price_per_sq

# Odp: Najwieksza cena za  metr kwadratowy to w przyblizeniu 810.14.