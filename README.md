# usa-traffic-deaths
This was a short MySQL and Tableau project showing traffic deaths. Data was obtained from the CDC Wonder online database.

Data is ordered by cause of death, in combination with additional information such as age group and day of the week. 

At first I had combined all this information in one request, but this led to inaccuracies due to suppression of small data (<10 deaths)
For example, there are only 15 people under "Pedestrian injured in collision with two- or three-wheeled motor vehicle, traffic accident" in a certain age group. 
If those 15 would then be further divided over the days of the week that the deaths happened, they will all probably fall below the threshold of 10 and get suppressed.

![Dashboard 1](https://github.com/djboek42/usa-traffic-deaths/assets/78880986/127dc943-34bf-4717-a790-0607fcc6e197)
