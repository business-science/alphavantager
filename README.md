
<!-- README.md is generated from README.Rmd. Please edit that file -->
alphavantager
=============

[![Travis-CI Build Status](https://travis-ci.org/business-science/alphavantager.svg?branch=master)](https://travis-ci.org/business-science/alphavantager.svg?branch=master) [![codecov](https://codecov.io/gh/business-science/alphavantager/branch/master/graph/badge.svg)](https://codecov.io/gh/business-science/alphavantager) [![CRAN\_Status\_Badge](http://www.r-pkg.org/badges/version/alphavantager)](https://cran.r-project.org/package=alphavantager) ![](http://cranlogs.r-pkg.org/badges/alphavantager?color=brightgreen) ![](http://cranlogs.r-pkg.org/badges/grand-total/alphavantager?color=brightgreen)

<!-- <img src="tools/logo.png" width="147" height="170" align="right" /> -->
> A lightweight R interface to the Alpha Vantage API

Alpha Vantage
-------------

Alpha Vantage is a **free service** that enables users to get **real-time and historical financial data**. New users will need to visit [Alpha Vantage](https://www.alphavantage.co/) and obtain an API key.

R Interface: Getting Started
----------------------------

The `alphavantager` package provides a convenient and lightweight interface to the Alpha Vantage API.

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

Set your API key (get one from [Alpha Vantage](https://www.alphavantage.co/) if you don't already have one... it's free).

``` r
av_api_key("YOUR_API_KEY")
print(av_api_key())
#> [1] "YOUR_API_KEY"
```

Getting Financial Data from Alpha Vantage
-----------------------------------------

Now, you're ready to get financial data via `av_get()`, which accepts the same<sup>1</sup> arguments as the [API Documentation](https://www.alphavantage.co/documentation/) parameters. The function is setup with two primary arguments, `symbol` and `av_fun`, which accepts an equity and one of the API "function" parameters. You can pass additional API parameters via the `...`.

``` r
# Function is streamlined and user adds additional parameters via ... 
args(av_get)
#> function (symbol = NULL, av_fun, ...) 
#> NULL
```

Here are a few examples of retrieving **real-time and historical financial data**!

#### Time Series Data

``` r
av_get(symbol = "MSFT", av_fun = "TIME_SERIES_INTRADAY", interval = "15min")
```

#### Technical Indicators

``` r
av_get(symbol = "MSFT", av_fun = "AROON", interval = "monthly", time_period = 60)
```

#### Sector Performances

``` r
av_get(av_fun = "SECTOR")
```

#### Important Notes: av\_get()

1.  The `av_fun` argument replaces the API parameter "function" because function is a reserved name in R. All other arguments match the Alpha Vantage API parameters.

2.  There is no need to specify the `apikey` parameter as an argument to `av_get()`. The required method is to set the API key using `av_api_key("YOUR_API_KEY")`.

3.  There is no need to specify the `datatype` parameter as an argument to `av_get()`. The function will return a tibble data frame.

4.  Some data sets only return 100 rows by default. Change the parameter `outputsize = "full"` to get the full dataset.
