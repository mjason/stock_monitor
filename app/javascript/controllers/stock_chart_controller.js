// app/javascript/controllers/stock_chart_controller.js
import { Controller } from "@hotwired/stimulus"
import {createChart, CrosshairMode, CandlestickSeries, LineSeries, HistogramSeries} from 'lightweight-charts'

export default class extends Controller {
  static targets = [
    "chartContainer", "stockData",
    "candlestickBtn", "lineBtn",
    "currentDate", "latestPrice", "openPrice",
    "highPrice", "lowPrice", "volume", "changePercent"
  ]

  connect() {
    this.initializeChart()
  }

  disconnect() {
    if (this.chart) {
      this.chart.remove()
    }
  }

  initializeChart() {
    // 获取数据
    let data
    try {
      data = JSON.parse(this.stockDataTarget.dataset.stockData)
    } catch (e) {
      console.error("无法解析股票数据:", e)
    }

    // 创建图表
    this.chart = createChart(this.chartContainerTarget, {
      layout: {
        background: { color: '#ffffff' },
        textColor: '#333',
      },
      grid: {
        vertLines: { color: '#f0f3fa' },
        horzLines: { color: '#f0f3fa' },
      },
      crosshair: {
        mode: CrosshairMode.Normal,
      },
      rightPriceScale: {
        borderColor: '#dfdfdf',
      },
      timeScale: {
        borderColor: '#dfdfdf',
        timeVisible: true,
        secondsVisible: false,
      },
      handleScroll: {
        vertTouchDrag: false,
      },
    })

    // 解析数据
    const formattedData = data.map(item => ({
      time: this.parseTimeToBarTime(item.time),
      open: item.open,
      high: item.high,
      low: item.low,
      close: item.close,
      volume: item.volume
    }))

    console.log(formattedData)

    // 成交量数据
    const volumeData = data.map(item => ({
      time: this.parseTimeToBarTime(item.time),
      value: item.volume,
      color: item.close >= item.open ? 'rgba(16, 185, 129, 0.5)' : 'rgba(239, 68, 68, 0.5)'
    }))

    // 创建蜡烛图系列
    this.candlestickSeries = this.chart.addSeries(CandlestickSeries, {
      upColor: '#10b981', // Tailwind green-500
      downColor: '#ef4444', // Tailwind red-500
      borderVisible: false,
      wickUpColor: '#10b981',
      wickDownColor: '#ef4444',
    })
    this.candlestickSeries.setData(formattedData)

    // 创建线图系列
    this.lineSeries = this.chart.addSeries(LineSeries, {
      color: '#3b82f6', // Tailwind blue-500
      lineWidth: 2,
      visible: false,
    })
    this.lineSeries.setData(formattedData.map(item => ({
      time: item.time,
      value: item.close
    })))

    // 添加成交量图表
    this.volumeSeries = this.chart.addSeries(HistogramSeries,{
      color: '#10b981', // Tailwind green-500
      priceFormat: {
        type: 'volume',
      },
      priceScaleId: 'volume',
      scaleMargins: {
        top: 0.8,
        bottom: 0,
      },
    })
    this.volumeSeries.setData(volumeData)

    // 初始化更新价格信息
    this.updatePriceInfo(data[data.length - 1])

    // 设置交叉线事件
    this.setupCrosshairEvents(data)
  }

  // 显示蜡烛图
  showCandlestick() {
    this.candlestickSeries.applyOptions({ visible: true })
    this.lineSeries.applyOptions({ visible: false })

    this.candlestickBtnTarget.classList.remove('btn-neutral')
    this.candlestickBtnTarget.classList.add('btn-primary')

    this.lineBtnTarget.classList.remove('btn-primary')
    this.lineBtnTarget.classList.add('btn-neutral')
  }

  // 显示线图
  showLine() {
    this.candlestickSeries.applyOptions({ visible: false })
    this.lineSeries.applyOptions({ visible: true })

    this.lineBtnTarget.classList.remove('btn-neutral')
    this.lineBtnTarget.classList.add('btn-primary')

    this.candlestickBtnTarget.classList.remove('btn-primary')
    this.candlestickBtnTarget.classList.add('btn-neutral')
  }

  // 更新价格信息
  updatePriceInfo(dataItem) {
    if (!dataItem) return

    this.currentDateTarget.textContent = this.formatDateForDisplay(dataItem.time)

    this.latestPriceTarget.textContent = dataItem.close.toFixed(2)
    this.latestPriceTarget.className = dataItem.close >= dataItem.open
        ? 'text-base font-semibold text-green-500'
        : 'text-base font-semibold text-red-500'

    this.openPriceTarget.textContent = dataItem.open.toFixed(2)
    this.highPriceTarget.textContent = dataItem.high.toFixed(2)
    this.lowPriceTarget.textContent = dataItem.low.toFixed(2)

    this.volumeTarget.textContent = dataItem.volume.toLocaleString()

    const changePercent = ((dataItem.close - dataItem.open) / dataItem.open * 100).toFixed(2)
    this.changePercentTarget.textContent = changePercent + '%'
    this.changePercentTarget.className = changePercent >= 0
        ? 'text-base font-semibold text-green-500'
        : 'text-base font-semibold text-red-500'
  }

  // 设置交叉线事件
  setupCrosshairEvents(data) {
    this.chart.subscribeCrosshairMove((param) => {
      if (param.time) {
        const dataPoint = this.findDataPoint(param.time, data)
        if (dataPoint) {
          this.updatePriceInfo(dataPoint)
        }
      } else {
        // 如果鼠标移出图表，显示最后一个数据点的信息
        this.updatePriceInfo(data[data.length - 1])
      }
    })
  }

  // 解析ISO日期为图表格式
  parseTimeToBarTime(isoTime) {
    const date = new Date(isoTime)
    return {
      day: date.getUTCDate(),
      month: date.getUTCMonth() + 1, // 月份从0开始，所以需要+1
      year: date.getUTCFullYear()
    }
  }

  // 格式化日期显示
  formatDateForDisplay(isoTime) {
    const date = new Date(isoTime)
    return date.toLocaleDateString('zh-CN', {
      year: 'numeric',
      month: '2-digit',
      day: '2-digit',
      weekday: 'short'
    })
  }

  // 获取数据点
  findDataPoint(time, data) {
    // 将图表时间格式转换回日期字符串以进行匹配
    const searchDate = `${time.year}-${String(time.month).padStart(2, '0')}-${String(time.day).padStart(2, '0')}`
    return data.find(d => d.time.startsWith(searchDate))
  }
}