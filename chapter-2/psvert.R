
library(ggplot2)
library(xts)

# 加载economics数据集
data("economics")

# 查看数据集结构
str(economics)

# 选择个人储蓄率和失业人数作为变量
data <- economics[, c("psavert", "unemploy")]

# 构建一元回归模型，以失业人数作为自变量，个人储蓄率作为因变量
model <- lm(psavert ~ unemploy, data = data)

# 查看模型摘要
summary(model)

# 可选：绘制散点图和回归线
library(ggplot2)
ggplot(data, aes(x = unemploy, y = psavert)) +
  geom_point() +
  geom_smooth(method = "lm", col = "blue")
 

# 加载economics数据集
data("economics")

# 构建多元回归模型
model <- lm(psavert ~ pce + pop + uempmed + unemploy, data = economics)

# 查看模型摘要
summary(model)

# 可选：绘制模型的诊断图，检查模型假设
par(mfrow=c(2,2))
plot(model)




# install.packages(c("lmtest", "car"))
library(lmtest)
library(car)

# 加载economics数据集
data("economics")

# 构建多元回归模型
model <- lm(psavert ~ pce + pop + uempmed + unemploy, data = economics)

# 查看模型摘要
summary(model)
 
# 多重共线性检验
# 方差膨胀因子
vif(model)  # VIF值大于5或10通常被认为表明有严重的多重共线性

# 使用glmnet进行岭回归：
library(glmnet)

# 准备数据
x <- model.matrix(psavert ~ pce + pop + uempmed + unemploy, data=economics)[,-1]
y <- economics$psavert

# 岭回归模型
ridge_model <- glmnet(x, y, alpha=0)



# 异方差性检验
# 布雷施-帕甘检验
bptest(model)

# 或非常数方差检验
ncvTest(model)

# 自相关检验
# 达宾-沃森检验
dwtest(model)
