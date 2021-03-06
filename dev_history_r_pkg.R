
# setup -------------------------------------------------------------------

library(devtools)
use_git()

# https://github.com/JiaxiangBU/add2impala/blob/master/DESCRIPTION
file.edit("DESCRIPTION")
library(devtools)

use_build_ignore("dev_history.R")
use_roxygen_md()
use_pipe()
library(magrittr)

options(usethis.full_name = "Jiaxiang Li")
use_mit_license()


# rm packrat --------------------------------------------------------------

# rm -rf packrat


# desc --------------------------------------------------------------------

add2pkg::add_me(is_paste = TRUE)
file.edit("DESCRIPTION")

# coding ------------------------------------------------------------------

file.edit("R/lift_chart.R")
devtools::load_all()
# cum_gains_chart(add2evaluation::df)
cum_lift_chart(add2evaluation::df)
# add title

use_r("add_logo")
library(fs)
file_move("R/add_logo.R", "../add2ggplot/R/")
file.edit("DESCRIPTION")

library(devtools)
use_r("groom_model")
use_vignette("use_groom_model")

# prettify ----------------------------------------------------------------

use_readme_rmd()
# help translate XGBoost model R object into SQL statement.
file.edit("DESCRIPTION")
rmarkdown::render("README.Rmd")
file.remove("README.html")


# func --------------------------------------------------------------------

file.edit("R/lift_chart.R")

# commit

# add disclaimer ----------------------------------------------------------

file.edit("DESCRIPTION")
clipr::write_clip('`r add2pkg::add_disclaimer("Jiaxiang Li")`')
file.edit("README.Rmd")
rmarkdown::render("README.Rmd")
rstudioapi::viewer("README.html")
file.remove("README.html")
usethis::use_code_of_conduct()


# publish -----------------------------------------------------------------

# open it and link it.
# https://zenodo.org/account/settings/github/
# push
# make public
use_news_md()
use_version()
file.edit("NEWS.md")
use_github_release()
rmarkdown::render("README.Rmd")
rstudioapi::viewer("README.html")
safely(file.remove)("README.html")
# 因为会更新 citations，但是要等一会。
# publish release


# add badge and citation --------------------------------------------------

# login zenodo and copy badge in markdown
clipr::write_clip('## Citations

```{r include=FALSE}
citations <- add2pkg::add_zenodo_citation("README.Rmd")
```

```{r echo=FALSE, results=\'asis\'}
cat(citations$Cite)
```

```{r echo=FALSE, results=\'asis\'}
cat(paste0("```BibTex\\n",citations$BibTex,"\\n```"))
```

```{r echo=FALSE, results=\'asis\'}
cat(citations$Comments)
```')
file.edit("README.Rmd")
# 需要等一段时间，有时候 doi 没有显示出来
rmarkdown::render("README.Rmd")
rstudioapi::viewer("README.html")
safely(file.remove)("README.html")


# add vignette ------------------------------------------------------------

use_vignette("lift_chart")

# build -------------------------------------------------------------------

library(devtools)
document()
load_all()
install()


# pkgdown -----------------------------------------------------------------

start_time <- lubridate::now()
pkgdown::build_site()
end_time <- lubridate::now()
end_time - start_time
