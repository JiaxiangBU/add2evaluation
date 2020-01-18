#' Build the evaluation metrics for the competition phv.
#' @import dplyr
#' @import lubridate
#' @param id id.
#' @param t The time column.
#' @param y Target.
#' @param yhat Predictions.
#' @export
phv_metric <- function(id,t,y,yhat){
    tmp <-
        data.frame(
            id = id
            ,t = t
            ,y = y
            ,yhat = yhat
        ) %>%
        dplyr::mutate(
            c = dplyr::case_when(
                id == 1 ~ 10
                ,id == 2 ~ 10
                ,id == 3 ~ 40
                ,id == 4 ~ 50
            )
            # 装机功率
        )
    mae_m <-
        tmp %>%
        dplyr::filter(y >= c*0.03) %>%
        # 实际功率值大于等于Ci*0.03
        dplyr::mutate(yr = lubridate::year(t), m = lubridate::month(t), d = lubridate::day(t)) %>%
        dplyr::group_by(id,yr,m,d) %>%
        dplyr::summarise(
            n = dplyr::n()
            ,abs_err = sum(abs(y-yhat)/c)
            ,mae_d = abs_err/n
        ) %>%
        dplyr::ungroup() %>%
        dplyr::group_by(id,yr,m) %>%
        dplyr::summarise(mae_m = mean(mae_d)) %>%
        # 每月的绝对平均偏差的平均值计算方法
        dplyr::ungroup() %>%
        dplyr::group_by(id) %>%
        dplyr::summarise(mae_m = mean(mae_m)) %>%
        # 计算单个电场月MAE的平均值
        dplyr::ungroup() %>%
        dplyr::summarise(mae_m = mean(mae_m))
    mae_m %>% dplyr::pull()
}
