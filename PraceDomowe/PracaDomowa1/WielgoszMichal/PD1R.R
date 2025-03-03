library(dplyr)

domy <- read.csv("house_data.csv")

# 1. Jaka jest �rednia cena nieruchomo�ci po�o�onych nad wod�, kt�rych jako� wyko�czenia jest r�wna lub wi�ksza od mediany jako�ci wyko�czenia?
domy %>% 
  filter(grade>=median(grade), waterfront==1) %>% 
  summarise(srednia = mean(price)) 
# Odp: 1784152

# 2. Czy nieruchomo�ci o 2 pi�trach maj� wi�ksz� (w oparciu o warto�ci mediany) liczb� �azienek ni� nieruchomo�ci o 3 pi�trach?

domy %>% 
  filter(floors==2) %>% 
  summarise(srenia_liczba_lazienek1 = median(bathrooms)) 
domy %>% 
  filter(floors==3) %>% 
  summarise(srenia_liczba_lazienek2 = median(bathrooms))
# Odp: Nie, w obu przypadkach mediana wynosi 2.5

# 3. O ile procent wi�cej jest nieruchomo�ci le�cych na p�nocy zach�d ni�  nieruchomo�ci le��cych na po�udniowy wsch�d?

#Nie wiedzia�em w stosunku do czego maj� le�e� na zach�d, czy wsch�d itd wi�c korzystaj�c z najwi�kszych i najmniejszych warto�ci po�o�enia geograficznego,
#wyznaczy�em "kwadrat", robi�c �rednie ze skrajnych po�o�e� wyznaczy�em jego �rodek i wszystko co by�o w lewej g�rnej �wiartce uzna�em za po�o�one na
#p�nocny zach�d, a w prawej dolnej za le��ce na po�udniowy wsch�d. 

ile_1<-domy %>% 
   filter(long<((max(long)+min(long))/2), lat >(max(lat)+min(lat))/2) %>%
   nrow()
ile_2<-domy %>% 
  filter(long>(max(long)+min(long))/2, lat < (max(lat)+min(lat))/2) %>%
  nrow()
odp = (ile_1/ile_2)*100 

# Odp: Nieruchomo�ci le�cych na p�nocy zach�d jest o 18443.53% ni�  nieruchomo�ci le��cych na po�udniowy wsch�d.

# 4. Jak zmienia�a si� (mediana) liczba �azienek dla nieruchomo�ci wybudownych w latach 90 XX wieku wzgl�dem nieruchmo�ci wybudowanych w/po(<-nie by�o sprecyzowane)) roku 2000?

domy %>% 
  filter(yr_built>=1990, yr_built<2000) %>%
  summarise(med_lazienek1=median(bathrooms)) 
domy %>% 
  filter(yr_built==2000) %>% 
  summarise(med_lazienek2=median(bathrooms)) 
domy %>% 
  filter(yr_built>=2000) %>% 
  summarise(med_lazienek3=median(bathrooms))

# Odp: Mediana nie zmieni�a si� zar�wno dala wybudowanych w 2000 roku jak i po 2000 roku. W ka�dym przypadku mediana wynosi 2.5

# 5. Jak wygl�da warto�� kwartyla 0.25 oraz 0.75 jako�ci wyko�czenia nieruchomo�ci po�o�onych na p�nocy bior�c pod uwag� czy ma ona widok na wod� czy nie ma?

df1<-domy %>% 
  filter(lat >(max(lat)+min(lat))/2, waterfront==1) %>% 
  arrange(grade)
quantile(df1$grade)

df2<-domy %>% 
  filter(lat >(max(lat)+min(lat))/2, waterfront==0) %>% 
  arrange(grade)
quantile(df2$grade)

# Odp: Dla dom�w z widokiem na wod� kwartyl 0.25 wynosi 8, a kwartyl 0.75 wynosi 10,
#natomiast dla dom�W bez widoku na wod� kwartyl 0.25 wynosi 7, a kwartyl 0.75 wynosi 8

# 6. Pod kt�rym kodem pocztowy jest po�o�onych najwi�cej nieruchomo�ci i jaki jest rozst�p miedzykwartylowy dla ceny nieruchomo�ci po�o�onych pod tym adresem?

nie_pokazuj_sie_w_konsoli<-domy %>% 
  group_by(zipcode) %>% 
  summarise(kod=n()) %>%
  arrange(-kod)

kody<-domy %>% 
  filter(zipcode==98103)
rozstep<-quantile(kody$price)[4]-quantile(kody$price)[2]

# Odp: Najpopularniejszym kodem pocztowym jest 98103, a rozst�p miedzykwartylowy dla ceny nieruchomo�ci po�o�onych pod tym adresem jest r�wny 262875

# 7. Ile procent nieruchomo�ci ma wy�sz� �redni� powierzchni� 15 najbli�szych s�siad�w wzgl�dem swojej powierzchni?

zmienna<-domy %>% 
  filter(sqft_lot15>sqft_lot)  
Odp7<-(nrow(zmienna)/nrow(domy))*100
  
# Odp: 39.51326 procent nieruchomo�ci ma wy�sz� �redni� powierzchni� 15 najbli�szych s�siad�w wzgl�dem swojej powierzchni.

# 8. Jak� liczb� pokoi maj� nieruchomo�ci, kt�rych cena jest wi�ksza ni� trzeci kwartyl oraz mia�y remont w ostatnich 10 latach (pamietaj�c �e nie wiemy kiedy by�y zbierane dane) oraz zosta�y zbudowane po 1970?

domy %>% 
  filter(price>quantile(domy$price)[4],yr_renovated>=2012,yr_built>1970) %>% 
  summarise(liczba=mean(bedrooms))

# Odp: Nieruchomo�ci, kt�rych cena jest wi�ksza ni� trzeci kwartyl, mia�y remont w ostatnich 10 latach oraz zosta�y zbudowane po 1970 maj� �rednio 3.6 pokoi.

# 9. Patrz�c na definicj� warto�ci odstaj�cych wed�ug Tukeya (wykres boxplot) wska� ile jest warto�ci odstaj�cych wzgl�dem powierzchni nieruchomo�ci(dolna i g�rna granica warto�ci odstajacej).

IQR<-(quantile(domy$sqft_lot)[4] - quantile(domy$sqft_lot)[2])
domy %>% 
  filter(sqft_lot>(quantile(domy$sqft_lot)[2]-(3*IQR)),sqft_lot<(quantile(domy$sqft_lot)[2]-(1.5*IQR))) 
  
domy %>% 
  filter(sqft_lot<(quantile(domy$sqft_lot)[4]+(3*IQR)),sqft_lot>(quantile(domy$sqft_lot)[4]+(1.5*IQR))) %>% 
  nrow()

# Odp: Obserwacji odstaj�cych dolnych jest 0, a obserwacji odstaj�cych g�rncyh jest 654

# 10. W�r�d nieruchomo�ci wska� jaka jest najwi�ksz� cena za metr kwadratowy bior�c pod uwag� tylko powierzchni� mieszkaln�.

domy %>% 
  mutate(cena_za_metr=price/sqft_living) %>% 
  summarise(cena_za_metr_max=max(cena_za_metr)) 

# Odp: Uwzgl�dniaj�c tylko powierzchni� mieszkaln�, najwi�ksza cena za metr kwadratowy wynosi 810.1389 .
