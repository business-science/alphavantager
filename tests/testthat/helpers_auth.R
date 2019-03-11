# Auth helpers

# Developer:
# Call `usethis::edit_r_environ()`
# Add a line: `AV_API_KEY_TEST=<my-key>`
# Save and restart R

maybe_key <- Sys.getenv("AV_API_KEY_TEST", unset = NA_character_)

skip_if_no_auth <- function() {
    if (is.na(maybe_key)) {
        skip("Authentication not available")
    }
}

if (!is.na(maybe_key)) {
    av_api_key(maybe_key)
}

# only 5 api calls per minute allowed
delay_15_seconds <- function() {
    Sys.sleep(15)
}

