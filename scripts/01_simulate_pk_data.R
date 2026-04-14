library(tidyverse)

set.seed(123)

subjects <- sprintf("SUBJ%03d", 1:40)
treatment <- rep(c("Dose 100 mg", "Dose 200 mg"), each = 20)
time_points <- c(0, 0.5, 1, 2, 4, 8, 12, 24)

pk_data <- expand.grid(
  USUBJID = subjects,
  ATPTN = time_points
) %>%
  as_tibble() %>%
  arrange(USUBJID, ATPTN) %>%
  mutate(
    TRT01A = rep(treatment, each = length(time_points)),
    SEX = sample(c("M", "F"), n(), replace = TRUE),
    AGE = sample(30:75, n(), replace = TRUE)
  )

subject_params <- tibble(
  USUBJID = subjects,
  KA = runif(length(subjects), 0.8, 1.5),
  KE = runif(length(subjects), 0.08, 0.18),
  V = runif(length(subjects), 20, 35),
  DOSE = ifelse(1:length(subjects) <= 20, 100, 200)
)

pk_data <- pk_data %>%
  left_join(subject_params, by = "USUBJID") %>%
  mutate(
    CONC = ifelse(
      ATPTN == 0,
      0,
      (DOSE / V) * (KA / (KA - KE)) * (exp(-KE * ATPTN) - exp(-KA * ATPTN))
    ),
    CONC = pmax(CONC + rnorm(n(), 0, 0.15), 0),
    AVISIT = paste0("Hour ", ATPTN)
  )

dir.create("data", showWarnings = FALSE)

write_csv(pk_data, "data/raw_pk.csv")

cat("raw_pk.csv created successfully\n")
