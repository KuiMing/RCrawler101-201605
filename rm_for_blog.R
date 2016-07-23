library(httr)
library(XML)
library(magrittr)
rm_for_blog <- function(file){
  res <- GET(paste0('file:///Users/benjamin/',file))
  resStr <- content(res,type='text',encoding = 'utf8')
  resStr <- sub('<div class=\"fluid-row\" id=\"header\">\n\n\n\n\n</div>','',resStr)
  
  resStr <- sub('<style type = \"text/css\">\n.main-container \\{\n  max-width: 940px;\n  margin-left: auto;\n  margin-right: auto;\n\\}\ncode \\{\n  color: inherit;\n  background-color: rgba\\(0, 0, 0, 0.04\\);\n\\}\nimg \\{\n  max-width:100%;\n  height: auto;\n\\}\n.tabbed-pane \\{\n  padding-top: 12px;\n\\}\nbutton.code-folding-btn:focus \\{\n  outline: none;\n\\}\n</style>',
                '',resStr)
  
  resStr <- sub(
    '\\$\\(document\\).ready\\(function \\(\\) \\{\n  window.buildTabsets\\(\"TOC\"\\);\n\\}\\);',
    '',resStr)
  write(resStr,file=file)
}

mv_for_blog <- function(file){
  file=sub('.html','',file)
  # create file folder by time
  repo <- format(Sys.time(),"%Y-%m-%d_%H-%M-%S")
  command <- paste("mkdir ",repo)
  system(command)
  # move file folder of Rmarkdown output
  command <- paste0("mv -f ",file,'_files/ ',
                    repo, '/',file,'_files/')
  system(command)
  # move Rmd and html files
  command <- paste0("mv ", file,'* ', repo)
  system(command)
}

rm_mv <- function(file){
  rm_for_blog(file)
  mv_for_blog(file)
}

rm_mv('quantmod的問題.html')
