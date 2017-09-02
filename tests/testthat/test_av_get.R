context("av_get() API interface")

# Time Series -----
test_that("call TIMES_SERIES_INTRADAY", {

    skip_if_no_auth()

    # Time Series Intraday
    symbol   <- "MSFT"
    av_fun   <- "TIME_SERIES_INTRADAY"
    interval <- "15min"

    resp <- av_get(symbol, av_fun, interval = interval)

    expect_s3_class(resp, "tbl")
    expect_equal(nrow(resp), 100)

    # Time Series Daily Adjusted
    symbol   <- "MSFT"
    av_fun   <- "TIME_SERIES_DAILY_ADJUSTED"

    resp <- av_get(symbol, av_fun)

    expect_s3_class(resp, "tbl")
    expect_equal(nrow(resp), 100)

})


# Sector Performance -----
test_that("call SECTOR", {

    skip_if_no_auth()

    symbol   <- NULL
    av_fun   <- "SECTOR"

    resp <- av_get(symbol, av_fun)

    expect_s3_class(resp, "tbl")
    expect_gt(nrow(resp), 50)

})

# Technical Indicators -----
test_that("call Technical Indicators", {

    skip_if_no_auth()

    # SMA
    symbol       <- "MSFT"
    av_fun       <- "SMA"
    interval     <- "monthly"
    time_period  <- 60
    series_type  <- "close"

    resp <- av_get(symbol, av_fun, interval = interval, time_period = time_period, series_type = series_type)

    expect_s3_class(resp, "tbl")
    expect_gt(nrow(resp), 50)

    # RSI
    symbol       <- "MSFT"
    av_fun       <- "RSI"
    interval     <- "monthly"
    time_period  <- 60
    series_type  <- "close"

    resp <- av_get(symbol, av_fun, interval = interval, time_period = time_period, series_type = series_type)

    expect_s3_class(resp, "tbl")
    expect_gt(nrow(resp), 50)

})

# Bad Calls ------

test_that("call results in error", {

    skip_if_no_auth()

    symbol   <- NULL
    av_fun   <- "TIME_SERIES_DAILY"

    expect_error(av_get(symbol, av_fun))

})


