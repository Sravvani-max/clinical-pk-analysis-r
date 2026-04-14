library(tidyverse)

adpc <- read_csv("data/adpc.csv", show_col_types = FALSE)

mean_profile <- adpc %>%
  group_by(TRT01A, ATPTN) %>%
  summarise(
    MEAN_CONC = mean(AVAL, na.rm = TRUE),
    .groups = "drop"
  )

dir.create("output", showWarnings = FALSE)

# Mean PK Profile
p1 <- ggplot(mean_profile, aes(x = ATPTN, y = MEAN_CONC, linetype = TRT01A)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  labs(
    title = "Mean Concentration-Time Profile",
    x = "Time (Hours)",
    y = "Mean Concentration"
  ) +
  theme_minimal()

ggsave("output/mean_pk_profile.png", plot = p1, width = 8, height = 5)

# Subject-level plots
p2 <- ggplot(adpc, aes(x = ATPTN, y = AVAL, group = USUBJID)) +
  geom_line(alpha = 0.5) +
  facet_wrap(~TRT01A) +
  labs(
    title = "Subject-Level PK Profiles",
    x = "Time (Hours)",
    y = "Concentration"
  ) +
  theme_minimal()

ggsave("output/subject_profiles.png", plot = p2, width = 10, height = 6)

# Log scale plot
p3 <- ggplot(mean_profile %>% filter(ATPTN > 0),
             aes(x = ATPTN, y = MEAN_CONC, linetype = TRT01A)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  scale_y_log10() +
  labs(
    title = "Mean PK Profile (Log Scale)",
    x = "Time (Hours)",
    y = "Log Concentration"
  ) +
  theme_minimal()

ggsave("output/mean_pk_profile_log.png", plot = p3, width = 8, height = 5)

cat("PK plots created successfully\n")
