# devtools::install_github("craddm/eegUtils")
# install.packages('mgcv')

library(itsadug)
library(mgcv)
library(eegUtils)
library(dplyr)
library(ggplot2)

folder_name <- '..\\EYE_DATA\\LEX_DEC'

sub_name <- 'ld_01'


hfhl <- import_set(paste(folder_name , '\\', sub_name, '\\', sub_name, '_hfhl_ld.set', sep=''))
lfhl <- import_set(paste(folder_name, '\\', sub_name, '\\', sub_name, '_lfhl_ld.set', sep=''))
lfll <- import_set(paste(folder_name, '\\', sub_name, '\\', sub_name, '_lfll_ld.set', sep=''))
hfll <- import_set(paste(folder_name, '\\', sub_name, '\\', sub_name, '_hfll_ld.set', sep=''))

hfhl_df <- hfhl %>% select_elecs(c("Fz","Cz", "Pz")) %>%
  select_times(c(-.1, .7)) %>%
#  rm_baseline(c(-.1, 0)) %>%
  as.data.frame(long = TRUE) %>%
  mutate(Freq = 'H', Lsa = 'H')

lfhl_df <- lfhl %>% select_elecs(c("Fz","Cz", "Pz")) %>%
  select_times(c(-.1, .7)) %>%
#  rm_baseline(c(-.1, 0)) %>%
  as.data.frame(long = TRUE) %>%
  mutate(Freq = 'L', Lsa = 'H', epoch = epoch + max(hfhl_df$epoch))

lfll_df <- lfll %>% select_elecs(c("Fz","Cz", "Pz")) %>%
  select_times(c(-.1, .7)) %>%
#  rm_baseline(c(-.1, 0)) %>%
  as.data.frame(long = TRUE) %>%
  mutate(Freq = 'L', Lsa = 'L', epoch = epoch + max(lfhl_df$epoch))

hfll_df <- hfll %>% select_elecs(c("Fz","Cz", "Pz")) %>%
  select_times(c(-.1, .7)) %>%
#  rm_baseline(c(-.1, 0)) %>%
  as.data.frame(long = TRUE) %>%
  mutate(Freq = 'H', Lsa = 'L', epoch = epoch + max(lfll_df$epoch))

subject_df = bind_rows(hfhl_df, lfhl_df, lfll_df, hfll_df)

subject_df %>% write.csv('saved_01.csv')

subject_df <- read.csv('saved_01.csv')

subject_df %>%
  group_by(Freq, time) %>% 
  ggplot(aes(x = time, y = amplitude)) +
  geom_line(aes(group = epoch), alpha = 0.2) + 
  stat_summary(fun.y = mean,
               geom = "line",
               size = 2,
               aes(colour = Freq)) + 
  geom_vline(xintercept = 0) +
  geom_hline(yintercept = 0) +
  facet_wrap(~electrode) + 
  theme_classic()

subject_df %>%
  group_by(Lsa, time) %>% 
  ggplot(aes(x = time, y = amplitude)) +
  geom_line(aes(group = epoch), alpha = 0.2) + 
  stat_summary(fun.y = mean,
               geom = "line",
               size = 2,
               aes(colour = Lsa)) + 
  geom_vline(xintercept = 0) +
  geom_hline(yintercept = 0) +
  facet_wrap(~electrode) + 
  theme_classic()

m1 <- gam(amplitude ~  s(time, by = Lsa) + 
            s(epoch, bs='re') + s(electrode, bs='re'), data=subject_df)

summary(m1)

plot_smooth(m1, view = 'time', plot_all = c('Lsa'), rm.ranef = TRUE)

plot_diff(m1, view = 'time', comp = list(Lsa=c("H", "L")),
          eegAxis=TRUE, shade=FALSE, rm.ranef = TRUE)

m2 <- gam(amplitude ~ s(time, by = Freq) + 
            + s(epoch, bs='re') + s(electrode, bs='re') , data=subject_df)

summary(m2)

            
plot_smooth(m2, view = 'time', plot_all = c('Freq'))

plot_diff(m2, view = 'time', comp = list(Freq=c("H", "L")),
          eegAxis=TRUE, shade=FALSE)

          