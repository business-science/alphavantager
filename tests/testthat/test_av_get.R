context("av_get() API interface")

# Time Series -----
test_that("call TIMES_SERIES_INTRADAY", {

    skip_if_no_auth()
    skip_on_cran()

    # Time Series Intraday
    symbol   <- "MSFT"
    av_fun   <- "TIME_SERIES_INTRADAY"
    interval <- "15min"

    delay_15_seconds()
    resp <- av_get(symbol, av_fun, interval = interval)

    expect_s3_class(resp, "tbl")
    expect_equal(nrow(resp), 100)

    # Time Series Daily Adjusted
    symbol   <- "MSFT"
    av_fun   <- "TIME_SERIES_DAILY_ADJUSTED"

    delay_15_seconds()
    resp <- av_get(symbol, av_fun)

    expect_s3_class(resp, "tbl")
    expect_equal(nrow(resp), 100)

})


# Sector Performance -----
test_that("call SECTOR", {

    skip_if_no_auth()
    skip_on_cran()

    symbol   <- NULL
    av_fun   <- "SECTOR"

    delay_15_seconds()
    resp <- av_get(symbol, av_fun)

    expect_s3_class(resp, "tbl")
    expect_gt(nrow(resp), 50)

})

# Technical Indicators -----
test_that("call Technical Indicators", {

    skip_if_no_auth()
    skip_on_cran()

    # SMA
    symbol       <- "MSFT"
    av_fun       <- "SMA"
    interval     <- "monthly"
    time_period  <- 60
    series_type  <- "close"

    delay_15_seconds()
    resp <- av_get(symbol, av_fun, interval = interval, time_period = time_period, series_type = series_type)

    expect_s3_class(resp, "tbl")
    expect_gt(nrow(resp), 50)

    # RSI
    symbol       <- "MSFT"
    av_fun       <- "RSI"
    interval     <- "monthly"
    time_period  <- 60
    series_type  <- "close"

    delay_15_seconds()
    resp <- av_get(symbol, av_fun, interval = interval, time_period = time_period, series_type = series_type)

    expect_s3_class(resp, "tbl")
    expect_gt(nrow(resp), 50)

})

# Bad Calls ------

test_that("call results in error", {

    skip_if_no_auth()
    skip_on_cran()
    delay_15_seconds()

    symbol   <- NULL
    av_fun   <- "TIME_SERIES_DAILY"

    delay_15_seconds()
    expect_error(av_get(symbol, av_fun))

})

test_that("call with no API key is stopped", {

    skip_if_no_auth()
    skip_on_cran()

    key <- av_api_key()

    options(av_api_key = NULL)

    symbol   <- "MSFT"
    av_fun   <- "TIME_SERIES_DAILY"

    delay_15_seconds()
    expect_error(av_get(symbol, av_fun))

    av_api_key(key)

})
