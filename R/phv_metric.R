phv_metric <- function(id,t,y,yhat){
    tmp <-
        tibble(
            id = id
            ,t = t
            ,y = y
            ,yhat = yhat
        ) %>%
        mutate(
            c = case_when(
                id == 1 ~ 10
                ,id == 2 ~ 10
                ,id == 3 ~ 40
                ,id == 4 ~ 50
            )
            # 装机功率
        )
    mae_m <-
        tmp %>%
        filter(y >= c*0.03) %>%
        # 实际功率值大于等于Ci*0.03
        mutate(yr = year(t), m = month(t), d = day(t)) %>%
        group_by(id,yr,m,d) %>%
        summarise(
            n = n()
            ,abs_err = sum(abs(y-yhat)/c)
            ,mae_d = abs_err/n
        ) %>%
        ungroup() %>%
        group_by(id,yr,m) %>%
        summarise(mae_m = mean(mae_d)) %>%
        # 每月的绝对平均偏差的平均值计算方法
        ungroup() %>%
        group_by(id) %>%
        summarise(mae_m = mean(mae_m)) %>%
        # 计算单个电场月MAE的平均值
        ungroup() %>%
        summarise(mae_m = mean(mae_m))
    mae_m %>% pull()
}
