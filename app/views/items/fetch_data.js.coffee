$('.month').text("<%= @month %>")
$('.total_amount .incomes').text("<%= @total_incomes %>")
$('.total_amount .expense').text("<%= @total_expense %>")
label = "<%= safe_join @label, ',' %>"
record = "<%= safe_join @record, ',' %>"
ctx = $("#myChart")
new Chart(ctx,{
  type: 'pie',
  data: {
    labels: label.split(','),
    datasets: [
        {
            data: record.split(','),
            backgroundColor: ["#f17578", "#f7ba77", "#e8dd23", "#6795d2", "#76c3a1", "#64d1d4"]
        }]
  },
  options: {
    legend: {
      position: 'bottom'
    }
    tooltips: {
      intersect: false,
      displayColors: false
    }
  }
})
