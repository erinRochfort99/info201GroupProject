# Info 201 Final Project
## Olympics Data

### Project Link:
[Final Project](https://erika-s.shinyapps.io/olympics_group_app/)

### Overview

The dataset we worked with is "120 Years of Olympic History: athletes and results: Basic biodata on athletes and medal results from Athens 1896 to Rio 2016" from kaggle. The link is: [Olympics Data Link](https://www.kaggle.com/heesoo37/120-years-of-olympic-history-athletes-and-results#athlete_events.csv). This dataset puts the Olympic games into a historical context by providing data from such a large amount of time on the Olympians themselves such as age, gender, name, event, weight, medals, and ID, along with information about the games like year, season, and host city.

The target audience for this data and therefore our project is basically everyone. Because the Olympics is now such a global event, anyone who knows of or follows the Olympic games may be interested in viewing Olympic trends over time and seeing what these results reveal.

### Questions

1. What years did each group/nation start coming to the Olympics?
2. What are the medal counts per group/nation?
3. Is there a relationship between the size of an Olympic team and their overall medal count?
4. What is the ratio of Olympic medals between males and females by Olympic games and nation/group?

### Technical Description

* Format of final product: Shiny app
* Data: static .csv file from kaggle
* Type of data-wrangling: We used the dplyr library to edit the data to answer the above questions
* Library usage: plotly, shiny, vistime, mapdata, data.table, and countrycode

### Authors

* Jenny Li
* Erin Rochfort
* Erika Sundstrom
* Jocelyn Afandi