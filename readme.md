# Cross Set Solver

Cross Set 解題工具

[Cross Set on Steam] (https://store.steampowered.com/app/415400/Cross_Set/)

[Cross Set Infinity on Steam] (https://store.steampowered.com/app/705250/Cross_Set_Infinity/)

------

輸入格式為

```
124,241,124,413,
413,231,123,312,
413,234,241,234,
124,341,412,342
```

假設數字只會用到 1,2,3...9，並且為正方形棋盤。

若會用到 10 以上，則上述的簡寫方式會造成誤解，請不要使用，改用正規陣列描述。

e.g.  [1,2,4]

目前用 sqrt 抓邊長，如果是長方形，請改為分別輸入長寬。

------

預設行為採用 策略1~4 解題。 若發生 halt 情況，會啟用 Guessing Controller 進行「猜測模擬」解題。

理論上可以處理有多重解的題目，應該吧。
