phv_log_xgb <- function(x,start_time,end_time,output='xgboost_result_baseline_tweedie.csv'){
    # lose start_time or end_time
    # results
    # Error in .Call(`_dplyr_mutate_impl`, df, dots) :
    #     promise already under evaluation: recursive default argument reference or earlier problems?
    xgb_parms <- x$params %>%
        as.data.frame()
    sys_name <-
        Sys.info() %>%
        t() %>%
        as.data.frame() %>%
        select(sysname)
    bind_cols(
        xgb_parms,sys_name
    ) %>%
        mutate(
            start_time = start_time
            ,end_time = end_time
        ) %>%
        write_excel_csv(
            file.path(
                'data'
                ,paste(now() %>% str_remove_all('-|\\s|:'),'xgboost_result_baseline_tweedie.csv',sep='_')
            )
        )
}
