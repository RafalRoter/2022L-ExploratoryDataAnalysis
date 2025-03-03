df <- read.csv("R/house_data.csv")
library(dplyr)

df %>% 
  View()


# 1. Jaka jest �rednia cena nieruchomo�ci po�o�onych nad wod�, kt�rych jako� wyko�czenia jest r�wna lub wi�ksza od mediany jako�ci wyko�czenia?
df %>% 
  filter(waterfront == 1) %>% 
  select(price,waterfront,grade) %>% 
  filter(grade >= median(df$grade)) %>% 
  summarise(srednia = mean(price))

# Odp: 1784152


# 2. Czy nieruchomo�ci o 2 pi�trach maj� wi�ksz� (w oparciu o warto�ci mediany) liczb� �azienek ni� nieruchomo�ci o 3 pi�trach?
df %>% 
  select(floors,bathrooms) %>% 
  filter(floors == 2 | floors == 3) %>% 
  group_by(floors) %>%
  summarise(liczba = median(bathrooms))
# Odp: Nie, nie maj�. W obu przypadkach mediana wynosi 2.5.


# 3. O ile procent wi�cej jest nieruchomo�ci le�cych na p�nocy zach�d ni�  nieruchomo�ci le��cych na po�udniowy wsch�d?
NW <- df %>% 
  select(id, lat, long) %>% 
  filter(lat < median(df$lat), long > median(df$long)) %>% 
  summarise(n = n())
SE <- df %>% 
  select(id, lat, long) %>% 
  filter(lat > median(df$lat), long < median(df$long)) %>% 
  summarise(n = n())

# Odp:Tych na po�udniowym wschodzie jest o 9 wi�cej.


# 4. Jak zmienia�a si� (mediana) liczba �azienek dla nieruchomo�ci wybudownych w latach 90 XX wieku wzgl�dem nieruchmo�ci wybudowanych roku 2000?
df %>% 
  select(bathrooms, yr_built) %>% 
  filter(yr_built == c(1990:1999)) %>% 
  summarise(med_dziew = median(bathrooms))
df %>% 
  select(bathrooms, yr_built) %>% 
  filter(yr_built == 2000) %>% 
  summarise(med_dziew = median(bathrooms))
# Odp: Mediana nie zmieni�a si�.


# 5. Jak wygl�da warto�� kwartyla 0.25 oraz 0.75 jako�ci wyko�czenia nieruchomo�ci po�o�onych na p�nocy bior�c pod uwag� czy ma ona widok na wod� czy nie ma?
df %>% 
  select(grade, long, waterfront) %>% 
  filter(long > median(long)) %>% 
  group_by(waterfront) %>% 
  summarise(x = quantile(grade))
  
# Odp: Dla nieruchomo�ci po�ozonych nad wod�, to Q1 = 8, Q3 = 11, a nie nad wod� Q1 = 7, Q3 = 9


# 6. Pod kt�rym kodem pocztowy jest po�o�onych najwi�cej nieruchomo�ci i jaki jest rozst�p miedzykwartylowy dla ceny nieruchomo�ci po�o�onych pod tym adresem?
df %>% 
  select(price,zipcode) %>% 
  group_by(zipcode) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n)) %>% 
  slice(1)
df %>% 
  select(price, zipcode) %>% 
  filter(zipcode == 98103) %>% 
  summarise(srednia_cena = mean(price))

# Odp:584919.2


# 7. Ile procent nieruchomo�ci ma wy�sz� �redni� powierzchni� 15 najbli�szych s�siad�w wzgl�dem swojej powierzchni?
x <- df %>% 
  select(sqft_lot15, sqft_lot) %>% 
  filter(sqft_lot15 > sqft_lot) %>% 
  summarise(n=n())
x[1]/ 21613
# Odp: 39.51326%


# 8. Jak� liczb� pokoi maj� nieruchomo�ci, kt�rych cena jest wi�ksza ni� trzeci kwartyl oraz mia�y remont w ostatnich 10 latach (pamietaj�c �e nie wiemy kiedy by�y zbierane dne) oraz zosta�y zbudowane po 1970?
df %>% 
  select(price) %>% 
  summarise(x = quantile(price))

df %>% 
  select(price, bedrooms, bathrooms, yr_built, yr_renovated) %>% 
  filter(yr_built > 1970, yr_renovated > max(yr_renovated - 10), price > 645000) %>% 
  mutate(liczba_pokoi = bathrooms + bedrooms) %>% 
  summarise(srednialp = mean(liczba_pokoi))

# Odp: Srednio 7.19 pokoi.


# 9. Patrz�c na definicj� warto�ci odstaj�cych wed�ug Tukeya (wykres boxplot) wska� ile jest warto�ci odstaj�cych wzgl�dem powierzchni nieruchomo�ci(dolna i g�rna granica warto�ci odstajacej).
boxplot(df$sqft_living)
quantile(df$sqft_living)
IQR(df$sqft_living)
df %>% 
  select(sqft_living) %>% 
  filter(sqft_living > quantile(df$sqft_living)[4]+1.5*IQR(df$sqft_living) | sqft_living < quantile(df$sqft_living)[2]-1.5*IQR(df$sqft_living)) %>% 
  summarise(n=n())
# Odp:572


# 10. W�r�d nieruchomo�ci wska� jaka jest najwi�ksz� cena za metr kwadratowy bior�c pod uwag� tylko powierzchni� mieszkaln�.
df %>% 
  select(price, sqft_living) %>% 
  mutate(cena_m2 = price/sqft_living) %>% 
  arrange(-cena_m2) %>% 
  slice(1)

# Odp: 810.1389