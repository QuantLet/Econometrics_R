# 清除环境中的所有对象
rm(list=ls()) 

# 设置工作目录
folder <- "/Users/sunjiajing/Desktop/Hong2020/advance time series analysis -20240328/R代码/advanced-time-series-chapter1"
setwd(folder)

# 读取数据
sse <- read.csv("sse.csv") 

# 确保日期列的类型为Date
sse$Date <- as.Date(sse$Date)

# 使用ggplot2画出SSE指数随时间的变化
sse_plot <- ggplot(sse, aes(x = Date, y = SSE)) +
  geom_line(color = "blue") + # 添加蓝色线条
  labs(title = "SSE Index Over Time", x = "Date", y = "SSE Index") +
  theme_minimal() + # 使用简洁主题
  theme(
    panel.grid.major = element_line(color = "grey80"), # 修改主要网格线颜色
    panel.grid.minor = element_blank(), # 移除次要网格线
    panel.background = element_rect(fill = "white"), # 修改背景为白色
    plot.background = element_rect(fill = "white", colour = NA), # 修改绘图区域背景为白色
    axis.line = element_line(color = "black") # 增加轴线
  )

# 显示图表
print(sse_plot)

# 保存图表为PNG文件
ggsave("sse_index_plot.png", plot = sse_plot, width = 10, height = 6)

# 计算对数收益率
sse$Log_Returns <- c(NA, diff(log(sse$SSE))) 
sse <- na.omit(sse) # 移除因差分产生的NA值

# 将数据分为训练集和测试集（训练集95%，测试集5%）
split_index <- floor(0.95 * nrow(sse))
train_data <- sse$Log_Returns[1:split_index]
test_data <- sse$Log_Returns[(split_index + 1):nrow(sse)]

# 加载必要的库
library(tseries)
library(forecast)
library(ggplot2)
library(dplyr)
 
# 保存残差的ACF图为PNG文件
png(file = "acf_SSE.png")
acf(train_data)
dev.off() # 关闭图形设备

# 保存残差的PACF图为PNG文件
png(file = "pacf_SSE.png")
pacf(train_data)
dev.off() # 关闭图形设备

# 创建一个新的图形窗口，分成两行一列
par(mfrow = c(1, 2))
acf(train_data) # 再次绘制以在Plots窗格中显示
pacf(train_data) # 再次绘制以在Plots窗格中显示

# 对训练数据拟合ARIMA模型
model <- auto.arima(train_data)
summary(model)

# 使用该模型对测试数据进行预测
forecasts <- forecast(model, h = length(test_data))

# 准备用于ggplot的数据
train_df <- data.frame(Date = sse$Date[1:split_index], Value = train_data, Type = "训练数据")
forecast_df <- data.frame(Date = sse$Date[(split_index + 1):nrow(sse)], Forecast = forecasts$mean, Lower = forecasts$lower[, "80%"], Upper = forecasts$upper[, "80%"], Type = "预测数据")

# 使用ggplot2进行绘图，并设置白色背景
final_plot <- ggplot() +
  geom_line(data = train_df, aes(x = Date, y = Value, group = 1), color = "black") +
  geom_line(data = forecast_df, aes(x = Date, y = Forecast, group = 1), color = "blue") +
  geom_ribbon(data = forecast_df, aes(x = Date, ymin = Lower, ymax = Upper, group = 1), fill = "blue", alpha = 0.2) +
  geom_point(data = data.frame(Date = sse$Date[(split_index + 1):nrow(sse)], Actual = test_data), aes(x = Date, y = Actual), color = "red") +
  scale_x_date(date_breaks = "3 month", date_labels = "%Y-%m") +
  labs(title = "Training, Forecast and Actual Data", x = "Date", y = "Log Returns") +
  theme_minimal() +
  theme(
    panel.background = element_rect(fill = "white", colour = "black"),
    plot.background = element_rect(fill = "white", colour = NA)
  )

# 显示图表
print(final_plot)

# 保存图表为PNG文件
ggsave("forecast_plot.png", plot = final_plot, width = 10, height = 6)
