phv_pred <-
    function(
        testset
        ,model
        ,dir=''
        ,output_name='pred.csv'
    ){
        print('testset is test_*')
        testset %>%
            ungroup %>%
            # unless
            # Error in mutate_impl(.data, dots) : Column `predicition` must be length 11808 (the group size) or one, not 46571
            select(id) %>%
            mutate(
                predicition =
                    # 我也是醉了，prediction
                    testset %>%
                    select(-id,-t) %>%
                    as.matrix %>%
                    predict(model,.) %>%
                    `-`(100)
                # length()
                # 46571
                # round(.,1)
            ) %>%
            write_excel_csv(
                file.path(
                    'data'
                    ,paste(today() %>% str_remove_all('-') %>% str_sub(3,-1),'jiaxiang_prediction_xgboostbaseline_tweedie.csv',sep='_')
                )
            )
    }
