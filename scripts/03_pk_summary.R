library(tidyverse)

adpc <- read_csv("data/adpc.csv", show_col_types = FALSE)

pk_summary <- adpc %>%
  group_by(TRT01A, ATPTN, ATPT) %>%
  summarise(
    N = n(),
    MEAN = round(mean(AVAL, na.rm = TRUE), 3),
    SD = round(sd(AVAL, na.rm = TRUE), 3),
    MEDIAN = round(median(AVAL, na.rm = TRUE), 3),
    MIN = round(min(AVAL, na.rm = TRUE), 3),
    MAX = round(max(AVAL, na.rm = TRUE), 3),
    .groups = "drop"
  )

dir.create("output", showWarnings = FALSE)

write_csv(pk_summary, "output/pk_summary.csv")

print(pk_summary)

cat("pk_summary.csv created successfully\n")
