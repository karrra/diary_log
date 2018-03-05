config = (dom, range)->
  type: 'line',
  data: {
    labels: dom.data('labels'),
    datasets: [
      {
        label: 'Expense',
        data: dom.data('expense'),
        backgroundColor: 'rgba(54, 162, 235, 0.5)' for x in [1..range]
      },
      {
        label: 'Income',
        data: dom.data('incomes'),
        backgroundColor: 'rgba(75, 192, 192, 0.5)' for x in [1..range]
      }
    ]
  },
  options: {
    scales: {
      xAxes: [{
          stacked: true
      }],
      yAxes: [{
          stacked: true
      }]
    }
  }

change_type = (new_type)->
  if daily_chart && monthly_chart
    daily_chart.destroy()
    monthly_chart.destroy()
  daily_temp = $.extend(true, {}, config($('#line_chart'), 31))
  monthly_temp = $.extend(true, {}, config($('#stacked_bar'), 12))
  daily_temp.type = new_type
  monthly_temp.type = new_type
  daily_chart = new Chart($('#line_chart'), daily_temp)
  monthly_chart = new Chart($('#stacked_bar'), monthly_temp)

$ ->
  if $('.admin_report').length > 0
    change_type('line')
    $(document).on 'click', '.type_btn button', ()->
      if $(this).attr('role') == 'line'
        change_type('line')
      else if $(this).attr('role') == 'bar'
        change_type('bar')
