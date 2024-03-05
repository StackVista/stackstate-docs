---
description: StackState SaaS
---

# Health Forecast

## Overview

Install the Health Forecast StackPack to get on-demand forecasts for the health of any component over the coming 12 hours.

### How to use the Health Forecast StackPack

1. Install the Health Forecast StackPack from the StackState UI:
   * Go to StackPacks &gt; Add-ons
   * Select **Health Forecast**
   * Click **INSTALL**
2. After installation, hover over any component and go to the **Actions** tab of the popup.
3. Select the action **Health Forecast \(12h\)**.
4. A forecast report for the coming 12 hours is calculated and presented on-screen.

### How does the forecasting work?

The Health Forecast StackPack adds a health forecast action to each component. This forecast action looks at the health checks of a component that are based on metrics. A part of the history of each these metrics is retrieved and used to predict these metrics for the coming 12 hours. The prediction is then fed back into the health checks hourly. The health state of each hour of each check, as well as all the predicted metrics, are added to the forecast report.

### Can I get a forecast for more than 12 hours?

Not yet. Please report your request for longer time-frame forecasts at [support.stackstate.com](https://support.stackstate.com).
