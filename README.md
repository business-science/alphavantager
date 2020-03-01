
<!-- README.md is generated from README.Rmd. Please edit that file -->

# alphavantager

<https://travis-ci.org/business-science/alphavantager.svg?branch=master>
[![codecov](https://codecov.io/gh/business-science/alphavantager/branch/master/graph/badge.svg)](https://codecov.io/gh/business-science/alphavantager)
[![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/alphavantager)](https://cran.r-project.org/package=alphavantager)
![](http://cranlogs.r-pkg.org/badges/alphavantager?color=brightgreen)
![](http://cranlogs.r-pkg.org/badges/grand-total/alphavantager?color=brightgreen)

<!-- <img src="tools/logo.png" width="147" height="170" align="right" /> -->

> A lightweight R interface to the Alpha Vantage API

## Alpha Vantage

Alpha Vantage is a **free service** that enables users to get
**real-time and historical financial data**. New users will need to
visit [Alpha Vantage](https://www.alphavantage.co/) and obtain an API
key.

## R Interface: Getting Started

The `alphavantager` package provides a convenient and lightweight
interface to the Alpha Vantage API.

To get started, install the package from CRAN or from GitHub:

``` r
install.packages("alphavantager")
# Or
devtools::install_github("business-science/alphavantager")
```

Load the package.

``` r
library(alphavantager)
```

Set your API key (get one from [Alpha
Vantage](https://www.alphavantage.co/) if you don’t already have one…
it’s free).

``` r
av_api_key("YOUR_API_KEY")
print(av_api_key())
#> [1] "YOUR_API_KEY"
```

## Getting Financial Data from Alpha Vantage

Now, you’re ready to get financial data via `av_get()`, which accepts
the same<sup>1</sup> arguments as the [API
Documentation](https://www.alphavantage.co/documentation/) parameters.
The function is setup with two primary arguments, `symbol` and `av_fun`,
which accepts an equity and one of the API “function” parameters. You
can pass additional API parameters via the `...`.

``` r
# Function is streamlined and user adds additional parameters via ... 
args(av_get)
#> function (symbol, av_fun, ...) 
#> NULL
```

Here are a few examples of retrieving **real-time and historical
financial
data**\!

#### Time Series Data

``` r
av_get(symbol = "MSFT", av_fun = "TIME_SERIES_INTRADAY", interval = "15min")
#> # A tibble: 100 x 6
#>    timestamp            open  high   low close  volume
#>    <dttm>              <dbl> <dbl> <dbl> <dbl>   <dbl>
#>  1 2020-02-25 10:45:00  172.  173.  171.  173. 1947367
#>  2 2020-02-25 11:00:00  173.  173.  171.  171. 1648589
#>  3 2020-02-25 11:15:00  171.  172.  170.  171. 1912259
#>  4 2020-02-25 11:30:00  171.  171.  170.  171. 2144892
#>  5 2020-02-25 11:45:00  171.  171.  171.  171. 1496695
#>  6 2020-02-25 12:00:00  171.  173.  171.  172. 1445612
#>  7 2020-02-25 12:15:00  172.  173.  172.  172. 1224751
#>  8 2020-02-25 12:30:00  172.  172.  171.  172. 1449176
#>  9 2020-02-25 12:45:00  172.  172.  171.  171. 1065737
#> 10 2020-02-25 13:00:00  171.  172.  171.  171.  997559
#> # … with 90 more rows
```

#### ForEx

``` r
# REAL-TIME QUOTE
av_get("EUR/USD", av_fun = "CURRENCY_EXCHANGE_RATE")
#> # A tibble: 1 x 9
#>   from_currency_c… from_currency_n… to_currency_code to_currency_name
#>   <chr>            <chr>            <chr>            <chr>           
#> 1 EUR              Euro             USD              United States D…
#> # … with 5 more variables: exchange_rate <dbl>, last_refreshed <dttm>,
#> #   time_zone <chr>, bid_price <dbl>, ask_price <dbl>
```

``` r
# TIME SERIES
av_get("EUR/USD", av_fun = "FX_DAILY")
#> # A tibble: 100 x 5
#>    timestamp   open  high   low close
#>    <date>     <dbl> <dbl> <dbl> <dbl>
#>  1 2019-11-06  1.11  1.11  1.11  1.11
#>  2 2019-11-07  1.11  1.11  1.10  1.10
#>  3 2019-11-08  1.10  1.11  1.10  1.10
#>  4 2019-11-10  1.10  1.10  1.10  1.10
#>  5 2019-11-11  1.10  1.10  1.10  1.10
#>  6 2019-11-12  1.10  1.10  1.10  1.10
#>  7 2019-11-13  1.10  1.10  1.10  1.10
#>  8 2019-11-14  1.10  1.10  1.10  1.10
#>  9 2019-11-15  1.10  1.11  1.10  1.11
#> 10 2019-11-17  1.11  1.11  1.10  1.11
#> # … with 90 more rows
```

#### Technical Indicators

``` r
av_get(symbol = "MSFT", av_fun = "AROON", interval = "monthly", time_period = 60)
#> # A tibble: 180 x 3
#>    time       aroon_down aroon_up
#>    <date>          <dbl>    <dbl>
#>  1 2020-02-28       10      100  
#>  2 2020-01-31       11.7    100  
#>  3 2019-12-31       13.3    100  
#>  4 2019-11-29       15      100  
#>  5 2019-10-31       16.7    100  
#>  6 2019-09-30       18.3    100  
#>  7 2019-08-30       20       98.3
#>  8 2019-07-31       21.7    100  
#>  9 2019-06-28       23.3    100  
#> 10 2019-05-31        0       98.3
#> # … with 170 more rows
```

#### Sector Performances

``` r
av_get(av_fun = "SECTOR")
#> # A tibble: 110 x 3
#>    rank_group                             sector  change
#>    <chr>                                  <chr>    <dbl>
#>  1 Rank A: Real-Time Performance          Energy  0.0125
#>  2 Rank B: 1 Day Performance              Energy  0.0125
#>  3 Rank C: 5 Day Performance              Energy -0.154 
#>  4 Rank D: 1 Month Performance            Energy -0.178 
#>  5 Rank E: 3 Month Performance            Energy -0.212 
#>  6 Rank F: Year-to-Date (YTD) Performance Energy -0.247 
#>  7 Rank G: 1 Year Performance             Energy -0.291 
#>  8 Rank H: 3 Year Performance             Energy -0.341 
#>  9 Rank I: 5 Year Performance             Energy -0.405 
#> 10 Rank J: 10 Year Performance            Energy -0.179 
#> # … with 100 more rows
```

#### Important Notes: av\_get()

1.  The `av_fun` argument replaces the API parameter “function” because
    function is a reserved name in R. All other arguments match the
    Alpha Vantage API parameters.

2.  There is no need to specify the `apikey` parameter as an argument to
    `av_get()`. The required method is to set the API key using
    `av_api_key("YOUR_API_KEY")`.

3.  There is no need to specify the `datatype` parameter as an argument
    to `av_get()`. The function will return a tibble data frame.

4.  Some data sets only return 100 rows by default. Change the parameter
    `outputsize = "full"` to get the full dataset.
