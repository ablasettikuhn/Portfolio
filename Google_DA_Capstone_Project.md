  

This project follows the 6 data analysis phases from Google Data
Analytics Certification: Ask, Prepare, Process, Analyze, Share and Act.

  

# Ask Phase

<hr style="border: 1px solid black;">

## Introduction

The coach of the team wants to understand the effect of some time and
location conditionals on the shot conversion from 2015 to 2023.

Specifically, He wants to understand what’s the relationship between the
time/location of the shot and the shot conversion from 2015 to 2023.

## Problem

what’s the relationship between minutes left, seconds left, distance
shot and the shot conversion (efficiency rate) throughout the years?
They decided to ask an external exercise science professional with Data
analyst experience.

## Business Task

Business task: identify if minutes left, seconds left and distance shot
are related to the shot conversion (efficiency rate) throughout the
years 2015-2023.

## Hypothesis

Hypothesis: IF the minutes left, seconds left and distance shot\* have
an effect on shot conversion, THEN there is a relationship between these
conditionals and the efficiency rate. This is the alternative hypothesis
(H1), while the null hypothesis (H0) states that there is no
relationship between the variables. \*these conditionals in the main
hypothesis will be evaluated as H1, H2 and H3.

  

# Prepare Phase

<hr style="border: 1px solid black;">

## Data Sources

The data is provided directly from <https://www.nba.com/stats>. It is
public and accessible in the R package “ISAR”, data in
nba\_nuggets\_shots.

The data set contains seven seasons of Denver Nuggets shot data from
2015 to 2023. It follows the ROCCC premises (the data is from a reliable
organization, original, comprehensive, current, and cited)

Source: <http://asbcllc.com/nbastatR/reference/teams_shots.html> Credits
and owner: nba\_nuggets\_shots, ISAR package, NBA.

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ dplyr     1.1.3     ✔ readr     2.1.4
    ## ✔ forcats   1.0.0     ✔ stringr   1.5.0
    ## ✔ ggplot2   3.4.3     ✔ tibble    3.2.1
    ## ✔ lubridate 1.9.3     ✔ tidyr     1.3.0
    ## ✔ purrr     1.0.2     
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()
    ## ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors

## Variables and objects

Lets have a `glimpse(nba_nuggets_shots)` of the dataset. Other options
are `str()` and `View()`

The data set has 62,196 rows and 27 columns. It follows the ROCCC
premises and is tidy, organized in long format. We are interested in the
following variables: `yearSeason`, `minutesRemaining`,
`secondsRemaining`, `distanceShot`, `isShotAttempted` and `isShotMade`.
We are going to calculate the Efficiency Rate as
`isShotMade/isShotAttempted` and store the result as the variable
`EffRate` without adding it to the original database.

    EffRate <- nba_nuggets_shots$isShotMade/nba_nuggets_shots$isShotAttempted

The main coach and the data analyst agreed that the selected variables
are appropriate for exploring the desired relationship, if there is any.

  

# Process Phase

<hr style="border: 1px solid black;">

## Data integrity and cleaning

Now we are going to check the NA’s values on the database. We are only
using 5 variables so we will select them.

    na_check <- nba_nuggets_shots %>% select(yearSeason, minutesRemaining, secondsRemaining, distanceShot, isShotAttempted, isShotMade) %>% is.na() %>% any()

    ifelse(na_check==TRUE, "There are NA values in the selected columns.", "There are no NA values in the selected columns.")

    ## [1] "There are no NA values in the selected columns."

Before starting any analysis, let’s explore the objects inside the
variables we want to consider. We can use the `unique()` function on
each variable or the `distinct()` function and the %&gt;%

    nba_nuggets_shots %>% distinct(yearSeason)

    ## # A tibble: 9 × 1
    ##   yearSeason
    ##        <dbl>
    ## 1       2015
    ## 2       2016
    ## 3       2017
    ## 4       2018
    ## 5       2019
    ## 6       2020
    ## 7       2021
    ## 8       2022
    ## 9       2023

    unique(nba_nuggets_shots$yearSeason)

    ## [1] 2015 2016 2017 2018 2019 2020 2021 2022 2023

    unique(nba_nuggets_shots$minutesRemaining)

    ##  [1] 11 10  9  8  7  5  4  3  2  1  0  6 12

    unique(nba_nuggets_shots$secondsRemaining)

    ##  [1] 25 23 55 31 51 57 10 42 19 56  1 26 35  0 49 41  4 52 17  7 53  9 37 24 20
    ## [26] 50 14 30  6 27 45 21 15 13 38 46  8 47 16 36 34 48 12 32  2 39 22 43 40 58
    ## [51] 29 28 33  5 59 18 44 54 11  3

    unique(nba_nuggets_shots$distanceShot)

    ##  [1] 24  0  2 13 19  1  3 17 16  7 25 18 20 23 21 26  5 12 15  4 14 22  9  6 11
    ## [26]  8 29 53 27 10 40 48 28 56 33 44 30 62 36 32 47 54 55 50 79 43 46 84 39 31
    ## [51] 64 51 42 34 35 52 57 70 74 67 69 72 45 37 66 38 58 59 65 77 49 78 61 75 82
    ## [76] 63 68 41 83 60 81 80

    unique(nba_nuggets_shots$isShotAttempted)

    ## [1] TRUE

    unique(nba_nuggets_shots$isShotMade)

    ## [1] FALSE  TRUE

To pull out a brief summary of the variables we want to analyze,
`summary()` or `skim()` functions are both good options. With the skim
function we have a visual idea of the data distribution. The
Visualizations were also examined with hist() function.

    nba_nuggets_shots %>% select(yearSeason, minutesRemaining, secondsRemaining, distanceShot, isShotAttempted, isShotMade) %>% skim()

<table>
<caption>Data summary</caption>
<tbody>
<tr class="odd">
<td style="text-align: left;">Name</td>
<td style="text-align: left;">Piped data</td>
</tr>
<tr class="even">
<td style="text-align: left;">Number of rows</td>
<td style="text-align: left;">62196</td>
</tr>
<tr class="odd">
<td style="text-align: left;">Number of columns</td>
<td style="text-align: left;">6</td>
</tr>
<tr class="even">
<td style="text-align: left;">_______________________</td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;">Column type frequency:</td>
<td style="text-align: left;"></td>
</tr>
<tr class="even">
<td style="text-align: left;">logical</td>
<td style="text-align: left;">2</td>
</tr>
<tr class="odd">
<td style="text-align: left;">numeric</td>
<td style="text-align: left;">4</td>
</tr>
<tr class="even">
<td style="text-align: left;">________________________</td>
<td style="text-align: left;"></td>
</tr>
<tr class="odd">
<td style="text-align: left;">Group variables</td>
<td style="text-align: left;">None</td>
</tr>
</tbody>
</table>

Data summary

**Variable type: logical**

<table style="width:100%;">
<colgroup>
<col style="width: 23%" />
<col style="width: 14%" />
<col style="width: 20%" />
<col style="width: 7%" />
<col style="width: 33%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">skim_variable</th>
<th style="text-align: right;">n_missing</th>
<th style="text-align: right;">complete_rate</th>
<th style="text-align: right;">mean</th>
<th style="text-align: left;">count</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">isShotAttempted</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">1.00</td>
<td style="text-align: left;">TRU: 62196</td>
</tr>
<tr class="even">
<td style="text-align: left;">isShotMade</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">0.47</td>
<td style="text-align: left;">FAL: 33009, TRU: 29187</td>
</tr>
</tbody>
</table>

**Variable type: numeric**

<table>
<colgroup>
<col style="width: 19%" />
<col style="width: 11%" />
<col style="width: 16%" />
<col style="width: 9%" />
<col style="width: 6%" />
<col style="width: 5%" />
<col style="width: 5%" />
<col style="width: 5%" />
<col style="width: 5%" />
<col style="width: 5%" />
<col style="width: 6%" />
</colgroup>
<thead>
<tr class="header">
<th style="text-align: left;">skim_variable</th>
<th style="text-align: right;">n_missing</th>
<th style="text-align: right;">complete_rate</th>
<th style="text-align: right;">mean</th>
<th style="text-align: right;">sd</th>
<th style="text-align: right;">p0</th>
<th style="text-align: right;">p25</th>
<th style="text-align: right;">p50</th>
<th style="text-align: right;">p75</th>
<th style="text-align: right;">p100</th>
<th style="text-align: left;">hist</th>
</tr>
</thead>
<tbody>
<tr class="odd">
<td style="text-align: left;">yearSeason</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">2018.94</td>
<td style="text-align: right;">2.60</td>
<td style="text-align: right;">2015</td>
<td style="text-align: right;">2017</td>
<td style="text-align: right;">2019</td>
<td style="text-align: right;">2021</td>
<td style="text-align: right;">2023</td>
<td style="text-align: left;">▇▇▅▇▇</td>
</tr>
<tr class="even">
<td style="text-align: left;">minutesRemaining</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">5.34</td>
<td style="text-align: right;">3.46</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">2</td>
<td style="text-align: right;">5</td>
<td style="text-align: right;">8</td>
<td style="text-align: right;">12</td>
<td style="text-align: left;">▇▅▇▅▅</td>
</tr>
<tr class="odd">
<td style="text-align: left;">secondsRemaining</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">28.78</td>
<td style="text-align: right;">17.46</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">14</td>
<td style="text-align: right;">29</td>
<td style="text-align: right;">44</td>
<td style="text-align: right;">59</td>
<td style="text-align: left;">▇▇▇▇▇</td>
</tr>
<tr class="even">
<td style="text-align: left;">distanceShot</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">1</td>
<td style="text-align: right;">12.76</td>
<td style="text-align: right;">10.47</td>
<td style="text-align: right;">0</td>
<td style="text-align: right;">2</td>
<td style="text-align: right;">12</td>
<td style="text-align: right;">24</td>
<td style="text-align: right;">84</td>
<td style="text-align: left;">▇▆▁▁▁</td>
</tr>
</tbody>
</table>

*After reviewing and testing the data, we can conclude the data is tidy,
organized in long format and there are no NA’s. The EDA-Exploratory data
analysis shows that the data does not follow a normal distribution.*

  

# Analyze Phase

<hr style="border: 1px solid black;">

## Hypothesis testing: Spearman’s Rank Correlation Analysis

Considering that the data is NOT normally distributed, H1, H2 and H3 are
tested with the Spearman’s Rank Correlation Coefficient.

**H1: IF the minutes left have an effect on shot conversion, THEN there
is a relationship between minutes remaining and the efficiency rate. H0:
There is no relationship between the variables.**

We are going to perform the correlation test between minutes remaining
and efficiency rate and store the results as H1:

    H1 <- cor.test(nba_nuggets_shots$minutesRemaining, EffRate, method = "spearman")

    ## Warning in cor.test.default(nba_nuggets_shots$minutesRemaining, EffRate, :
    ## Cannot compute exact p-value with ties

    H1

    ## 
    ##  Spearman's rank correlation rho
    ## 
    ## data:  nba_nuggets_shots$minutesRemaining and EffRate
    ## S = 3.9314e+13, p-value = 1.03e-06
    ## alternative hypothesis: true rho is not equal to 0
    ## sample estimates:
    ##        rho 
    ## 0.01958973

**Conclusion H1/H0**

Based on the Spearman’s rank correlation analysis, there is a
statistically significant correlation between the variables
`minutesRemaining` and `EffRate` (rho = 0.0196, p &lt; 0.001). The
positive correlation coefficient (rho) suggests a weak positive
monotonic relationship between the remaining minutes in a basketball
game and the efficiency rate. (warning: correlation does not mean
causation).

The large test statistic S provides strong evidence against the null
hypothesis H0 (S = 3.9314e+13). This means that the observed correlation
is unlikely to be due to random chance. We reject H0 and accept H1.

*In practice, the analysis suggests that the greater the number of
remaining minutes in a basketball game, there is a tendency for the
efficiency rate to also increase, although the relationship is weak.
This information can be valuable for basketball teams and coaches in
understanding the dynamics of the game and making strategic decisions
based on the remaining time and efficiency rate.*

  

**H2: IF the seconds left have an effect on shot conversion, THEN there
is a relationship between seconds remaining and the efficiency rate. H0:
There is no relationship between the variables.**

We are going to perform the correlation test between seconds remaining
and efficiency rate and store the results as H2:

    H2 <- cor.test(nba_nuggets_shots$secondsRemaining, EffRate, method = "spearman")

    ## Warning in cor.test.default(nba_nuggets_shots$secondsRemaining, EffRate, :
    ## Cannot compute exact p-value with ties

    H2

    ## 
    ##  Spearman's rank correlation rho
    ## 
    ## data:  nba_nuggets_shots$secondsRemaining and EffRate
    ## S = 3.9396e+13, p-value = 1.21e-05
    ## alternative hypothesis: true rho is not equal to 0
    ## sample estimates:
    ##        rho 
    ## 0.01754498

**Conclusion H2/H0**

Based on the Spearman’s rank correlation analysis, there is a
statistically significant correlation between the variables
`secondsRemaining` and `EffRate` (rho = 0.0175, p &lt; 0.001). The
positive correlation coefficient (rho) suggests a weak positive
monotonic relationship between the remaining seconds in a basketball
game and the efficiency rate. (warning: correlation does not mean
causation).

The large test statistic S provides strong evidence against the null
hypothesis H0 (S = 3.9396e+13). This means that the observed correlation
is unlikely to be due to random chance. We reject H0 and accept H2.

*In practice, the analysis suggests that the greater the number of
remaining seconds in a basketball game, there is a tendency for the
efficiency rate to also increase, although the relationship is weak.
This information can be valuable for basketball teams and coaches in
understanding the dynamics of the game and making strategic decisions
based on the remaining time and efficiency rate.*

  

**H3: IF the distance shot has an effect on shot conversion, THEN there
is a relationship between the distance shot and the efficiency rate. H0:
There is no relationship between the variables.**

We are going to perform the correlation test between distance shot and
efficiency rate and store the results as H3:

    H3 <- cor.test(nba_nuggets_shots$distanceShot, EffRate, method = "spearman")

    ## Warning in cor.test.default(nba_nuggets_shots$distanceShot, EffRate, method =
    ## "spearman"): Cannot compute exact p-value with ties

    H3

    ## 
    ##  Spearman's rank correlation rho
    ## 
    ## data:  nba_nuggets_shots$distanceShot and EffRate
    ## S = 4.989e+13, p-value < 2.2e-16
    ## alternative hypothesis: true rho is not equal to 0
    ## sample estimates:
    ##       rho 
    ## -0.244173

**Conclusion H3/H0**

Based on the Spearman’s rank correlation analysis, there is a
statistically significant correlation between the variables
`distanceShot` and `EffRate` (rho = -0.2441, p &lt; 0.001). The positive
correlation coefficient (rho) suggests a weak negative monotonic
relationship between the distance shot in a basketball game and the
efficiency rate. (warning: correlation does not mean causation).

The large test statistic S provides strong evidence against the null
hypothesis H0 (S = 4.989e+13). This means that the observed correlation
is unlikely to be due to random chance. We reject H0 and accept H3.

*In practice, the analysis suggests that the shorter the distance shot
in a basketball game, there is a tendency for the efficiency rate to
increase, although the relationship is weak.*

> Note: Considering the main hypothesis and the correlation coefficient
> obtained in minutes remaining, seconds remaining and distance shot, we
> can conclude that although all variables are related to the Efficiency
> Rate, the distance shot has a higher correlation on the efficiency
> rate than the other two time conditionals. In the share phase, we will
> focus the visualizations in distance shots as it’s an important
> variable that the main coach can control and train.

> This information can be valuable for basketball teams and coaches in
> understanding the dynamics of the game and making strategic decisions
> based on the remaining time/location variables of the shot and the
> efficiency rate.

## Just for curiosity

The data analyst decided to test Pearson’s Correlation Coefficient
despite the data is not normally distributed just for curiosity.This
decision to test Pearson’s Correlation Coefficient despite the not
normal distribution, yielded surprising outcomes. This highlights the
importance of exploring relationships between variables even in
non-ideal conditions and being open to unexpected findings.

    ## 
    ##  Pearson's product-moment correlation
    ## 
    ## data:  nba_nuggets_shots$distanceShot and EffRate
    ## t = -57.091, df = 62194, p-value < 2.2e-16
    ## alternative hypothesis: true correlation is not equal to 0
    ## 95 percent confidence interval:
    ##  -0.2306056 -0.2156702
    ## sample estimates:
    ##       cor 
    ## -0.223151

    ## 
    ##  Pearson's product-moment correlation
    ## 
    ## data:  nba_nuggets_shots$minutesRemaining and EffRate
    ## t = 4.805, df = 62194, p-value = 1.551e-06
    ## alternative hypothesis: true correlation is not equal to 0
    ## 95 percent confidence interval:
    ##  0.01140654 0.02711874
    ## sample estimates:
    ##        cor 
    ## 0.01926383

    ## 
    ##  Pearson's product-moment correlation
    ## 
    ## data:  nba_nuggets_shots$secondsRemaining and EffRate
    ## t = 4.3207, df = 62194, p-value = 1.557e-05
    ## alternative hypothesis: true correlation is not equal to 0
    ## 95 percent confidence interval:
    ##  0.009465111 0.025178435
    ## sample estimates:
    ##        cor 
    ## 0.01732284

The p-value obtained from the 3 tests are less than the significance
level of 0.001, providing strong evidence against the null hypothesis
H0. Therefore, there is a statistically significant relationship between
the variables. Although the Pearson’s correlation coefficients are small
in magnitude, they are still statistically significant. This means that
even though the relationship between the variables is weak, it is
unlikely to have occurred by chance.

The surprise: The Pearson’s correlation coefficient obtained for H1, H2
and H3 are similar in magnitude and value to the estimated Spearman’s
correlation coefficients. This indicates a weak positive relationship
between Efficiency rate and minutes and seconds left, and a weak
negative relationship between Efficiency Rate and distance shot.

  

# Share Phase

<hr style="border: 1px solid black;">

## Visualizations

## Boxplot: Distribution of Distance Shot by Efficiency Rate

    ggplot(nba_nuggets_shots, aes(x = distanceShot, y = isShotMade, fill = isShotMade)) + geom_boxplot() + stat_summary(fun = mean, geom = "point", shape = 23, size = 2.5, fill = "black", position = position_dodge(width = 0.75)) + scale_fill_manual(values = c("tomato", "palegreen")) + labs(x = "Distance Shot", y = "Is Shot Made", fill = "Is Shot Made?") + ggtitle("Distribution of Distance Shot by Efficiency Rate")

![](Google_DA_Capstone_Project_files/figure-markdown_strict/unnamed-chunk-11-1.png)

> The boxplot above shows the distribution of shot distances based on
> the efficiency rate. The boxes represent the interquartile range (0.25
> to 0.75 percent of the observations), filled in green for shots made
> and red for shots missed. The vertical line inside the box represents
> the median (0.50 of the observations). The black diamond represents
> the mean. The mean for shots missed is below the median and the mean
> for shots converted is above the median. The means are relatively
> similar, but the median for shots missed is higher than the median for
> shots converted, indicating that shots converted tend to be in shorter
> distances, while shots missed tend to be in longer distances. The
> black points represent outliers, with more shots missed in long
> distances and a few shots converted in long distances.

  

## Barplot: Distribution of Minutes Left by Efficiency Rate

    ggplot(nba_nuggets_shots, aes(x = minutesRemaining, fill = isShotMade)) + geom_bar(stat = "count") + scale_fill_manual(values = c("tomato", "palegreen")) + labs(x = "Minutes Remaining", y = "Count", fill = "Is Shot Made?") + ggtitle("Distribution of Minutes Left by Efficiency Rate")

![](Google_DA_Capstone_Project_files/figure-markdown_strict/unnamed-chunk-12-1.png)

> The barplot above shows the distribution of minutes remaining based on
> the efficiency rate. The bars represent the count of shots converted
> in green and shots missed in red, based on the minutes left. The first
> tall bar shows a higher number of shots missed when there is 1 minute
> left. The last two bars show a smaller number of shots missed when
> there are 11 minutes left, and no shots when the game quarter starts
> (12 minutes left).

  

## Barplot: Distribution of Seconds Left by Efficiency Rate

    ggplot(nba_nuggets_shots, aes(x = secondsRemaining, fill = isShotMade)) + geom_bar(stat = "count") + scale_fill_manual(values = c("tomato", "palegreen")) + labs(x = "Seconds Remaining", y = "Count", fill = "Is Shot Made?") + ggtitle("Distribution of Seconds Left by Efficiency Rate")

![](Google_DA_Capstone_Project_files/figure-markdown_strict/unnamed-chunk-13-1.png)

> The barplot above shows the distribution of seconds remaining based on
> the efficiency rate. The bars represent the count of shots converted
> in green and shots missed in red, based on the seconds left. The first
> tall bar shows a higher number of shots missed when there are between
> 1 and 1.5 seconds left. Also, the shots made are higher when there are
> between 1 and 1.5 seconds left. The last bar shows there are no shots
> when the game countdown clock starts (60 seconds left).

  

## Dashboard: boxplot of distance shot and efficiency rate by year

    ggplot(nba_nuggets_shots, aes(x = distanceShot, y = isShotMade, fill = isShotMade)) + geom_boxplot() + stat_summary(fun = mean, geom = "point", shape = 23, size = 2, fill = "black", position = position_dodge(width = 0.75)) + scale_fill_manual(values = c("tomato", "palegreen")) + labs(x = "Distance Shot", y = "Is Shot Made", fill = "Is Shot Made?") + ggtitle("Distribution of Distance Shot by Efficiency Rate") + facet_wrap(~yearSeason, ncol=3)

![](Google_DA_Capstone_Project_files/figure-markdown_strict/unnamed-chunk-14-1.png)

The main coach wants to see the changes throughout the years, however,
the visualization above is not easy to understand. It can be simplified
with an Interactive Dashboard by year. The link below shows the
distribution of distance shot and efficiency rate from 2015 to 2023.

> [**CLICK HERE**](https://ablasettikuhn.shinyapps.io/dashboard-app/) to
> access the Interactive Dashboard created with Shiny and hosted on
> Shinyapps.io.

<!--First we need to define the UI:

`
library(shiny)
ui <- fluidPage(
titlePanel("Interactive Dashboard"),
sidebarLayout(
sidebarPanel(
sliderInput("year", "Select Year", min = min(nba_nuggets_shots$yearSeason),
max = max(nba_nuggets_shots$yearSeason), value = min(nba_nuggets_shots$yearSeason),
step = 1)
),
mainPanel(
plotOutput("plot")
)
)
)
`

Second we need to define the server logic and third run the shinyApp: `shinyApp(ui, server)`. By defining `output: html_document`, `runtime: shiny` in the YAML, the dashboard is displayed in the html document (only visualizations in Rstudio)

`
library(shiny)
server <- function(input, output) {
  output$plot <- renderPlot({
    filtered_data <- nba_nuggets_shots[nba_nuggets_shots$yearSeason == input$year, ]
    ggplot(filtered_data, aes(x = distanceShot, y = isShotMade, fill = isShotMade)) +
      geom_boxplot() + stat_summary(fun = mean, geom = "point", shape = 23, size = 2, fill = "black", position = position_dodge(width = 0.75)) +
      scale_fill_manual(values = c("tomato", "palegreen")) +
      labs(x = "Distance Shot", y = "Is Shot Made", fill = "Is Shot Made?") +
      ggtitle("Distribution of Distance Shot by Efficiency Rate") +
      facet_wrap(~yearSeason, ncol = 3)
  })
}
shinyApp(ui, server)
`

> The slidebar selects the desired year throughout the years 2015 to 2023. We can now see the distribution of distance shot and efficiency rate for each year. To understand the dashboard by year, recall that 1) The boxes represent the interquartile range (0.25 to 0.75 percent of the observations), filled in green for shots made and red for shots missed. 2) The vertical line inside the box represents the median (0.50 of the observations). The black diamond represents the mean. 3) The black points represent outliers, with more shots missed in long distances and a few shots converted in long distances.-->

  

# Act Phase

<hr style="border: 1px solid black;">

## Summary

-   The business task was performed and analyzed based on the problem
    that the main coach wanted to understand. The relation between
    minutes left, seconds left, distance shot and Efficiency Rate was
    successful measured and analyzed.

-   The main hypothesis was confirmed, there is a relationship between
    minutes left, seconds left, distance shot and the efficiency rate.
    Although all variables are related to the Efficiency Rate, the
    distance shot has a higher correlation with the efficiency rate than
    the other two time conditionals.

-   This information can be valuable for all NBA basketball teams and
    coaches as it can lead to further research. In this particular case
    study the time/location variables of the shot were analyzed and
    related to the efficiency rate.

-   Understanding the constraints of the game is a powerful
    decision-making strategy. Shots effectuated from a smaller distance
    to the hoop tend to be more effective, this applies to all years. If
    the coach wants to control the more unexpected conditionals during
    the game, shorter distance shots with fewer seconds left in the
    countdown clock is a good strategy. The relationship between minutes
    remaining is more stable throughout the game, that’s why no matter
    in which quarter of the game, the strategy of shooting close to the
    rim and close to zero in the countdown clock is a way to clear out
    unexpected conditionals. Human beings work under pressure, the
    positioning of opposing players in a short distance to the hoop plus
    the countdown clock could play a role in the efficiency rate. In
    this study we focus on controllable time/location conditionals, we
    do not know what effect an opposing player might have had on these
    results.

-   The period of time taken was from 2015 to 2023 but the purpose of
    the coach was not to analyze the years separately. This can be
    performed as part of a new business task if the main focus changes
    to differences between the 2015 to 2023 seasons.

-   In the share phase, the visualizations were focused on distance
    shots as it’s an important variable that the main coach can control
    and train. Dashboards for minutes and seconds remaining can be
    included as part of a redefinition of the business task.
