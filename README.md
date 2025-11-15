# ingress UPC&UPV map

A simple Ruby tool that parses Ingress **game_log.tsv** and generates UPC / UPV datasets for mapping and visualization.

数据来自于你向privacy@nianticspatial.com写信要求获取你的personal data, 度过不知道多少天之后他们会回信一个Google Drive文件，下载解压. 

下面是写信模板，记得替换ID和邮箱

```text

Dear Niantic Privacy Team,

Please provide me with a copy of all personal data that Niantic Spatial holds about me.

Here are my details for verification:

Agent ID: {YOUR_AGENT_ID}

Email Address associated with the account:{YOUR_EMAIL_ADDRESS}

Please let me know if you require any additional information to verify my identity or process this request.

Thank you for your time and assistance.

Kind regards,

（Your name here if needed）

```

---

## How to use

1. 将 `upc.rb` 与 **game_log.tsv** 放在同一个目录下
   （⚠️ 注意：**portal_history.tsv 不支持**，其中包含奇怪或不完整记录，会导致分类错误。）
2. 运行：
   
   ```bash
   ruby upc.rb
   ```
3. 执行完成后，会生成以下文件：
   文件名	用途
   
| 文件名|用途|
| ---------------------------- | ---------------------------------------------------------------------- |
| **draw\_out.txt**    | 可导入 IITC Draw Tools。⚠️ 大量数据会导致浏览器卡死，慎用。        |
| **upc\_map\_\*.csv** | 所有 Unique Portal Capture（UPC）坐标，自动切片（每片 ≤ 2000 行）。 |
| **upv\_map\_0.csv**  | 所有 Unique Portal Visit（UPV）坐标。                                |
   
   

---

## Mapping Options

✔ 推荐：使用 Mapbox Studio（非常方便）

导入 Google My Maps 十分麻烦：每次最多上传 2000 行，还需要手动分图层。
相比之下，Mapbox Studio 可以一次性导入所有 CSV，体验更好。

这是我实际使用的 Mapbox 地图示例：

👉 https://api.mapbox.com/styles/v1/tolves/cmi0au74o002701sb2yfo9tgm.html?title=view&access_token=pk.eyJ1IjoidG9sdmVzIiwiYSI6ImNtaTBhZnBpaTBjYmQyaXNmbm90eTlvenYifQ.0IaPI_1QiHNGEhz0kim42A&zoomwheel=true&fresh=true#2/38/-34

在 Mapbox Studio 中：

1. 新建 Dataset
2. 直接拖入 upv_map_0.csv 或多个 upc_map_*.csv
3. 应用样式并发布即可

对比Google MyMap优点：

1. 支持一次导入大量数据
2. 标记渲染性能比 IITC / MyMaps 都强
3. 可以自定义颜色、样式、过滤器
4. 可在线分享地图（不需要登录 Google）

---

## What the script does

- 读取 game_log.tsv
- 根据动作类型识别：
 - UPC = captured portal
 - UPV = hack / deploy / upgrade / link / mod 等非 capture 互动
- 自动根据坐标去重（每个 portal 只保留一次）
- 输出 CSV（便于 GIS 和地图工具）
- 生成 IITC Draw Tools JSON

---

## Notes

* ​**不要使用 portal\_history.tsv**​，其中包含无效或损坏记录，会导致分类错误。
* `draw_out.txt` 导入 IITC 时，大量数据（>20k）会导致页面卡死或崩溃。

