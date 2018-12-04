get_value <- function(medal_type, group) {
  df <- count_medal(events, medal_type)
  #df[is.na(df)] <- 0
  val <- df[which(df$Team == group),]$medal
  if (length(val) == 0) {
    val <- 0
  }
  return (val)
}

name_medal <- function(medal_type) {
  if (medal_type == "All") {
    medal_type <- "overall"
  } else {
    medal_type <- tolower(medal_type)
  }
  return (medal_type)
}