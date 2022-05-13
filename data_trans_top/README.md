# 路由代码克隆注意事项

路由代码从GitHub或者bitbucket上克隆下来时，在还原工程中，可直接进行生成bit行为，但在进行到implementation时会出现严重警告，解决方式为点击警告中提到的文件aurora_64b66b_0_gt.xdc，对如下的约束进行注释，再重新运行即可解决。

set_property LOC GTHE3_CHANNEL_X1Y0 [get_cells -hierarchical -filter {NAME =~ *gen_channel_container[24].*gen_gthe3_channel_inst[0].GTHE3_CHANNEL_PRIM_INST}]



### 补充

在进行代码搬移时，尤其是IP核的搬移，只搬移xci文件，但需要把**不同的xci**文件分开到**单独的文件夹中**存放，否则在运行综合时候会将IP核锁上，IP核的综合文件会出现在工程名.gen文件夹内

