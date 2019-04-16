
library(algor)
library(tidyverse)

### Attitude scores

## Create composite scores

# IN HIGH SCHOOL (attitudes towards taking classes)
ihs_comp <- attitude_ihs_tbl %>%
  transmute(timing, ID,
            csci = comp_prog,
            math = (calc + trig)/2,
            phys,
            stem = rowMeans(select(., calc:eng), na.rm = TRUE)
  )
# AFTER HIGH SCHOOL (attitudes towards studying or working at a subject)
ahs_comp <- attitude_ahs_tbl %>%
  transmute(timing, ID,
            csci = (cs + prog)/2,
            math,
            phys,
            stem = rowMeans(select(., cs:eng), na.rm = TRUE)
  )

## Create a 'tidy' data table to facilitate grouping and graphing
#  with all scores as one long table of scores indexed by
#  focus (ihs/ahs), timing (pre/post) and subject (csci, math, phys, stem)

attitude_comp <-
  bind_rows(.id = "focus",
            ihs = ihs_comp, ahs = ahs_comp
  ) %>%
  mutate(focus =
           ordered(focus, levels = c("ihs", "ahs"),
                   labels = c("In high school", "After high school")
           )
  ) %>%
  gather(csci:stem, key = subject, value = score)

# Find descriptives statistics, Mean (M) and Standard Deviation (S)

attitude_comp_descr <- attitude_comp %>%
  select(-ID) %>%
  group_by(focus, timing, subject) %>%
  summarize_all(list(M = mean, S = sd), na.rm = TRUE)


## Create pre/post graph to be paneled by focus

# Captiontioning:
# Will be broken into lines on plot call, since ggplot does not flow text

# ... verbose captioning
cap <- "For courses in school, csci is 'computer programming', math averages 'calculus and trig', stem averages 'calculus', 'trig', 'physics', 'advanced chemistry', and 'computer programming'. For study/work after high school, csci averages 'programming' and 'computer science', stem averages 'math', 'physics', 'chem', 'programming' and 'computer science'."
tit <- "Pre/post mean attitude toward a subject"
subtit <- "Attitude score from 'absolute no' (1) to 'absolute yes' (4)"

#... null captioning
cap    <- ""
tit    <- ""
subtit <- ""

# Mean attitude paneled by focus
attitude_comp_descr %>%
  ggplot(aes(x = timing, y = M, col = subject)) +
    geom_line(size = 1.5, aes(group = subject)) +
    geom_point(size = 3) +
    # force the full range of data to be displayed. Gives context
    ylim(1, 4) +
    # make each panel narrower and with less wasted space laterlly
#    coord_fixed(ratio = 1.25, xlim = c(1.35, 1.65), clip = "off") +
    labs(title = tit,
         subtitle = subtit,
         # break long caption into 70 character lines
         caption = paste(strwrap(cap, width = 70), collapse = "\n")
    ) +
    ylab("Mean score") +
    facet_wrap(~focus) +
    theme(
      plot.caption = element_text(size = 9, hjust = 0,
                                  margin = margin(18, 0, 0, 0))
    )

ggsave("figures/attitude-mean.png", width = 6, height = 6, units = "in")

# INDIVIDUAL IN HIGH SCHOOL Attitude Paneled By Id
attitude_comp %>%
  filter(focus == "In high school") %>%
  ggplot(aes(x = timing, y = score, col = subject, group = subject)) +
  geom_line(size = 1.5) + geom_point(size = 3) +
  ylim(1, 4) +
  #    coord_fixed(ratio = 1.25, xlim = c(1.35, 1.65)) +
  labs(title = tit,
       subtitle = subtit,
       caption = paste(strwrap(cap, width = 80), collapse = "\n")
  ) +
  facet_wrap(~ID) +
  theme(
  )
ggsave("figures/attitude-indiv-ihs.png", width = 6, height = 6, units = "in")

# INDIVIDUAL AFTER HIGH SCHOOL attitudes paneled by ID
attitude_comp %>%
  filter(focus == "After high school") %>%
  ggplot(aes(x = timing, y = score, col = subject, group = subject)) +
    geom_line(size = 1.5) + geom_point(size = 3) +
    ylim(1, 4) +
#    coord_fixed(ratio = 1.25, xlim = c(1.35, 1.65)) +
    labs(title = tit,
       subtitle = subtit,
       caption = paste(strwrap(cap, width = 80), collapse = "\n")
    ) +
    facet_wrap(~ID) +
    theme(
    )
ggsave("figures/attitude-indiv-ahs.png", width = 6, height = 6, units = "in")


