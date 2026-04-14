library(tidyverse)

raw_pk <- read_csv("data/raw_pk.csv", show_col_types = FALSE)

adpc <- raw_pk %>%
  mutate(
    STUDYID = "PK001",
    DOMAIN = "PC",
    PARAMCD = "CONC",
    PARAM = "Plasma Drug Concentration",
    AVAL = round(CONC, 3),
    ATPT = paste0(ATPTN, " hr"),
    ADY = 1,
    ANL01FL = "Y"
  ) %>%
  select(
    STUDYID,
    USUBJID,
    TRT01A,
    SEX,
    AGE,
    PARAMCD,
    PARAM,
    ATPTN,
    ATPT,
    AVISIT,
    ADY,
    AVAL,
    ANL01FL
  )

write_csv(adpc, "data/adpc.csv")

cat("adpc.csv created successfully\n")
