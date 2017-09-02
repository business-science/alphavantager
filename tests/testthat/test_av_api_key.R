library(alphavantager)
context("Testing av_api_key()")

test_that("av_api_key sets api key into options", {

    key <- av_api_key() # Save key

    av_api_key("YOUR_API_KEY")

    expect_equal("YOUR_API_KEY", av_api_key())

    av_api_key(key) # Reset key

})


